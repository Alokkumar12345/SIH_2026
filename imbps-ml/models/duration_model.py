"""
ML Model 1: Maintenance Duration Prediction Model for IMBPS.
Predicts actual execution duration in minutes for maintenance blocks
across TMS, SMMS, and TDMS activities.
"""

import logging
from typing import Dict, Any, List, Optional, Tuple
import numpy as np
import pandas as pd
import joblib
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.linear_model import Ridge
from sklearn.metrics import mean_absolute_error, root_mean_squared_error, r2_score
from sklearn.pipeline import Pipeline

from preprocessing.feature_engineering import FeatureEngineer

logger = logging.getLogger("IMBPS.DurationModel")


class DurationPredictionModel:
    """
    Supervised regression pipeline predicting actual maintenance duration.
    Combines feature extraction, one-hot encoding, scaling, and regressor.
    """

    def __init__(self, algorithm: str = "RandomForest", model_version: str = "duration_v1"):
        self.algorithm = algorithm
        self.model_version = model_version
        self.feature_engineer = FeatureEngineer()
        self.model: Optional[Any] = None
        self.pipeline: Optional[Pipeline] = None
        self.is_trained: bool = False
        self.metrics: Dict[str, float] = {}

    def _get_regressor(self) -> Any:
        if self.algorithm == "RandomForest":
            return RandomForestRegressor(n_estimators=120, max_depth=12, min_samples_split=4, random_state=42, n_jobs=-1)
        elif self.algorithm == "GradientBoosting":
            return GradientBoostingRegressor(n_estimators=100, max_depth=5, learning_rate=0.08, random_state=42)
        elif self.algorithm == "Linear":
            return Ridge(alpha=1.0)
        else:
            raise ValueError(f"Unknown regressor algorithm: {self.algorithm}")

    def train(self, df_train: pd.DataFrame) -> Dict[str, float]:
        """Trains the duration model on training dataframe."""
        logger.info(f"Training Duration Model [{self.model_version}] using {self.algorithm} on {len(df_train)} records...")
        
        # Fit feature preprocessor on training data
        preprocessor = self.feature_engineer.fit_preprocessor(df_train)
        
        # Target variable
        y_train = df_train["actual_duration_min"].values

        # Build end-to-end pipeline
        raw_feat_train = self.feature_engineer.extract_raw_features(df_train)
        self.model = self._get_regressor()
        
        self.pipeline = Pipeline([
            ("preprocessor", preprocessor),
            ("regressor", self.model)
        ])
        
        self.pipeline.fit(raw_feat_train, y_train)
        self.is_trained = True

        # Training metrics
        y_pred = self.pipeline.predict(raw_feat_train)
        self.metrics = {
            "train_mae": float(mean_absolute_error(y_train, y_pred)),
            "train_rmse": float(root_mean_squared_error(y_train, y_pred)),
            "train_r2": float(r2_score(y_train, y_pred))
        }
        logger.info(f"Training complete. Train MAE: {self.metrics['train_mae']:.2f} min, R²: {self.metrics['train_r2']:.3f}")
        return self.metrics

    def evaluate(self, df_eval: pd.DataFrame) -> Dict[str, float]:
        """Evaluates model performance on validation or test split."""
        if not self.is_trained or self.pipeline is None:
            raise ValueError("Model must be trained before evaluation.")

        raw_feat_eval = self.feature_engineer.extract_raw_features(df_eval)
        y_eval = df_eval["actual_duration_min"].values
        y_pred = self.pipeline.predict(raw_feat_eval)

        eval_metrics = {
            "mae": float(mean_absolute_error(y_eval, y_pred)),
            "rmse": float(root_mean_squared_error(y_eval, y_pred)),
            "r2": float(r2_score(y_eval, y_pred))
        }
        logger.info(f"Evaluation metrics - MAE: {eval_metrics['mae']:.2f} min, RMSE: {eval_metrics['rmse']:.2f} min, R²: {eval_metrics['r2']:.3f}")
        return eval_metrics

    def predict_one(self, job_record: Dict[str, Any]) -> Dict[str, Any]:
        """Predicts actual duration for a single job request dictionary."""
        df_single = pd.DataFrame([job_record])
        pred_val = self.predict_batch(df_single)[0]
        return {
            "job_id": job_record.get("job_id", "UNKNOWN"),
            "requested_duration_min": job_record.get("requested_duration_min", pred_val),
            "predicted_duration_min": round(float(pred_val), 1),
            "model_version": self.model_version
        }

    def predict_batch(self, df: pd.DataFrame) -> np.ndarray:
        """Predicts actual durations for a batch dataframe."""
        if not self.is_trained or self.pipeline is None:
            raise ValueError("Model has not been trained or loaded yet.")
        raw_feat = self.feature_engineer.extract_raw_features(df)
        predictions = self.pipeline.predict(raw_feat)
        # Ensure domain minimum duration clamp (at least 20 min)
        return np.clip(predictions, a_min=20.0, a_max=480.0)

    def save(self, filepath: str):
        """Serializes the trained pipeline to disk."""
        data = {
            "pipeline": self.pipeline,
            "feature_engineer": self.feature_engineer,
            "algorithm": self.algorithm,
            "model_version": self.model_version,
            "metrics": self.metrics,
            "is_trained": self.is_trained
        }
        joblib.dump(data, filepath)
        logger.info(f"Duration model successfully saved to: {filepath}")

    @classmethod
    def load(cls, filepath: str) -> "DurationPredictionModel":
        """Loads a serialized model pipeline from disk."""
        data = joblib.load(filepath)
        instance = cls(algorithm=data["algorithm"], model_version=data["model_version"])
        instance.pipeline = data["pipeline"]
        instance.feature_engineer = data["feature_engineer"]
        instance.metrics = data["metrics"]
        instance.is_trained = data["is_trained"]
        logger.info(f"Duration model [{instance.model_version}] successfully loaded from {filepath}")
        return instance
