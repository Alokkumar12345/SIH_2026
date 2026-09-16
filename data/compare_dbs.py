import psycopg2
from psycopg2.extras import RealDictCursor

url1 = "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
url2 = "postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

for name, url in [("USER_PROVIDED (ep-royal-sun)", url1), ("NEON_TMS_URL (ep-jolly-union)", url2)]:
    print(f"\nChecking {name}...")
    try:
        conn = psycopg2.connect(url, connect_timeout=5)
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
        tables = cur.fetchall()
        print("Tables:", [t['table_name'] for t in tables])
        for t in tables:
            cur.execute(f"SELECT count(*) FROM {t['table_name']}")
            print(f"  {t['table_name']}: {cur.fetchone()['count']} rows")
        conn.close()
    except Exception as e:
        print("Error:", e)
