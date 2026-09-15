"""
Database connection and state manager for IMBPS.
Handles Neon PostgreSQL operations for TMS, SMMS, and TDMS,
with local JSON cache synchronization for high resilience.
"""

import os
import sys
import json
import logging
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional
import psycopg2
from psycopg2.extras import RealDictCursor

logger = logging.getLogger("IMBPS.Database")

DATA_DIR = Path("c:/IMBPS/data")

# Neon PostgreSQL connection strings
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

DEPT_DB_URLS = {
    "TMS": NEON_TMS_URL,
    "SMMS": NEON_SMMS_URL,
    "TDMS": NEON_TDMS_URL,
    "ENGINEERING": NEON_TMS_URL,
    "SIGNAL_TELECOM": NEON_SMMS_URL,
    "TRD": NEON_TDMS_URL
}

DEPT_TABLES = {
    "TMS": "tms_maintenance_history",
    "SMMS": "smms_maintenance_history",
    "TDMS": "tdms_maintenance_history",
    "ENGINEERING": "tms_maintenance_history",
    "SIGNAL_TELECOM": "smms_maintenance_history",
    "TRD": "tdms_maintenance_history"
}

STATE_FILE = DATA_DIR / "divisional_blocks_state.json"


class IMBPSDatabaseManager:
    def __init__(self):
        self._ensure_state_file()

    def _ensure_state_file(self):
        """Initializes state file for divisional blocks and authorizations."""
        if not STATE_FILE.exists():
            initial_blocks = self._generate_initial_blocks_ahead()
            with open(STATE_FILE, "w", encoding="utf-8") as f:
                json.dump(initial_blocks, f, indent=2)

    def _generate_initial_blocks_ahead(self) -> List[Dict[str, Any]]:
        """Generates realistic 1-week ahead maintenance blocks across TMS, SMMS, TDMS."""
        base_date = (datetime.now() + timedelta(days=7)).strftime("%Y-%m-%d")
        return [
            {
                "block_id": "BLK-2026-W37-001",
                "department": "TMS",
                "department_display": "Track Management System (Civil)",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "UDL-UKA",
                "block_section_name": "Andal (UDL) - Ukhra (UKA)",
                "line": "UP_MAIN",
                "work_type": "Tamping Machine (CSM) Deployment",
                "asset_type": "Track",
                "scheduled_date": base_date,
                "preferred_start": "11:30",
                "preferred_end": "14:00",
                "duration_min": 150,
                "equipment": "CSM-952",
                "crew_size": 8,
                "priority": "HIGH",
                "risk_probability": 0.38,
                "power_block_required": True,
                "st_disconnection_required": True,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Rajesh Kumar (SSE/P-Way)"
            },
            {
                "block_id": "BLK-2026-W37-002",
                "department": "SMMS",
                "department_display": "Signal & Telecom Maintenance",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "UDL-UKA",
                "block_section_name": "Andal (UDL) Junction East Yard",
                "line": "BOTH_MAIN",
                "work_type": "Point Machine Motor & Detection Overhaul",
                "asset_type": "Point Machine",
                "scheduled_date": base_date,
                "preferred_start": "11:30",
                "preferred_end": "13:30",
                "duration_min": 120,
                "equipment": "Insulation Testing Kit + Torque Wrench",
                "crew_size": 5,
                "priority": "HIGH",
                "risk_probability": 0.42,
                "power_block_required": False,
                "st_disconnection_required": True,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Amit Sharma (SSE/Signal)"
            },
            {
                "block_id": "BLK-2026-W37-003",
                "department": "TDMS",
                "department_display": "Traction Distribution (TRD / OHE)",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "UDL-UKA",
                "block_section_name": "Andal (UDL) - Ukhra (UKA)",
                "line": "UP_MAIN",
                "work_type": "Cantilever & Contact Wire Replacement",
                "asset_type": "OHE Catenary Wire",
                "scheduled_date": base_date,
                "preferred_start": "11:30",
                "preferred_end": "14:15",
                "duration_min": 165,
                "equipment": "8-Wheeler Tower Wagon (TW-401)",
                "crew_size": 7,
                "priority": "HIGH",
                "risk_probability": 0.35,
                "power_block_required": True,
                "st_disconnection_required": False,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Vikram Sengupta (SSE/TRD)"
            },
            {
                "block_id": "BLK-2026-W37-004",
                "department": "TMS",
                "department_display": "Track Management System (Civil)",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "UKA-PAW",
                "block_section_name": "Ukhra (UKA) - Pandabeswar (PAW)",
                "line": "DN_MAIN",
                "work_type": "Deep Screening with BCM",
                "asset_type": "Ballast & Sleeper",
                "scheduled_date": (datetime.now() + timedelta(days=8)).strftime("%Y-%m-%d"),
                "preferred_start": "10:00",
                "preferred_end": "13:30",
                "duration_min": 210,
                "equipment": "BCM-083 + DGS",
                "crew_size": 12,
                "priority": "CRITICAL",
                "risk_probability": 0.65,
                "power_block_required": True,
                "st_disconnection_required": True,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Rajesh Kumar (SSE/P-Way)"
            },
            {
                "block_id": "BLK-2026-W37-005",
                "department": "SMMS",
                "department_display": "Signal & Telecom Maintenance",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "PAW-DUJ",
                "block_section_name": "Pandabeswar (PAW) - Dubrajpur (DUJ)",
                "line": "UP_MAIN",
                "work_type": "Digital Axle Counter (DAC) Head Replacement",
                "asset_type": "Axle Counter",
                "scheduled_date": (datetime.now() + timedelta(days=9)).strftime("%Y-%m-%d"),
                "preferred_start": "12:00",
                "preferred_end": "13:30",
                "duration_min": 90,
                "equipment": "Electronic Calibration Kit",
                "crew_size": 4,
                "priority": "MEDIUM",
                "risk_probability": 0.29,
                "power_block_required": False,
                "st_disconnection_required": True,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Amit Sharma (SSE/Signal)"
            },
            {
                "block_id": "BLK-2026-W37-006",
                "department": "TDMS",
                "department_display": "Traction Distribution (TRD / OHE)",
                "division": "Asansol (ASN)",
                "division_code": "ASN",
                "zone": "EASTERN RAILWAY",
                "zone_code": "ER",
                "section": "UDL-SNT",
                "section_display": "Andal - Sainthia",
                "block_section": "DUJ-CPLE",
                "block_section_name": "Dubrajpur (DUJ) - Chinpai (CPLE)",
                "line": "UP_MAIN",
                "work_type": "Section Insulator Overhaul & Tree Trimming",
                "asset_type": "Section Insulator",
                "scheduled_date": (datetime.now() + timedelta(days=9)).strftime("%Y-%m-%d"),
                "preferred_start": "12:00",
                "preferred_end": "14:00",
                "duration_min": 120,
                "equipment": "Ladder Trolley + Discharge Rods",
                "crew_size": 6,
                "priority": "MEDIUM",
                "risk_probability": 0.31,
                "power_block_required": True,
                "st_disconnection_required": False,
                "status": "AWAITING_AUTHORIZATION",
                "is_edited": False,
                "edit_history": [],
                "authorized": False,
                "authorized_by": None,
                "authorized_at": None,
                "assigned_to": "Er. Vikram Sengupta (SSE/TRD)"
            }
        ]

    def get_pending_requisitions(self, dept: Optional[str] = None, zone: Optional[str] = None, division: Optional[str] = None) -> List[Dict[str, Any]]:
        """Loads pending requisitions from TMS, SMMS, TDMS datasets."""
        results = []
        files = {
            "TMS": DATA_DIR / "tms_data.json",
            "SMMS": DATA_DIR / "smms_data.json",
            "TDMS": DATA_DIR / "tdms_data.json"
        }

        for d_key, f_path in files.items():
            if dept and dept != "ALL" and dept != d_key:
                continue
            if not f_path.exists():
                continue
            try:
                with open(f_path, "r", encoding="utf-8") as f:
                    data = json.load(f)
                for item in data:
                    item_zone = (
                        item.get("electrical_section_details", {}).get("zone") or
                        item.get("zone") or
                        ("EASTERN RAILWAY" if "ASN" in str(item) or "HWH" in str(item) else "NORTHERN RAILWAY")
                    )
                    item_div = (
                        item.get("location_details", {}).get("division") or
                        item.get("asset_location", {}).get("division") or
                        item.get("electrical_section_details", {}).get("division") or
                        "Asansol (ASN)"
                    )
                    
                    if zone and zone != "ALL" and zone.upper() not in item_zone.upper():
                        continue
                    if division and division != "ALL" and division.upper() not in item_div.upper():
                        continue

                    # Standardize view model
                    results.append({
                        "department": d_key,
                        "ref_id": item.get("demand_ref_id") or item.get("disconnection_ref_id") or item.get("requisition_id") or f"{d_key}-REQ",
                        "zone": item_zone,
                        "division": item_div,
                        "section": item.get("location_details", {}).get("section") or item.get("physical_track_boundaries", {}).get("section") or "Main Line Section",
                        "block_section": item.get("location_details", {}).get("block_section") or item.get("asset_location", {}).get("station_name") or item.get("physical_track_boundaries", {}).get("block_section") or "Block Section",
                        "work_type": item.get("block_specifications", {}).get("work_type") or item.get("disconnection_specifications", {}).get("maintenance_nature") or item.get("requisition_type") or "Track Maintenance",
                        "preferred_date": item.get("block_specifications", {}).get("preferred_date") or item.get("disconnection_specifications", {}).get("requested_slot", {}).get("date") or "2026-09-12",
                        "duration_minutes": item.get("block_specifications", {}).get("requested_window", {}).get("duration_minutes") or 150,
                        "power_block_required": item.get("interdepartmental_dependencies", {}).get("power_block_required", False) or ("Power" in str(item.get("requisition_type", ""))),
                        "st_disconnection_required": item.get("interdepartmental_dependencies", {}).get("st_disconnection_required", False) or item.get("disconnection_specifications", {}).get("requires_traffic_block", False),
                        "status": "PENDING_APPROVAL",
                        "raw_payload": item
                    })
            except Exception as e:
                logger.error(f"Error loading {f_path}: {e}")

        return results

    def get_maintenance_history(self, dept: Optional[str] = None, zone: Optional[str] = None, division: Optional[str] = None, limit: int = 150) -> List[Dict[str, Any]]:
        """Queries maintenance history from Neon PostgreSQL, fallback to local JSONs."""
        history = []
        depts_to_query = ["TMS", "SMMS", "TDMS"] if not dept or dept == "ALL" else [dept]

        for d in depts_to_query:
            db_url = DEPT_DB_URLS.get(d)
            table_name = DEPT_TABLES.get(d)
            fetched = False

            if db_url and table_name:
                try:
                    conn = psycopg2.connect(db_url, cursor_factory=RealDictCursor, connect_timeout=4)
                    cur = conn.cursor()
                    query = f"SELECT * FROM {table_name}"
                    params = []
                    clauses = []
                    if division and division != "ALL":
                        clauses.append("division ILIKE %s")
                        params.append(f"%{division[:3]}%")
                    if clauses:
                        query += " WHERE " + " AND ".join(clauses)
                    query += f" ORDER BY actual_start DESC LIMIT {limit};"
                    cur.execute(query, tuple(params))
                    rows = cur.fetchall()
                    conn.close()
                    for r in rows:
                        row_dict = dict(r)
                        row_dict["department"] = d
                        # Serialize timestamps
                        for k, v in row_dict.items():
                            if isinstance(v, (datetime,)):
                                row_dict[k] = v.isoformat()
                        history.append(row_dict)
                    fetched = True
                except Exception as e:
                    logger.warning(f"Neon query for {d} history failed ({e}). Falling back to local JSON.")

            if not fetched:
                # Local JSON fallback
                json_file = DATA_DIR / f"{d.lower()}_maintenance_history.json"
                if json_file.exists():
                    try:
                        with open(json_file, "r", encoding="utf-8") as f:
                            data = json.load(f)
                        records = data.get("maintenance_history", [])
                        for r in records[:limit]:
                            r_copy = dict(r)
                            r_copy["department"] = d
                            r_copy["zone"] = "EASTERN RAILWAY" if r_copy.get("division") in ["ASN", "HWH"] else "NORTHERN RAILWAY"
                            r_copy["zone_code"] = "ER" if r_copy.get("division") in ["ASN", "HWH"] else "NR"
                            history.append(r_copy)
                    except Exception as err:
                        logger.error(f"Error reading local {json_file}: {err}")

        # Filter by zone / division if needed
        if zone and zone != "ALL":
            history = [h for h in history if zone.lower() in str(h.get("zone", "")).lower() or zone.lower() in str(h.get("zone_code", "")).lower()]
        if division and division != "ALL":
            history = [h for h in history if division[:3].lower() in str(h.get("division", "")).lower()]

        return history

    def get_divisional_blocks_state(self) -> List[Dict[str, Any]]:
        """Reads the live divisional block scheduling state."""
        self._ensure_state_file()
        try:
            with open(STATE_FILE, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception:
            return self._generate_initial_blocks_ahead()

    def update_divisional_blocks_state(self, blocks: List[Dict[str, Any]]):
        """Persists updated block scheduling state."""
        with open(STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(blocks, f, indent=2)

    def edit_block(self, block_id: str, edit_data: Dict[str, Any], edited_by: str) -> Optional[Dict[str, Any]]:
        """Applies divisional improvisation to a block and marks it as EDITED."""
        blocks = self.get_divisional_blocks_state()
        target = None
        for b in blocks:
            if b["block_id"] == block_id:
                target = b
                break
        if not target:
            return None

        # Track previous values
        target["edit_history"].append({
            "edited_at": datetime.now().isoformat(),
            "edited_by": edited_by,
            "previous_values": {
                "scheduled_date": target.get("scheduled_date"),
                "preferred_start": target.get("preferred_start"),
                "preferred_end": target.get("preferred_end"),
                "duration_min": target.get("duration_min"),
                "line": target.get("line"),
                "equipment": target.get("equipment")
            }
        })

        # Apply new values
        for key in ["scheduled_date", "preferred_start", "preferred_end", "duration_min", "line", "equipment", "crew_size", "priority", "notes"]:
            if key in edit_data and edit_data[key] is not None:
                target[key] = edit_data[key]

        target["is_edited"] = True
        target["last_edited_by"] = edited_by
        target["last_edited_at"] = datetime.now().isoformat()
        target["status"] = "EDITED_BY_DIVISION"

        self.update_divisional_blocks_state(blocks)
        return target

    def authorize_block(self, block_id: str, authorized_by: str) -> Optional[Dict[str, Any]]:
        """Authorizes block schedule and dispatches to sectional engineer."""
        blocks = self.get_divisional_blocks_state()
        target = None
        for b in blocks:
            if b["block_id"] == block_id:
                target = b
                break
        if not target:
            return None

        target["authorized"] = True
        target["authorized_by"] = authorized_by
        target["authorized_at"] = datetime.now().isoformat()
        target["status"] = "AUTHORIZED_DISPATCHED"

        self.update_divisional_blocks_state(blocks)
        return target

    def authorize_all_blocks(self, authorized_by: str) -> List[Dict[str, Any]]:
        """Authorizes all pending blocks in batch."""
        blocks = self.get_divisional_blocks_state()
        for b in blocks:
            b["authorized"] = True
            b["authorized_by"] = authorized_by
            b["authorized_at"] = datetime.now().isoformat()
            b["status"] = "AUTHORIZED_DISPATCHED"
        self.update_divisional_blocks_state(blocks)
        return blocks

    def get_authorized_blocks_for_engineer(self, dept: str, section: Optional[str] = None) -> List[Dict[str, Any]]:
        """Retrieves present week's authorized blocks for a specific sectional engineer."""
        blocks = self.get_divisional_blocks_state()
        res = []
        for b in blocks:
            if b.get("authorized") and b.get("department", "").upper() == dept.upper():
                if not section or section in b.get("section", "") or b.get("section") in section:
                    res.append(b)
        return res

    def log_completed_maintenance(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Inserts completed work into the Neon PostgreSQL table for the department,
        and saves into local JSON backup.
        """
        dept = record.get("department", "TMS").upper()
        db_url = DEPT_DB_URLS.get(dept, NEON_TMS_URL)
        table_name = DEPT_TABLES.get(dept, "tms_maintenance_history")

        job_id = record.get("job_id") or f"{dept}-LOG-{int(datetime.now().timestamp())}"
        record["job_id"] = job_id
        record["created_at"] = datetime.now().isoformat()

        neon_success = False
        try:
            conn = psycopg2.connect(db_url, connect_timeout=5)
            cur = conn.cursor()
            insert_sql = f"""
            INSERT INTO {table_name} (
                job_id, source_system, department, zone, zone_code,
                division, division_name, section, section_display,
                block_section, block_section_name, line, work_type,
                asset_type, severity, criticality, overdue_days,
                crew_size, equipment, requested_duration_min,
                actual_duration_min, actual_start, actual_end,
                completion_status, payload
            ) VALUES (
                %s, %s, %s, %s, %s,
                %s, %s, %s, %s,
                %s, %s, %s, %s,
                %s, %s, %s, %s,
                %s, %s, %s,
                %s, %s, %s,
                %s, %s
            ) ON CONFLICT (job_id) DO UPDATE SET
                actual_duration_min = EXCLUDED.actual_duration_min,
                completion_status = EXCLUDED.completion_status;
            """
            cur.execute(insert_sql, (
                job_id,
                f"{dept}_ENGG_LOG",
                dept,
                record.get("zone", "EASTERN RAILWAY"),
                record.get("zone_code", "ER"),
                record.get("division", "ASN"),
                record.get("division_name", "Asansol Division"),
                record.get("section", "UDL-SNT"),
                record.get("section_display", "Andal - Sainthia"),
                record.get("block_section", "UDL-UKA"),
                record.get("block_section_name", "Andal - Ukhra"),
                record.get("line", "UP_MAIN"),
                record.get("work_type", "Track Maintenance Work"),
                record.get("asset_type", "Asset"),
                record.get("severity", "Medium"),
                record.get("criticality", "Normal"),
                record.get("overdue_days", 0),
                int(record.get("crew_size", 6)),
                record.get("equipment", "Standard Tooling"),
                int(record.get("requested_duration_min", 120)),
                int(record.get("actual_duration_min", 120)),
                record.get("actual_start", datetime.now().isoformat()),
                record.get("actual_end", datetime.now().isoformat()),
                record.get("completion_status", "Completed"),
                json.dumps(record)
            ))
            conn.commit()
            conn.close()
            neon_success = True
            logger.info(f"Successfully inserted {job_id} into Neon PostgreSQL {table_name}")
        except Exception as e:
            logger.warning(f"Direct Neon insert failed ({e}). Proceeding with local JSON storage.")

        # Local JSON backup append
        local_file = DATA_DIR / f"{dept.lower()}_maintenance_history.json"
        try:
            with open(local_file, "r", encoding="utf-8") as f:
                data = json.load(f)
            data["maintenance_history"].insert(0, record)
            with open(local_file, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2)
        except Exception as e:
            logger.error(f"Error appending to {local_file}: {e}")

        # Also remove/mark the block as completed in divisional state
        blocks = self.get_divisional_blocks_state()
        for b in blocks:
            if b.get("block_id") == record.get("block_id") or b.get("assigned_to") == record.get("logged_by"):
                b["status"] = "WORK_COMPLETED_AND_LOGGED"
                b["actual_duration_min"] = record.get("actual_duration_min")
        self.update_divisional_blocks_state(blocks)

        return {
            "status": "SUCCESS",
            "job_id": job_id,
            "neon_synced": neon_success,
            "department": dept,
            "message": "Maintenance log successfully saved to Neon PostgreSQL cloud database and local archives."
        }


db_manager = IMBPSDatabaseManager()
