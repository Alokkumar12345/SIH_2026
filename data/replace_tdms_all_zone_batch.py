import copy
import json
import os
from datetime import datetime, timedelta

import psycopg2
from psycopg2.extras import execute_batch

from generate_and_insert_tms_history import NETWORK_DATA, generate_record


TARGET_RECORDS = 2500


def build_rows():
    zone_groups = {}
    for network in NETWORK_DATA:
        zone_groups.setdefault(network["zone"], []).extend(
            (network, section) for section in network["sections"]
        )
    zones = list(zone_groups)
    zone_base, zone_remainder = divmod(TARGET_RECORDS, len(zones))
    rows = []
    sequence = 1

    for zone_index, zone in enumerate(zones):
        zone_entries = zone_groups[zone]
        zone_count = zone_base + (1 if zone_index < zone_remainder else 0)
        section_base, section_remainder = divmod(zone_count, len(zone_entries))
        for section_index, (network, section) in enumerate(zone_entries):
            count = section_base + (1 if section_index < section_remainder else 0)
            section_network = copy.deepcopy(network)
            section_network["sections"] = [section]

            for _ in range(count):
                source_row, payload = generate_record(sequence, section_network)
                job_id = f"TDMS-ML-{sequence:05d}"
                payload = copy.deepcopy(payload)
                payload["job_id"] = job_id
                payload["source_system"] = "TDMS_ELECTRICAL_TRD"
                payload["department"] = "TRD"

                preferred_date = source_row[8]
                preferred_start = source_row[10]
                actual_start = datetime.combine(preferred_date, preferred_start)
                actual_duration = max(30, source_row[9] + ((sequence % 5) - 2) * 5)
                actual_end = actual_start + timedelta(minutes=actual_duration)
                location = payload["location_details"]
                maintenance = payload["maintenance_details"]
                ml_features = payload["ml_features"]
                division_name = location["division"].split(" (", 1)[0]

                payload.update({
                    "actual_start": actual_start.isoformat(sep=" "),
                    "actual_end": actual_end.isoformat(sep=" "),
                    "actual_duration_min": actual_duration,
                    "completion_status": "COMPLETED",
                })
                rows.append((
                job_id,
                "TDMS_ELECTRICAL_TRD",
                "TRD",
                location["zone"].upper(),
                location["zone_code"],
                location["division_code"],
                division_name,
                location["section"],
                location["section"],
                location["block_section"],
                location["block_section"],
                location["line"],
                maintenance["work_type"],
                "Permanent Way Track Asset",
                maintenance["defect_severity"],
                ml_features["maintenance_priority"],
                max(0, int(payload["operational_context"]["days_since_last_maintenance"]) - 180),
                maintenance["crew_size"],
                maintenance["machine_used"],
                source_row[9],
                actual_duration,
                actual_start,
                actual_end,
                "COMPLETED",
                json.dumps(payload),
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
        cur.execute("SELECT COUNT(*) FROM tdms_maintenance_history")
        before = cur.fetchone()[0]
        cur.execute("DELETE FROM tdms_maintenance_history")
        execute_batch(cur, """
            INSERT INTO tdms_maintenance_history (
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
        print(f"replaced_all_zone_rows: {len(rows)}")
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == "__main__":
    main()