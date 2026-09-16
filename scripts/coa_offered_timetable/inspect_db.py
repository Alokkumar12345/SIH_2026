import os
import sys
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

# Load .env from coa_data_generator or current dir
load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured")

conn = psycopg2.connect(DATABASE_URL)
cursor = conn.cursor(cursor_factory=RealDictCursor)

print("=== CHECKING DATABASE TABLES ===")
cursor.execute("""
    SELECT table_schema, table_name 
    FROM information_schema.tables 
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
    ORDER BY table_schema, table_name;
""")
tables = cursor.fetchall()
print(f"Discovered tables ({len(tables)}):")
for t in tables:
    print(f" - [{t['table_schema']}] {t['table_name']}")

# Check specifically for coa_offered_timetable or coa_offered_slots
cursor.execute("""
    SELECT table_schema, table_name 
    FROM information_schema.tables 
    WHERE table_name LIKE '%coa%offer%' OR table_name LIKE '%slot%' OR table_name LIKE '%timetable%';
""")
matching = cursor.fetchall()
print(f"\nMatching tables: {[m['table_name'] for m in matching]}")

for m in matching:
    t_name = m['table_name']
    schema = m['table_schema']
    print(f"\n==========================================")
    print(f"Inspecting table: {schema}.{t_name}")
    print("==========================================")
    
    cursor.execute(f'SELECT COUNT(*) FROM "{schema}"."{t_name}";')
    cnt = cursor.fetchone()['count']
    print(f"Row count: {cnt}")
    
    cursor.execute("""
        SELECT column_name, data_type, udt_name, is_nullable, column_default
        FROM information_schema.columns
        WHERE table_schema = %s AND table_name = %s
        ORDER BY ordinal_position;
    """, (schema, t_name))
    cols = cursor.fetchall()
    print("Columns:")
    for c in cols:
        print(f" - {c['column_name']} ({c['data_type']}) | Nullable: {c['is_nullable']} | Default: {c['column_default']}")

    cursor.execute("""
        SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        WHERE tc.table_schema = %s AND tc.table_name = %s
        ORDER BY tc.constraint_type, tc.constraint_name;
    """, (schema, t_name))
    constraints = cursor.fetchall()
    print("Constraints:")
    for c in constraints:
        print(f" - {c['constraint_type']}: {c['constraint_name']} on {c['column_name']}")

    try:
        cursor.execute(f'SELECT * FROM "{schema}"."{t_name}" LIMIT 2;')
        samples = cursor.fetchall()
        print(f"Sample rows ({len(samples)}):")
        for idx, s in enumerate(samples, 1):
            print(f"-- Sample {idx} --")
            print(json.dumps(s, indent=2, default=str))
    except Exception as e:
        print(f"Error reading samples: {e}")

cursor.close()
conn.close()
