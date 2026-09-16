"""
Sectional Level User Portal Routes for IMBPS.
Supports 3 Engineering Departments:
1. TMS Engineers (Civil Track Management)
2. SMMS Engineers (Signal & Telecom)
3. TDMS Engineers (Traction Distribution / OHE)

Features:
- Section 1: Current Maintenance Report for present week (shown after divisional authorization)
- Section 2: Log Maintenance History form, storing completed work directly in Neon PostgreSQL database
"""

from typing import Optional, Dict, Any, List
from fastapi import APIRouter, HTTPException, Query
from app.database import db_manager
from app.models import LogMaintenanceHistoryRequest

router = APIRouter(prefix="/api/engineer", tags=["Section Engineer Portals"])

@router.get("/current-blocks")
def get_current_authorized_blocks(
    department: str = Query("TMS", description="Department: TMS, SMMS, or TDMS"),
    section: Optional[str] = Query(None, description="Section code, e.g., UDL-SNT")
):
    """
    SECTION 1:
    Displays current maintenance report for present week after divisional authorization.
    """
    blocks = db_manager.get_authorized_blocks_for_engineer(
        dept=department.upper(),
        section=section
    )
    return {
        "department": department.upper(),
        "section": section or "ALL_DEPARTMENT_SECTIONS",
        "authorized_count": len(blocks),
        "authorized_blocks": blocks
    }

@router.post("/log-history")
def log_completed_maintenance_history(payload: LogMaintenanceHistoryRequest):
    """
    SECTION 2:
    Logs maintenance history after completing work for the week.
    Persists data directly to Neon PostgreSQL table for the department
    (tms_maintenance_history, smms_maintenance_history, or tdms_maintenance_history)
    with local JSON mirror.
    """
    record = payload.model_dump()
    result = db_manager.log_completed_maintenance(record)
    return result

@router.get("/my-history")
def get_engineer_logged_history(
    department: str = Query("TMS"),
    division: Optional[str] = Query("Asansol (ASN)"),
    section: Optional[str] = Query(None, description="Section code, e.g., UDL-SNT"),
    limit: int = 50
):
    """
    Retrieves previous maintenance history logged for this engineer's department and designated section.
    """
    history = db_manager.get_maintenance_history(
        dept=department.upper(),
        division=division,
        section=section,
        limit=limit
    )
    return {
        "department": department.upper(),
        "division": division,
        "section": section or "ALL",
        "count": len(history),
        "history": history
    }
