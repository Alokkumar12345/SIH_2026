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

load_dotenv(os.path.join(os.path.dirname(__file__), "../../coa_data_generator/.env"))
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured")

conn = psycopg2.connect(DATABASE_URL)
cursor = conn.cursor(cursor_factory=RealDictCursor)

table_name = "coa_weekly_yard_capacity"
print(f"=== INSPECTING {table_name} ===")

cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
cnt = cursor.fetchone()['count']
print(f"Current row count: {cnt}")

cursor.execute("""
    SELECT column_name, data_type, character_maximum_length, is_nullable, column_default
    FROM information_schema.columns 
    WHERE table_name = %s
    ORDER BY ordinal_position;
""", (table_name,))
cols = cursor.fetchall()
print("\nColumns:")
for c in cols:
    print(f" - {c['column_name']} ({c['data_type']}) [max_len={c['character_maximum_length']}] | Nullable: {c['is_nullable']} | Default: {c['column_default']}")

cursor.execute("""
    SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu 
      ON tc.constraint_name = kcu.constraint_name 
      AND tc.table_schema = kcu.table_schema
    WHERE tc.table_name = %s
    ORDER BY tc.constraint_type, tc.constraint_name;
""", (table_name,))
constraints = cursor.fetchall()
print("\nConstraints:")
for c in constraints:
    print(f" - {c['constraint_type']}: {c['constraint_name']} on {c['column_name']}")

cursor.execute(f"SELECT * FROM {table_name} LIMIT 5;")
samples = cursor.fetchall()
print(f"\nSample rows ({len(samples)}):")
for idx, s in enumerate(samples, 1):
    print(f"-- SAMPLE {idx} --")
    print(json.dumps(s, indent=2, default=str))

cursor.close()
conn.close()
