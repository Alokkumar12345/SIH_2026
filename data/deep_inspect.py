import psycopg2
from psycopg2.extras import RealDictCursor
import json

conn_str = "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

conn = psycopg2.connect(conn_str)
cur = conn.cursor(cursor_factory=RealDictCursor)

print("=== INSPECTION OF tms_civil_demands ===")
cur.execute("SELECT COUNT(*) FROM tms_civil_demands;")
count = cur.fetchone()['count']
print(f"Total existing records: {count}")

cur.execute("SELECT DISTINCT division FROM tms_civil_demands;")
print("Existing divisions:", [r['division'] for r in cur.fetchall()])

cur.execute("SELECT DISTINCT work_type FROM tms_civil_demands;")
print("Existing work_types:", [r['work_type'] for r in cur.fetchall()])

cur.execute("SELECT DISTINCT demand_nature FROM tms_civil_demands;")
print("Existing demand_natures:", [r['demand_nature'] for r in cur.fetchall()])

cur.execute("SELECT DISTINCT line_name FROM tms_civil_demands;")
print("Existing line_names:", [r['line_name'] for r in cur.fetchall()])

cur.execute("SELECT demand_ref_id FROM tms_civil_demands ORDER BY demand_ref_id LIMIT 10;")
print("Sample demand_ref_ids (first 10):", [r['demand_ref_id'] for r in cur.fetchall()])

cur.execute("SELECT demand_ref_id FROM tms_civil_demands ORDER BY demand_ref_id DESC LIMIT 10;")
print("Sample demand_ref_ids (last 10):", [r['demand_ref_id'] for r in cur.fetchall()])

cur.execute("SELECT * FROM tms_civil_demands LIMIT 2;")
rows = cur.fetchall()
for i, r in enumerate(rows):
    print(f"\n--- Detailed Record {i+1} ---")
    d = dict(r)
    for k, v in d.items():
        if k != 'payload':
            print(f"  {k}: {v} (type: {type(v).__name__})")
        else:
            print(f"  payload keys: {list(v.keys())}")
            print(f"  payload sample: {json.dumps(v, indent=4, default=str)}")

conn.close()
