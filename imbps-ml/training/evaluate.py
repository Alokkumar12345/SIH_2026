"""
Model Evaluation and Quality Gate verification module for IMBPS.
Verifies whether a candidate model satisfies operational accuracy criteria
before deployment to production.
"""

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.append(str(BASE_DIR))

import logging
from typing import Dict, Any, Tuple
import pandas as pd

from models.duration_model import DurationPredictionModel

logger = logging.getLogger("IMBPS.Evaluate")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class ModelEvaluator:
    """Evaluates candidate model performance against operational thresholds."""

    MAX_ACCEPTABLE_MAE_MINUTES = 15.0  # Quality threshold for railway block grants
    MIN_ACCEPTABLE_R2 = 0.80

    @classmethod
    def evaluate_duration_model(
        cls, model: DurationPredictionModel, df_test: pd.DataFrame
    ) -> Tuple[bool, Dict[str, float], str]:
        """
        Evaluates duration model against test data.
        Returns: (passed_quality_gate, metrics_dict, explanation)
        """
        metrics = model.evaluate(df_test)
        mae = metrics["mae"]
        r2 = metrics["r2"]

        passed = (mae <= cls.MAX_ACCEPTABLE_MAE_MINUTES) and (r2 >= cls.MIN_ACCEPTABLE_R2)
        if passed:
            msg = f"PASSED: MAE={mae:.2f} <= {cls.MAX_ACCEPTABLE_MAE_MINUTES} min, R2={r2:.3f} >= {cls.MIN_ACCEPTABLE_R2}"
        else:
            msg = f"FAILED QUALITY GATE: MAE={mae:.2f} (max {cls.MAX_ACCEPTABLE_MAE_MINUTES}) or R2={r2:.3f} (min {cls.MIN_ACCEPTABLE_R2})"

        logger.info(msg)
        return passed, metrics, msg
