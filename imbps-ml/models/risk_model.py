"""
ML Model 2: Maintenance & Asset Risk Prediction Model for IMBPS.
Estimates the risk probability (0.0 to 1.0) of an asset failure or critical disruption.
Implements an explainable domain-based formulation with a pluggable supervised ML classifier
interface for future transitions when explicit failure labels become available.
"""

import logging
from typing import Dict, Any, List, Optional
import numpy as np
import pandas as pd
import joblib
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline

logger = logging.getLogger("IMBPS.RiskModel")

SEVERITY_MAP = {"Low": 0.2, "Medium": 0.5, "High": 0.8, "Critical": 1.0}
CRITICALITY_MAP = {"Low": 0.2, "Medium": 0.5, "High": 0.8, "Critical": 1.0}


class AssetRiskModel:
    """
    Estimates Asset Risk Score (0.0 to 1.0).
    Dual-mode:
    1. Explainable Domain Formulation (Current Production Mode)
    2. Supervised Classification (Pluggable Mode when failure labels are recorded)
    """

    def __init__(self, model_version: str = "risk_v1", mode: str = "domain_explainable"):
        self.model_version = model_version
        self.mode = mode
        self.ml_pipeline: Optional[Pipeline] = None
        self.is_trained: bool = (mode == "domain_explainable")

    def calculate_domain_risk(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Calculates explainable risk score based on:
        - Asset Criticality (Weight 0.35)
        - Defect Severity (Weight 0.30)
        - Overdue Status (Weight 0.20)
        - Operational Traffic / Line Density (Weight 0.15)
        """
        crit_score = CRITICALITY_MAP.get(record.get("criticality", "Medium"), 0.5)
        sev_score = SEVERITY_MAP.get(record.get("severity", "Medium"), 0.5)
        
        # Overdue factor: 0 days = 0.0, 7+ days = 1.0
        overdue_days = max(0, int(record.get("overdue_days", 0)))
        overdue_score = min(1.0, overdue_days / 7.0)

        # Operational factor: Main/Chord line vs Branch line
        line = str(record.get("line", "UP_MAIN")).upper()
        line_factor = 0.9 if "MAIN" in line or "CHORD" in line else 0.5

        # Weighted calculation
        raw_risk = (0.35 * crit_score) + (0.30 * sev_score) + (0.20 * overdue_score) + (0.15 * line_factor)
        risk_probability = float(np.clip(raw_risk, 0.05, 0.98))

        # Risk Classification tier
        if risk_probability >= 0.75:
            risk_tier = "CRITICAL_RISK"
        elif risk_probability >= 0.50:
            risk_tier = "HIGH_RISK"
        elif risk_probability >= 0.30:
            risk_tier = "MODERATE_RISK"
        else:
            risk_tier = "LOW_RISK"

        return {
            "job_id": record.get("job_id", "UNKNOWN"),
            "risk_probability": round(risk_probability, 3),
            "risk_tier": risk_tier,
            "sub_factors": {
                "criticality_factor": round(crit_score, 2),
                "severity_factor": round(sev_score, 2),
                "overdue_factor": round(overdue_score, 2),
                "line_operational_factor": round(line_factor, 2)
            },
            "model_version": self.model_version
        }

    def predict_one(self, job_record: Dict[str, Any]) -> Dict[str, Any]:
        """Inference entry point for a single job."""
        if self.mode == "supervised" and self.ml_pipeline is not None:
            # Supervised prediction mode
            df_single = pd.DataFrame([job_record])
            prob = float(self.ml_pipeline.predict_proba(df_single)[0][1])
            return {
                "job_id": job_record.get("job_id", "UNKNOWN"),
                "risk_probability": round(prob, 3),
                "risk_tier": "CRITICAL_RISK" if prob >= 0.75 else ("HIGH_RISK" if prob >= 0.5 else "MODERATE_RISK"),
                "model_version": self.model_version,
                "mode": "supervised_ml"
            }
        else:
            return self.calculate_domain_risk(job_record)

    def predict_batch(self, df: pd.DataFrame) -> List[Dict[str, Any]]:
        """Batch inference for multiple maintenance jobs."""
        records = df.to_dict(orient="records")
        return [self.predict_one(r) for r in records]

    def save(self, filepath: str):
        """Saves risk model configuration."""
        data = {
            "model_version": self.model_version,
            "mode": self.mode,
            "is_trained": self.is_trained,
            "ml_pipeline": self.ml_pipeline
        }
        joblib.dump(data, filepath)
        logger.info(f"Risk model saved to {filepath}")

    @classmethod
    def load(cls, filepath: str) -> "AssetRiskModel":
        data = joblib.load(filepath)
        instance = cls(model_version=data["model_version"], mode=data["mode"])
        instance.is_trained = data["is_trained"]
        instance.ml_pipeline = data.get("ml_pipeline")
        logger.info(f"Risk model [{instance.model_version}] loaded from {filepath}")
        return instance
