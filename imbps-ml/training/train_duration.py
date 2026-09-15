"""
Training script for Duration Prediction Model.
Executes time-based split, model benchmark comparison (RandomForest vs GradientBoosting vs Ridge),
evaluates metrics (MAE, RMSE, R²), and registers the best model.
"""

import os
import sys
from pathlib import Path

# Add project root to sys.path
BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import json
import logging
import pandas as pd
from datetime import datetime

from data.loader import data_loader
from preprocessing.validation import DataValidator
from preprocessing.cleaning import DataCleaner
from models.duration_model import DurationPredictionModel
from config.settings import REGISTRY_DIR, REGISTRY_FILE

logger = logging.getLogger("IMBPS.TrainDuration")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


def time_based_split(df: pd.DataFrame, train_ratio: float = 0.70, val_ratio: float = 0.15):
    """
    Splits records chronologically:
    Oldest 70% -> Train
    Next 15% -> Validation
    Latest 15% -> Test
    Prevents temporal data leakage!
    """
    df_sorted = df.sort_values(by="actual_start").reset_index(drop=True)
    n = len(df_sorted)
    train_end = int(n * train_ratio)
    val_end = int(n * (train_ratio + val_ratio))

    df_train = df_sorted.iloc[:train_end].copy()
    df_val = df_sorted.iloc[train_end:val_end].copy()
    df_test = df_sorted.iloc[val_end:].copy()

    logger.info(f"Time-based split: Train={len(df_train)}, Val={len(df_val)}, Test={len(df_test)}")
    return df_train, df_val, df_test


def run_training_experiment(model_version: str = "duration_v1") -> DurationPredictionModel:
    logger.info("=== STARTING DURATION MODEL TRAINING EXPERIMENT ===")
    
    # 1. Load data directly from live Neon PostgreSQL Cloud tables
    raw_df = data_loader.get_unified_dataset(use_db=True)
    
    # 2. Validate
    is_valid_schema, missing = DataValidator.validate_schema(raw_df)
    if not is_valid_schema:
        raise ValueError(f"Schema validation failed: Missing columns {missing}")
    clean_df, issues = DataValidator.validate_records(raw_df)

    # 3. Clean
    clean_df = DataCleaner.clean(clean_df)

    # 4. Time-based split
    df_train, df_val, df_test = time_based_split(clean_df)

    # 5. Benchmark algorithms
    algorithms = ["RandomForest", "GradientBoosting", "Linear"]
    benchmark_results = {}
    candidate_models = {}

    for algo in algorithms:
        logger.info(f"Evaluating algorithm: {algo}...")
        model = DurationPredictionModel(algorithm=algo, model_version=model_version)
        model.train(df_train)
        eval_metrics = model.evaluate(df_val)
        benchmark_results[algo] = eval_metrics
        candidate_models[algo] = model

    # 6. Select Best Algorithm based on Validation MAE
    best_algo = min(benchmark_results, key=lambda a: benchmark_results[a]["mae"])
    best_val_mae = benchmark_results[best_algo]["mae"]
    logger.info(f"\n--- Benchmark Results on Validation Set ---")
    for a, m in benchmark_results.items():
        logger.info(f"  {a:18s} -> Val MAE: {m['mae']:.2f} min, RMSE: {m['rmse']:.2f} min, R²: {m['r2']:.3f}")
    logger.info(f"Champion Algorithm: {best_algo} (Val MAE = {best_val_mae:.2f} min)")

    # 7. Final Test Evaluation
    champion_model = candidate_models[best_algo]
    test_metrics = champion_model.evaluate(df_test)
    logger.info(f"Held-out Test Performance: MAE: {test_metrics['mae']:.2f} min, RMSE: {test_metrics['rmse']:.2f} min, R²: {test_metrics['r2']:.3f}")

    # 8. Save Champion Model
    model_save_path = REGISTRY_DIR / f"{model_version}.joblib"
    champion_model.save(str(model_save_path))

    # 9. Update Model Registry Metadata
    registry_entry = {
        "model_version": model_version,
        "algorithm": best_algo,
        "trained_at": datetime.now().isoformat(),
        "total_records": len(clean_df),
        "train_records": len(df_train),
        "val_records": len(df_val),
        "test_records": len(df_test),
        "metrics": {
            "val_mae": best_val_mae,
            "test_mae": test_metrics["mae"],
            "test_rmse": test_metrics["rmse"],
            "test_r2": test_metrics["r2"]
        },
        "status": "PRODUCTION",
        "file_path": str(model_save_path)
    }

    registry_data = {}
    if REGISTRY_FILE.exists():
        try:
            with open(REGISTRY_FILE, "r", encoding="utf-8") as f:
                registry_data = json.load(f)
        except Exception:
            registry_data = {}

    # Update previous active models to STAGING/RETIRED
    for k, v in registry_data.items():
        if v.get("status") == "PRODUCTION":
            v["status"] = "RETIRED"

    registry_data[model_version] = registry_entry

    with open(REGISTRY_FILE, "w", encoding="utf-8") as f:
        json.dump(registry_data, f, indent=2)

    logger.info(f"Model Registry updated successfully at: {REGISTRY_FILE}")
    logger.info("=== DURATION MODEL TRAINING COMPLETE ===")
    return champion_model


if __name__ == "__main__":
    run_training_experiment()
