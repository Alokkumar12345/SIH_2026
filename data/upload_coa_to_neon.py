"""
Uploader script for all 4 COA feeds into Neon PostgreSQL Cloud.
Target: postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
"""

import json
import psycopg2
from psycopg2.extras import execute_batch

NEON_DB_URL = "postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def upload_coa_to_neon(db_url=NEON_DB_URL):
    print("[*] Reading coa_data.json...")
    with open("c:/IMBPS/coa_data.json", "r", encoding="utf-8") as f:
        coa = json.load(f)

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    print("[*] Creating COA tables...")
    create_tables_sql = """
    -- 1. Master Timetable Paths
    CREATE TABLE IF NOT EXISTS coa_master_timetable (
        id SERIAL PRIMARY KEY,
        train_number VARCHAR(32) NOT NULL,
        train_name VARCHAR(128) NOT NULL,
        division_code VARCHAR(16) NOT NULL,
        sub_division VARCHAR(64) NOT NULL,
        traction VARCHAR(32),
        train_length_coaches INTEGER,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    CREATE INDEX IF NOT EXISTS idx_coa_tt_div ON coa_master_timetable (division_code);
    CREATE INDEX IF NOT EXISTS idx_coa_tt_train ON coa_master_timetable (train_number);
    CREATE INDEX IF NOT EXISTS idx_coa_tt_payload ON coa_master_timetable USING gin (payload);

    -- 2. Priority Constraint Policy
    CREATE TABLE IF NOT EXISTS coa_priority_policies (
        id SERIAL PRIMARY KEY,
        zone_code VARCHAR(16) NOT NULL,
        division_code VARCHAR(16) NOT NULL,
        sub_division VARCHAR(64) NOT NULL,
        corridor_classification VARCHAR(64) NOT NULL,
        policy_year VARCHAR(16) NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    CREATE INDEX IF NOT EXISTS idx_coa_pol_div ON coa_priority_policies (division_code);
    CREATE INDEX IF NOT EXISTS idx_coa_pol_payload ON coa_priority_policies USING gin (payload);

    -- 3. Weekly Station Yard Capacity
    CREATE TABLE IF NOT EXISTS coa_weekly_yard_capacity (
        id SERIAL PRIMARY KEY,
        station_code VARCHAR(16) NOT NULL,
        station_name VARCHAR(64) NOT NULL,
        division_code VARCHAR(16) NOT NULL,
        sub_division VARCHAR(64) NOT NULL,
        target_week VARCHAR(16) NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    CREATE INDEX IF NOT EXISTS idx_coa_yd_stn ON coa_weekly_yard_capacity (station_code);
    CREATE INDEX IF NOT EXISTS idx_coa_yd_div ON coa_weekly_yard_capacity (division_code);
    CREATE INDEX IF NOT EXISTS idx_coa_yd_payload ON coa_weekly_yard_capacity USING gin (payload);

    -- 4. Candidate Offered Slots
    CREATE TABLE IF NOT EXISTS coa_offered_slots (
        coa_slot_id VARCHAR(64) PRIMARY KEY,
        division_code VARCHAR(16) NOT NULL,
        sub_division VARCHAR(64) NOT NULL,
        section_id VARCHAR(64) NOT NULL,
        block_section VARCHAR(128) NOT NULL,
        line VARCHAR(32) NOT NULL,
        target_date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        duration_minutes INTEGER NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    CREATE INDEX IF NOT EXISTS idx_coa_slot_div ON coa_offered_slots (division_code);
    CREATE INDEX IF NOT EXISTS idx_coa_slot_sec ON coa_offered_slots (section_id);
    CREATE INDEX IF NOT EXISTS idx_coa_slot_date ON coa_offered_slots (target_date);
    CREATE INDEX IF NOT EXISTS idx_coa_slot_payload ON coa_offered_slots USING gin (payload);
    """
    cur.execute(create_tables_sql)

    # 1. Insert Master Timetable Records
    print("[*] Inserting Master Timetable Records...")
    tt_rows = []
    for feed in coa["master_timetable_feeds"]:
        for record in feed["timetable_records"]:
            tt_rows.append((
                record["train_number"],
                record["train_name"],
                record["division_code"],
                record["sub_division"],
                record.get("traction", "ELECTRIC_3PH"),
                record.get("train_length_coaches", 18),
                json.dumps(record)
            ))
    cur.execute("TRUNCATE TABLE coa_master_timetable;")
    execute_batch(cur, """
        INSERT INTO coa_master_timetable (
            train_number, train_name, division_code, sub_division, traction, train_length_coaches, payload
        ) VALUES (%s, %s, %s, %s, %s, %s, %s);
    """, tt_rows)

    # 2. Insert Priority Policy Feeds
    print("[*] Inserting Priority Constraint Policies...")
    pol_rows = []
    for feed in coa["priority_policy_feeds"]:
        pol_rows.append((
            feed["zone_code"],
            feed["division_code"],
            feed["sub_division"],
            feed["corridor_classification"],
            feed["policy_year"],
            json.dumps(feed)
        ))
    cur.execute("TRUNCATE TABLE coa_priority_policies;")
    execute_batch(cur, """
        INSERT INTO coa_priority_policies (
            zone_code, division_code, sub_division, corridor_classification, policy_year, payload
        ) VALUES (%s, %s, %s, %s, %s, %s);
    """, pol_rows)

    # 3. Insert Yard Capacity Stations
    print("[*] Inserting Weekly Yard Capacity Stations...")
    yd_rows = []
    for feed in coa["yard_capacity_feeds"]:
        target_week = feed["target_week"]
        for stn in feed["stations"]:
            yd_rows.append((
                stn["station_code"],
                stn["station_name"],
                stn["division_code"],
                stn["sub_division"],
                target_week,
                json.dumps(stn)
            ))
    cur.execute("TRUNCATE TABLE coa_weekly_yard_capacity;")
    execute_batch(cur, """
        INSERT INTO coa_weekly_yard_capacity (
            station_code, station_name, division_code, sub_division, target_week, payload
        ) VALUES (%s, %s, %s, %s, %s, %s);
    """, yd_rows)

    # 4. Insert Candidate Offered Slots
    print("[*] Inserting Candidate Offered Slots...")
    slot_rows = []
    for feed in coa["offered_slots_feeds"]:
        for slot in feed["candidate_slots"]:
            slot_rows.append((
                slot["coa_slot_id"],
                slot["division_code"],
                slot["sub_division"],
                slot["section_id"],
                slot["block_section"],
                slot["line"],
                slot["target_date"],
                slot["slot_window"]["start_time"],
                slot["slot_window"]["end_time"],
                slot["slot_window"]["duration_minutes"],
                json.dumps(slot)
            ))
    cur.execute("TRUNCATE TABLE coa_offered_slots;")
    execute_batch(cur, """
        INSERT INTO coa_offered_slots (
            coa_slot_id, division_code, sub_division, section_id, block_section,
            line, target_date, start_time, end_time, duration_minutes, payload
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (coa_slot_id) DO UPDATE SET payload = EXCLUDED.payload;
    """, slot_rows)

    # Verification counts
    print("\n[+] VERIFICATION ON NEON CLOUD:")
    for tbl in ["coa_master_timetable", "coa_priority_policies", "coa_weekly_yard_capacity", "coa_offered_slots"]:
        cur.execute(f"SELECT COUNT(*) FROM {tbl};")
        cnt = cur.fetchone()[0]
        print(f"    - Table '{tbl}': {cnt} records")

    cur.close()
    conn.close()
    print("[+] SUCCESS: All 4 COA tables migrated to Neon successfully!")

if __name__ == "__main__":
    upload_coa_to_neon()
