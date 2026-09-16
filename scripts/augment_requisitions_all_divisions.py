import json
from pathlib import Path
from datetime import datetime, timedelta

with open("c:/IMBPS/data/all_railway_entities.json", "r", encoding="utf-8") as f:
    entities = json.load(f)

# Load existing datasets
tms_path = Path("c:/IMBPS/data/tms_data.json")
smms_path = Path("c:/IMBPS/data/smms_data.json")
tdms_path = Path("c:/IMBPS/data/tdms_data.json")

with open(tms_path, "r", encoding="utf-8") as f:
    tms_data = json.load(f)
with open(smms_path, "r", encoding="utf-8") as f:
    smms_data = json.load(f)
with open(tdms_path, "r", encoding="utf-8") as f:
    tdms_data = json.load(f)

existing_tms_divs = set(item.get("location_details", {}).get("division", "") for item in tms_data)
existing_smms_divs = set(item.get("asset_location", {}).get("division", "") for item in smms_data)
existing_tdms_divs = set(item.get("electrical_section_details", {}).get("division", "") for item in tdms_data)

target_date = (datetime.now() + timedelta(days=5)).strftime("%Y-%m-%d")

req_id_counter = 1000

for z_code, z_data in entities.items():
    z_name = z_data.get("name", z_code)
    for d_code, d_data in z_data.get("divisions", {}).items():
        d_name = d_data.get("name", d_code)
        sections = d_data.get("sections", [])
        if not sections:
            sections = [{"code": f"{d_code}-SEC", "name": f"{d_name} Section"}]
        sec = sections[0]
        sec_name = sec.get("name", sec.get("code"))

        # Add TMS if not present
        if not any(d_code.lower() in str(ed).lower() for ed in existing_tms_divs):
            req_id_counter += 1
            tms_data.append({
                "source_system": "TMS_CIVIL_ENGG",
                "demand_ref_id": f"TMS/{d_code}/2026/BLK/{req_id_counter}",
                "requisitioning_officer": {
                    "emp_id": f"10{req_id_counter}",
                    "designation": f"SSE_PWAY_{d_code}",
                    "mobile": "9876543210"
                },
                "location_details": {
                    "zone": z_name,
                    "division": d_name,
                    "section": sec_name,
                    "block_section": f"{sec_name} Section",
                    "line": "UP Main",
                    "from_km": "10.000",
                    "to_km": "14.500"
                },
                "block_specifications": {
                    "work_type": "Tamping Machine (CSM) Deployment",
                    "demand_nature": "Planned Rolling Block",
                    "preferred_date": target_date,
                    "requested_window": {
                        "duration_minutes": 150,
                        "preferred_start": "11:30",
                        "preferred_end": "14:00"
                    }
                },
                "interdepartmental_dependencies": {
                    "power_block_required": True,
                    "trd_details": f"OHE power isolation required in {d_code} corridor",
                    "st_disconnection_required": True,
                    "st_details": "Axle counters & track circuit bonding disconnection"
                },
                "speed_restriction_proposed": {
                    "post_work_speed_kmph": 50,
                    "normal_speed_restoration_hrs": 48
                }
            })

        # Add SMMS if not present
        if not any(d_code.lower() in str(ed).lower() for ed in existing_smms_divs):
            req_id_counter += 1
            smms_data.append({
                "source_system": "SMMS_SIGNAL_TELECOM",
                "disconnection_ref_id": f"SMMS/{d_code}/2026/SIG/{req_id_counter}",
                "issuing_authority": {
                    "designation": f"SSE_SIGNAL_{d_code}",
                    "contact": "9876543211"
                },
                "asset_location": {
                    "zone": z_name,
                    "division": d_name,
                    "station_name": f"{d_code} Junction",
                    "geographical_chainage_km": 12.5
                },
                "disconnection_specifications": {
                    "maintenance_nature": "Point Machine Motor & Detection Overhaul",
                    "requires_traffic_block": True,
                    "requested_slot": {
                        "date": target_date,
                        "start_time": "12:00",
                        "end_time": "14:00",
                        "duration_minutes": 120
                    }
                }
            })

        # Add TDMS if not present
        if not any(d_code.lower() in str(ed).lower() for ed in existing_tdms_divs):
            req_id_counter += 1
            tdms_data.append({
                "source_system": "TDMS_TRACTION_DISTRIBUTION",
                "requisition_id": f"TDMS/{d_code}/2026/TRD/{req_id_counter}",
                "supervising_engineer": {
                    "designation": f"SSE_TRD_{d_code}",
                    "contact_number": "9876543212"
                },
                "electrical_section_details": {
                    "zone": z_name,
                    "division": d_name,
                    "traction_sub_station": f"{d_code} TSS",
                    "elementry_section": f"{d_code}-ES-01"
                },
                "requisition_type": "Cantilever & Contact Wire Replacement",
                "block_specifications": {
                    "preferred_date": target_date,
                    "requested_window": {
                        "duration_minutes": 150,
                        "preferred_start": "11:30",
                        "preferred_end": "14:00"
                    }
                }
            })

with open(tms_path, "w", encoding="utf-8") as f:
    json.dump(tms_data, f, indent=2)
with open(smms_path, "w", encoding="utf-8") as f:
    json.dump(smms_data, f, indent=2)
with open(tdms_path, "w", encoding="utf-8") as f:
    json.dump(tdms_data, f, indent=2)

print(f"Updated TMS requisitions: {len(tms_data)}")
print(f"Updated SMMS requisitions: {len(smms_data)}")
print(f"Updated TDMS requisitions: {len(tdms_data)}")
