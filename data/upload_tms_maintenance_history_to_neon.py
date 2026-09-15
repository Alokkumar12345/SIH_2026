"""
Uploader script for TMS Maintenance History data into Neon PostgreSQL Cloud.
Target: postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
"""

import json
import psycopg2
from psycopg2.extras import execute_batch

NEON_DB_URL = "postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

# Lookup mapping for section metadata enrichment
from generate_tms_maintenance_history import SECTIONS_CONFIG

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
    print("[*] Loading tms_maintenance_history.json...")
    with open("c:/IMBPS/tms_maintenance_history.json", "r", encoding="utf-8") as f:
        feed = json.load(f)

    records = feed["maintenance_history"]
    lookup = build_lookup_map()

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    print("[*] Creating table 'tms_maintenance_history' and indexes...")
    schema_sql = """
    CREATE TABLE IF NOT EXISTS tms_maintenance_history (
        job_id VARCHAR(64) PRIMARY KEY,
        source_system VARCHAR(32) NOT NULL DEFAULT 'TMS_CIVIL_ENGG',
        department VARCHAR(32) NOT NULL DEFAULT 'ENGINEERING',
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

    CREATE INDEX IF NOT EXISTS idx_tms_mh_div ON tms_maintenance_history (division);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_zone ON tms_maintenance_history (zone_code);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_section ON tms_maintenance_history (section);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_bsec ON tms_maintenance_history (block_section);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_work ON tms_maintenance_history (work_type);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_start ON tms_maintenance_history (actual_start);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_crit ON tms_maintenance_history (criticality);
    CREATE INDEX IF NOT EXISTS idx_tms_mh_payload ON tms_maintenance_history USING gin (payload);

    -- Also create a view named 'maintenance_history' for direct mapping
    CREATE OR REPLACE VIEW maintenance_history AS SELECT * FROM tms_maintenance_history;

    -- Feed container table to store full document feed
    CREATE TABLE IF NOT EXISTS tms_maintenance_feed (
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
    INSERT INTO tms_maintenance_history (
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
        key = (item["division"], item["section"])
        sec_meta = lookup.get(key, {
            "zone": "EASTERN RAILWAY" if item["division"] in ["ASN", "HWH"] else "NORTHERN RAILWAY",
            "zone_code": "ER" if item["division"] in ["ASN", "HWH"] else "NR",
            "division_name": item["division"],
            "section_display": item["section"],
            "block_sections": {}
        })
        b_name = sec_meta["block_sections"].get(item["block_section"], item["block_section"])

        rows_to_insert.append((
            item["job_id"],
            feed["source_system"],
            feed["department"],
            sec_meta["zone"],
            sec_meta["zone_code"],
            item["division"],
            sec_meta["division_name"],
            item["section"],
            sec_meta["section_display"],
            item["block_section"],
            b_name,
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
        ))

    execute_batch(cur, insert_sql, rows_to_insert)

    # Insert root feed document
    print("[*] Inserting full document feed into 'tms_maintenance_feed'...")
    cur.execute("""
        INSERT INTO tms_maintenance_feed (source_system, department, record_count, payload)
        VALUES (%s, %s, %s, %s);
    """, (feed["source_system"], feed["department"], len(records), json.dumps(feed)))

    # Verification queries
    cur.execute("SELECT COUNT(*) FROM tms_maintenance_history;")
    total_count = cur.fetchone()[0]

    cur.execute("""
        SELECT zone_code, division, COUNT(*), MIN(actual_start), MAX(actual_start)
        FROM tms_maintenance_history
        GROUP BY zone_code, division
        ORDER BY zone_code, division;
    """)
    div_breakdown = cur.fetchall()

    cur.execute("""
        SELECT work_type, COUNT(*), ROUND(AVG(actual_duration_min), 1), ROUND(AVG(overdue_days), 1)
        FROM tms_maintenance_history
        GROUP BY work_type
        ORDER BY COUNT(*) DESC;
    """)
    work_breakdown = cur.fetchall()

    print(f"\n=======================================================")
    print(f"SUCCESS: Uploaded {total_count} records to Neon PostgreSQL!")
    print(f"=======================================================")
    print("Divisional Breakdown:")
    for zc, div, count, min_d, max_d in div_breakdown:
        print(f"  - [{zc}] Division {div}: {count} records (Date Range: {min_d} to {max_d})")

    print("\nWork Type Breakdown:")
    for wt, count, avg_dur, avg_od in work_breakdown:
        print(f"  - {wt}: {count} jobs | Avg Duration: {avg_dur} mins | Avg Overdue: {avg_od} days")

    cur.close()
    conn.close()

if __name__ == "__main__":
    upload_to_neon()
