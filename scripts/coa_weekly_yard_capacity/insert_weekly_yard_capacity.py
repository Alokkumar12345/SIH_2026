"""
Database Inserter for COA Weekly Yard Capacity Table.
Inserts realistic synthetic yard and loop capacity data into PostgreSQL table:
    coa_weekly_yard_capacity

Safety Rules:
- Additive INSERT only.
- No DROP, TRUNCATE, DELETE, UPDATE, ALTER, CREATE.
- Existing records are checked and skipped (no duplicates).
- Parameterized queries with psycopg2.extras.Json.
- Batch transactions with rollback on failure.
"""

import os
import sys
import json
import psycopg2
from psycopg2.extras import RealDictCursor, Json
from dotenv import load_dotenv

# Ensure UTF-8 output
if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# Load environment configuration
load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL environment variable is not configured.")

# Import generator
from generate_weekly_yard_capacity import generate_weekly_capacity_dataset

def get_connection():
    return psycopg2.connect(DATABASE_URL)

def run_inserter():
    print("=" * 70)
    print("COA WEEKLY YARD CAPACITY - SAFE DATABASE INSERTER")
    print("=" * 70)

    conn = get_connection()
    conn.autocommit = False
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        table_name = "coa_weekly_yard_capacity"

        # 1. Fetch initial count before insert
        cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
        count_before = cursor.fetchone()["count"]
        print(f"[*] Initial row count in {table_name}: {count_before}")

        # 2. Fetch existing (station_code, target_week) pairs to avoid duplicates
        cursor.execute(f"SELECT station_code, target_week FROM {table_name};")
        existing_rows = cursor.fetchall()
        existing_keys = {(r["station_code"], r["target_week"]) for r in existing_rows}
        print(f"[*] Existing station-week combinations found: {len(existing_keys)}")

        # 3. Generate dataset skipping existing combinations
        dataset = generate_weekly_capacity_dataset(existing_keys=existing_keys)
        records_to_insert = len(dataset)
        print(f"[*] New records to insert: {records_to_insert}")

        if records_to_insert == 0:
            print("[!] No new records to insert. All station-week combinations are already present.")
            conn.close()
            return

        # 4. Save a preview artifact of first 50 records
        preview_file = os.path.join(os.path.dirname(__file__), "coa_yard_capacity_sample_50_preview.json")
        with open(preview_file, "w", encoding="utf-8") as f:
            json.dump([r["payload"] for r in dataset[:50]], f, indent=2, default=str)
        print(f"[*] Exported 50-record sample preview to: {preview_file}")

        # 5. Parameterized batch insertion
        insert_sql = f"""
            INSERT INTO {table_name} (
                station_code,
                station_name,
                division_code,
                sub_division,
                target_week,
                payload
            ) VALUES (%s, %s, %s, %s, %s, %s);
        """

        batch_size = 200
        total_inserted = 0
        failed_rows = 0

        print(f"\n[*] Starting batch insertion (Batch size: {batch_size})...")

        for i in range(0, records_to_insert, batch_size):
            batch = dataset[i : i + batch_size]
            batch_data = [
                (
                    row["station_code"],
                    row["station_name"],
                    row["division_code"],
                    row["sub_division"],
                    row["target_week"],
                    Json(row["payload"])
                )
                for row in batch
            ]

            try:
                cursor.executemany(insert_sql, batch_data)
                conn.commit()
                total_inserted += len(batch)
                pct = (total_inserted / records_to_insert) * 100
                print(f"    -> Inserted {total_inserted}/{records_to_insert} rows ({pct:.1f}%) [Batch {i//batch_size + 1}]")
            except Exception as batch_err:
                conn.rollback()
                failed_rows += len(batch)
                print(f"[!] Error inserting batch {i//batch_size + 1}: {batch_err}")
                raise batch_err

        # 6. Verify count after insertion
        cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
        count_after = cursor.fetchone()["count"]

        print("\n" + "=" * 70)
        print("INSERTION SUMMARY")
        print("=" * 70)
        print(f"Target table:            {table_name}")
        print(f"Before row count:        {count_before}")
        print(f"Rows inserted:           {total_inserted}")
        print(f"After row count:         {count_after}")
        print(f"Skipped duplicate rows:  {len(existing_keys)}")
        print(f"Failed rows:             {failed_rows}")
        print("=" * 70)

    except Exception as e:
        conn.rollback()
        print(f"\n[FATAL ERROR] Transaction rolled back due to error: {e}")
        raise e
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    run_inserter()
