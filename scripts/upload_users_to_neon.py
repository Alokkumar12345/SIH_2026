import json
import psycopg2
from psycopg2.extras import execute_batch

urls = {
    'TMS': 'postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'SMMS': 'postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'TDMS': 'postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'COA': 'postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require'
}

with open("c:/IMBPS/data/generated_users.json", "r", encoding="utf-8") as f:
    users = json.load(f)

print(f"Loaded {len(users)} user records to upload.")

create_table_sql = """
CREATE TABLE IF NOT EXISTS app_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(128) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(64) NOT NULL,
    role_display VARCHAR(255) NOT NULL,
    zone VARCHAR(255),
    zone_code VARCHAR(32),
    division VARCHAR(255),
    division_code VARCHAR(32),
    department VARCHAR(64),
    department_display VARCHAR(255),
    section VARCHAR(255),
    section_display VARCHAR(512),
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(64) DEFAULT 'SYSTEM',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_app_users_username ON app_users (username);
CREATE INDEX IF NOT EXISTS idx_app_users_role ON app_users (role);
CREATE INDEX IF NOT EXISTS idx_app_users_division ON app_users (division_code);
CREATE INDEX IF NOT EXISTS idx_app_users_zone ON app_users (zone_code);
CREATE INDEX IF NOT EXISTS idx_app_users_dept ON app_users (department);
CREATE INDEX IF NOT EXISTS idx_app_users_section ON app_users (section);
"""

insert_sql = """
INSERT INTO app_users (
    username, hashed_password, name, role, role_display,
    zone, zone_code, division, division_code,
    department, department_display, section, section_display,
    is_active, created_by
) VALUES (
    %(username)s, %(hashed_password)s, %(name)s, %(role)s, %(role_display)s,
    %(zone)s, %(zone_code)s, %(division)s, %(division_code)s,
    %(department)s, %(department_display)s, %(section)s, %(section_display)s,
    %(is_active)s, %(created_by)s
)
ON CONFLICT (username) DO UPDATE SET
    hashed_password = EXCLUDED.hashed_password,
    name = EXCLUDED.name,
    role = EXCLUDED.role,
    role_display = EXCLUDED.role_display,
    zone = EXCLUDED.zone,
    zone_code = EXCLUDED.zone_code,
    division = EXCLUDED.division,
    division_code = EXCLUDED.division_code,
    department = EXCLUDED.department,
    department_display = EXCLUDED.department_display,
    section = EXCLUDED.section,
    section_display = EXCLUDED.section_display,
    is_active = EXCLUDED.is_active;
"""

for db_name, db_url in urls.items():
    print(f"\n[*] Uploading app_users to Neon PostgreSQL ({db_name})...")
    try:
        conn = psycopg2.connect(db_url, connect_timeout=10)
        conn.autocommit = True
        cur = conn.cursor()
        
        cur.execute(create_table_sql)
        
        execute_batch(cur, insert_sql, users, page_size=100)
        
        cur.execute("SELECT COUNT(*) FROM app_users;")
        total_in_db = cur.fetchone()[0]
        print(f"[{db_name}] Successfully synced {total_in_db} users in app_users table!")
        conn.close()
    except Exception as e:
        print(f"[{db_name}] Error uploading users: {e}")

print("\nFinished syncing users across Neon databases.")
