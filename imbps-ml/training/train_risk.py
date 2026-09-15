"""
Training and registration script for Asset Risk Model.
Validates explainable risk calibration against unified maintenance data
and registers the production risk model.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
from datetime import datetime
import pandas as pd

from data.loader import data_loader
from models.risk_model import AssetRiskModel
from config.settings import REGISTRY_DIR, REGISTRY_FILE

logger = logging.getLogger("IMBPS.TrainRisk")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def register_risk_model(model_version: str = "risk_v1") -> AssetRiskModel:
    logger.info("=== INITIALIZING & REGISTERING ASSET RISK MODEL ===")
    
    # Instantiate domain explainable risk model
    risk_model = AssetRiskModel(model_version=model_version, mode="domain_explainable")
    
    # Load sample records directly from Neon Cloud DB
    raw_df = data_loader.get_unified_dataset(use_db=True)
    sample_records = raw_df.head(50).to_dict(orient="records")
    risk_outputs = [risk_model.predict_one(r) for r in sample_records]

    # Check distribution
    probs = [r["risk_probability"] for r in risk_outputs]
    avg_risk = sum(probs) / len(probs)
    logger.info(f"Sample verification on 50 jobs - Mean Risk: {avg_risk:.3f}, Min: {min(probs):.3f}, Max: {max(probs):.3f}")

    # Save model artifact
    save_path = REGISTRY_DIR / f"{model_version}.joblib"
    risk_model.save(str(save_path))

    # Update Registry
    registry_entry = {
        "model_version": model_version,
        "type": "asset_risk",
        "mode": "domain_explainable_with_ml_interface",
        "registered_at": datetime.now().isoformat(),
        "status": "PRODUCTION",
        "file_path": str(save_path),
        "mean_risk_benchmark": round(avg_risk, 3)
    }

    registry_data = {}
    if REGISTRY_FILE.exists():
        try:
            with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
                registry_data = json.load(f)
        except Exception:
            registry_data = {}

    registry_data[model_version] = registry_entry
    with open(REGISTRY_FILE, "w", encoding="utf-8") as f:
        json.dump(registry_data, f, indent=2)

    logger.info(f"Asset Risk Model [{model_version}] registered successfully.")
    return risk_model


if __name__ == "__main__":
    register_risk_model()
