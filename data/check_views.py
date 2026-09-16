import psycopg2
from psycopg2.extras import RealDictCursor

conn_str = "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

conn = psycopg2.connect(conn_str)
cur = conn.cursor(cursor_factory=RealDictCursor)

cur.execute("SELECT * FROM pg_views WHERE schemaname = 'public';")
print("Views in public:", cur.fetchall())

cur.execute("SELECT * FROM pg_matviews WHERE schemaname = 'public';")
print("Materialized views in public:", cur.fetchall())

cur.execute("""
    SELECT table_schema, table_name, table_type
    FROM information_schema.tables 
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
""")
print("All tables/views in DB:", cur.fetchall())

conn.close()
