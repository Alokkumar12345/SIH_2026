"""
Data Loader for IMBPS (Integrated Maintenance & Block Planning System).
Combines TMS (Engineering), SMMS (Signal & Telecom), and TDMS (Electrical TRD)
data into a unified analytical dataset for ML modeling and optimization.
Supports both direct Neon PostgreSQL queries and local JSON feeds with full resilience.
"""

import json
import logging
from pathlib import Path
from datetime import datetime
from typing import Optional, Dict, Any, List
import pandas as pd
import psycopg2

from config.settings import (
    NEON_TMS_URL, NEON_SMMS_URL, NEON_TDMS_URL,
    LOCAL_TMS_PATH, LOCAL_SMMS_PATH, LOCAL_TDMS_PATH, LOCAL_COA_PATH
)

logger = logging.getLogger("IMBPS.DataLoader")
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


class IMBPSDataLoader:
    """
    Connects to PostgreSQL tables (tms_maintenance_history, smms_maintenance_history,
    tdms_maintenance_history) and builds a unified analytical DataFrame.
    """

    def __init__(self):
        self.tms_url = NEON_TMS_URL
        self.smms_url = NEON_SMMS_URL
        self.tdms_url = NEON_TDMS_URL

    def _fetch_from_db(self, db_url: str, table_name: str) -> Optional[pd.DataFrame]:
        """Fetch records from a PostgreSQL table."""
        try:
            conn = psycopg2.connect(db_url)
            query = f"""
            SELECT job_id, division, section, block_section, line,
                   department, source_system, work_type, asset_type,
                   severity, criticality, overdue_days, crew_size, equipment,
                   requested_duration_min, actual_duration_min,
                   actual_start, actual_end, completion_status
            FROM {table_name};
            """
            df = pd.read_sql_query(query, conn)
            conn.close()
            logger.info(f"Loaded {len(df)} records from {table_name} via PostgreSQL.")
            return df
        except Exception as e:
            logger.warning(f"PostgreSQL connection to {table_name} failed: {e}. Falling back to local data.")
            return None

    def _fetch_from_json(self, json_path: Path, department: str, source_system: str) -> pd.DataFrame:
        """Fallback to local JSON dataset."""
        if not json_path.exists():
            from config.settings import resolve_data_path
            json_path = resolve_data_path(json_path.name)
        if not json_path.exists():
            raise FileNotFoundError(f"Data file not found at: {json_path}")

        with open(json_path, "r", encoding="utf-8") as f:
            feed = json.load(f)

        records = feed.get("maintenance_history", [])
        df = pd.DataFrame(records)
        df["department"] = feed.get("department", department)
        df["source_system"] = feed.get("source_system", source_system)
        logger.info(f"Loaded {len(df)} records from {json_path.name} (Local JSON).")
        return df

    def get_unified_dataset(self, use_db: bool = True) -> pd.DataFrame:
        """
        Creates the Unified Analytical Dataset by reading TMS, SMMS, and TDMS.
        Returns a single clean pandas DataFrame.
        """
        dfs = []

        # 1. TMS (Civil Engineering)
        tms_df = self._fetch_from_db(self.tms_url, "tms_maintenance_history") if use_db else None
        if tms_df is None or tms_df.empty:
            tms_df = self._fetch_from_json(LOCAL_TMS_PATH, "ENGINEERING", "TMS_CIVIL_ENGG")
        dfs.append(tms_df)

        # 2. SMMS (Signal & Telecom)
        smms_df = self._fetch_from_db(self.smms_url, "smms_maintenance_history") if use_db else None
        if smms_df is None or smms_df.empty:
            smms_df = self._fetch_from_json(LOCAL_SMMS_PATH, "SIGNAL_TELECOM", "SMMS_SIGNAL_TELECOM")
        dfs.append(smms_df)

        # 3. TDMS (Electrical TRD)
        tdms_df = self._fetch_from_db(self.tdms_url, "tdms_maintenance_history") if use_db else None
        if tdms_df is None or tdms_df.empty:
            tdms_df = self._fetch_from_json(LOCAL_TDMS_PATH, "TRD", "TDMS_ELECTRICAL_TRD")
        dfs.append(tdms_df)

        unified_df = pd.concat(dfs, ignore_index=True)
        logger.info(f"Unified Analytical Dataset generated: {len(unified_df)} total records across TMS, SMMS, TDMS.")
        return unified_df

    def get_coa_operational_data(self) -> Dict[str, Any]:
        """Loads COA (Control Office Application) master operational data."""
        coa_path = LOCAL_COA_PATH
        if not coa_path.exists():
            from config.settings import resolve_data_path
            coa_path = resolve_data_path(coa_path.name)
        if not coa_path.exists():
            raise FileNotFoundError(f"COA data file not found at: {coa_path}")

        with open(coa_path, "r", encoding="utf-8") as f:
            coa_data = json.load(f)
        logger.info(f"Loaded COA operational feeds from {coa_path.name}.")
        return coa_data


# Singleton loader instance
data_loader = IMBPSDataLoader()

if __name__ == "__main__":
    df = data_loader.get_unified_dataset(use_db=False)
    print(df.info())
    print("\nDepartment Counts:")
    print(df["department"].value_counts())
