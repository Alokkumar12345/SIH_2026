"""
Zonal Level Railway Admin Routes for IMBPS.
Provides divisional breakdown for a specific zone (Eastern Railway, Northern Railway),
pending work totals by division for TMS, SMMS, TDMS, and zonal maintenance history.
"""

from typing import Optional, Dict, Any, List
from fastapi import APIRouter, Query
from app.database import db_manager

router = APIRouter(prefix="/api/zonal", tags=["Zonal Admin"])

@router.get("/divisions-summary")
def get_divisions_pending_summary(
    zone_code: str = Query("ER", description="Zonal Code, e.g., ER or NR"),
    month: Optional[str] = "September 2026"
):
    """
    Returns pending works per division under the given zone (e.g. Asansol, Howrah)
    categorized by TMS, SMMS, and TDMS for the selected month.
    """
    zone_name = "EASTERN RAILWAY" if zone_code.upper() == "ER" else "NORTHERN RAILWAY"
    pending = db_manager.get_pending_requisitions(zone=zone_name)

    # Divisional mapping
    if zone_code.upper() == "ER":
        divs_map = {
            "Asansol (ASN)": {
                "division_code": "ASN",
                "division_name": "Asansol Division",
                "headquarters": "Asansol, West Bengal",
                "tms_pending": 0,
                "smms_pending": 0,
                "tdms_pending": 0,
                "total_pending": 0,
                "key_sections": ["Andal - Sainthia", "Asansol - Dhanbad", "Sitarampur - Jhajha"]
            },
            "Howrah (HWH)": {
                "division_code": "HWH",
                "division_name": "Howrah Division",
                "headquarters": "Howrah, West Bengal",
                "tms_pending": 0,
                "smms_pending": 0,
                "tdms_pending": 0,
                "total_pending": 0,
                "key_sections": ["Howrah - Bandel", "Burdwan - Khana", "Bandel - Katwa"]
            },
            "Sealdah (SDAH)": {
                "division_code": "SDAH",
                "division_name": "Sealdah Division",
                "headquarters": "Kolkata, West Bengal",
                "tms_pending": 0,
                "smms_pending": 0,
                "tdms_pending": 0,
                "total_pending": 0,
                "key_sections": ["Sealdah - Ranaghat", "Barasat - Bongaon"]
            }
        }
    else:
        divs_map = {
            "Ambala (UMB)": {
                "division_code": "UMB",
                "division_name": "Ambala Division",
                "headquarters": "Ambala Cantt, Haryana",
                "tms_pending": 0,
                "smms_pending": 0,
                "tdms_pending": 0,
                "total_pending": 0,
                "key_sections": ["Ambala Cantt - Saharanpur", "Rajpura - Bhatinda", "Kalka - Shimla"]
            },
            "Delhi (DLI)": {
                "division_code": "DLI",
                "division_name": "Delhi Division",
                "headquarters": "New Delhi",
                "tms_pending": 0,
                "smms_pending": 0,
                "tdms_pending": 0,
                "total_pending": 0,
                "key_sections": ["New Delhi - Ghaziabad", "Delhi - Panipat"]
            }
        }

    for item in pending:
        d = item.get("division", "Asansol (ASN)")
        dept = item.get("department", "TMS").upper()
        # Match division
        matched = None
        for div_key in divs_map:
            if div_key[:3].lower() in d.lower() or d[:3].lower() in div_key.lower():
                matched = div_key
                break
        if not matched:
            matched = list(divs_map.keys())[0]

        if dept == "TMS":
            divs_map[matched]["tms_pending"] += 1
        elif dept == "SMMS":
            divs_map[matched]["smms_pending"] += 1
        elif dept == "TDMS":
            divs_map[matched]["tdms_pending"] += 1
        divs_map[matched]["total_pending"] += 1

    div_list = list(divs_map.values())
    total_zonal = sum([d["total_pending"] for d in div_list])
    total_tms = sum([d["tms_pending"] for d in div_list])
    total_smms = sum([d["smms_pending"] for d in div_list])
    total_tdms = sum([d["tdms_pending"] for d in div_list])

    return {
        "zone_code": zone_code.upper(),
        "zone_name": zone_name,
        "month": month,
        "zonal_totals": {
            "total_pending_blocks": total_zonal,
            "tms_civil_pending": total_tms,
            "smms_signal_pending": total_smms,
            "tdms_trd_pending": total_tdms,
            "divisions_count": len(div_list)
        },
        "divisions_data": div_list
    }

@router.get("/pending-works")
def get_zonal_pending_works(
    zone_code: str = Query("ER"),
    division: Optional[str] = None,
    department: Optional[str] = None
):
    """Returns detailed pending requisitions for the selected zone and division."""
    zone_name = "EASTERN RAILWAY" if zone_code.upper() == "ER" else "NORTHERN RAILWAY"
    items = db_manager.get_pending_requisitions(dept=department, zone=zone_name, division=division)
    return {
        "zone_code": zone_code,
        "count": len(items),
        "requisitions": items
    }

@router.get("/maintenance-history")
def get_zonal_maintenance_history(
    zone_code: str = Query("ER"),
    division: Optional[str] = None,
    department: Optional[str] = None,
    timeframe: Optional[str] = "all",
    limit: int = 120
):
    """
    Returns maintenance history records for this zone across previous weeks and months.
    """
    zone_name = "EASTERN RAILWAY" if zone_code.upper() == "ER" else "NORTHERN RAILWAY"
    history = db_manager.get_maintenance_history(dept=department, zone=zone_name, division=division, limit=limit)
    return {
        "zone_code": zone_code,
        "zone_name": zone_name,
        "timeframe": timeframe,
        "count": len(history),
        "history": history
    }
