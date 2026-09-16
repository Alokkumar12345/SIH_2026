import json
from pathlib import Path
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, status, Query
import psycopg2
from psycopg2.extras import RealDictCursor

from app.auth import authenticate_user, USERS_DB
from app.models import LoginRequest, LoginResponse
from app.database import NEON_TMS_URL

router = APIRouter(prefix="/api/auth", tags=["Authentication"])

HIERARCHY_FILE = Path("c:/IMBPS/data/all_railway_entities.json")

@router.post("/login", response_model=LoginResponse)
def login(request: LoginRequest):
    profile = authenticate_user(request.username, request.password)
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Indian Railways User ID or Password."
        )
    # Generate mock session token
    token = f"IMBPS-IR-TOKEN-{profile.role.upper()}-{profile.username}"
    return LoginResponse(
        token=token,
        user=profile.model_dump()
    )

@router.get("/accounts")
def get_accounts(
    role: Optional[str] = Query(None, description="Filter by role: central_admin, zonal_admin, divisional_admin, section_engineer"),
    zone: Optional[str] = Query(None, description="Filter by zone name or code"),
    division: Optional[str] = Query(None, description="Filter by division name or code"),
    department: Optional[str] = Query(None, description="Filter by department: TMS, SMMS, TDMS, COA"),
    search: Optional[str] = Query(None, description="Search by username, officer name, or section"),
    limit: int = Query(1000, description="Max accounts to return")
):
    """
    Returns verified railway accounts directly from Neon PostgreSQL Cloud app_users table,
    with filtering across all Zones, Divisions, Sections, and Engineering Departments.
    """
    accounts = []
    try:
        conn = psycopg2.connect(NEON_TMS_URL, cursor_factory=RealDictCursor, connect_timeout=4)
        cur = conn.cursor()
        query = """
            SELECT username, hashed_password as password, name, role, role_display,
                   zone, zone_code, division, division_code,
                   department, department_display, section, section_display
            FROM app_users
            WHERE is_active = TRUE
        """
        params = []
        if role and role != "ALL":
            query += " AND role = %s"
            params.append(role)
        if zone and zone != "ALL":
            query += " AND (zone ILIKE %s OR zone_code ILIKE %s)"
            params.extend([f"%{zone}%", f"%{zone}%"])
        if division and division != "ALL":
            query += " AND (division ILIKE %s OR division_code ILIKE %s)"
            params.extend([f"%{division}%", f"%{division}%"])
        if department and department != "ALL":
            query += " AND department ILIKE %s"
            params.append(f"%{department}%")
        if search:
            query += " AND (name ILIKE %s OR username ILIKE %s OR section_display ILIKE %s OR division ILIKE %s)"
            params.extend([f"%{search}%", f"%{search}%", f"%{search}%", f"%{search}%"])
        query += f" ORDER BY id ASC LIMIT {limit};"
        cur.execute(query, tuple(params))
        rows = cur.fetchall()
        conn.close()
        for r in rows:
            accounts.append(dict(r))
        return accounts
    except Exception as e:
        # Fallback to local USERS_DB
        for uname, data in USERS_DB.items():
            prof = data.get("profile", {})
            # apply simple filtering
            if role and role != "ALL" and prof.get("role") != role:
                continue
            if zone and zone != "ALL" and zone.lower() not in str(prof.get("zone", "")).lower() and zone.lower() not in str(prof.get("zone_code", "")).lower():
                continue
            if division and division != "ALL" and division.lower() not in str(prof.get("division", "")).lower():
                continue
            if department and department != "ALL" and department.lower() not in str(prof.get("department", "")).lower():
                continue
            accounts.append({
                "username": uname,
                "password": data["password"],
                "name": prof.get("name"),
                "role": prof.get("role"),
                "role_display": prof.get("role_display"),
                "zone": prof.get("zone"),
                "zone_code": prof.get("zone_code"),
                "division": prof.get("division"),
                "division_code": prof.get("division_code"),
                "department": prof.get("department"),
                "department_display": prof.get("department_display"),
                "section": prof.get("section"),
                "section_display": prof.get("section_display")
            })
            if len(accounts) >= limit:
                break
        return accounts

@router.get("/stats")
def get_auth_stats():
    """
    Returns live statistics of accounts, zones, divisions, and sections synced in Neon Cloud.
    """
    try:
        conn = psycopg2.connect(NEON_TMS_URL, cursor_factory=RealDictCursor, connect_timeout=4)
        cur = conn.cursor()
        cur.execute("""
            SELECT 
                COUNT(*) as total_users,
                COUNT(DISTINCT zone_code) as total_zones,
                COUNT(DISTINCT division_code) as total_divisions,
                COUNT(DISTINCT section) as total_sections
            FROM app_users
            WHERE is_active = TRUE;
        """)
        totals = cur.fetchone()
        
        cur.execute("""
            SELECT role, COUNT(*) as count
            FROM app_users
            WHERE is_active = TRUE
            GROUP BY role;
        """)
        by_role = {r["role"]: r["count"] for r in cur.fetchall()}

        cur.execute("""
            SELECT COALESCE(department, 'ALL_DEPTS') as dept, COUNT(*) as count
            FROM app_users
            WHERE is_active = TRUE
            GROUP BY department;
        """)
        by_dept = {r["dept"]: r["count"] for r in cur.fetchall()}
        conn.close()

        return {
            "status": "ONLINE",
            "neon_synced": True,
            "total_users": totals["total_users"],
            "total_zones": totals["total_zones"],
            "total_divisions": totals["total_divisions"],
            "total_sections": totals["total_sections"],
            "by_role": by_role,
            "by_department": by_dept
        }
    except Exception as e:
        return {
            "status": "FALLBACK",
            "neon_synced": False,
            "total_users": len(USERS_DB),
            "message": str(e)
        }

@router.get("/railway-hierarchy")
def get_railway_hierarchy():
    """
    Returns full railway hierarchy (16 Zones, 35 Divisions, 98 Sections)
    mapped across TMS, SMMS, TDMS, and COA.
    """
    if HIERARCHY_FILE.exists():
        with open(HIERARCHY_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


