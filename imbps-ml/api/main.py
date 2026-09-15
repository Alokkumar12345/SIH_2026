"""
FastAPI REST API Service for IMBPS (Integrated Maintenance & Block Planning System).
Provides endpoints for ML Duration, Risk, Priority predictions, CP-SAT Block Optimization,
Feedback Outcome Logging, and Automated Retraining / Governance.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
from datetime import datetime, date
from typing import Dict, Any, List, Optional
from fastapi import FastAPI, HTTPException, Query, status
from pydantic import BaseModel, Field

from inference.predictor import predictor
from optimization.scheduler import IMBPSBlockScheduler
from pipelines.training_pipeline import retraining_pipeline
from pipelines.deployment_pipeline import deployment_pipeline
from config.settings import REGISTRY_FILE, DATA_DIR

logger = logging.getLogger("IMBPS.API")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

app = FastAPI(
    title="IMBPS ML & Block Planning Optimization API",
    description="Integrated Maintenance & Block Planning System for Indian Railways (TMS, SMMS, TDMS, COA)",
    version="1.0.0"
)

scheduler = IMBPSBlockScheduler(solver_timeout_seconds=20)
FEEDBACK_OUTCOMES_FILE = DATA_DIR / "maintenance_outcomes_feedback.json"


# =========================================================================
# PYDANTIC DATA SCHEMAS
# =========================================================================

class MaintenanceJobRequest(BaseModel):
    job_id: str = Field(..., example="TMS-H001")
    department: str = Field(..., example="ENGINEERING") # ENGINEERING, SIGNAL_TELECOM, TRD
    division: str = Field(..., example="ASN")           # ASN, HWH, UMB
    section: str = Field(..., example="UDL-SNT")
    block_section: str = Field(..., example="UDL-UKA")
    line: str = Field("UP_MAIN", example="UP_MAIN")
    work_type: str = Field(..., example="Tamping")
    asset_type: str = Field(..., example="Track")
    severity: str = Field("High", example="High")       # Low, Medium, High, Critical
    criticality: str = Field("Critical", example="Critical")
    overdue_days: int = Field(0, example=4)
    crew_size: int = Field(8, example=8)
    equipment: str = Field("CSM", example="CSM")
    requested_duration_min: int = Field(150, example=150)


class DurationPredictionResponse(BaseModel):
    job_id: str
    requested_duration_min: float
    predicted_duration_min: float
    model_version: str


class RiskPredictionResponse(BaseModel):
    job_id: str
    risk_probability: float
    risk_tier: str
    sub_factors: Dict[str, float]
    model_version: str


class PriorityPredictionResponse(BaseModel):
    job_id: str
    priority_score: float
    priority_band: str
    breakdown: Dict[str, float]
    model_version: str


class CandidateBlockSlot(BaseModel):
    slot_id: str = Field(..., example="SLOT_UDL_01")
    section: str = Field(..., example="UDL-SNT")
    line: str = Field("UP_MAIN", example="UP_MAIN")
    start_minute: int = Field(..., example=660) # 11:00 AM (660 mins from 00:00)
    end_minute: int = Field(..., example=840)   # 14:00 PM (840 mins from 00:00)
    date: str = Field("2026-10-05", example="2026-10-05")


class OptimizePlanRequest(BaseModel):
    planning_horizon: str = Field("WEEKLY", example="WEEKLY") # WEEKLY or MONTHLY
    jobs: List[MaintenanceJobRequest]
    candidate_slots: List[CandidateBlockSlot]


class MaintenanceOutcomeFeedback(BaseModel):
    job_id: str = Field(..., example="TMS-H001")
    predicted_duration_min: float = Field(..., example=168.0)
    actual_duration_min: float = Field(..., example=172.0)
    predicted_start: str = Field(..., example="2026-10-05T11:00:00")
    actual_start: str = Field(..., example="2026-10-05T11:05:00")
    predicted_end: str = Field(..., example="2026-10-05T13:48:00")
    actual_end: str = Field(..., example="2026-10-05T13:57:00")
    train_delay_minutes: float = Field(0.0, example=6.0)
    block_utilization_percent: float = Field(95.5, example=95.5)
    resource_usage: str = Field("CSM + 8 Gangmen", example="CSM + 8 Gangmen")
    completion_status: str = Field("Completed", example="Completed")


class RetrainTriggerRequest(BaseModel):
    reason: str = Field("SCHEDULED_WEEKLY_RETRAIN", example="SCHEDULED_WEEKLY_RETRAIN")


# In-memory storage for generated block plans
GENERATED_PLANS: Dict[str, Any] = {}


from fastapi.responses import HTMLResponse

HTML_FILE = Path(__file__).resolve().parent / "index.html"

# =========================================================================
# REST API ENDPOINTS
# =========================================================================

@app.get("/", response_class=HTMLResponse)
def root_dashboard():
    """Serves the interactive IMBPS Web Control Dashboard."""
    if HTML_FILE.exists():
        with open(HTML_FILE, "r", encoding="utf-8") as f:
            return f.read()
    return "<h1>IMBPS Control System API is Running. Visit <a href='/docs'>/docs</a> for API.</h1>"


@app.get("/api/info")
def api_info():
    return {
        "service": "IMBPS ML & Block Planning Optimization API",
        "status": "OPERATIONAL",
        "version": "1.0.0",
        "docs_url": "/docs"
    }


@app.post("/predict/duration", response_model=DurationPredictionResponse)
def predict_duration(job: MaintenanceJobRequest):
    """Predicts actual execution duration in minutes for a maintenance job."""
    try:
        res = predictor.predict_duration(job.model_dump())
        return res
    except Exception as e:
        logger.error(f"Duration prediction error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/predict/risk", response_model=RiskPredictionResponse)
def predict_risk(job: MaintenanceJobRequest):
    """Estimates asset failure risk probability (0.0 to 1.0) and risk tier."""
    try:
        res = predictor.predict_risk(job.model_dump())
        return res
    except Exception as e:
        logger.error(f"Risk prediction error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/predict/priority", response_model=PriorityPredictionResponse)
def predict_priority(job: MaintenanceJobRequest):
    """Calculates normalized 0-100 priority score balancing safety, risk, urgency, and operations."""
    try:
        risk_res = predictor.predict_risk(job.model_dump())
        prio_res = predictor.predict_priority(job.model_dump(), risk_prob=risk_res["risk_probability"])
        return prio_res
    except Exception as e:
        logger.error(f"Priority scoring error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/optimize/block-plan")
def optimize_block_plan(request: OptimizePlanRequest):
    """
    End-to-End Optimization:
    1. Runs ML Duration, Risk, and Priority predictions on all candidate requests.
    2. Enforces COA operational constraints, headway, power isolation, and S&T permits.
    3. Solves multi-objective block schedule using Google OR-Tools CP-SAT.
    """
    try:
        jobs_raw = [j.model_dump() for j in request.jobs]
        slots_raw = [s.model_dump() for s in request.candidate_slots]

        # ML Pre-Scheduling Enrichment
        enriched_jobs = predictor.enrich_candidate_jobs(jobs_raw)

        # OR-Tools Scheduling
        if request.planning_horizon.upper() == "MONTHLY":
            plan = scheduler.generate_monthly_plan(enriched_jobs, slots_raw)
        else:
            plan = scheduler.generate_weekly_plan(enriched_jobs, slots_raw)

        # Store plan by current date for retrieval
        plan_date = date.today().isoformat()
        GENERATED_PLANS[plan_date] = plan
        return plan
    except Exception as e:
        logger.error(f"Optimization error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/block-plan/{plan_date}")
def get_block_plan(plan_date: str):
    """Retrieves an existing optimized block plan by date (YYYY-MM-DD)."""
    if plan_date in GENERATED_PLANS:
        return GENERATED_PLANS[plan_date]
    # Fallback default plan
    if GENERATED_PLANS:
        latest_key = list(GENERATED_PLANS.keys())[-1]
        return GENERATED_PLANS[latest_key]
    raise HTTPException(status_code=404, detail=f"No block plan found for date: {plan_date}")


@app.post("/maintenance/outcome")
def log_maintenance_outcome(outcome: MaintenanceOutcomeFeedback):
    """
    Feedback Loop: Ingests actual execution outcomes (actual duration, delays, utilization).
    Stores data for continuous model retraining and drift monitoring.
    """
    try:
        history = []
        if FEEDBACK_OUTCOMES_FILE.exists():
            try:
                with open(FEEDBACK_OUTCOMES_FILE, "r", encoding="utf-8") as f:
                    history = json.load(f)
            except Exception:
                history = []

        record = outcome.model_dump()
        record["logged_at"] = datetime.now().isoformat()
        history.append(record)

        with open(FEEDBACK_OUTCOMES_FILE, "w", encoding="utf-8") as f:
            json.dump(history, f, indent=2)

        return {
            "status": "LOGGED_SUCCESSFULLY",
            "job_id": outcome.job_id,
            "recorded_actual_duration": outcome.actual_duration_min,
            "duration_variance": round(outcome.actual_duration_min - outcome.predicted_duration_min, 1)
        }
    except Exception as e:
        logger.error(f"Feedback outcome logging error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/model/retrain")
def trigger_retrain(req: RetrainTriggerRequest):
    """Triggers the automated retraining pipeline with promotion quality gates."""
    try:
        report = retraining_pipeline.trigger_retraining(trigger_reason=req.reason)
        # If promoted, refresh inference predictor in memory
        if report.get("promoted_to_production"):
            predictor._load_models()
        return report
    except Exception as e:
        logger.error(f"Retraining error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/model/status")
def get_model_status():
    """Checks the active model registry status, deployment health, and evaluation metrics."""
    try:
        registry_data = {}
        if REGISTRY_FILE.exists():
            with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
                registry_data = json.load(f)

        return {
            "active_duration_model_version": predictor.duration_version,
            "active_risk_model_version": predictor.risk_model.model_version if predictor.risk_model else "risk_v1",
            "active_priority_model_version": predictor.priority_engine.model_version if predictor.priority_engine else "priority_v1",
            "total_registered_models": len(registry_data),
            "registry_models": registry_data
        }
    except Exception as e:
        logger.error(f"Model status error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
