import psycopg2
from psycopg2.extras import RealDictCursor
import json

conn_str = "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

conn = psycopg2.connect(conn_str)
cur = conn.cursor(cursor_factory=RealDictCursor)

cur.execute("""
    SELECT table_schema, table_name 
    FROM information_schema.tables 
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
""")
tables = cur.fetchall()
print("All tables across non-system schemas:", tables)

# Primary keys / constraints
cur.execute("""
    SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    WHERE tc.table_name = 'tms_civil_demands';
""")
print("Constraints on tms_civil_demands:")
for r in cur.fetchall():
    print(" ", r)

# Also check other files in c:\IMBPS\data to see if there are other neon databases or sql files
# Let's inspect upload_tms_to_neon.py and upload_tms_maintenance_history_to_neon.py!

conn.close()
