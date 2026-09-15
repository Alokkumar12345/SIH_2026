"""
SQL Migration Script Generator for COA (Control Office Application) Feeds
"""
import json

def generate_coa_sql():
    with open("c:/IMBPS/coa_data.json", "r", encoding="utf-8") as f:
        coa = json.load(f)

    sql_lines = []
    sql_lines.append("-- =====================================================")
    sql_lines.append("-- NEON POSTGRESQL SCHEMA FOR IR COA (CONTROL OFFICE APPLICATION)")
    sql_lines.append("-- =====================================================")
    sql_lines.append("""
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
""")

    sql_lines.append("-- 1. Master Timetable INSERTS")
    for feed in coa["master_timetable_feeds"]:
        for record in feed["timetable_records"]:
            t_num = record["train_number"].replace("'", "''")
            t_name = record["train_name"].replace("'", "''")
            div = record["division_code"].replace("'", "''")
            sub = record["sub_division"].replace("'", "''")
            trac = record.get("traction", "ELECTRIC_3PH").replace("'", "''")
            length = record.get("train_length_coaches", 18)
            payload_str = json.dumps(record).replace("'", "''")
            sql_lines.append(f"INSERT INTO coa_master_timetable (train_number, train_name, division_code, sub_division, traction, train_length_coaches, payload) VALUES ('{t_num}', '{t_name}', '{div}', '{sub}', '{trac}', {length}, '{payload_str}'::jsonb);")

    sql_lines.append("\n-- 2. Priority Policies INSERTS")
    for feed in coa["priority_policy_feeds"]:
        zone = feed["zone_code"].replace("'", "''")
        div = feed["division_code"].replace("'", "''")
        sub = feed["sub_division"].replace("'", "''")
        corr = feed["corridor_classification"].replace("'", "''")
        yr = feed["policy_year"].replace("'", "''")
        payload_str = json.dumps(feed).replace("'", "''")
        sql_lines.append(f"INSERT INTO coa_priority_policies (zone_code, division_code, sub_division, corridor_classification, policy_year, payload) VALUES ('{zone}', '{div}', '{sub}', '{corr}', '{yr}', '{payload_str}'::jsonb);")

    sql_lines.append("\n-- 3. Yard Capacity INSERTS")
    for feed in coa["yard_capacity_feeds"]:
        wk = feed["target_week"].replace("'", "''")
        for stn in feed["stations"]:
            code = stn["station_code"].replace("'", "''")
            name = stn["station_name"].replace("'", "''")
            div = stn["division_code"].replace("'", "''")
            sub = stn["sub_division"].replace("'", "''")
            payload_str = json.dumps(stn).replace("'", "''")
            sql_lines.append(f"INSERT INTO coa_weekly_yard_capacity (station_code, station_name, division_code, sub_division, target_week, payload) VALUES ('{code}', '{name}', '{div}', '{sub}', '{wk}', '{payload_str}'::jsonb);")

    sql_lines.append("\n-- 4. Offered Candidate Slots INSERTS")
    for feed in coa["offered_slots_feeds"]:
        for slot in feed["candidate_slots"]:
            s_id = slot["coa_slot_id"].replace("'", "''")
            div = slot["division_code"].replace("'", "''")
            sub = slot["sub_division"].replace("'", "''")
            sec_id = slot["section_id"].replace("'", "''")
            b_sec = slot["block_section"].replace("'", "''")
            line = slot["line"].replace("'", "''")
            t_date = slot["target_date"]
            s_time = slot["slot_window"]["start_time"]
            e_time = slot["slot_window"]["end_time"]
            dur = slot["slot_window"]["duration_minutes"]
            payload_str = json.dumps(slot).replace("'", "''")
            sql_lines.append(f"""INSERT INTO coa_offered_slots (
    coa_slot_id, division_code, sub_division, section_id, block_section,
    line, target_date, start_time, end_time, duration_minutes, payload
) VALUES (
    '{s_id}', '{div}', '{sub}', '{sec_id}', '{b_sec}',
    '{line}', '{t_date}', '{s_time}', '{e_time}', {dur}, '{payload_str}'::jsonb
) ON CONFLICT (coa_slot_id) DO UPDATE SET payload = EXCLUDED.payload;""")

    with open("c:/IMBPS/neon_coa_schema_and_inserts.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))

    print("Generated c:/IMBPS/neon_coa_schema_and_inserts.sql successfully.")

if __name__ == "__main__":
    generate_coa_sql()
