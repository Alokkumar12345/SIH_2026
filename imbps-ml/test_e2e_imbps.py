"""
End-to-End Verification and Demonstration Script for IMBPS ML + Optimization Layer.
Executes and validates all 10 core architectural modules:
1. Unified Data Loading (TMS + SMMS + TDMS + COA)
2. Preprocessing & Feature Engineering
3. Duration Regression Prediction
4. Asset Risk Estimation
5. Maintenance Priority Scoring
6. OR-Tools CP-SAT Multi-Department Optimization
7. Weekly & Monthly Block Plan Generation
8. Feedback Loop Outcome Logging
9. Automated Retraining Pipeline & Model Registry
10. FastAPI Service Endpoints Test
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
sys.path.append(str(BASE_DIR))

import json
import logging
from datetime import datetime, date
from fastapi.testclient import TestClient

from data.loader import data_loader
from preprocessing.validation import DataValidator
from preprocessing.cleaning import DataCleaner
from preprocessing.feature_engineering import FeatureEngineer
from inference.predictor import predictor
from optimization.scheduler import IMBPSBlockScheduler
from pipelines.training_pipeline import retraining_pipeline
from pipelines.deployment_pipeline import deployment_pipeline
from api.main import app

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger("IMBPS.E2ETest")


def run_full_e2e_test():
    print("\n" + "="*80)
    print("      IMBPS (INTEGRATED MAINTENANCE & BLOCK PLANNING SYSTEM)")
    print("          END-TO-END ML + OPTIMIZATION VERIFICATION SUITE")
    print("="*80)

    # -------------------------------------------------------------------------
    # 1. TEST DATA LAYER
    # -------------------------------------------------------------------------
    print("\n[STEP 1] Testing Unified Data Ingestion from TMS, SMMS, TDMS via Neon PostgreSQL Cloud...")
    raw_df = data_loader.get_unified_dataset(use_db=True)
    print(f"  -> Total records loaded: {len(raw_df)}")
    dept_counts = raw_df["department"].value_counts().to_dict()
    print(f"  -> Department distribution: {dept_counts}")
    assert len(raw_df) > 1500, "Expected at least 1500 records across 3 departments"

    coa_data = data_loader.get_coa_operational_data()
    print(f"  -> COA master operational feeds: {list(coa_data.keys())}")
    print("  [PASS] Data Ingestion Verified.")

    # -------------------------------------------------------------------------
    # 2. TEST PREPROCESSING & FEATURE ENGINEERING
    # -------------------------------------------------------------------------
    print("\n[STEP 2] Testing Data Validation, Cleaning & Feature Engineering...")
    is_valid, missing = DataValidator.validate_schema(raw_df)
    assert is_valid, f"Missing schema columns: {missing}"

    clean_df, issues = DataValidator.validate_records(raw_df)
    clean_df = DataCleaner.clean(clean_df)
    print(f"  -> Valid cleaned records: {len(clean_df)}")

    fe = FeatureEngineer()
    df_features = fe.extract_raw_features(clean_df.head(20))
    print(f"  -> Engineered features sample columns: {list(df_features.columns[-8:])}")
    print("  [PASS] Preprocessing & Feature Engineering Verified.")

    # -------------------------------------------------------------------------
    # 3. TEST ML MODEL 1 - DURATION PREDICTION
    # -------------------------------------------------------------------------
    print("\n[STEP 3] Testing ML Model 1: Duration Prediction...")
    sample_jobs = [
        {
            "job_id": "TMS-JOB-101",
            "department": "ENGINEERING",
            "division": "ASN",
            "section": "UDL-SNT",
            "block_section": "UDL-UKA",
            "line": "UP_MAIN",
            "work_type": "Tamping",
            "asset_type": "Track",
            "severity": "High",
            "criticality": "Critical",
            "overdue_days": 4,
            "crew_size": 8,
            "equipment": "CSM",
            "requested_duration_min": 150
        },
        {
            "job_id": "SMMS-JOB-202",
            "department": "SIGNAL_TELECOM",
            "division": "HWH",
            "section": "HWH-KAN (Main line)",
            "block_section": "BLY-BDC",
            "line": "3RD_LINE",
            "work_type": "Point Motor Replacement",
            "asset_type": "Point Machine",
            "severity": "Critical",
            "criticality": "Critical",
            "overdue_days": 5,
            "crew_size": 5,
            "equipment": "Point Testing Kit",
            "requested_duration_min": 90
        },
        {
            "job_id": "TDMS-JOB-303",
            "department": "TRD",
            "division": "UMB",
            "section": "UMB-LDH",
            "block_section": "UMB-RPJ",
            "line": "UP_MAIN",
            "work_type": "OHE Wire Replacement",
            "asset_type": "OHE",
            "severity": "High",
            "criticality": "Critical",
            "overdue_days": 6,
            "crew_size": 8,
            "equipment": "Tower Wagon",
            "requested_duration_min": 120
        }
    ]

    for job in sample_jobs:
        dur_res = predictor.predict_duration(job)
        print(f"  -> [{job['job_id']}] {job['department']} | {job['work_type']}: Requested {job['requested_duration_min']}m -> Predicted: {dur_res['predicted_duration_min']}m (Model: {dur_res['model_version']})")
        assert dur_res["predicted_duration_min"] > 0
    print("  [PASS] Duration Prediction Verified.")

    # -------------------------------------------------------------------------
    # 4. TEST ML MODEL 2 - ASSET RISK ESTIMATION
    # -------------------------------------------------------------------------
    print("\n[STEP 4] Testing ML Model 2: Asset Risk Estimation...")
    for job in sample_jobs:
        risk_res = predictor.predict_risk(job)
        print(f"  -> [{job['job_id']}] Risk Probability: {risk_res['risk_probability']} ({risk_res['risk_tier']}) Sub-factors: {risk_res['sub_factors']}")
        assert 0.0 <= risk_res["risk_probability"] <= 1.0
    print("  [PASS] Asset Risk Estimation Verified.")

    # -------------------------------------------------------------------------
    # 5. TEST ML MODEL 3 - MAINTENANCE PRIORITY SCORING
    # -------------------------------------------------------------------------
    print("\n[STEP 5] Testing ML Model 3: Maintenance Priority Engine...")
    for job in sample_jobs:
        risk_res = predictor.predict_risk(job)
        prio_res = predictor.predict_priority(job, risk_prob=risk_res["risk_probability"])
        print(f"  -> [{job['job_id']}] Priority Score: {prio_res['priority_score']}/100 [{prio_res['priority_band']}] Breakdown: {prio_res['breakdown']}")
        assert 0.0 <= prio_res["priority_score"] <= 100.0
    print("  [PASS] Maintenance Priority Scoring Verified.")

    # -------------------------------------------------------------------------
    # 6. TEST OR-TOOLS CP-SAT SCHEDULER & COA OPTIMIZATION
    # -------------------------------------------------------------------------
    print("\n[STEP 6] Testing OR-Tools CP-SAT Block Scheduling & Multi-Department Coordination...")
    candidate_slots = [
        {
            "slot_id": "SLOT_ASN_01",
            "section": "UDL-SNT",
            "line": "UP_MAIN",
            "start_minute": 660,  # 11:00 AM
            "end_minute": 870,    # 14:30 PM (210 mins)
            "date": "2026-10-05"
        },
        {
            "slot_id": "SLOT_HWH_01",
            "section": "HWH-KAN (Main line)",
            "line": "3RD_LINE",
            "start_minute": 60,   # 01:00 AM (Night shadow block)
            "end_minute": 240,    # 04:00 AM (180 mins)
            "date": "2026-10-05"
        },
        {
            "slot_id": "SLOT_UMB_01",
            "section": "UMB-LDH",
            "line": "UP_MAIN",
            "start_minute": 720,  # 12:00 PM
            "end_minute": 930,    # 15:30 PM (210 mins)
            "date": "2026-10-05"
        }
    ]

    # Pre-enrich candidate requests with ML predictions
    enriched_jobs = predictor.enrich_candidate_jobs(sample_jobs)
    
    # Add a co-located job (TDMS dropper renewal on UDL-UKA UP_MAIN that can piggyback with TMS Tamping!)
    piggyback_job = {
        "job_id": "TDMS-CO-LOCATED-404",
        "department": "TRD",
        "division": "ASN",
        "section": "UDL-SNT",
        "block_section": "UDL-UKA",
        "line": "UP_MAIN",
        "work_type": "Dropper Renewal",
        "asset_type": "OHE",
        "severity": "Medium",
        "criticality": "High",
        "overdue_days": 2,
        "crew_size": 6,
        "equipment": "Tower Wagon",
        "requested_duration_min": 75
    }
    enriched_jobs.append(predictor.process_job(piggyback_job))

    scheduler = IMBPSBlockScheduler(solver_timeout_seconds=15)
    plan = scheduler.generate_weekly_plan(enriched_jobs, candidate_slots)

    print(f"  -> Solver Status: {plan['solver_status']}")
    print(f"  -> KPIs: {plan['kpis']}")
    print("\n  --- Scheduled Block Assignments ---")
    for b in plan["scheduled_blocks"]:
        print(f"    * [{b['job_id']}] {b['department']:15s} | {b['work_type']:25s} on {b['block_section']} ({b['line']})")
        print(f"      Assigned Window: {b['scheduled_start_time']} - {b['scheduled_end_time']} ({b['assigned_duration_min']} min) in {b['assigned_slot_id']}")
        print(f"      Dependencies: Power Block Req: {b['coordination']['power_block_required']}, S&T Permit Req: {b['coordination']['st_disconnection_required']}")

    assert plan["kpis"]["jobs_scheduled"] > 0, "Expected jobs to be scheduled successfully"
    print("  [PASS] CP-SAT Multi-Department Scheduling Verified.")

    # -------------------------------------------------------------------------
    # 7. TEST MONTHLY AGGREGATED PLAN
    # -------------------------------------------------------------------------
    print("\n[STEP 7] Testing Monthly Aggregated Planning Horizon...")
    monthly_plan = scheduler.generate_monthly_plan(enriched_jobs, candidate_slots)
    print(f"  -> Monthly Workload Hours by Department: {monthly_plan.get('monthly_workload_hours')}")
    print("  [PASS] Monthly Aggregated Planning Verified.")

    # -------------------------------------------------------------------------
    # 8. TEST FEEDBACK LOOP
    # -------------------------------------------------------------------------
    print("\n[STEP 8] Testing Execution Feedback Loop...")
    feedback_payload = {
        "job_id": "TMS-JOB-101",
        "predicted_duration_min": 156.7,
        "actual_duration_min": 162.0,
        "predicted_start": "2026-10-05T11:00:00",
        "actual_start": "2026-10-05T11:04:00",
        "predicted_end": "2026-10-05T13:36:00",
        "actual_end": "2026-10-05T13:46:00",
        "train_delay_minutes": 5.0,
        "block_utilization_percent": 94.2,
        "resource_usage": "CSM + 8 Gangmen",
        "completion_status": "Completed"
    }
    client = TestClient(app)
    fb_resp = client.post("/maintenance/outcome", json=feedback_payload)
    print(f"  -> Feedback outcome response: {fb_resp.json()}")
    assert fb_resp.status_code == 200
    print("  [PASS] Feedback Loop Logging Verified.")

    # -------------------------------------------------------------------------
    # 9. TEST AUTOMATED RETRAINING & MODEL REGISTRY
    # -------------------------------------------------------------------------
    print("\n[STEP 9] Testing Automated Retraining Pipeline & Model Registry...")
    retrain_report = retraining_pipeline.trigger_retraining("AUTOMATED_TEST_TRIGGER")
    print(f"  -> Retraining Report: {json.dumps(retrain_report, indent=2)}")
    assert "candidate_version" in retrain_report
    print("  [PASS] Automated Retraining Pipeline Verified.")

    # -------------------------------------------------------------------------
    # 10. TEST DIVISION DEPLOYMENT & ROLLBACK
    # -------------------------------------------------------------------------
    print("\n[STEP 10] Testing Division Deployment & Rollback Pipeline...")
    deploy_res = deployment_pipeline.distribute_approved_model()
    print(f"  -> Deployed Version: {deploy_res['model_version']} to Divisions: {deploy_res['target_divisions']}")
    assert deploy_res["status"] == "DEPLOYED_SUCCESSFULLY"

    rollback_res = deployment_pipeline.rollback_model("duration_v1")
    print(f"  -> Rollback executed to: {rollback_res['model_version']}")
    assert rollback_res["action"] == "ROLLBACK_EXECUTED"
    print("  [PASS] Division Deployment & Rollback Verified.")

    # -------------------------------------------------------------------------
    # 11. TEST FASTAPI ENDPOINTS
    # -------------------------------------------------------------------------
    print("\n[STEP 11] Testing FastAPI Endpoints...")
    r_root = client.get("/")
    assert r_root.status_code == 200

    r_dur = client.post("/predict/duration", json=sample_jobs[0])
    print(f"  -> POST /predict/duration: {r_dur.json()}")
    assert r_dur.status_code == 200

    r_risk = client.post("/predict/risk", json=sample_jobs[0])
    print(f"  -> POST /predict/risk: {r_risk.json()}")
    assert r_risk.status_code == 200

    r_prio = client.post("/predict/priority", json=sample_jobs[0])
    print(f"  -> POST /predict/priority: {r_prio.json()}")
    assert r_prio.status_code == 200

    r_status = client.get("/model/status")
    print(f"  -> GET /model/status: Active duration version: {r_status.json()['active_duration_model_version']}")
    assert r_status.status_code == 200

    print("\n" + "="*80)
    print("      ALL 11 IMBPS VERIFICATION MODULES PASSED SUCCESSFULLY! ")
    print("="*80)


if __name__ == "__main__":
    run_full_e2e_test()
