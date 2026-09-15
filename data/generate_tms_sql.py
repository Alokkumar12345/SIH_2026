"""
Generate SQL migration script for TMS Civil Demands
"""
import json

def generate_tms_sql():
    with open("c:/IMBPS/tms_data.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    sql_lines = []
    sql_lines.append("-- =====================================================")
    sql_lines.append("-- NEON POSTGRESQL SCHEMA FOR IR TMS CIVIL ENGINEERING")
    sql_lines.append("-- =====================================================")
    sql_lines.append("CREATE TABLE IF NOT EXISTS tms_civil_demands (")
    sql_lines.append("    demand_ref_id VARCHAR(64) PRIMARY KEY,")
    sql_lines.append("    source_system VARCHAR(32) NOT NULL,")
    sql_lines.append("    division VARCHAR(64) NOT NULL,")
    sql_lines.append("    section VARCHAR(128) NOT NULL,")
    sql_lines.append("    block_section VARCHAR(128) NOT NULL,")
    sql_lines.append("    line_name VARCHAR(128) NOT NULL,")
    sql_lines.append("    work_type VARCHAR(128) NOT NULL,")
    sql_lines.append("    demand_nature VARCHAR(64) NOT NULL,")
    sql_lines.append("    preferred_date DATE NOT NULL,")
    sql_lines.append("    duration_minutes INTEGER NOT NULL,")
    sql_lines.append("    preferred_start TIME NOT NULL,")
    sql_lines.append("    preferred_end TIME NOT NULL,")
    sql_lines.append("    power_block_required BOOLEAN NOT NULL,")
    sql_lines.append("    st_disconnection_required BOOLEAN NOT NULL,")
    sql_lines.append("    post_work_speed_kmph INTEGER,")
    sql_lines.append("    payload JSONB NOT NULL,")
    sql_lines.append("    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    sql_lines.append(");")
    sql_lines.append("")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_tms_div ON tms_civil_demands (division);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_tms_section ON tms_civil_demands (section);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_tms_date ON tms_civil_demands (preferred_date);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_tms_payload ON tms_civil_demands USING gin (payload);")
    sql_lines.append("")
    sql_lines.append("-- =====================================================")
    sql_lines.append("-- TMS DATA INSERT STATEMENTS")
    sql_lines.append("-- =====================================================")

    for item in data:
        ref_id = item["demand_ref_id"].replace("'", "''")
        src = item["source_system"].replace("'", "''")
        div = item["location_details"]["division"].replace("'", "''")
        sec = item["location_details"]["section"].replace("'", "''")
        b_sec = item["location_details"]["block_section"].replace("'", "''")
        line = item["location_details"]["line"].replace("'", "''")
        w_type = item["block_specifications"]["work_type"].replace("'", "''")
        d_nature = item["block_specifications"]["demand_nature"].replace("'", "''")
        p_date = item["block_specifications"]["preferred_date"]
        dur = item["block_specifications"]["requested_window"]["duration_minutes"]
        p_start = item["block_specifications"]["requested_window"]["preferred_start"]
        p_end = item["block_specifications"]["requested_window"]["preferred_end"]
        pb_req = "TRUE" if item["interdepartmental_dependencies"]["power_block_required"] else "FALSE"
        st_req = "TRUE" if item["interdepartmental_dependencies"]["st_disconnection_required"] else "FALSE"
        speed = item["speed_restriction_proposed"]["post_work_speed_kmph"]
        payload_str = json.dumps(item).replace("'", "''")

        stmt = f"""INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    '{ref_id}', '{src}', '{div}', '{sec}', '{b_sec}', '{line}',
    '{w_type}', '{d_nature}', '{p_date}', {dur},
    '{p_start}', '{p_end}', {pb_req}, {st_req},
    {speed}, '{payload_str}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;"""
        sql_lines.append(stmt)

    with open("c:/IMBPS/neon_tms_schema_and_inserts.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))

    print(f"Generated neon_tms_schema_and_inserts.sql with {len(data)} rows.")

if __name__ == "__main__":
    generate_tms_sql()
