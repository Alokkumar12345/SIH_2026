import psycopg2
from psycopg2.extras import RealDictCursor

urls = {
    'TMS': 'postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'SMMS': 'postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'TDMS': 'postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'COA': 'postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require'
}

for name, url in urls.items():
    print(f'=== DB: {name} ===')
    try:
        conn = psycopg2.connect(url, connect_timeout=10)
        cur = conn.cursor()
        cur.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            ORDER BY table_name;
        """)
        tables = [r[0] for r in cur.fetchall()]
        print('Tables:', tables)
        for t in tables:
            cur.execute(f"SELECT COUNT(*) FROM {t}")
            cnt = cur.fetchone()[0]
            print(f"  - {t}: {cnt} rows")
        conn.close()
    except Exception as e:
        print(f'Error connecting to {name}: {e}')
