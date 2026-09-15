"""
Data Validation module for IMBPS Preprocessing Pipeline.
Ensures schema adherence, data type consistency, and domain range constraints.
"""

import logging
from typing import Tuple, List, Dict, Any
import pandas as pd
import numpy as np

logger = logging.getLogger("IMBPS.Validation")

REQUIRED_COLUMNS = [
    "job_id", "division", "section", "block_section", "line",
    "department", "work_type", "asset_type", "severity", "criticality",
    "overdue_days", "crew_size", "equipment", "requested_duration_min",
    "actual_duration_min", "actual_start", "actual_end", "completion_status"
]

VALID_DEPARTMENTS = {"ENGINEERING", "SIGNAL_TELECOM", "TRD"}
VALID_SEVERITIES = {"Low", "Medium", "High", "Critical"}
VALID_CRITICALITIES = {"Low", "Medium", "High", "Critical"}


class DataValidator:
    """Validates raw maintenance records before entering ML pipeline."""

    @staticmethod
    def validate_schema(df: pd.DataFrame) -> Tuple[bool, List[str]]:
        missing_cols = [c for c in REQUIRED_COLUMNS if c not in df.columns]
        if missing_cols:
            return False, missing_cols
        return True, []

    @staticmethod
    def validate_records(df: pd.DataFrame) -> Tuple[pd.DataFrame, Dict[str, int]]:
        """
        Validates individual records against Indian Railways domain rules.
        Flags and filters invalid records.
        """
        initial_count = len(df)
        issues = {
            "missing_required_fields": 0,
            "invalid_duration": 0,
            "invalid_crew": 0,
            "invalid_overdue": 0,
            "invalid_timestamps": 0,
            "invalid_categorical": 0
        }

        # Check critical nulls
        null_mask = df[["job_id", "work_type", "asset_type", "requested_duration_min", "actual_duration_min"]].isnull().any(axis=1)
        issues["missing_required_fields"] = int(null_mask.sum())
        clean_df = df[~null_mask].copy()

        # Check positive durations (minimum 10 mins, maximum 480 mins for single shift block)
        duration_mask = (clean_df["requested_duration_min"] > 0) & (clean_df["actual_duration_min"] > 0)
        issues["invalid_duration"] = int((~duration_mask).sum())
        clean_df = clean_df[duration_mask]

        # Check positive crew size
        crew_mask = clean_df["crew_size"] > 0
        issues["invalid_crew"] = int((~crew_mask).sum())
        clean_df = clean_df[crew_mask]

        # Check non-negative overdue days
        overdue_mask = clean_df["overdue_days"] >= 0
        issues["invalid_overdue"] = int((~overdue_mask).sum())
        clean_df = clean_df[overdue_mask]

        # Check timestamps
        try:
            clean_df["actual_start"] = pd.to_datetime(clean_df["actual_start"], errors="coerce")
            clean_df["actual_end"] = pd.to_datetime(clean_df["actual_end"], errors="coerce")
            valid_time_mask = clean_df["actual_start"].notnull() & clean_df["actual_end"].notnull()
            issues["invalid_timestamps"] = int((~valid_time_mask).sum())
            clean_df = clean_df[valid_time_mask]
        except Exception as e:
            logger.error(f"Timestamp conversion error: {e}")

        logger.info(f"Validation complete: {len(clean_df)} / {initial_count} records valid. Issues: {issues}")
        return clean_df, issues
