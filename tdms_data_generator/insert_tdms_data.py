"""
TDMS Electrical TRD Safe Insertion Script
Inserts synthetic TDMS records into Neon PostgreSQL in batches without modifying
or overwriting existing records.
"""

import os
import json
import psycopg2
from psycopg2.extras import execute_batch, Json
from dotenv import load_dotenv
from generate_tdms_data import generate_tdms_dataset

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured in .env")

TARGET_TABLE = "tdms_requisitions"
BATCH_SIZE = 250
DESIRED_RECORDS = 2500

def insert_tdms_records():
    print("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    conn.autocommit = False # Use explicit transactions for safety
    cursor = conn.cursor()
    
    # 1. Row count before
    cursor.execute(f"SELECT COUNT(*) FROM {TARGET_TABLE};")
    count_before = cursor.fetchone()[0]
    print(f"Current row count in {TARGET_TABLE} before insertion: {count_before}")
    
    # 2. Collect existing requisition_ids to guarantee 100% uniqueness
    cursor.execute(f"SELECT requisition_id FROM {TARGET_TABLE};")
    existing_ids = set(row[0] for row in cursor.fetchall())
    print(f"Fetched {len(existing_ids)} existing requisition IDs.")
    
    # 3. Generate synthetic records
    print(f"\nGenerating {DESIRED_RECORDS} new synthetic records...")
    records = generate_tdms_dataset(num_records=DESIRED_RECORDS, existing_ids=existing_ids)
    
    # Save a 50-record preview file
    preview_path = os.path.join(os.path.dirname(__file__), "tdms_sample_50_preview.json")
    preview_records = [r["payload"] for r in records[:50]]
    with open(preview_path, "w") as f:
        json.dump(preview_records, f, indent=2, default=str)
    print(f"Saved 50 sample records preview to: {preview_path}")
    
    # 4. Prepare parameterized insert SQL
    insert_sql = f"""
        INSERT INTO {TARGET_TABLE} (
            requisition_id,
            source_system,
            requisition_type,
            zone,
            division,
            section,
            block_section,
            line_name,
            traction_sub_station,
            elementary_section_no,
            preferred_date,
            start_time,
            end_time,
            duration_minutes,
            nature_of_work,
            equipment_deployed,
            payload
        ) VALUES (
            %(requisition_id)s,
            %(source_system)s,
            %(requisition_type)s,
            %(zone)s,
            %(division)s,
            %(section)s,
            %(block_section)s,
            %(line_name)s,
            %(traction_sub_station)s,
            %(elementary_section_no)s,
            %(preferred_date)s,
            %(start_time)s,
            %(end_time)s,
            %(duration_minutes)s,
            %(nature_of_work)s,
            %(equipment_deployed)s,
            %(payload)s
        );
    """
    
    # Format payload as Json adapter for psycopg2
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
        print("Transaction rolled back safely. No partial corruptions made.")
        cursor.close()
        conn.close()
        raise
        
    # 5. Row count after
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
    insert_tdms_records()
