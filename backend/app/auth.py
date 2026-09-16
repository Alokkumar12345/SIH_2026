"""
Authentication and Role-Based Access Control (RBAC) for IMBPS.
Defines user accounts across Central, Zonal, Divisional, and Sectional Engineer tiers.
"""

import os
import json
import logging
from pathlib import Path
from typing import Optional, Dict, Any, List
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor

class UserProfile(BaseModel):
    username: str
    name: str
    role: str               # 'central_admin', 'zonal_admin', 'divisional_admin', 'section_engineer'
    role_display: str
    zone: Optional[str] = None         # 'EASTERN RAILWAY', 'NORTHERN RAILWAY', or None (all)
    zone_code: Optional[str] = None    # 'ER', 'NR', None
    division: Optional[str] = None     # 'Asansol (ASN)', 'Howrah (HWH)', 'Ambala (UMB)', None
    division_code: Optional[str] = None# 'ASN', 'HWH', 'UMB', None
    department: Optional[str] = None   # 'TMS', 'SMMS', 'TDMS', None
    department_display: Optional[str] = None
    section: Optional[str] = None      # e.g. 'UDL-SNT'
    section_display: Optional[str] = None

# Verified Master User Accounts for IMBPS
USERS_DB: Dict[str, Dict[str, Any]] = {
    # 1. Centralized Admin (Railway Board Level)
    "railway_central": {
        "password": "RailBoard@2026",
        "profile": {
            "username": "railway_central",
            "name": "Shri Ashwini Vaishnaw / Member Infrastructure",
            "role": "central_admin",
            "role_display": "Centralized Railway Board Admin (All-India)",
            "zone": "All Zones",
            "zone_code": "ALL",
            "division": "All Divisions",
            "division_code": "ALL",
            "department": None,
            "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None,
            "section_display": "All Sections"
        }
    },

    # 2. Zonal Level Admin (Eastern Railway & Northern Railway)
    "zone_er": {
        "password": "ZonalER@2026",
        "profile": {
            "username": "zone_er",
            "name": "General Manager / PCE, Eastern Railway",
            "role": "zonal_admin",
            "role_display": "Zonal Level Admin (Eastern Railway)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "All Divisions (ASN, HWH, SDAH, MLDT)",
            "division_code": "ER_ALL",
            "department": None,
            "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None,
            "section_display": "All Zonal Sections"
        }
    },
    "zone_nr": {
        "password": "ZonalNR@2026",
        "profile": {
            "username": "zone_nr",
            "name": "Principal Chief Engineer, Northern Railway",
            "role": "zonal_admin",
            "role_display": "Zonal Level Admin (Northern Railway)",
            "zone": "NORTHERN RAILWAY",
            "zone_code": "NR",
            "division": "All Divisions (UMB, DLI, FZR, LKO, MB)",
            "division_code": "NR_ALL",
            "department": None,
            "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None,
            "section_display": "All Zonal Sections"
        }
    },

    # 3. Divisional Level Admin (Asansol, Howrah, Ambala)
    "div_asn": {
        "password": "DivASN@2026",
        "profile": {
            "username": "div_asn",
            "name": "Divisional Railway Manager / Sr. DOM, Asansol",
            "role": "divisional_admin",
            "role_display": "Divisional Level Admin (Asansol Division)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Asansol (ASN)",
            "division_code": "ASN",
            "department": None,
            "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All ASN Sections",
            "section_display": "Andal-Sainthia, Asansol-Dhanbad, Sitarampur-Jhajha"
        }
    },
    "div_hwh": {
        "password": "DivHWH@2026",
        "profile": {
            "username": "div_hwh",
            "name": "Divisional Railway Manager / Sr. DOM, Howrah",
            "role": "divisional_admin",
            "role_display": "Divisional Level Admin (Howrah Division)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Howrah (HWH)",
            "division_code": "HWH",
            "department": None,
            "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All HWH Sections",
            "section_display": "Howrah-Bandel, Barddhaman-Khana"
        }
    },
    "div_umb": {
        "password": "DivUMB@2026",
        "profile": {
            "username": "div_umb",
            "name": "Divisional Railway Manager / Sr. DOM, Ambala",
            "role": "divisional_admin",
            "role_display": "Divisional Level Admin (Ambala Division)",
            "zone": "NORTHERN RAILWAY",
            "zone_code": "NR",
            "division": "Ambala (UMB)",
            "division_code": "UMB",
            "department": None,
            "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All UMB Sections",
            "section_display": "Ambala Cantt - Saharanpur, Rajpura - Bhatinda"
        }
    },

    # 4. User Portals: Sectional Level Engineers
    # (a) TMS Engineers (Civil Track Management)
    "tms_engineer": {
        "password": "TrackEng@2026",
        "profile": {
            "username": "tms_engineer",
            "name": "Er. Rajesh Kumar (SSE/P-Way)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Asansol (ASN)",
            "division_code": "ASN",
            "department": "TMS",
            "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "UDL-SNT",
            "section_display": "Andal (UDL) - Sainthia (SNT) Section"
        }
    },
    "tms_hwh": {
        "password": "TrackHWH@2026",
        "profile": {
            "username": "tms_hwh",
            "name": "Er. Sourav Ghosh (SSE/P-Way)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Howrah (HWH)",
            "division_code": "HWH",
            "department": "TMS",
            "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "HWH-BDC",
            "section_display": "Howrah (HWH) - Bandel (BDC) Main Line"
        }
    },
    "tms_umb": {
        "password": "TrackUMB@2026",
        "profile": {
            "username": "tms_umb",
            "name": "Er. Harpreet Singh (SSE/P-Way)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "NORTHERN RAILWAY",
            "zone_code": "NR",
            "division": "Ambala (UMB)",
            "division_code": "UMB",
            "department": "TMS",
            "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "UMB-SRE",
            "section_display": "Ambala Cantt (UMB) - Saharanpur (SRE) Section"
        }
    },

    # (b) SMMS Engineers (Signal & Telecom)
    "smms_engineer": {
        "password": "SignalEng@2026",
        "profile": {
            "username": "smms_engineer",
            "name": "Er. Amit Sharma (SSE/Signal)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Asansol (ASN)",
            "division_code": "ASN",
            "department": "SMMS",
            "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "UDL-SNT",
            "section_display": "Andal Junction & Associated Interlocking"
        }
    },
    "smms_hwh": {
        "password": "SignalHWH@2026",
        "profile": {
            "username": "smms_hwh",
            "name": "Er. Debabrata Roy (SSE/Signal)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Howrah (HWH)",
            "division_code": "HWH",
            "department": "SMMS",
            "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "HWH-BDC",
            "section_display": "Howrah - Bandel Electronic Interlocking"
        }
    },
    "smms_umb": {
        "password": "SignalUMB@2026",
        "profile": {
            "username": "smms_umb",
            "name": "Er. Gurpreet Verma (SSE/Signal)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "NORTHERN RAILWAY",
            "zone_code": "NR",
            "division": "Ambala (UMB)",
            "division_code": "UMB",
            "department": "SMMS",
            "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "UMB-SRE",
            "section_display": "Ambala - Saharanpur Automatic Signalling"
        }
    },

    # (c) TDMS Engineers (Traction Distribution / OHE)
    "tdms_engineer": {
        "password": "TrdEng@2026",
        "profile": {
            "username": "tdms_engineer",
            "name": "Er. Vikram Sengupta (SSE/TRD)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Asansol (ASN)",
            "division_code": "ASN",
            "department": "TDMS",
            "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "UDL-SNT",
            "section_display": "Andal - Sainthia OHE Sub-Division"
        }
    },
    "tdms_hwh": {
        "password": "TrdHWH@2026",
        "profile": {
            "username": "tdms_hwh",
            "name": "Er. Animesh Bose (SSE/TRD)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "EASTERN RAILWAY",
            "zone_code": "ER",
            "division": "Howrah (HWH)",
            "division_code": "HWH",
            "department": "TDMS",
            "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "HWH-BDC",
            "section_display": "Howrah - Bandel 25kV Traction Sub-Station"
        }
    },
    "tdms_umb": {
        "password": "TrdUMB@2026",
        "profile": {
            "username": "tdms_umb",
            "name": "Er. Jasbir Kaur (SSE/TRD)",
            "role": "section_engineer",
            "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "NORTHERN RAILWAY",
            "zone_code": "NR",
            "division": "Ambala (UMB)",
            "division_code": "UMB",
            "department": "TDMS",
            "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "UMB-SRE",
            "section_display": "Ambala - Saharanpur 25kV OHE Maintenance Unit"
        }
    }
}

