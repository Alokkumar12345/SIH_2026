"""
Upload script for SMMS Signal & Telecom Disconnection Requisitions to Neon PostgreSQL Cloud
Target: postgresql://neondb_owner:npg_6BKvskhxM7yt@ep-noisy-glitter-aersnkh1-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
"""

import json
import psycopg2
from psycopg2.extras import execute_batch

NEON_DB_URL = "postgresql://neondb_owner:npg_6BKvskhxM7yt@ep-noisy-glitter-aersnkh1-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def upload_smms_data(db_url=NEON_DB_URL):
    print("[*] Reading smms_data.json...")
    with open("c:/IMBPS/smms_data.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    print("[*] Creating table 'smms_signal_disconnections' if not exists...")
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS smms_signal_disconnections (
        disconnection_ref_id VARCHAR(64) PRIMARY KEY,
        source_system VARCHAR(32) NOT NULL,
        form_type VARCHAR(64) NOT NULL,
        division VARCHAR(64) NOT NULL,
        station_code VARCHAR(16) NOT NULL,
        station_name VARCHAR(64) NOT NULL,
        gear_type VARCHAR(64) NOT NULL,
        gear_id VARCHAR(64) NOT NULL,
        maintenance_nature TEXT NOT NULL,
        requires_traffic_block BOOLEAN NOT NULL,
        fouling_mark_infringed BOOLEAN NOT NULL,
        slot_date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        duration_minutes INTEGER NOT NULL,
        crank_handle_locked BOOLEAN NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    CREATE INDEX IF NOT EXISTS idx_smms_div ON smms_signal_disconnections (division);
    CREATE INDEX IF NOT EXISTS idx_smms_stn ON smms_signal_disconnections (station_code);
    CREATE INDEX IF NOT EXISTS idx_smms_gear ON smms_signal_disconnections (gear_type);
    CREATE INDEX IF NOT EXISTS idx_smms_date ON smms_signal_disconnections (slot_date);
    CREATE INDEX IF NOT EXISTS idx_smms_payload ON smms_signal_disconnections USING gin (payload);
    """
    cur.execute(create_table_sql)

    print(f"[*] Inserting {len(data)} SMMS Signal & Telecom disconnection records...")
    insert_sql = """
    INSERT INTO smms_signal_disconnections (
        disconnection_ref_id, source_system, form_type, division,
        station_code, station_name, gear_type, gear_id,
        maintenance_nature, requires_traffic_block, fouling_mark_infringed,
        slot_date, start_time, end_time, duration_minutes,
        crank_handle_locked, payload
    ) VALUES (
        %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s
    ) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
    """

    rows = []
    for item in data:
        ref_id = item["disconnection_ref_id"]
        src = item["source_system"]
        f_type = item["form_type"]
        div = item["asset_location"]["division"]
        stn_code = item["asset_location"]["station_code"]
        stn_name = item["asset_location"]["station_name"]
        gear_type = item["asset_location"]["affected_gear"]["gear_type"]
        gear_id = item["asset_location"]["affected_gear"]["gear_id"]
        maint = item["disconnection_specifications"]["maintenance_nature"]
        req_tb = item["disconnection_specifications"]["requires_traffic_block"]
        foul = item["disconnection_specifications"]["fouling_mark_infringed"]
        s_date = item["disconnection_specifications"]["requested_slot"]["date"]
        s_time = item["disconnection_specifications"]["requested_slot"]["start_time"]
        e_time = item["disconnection_specifications"]["requested_slot"]["end_time"]
        dur = item["disconnection_specifications"]["requested_slot"]["duration_minutes"]
        crank = item["safety_protocols"]["crank_handle_locked"]
        payload_str = json.dumps(item)

        rows.append((
            ref_id, src, f_type, div,
            stn_code, stn_name, gear_type, gear_id,
            maint, req_tb, foul,
            s_date, s_time, e_time, dur,
            crank, payload_str
        ))

    execute_batch(cur, insert_sql, rows)

    cur.execute("SELECT COUNT(*) FROM smms_signal_disconnections;")
    total_count = cur.fetchone()[0]

    cur.execute("SELECT division, COUNT(*) FROM smms_signal_disconnections GROUP BY division ORDER BY division;")
    breakdown = cur.fetchall()

    print(f"\n[+] SUCCESS: Uploaded and verified {total_count} records in 'smms_signal_disconnections' on Neon Cloud!")
    print("[+] Division Breakdown:")
    for d, c in breakdown:
        print(f"    - {d}: {c} records")

    cur.close()
    conn.close()

if __name__ == "__main__":
    upload_smms_data()
