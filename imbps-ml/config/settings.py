"""
Configuration and settings for IMBPS (Integrated Maintenance & Block Planning System).
Provides database connection strings, paths, model registry paths, and optimization defaults.
"""

import os
from pathlib import Path

# Base Paths
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
REGISTRY_DIR = BASE_DIR / "model_registry"
CONFIG_DIR = BASE_DIR / "config"

# Ensure directories exist
DATA_DIR.mkdir(parents=True, exist_ok=True)
REGISTRY_DIR.mkdir(parents=True, exist_ok=True)

# PostgreSQL Neon Database URLs (with fallback to local JSON data)
NEON_TMS_URL = os.getenv(
    "NEON_TMS_URL",
    "postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
)
NEON_SMMS_URL = os.getenv(
    "NEON_SMMS_URL",
    "postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
)
NEON_TDMS_URL = os.getenv(
    "NEON_TDMS_URL",
    "postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
)

def resolve_data_path(filename: str) -> Path:
    candidates = [
        Path("c:/IMBPS/data") / filename,
        Path("c:/IMBPS") / filename,
        DATA_DIR / filename,
        BASE_DIR / filename
    ]
    for c in candidates:
        if c.exists():
            return c
    # Default to data folder
    return Path("c:/IMBPS/data") / filename

# Local Fallback Data Files (IMBPS workspace)
LOCAL_TMS_PATH = resolve_data_path("tms_maintenance_history.json")
LOCAL_SMMS_PATH = resolve_data_path("smms_maintenance_history.json")
LOCAL_TDMS_PATH = resolve_data_path("tdms_maintenance_history.json")
LOCAL_COA_PATH = resolve_data_path("coa_data.json")

# Model Registry Settings
REGISTRY_FILE = REGISTRY_DIR / "registry.json"
DEFAULT_MODEL_VERSION = "duration_v1"
DEFAULT_RISK_VERSION = "risk_v1"
DEFAULT_PRIORITY_VERSION = "priority_v1"

# Optimization Weights & Defaults
OPTIMIZATION_CONFIG = {
    "weight_priority": 10.0,
    "weight_risk_reduction": 8.0,
    "weight_block_utilization": 5.0,
    "weight_train_delay_penalty": 15.0,
    "weight_unused_block_penalty": 4.0,
    "weight_deviation_penalty": 2.0,
    "max_solver_time_seconds": 30,
    "headway_buffer_minutes": 15,
    "power_block_lead_minutes": 10,
    "st_disconnection_lead_minutes": 15
}
