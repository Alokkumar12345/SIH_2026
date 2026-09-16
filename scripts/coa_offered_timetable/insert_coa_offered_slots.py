"""
Safe Batch Inserter for COA Candidate Slot Offers & Regulation Playbooks.
Inserts synthetic candidate slot records into coa_offered_slots in Neon PostgreSQL.
"""

import os
import sys
import json
import psycopg2
from psycopg2.extras import execute_batch, Json
from dotenv import load_dotenv

from generate_coa_offered_slots import generate_coa_offered_dataset

# Load environment configuration
load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured")

TARGET_TABLE = "coa_offered_slots"
BATCH_SIZE = 250
DESIRED_RECORDS = 2500

def insert_offered_slots():
    print("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    conn.autocommit = False
    cursor = conn.cursor()

    # 1. Count Before
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    count_before = cursor.fetchone()[0]
    print(f"Current row count in {TARGET_TABLE} before insertion: {count_before}")

    # 2. Existing slot IDs
    cursor.execute(f"SELECT coa_slot_id FROM {TARGET_TABLE};")
    existing_ids = set(row[0] for row in cursor.fetchall())
    print(f"Fetched {len(existing_ids)} existing slot IDs.")

    # 3. Generate Records
    print(f"\nGenerating {DESIRED_RECORDS} synthetic candidate slot offer records...")
    records = generate_coa_offered_dataset(num_records=DESIRED_RECORDS, existing_slot_ids=existing_ids)

    # Save 50 sample preview
    preview_path = os.path.join(os.path.dirname(__file__), "coa_offered_sample_50_preview.json")
    preview_records = [r["payload"] for r in records[:50]]
    with open(preview_path, "w", encoding="utf-8") as f:
        json.dump(preview_records, f, indent=2, default=str)
    print(f"Saved 50 sample records preview to: {preview_path}")

    # 4. Parameterized Insert with ON CONFLICT DO NOTHING
    insert_sql = f"""
        INSERT INTO {TARGET_TABLE} (
            coa_slot_id,
            division_code,
            sub_division,
            section_id,
            block_section,
            line,
            target_date,
            start_time,
            end_time,
            duration_minutes,
            payload
        ) VALUES (
            %(coa_slot_id)s,
            %(division_code)s,
            %(sub_division)s,
            %(section_id)s,
            %(block_section)s,
            %(line)s,
            %(target_date)s,
            %(start_time)s,
            %(end_time)s,
            %(duration_minutes)s,
            %(payload)s
        )
        ON CONFLICT (coa_slot_id) DO NOTHING;
    """

    prepared_data = []
    for r in records:
        item = dict(r)
        item["payload"] = Json(r["payload"])
        prepared_data.append(item)

    total_inserted = 0
    num_batches = (len(prepared_data) + BATCH_SIZE - 1) // BATCH_SIZE
    print(f"\nBeginning safe batch insertion ({num_batches} batches of up to {BATCH_SIZE})...")

    try:
        for i in range(0, len(prepared_data), BATCH_SIZE):
            batch = prepared_data[i:i + BATCH_SIZE]
            batch_num = (i // BATCH_SIZE) + 1
            print(f"  -> Inserting Batch {batch_num}/{num_batches} ({len(batch)} records)...", end="", flush=True)
            execute_batch(cursor, insert_sql, batch)
            conn.commit()
            total_inserted += len(batch)
            print(" [COMMITTED]")

    except Exception as e:
        conn.rollback()
        print(f"\n[ERROR] Batch insertion failed: {e}")
        print("Transaction rolled back safely. Database remains unmodified.")
        cursor.close()
        conn.close()
        raise

    # 5. Count After
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    count_after = cursor.fetchone()[0]
    print(f"\nInsertion completed successfully!")
    print(f"Rows before: {count_before}")
    print(f"Rows inserted: {total_inserted}")
    print(f"Rows after: {count_after}")

    cursor.close()
    conn.close()
    return count_before, total_inserted, count_after

if __name__ == "__main__":
    insert_offered_slots()
