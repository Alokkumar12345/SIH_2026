import psycopg2
from psycopg2.extras import RealDictCursor
import json

conn = psycopg2.connect('postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require')
cur = conn.cursor(cursor_factory=RealDictCursor)

print("=== COA TABLES IN NEON ===")
cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;")
tables = [r['table_name'] for r in cur.fetchall()]
print(tables)

for t in ['coa_master_timetable', 'coa_offered_slots', 'coa_priority_policies', 'coa_weekly_yard_capacity']:
    cur.execute(f"SELECT DISTINCT division_code FROM {t} ORDER BY division_code;")
    divs = [r['division_code'] for r in cur.fetchall()]
    print(f"{t}: {len(divs)} divisions -> {divs}")

conn.close()
