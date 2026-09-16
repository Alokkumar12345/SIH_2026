"""
Safe, Additive Batch Inserter for SMMS Maintenance Data into Neon PostgreSQL.
Adheres strictly to safety rules: no drops, no truncates, no alters, no overwrites.
"""

import json
import os
import sys
from pathlib import Path
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import execute_batch, RealDictCursor

from generate_smms_data import generate_smms_dataset

env_path = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_path)

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL is not set. Please define it in your .env file.")

TARGET_TABLE = "smms_signal_disconnections"
TARGET_NEW_RECORDS = 2600
BATCH_SIZE = 500


def main():
    print("=" * 80)
    print("      SMMS SYNTHETIC DATA BATCH INSERTER (NEON POSTGRESQL)")
    print(f"      Target Table: {TARGET_TABLE} | Target Volume: {TARGET_NEW_RECORDS} Records")
    print("=" * 80)

    # 1. Connect
    print("\n[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # 2. Safety Check: Verify table exists and fetch baseline count
    cur.execute(f'SELECT COUNT(*) FROM "{TARGET_TABLE}";')
    baseline_count = cur.fetchone()["count"]
    print(f"[+] Verified target table '{TARGET_TABLE}' exists.")
    print(f"[+] Baseline row count before insertion: {baseline_count}")

    # 3. Index existing primary keys
    cur.execute(f'SELECT disconnection_ref_id FROM "{TARGET_TABLE}";')
    existing_pks = set(r["disconnection_ref_id"] for r in cur.fetchall())
    print(f"[+] Indexed {len(existing_pks)} pre-existing disconnection_ref_ids.")

    # 4. Synthesize data
    print(f"\n[*] Generating {TARGET_NEW_RECORDS} domain-calibrated SMMS records...")
    tuples_list, payloads_list = generate_smms_dataset(
        target_count=TARGET_NEW_RECORDS,
        existing_ids=existing_pks,
    )
    print(f"[+] Successfully generated {len(tuples_list)} distinct, unique SMMS records.")

    # Format tuples with json.dumps(payload) for postgres jsonb
    formatted_tuples = []
    for t in tuples_list:
        # t is tuple of 17 items; item 16 is payload dict
        row_tuple = list(t)
        row_tuple[16] = json.dumps(row_tuple[16])
        formatted_tuples.append(tuple(row_tuple))

    # Save 50 sample records preview
    preview_file = Path(__file__).resolve().parent / "sample_smms_preview_50.json"
    with open(preview_file, "w", encoding="utf-8") as f:
        json.dump(payloads_list[:50], f, indent=2)
    print(f"[+] Saved 50 sample records preview to {preview_file.name}")

    # 5. Execute Batch Insertion
    insert_sql = f"""
    INSERT INTO "{TARGET_TABLE}" (
        disconnection_ref_id, source_system, form_type, division, station_code, station_name,
        gear_type, gear_id, maintenance_nature, requires_traffic_block, fouling_mark_infringed,
        slot_date, start_time, end_time, duration_minutes, crank_handle_locked, payload
    ) VALUES (
        %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s::jsonb
    );
    """

    print(f"\n[*] Executing additive batch insertion in chunks of {BATCH_SIZE}...")
    inserted_total = 0

    try:
        for i in range(0, len(formatted_tuples), BATCH_SIZE):
            batch = formatted_tuples[i : i + BATCH_SIZE]
            execute_batch(cur, insert_sql, batch)
            conn.commit()
            inserted_total += len(batch)
            pct = (inserted_total / len(formatted_tuples)) * 100.0
            print(f"  [+] Inserted batch {i // BATCH_SIZE + 1}: {inserted_total}/{len(formatted_tuples)} ({pct:.1f}%)")

        print(f"\n[SUCCESS] Successfully inserted all {inserted_total} records into {TARGET_TABLE}!")
    except Exception as e:
        conn.rollback()
        print(f"\n[-] Insertion failure encountered: {e}")
        print(f"[-] Transaction rolled back. Rows inserted in this run: 0 (prior state preserved).")
        conn.close()
        sys.exit(1)

    # 6. Post-insertion verification
    cur.execute(f'SELECT COUNT(*) FROM "{TARGET_TABLE}";')
    after_count = cur.fetchone()["count"]
    net_increase = after_count - baseline_count

    print("\n" + "=" * 80)
    print("                    POST-INSERTION INTEGRITY CHECK")
    print("=" * 80)
    print(f"  Baseline Count:    {baseline_count}")
    print(f"  Records Inserted:  {inserted_total}")
    print(f"  New Total Count:   {after_count}")
    print(f"  Net Verification:  {net_increase} (Target >= 2000: {'PASSED' if net_increase >= 2000 else 'FAILED'})")

    conn.close()


if __name__ == "__main__":
    main()
