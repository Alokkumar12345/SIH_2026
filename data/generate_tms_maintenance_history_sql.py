"""
Script to generate neon_tms_maintenance_history.sql containing complete schema,
indexes, views, and raw INSERT statements for standalone execution.
"""

import json
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

def generate_sql():
    with open("c:/IMBPS/tms_maintenance_history.json", "r", encoding="utf-8") as f:
        feed = json.load(f)

    records = feed["maintenance_history"]
    lookup = build_lookup_map()

    lines = []
    lines.append("-- ========================================================================")
    lines.append("-- NEON POSTGRESQL SCHEMA & INSERTS FOR INDIAN RAILWAYS TMS MAINTENANCE HISTORY")
    lines.append("-- SIH Problem Statement - Track Management System (TMS)")
    lines.append("-- Zones: EASTERN RAILWAY (ASN & HWH Divisions), NORTHERN RAILWAY (UMB Division)")
    lines.append("-- ========================================================================\n")

    lines.append("CREATE TABLE IF NOT EXISTS tms_maintenance_history (")
    lines.append("    job_id VARCHAR(64) PRIMARY KEY,")
    lines.append("    source_system VARCHAR(32) NOT NULL DEFAULT 'TMS_CIVIL_ENGG',")
    lines.append("    department VARCHAR(32) NOT NULL DEFAULT 'ENGINEERING',")
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

    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_div ON tms_maintenance_history (division);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_zone ON tms_maintenance_history (zone_code);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_section ON tms_maintenance_history (section);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_bsec ON tms_maintenance_history (block_section);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_work ON tms_maintenance_history (work_type);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_start ON tms_maintenance_history (actual_start);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_crit ON tms_maintenance_history (criticality);")
    lines.append("CREATE INDEX IF NOT EXISTS idx_tms_mh_payload ON tms_maintenance_history USING gin (payload);\n")

    lines.append("CREATE OR REPLACE VIEW maintenance_history AS SELECT * FROM tms_maintenance_history;\n")

    lines.append("CREATE TABLE IF NOT EXISTS tms_maintenance_feed (")
    lines.append("    id SERIAL PRIMARY KEY,")
    lines.append("    source_system VARCHAR(32) NOT NULL,")
    lines.append("    department VARCHAR(32) NOT NULL,")
    lines.append("    record_count INTEGER NOT NULL,")
    lines.append("    payload JSONB NOT NULL,")
    lines.append("    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    lines.append(");\n")

    lines.append("-- ========================================================================")
    lines.append("-- RECORD INSERTS (280 Track Maintenance History Jobs)")
    lines.append("-- ========================================================================\n")

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
        payload_str = json.dumps(item).replace("'", "''")

        sql_line = (
            f"INSERT INTO tms_maintenance_history ("
            f"job_id, source_system, department, zone, zone_code, division, division_name, "
            f"section, section_display, block_section, block_section_name, line, "
            f"work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment, "
            f"requested_duration_min, actual_duration_min, actual_start, actual_end, "
            f"completion_status, payload"
            f") VALUES ("
            f"'{item['job_id']}', '{feed['source_system']}', '{feed['department']}', "
            f"'{sec_meta['zone']}', '{sec_meta['zone_code']}', '{item['division']}', '{sec_meta['division_name']}', "
            f"'{item['section']}', '{sec_meta['section_display']}', '{item['block_section']}', '{b_name}', '{item['line']}', "
            f"'{item['work_type']}', '{item['asset_type']}', '{item['severity']}', '{item['criticality']}', "
            f"{item['overdue_days']}, {item['crew_size']}, '{item['equipment']}', "
            f"{item['requested_duration_min']}, {item['actual_duration_min']}, "
            f"'{item['actual_start']}', '{item['actual_end']}', "
            f"'{item['completion_status']}', '{payload_str}'::jsonb"
            f") ON CONFLICT (job_id) DO UPDATE SET "
            f"actual_duration_min = EXCLUDED.actual_duration_min, "
            f"completion_status = EXCLUDED.completion_status, "
            f"payload = EXCLUDED.payload;"
        )
        lines.append(sql_line)

    output_path = "c:/IMBPS/neon_tms_maintenance_history.sql"
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"[+] Successfully wrote {len(records)} SQL inserts to {output_path}")

if __name__ == "__main__":
    generate_sql()
