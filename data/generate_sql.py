"""
SQL Schema and Migration script for Neon PostgreSQL.
Reads tdms_data.json and generates neon_ready_insert.sql
"""

import json

def generate_sql():
    with open("c:/IMBPS/tdms_data.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    sql_statements = []

    sql_statements.append("-- =====================================================")
    sql_statements.append("-- NEON POSTGRESQL SCHEMA FOR IR TDMS ELECTRICAL TRD")
    sql_statements.append("-- =====================================================")
    sql_statements.append("CREATE TABLE IF NOT EXISTS tdms_requisitions (")
    sql_statements.append("    requisition_id VARCHAR(64) PRIMARY KEY,")
    sql_statements.append("    source_system VARCHAR(32) NOT NULL,")
    sql_statements.append("    requisition_type VARCHAR(64) NOT NULL,")
    sql_statements.append("    zone VARCHAR(64) NOT NULL,")
    sql_statements.append("    division VARCHAR(64) NOT NULL,")
    sql_statements.append("    section VARCHAR(128) NOT NULL,")
    sql_statements.append("    block_section VARCHAR(128) NOT NULL,")
    sql_statements.append("    line_name VARCHAR(128) NOT NULL,")
    sql_statements.append("    traction_sub_station VARCHAR(64),")
    sql_statements.append("    elementary_section_no VARCHAR(32),")
    sql_statements.append("    preferred_date DATE NOT NULL,")
    sql_statements.append("    start_time TIME NOT NULL,")
    sql_statements.append("    end_time TIME NOT NULL,")
    sql_statements.append("    duration_minutes INTEGER NOT NULL,")
    sql_statements.append("    nature_of_work TEXT NOT NULL,")
    sql_statements.append("    equipment_deployed TEXT,")
    sql_statements.append("    payload JSONB NOT NULL,")
    sql_statements.append("    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    sql_statements.append(");")
    sql_statements.append("")
    sql_statements.append("CREATE INDEX IF NOT EXISTS idx_tdms_zone_div ON tdms_requisitions (zone, division);")
    sql_statements.append("CREATE INDEX IF NOT EXISTS idx_tdms_section ON tdms_requisitions (section);")
    sql_statements.append("CREATE INDEX IF NOT EXISTS idx_tdms_date ON tdms_requisitions (preferred_date);")
    sql_statements.append("CREATE INDEX IF NOT EXISTS idx_tdms_payload ON tdms_requisitions USING gin (payload);")
    sql_statements.append("")
    sql_statements.append("-- =====================================================")
    sql_statements.append("-- INSERT DATA STATEMENTS")
    sql_statements.append("-- =====================================================")

    for item in data:
        req_id = item["requisition_id"].replace("'", "''")
        src = item["source_system"].replace("'", "''")
        rtype = item["requisition_type"].replace("'", "''")
        zone = item["electrical_section_details"]["zone"].replace("'", "''")
        div = item["electrical_section_details"]["division"].replace("'", "''")
        sec = item["physical_track_boundaries"]["section"].replace("'", "''")
        b_sec = item["physical_track_boundaries"]["block_section"].replace("'", "''")
        line = item["physical_track_boundaries"]["line"].replace("'", "''")
        tss = item["electrical_section_details"]["traction_sub_station"].replace("'", "''")
        es = item["electrical_section_details"]["elementary_section_no"].replace("'", "''")
        pdate = item["work_specifications"]["preferred_window"]["date"]
        stime = item["work_specifications"]["preferred_window"]["start_time"]
        etime = item["work_specifications"]["preferred_window"]["end_time"]
        dur = item["work_specifications"]["duration_minutes"]
        nowork = item["work_specifications"]["nature_of_work"].replace("'", "''")
        eq = item["work_specifications"]["equipment_deployed"].replace("'", "''")
        payload_str = json.dumps(item).replace("'", "''")

        stmt = f"""INSERT INTO tdms_requisitions (
    requisition_id, source_system, requisition_type, zone, division, section, 
    block_section, line_name, traction_sub_station, elementary_section_no, 
    preferred_date, start_time, end_time, duration_minutes, nature_of_work, equipment_deployed, payload
) VALUES (
    '{req_id}', '{src}', '{rtype}', '{zone}', '{div}', '{sec}', 
    '{b_sec}', '{line}', '{tss}', '{es}', 
    '{pdate}', '{stime}', '{etime}', {dur}, '{nowork}', '{eq}', '{payload_str}'::jsonb
) ON CONFLICT (requisition_id) DO UPDATE SET payload = EXCLUDED.payload;"""
        sql_statements.append(stmt)

    with open("c:/IMBPS/neon_schema_and_inserts.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(sql_statements))

    print(f"Generated neon_schema_and_inserts.sql with {len(data)} rows.")

if __name__ == "__main__":
    generate_sql()
