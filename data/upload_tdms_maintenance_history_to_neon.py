"""
Uploader script for TDMS Electrical TRD Maintenance History data into Neon PostgreSQL Cloud.
Target: postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
"""

import json
import psycopg2
from psycopg2.extras import execute_batch
from generate_tdms_maintenance_history import SECTIONS_CONFIG

NEON_DB_URL = "postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def build_lookup_map():
    lookup = {}
    for sec in SECTIONS_CONFIG:
        div = sec["division"]
        sec_code = sec["section"]
        key = (div, sec_code)
        b_map = {b["code"]: b["name"] for b in sec["block_sections"]}
        lookup[key] = {
            "zone": sec["zone"],
            "zone_code": sec["zone_code"],
            "division_name": sec["division_name"],
            "section_display": sec["section_display"],
            "block_sections": b_map
        }
    return lookup

def upload_to_neon(db_url=NEON_DB_URL):
    print("[*] Loading tdms_maintenance_history.json...")
    with open("c:/IMBPS/tdms_maintenance_history.json", "r", encoding="utf-8") as f:
        feed = json.load(f)

    records = feed["maintenance_history"]
    lookup = build_lookup_map()

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    print("[*] Creating table 'tdms_maintenance_history', indexes and views...")
    schema_sql = """
    CREATE TABLE IF NOT EXISTS tdms_maintenance_history (
        job_id VARCHAR(64) PRIMARY KEY,
        source_system VARCHAR(32) NOT NULL DEFAULT 'TDMS_ELECTRICAL_TRD',
        department VARCHAR(32) NOT NULL DEFAULT 'TRD',
        zone VARCHAR(64) NOT NULL,
        zone_code VARCHAR(16) NOT NULL,
        division VARCHAR(32) NOT NULL,
        division_name VARCHAR(64) NOT NULL,
        section VARCHAR(128) NOT NULL,
        section_display VARCHAR(128) NOT NULL,
        block_section VARCHAR(128) NOT NULL,
        block_section_name VARCHAR(128) NOT NULL,
        line VARCHAR(64) NOT NULL,
        work_type VARCHAR(128) NOT NULL,
        asset_type VARCHAR(64) NOT NULL,
        severity VARCHAR(32) NOT NULL,
        criticality VARCHAR(32) NOT NULL,
        overdue_days INTEGER NOT NULL,
        crew_size INTEGER NOT NULL,
        equipment VARCHAR(128) NOT NULL,
        requested_duration_min INTEGER NOT NULL,
        actual_duration_min INTEGER NOT NULL,
        actual_start TIMESTAMP NOT NULL,
        actual_end TIMESTAMP NOT NULL,
        completion_status VARCHAR(64) NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );

    CREATE INDEX IF NOT EXISTS idx_tdms_mh_div ON tdms_maintenance_history (division);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_zone ON tdms_maintenance_history (zone_code);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_section ON tdms_maintenance_history (section);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_bsec ON tdms_maintenance_history (block_section);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_work ON tdms_maintenance_history (work_type);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_asset ON tdms_maintenance_history (asset_type);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_start ON tdms_maintenance_history (actual_start);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_crit ON tdms_maintenance_history (criticality);
    CREATE INDEX IF NOT EXISTS idx_tdms_mh_payload ON tdms_maintenance_history USING gin (payload);

    -- Standard maintenance_history view for direct querying
    CREATE OR REPLACE VIEW maintenance_history AS SELECT * FROM tdms_maintenance_history;

    -- Feed container table to store full document feed
    CREATE TABLE IF NOT EXISTS tdms_maintenance_feed (
        id SERIAL PRIMARY KEY,
        source_system VARCHAR(32) NOT NULL,
        department VARCHAR(32) NOT NULL,
        record_count INTEGER NOT NULL,
        payload JSONB NOT NULL,
        uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
    """
    cur.execute(schema_sql)

    print(f"[*] Preparing batch insert of {len(records)} records...")
    insert_sql = """
    INSERT INTO tdms_maintenance_history (
        job_id, source_system, department, zone, zone_code, division, division_name,
        section, section_display, block_section, block_section_name, line,
        work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
        requested_duration_min, actual_duration_min, actual_start, actual_end,
        completion_status, payload
    ) VALUES (
        %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s
    ) ON CONFLICT (job_id) DO UPDATE SET
        actual_duration_min = EXCLUDED.actual_duration_min,
        completion_status = EXCLUDED.completion_status,
        payload = EXCLUDED.payload;
    """

    rows_to_insert = []
    for item in records:
        div = item["division"]
        sec = item["section"]
        bsec = item["block_section"]

        sec_meta = lookup.get((div, sec), {
            "zone": "EASTERN RAILWAY" if div in ["ASN", "HWH"] else "NORTHERN RAILWAY",
            "zone_code": "ER" if div in ["ASN", "HWH"] else "NR",
            "division_name": "Asansol" if div == "ASN" else ("Howrah" if div == "HWH" else "Ambala"),
            "section_display": sec,
            "block_sections": {}
        })

        bsec_name = sec_meta["block_sections"].get(bsec, bsec)

        row = (
            item["job_id"],
            feed.get("source_system", "TDMS_ELECTRICAL_TRD"),
            feed.get("department", "TRD"),
            sec_meta["zone"],
            sec_meta["zone_code"],
            div,
            sec_meta["division_name"],
            sec,
            sec_meta["section_display"],
            bsec,
            bsec_name,
            item["line"],
            item["work_type"],
            item["asset_type"],
            item["severity"],
            item["criticality"],
            item["overdue_days"],
            item["crew_size"],
            item["equipment"],
            item["requested_duration_min"],
            item["actual_duration_min"],
            item["actual_start"],
            item["actual_end"],
            item["completion_status"],
            json.dumps(item)
        )
        rows_to_insert.append(row)

    print(f"[*] Executing execute_batch with {len(rows_to_insert)} rows...")
    execute_batch(cur, insert_sql, rows_to_insert, page_size=100)

    print("[*] Storing full feed payload into tdms_maintenance_feed...")
    cur.execute("""
    INSERT INTO tdms_maintenance_feed (source_system, department, record_count, payload)
    VALUES (%s, %s, %s, %s);
    """, (
        feed.get("source_system", "TDMS_ELECTRICAL_TRD"),
        feed.get("department", "TRD"),
        len(records),
        json.dumps(feed)
    ))

    # Verification queries
    print("\n" + "="*70)
    print("VERIFICATION OF UPLOADED TDMS DATA ON NEON POSTGRESQL CLOUD")
    print("="*70)

    cur.execute("SELECT COUNT(*) FROM tdms_maintenance_history;")
    total_count = cur.fetchone()[0]
    print(f"[*] Total rows in 'tdms_maintenance_history': {total_count}")

    cur.execute("SELECT COUNT(*) FROM maintenance_history;")
    view_count = cur.fetchone()[0]
    print(f"[*] Total rows in 'maintenance_history' view: {view_count}")

    print("\n[*] Breakdown by Zone and Division:")
    cur.execute("""
    SELECT zone_code, zone, division, division_name, COUNT(*) AS count
    FROM tdms_maintenance_history
    GROUP BY zone_code, zone, division, division_name
    ORDER BY zone_code, division;
    """)
    for r in cur.fetchall():
        print(f"  {r[0]} ({r[1]}) - Division {r[2]} ({r[3]}): {r[4]} records")

    print("\n[*] Breakdown by Asset Type:")
    cur.execute("""
    SELECT asset_type, COUNT(*) AS count
    FROM tdms_maintenance_history
    GROUP BY asset_type
    ORDER BY count DESC;
    """)
    for r in cur.fetchall():
        print(f"  {r[0]}: {r[1]} records")

    print("\n[*] Section Coverage Verification:")
    cur.execute("""
    SELECT division, section, section_display, COUNT(DISTINCT block_section) AS bsec_count, COUNT(*) AS total_jobs
    FROM tdms_maintenance_history
    GROUP BY division, section, section_display
    ORDER BY division, section;
    """)
    for r in cur.fetchall():
        print(f"  [{r[0]}] {r[2]} ({r[1]}): {r[3]} block sections, {r[4]} maintenance jobs")

    print("\n[*] Sample Record from Database:")
    cur.execute("""
    SELECT job_id, division, section, block_section, line, work_type, asset_type,
           severity, criticality, overdue_days, crew_size, equipment,
           requested_duration_min, actual_duration_min, actual_start, actual_end, completion_status
    FROM tdms_maintenance_history
    ORDER BY actual_start ASC
    LIMIT 3;
    """)
    cols = [desc[0] for desc in cur.description]
    for row in cur.fetchall():
        print("  {")
        for col_name, val in zip(cols, row):
            print(f'    "{col_name}": {repr(str(val) if isinstance(val, (str, type(None))) else val)},')
        print("  }")

    cur.close()
    conn.close()
    print("\n[OK] TDMS Maintenance History successfully persisted on Neon Cloud PostgreSQL!")

if __name__ == "__main__":
    upload_to_neon()
