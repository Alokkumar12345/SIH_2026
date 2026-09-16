import json
from pathlib import Path
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, status, Depends, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor

from app.auth import (
    authenticate_user, 
    create_access_token, 
    decode_access_token, 
    create_user_by_admin,
    USERS_DB
)
from app.models import LoginRequest, LoginResponse
from app.database import NEON_TMS_URL

router = APIRouter(prefix="/api/auth", tags=["Authentication"])
security = HTTPBearer()

DATA_DIR = Path("c:/IMBPS/data")
HIERARCHY_FILE = DATA_DIR / "railway_hierarchy.json"


class CreateEmployeeRequest(BaseModel):
    username: str
    password: str
    name: str
    role: str                       # 'section_engineer', 'divisional_admin', etc.
    role_display: str
    zone: Optional[str] = None
    zone_code: Optional[str] = None
    division: Optional[str] = None
    division_code: Optional[str] = None
    department: Optional[str] = None
    department_display: Optional[str] = None
    section: Optional[str] = None
    section_display: Optional[str] = None


def get_current_user_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Session has expired or token is invalid."
        )
    return payload


# 1. Standard Login Endpoint (JWT signed session)
@router.post("/login", response_model=LoginResponse)
def login(request: LoginRequest):
    profile = authenticate_user(request.username, request.password)
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Indian Railways User ID or Password."
        )
    
    token = create_access_token(profile)
    
    return LoginResponse(
        token=token,
        user=profile.model_dump()
    )


# 2. Engineer/Admin Staff Provisioning Route (Protected)
@router.post("/register-employee")
def register_employee(
    request: CreateEmployeeRequest, 
    current_user: dict = Depends(get_current_user_token)
):
    allowed_creators = ["central_admin", "zonal_admin", "divisional_admin", "section_engineer"]
    if current_user.get("role") not in allowed_creators:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only authorized engineers or administrators can register staff."
        )

    success = create_user_by_admin(request.model_dump(), created_by=current_user.get("sub"))
    if not success:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to create employee. Username may already exist."
        )

    return {"status": "success", "message": f"Account for {request.username} successfully provisioned."}


# 3. Verified Railway Accounts Query (Excludes password hashes)
@router.get("/accounts")
def get_accounts(
    role: Optional[str] = Query(None, description="Filter by role: central_admin, zonal_admin, divisional_admin, section_engineer"),
    zone: Optional[str] = Query(None, description="Filter by zone name or code"),
    division: Optional[str] = Query(None, description="Filter by division name or code"),
    department: Optional[str] = Query(None, description="Filter by department: TMS, SMMS, TDMS, COA"),
    search: Optional[str] = Query(None, description="Search by username, officer name, or section"),
    limit: int = Query(1000, description="Max accounts to return")
):
    accounts = []
    try:
        conn = psycopg2.connect(NEON_TMS_URL, cursor_factory=RealDictCursor, connect_timeout=4)
        cur = conn.cursor()
        query = """
            SELECT username, name, role, role_display,
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
    except Exception:
        # Fallback to in-memory USERS_DB profiles
        for uname, data in USERS_DB.items():
            prof = data.get("profile", {})
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


# 4. Live Statistics for Dashboard Widgets
@router.get("/stats")
def get_auth_stats():
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


# 5. Full Railway Hierarchy
@router.get("/railway-hierarchy")
def get_railway_hierarchy():
    if HIERARCHY_FILE.exists():
        with open(HIERARCHY_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}