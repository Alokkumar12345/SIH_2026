import json
import psycopg2
from psycopg2.extras import execute_batch
from datetime import datetime, timedelta, date, time
from pathlib import Path

# Load railway entities
with open("c:/IMBPS/data/all_railway_entities.json", "r", encoding="utf-8") as f:
    entities = json.load(f)

# Connect to Neon COA database
NEON_COA_URL = "postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

conn = psycopg2.connect(NEON_COA_URL)
cur = conn.cursor()

# Find existing division codes in coa_offered_slots
cur.execute("SELECT DISTINCT division_code FROM coa_offered_slots;")
existing_divs = set(r[0] for r in cur.fetchall())
print(f"Existing divisions in coa_offered_slots: {existing_divs}")

base_date = date(2026, 9, 16)
new_slots = []

slot_counter = 5000

for z_code, z_data in entities.items():
    z_name = z_data.get("name", z_code)
    for d_code, d_data in z_data.get("divisions", {}).items():
        # Check if already has slots
        if d_code in existing_divs:
            continue
        
        d_name = d_data.get("name", d_code)
        sections = d_data.get("sections", [])
        if not sections:
            sections = [{"code": f"{d_code}-MAIN", "name": f"{d_name} Main Line"}]

        # Generate 14-28 slots across days for this division
        for day_offset in range(21):
            target_dt = base_date + timedelta(days=day_offset)
            sec = sections[day_offset % len(sections)]
            sec_code = sec.get("code")
            sec_name = sec.get("name")

            # Morning and Afternoon windows
            windows = [
                ("MORN", time(11, 0), time(13, 30), 150, "UP_MAIN"),
                ("AFTN", time(12, 30), time(15, 0), 150, "DN_MAIN")
            ]
            w = windows[day_offset % len(windows)]
            win_name, st_time, end_time, dur, ln = w

            slot_counter += 1
            clean_dcode = d_code.replace("-", "_")
            slot_id = f"COA_SLOT_{clean_dcode}_D{target_dt.day:02d}_{win_name}_{slot_counter}"

            payload = {
                "coa_slot_id": slot_id,
                "division_code": d_code,
                "sub_division": f"{d_code}-{sec_code[:8]}",
                "section_id": sec_code,
                "block_section": f"{sec_name} Block Section",
                "line": ln,
                "target_date": target_dt.strftime("%Y-%m-%d"),
                "day_of_week": target_dt.strftime("%A").upper(),
                "slot_window": {
                    "start_time": st_time.strftime("%H:%M"),
                    "end_time": end_time.strftime("%H:%M"),
                    "duration_minutes": dur
                },
                "following_service": {
                    "train_no": f"1{slot_counter % 9000 + 1000}",
                    "train_name": f"{d_name} Express",
                    "type": "MAIL_EXPRESS",
                    "projected_arrival_time_at_from_station": (datetime.combine(target_dt, end_time) + timedelta(minutes=15)).strftime("%H:%M")
                },
                "preceding_service": {
                    "train_no": f"2{slot_counter % 9000 + 1000}",
                    "train_name": f"{d_name} Superfast",
                    "type": "SUPERFAST",
                    "projected_clearance_time_at_to_station": (datetime.combine(target_dt, st_time) - timedelta(minutes=10)).strftime("%H:%M")
                },
                "contingency_regulation_playbook": {
                    "regulated_freight_rakes": [
                        {
                            "freight_id": f"FREIGHT_{d_code}_{slot_counter % 100:03d}",
                            "stabling_station": f"{d_code} Yard",
                            "stabling_loop": "LOOP_1_UP",
                            "planned_hold_minutes": 120
                        }
                    ],
                    "regulated_coaching_trains": []
                }
            }

            new_slots.append((
                slot_id,
                d_code,
                f"{d_code}-{sec_code[:8]}",
                sec_code,
                f"{sec_name} Block Section",
                ln,
                target_dt,
                st_time,
                end_time,
                dur,
                json.dumps(payload)
            ))

print(f"Generated {len(new_slots)} new COA offered slots across remaining divisions.")

if new_slots:
    insert_sql = """
    INSERT INTO coa_offered_slots (
        coa_slot_id, division_code, sub_division, section_id,
        block_section, line, target_date, start_time, end_time,
        duration_minutes, payload
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (coa_slot_id) DO NOTHING;
    """
    execute_batch(cur, insert_sql, new_slots, page_size=100)
    conn.commit()
    print("Successfully inserted all new COA slots into Neon database!")

cur.execute("SELECT COUNT(*), COUNT(DISTINCT division_code) FROM coa_offered_slots;")
total_slots, total_divs = cur.fetchone()
print(f"Total COA slots now in Neon: {total_slots} across {total_divs} divisions!")

conn.close()
