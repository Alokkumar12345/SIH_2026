import psycopg2
from psycopg2.extras import RealDictCursor

urls = {
    'TMS': 'postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'SMMS': 'postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'TDMS': 'postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require'
}

# 1. Check schema of app_users
conn = psycopg2.connect(urls['TMS'])
cur = conn.cursor(cursor_factory=RealDictCursor)
cur.execute("""
    SELECT column_name, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_name = 'app_users'
    ORDER BY ordinal_position;
""")
cols = cur.fetchall()
print("=== app_users Columns in TMS DB ===")
for c in cols:
    print(c)

# 2. Check distinct zones, divisions, sections across TMS, SMMS, TDMS
for dept in ['TMS', 'SMMS', 'TDMS']:
    c = psycopg2.connect(urls[dept]).cursor(cursor_factory=RealDictCursor)
    tbl = f"{dept.lower()}_maintenance_history"
    print(f"\n=== Distinct Zones, Divisions, Sections in {dept} ({tbl}) ===")
    
    # Get columns of the table first
    c.execute(f"""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = '{tbl}';
    """)
    tcols = [r['column_name'] for r in c.fetchall()]
    print(f"Columns: {tcols}")
    
    zone_col = 'zone' if 'zone' in tcols else ('railway_zone' if 'railway_zone' in tcols else None)
    div_col = 'division' if 'division' in tcols else None
    sec_col = 'section' if 'section' in tcols else ('section_id' if 'section_id' in tcols else None)
    
    if zone_col and div_col:
        c.execute(f"SELECT DISTINCT {zone_col}, {div_col} FROM {tbl} ORDER BY {zone_col}, {div_col};")
        rows = c.fetchall()
        print(f"Zones & Divisions ({len(rows)}): {rows[:10]}")
    if sec_col:
        c.execute(f"SELECT DISTINCT {div_col}, {sec_col} FROM {tbl} ORDER BY {div_col}, {sec_col};")
        srows = c.fetchall()
        print(f"Divisions & Sections ({len(srows)}): {srows[:10]}")

