"""
Generate SQL migration file for SMMS Signal & Telecom
"""
import json

def generate_smms_sql():
    with open("c:/IMBPS/smms_data.json", "r", encoding="utf-8") as f:
        data = json.load(f)

    sql_lines = []
    sql_lines.append("-- =====================================================")
    sql_lines.append("-- NEON POSTGRESQL SCHEMA FOR IR SMMS SIGNAL & TELECOM")
    sql_lines.append("-- =====================================================")
    sql_lines.append("CREATE TABLE IF NOT EXISTS smms_signal_disconnections (")
    sql_lines.append("    disconnection_ref_id VARCHAR(64) PRIMARY KEY,")
    sql_lines.append("    source_system VARCHAR(32) NOT NULL,")
    sql_lines.append("    form_type VARCHAR(64) NOT NULL,")
    sql_lines.append("    division VARCHAR(64) NOT NULL,")
    sql_lines.append("    station_code VARCHAR(16) NOT NULL,")
    sql_lines.append("    station_name VARCHAR(64) NOT NULL,")
    sql_lines.append("    gear_type VARCHAR(64) NOT NULL,")
    sql_lines.append("    gear_id VARCHAR(64) NOT NULL,")
    sql_lines.append("    maintenance_nature TEXT NOT NULL,")
    sql_lines.append("    requires_traffic_block BOOLEAN NOT NULL,")
    sql_lines.append("    fouling_mark_infringed BOOLEAN NOT NULL,")
    sql_lines.append("    slot_date DATE NOT NULL,")
    sql_lines.append("    start_time TIME NOT NULL,")
    sql_lines.append("    end_time TIME NOT NULL,")
    sql_lines.append("    duration_minutes INTEGER NOT NULL,")
    sql_lines.append("    crank_handle_locked BOOLEAN NOT NULL,")
    sql_lines.append("    payload JSONB NOT NULL,")
    sql_lines.append("    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP")
    sql_lines.append(");")
    sql_lines.append("")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_smms_div ON smms_signal_disconnections (division);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_smms_stn ON smms_signal_disconnections (station_code);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_smms_gear ON smms_signal_disconnections (gear_type);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_smms_date ON smms_signal_disconnections (slot_date);")
    sql_lines.append("CREATE INDEX IF NOT EXISTS idx_smms_payload ON smms_signal_disconnections USING gin (payload);")
    sql_lines.append("")
    sql_lines.append("-- =====================================================")
    sql_lines.append("-- INSERT STATEMENTS")
    sql_lines.append("-- =====================================================")

    for item in data:
        ref_id = item["disconnection_ref_id"].replace("'", "''")
        src = item["source_system"].replace("'", "''")
        f_type = item["form_type"].replace("'", "''")
        div = item["asset_location"]["division"].replace("'", "''")
        stn_code = item["asset_location"]["station_code"].replace("'", "''")
        stn_name = item["asset_location"]["station_name"].replace("'", "''")
        gear_type = item["asset_location"]["affected_gear"]["gear_type"].replace("'", "''")
        gear_id = item["asset_location"]["affected_gear"]["gear_id"].replace("'", "''")
        maint = item["disconnection_specifications"]["maintenance_nature"].replace("'", "''")
        req_tb = "TRUE" if item["disconnection_specifications"]["requires_traffic_block"] else "FALSE"
        foul = "TRUE" if item["disconnection_specifications"]["fouling_mark_infringed"] else "FALSE"
        s_date = item["disconnection_specifications"]["requested_slot"]["date"]
        s_time = item["disconnection_specifications"]["requested_slot"]["start_time"]
        e_time = item["disconnection_specifications"]["requested_slot"]["end_time"]
        dur = item["disconnection_specifications"]["requested_slot"]["duration_minutes"]
        crank = "TRUE" if item["safety_protocols"]["crank_handle_locked"] else "FALSE"
        payload_str = json.dumps(item).replace("'", "''")

        stmt = f"""INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    '{ref_id}', '{src}', '{f_type}', '{div}',
    '{stn_code}', '{stn_name}', '{gear_type}', '{gear_id}',
    '{maint}', {req_tb}, {foul},
    '{s_date}', '{s_time}', '{e_time}', {dur},
    {crank}, '{payload_str}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;"""
        sql_lines.append(stmt)

    with open("c:/IMBPS/neon_smms_schema_and_inserts.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))

    print(f"Generated neon_smms_schema_and_inserts.sql with {len(data)} rows.")

if __name__ == "__main__":
    generate_smms_sql()
