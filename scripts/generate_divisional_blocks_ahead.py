import json
from datetime import datetime, timedelta
from pathlib import Path

# Load railway entities and generated users
with open("c:/IMBPS/data/all_railway_entities.json", "r", encoding="utf-8") as f:
    entities = json.load(f)

with open("c:/IMBPS/data/generated_users.json", "r", encoding="utf-8") as f:
    all_users = json.load(f)

# Build a lookup for engineers by (dept, division_code, section)
engineer_map = {}
for u in all_users:
    if u["role"] == "section_engineer":
        dept = u.get("department")
        d_code = u.get("division_code")
        sec = u.get("section")
        key = (dept, d_code, sec)
        engineer_map[key] = u.get("name")

# Also preserve existing state if already authorized/edited
existing_blocks = {}
state_path = Path("c:/IMBPS/data/divisional_blocks_state.json")
if state_path.exists():
    try:
        with open(state_path, "r", encoding="utf-8") as f:
            for b in json.load(f):
                existing_blocks[b["block_id"]] = b
    except Exception:
        pass

base_date = (datetime.now() + timedelta(days=7)).strftime("%Y-%m-%d")
day_after = (datetime.now() + timedelta(days=8)).strftime("%Y-%m-%d")
day_after_2 = (datetime.now() + timedelta(days=9)).strftime("%Y-%m-%d")

work_catalog = {
    "TMS": [
        ("Tamping Machine (CSM) Deployment", "Track", 150, "CSM-952", 8, "HIGH", 0.38, True, True),
        ("Deep Screening with BCM", "Ballast & Sleeper", 210, "BCM-083 + DGS", 12, "CRITICAL", 0.65, True, True),
        ("Rail Renewal & Flash Butt Welding", "Rails", 180, "Mobile Flash Butt Welder", 10, "HIGH", 0.45, True, False),
        ("Switch Expansion Joint (SEJ) Overhaul", "Track Switch", 120, "Precision Track Gauge & Lifting Jack", 6, "MEDIUM", 0.30, False, True)
    ],
    "SMMS": [
        ("Point Machine Motor & Detection Overhaul", "Point Machine", 120, "Insulation Testing Kit + Torque Wrench", 5, "HIGH", 0.42, False, True),
        ("Digital Axle Counter (DAC) Head Replacement", "Axle Counter", 90, "Electronic Calibration Kit", 4, "MEDIUM", 0.29, False, True),
        ("Electronic Interlocking (EI) Software & Diagnostic Test", "Interlocking System", 120, "VDU Diagnostic Terminal", 4, "HIGH", 0.35, False, True),
        ("Track Circuit Relay & Bond Wire Inspection", "Track Circuit", 100, "Multi-meter & Bond Crimping Kit", 4, "MEDIUM", 0.25, False, True)
    ],
    "TDMS": [
        ("Cantilever & Contact Wire Replacement", "OHE Catenary Wire", 165, "8-Wheeler Tower Wagon (TW-401)", 7, "HIGH", 0.35, True, False),
        ("Section Insulator Overhaul & Tree Trimming", "Section Insulator", 120, "Ladder Trolley + Discharge Rods", 6, "MEDIUM", 0.31, True, False),
        ("25kV Traction Sub-Station Circuit Breaker Servicing", "TSS Circuit Breaker", 180, "High Voltage Testing Kit", 8, "CRITICAL", 0.52, True, False),
        ("OHE Dropper & Contact Wire Height Adjustment", "OHE Mast & Droppers", 135, "Tower Wagon + Laser Gauge", 5, "MEDIUM", 0.28, True, False)
    ]
}

blocks = []
block_counter = 1

for z_code, z_data in entities.items():
    z_name = z_data.get("name", z_code)
    for d_code, d_data in z_data.get("divisions", {}).items():
        d_name = d_data.get("name", d_code)
        sections = d_data.get("sections", [])
        if not sections:
            sections = [{"code": f"{d_code}-MAIN", "name": f"{d_name} Main Line"}]

        # Generate 2 to 4 blocks per division across TMS, SMMS, TDMS
        for dept in ["TMS", "SMMS", "TDMS"]:
            for sec_idx, sec in enumerate(sections[:2]):
                sec_code = sec["code"]
                sec_name = sec["name"]
                b_id = f"BLK-2026-W38-{block_counter:03d}"
                block_counter += 1

                # If this block ID already exists in previous state, preserve it!
                if b_id in existing_blocks:
                    blocks.append(existing_blocks[b_id])
                    continue

                catalog = work_catalog[dept]
                item = catalog[(sec_idx + len(blocks)) % len(catalog)]
                w_type, a_type, dur, equip, crew, prio, risk, pwr, sig = item

                engineer_name = engineer_map.get((dept, d_code, sec_code)) or f"Er. In-Charge (SSE/{dept})"
                sched_date = base_date if block_counter % 3 == 0 else (day_after if block_counter % 3 == 1 else day_after_2)

                dept_display_map = {
                    "TMS": "Track Management System (Civil)",
                    "SMMS": "Signal & Telecom Maintenance",
                    "TDMS": "Traction Distribution (TRD / OHE)"
                }

                blocks.append({
                    "block_id": b_id,
                    "department": dept,
                    "department_display": dept_display_map[dept],
                    "division": d_name,
                    "division_code": d_code,
                    "zone": z_name,
                    "zone_code": z_code,
                    "section": sec_code,
                    "section_display": sec_name,
                    "block_section": f"{sec_code}-BLK1",
                    "block_section_name": f"{sec_name} Block Section",
                    "line": "UP_MAIN" if block_counter % 2 == 0 else "DN_MAIN",
                    "work_type": w_type,
                    "asset_type": a_type,
                    "scheduled_date": sched_date,
                    "preferred_start": "11:30" if dept == "TMS" else ("12:00" if dept == "SMMS" else "12:30"),
                    "preferred_end": "14:00" if dept == "TMS" else ("14:00" if dept == "SMMS" else "14:45"),
                    "duration_min": dur,
                    "equipment": equip,
                    "crew_size": crew,
                    "priority": prio,
                    "risk_probability": risk,
                    "power_block_required": pwr,
                    "st_disconnection_required": sig,
                    "status": "AWAITING_AUTHORIZATION",
                    "is_edited": False,
                    "edit_history": [],
                    "authorized": False,
                    "authorized_by": None,
                    "authorized_at": None,
                    "assigned_to": engineer_name
                })

print(f"Total Divisional Blocks Generated: {len(blocks)}")
divs_covered = set(b["division_code"] for b in blocks)
print(f"Total Divisions with Blocks: {len(divs_covered)}")

with open("c:/IMBPS/data/divisional_blocks_state.json", "w", encoding="utf-8") as f:
    json.dump(blocks, f, indent=2)

print("Saved updated blocks to c:/IMBPS/data/divisional_blocks_state.json")
