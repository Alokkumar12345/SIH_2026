"""
Inference Predictor for IMBPS.
Unified inference engine that loads production models from the registry
and generates duration predictions, risk probabilities, and priority scores.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
from typing import Dict, Any, List, Optional
import pandas as pd

from models.duration_model import DurationPredictionModel
from models.risk_model import AssetRiskModel
from models.priority_model import MaintenancePriorityEngine
from config.settings import REGISTRY_DIR, REGISTRY_FILE, DEFAULT_MODEL_VERSION

logger = logging.getLogger("IMBPS.Predictor")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class IMBPSPredictor:
    """
    Central inference interface for production ML predictions in IMBPS.
    """

    def __init__(self, duration_version: Optional[str] = None):
        self.duration_version = duration_version or self._get_active_model_version("duration")
        self.duration_model: Optional[DurationPredictionModel] = None
        self.risk_model: Optional[AssetRiskModel] = None
        self.priority_engine: Optional[MaintenancePriorityEngine] = None
        self._load_models()

    def _get_active_model_version(self, model_type: str) -> str:
        """Reads the currently active PRODUCTION model version from registry."""
        if REGISTRY_FILE.exists():
            try:
                with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
                    reg = json.load(f)
                for ver, meta in reg.items():
                    if meta.get("status") == "PRODUCTION" and (model_type in ver or meta.get("type") == model_type):
                        return ver
            except Exception as e:
                logger.warning(f"Could not read registry: {e}")
        return DEFAULT_MODEL_VERSION

    def _load_models(self):
        """Loads all required models into memory."""
        # 1. Duration Model
        duration_path = REGISTRY_DIR / f"{self.duration_version}.joblib"
        if duration_path.exists():
            self.duration_model = DurationPredictionModel.load(str(duration_path))
        else:
            logger.warning(f"Duration model file {duration_path} not found. Using fallback estimator.")
            self.duration_model = None

        # 2. Risk Model
        risk_path = REGISTRY_DIR / "risk_v1.joblib"
        if risk_path.exists():
            self.risk_model = AssetRiskModel.load(str(risk_path))
        else:
            self.risk_model = AssetRiskModel(model_version="risk_v1")

        # 3. Priority Engine
        self.priority_engine = MaintenancePriorityEngine(model_version="priority_v1")
        logger.info("IMBPS Inference Models successfully initialized.")

    def predict_duration(self, job: Dict[str, Any]) -> Dict[str, Any]:
        """Predicts actual duration in minutes."""
        if self.duration_model is not None and self.duration_model.is_trained:
            return self.duration_model.predict_one(job)
        else:
            # Fallback heuristic if model not yet trained
            req = float(job.get("requested_duration_min", 90))
            return {
                "job_id": job.get("job_id", "UNKNOWN"),
                "predicted_duration_min": round(req * 1.08, 1),
                "model_version": "heuristic_fallback"
            }

    def predict_risk(self, job: Dict[str, Any]) -> Dict[str, Any]:
        """Estimates asset failure risk probability (0.0 to 1.0)."""
        return self.risk_model.predict_one(job)

    def predict_priority(self, job: Dict[str, Any], risk_prob: Optional[float] = None) -> Dict[str, Any]:
        """Calculates normalized 0-100 priority score."""
        return self.priority_engine.compute_priority(job, risk_probability=risk_prob)

    def process_job(self, job: Dict[str, Any]) -> Dict[str, Any]:
        """
        Runs the complete ML prediction pipeline for a single maintenance job:
        Step 1: Predict Duration
        Step 2: Predict Risk Probability
        Step 3: Compute Maintenance Priority
        """
        dur_res = self.predict_duration(job)
        risk_res = self.predict_risk(job)
        prio_res = self.predict_priority(job, risk_prob=risk_res["risk_probability"])

        enriched = job.copy()
        enriched["predicted_duration_min"] = dur_res["predicted_duration_min"]
        enriched["duration_model_version"] = dur_res["model_version"]
        enriched["risk_probability"] = risk_res["risk_probability"]
        enriched["risk_tier"] = risk_res["risk_tier"]
        enriched["priority_score"] = prio_res["priority_score"]
        enriched["priority_band"] = prio_res["priority_band"]
        return enriched

    def enrich_candidate_jobs(self, jobs: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Batch-enriches a list of maintenance requests for optimization scheduling."""
        return [self.process_job(j) for j in jobs]


# Singleton predictor instance
predictor = IMBPSPredictor()
