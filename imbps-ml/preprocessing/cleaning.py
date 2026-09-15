"""
Data Cleaning module for IMBPS Preprocessing Pipeline.
Handles deduplication, missing value imputation, outlier detection and handling,
and text standardization.
"""

import logging
import pandas as pd
import numpy as np

logger = logging.getLogger("IMBPS.Cleaning")


class DataCleaner:
    """Cleans and prepares validated railway maintenance data."""

    @staticmethod
    def remove_duplicates(df: pd.DataFrame) -> pd.DataFrame:
        """Deduplicates records based on job_id, keeping the latest."""
        initial_len = len(df)
        df_clean = df.drop_duplicates(subset=["job_id"], keep="last")
        removed = initial_len - len(df_clean)
        if removed > 0:
            logger.info(f"Deduplicated {removed} duplicate job_id records.")
        return df_clean

    @staticmethod
    def handle_missing_values(df: pd.DataFrame) -> pd.DataFrame:
        """Imputes missing values using domain-appropriate defaults."""
        df = df.copy()

        # Categorical defaults
        cat_imputations = {
            "line": "UP_MAIN",
            "severity": "Medium",
            "criticality": "Medium",
            "equipment": "Standard Toolkit",
            "completion_status": "Completed"
        }
        for col, default_val in cat_imputations.items():
            if col in df.columns:
                df[col] = df[col].fillna(default_val)

        # Numerical defaults
        if "overdue_days" in df.columns:
            df["overdue_days"] = df["overdue_days"].fillna(0).astype(int)
        if "crew_size" in df.columns:
            median_crew = df["crew_size"].median()
            df["crew_size"] = df["crew_size"].fillna(median_crew).astype(int)

        return df

    @staticmethod
    def handle_outliers(df: pd.DataFrame, lower_dur: int = 20, upper_dur: int = 480) -> pd.DataFrame:
        """
        Clamps extreme durations to domain bounds.
        In Indian Railways, blocks are capped by 8-hour shift maximums (480 mins)
        and rarely less than 20 mins.
        """
        df = df.copy()
        df["actual_duration_min"] = df["actual_duration_min"].clip(lower=lower_dur, upper=upper_dur)
        df["requested_duration_min"] = df["requested_duration_min"].clip(lower=lower_dur, upper=upper_dur)
        return df

    @staticmethod
    def standardize_text(df: pd.DataFrame) -> pd.DataFrame:
        """Standardizes strings by stripping extra whitespaces."""
        df = df.copy()
        str_cols = df.select_dtypes(include=["object"]).columns
        for c in str_cols:
            df[c] = df[c].astype(str).str.strip()
        return df

    @classmethod
    def clean(cls, df: pd.DataFrame) -> pd.DataFrame:
        """Runs the complete cleaning pipeline."""
        df = cls.remove_duplicates(df)
        df = cls.handle_missing_values(df)
        df = cls.handle_outliers(df)
        df = cls.standardize_text(df)
        return df