logger = logging.getLogger("IMBPS.Auth")
DATA_DIR = Path("c:/IMBPS/data")

# Load generated users into fallback USERS_DB if present
try:
    gen_users_path = DATA_DIR / "generated_users.json"
    if gen_users_path.exists():
        with open(gen_users_path, "r", encoding="utf-8") as f:
            for u in json.load(f):
                uname = u["username"].strip().lower()
                if uname not in USERS_DB:
                    USERS_DB[uname] = {
                        "password": u["hashed_password"],
                        "profile": {
                            "username": u["username"],
                            "name": u["name"],
                            "role": u["role"],
                            "role_display": u["role_display"],
                            "zone": u.get("zone"),
                            "zone_code": u.get("zone_code"),
                            "division": u.get("division"),
                            "division_code": u.get("division_code"),
                            "department": u.get("department"),
                            "department_display": u.get("department_display"),
                            "section": u.get("section"),
                            "section_display": u.get("section_display")
                        }
                    }
except Exception as e:
    logger.warning(f"Could not load generated_users.json into USERS_DB: {e}")

def authenticate_user(username: str, password: str) -> Optional[UserProfile]:
    """
    Authenticates a user against Neon PostgreSQL Cloud (app_users table).
    Falls back gracefully to local USERS_DB in-memory store if offline.
    """
    clean_username = username.strip().lower()
    clean_password = password.strip()

    # 1. Primary: Neon PostgreSQL Cloud
    try:
        from app.database import NEON_TMS_URL
        conn = psycopg2.connect(NEON_TMS_URL, cursor_factory=RealDictCursor, connect_timeout=4)
        cur = conn.cursor()
        cur.execute("""
            SELECT username, hashed_password, name, role, role_display,
                   zone, zone_code, division, division_code, department, department_display,
                   section, section_display, is_active
            FROM app_users
            WHERE LOWER(username) = LOWER(%s) AND is_active = TRUE
            LIMIT 1;
        """, (clean_username,))
        row = cur.fetchone()
        conn.close()

        if row:
            if row["hashed_password"] == clean_password:
                profile_dict = dict(row)
                profile_dict.pop("hashed_password", None)
                profile_dict.pop("is_active", None)
                return UserProfile(**profile_dict)
            else:
                return None
    except Exception as e:
        logger.warning(f"Neon PostgreSQL authentication lookup failed ({e}). Falling back to local store.")

    # 2. Resilient Fallback: In-Memory / Local USERS_DB
    user = USERS_DB.get(clean_username)
    if not user:
        return None
    if user["password"] != clean_password:
        return None
    return UserProfile(**user["profile"])

