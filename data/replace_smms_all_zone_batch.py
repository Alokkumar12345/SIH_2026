import json
import os
import random
from datetime import datetime, timedelta

import psycopg2
from psycopg2.extras import execute_batch

from generate_and_insert_tms_history import NETWORK_DATA
from generate_smms_maintenance_history import SMMS_WORK_CATALOG, pick_weighted


TARGET_RECORDS = 2500


def build_rows():
    random.seed(31415)
    zone_groups = {}
    for network in NETWORK_DATA:
        zone_groups.setdefault(network["zone"], []).extend(
            (network, section) for section in network["sections"]
        )
    zones = list(zone_groups)
    zone_base, zone_remainder = divmod(TARGET_RECORDS, len(zones))
    rows = []
    sequence = 1
    start_date = datetime(2020, 1, 1)
    date_span = (datetime(2025, 12, 31) - start_date).days

    for zone_index, zone in enumerate(zones):
        zone_entries = zone_groups[zone]
        zone_count = zone_base + (1 if zone_index < zone_remainder else 0)
        section_base, section_remainder = divmod(zone_count, len(zone_entries))
        for section_index, (network, section) in enumerate(zone_entries):
            count = section_base + (1 if section_index < section_remainder else 0)
            for _ in range(count):
                block = random.choice(section["block_sections"])
                activity = random.choice(SMMS_WORK_CATALOG)
                severity = pick_weighted(activity["severity_weights"])
                criticality = pick_weighted(activity["criticality_weights"])
                requested_duration = max(45, activity["base_duration"] + random.choice([-15, 0, 15, 30]))
                actual_duration = max(35, requested_duration + random.randint(-12, 18))
                event_date = start_date + timedelta(days=random.randint(0, date_span))
                start_hour = random.choice([0, 1, 2, 10, 11, 12, 13, 14, 15, 16, 17])
                actual_start = event_date.replace(
                    hour=start_hour, minute=random.choice([0, 15, 30, 45]), second=0
                )
                actual_end = actual_start + timedelta(minutes=actual_duration)
                overdue_days = random.randint(0, 7 if criticality == "Critical" else 4)
                crew_size = random.randint(activity["crew_min"], activity["crew_max"])
                job_id = f"SMMS-ML-{sequence:05d}"
                division_code = network["division_code"]
                division_name = network["division"].split(" (", 1)[0]
                zone_name = network["zone"]
                zone_code = network["zone_code"]
                section_name = section["section"]
                line = section.get("line_name", "UP Main Line")
                block_name = block["name"]
                payload = {
                    "job_id": job_id,
                    "source_system": "SMMS_SIGNAL_TELECOM",
                    "department": "SIGNAL_TELECOM",
                    "zone": zone_name,
                    "zone_code": zone_code,
                    "division": network["division"],
                    "division_code": division_code,
                    "section": section_name,
                    "block_section": block_name,
                    "line": line,
                    "work_type": activity["work_type"],
                    "asset_type": activity["asset_type"],
                    "severity": severity,
                    "criticality": criticality,
                    "overdue_days": overdue_days,
                    "crew_size": crew_size,
                    "equipment": activity["equipment"],
                    "requested_duration_min": requested_duration,
                    "actual_duration_min": actual_duration,
                    "actual_start": actual_start.isoformat(),
                    "actual_end": actual_end.isoformat(),
                    "completion_status": "Completed",
                    "signal_telecom_context": {
                        "asset_maintenance_category": activity["asset_type"],
                        "inspection_cycle_days": random.choice([7, 14, 30, 90]),
                        "failure_recurrence": random.choice([False, False, False, True]),
                        "isolation_required": criticality in ["Critical", "High"],
                    },
                }
                rows.append((
                    job_id, "SMMS_SIGNAL_TELECOM", "SIGNAL_TELECOM", zone_name.upper(), zone_code,
                    division_code, division_name, section_name, section_name,
                    block_name, block_name, line, activity["work_type"], activity["asset_type"],
                    severity, criticality, overdue_days, crew_size, activity["equipment"],
                    requested_duration, actual_duration, actual_start, actual_end,
                    "Completed", json.dumps(payload),
                ))
                sequence += 1

    return rows


def main():
    database_url = os.environ.get("DATABASE_URL")
    if not database_url:
        raise ValueError("DATABASE_URL is required")
    rows = build_rows()
    if len(rows) != TARGET_RECORDS:
        raise RuntimeError(f"Expected {TARGET_RECORDS} rows, generated {len(rows)}")

    conn = psycopg2.connect(database_url)
    try:
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM smms_maintenance_history")
        before = cur.fetchone()[0]
        cur.execute("DELETE FROM smms_maintenance_history")
        execute_batch(cur, """
            INSERT INTO smms_maintenance_history (
                job_id, source_system, department, zone, zone_code, division, division_name,
                section, section_display, block_section, block_section_name, line,
                work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
                requested_duration_min, actual_duration_min, actual_start, actual_end,
                completion_status, payload
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                      %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, rows, page_size=250)
        conn.commit()
        print(f"replaced_previous_rows: {before}")
        print(f"inserted_all_zone_rows: {len(rows)}")
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == "__main__":
    main()