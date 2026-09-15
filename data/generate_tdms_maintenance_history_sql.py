"""
Script to generate neon_tdms_maintenance_history.sql containing complete schema,
indexes, views, and raw INSERT statements for standalone execution.
"""

import json
from generate_tdms_maintenance_history import SECTIONS_CONFIG

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

def generate_sql():
    with open("c:/IMBPS/tdms_maintenance_history.json", "r", encoding="utf-8") as f:
        feed = json.load(f)

    records = feed["maintenance_history"]
    lookup = build_lookup_map()

    lines = []
    lines.append("-- ========================================================================")
    lines.append("-- NEON POSTGRESQL SCHEMA & INSERTS FOR INDIAN RAILWAYS TDMS MAINTENANCE HISTORY")
    lines.append("-- SIH Problem Statement - Traction Distribution Management System (TDMS / Electrical TRD)")
    lines.append("-- Zones: EASTERN RAILWAY (ASN & HWH Divisions), NORTHERN RAILWAY (UMB Division)")
    lines.append("-- ========================================================================\n")

    lines.append("CREATE TABLE IF NOT EXISTS tdms_maintenance_history (")
    lines.append("    job_id VARCHAR(64) PRIMARY KEY,")
    lines.append("    source_system VARCHAR(32) NOT NULL DEFAULT 'TDMS_ELECTRICAL_TRD',")
    lines.append("    department VARCHAR(32) NOT NULL DEFAULT 'TRD',")
    lines.append("    zone VARCHAR(64) NOT NULL,")
    lines.append("    zone_code VARCHAR(16) NOT NULL,")
    lines.append("    division VARCHAR(32) NOT NULL,")
    lines.append("    division_name VARCHAR(64) NOT NULL,")
    lines.append("    section VARCHAR(128) NOT NULL,")
    lines.append("    section_display VARCHAR(128) NOT NULL,")
    lines.append("    block_section VARCHAR(128) NOT NULL,")
    lines.append("    block_section_name VARCHAR(128) NOT NULL,")
    lines.append("    line VARCHAR(64) NOT NULL,")
    lines.append("    work_type VARCHAR(128) NOT NULL,")
    lines.append("    asset_type VARCHAR(64) NOT NULL,")
    lines.append("    severity VARCHAR(32) NOT NULL,")
    lines.append("    criticality VARCHAR(32) NOT NULL,")
    lines.append("    overdue_days INTEGER NOT NULL,")
    lines.append("    crew_size INTEGER NOT NULL,")
    lines.append("    equipment VARCHAR(128) NOT NULL,")
    lines.append("    requested_duration_min INTEGER NOT NULL,")
    lines.append("    actual_duration_min INTEGER NOT NULL,")
    lines.append("    actual_start TIMESTAMP NOT NULL,")
    lines.append("    actual_end TIMESTAMP NOT NULL,")
    lines.append("    completion_status VARCHAR(64) NOT NULL,")
    lines.append("    payload JSONB NOT NULL,")
    lines.append("    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    lines.append(");\n")

    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_div ON tdms_maintenance_history (division);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_zone ON tdms_maintenance_history (zone_code);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_section ON tdms_maintenance_history (section);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_bsec ON tdms_maintenance_history (block_section);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_work ON tdms_maintenance_history (work_type);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_asset ON tdms_maintenance_history (asset_type);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_start ON tdms_maintenance_history (actual_start);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_crit ON tdms_maintenance_history (criticality);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tdms_mh_payload ON tdms_maintenance_history USING gin (payload);\n")

    lines.append("CREATE OR REPLACE VIEW maintenance_history AS SELECT * FROM tdms_maintenance_history;\n")

    lines.append("CREATE TABLE IF NOT EXISTS tdms_maintenance_feed (")
    lines.append("    id SERIAL PRIMARY KEY,")
    lines.append("    source_system VARCHAR(32) NOT NULL,")
    lines.append("    department VARCHAR(32) NOT NULL,")
    lines.append("    record_count INTEGER NOT NULL,")
    lines.append("    payload JSONB NOT NULL,")
    lines.append("    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    lines.append(");\n")

    lines.append("-- ------------------------------------------------------------------------")
    lines.append(f"-- INSERT STATEMENTS FOR {len(records)} TDMS RECORDS")
    lines.append("-- ------------------------------------------------------------------------\n")

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

        payload_json = json.dumps(item).replace("'", "''")
        sec_disp = sec_meta["section_display"].replace("'", "''")
        b_name = bsec_name.replace("'", "''")
        w_type = item["work_type"].replace("'", "''")
        eq = item["equipment"].replace("'", "''")

        stmt = f"""INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    '{item["job_id"]}', '{feed.get("source_system", "TDMS_ELECTRICAL_TRD")}', '{feed.get("department", "TRD")}',
    '{sec_meta["zone"]}', '{sec_meta["zone_code"]}', '{div}', '{sec_meta["division_name"]}',
    '{sec}', '{sec_disp}', '{bsec}', '{b_name}', '{item["line"]}',
    '{w_type}', '{item["asset_type"]}', '{item["severity"]}', '{item["criticality"]}',
    {item["overdue_days"]}, {item["crew_size"]}, '{eq}',
    {item["requested_duration_min"]}, {item["actual_duration_min"]}, '{item["actual_start"]}', '{item["actual_end"]}',
    '{item["completion_status"]}', '{payload_json}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;"""
        lines.append(stmt)

    output_path = "c:/IMBPS/neon_tdms_maintenance_history.sql"
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"[OK] Generated {output_path} with {len(records)} INSERT statements.")

if __name__ == "__main__":
    generate_sql()
