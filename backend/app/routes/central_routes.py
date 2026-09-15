"""
Centralized Railway Board Admin Routes for IMBPS.
Provides pan-India zonal aggregation for pending maintenance across TMS, SMMS, TDMS,
national maintenance history archives, and ML model retraining control.
"""

from typing import Optional, Dict, Any, List
from fastapi import APIRouter, Query
from app.database import db_manager
from app.ml_bridge import ml_bridge
from app.models import RetrainModelRequest

router = APIRouter(prefix="/api/central", tags=["Centralized Admin"])

@router.get("/zonal-summary")
def get_zonal_pending_summary(month: Optional[str] = "September 2026"):
    """
    Computes pending works count per zone (Eastern Railway, Northern Railway, etc.)
    for TMS, SMMS, and TDMS for the selected month.
    """
    pending = db_manager.get_pending_requisitions()

    # Pre-structure zones
    zones_map: Dict[str, Dict[str, Any]] = {
        "EASTERN RAILWAY": {
            "zone_code": "ER",
            "zone_name": "Eastern Railway (ER)",
            "headquarters": "Fairlie Place, Kolkata",
            "tms_pending": 0,
            "smms_pending": 0,
            "tdms_pending": 0,
            "total_pending": 0,
            "divisions": ["Asansol (ASN)", "Howrah (HWH)", "Sealdah (SDAH)", "Malda (MLDT)"]
        },
        "NORTHERN RAILWAY": {
            "zone_code": "NR",
            "zone_name": "Northern Railway (NR)",
            "headquarters": "Baroda House, New Delhi",
            "tms_pending": 0,
            "smms_pending": 0,
            "tdms_pending": 0,
            "total_pending": 0,
            "divisions": ["Ambala (UMB)", "Delhi (DLI)", "Firozpur (FZR)", "Moradabad (MB)", "Lucknow (LKO)"]
        }
    }

    for item in pending:
        z = item.get("zone", "EASTERN RAILWAY").upper()
        matched_z = "EASTERN RAILWAY" if "EAST" in z or "ER" in z else "NORTHERN RAILWAY"
        dept = item.get("department", "TMS").upper()

        if matched_z in zones_map:
            if dept == "TMS":
                zones_map[matched_z]["tms_pending"] += 1
            elif dept == "SMMS":
                zones_map[matched_z]["smms_pending"] += 1
            elif dept == "TDMS":
                zones_map[matched_z]["tdms_pending"] += 1
            zones_map[matched_z]["total_pending"] += 1

    summary_list = list(zones_map.values())
    total_national = sum([z["total_pending"] for z in summary_list])
    total_tms = sum([z["tms_pending"] for z in summary_list])
    total_smms = sum([z["smms_pending"] for z in summary_list])
    total_tdms = sum([z["tdms_pending"] for z in summary_list])

    return {
        "month": month,
        "national_totals": {
            "total_pending_blocks": total_national,
            "tms_civil_pending": total_tms,
            "smms_signal_pending": total_smms,
            "tdms_trd_pending": total_tdms,
            "active_zones": len(summary_list)
        },
        "zonal_data": summary_list
    }

@router.get("/pending-works")
def get_all_pending_works(
    zone: Optional[str] = None,
    department: Optional[str] = None,
    division: Optional[str] = None
):
    """Returns detailed pending requisitions with filtering."""
    items = db_manager.get_pending_requisitions(dept=department, zone=zone, division=division)
    return {
        "count": len(items),
        "requisitions": items
    }

@router.get("/maintenance-history")
def get_central_maintenance_history(
    timeframe: Optional[str] = "all", # 'previous_week', 'previous_month', 'all'
    department: Optional[str] = None,
    zone: Optional[str] = None,
    limit: int = 150
):
    """
    Returns maintenance history archives across all zones for previous weeks and months.
    """
    history = db_manager.get_maintenance_history(dept=department, zone=zone, limit=limit)
    return {
        "timeframe": timeframe,
        "total_records": len(history),
        "history": history
    }

@router.post("/train-model")
def trigger_ml_training(payload: RetrainModelRequest):
    """
    Initiates ML training pipeline directly from Central Admin on live Neon PostgreSQL data.
    """
    result = ml_bridge.train_model(trigger_reason=payload.trigger_reason)
    return result

@router.get("/model-status")
def get_ml_model_status():
    """Returns ML model status, active production versions, and evaluation metrics."""
    return ml_bridge.get_model_status()
