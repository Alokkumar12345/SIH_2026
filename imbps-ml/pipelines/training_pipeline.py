"""
Automated Retraining Pipeline for IMBPS.
Periodically ingests updated actual maintenance outcomes, trains candidate models,
evaluates against production thresholds (e.g. New MAE < Production MAE), and promotes
approved models to the registry.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
from datetime import datetime
from typing import Dict, Any, Tuple, Optional

from data.loader import data_loader
from preprocessing.validation import DataValidator
from preprocessing.cleaning import DataCleaner
from training.train_duration import time_based_split
from models.duration_model import DurationPredictionModel
from config.settings import REGISTRY_DIR, REGISTRY_FILE

logger = logging.getLogger("IMBPS.TrainingPipeline")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class RetrainingPipeline:
    """Orchestrates continuous learning and automated model governance."""

    def __init__(self):
        self.registry_file = REGISTRY_FILE

    def _get_production_model_info(self) -> Tuple[Optional[str], Optional[float]]:
        """Finds current production model version and its validation MAE."""
        if not self.registry_file.exists():
            return None, None
        try:
            with open(self.registry_file, "r", encoding="utf-8") as f:
                reg = json.load(f)
            for ver, meta in reg.items():
                if meta.get("status") == "PRODUCTION" and "duration" in ver:
                    val_mae = meta.get("metrics", {}).get("val_mae", 999.0)
                    return ver, float(val_mae)
        except Exception as e:
            logger.warning(f"Error reading registry: {e}")
        return None, None

    def trigger_retraining(self, trigger_reason: str = "SCHEDULED_PERIODIC") -> Dict[str, Any]:
        """
        Executes complete retraining cycle:
        Data Ingestion -> Cleaning -> Split -> Train Candidate -> Compare vs Production -> Decision
        """
        logger.info(f"=== RETRAINING TRIGGERED: {trigger_reason} ===")

        # 1. Ingest Data directly from live Neon PostgreSQL Cloud tables
        raw_df = data_loader.get_unified_dataset(use_db=True)
        clean_df, _ = DataValidator.validate_records(raw_df)
        clean_df = DataCleaner.clean(clean_df)

        # 2. Time-based split
        df_train, df_val, df_test = time_based_split(clean_df)

        # 3. Determine new version tag
        current_prod_ver, current_prod_mae = self._get_production_model_info()
        if current_prod_ver:
            try:
                num = int(current_prod_ver.split("_v")[-1]) + 1
            except Exception:
                num = 2
            candidate_ver = f"duration_v{num}"
        else:
            candidate_ver = "duration_v1"
            current_prod_mae = 999.0

        logger.info(f"Current Production: {current_prod_ver} (Val MAE: {current_prod_mae} min). Candidate: {candidate_ver}")

        # 4. Train Candidate Model (GradientBoosting / RandomForest)
        candidate_model = DurationPredictionModel(algorithm="GradientBoosting", model_version=candidate_ver)
        candidate_model.train(df_train)
        candidate_metrics = candidate_model.evaluate(df_val)
        candidate_mae = candidate_metrics["mae"]

        # 5. Quality Gate: Comparison with Production
        # Threshold: Candidate must be at least as good or better than production MAE
        is_promoted = (candidate_mae <= current_prod_mae) or (current_prod_ver is None)

        decision_report = {
            "candidate_version": candidate_ver,
            "current_production_version": current_prod_ver,
            "current_production_mae": current_prod_mae,
            "candidate_val_mae": round(candidate_mae, 2),
            "candidate_test_mae": round(candidate_metrics["mae"], 2),
            "promoted_to_production": is_promoted,
            "timestamp": datetime.now().isoformat()
        }

        # 6. Save Artifact and Update Registry
        save_path = REGISTRY_DIR / f"{candidate_ver}.joblib"
        candidate_model.save(str(save_path))

        registry_data = {}
        if self.registry_file.exists():
            try:
                with open(self.registry_file, "r", encoding="utf-8") as f:
                    registry_data = json.load(f)
            except Exception:
                registry_data = {}

        if is_promoted:
            # Demote old production model to RETIRED
            if current_prod_ver and current_prod_ver in registry_data:
                registry_data[current_prod_ver]["status"] = "RETIRED"
            status = "PRODUCTION"
            logger.info(f"PROMOTION GRANTED: {candidate_ver} is now the active PRODUCTION model!")
        else:
            status = "STAGING_NOT_PROMOTED"
            logger.info(f"PROMOTION DENIED: Candidate MAE ({candidate_mae:.2f}) did not beat Production MAE ({current_prod_mae:.2f}). Kept in STAGING.")

        registry_data[candidate_ver] = {
            "model_version": candidate_ver,
            "algorithm": candidate_model.algorithm,
            "trained_at": datetime.now().isoformat(),
            "status": status,
            "file_path": str(save_path),
            "metrics": candidate_metrics,
            "trigger": trigger_reason
        }

        with open(self.registry_file, "w", encoding="utf-8") as f:
            json.dump(registry_data, f, indent=2)

        decision_report["status"] = status
        return decision_report


# Singleton retraining pipeline
retraining_pipeline = RetrainingPipeline()

if __name__ == "__main__":
    result = retraining_pipeline.trigger_retraining("MANUAL_CLI_INVOCATION")
    print(json.dumps(result, indent=2))
