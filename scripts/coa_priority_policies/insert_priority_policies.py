"""
Safe Batch Inserter for COA Service Priority & Constraint Policies.
Inserts synthetic policy records into coa_priority_policies in Neon PostgreSQL.
"""

import os
import sys
import json
import psycopg2
from psycopg2.extras import execute_batch, Json
from dotenv import load_dotenv

from generate_priority_policies import generate_priority_policies_dataset

# Load environment configuration
load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured")

TARGET_TABLE = "coa_priority_policies"
BATCH_SIZE = 50

def insert_policies():
    print("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    conn.autocommit = False
    cursor = conn.cursor()

    # 1. Count before
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    count_before = cursor.fetchone()[0]
    print(f"Current row count in {TARGET_TABLE} before insertion: {count_before}")

    # 2. Existing unique combinations
    cursor.execute(f"SELECT zone_code, division_code, sub_division, policy_year FROM {TARGET_TABLE};")
    existing_keys = set((r[0], r[1], r[2], r[3]) for r in cursor.fetchall())
    print(f"Fetched {len(existing_keys)} existing policy keys.")

    # 3. Generate Records
    records = generate_priority_policies_dataset(existing_keys=existing_keys)

    # Save 50 sample preview
    preview_path = os.path.join(os.path.dirname(__file__), "coa_priority_policies_sample_50_preview.json")
    preview_records = [r["payload"] for r in records[:50]]
    with open(preview_path, "w", encoding="utf-8") as f:
        json.dump(preview_records, f, indent=2, default=str)
    print(f"Saved 50 sample records preview to: {preview_path}")

    # 4. Parameterized Insert
    insert_sql = f"""
        INSERT INTO {TARGET_TABLE} (
            zone_code,
            division_code,
            sub_division,
            corridor_classification,
            policy_year,
            payload
        ) VALUES (
            %(zone_code)s,
            %(division_code)s,
            %(sub_division)s,
            %(corridor_classification)s,
            %(policy_year)s,
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
        print("Transaction rolled back safely. Database remains unmodified.")
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
    insert_policies()
