"""
ML Model 3: Maintenance Priority Scoring Engine for IMBPS.
Calculates a normalized 0 to 100 priority score for maintenance activities,
balancing safety-critical requirements, asset failure risk, operational impact,
and regulatory urgency.
"""

import logging
from typing import Dict, Any, List, Optional
import numpy as np
import pandas as pd

logger = logging.getLogger("IMBPS.PriorityModel")

SAFETY_WEIGHTS = {
    # Engineering/Track safety critical
    "Track Renewal": 95, "Tamping": 85, "Rail Grinding": 90, "Ultrasonic Testing": 80, "Ballast Cleaning": 75,
    # S&T safety critical
    "Point Motor Replacement": 98, "Signal Aspect LED Unit Replacement": 90,
    "Track Circuit Repair": 95, "Axle Counter Maintenance": 92,
    "Electronic Interlocking Diagnostic & Card Replacement": 96,
    # Electrical TRD safety critical
    "OHE Wire Replacement": 98, "PTFE Neutral Section Overhaul & Arc Horn Check": 94,
    "25 kV Vacuum Circuit Breaker (VCB) Overhaul": 92, "Insulator Replacement": 88
}


class MaintenancePriorityEngine:
    """
    Computes normalized 0-100 Priority Scores for multi-department block requests.
    Architected to support future Learning-to-Rank (LTR) algorithms (e.g. LambdaMART).
    """

    def __init__(self, model_version: str = "priority_v1"):
        self.model_version = model_version
        # Domain weighting configuration
        self.weights = {
            "safety_criticality": 0.35,
            "asset_risk": 0.25,
            "urgency_overdue": 0.20,
            "operational_impact": 0.20
        }

    def compute_priority(self, job_record: Dict[str, Any], risk_probability: Optional[float] = None) -> Dict[str, Any]:
        """
        Computes normalized 0-100 priority score with explainable sub-scores.
        """
        work_type = job_record.get("work_type", "")
        criticality = job_record.get("criticality", "Medium")
        severity = job_record.get("severity", "Medium")
        overdue_days = max(0, int(job_record.get("overdue_days", 0)))
        line = str(job_record.get("line", "")).upper()

        # 1. Safety Criticality Score (0-100)
        base_safety = SAFETY_WEIGHTS.get(work_type, 65)
        crit_multiplier = 1.05 if criticality == "Critical" else (1.0 if criticality == "High" else 0.9)
        safety_score = min(100.0, base_safety * crit_multiplier)

        # 2. Asset Risk Score (0-100)
        if risk_probability is None:
            # Fallback estimation if not provided
            sev_boost = 30 if severity == "Critical" else (20 if severity == "High" else 10)
            risk_score = min(100.0, 40.0 + sev_boost + (overdue_days * 5.0))
        else:
            risk_score = min(100.0, risk_probability * 100.0)

        # 3. Urgency & Overdue Score (0-100)
        # Overdue jobs scale rapidly up to day 6+
        urgency_score = min(100.0, 40.0 + (overdue_days * 10.0))

        # 4. Operational Impact Score (0-100)
        # Main trunk and chord routes impact higher traffic than branches
        if "CHORD" in line or "3RD_LINE" in line:
            operational_score = 90.0
        elif "MAIN" in line:
            operational_score = 85.0
        elif "LOOP" in line:
            operational_score = 65.0
        else:
            operational_score = 50.0

        # Composite Normalized Priority Score (0-100)
        composite_score = (
            self.weights["safety_criticality"] * safety_score +
            self.weights["asset_risk"] * risk_score +
            self.weights["urgency_overdue"] * urgency_score +
            self.weights["operational_impact"] * operational_score
        )
        final_priority = round(float(np.clip(composite_score, 10.0, 99.5)), 1)

        # Priority Banding
        if final_priority >= 85:
            band = "P1_MANDATORY_CRITICAL"
        elif final_priority >= 70:
            band = "P2_HIGH_PRIORITY"
        elif final_priority >= 50:
            band = "P3_STANDARD_PLANNED"
        else:
            band = "P4_DEFERRABLE"

        return {
            "job_id": job_record.get("job_id", "UNKNOWN"),
            "priority_score": final_priority,
            "priority_band": band,
            "breakdown": {
                "safety_criticality_score": round(safety_score, 1),
                "asset_risk_score": round(risk_score, 1),
                "urgency_overdue_score": round(urgency_score, 1),
                "operational_impact_score": round(operational_score, 1)
            },
            "model_version": self.model_version
        }

    def rank_jobs(self, jobs: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Ranks a list of maintenance candidate jobs by priority score descending."""
        scored = [self.compute_priority(j) for j in jobs]
        # Attach full original job details
        for i, s in enumerate(scored):
            s["job_details"] = jobs[i]
        return sorted(scored, key=lambda x: x["priority_score"], reverse=True)
