"""
Script to create TMS table in Neon and upload all records from tms_data.json.
Target Connection: postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
"""

import json
import sys
import psycopg2

NEON_DB_URL = "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def upload_tms_data(db_url=NEON_DB_URL):
    print("[*] Loading tms_data.json...")
    with open("c:/IMBPS/tms_data.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    print("[*] Creating table 'tms_civil_demands' if not exists...")
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS tms_civil_demands (
        demand_ref_id VARCHAR(64) PRIMARY KEY,
        source_system VARCHAR(32) NOT NULL,
        division VARCHAR(64) NOT NULL,
        section VARCHAR(128) NOT NULL,
        block_section VARCHAR(128) NOT NULL,
        line_name VARCHAR(128) NOT NULL,
        work_type VARCHAR(128) NOT NULL,
        demand_nature VARCHAR(64) NOT NULL,
        preferred_date DATE NOT NULL,
        duration_minutes INTEGER NOT NULL,
        preferred_start TIME NOT NULL,
        preferred_end TIME NOT NULL,
        power_block_required BOOLEAN NOT NULL,
        st_disconnection_required BOOLEAN NOT NULL,
        post_work_speed_kmph INTEGER,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    CREATE INDEX IF NOT EXISTS idx_tms_div ON tms_civil_demands (division);
    CREATE INDEX IF NOT EXISTS idx_tms_section ON tms_civil_demands (section);
    CREATE INDEX IF NOT EXISTS idx_tms_date ON tms_civil_demands (preferred_date);
    CREATE INDEX IF NOT EXISTS idx_tms_payload ON tms_civil_demands USING gin (payload);
    """
    cur.execute(create_table_sql)

    print(f"[*] Inserting {len(data)} TMS Civil Engineering records...")
    insert_sql = """
    INSERT INTO tms_civil_demands (
        demand_ref_id, source_system, division, section, block_section, line_name,
        work_type, demand_nature, preferred_date, duration_minutes,
        preferred_start, preferred_end, power_block_required, st_disconnection_required,
        post_work_speed_kmph, payload
    ) VALUES (
        %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s
    ) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
    """

    rows_to_insert = []
    for item in data:
        ref_id = item["demand_ref_id"]
        src = item["source_system"]
        div = item["location_details"]["division"]
        sec = item["location_details"]["section"]
        b_sec = item["location_details"]["block_section"]
        line = item["location_details"]["line"]
        w_type = item["block_specifications"]["work_type"]
        d_nature = item["block_specifications"]["demand_nature"]
        p_date = item["block_specifications"]["preferred_date"]
        dur = item["block_specifications"]["requested_window"]["duration_minutes"]
        p_start = item["block_specifications"]["requested_window"]["preferred_start"]
        p_end = item["block_specifications"]["requested_window"]["preferred_end"]
        pb_req = item["interdepartmental_dependencies"]["power_block_required"]
        st_req = item["interdepartmental_dependencies"]["st_disconnection_required"]
        speed = item["speed_restriction_proposed"]["post_work_speed_kmph"]
        payload_json = json.dumps(item)

        rows_to_insert.append((
            ref_id, src, div, sec, b_sec, line,
            w_type, d_nature, p_date, dur,
            p_start, p_end, pb_req, st_req,
            speed, payload_json
        ))

    from psycopg2.extras import execute_batch
    execute_batch(cur, insert_sql, rows_to_insert)

    cur.execute("SELECT COUNT(*) FROM tms_civil_demands;")
    total_count = cur.fetchone()[0]

    cur.execute("SELECT division, COUNT(*) FROM tms_civil_demands GROUP BY division ORDER BY division;")
    breakdown = cur.fetchall()

    print(f"\n[+] SUCCESS: Uploaded and verified {total_count} records in 'tms_civil_demands' table on Neon Cloud!")
    print("[+] Division Breakdown:")
    for d, c in breakdown:
        print(f"    - {d}: {c} records")

    cur.close()
    conn.close()

if __name__ == "__main__":
    upload_tms_data()
