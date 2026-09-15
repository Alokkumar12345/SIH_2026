"""
Feature Engineering module for IMBPS ML models.
Transforms raw maintenance and operational attributes into rich numerical
and categorical feature matrices with strict temporal anti-leakage guarantees.
"""

import logging
from typing import Tuple, List, Dict, Any, Optional
import pandas as pd
import numpy as np
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.pipeline import Pipeline

logger = logging.getLogger("IMBPS.FeatureEngineering")

# Domain Mapping Dictionaries
SEVERITY_SCORES = {"Low": 1.0, "Medium": 2.0, "High": 3.0, "Critical": 4.0}
CRITICALITY_SCORES = {"Low": 1.0, "Medium": 2.0, "High": 3.0, "Critical": 4.0}

HEAVY_MACHINERY = {
    "CSM", "BCM", "Tamping Machine", "Rail Grinder", "Tower Wagon",
    "Oil Filtration Plant", "Ballast Regulator", "UNIMAT"
}

HIGH_DENSITY_SECTIONS = {
    "HWH-KAN (Main line)", "HWH-KAN (Chord line)", "KAN-GMAN",
    "UMB-LDH", "UMB-CDG-KLK", "UMB-SRE", "RPJ-BTI"
}


class FeatureEngineer:
    """Extracts, creates, and encodes features for maintenance models."""

    def __init__(self):
        self.preprocessor: Optional[ColumnTransformer] = None
        self.categorical_features = [
            "department", "division", "line", "asset_type",
            "work_type", "equipment_category"
        ]
        self.numerical_features = [
            "requested_duration_min", "crew_size", "overdue_days",
            "severity_score", "criticality_score", "is_heavy_equipment",
            "traffic_density_factor", "start_hour", "day_of_week",
            "is_night_shadow_block", "is_weekend"
        ]

    def extract_raw_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Derives engineered domain features from raw columns."""
        df = df.copy()

        # Severity & Criticality numerical mappings
        df["severity_score"] = df["severity"].map(lambda x: SEVERITY_SCORES.get(x, 2.0))
        df["criticality_score"] = df["criticality"].map(lambda x: CRITICALITY_SCORES.get(x, 2.0))

        # Equipment classification
        df["is_heavy_equipment"] = df["equipment"].apply(lambda eq: 1.0 if any(h in str(eq) for h in HEAVY_MACHINERY) else 0.0)
        df["equipment_category"] = df["equipment"].apply(
            lambda eq: "Heavy_Machinery" if any(h in str(eq) for h in HEAVY_MACHINERY)
            else ("Testing_Instrument" if "Tester" in str(eq) or "Kit" in str(eq) else "General_Tools")
        )

        # Operational traffic density factor
        df["traffic_density_factor"] = df["section"].apply(lambda sec: 1.0 if sec in HIGH_DENSITY_SECTIONS else 0.5)

        # Temporal features
        if "actual_start" in df.columns:
            ts = pd.to_datetime(df["actual_start"])
            df["start_hour"] = ts.dt.hour
            df["day_of_week"] = ts.dt.dayofweek
            df["is_night_shadow_block"] = df["start_hour"].apply(lambda h: 1.0 if 0 <= h <= 4 else 0.0)
            df["is_weekend"] = df["day_of_week"].apply(lambda d: 1.0 if d in (5, 6) else 0.0)
        else:
            df["start_hour"] = 12
            df["day_of_week"] = 2
            df["is_night_shadow_block"] = 0.0
            df["is_weekend"] = 0.0

        return df

    def build_preprocessor(self) -> ColumnTransformer:
        """Builds a scikit-learn ColumnTransformer for categorical & numerical encoding."""
        cat_transformer = OneHotEncoder(handle_unknown="ignore", sparse_output=False)
        num_transformer = StandardScaler()

        self.preprocessor = ColumnTransformer(
            transformers=[
                ("cat", cat_transformer, self.categorical_features),
                ("num", num_transformer, self.numerical_features)
            ],
            remainder="drop"
        )
        return self.preprocessor

    def fit_preprocessor(self, df_train: pd.DataFrame) -> ColumnTransformer:
        """Fits preprocessor strictly on training data to prevent data leakage."""
        df_feat = self.extract_raw_features(df_train)
        preprocessor = self.build_preprocessor()
        preprocessor.fit(df_feat)
        self.preprocessor = preprocessor
        return self.preprocessor

    def transform(self, df: pd.DataFrame) -> np.ndarray:
        """Transforms features using the fitted preprocessor."""
        if self.preprocessor is None:
            raise ValueError("Preprocessor has not been fitted yet!")
        df_feat = self.extract_raw_features(df)
        return self.preprocessor.transform(df_feat)
