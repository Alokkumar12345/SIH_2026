# SIH_2026/backend/app/auth.py
import os
import json
import logging
from pathlib import Path
from datetime import datetime, timedelta, timezone
from typing import Optional, Dict, Any, List
import jwt
from pydantic import BaseModel
import bcrypt
import psycopg2
from psycopg2.extras import RealDictCursor

from app.database import NEON_TMS_URL

logger = logging.getLogger("IMBPS.Auth")

SECRET_KEY = os.getenv("JWT_SECRET", "imbps-railway-secret-key-2026-secure-tier-alpha")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 8

DATA_DIR = Path("c:/IMBPS/data")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Safely verifies bcrypt hashed password without passlib attribute errors."""
    if not hashed_password:
        return False
    try:
        if hashed_password.startswith("$2b$") or hashed_password.startswith("$2a$"):
            return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))
        return plain_password == hashed_password
    except Exception:
        return False


def hash_password(password: str) -> str:
    """Hashes a password with bcrypt."""
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


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


# Static fallback profiles without plaintext passwords
USERS_DB: Dict[str, Dict[str, Any]] = {
    "railway_central": {
        "profile": {
            "username": "railway_central", "name": "Shri Ashwini Vaishnaw / Member Infrastructure",
            "role": "central_admin", "role_display": "Centralized Railway Board Admin (All-India)",
            "zone": "All Zones", "zone_code": "ALL", "division": "All Divisions", "division_code": "ALL",
            "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None, "section_display": "All Sections"
        }
    },
    "zone_er": {
        "profile": {
            "username": "zone_er", "name": "General Manager / PCE, Eastern Railway",
            "role": "zonal_admin", "role_display": "Zonal Level Admin (Eastern Railway)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "All Divisions (ASN, HWH, SDAH, MLDT)", "division_code": "ER_ALL",
            "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None, "section_display": "All Zonal Sections"
        }
    },
    "zone_nr": {
        "profile": {
            "username": "zone_nr", "name": "Principal Chief Engineer, Northern Railway",
            "role": "zonal_admin", "role_display": "Zonal Level Admin (Northern Railway)",
            "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "All Divisions (UMB, DLI, FZR, LKO, MB)", "division_code": "NR_ALL",
            "department": None, "department_display": "All Departments (TMS, SMMS, TDMS)",
            "section": None, "section_display": "All Zonal Sections"
        }
    },
    "div_asn": {
        "profile": {
            "username": "div_asn", "name": "Divisional Railway Manager / Sr. DOM, Asansol",
            "role": "divisional_admin", "role_display": "Divisional Level Admin (Asansol Division)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN",
            "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All ASN Sections", "section_display": "Andal-Sainthia, Asansol-Dhanbad, Sitarampur-Jhajha"
        }
    },
    "div_hwh": {
        "profile": {
            "username": "div_hwh", "name": "Divisional Railway Manager / Sr. DOM, Howrah",
            "role": "divisional_admin", "role_display": "Divisional Level Admin (Howrah Division)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Howrah (HWH)", "division_code": "HWH",
            "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All HWH Sections", "section_display": "Howrah-Bandel, Barddhaman-Khana"
        }
    },
    "div_umb": {
        "profile": {
            "username": "div_umb", "name": "Divisional Railway Manager / Sr. DOM, Ambala",
            "role": "divisional_admin", "role_display": "Divisional Level Admin (Ambala Division)",
            "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "Ambala (UMB)", "division_code": "UMB",
            "department": None, "department_display": "Division-wide (TMS, SMMS, TDMS)",
            "section": "All UMB Sections", "section_display": "Ambala Cantt - Saharanpur, Rajpura - Bhatinda"
        }
    },
    "tms_engineer": {
        "profile": {
            "username": "tms_engineer", "name": "Er. Rajesh Kumar (SSE/P-Way)",
            "role": "section_engineer", "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN",
            "department": "TMS", "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "UDL-SNT", "section_display": "Andal (UDL) - Sainthia (SNT) Section"
        }
    },
    "tms_hwh": {
        "profile": {
            "username": "tms_hwh", "name": "Er. Sourav Ghosh (SSE/P-Way)",
            "role": "section_engineer", "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Howrah (HWH)", "division_code": "HWH",
            "department": "TMS", "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "HWH-BDC", "section_display": "Howrah (HWH) - Bandel (BDC) Main Line"
        }
    },
    "tms_umb": {
        "profile": {
            "username": "tms_umb", "name": "Er. Harpreet Singh (SSE/P-Way)",
            "role": "section_engineer", "role_display": "Section Engineer - Track Management System (TMS)",
            "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "Ambala (UMB)", "division_code": "UMB",
            "department": "TMS", "department_display": "Track Management System (Civil Track / P-Way)",
            "section": "UMB-SRE", "section_display": "Ambala Cantt (UMB) - Saharanpur (SRE) Section"
        }
    },
    "smms_engineer": {
        "profile": {
            "username": "smms_engineer", "name": "Er. Amit Sharma (SSE/Signal)",
            "role": "section_engineer", "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN",
            "department": "SMMS", "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "UDL-SNT", "section_display": "Andal Junction & Associated Interlocking"
        }
    },
    "smms_hwh": {
        "profile": {
            "username": "smms_hwh", "name": "Er. Debabrata Roy (SSE/Signal)",
            "role": "section_engineer", "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Howrah (HWH)", "division_code": "HWH",
            "department": "SMMS", "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "HWH-BDC", "section_display": "Howrah - Bandel Electronic Interlocking"
        }
    },
    "smms_umb": {
        "profile": {
            "username": "smms_umb", "name": "Er. Gurpreet Verma (SSE/Signal)",
            "role": "section_engineer", "role_display": "Section Engineer - Signalling Maintenance Management (SMMS)",
            "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "Ambala (UMB)", "division_code": "UMB",
            "department": "SMMS", "department_display": "Signal & Telecom Maintenance (SMMS)",
            "section": "UMB-SRE", "section_display": "Ambala - Saharanpur Automatic Signalling"
        }
    },
    "tdms_engineer": {
        "profile": {
            "username": "tdms_engineer", "name": "Er. Vikram Sengupta (SSE/TRD)",
            "role": "section_engineer", "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Asansol (ASN)", "division_code": "ASN",
            "department": "TDMS", "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "UDL-SNT", "section_display": "Andal - Sainthia OHE Sub-Division"
        }
    },
    "tdms_hwh": {
        "profile": {
            "username": "tdms_hwh", "name": "Er. Animesh Bose (SSE/TRD)",
            "role": "section_engineer", "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "EASTERN RAILWAY", "zone_code": "ER", "division": "Howrah (HWH)", "division_code": "HWH",
            "department": "TDMS", "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "HWH-BDC", "section_display": "Howrah - Bandel 25kV Traction Sub-Station"
        }
    },
    "tdms_umb": {
        "profile": {
            "username": "tdms_umb", "name": "Er. Jasbir Kaur (SSE/TRD)",
            "role": "section_engineer", "role_display": "Section Engineer - Traction Distribution (TDMS / OHE)",
            "zone": "NORTHERN RAILWAY", "zone_code": "NR", "division": "Ambala (UMB)", "division_code": "UMB",
            "department": "TDMS", "department_display": "Traction Distribution (Electrical TRD / OHE)",
            "section": "UMB-SRE", "section_display": "Ambala - Saharanpur 25kV OHE Maintenance Unit"
        }
    }
}

# Optional: Load generated users into fallback USERS_DB if present
try:
    gen_users_path = DATA_DIR / "generated_users.json"
    if gen_users_path.exists():
        with open(gen_users_path, "r", encoding="utf-8") as f:
            for u in json.load(f):
                uname = u["username"].strip().lower()
                if uname not in USERS_DB:
                    USERS_DB[uname] = {
                        "profile": {
                            "username": u["username"],
                            "name": u.get("name", u["username"]),
                            "role": u.get("role", "section_engineer"),
                            "role_display": u.get("role_display", "Section Engineer"),
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
    """Authenticates against PostgreSQL using bcrypt."""
    clean_username = username.strip().lower()
    clean_password = password.strip()

    try:
        conn = psycopg2.connect(NEON_TMS_URL, connect_timeout=4)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(
            """
            SELECT username, hashed_password, name, role, role_display,
                   zone, zone_code, division, division_code,
                   department, department_display, section, section_display, is_active
            FROM app_users
            WHERE LOWER(username) = %s AND is_active = TRUE
            LIMIT 1;
            """,
            (clean_username,)
        )
        row = cursor.fetchone()
        cursor.close()
        conn.close()

        if row and verify_password(clean_password, row["hashed_password"]):
            profile_dict = dict(row)
            profile_dict.pop("hashed_password", None)
            profile_dict.pop("is_active", None)
            return UserProfile(**profile_dict)
    except Exception as e:
        logger.warning(f"PostgreSQL auth check failed ({e}).")

    return None


def create_access_token(profile: UserProfile) -> str:
    """Generates signed JWT access token."""
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
    """Decodes and validates a JWT access token."""
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except Exception:
        return None


def create_user_by_admin(data: dict, created_by: str) -> bool:
    """Provisions a new staff user into app_users table with bcrypt."""
    try:
        conn = psycopg2.connect(NEON_TMS_URL, connect_timeout=4)
        conn.autocommit = True
        cursor = conn.cursor()
        hashed = hash_password(data["password"])

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