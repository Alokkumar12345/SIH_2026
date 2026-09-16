import psycopg2
from psycopg2.extras import RealDictCursor

conn = psycopg2.connect('postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require')
cur = conn.cursor(cursor_factory=RealDictCursor)

print("=== coa_offered_slots columns ===")
cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'coa_offered_slots' ORDER BY ordinal_position;")
for r in cur.fetchall():
    print(f"  {r['column_name']}: {r['data_type']}")

print("\n=== coa_offered_slots sample 3 rows ===")
cur.execute("SELECT * FROM coa_offered_slots LIMIT 3;")
for r in cur.fetchall():
    print(dict(r))

print("\n=== coa_offered_slots distinct divisions ===")
cur.execute("SELECT DISTINCT division_code, COUNT(*) FROM coa_offered_slots GROUP BY division_code;")
for r in cur.fetchall():
    print(dict(r))

conn.close()
