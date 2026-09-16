import psycopg2
from psycopg2.extras import RealDictCursor

conn = psycopg2.connect('postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require')
cur = conn.cursor(cursor_factory=RealDictCursor)

print("=== coa_master_timetable columns ===")
cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'coa_master_timetable' ORDER BY ordinal_position;")
for r in cur.fetchall():
    print(f"  {r['column_name']}: {r['data_type']}")

print("\n=== coa_master_timetable sample row ===")
cur.execute("SELECT * FROM coa_master_timetable LIMIT 1;")
print(dict(cur.fetchone()))

print("\n=== coa_master_timetable divisions ===")
cur.execute("SELECT DISTINCT division_code, COUNT(*) FROM coa_master_timetable GROUP BY division_code;")
for r in cur.fetchall():
    print(dict(r))

conn.close()
