"""
Authentication and Role-Based Access Control (RBAC) for IMBPS.
Defines user accounts across Central, Zonal, Divisional, and Sectional Engineer tiers.
"""

from typing import Optional, Dict, Any
from pydantic import BaseModel

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
    # (a) TMS Engineer (Civil Track Management)
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

    # (b) SMMS Engineer (Signal & Telecom)
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

    # (c) TDMS Engineer (Traction Distribution / OHE)
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
    }
}

def authenticate_user(username: str, password: str) -> Optional[UserProfile]:
    user = USERS_DB.get(username.strip().lower())
    if not user:
        return None
    if user["password"] != password:
        return None
    return UserProfile(**user["profile"])
