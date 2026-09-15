# SIH_2026/backend/app/auth.py
import os
import logging
from datetime import datetime, timedelta, timezone
from typing import Optional, Dict, Any
import jwt
from pydantic import BaseModel
from passlib.context import CryptContext
import psycopg2
from psycopg2.extras import RealDictCursor

from app.database import NEON_TMS_URL

logger = logging.getLogger("IMBPS.Auth")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = os.getenv("JWT_SECRET", "imbps-railway-secret-key-2026-secure-tier-alpha")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 8

class UserProfile(BaseModel):
    username: str
    name: str
    role: str
    role_display: str
    zone: Optional[str] = None
    zone_code: Optional[str] = None
    division: Optional[str] = None
    division_code: Optional[str] = None
    department: Optional[str] = None
    department_display: Optional[str] = None
    section: Optional[str] = None
    section_display: Optional[str] = None

USERS_DB: Dict[str, Dict[str, Any]] = {
    "railway_central": {"password": "RailBoard@2026", "profile": {"username": "railway_central", "name": "Shri Ashwini Vaishnaw / Member Infrastructure", "role": "central_admin", "role_display": "Centralized Railway Board Admin (All-India)", "zone": "All Zones", "zone_code": "ALL", "division": "All Divisions", "division_code": "ALL", "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)", "section": None, "section_display": "All Sections"}},
    "zone_er": {"password": "ZonalER@2026", "profile": {"username": "zone_er", "name": "General Manager / PCE, Eastern Railway", "role": "zonal_admin", "role_display": "Zonal Level Admin (Eastern Railway)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "All Divisions (ASN, HWH, SDAH, MLDT)", "division_code": "ER_ALL", "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)", "section": None, "section_display": "All Zonal Sections"}},
    "zone_nr": {"password": "ZonalNR@2026", "profile": {"username": "zone_nr", "name": "Principal Chief Engineer, Northern Railway", "role": "zonal_admin", "role_display": "Zonal Level Admin (Northern Railway)", "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "All Divisions (UMB, DLI, FZR, LKO, MB)", "division_code": "NR_ALL", "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)", "section": None, "section_display": "All Zonal Sections"}},
    "div_asn": {"password": "DivASN@2026", "profile": {"username": "div_asn", "name": "Divisional Railway Manager / Sr. DOM, Asansol", "role": "divisional_admin", "role_display": "Divisional Level Admin (Asansol Division)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN", "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)", "section": "All ASN Sections", "section_display": "Andal-Sainthia, Asansol-Dhanbad, Sitarampur-Jhajha"}},
    "div_hwh": {"password": "DivHWH@2026", "profile": {"username": "div_hwh", "name": "Divisional Railway Manager / Sr. DOM, Howrah", "role": "divisional_admin", "role_display": "Divisional Level Admin (Howrah Division)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Howrah (HWH)", "division_code": "HWH", "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)", "section": "All HWH Sections", "section_display": "Howrah-Bandel, Barddhaman-Khana"}},
    "div_umb": {"password": "DivUMB@2026", "profile": {"username": "div_umb", "name": "Divisional Railway Manager / Sr. DOM, Ambala", "role": "divisional_admin", "role_display": "Divisional Level Admin (Ambala Division)", "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "Ambala (UMB)", "division_code": "UMB", "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)", "section": "All UMB Sections", "section_display": "Ambala Cantt - Saharanpur, Rajpura - Bhatinda"}},
    "tms_engineer": {"password": "TrackEng@2026", "profile": {"username": "tms_engineer", "name": "Er. Rajesh Kumar (SSE/P-Way)", "role": "section_engineer", "role_display": "Section Engineer - Track Management System (TMS)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN", "department": "TMS", "department_display": "Track Management System (Civil Track / P-Way)", "section": "UDL-SNT", "section_display": "Andal (UDL) - Sainthia (SNT) Section"}},
    "smms_engineer": {"password": "SignalEng@2026", "profile": {"username": "smms_engineer", "name": "Er. Amit Sharma (SSE/Signal)", "role": "section_engineer", "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN", "department": "SMMS", "department_display": "Signal & Telecom Maintenance (SMMS)", "section": "UDL-SNT", "section_display": "Andal Junction & Associated Interlocking"}},
    "tdms_engineer": {"password": "TrdEng@2026", "profile": {"username": "tdms_engineer", "name": "Er. Vikram Sengupta (SSE/TRD)", "role": "section_engineer", "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)", "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN", "department": "TDMS", "department_display": "Traction Distribution (Electrical TRD / OHE)", "section": "UDL-SNT", "section_display": "Andal - Sainthia OHE Sub-Division"}}
}

def authenticate_user(username: str, password: str) -> Optional[UserProfile]:
    clean_username = username.strip().lower()

    # 1. Primary: PostgreSQL Authentication
    try:
        conn = psycopg2.connect(NEON_TMS_URL, connect_timeout=4)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute("SELECT * FROM app_users WHERE username = %s AND is_active = TRUE", (clean_username,))
        row = cursor.fetchone()
        cursor.close()
        conn.close()

        if row and pwd_context.verify(password, row["hashed_password"]):
            return UserProfile(
                username=row["username"],
                name=row["name"],
                role=row["role"],
                role_display=row["role_display"],
                zone=row["zone"],
                zone_code=row["zone_code"],
                division=row["division"],
                division_code=row["division_code"],
                department=row["department"],
                department_display=row["department_display"],
                section=row["section"],
                section_display=row["section_display"]
            )
    except Exception as e:
        logger.warning(f"PostgreSQL auth check failed ({e}). Checking memory fallback...")

    # 2. Resilient Fallback: Memory store
    fallback = USERS_DB.get(clean_username)
    if fallback and fallback["password"] == password:
        return UserProfile(**fallback["profile"])

    return None

def create_access_token(profile: UserProfile) -> str:
    expire = datetime.now(timezone.utc) + timedelta(hours=ACCESS_TOKEN_EXPIRE_HOURS)
    payload = {
        "sub": profile.username,
        "name": profile.name,
        "role": profile.role,
        "zone_code": profile.zone_code,
        "division_code": profile.division_code,
        "department": profile.department,
        "exp": expire
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def decode_access_token(token: str) -> Optional[Dict[str, Any]]:
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except Exception:
        return None

def create_user_by_admin(data: dict, created_by: str) -> bool:
    try:
        conn = psycopg2.connect(NEON_TMS_URL, connect_timeout=4)
        conn.autocommit = True
        cursor = conn.cursor()
        hashed = pwd_context.hash(data["password"])
        
        insert_sql = """
        INSERT INTO app_users (
            username, hashed_password, name, role, role_display,
            zone, zone_code, division, division_code,
            department, department_display, section, section_display,
            created_by
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(insert_sql, (
            data["username"].strip().lower(),
            hashed,
            data["name"],
            data["role"],
            data["role_display"],
            data.get("zone"),
            data.get("zone_code"),
            data.get("division"),
            data.get("division_code"),
            data.get("department"),
            data.get("department_display"),
            data.get("section"),
            data.get("section_display"),
            created_by
        ))
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        logger.error(f"Error registering user: {e}")
        return False