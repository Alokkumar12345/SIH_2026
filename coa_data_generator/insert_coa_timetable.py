"""
Safe Batch Inserter for COA Master Working Timetable.
Inserts synthetic train timetable records into coa_master_timetable
using parameterized batch transactions.
"""

import os
import json
import psycopg2
from psycopg2.extras import execute_batch, Json
from dotenv import load_dotenv

from generate_coa_timetable import generate_coa_dataset

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured in .env")

TARGET_TABLE = "coa_master_timetable"
BATCH_SIZE = 250
DESIRED_RECORDS = 2200

def insert_coa_records():
    print("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    conn.autocommit = False
    cursor = conn.cursor()

    # 1. Count before
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    count_before = cursor.fetchone()[0]
    print(f"Current row count in {TARGET_TABLE} before insertion: {count_before}")

    # 2. Existing train numbers
    cursor.execute(f"SELECT train_number FROM {TARGET_TABLE};")
    existing_numbers = set(row[0] for row in cursor.fetchall())
    print(f"Fetched {len(existing_numbers)} existing train numbers.")

    # 3. Generate synthetic records
    print(f"\nGenerating {DESIRED_RECORDS} synthetic COA train timetable records...")
    records = generate_coa_dataset(num_records=DESIRED_RECORDS, existing_numbers=existing_numbers)

    # Save 50 sample records preview
    preview_path = os.path.join(os.path.dirname(__file__), "coa_sample_50_preview.json")
    preview_records = [r["payload"] for r in records[:50]]
    with open(preview_path, "w", encoding="utf-8") as f:
        json.dump(preview_records, f, indent=2, default=str)
    print(f"Saved 50 sample records preview to: {preview_path}")

    # 4. Parameterized Insert
    insert_sql = f"""
        INSERT INTO {TARGET_TABLE} (
            train_number,
            train_name,
            division_code,
            sub_division,
            traction,
            train_length_coaches,
            payload
        ) VALUES (
            %(train_number)s,
            %(train_name)s,
            %(division_code)s,
            %(sub_division)s,
            %(traction)s,
            %(train_length_coaches)s,
            %(payload)s
        );
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
        print("Transaction rolled back safely. No partial changes committed.")
        cursor.close()
        conn.close()
        raise

    # 5. Count after
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
    insert_coa_records()
