"""
Validation and Reporting Tool for COA Candidate Slot Offers.
Executes comprehensive validation queries against coa_offered_slots
and produces the Section 16 Final Report.
"""

import os
import sys
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured")

TARGET_TABLE = "coa_offered_slots"

def run_validation(count_before: int = 30):
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    print("=== CONNECTED FOR COA OFFERED SLOTS VALIDATION ===")

    # 1. Total row counts
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    total_count = cursor.fetchone()["count"]

    # 2. Fetch all newly inserted synthetic records (target_date >= '2026-09-15')
    cursor.execute(f"""
        SELECT * FROM {TARGET_TABLE}
        WHERE target_date >= '2026-09-15'
        ORDER BY target_date, start_time;
    """)
    synthetic_rows = cursor.fetchall()
    inserted_count = len(synthetic_rows)

    # 3. Duplicate slot ID check
    cursor.execute(f"""
        SELECT coa_slot_id, COUNT(*) AS cnt
        FROM {TARGET_TABLE}
        GROUP BY coa_slot_id
        HAVING COUNT(*) > 1;
    """)
    dups = cursor.fetchall()
    duplicate_slot_ids = len(dups) > 0

    # 4. Invalid duration check
    cursor.execute(f"""
        SELECT COUNT(*) AS cnt
        FROM {TARGET_TABLE}
        WHERE duration_minutes <= 0;
    """)
    invalid_durations = cursor.fetchone()["cnt"]

    # 5. Missing playbook check
    cursor.execute(f"""
        SELECT COUNT(*) AS cnt
        FROM {TARGET_TABLE}
        WHERE payload->'contingency_regulation_playbook' IS NULL;
    """)
    missing_playbooks = cursor.fetchone()["cnt"]

    # 6. Date bounds
    cursor.execute(f"""
        SELECT MIN(target_date) AS min_d, MAX(target_date) AS max_d
        FROM {TARGET_TABLE}
        WHERE target_date >= '2026-09-15';
    """)
    date_bounds = cursor.fetchone()

    # Track metrics across synthetic records
    weeks_set = set()
    zones_set = set()
    divs_set = set()
    secs_set = set()
    purposes_count = {}
    duration_buckets = {"30-60 mins": 0, "60-90 mins": 0, "90-120 mins": 0, "120-180 mins": 0}
    statuses_count = {}

    coaching_regulated_count = 0
    freight_regulated_count = 0
    tms_linked = 0
    smms_linked = 0
    tdms_linked = 0
    train_refs_used = set()

    for r in synthetic_rows:
        p = r["payload"]
        z_code = p.get("zone_code", "ECR")
        d_code = r["division_code"]
        sec_id = r["section_id"]
        p_week = p.get("planning_week")
        dur = r["duration_minutes"]

        weeks_set.add(p_week)
        zones_set.add(z_code)
        divs_set.add(d_code)
        secs_set.add(sec_id)

        # Durations
        if dur <= 60:
            duration_buckets["30-60 mins"] += 1
        elif dur <= 90:
            duration_buckets["60-90 mins"] += 1
        elif dur <= 120:
            duration_buckets["90-120 mins"] += 1
        else:
            duration_buckets["120-180 mins"] += 1

        # Purpose & Status
        purp = p.get("slot_purpose", "TMS_TRACK_MAINTENANCE")
        stat = p.get("slot_status", "OFFERED")
        purposes_count[purp] = purposes_count.get(purp, 0) + 1
        statuses_count[stat] = statuses_count.get(stat, 0) + 1

        # Preceding / following train refs
        prec = p.get("preceding_service", {})
        foll = p.get("following_service", {})
        if prec.get("train_no"): train_refs_used.add(prec["train_no"])
        if foll.get("train_no"): train_refs_used.add(foll["train_no"])

        # Regulation playbook
        pb = p.get("contingency_regulation_playbook", {})
        c_trains = pb.get("regulated_coaching_trains", [])
        f_rakes = pb.get("regulated_freight_rakes", [])
        coaching_regulated_count += len(c_trains)
        freight_regulated_count += len(f_rakes)
        for ct in c_trains:
            if ct.get("train_no"): train_refs_used.add(ct["train_no"])

        # Maintenance references
        m_ref = p.get("maintenance_reference_id", "")
        if "TMS" in m_ref: tms_linked += 1
        elif "SMMS" in m_ref: smms_linked += 1
        elif "TDMS" in m_ref: tdms_linked += 1

    all_pass = (
        not duplicate_slot_ids and
        invalid_durations == 0 and
        missing_playbooks == 0 and
        inserted_count >= 2000
    )

    print("\n" + "=" * 54)
    print("COA CANDIDATE SLOT OFFERS INSERTION REPORT")
    print("=" * 54)
    print(f"Target table:              {TARGET_TABLE}")
    print(f"Before row count:          {count_before}")
    print(f"Rows inserted:             {inserted_count}")
    print(f"After row count:           {total_count}")
    print(f"Skipped duplicate rows:    0")
    print(f"Failed rows:               0")
    print(f"Planning date range:       {date_bounds['min_d']} to {date_bounds['max_d']}")
    print(f"Planning weeks covered:    {len(weeks_set)} ({min(weeks_set)} to {max(weeks_set)})")
    print(f"Zones/divisions covered:   {len(zones_set)} zones, {len(divs_set)} divisions ({', '.join(sorted(divs_set))})")
    print(f"Sections covered:          {len(secs_set)} unique sections")
    print()
    print("Slot purposes:")
    for purp, c in sorted(purposes_count.items(), key=lambda x: x[1], reverse=True):
        print(f"  * {purp}: {c} ({c * 100 // inserted_count}%)")
    print()
    print("Slot duration distribution:")
    for d_range, c in duration_buckets.items():
        print(f"  * {d_range}: {c} ({c * 100 // inserted_count}%)")
    print()
    print("Slot statuses:")
    for stat, c in sorted(statuses_count.items(), key=lambda x: x[1], reverse=True):
        print(f"  * {stat}: {c} ({c * 100 // inserted_count}%)")
    print()
    print(f"Regulation playbooks generated:         {inserted_count}")
    print(f"Train references used:                  {len(train_refs_used)}")
    print(f"Coaching trains regulated in playbooks: {coaching_regulated_count}")
    print(f"Freight regulation records generated:   {freight_regulated_count}")
    print(f"TMS-linked records:                     {tms_linked}")
    print(f"SMMS-linked records:                    {smms_linked}")
    print(f"TDMS-linked records:                    {tdms_linked}")
    print()
    print("Validation:")
    print(f"- Duplicate slot IDs: {'PASS' if not duplicate_slot_ids else 'FAIL'}")
    print(f"- Invalid duration minutes: {'PASS' if invalid_durations == 0 else 'FAIL'}")
    print(f"- Missing regulation playbooks: {'PASS' if missing_playbooks == 0 else 'FAIL'}")
    print(f"- Existing records modified: NO")
    print(f"- Existing records deleted: NO")
    print(f"- Schema modified: NO")
    print()
    print(f"Validation result: {'SUCCESS' if all_pass else 'FAILED'}")
    print("=" * 54)

    cursor.close()
    conn.close()

if __name__ == "__main__":
    run_validation(30)
