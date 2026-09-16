"""
Load existing maintenance data from TMS, SMMS, and TDMS to support
COA Master Timetable conflict correlation and cross-system integration.
"""

import os
import json
from typing import List, Dict, Any

def load_maintenance_records() -> Dict[str, List[Dict[str, Any]]]:
    tms_records = []
    smms_records = []
    tdms_records = []
    
    # 1. TMS records
    tms_path = "c:/IMBPS/data/tms_data.json"
    if os.path.exists(tms_path):
        try:
            with open(tms_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                for item in data:
                    loc = item.get("location_details", {})
                    spec = item.get("block_specifications", {})
                    window = spec.get("requested_window", {})
                    tms_records.append({
                        "system": "TMS",
                        "ref_id": item.get("demand_ref_id"),
                        "division": loc.get("division"),
                        "section": loc.get("section"),
                        "block_section": loc.get("block_section"),
                        "line": loc.get("line"),
                        "preferred_date": spec.get("preferred_date"),
                        "start_time": window.get("preferred_start"),
                        "end_time": window.get("preferred_end"),
                        "duration_minutes": window.get("duration_minutes", 120),
                        "work_type": spec.get("work_type")
                    })
        except Exception as e:
            print(f"Warning: could not load TMS json: {e}")

    # 2. SMMS records
    smms_path = "c:/IMBPS/data/smms_data.json"
    if os.path.exists(smms_path):
        try:
            with open(smms_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                for item in data:
                    loc = item.get("asset_location", {})
                    spec = item.get("disconnection_specifications", {})
                    slot = spec.get("requested_slot", {})
                    smms_records.append({
                        "system": "SMMS",
                        "ref_id": item.get("disconnection_ref_id"),
                        "division": loc.get("division"),
                        "station_code": loc.get("station_code"),
                        "station_name": loc.get("station_name"),
                        "gear": loc.get("affected_gear", {}).get("gear_type"),
                        "date": slot.get("date"),
                        "start_time": slot.get("start_time"),
                        "end_time": slot.get("end_time"),
                        "duration_minutes": slot.get("duration_minutes", 90),
                        "requires_traffic_block": spec.get("requires_traffic_block", True)
                    })
        except Exception as e:
            print(f"Warning: could not load SMMS json: {e}")

    # 3. TDMS records
    tdms_path = "c:/IMBPS/data/tdms_data.json"
    if os.path.exists(tdms_path):
        try:
            with open(tdms_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                for item in data:
                    boundaries = item.get("physical_track_boundaries", {})
                    spec = item.get("work_specifications", {})
                    window = spec.get("preferred_window", {})
                    op = item.get("operational_impact", {})
                    tdms_records.append({
                        "system": "TDMS",
                        "ref_id": item.get("requisition_id"),
                        "section": boundaries.get("section"),
                        "block_section": boundaries.get("block_section"),
                        "line": boundaries.get("line"),
                        "date": window.get("date"),
                        "start_time": window.get("start_time"),
                        "end_time": window.get("end_time"),
                        "duration_minutes": spec.get("duration_minutes", 120),
                        "electric_traction_dead": op.get("electric_traction_dead", True),
                        "power_cutoff_voltage": op.get("power_cutoff_voltage", "25 kV AC")
                    })
        except Exception as e:
            print(f"Warning: could not load TDMS json: {e}")

    print(f"Loaded maintenance context: {len(tms_records)} TMS, {len(smms_records)} SMMS, {len(tdms_records)} TDMS records.")
    return {
        "tms": tms_records,
        "smms": smms_records,
        "tdms": tdms_records
    }

if __name__ == "__main__":
    recs = load_maintenance_records()
    print("Sample TMS:", recs["tms"][0] if recs["tms"] else "None")
    print("Sample SMMS:", recs["smms"][0] if recs["smms"] else "None")
    print("Sample TDMS:", recs["tdms"][0] if recs["tdms"] else "None")
