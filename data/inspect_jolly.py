import psycopg2
from psycopg2.extras import RealDictCursor
import json

url2 = "postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
conn = psycopg2.connect(url2)
cur = conn.cursor(cursor_factory=RealDictCursor)

cur.execute("""
    SELECT column_name, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_name = 'tms_maintenance_history'
    ORDER BY ordinal_position;
""")
print("Columns in tms_maintenance_history on ep-jolly-union:")
for c in cur.fetchall():
    print(f"  {c['column_name']} ({c['data_type']})")

cur.execute("SELECT * FROM tms_maintenance_history LIMIT 1;")
print("\nSample row:")
print(json.dumps(dict(cur.fetchone()), indent=2, default=str))

conn.close()
