import os
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(os.getenv("DATABASE_URL"))
cursor = conn.cursor(cursor_factory=RealDictCursor)

print("=== INSPECTING coa_master_timetable ===")

cursor.execute("SELECT COUNT(*) FROM coa_master_timetable;")
cnt = cursor.fetchone()["count"]
print(f"Current row count in coa_master_timetable: {cnt}")

cursor.execute("""
    SELECT column_name, data_type, udt_name, is_nullable, column_default
    FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'coa_master_timetable'
    ORDER BY ordinal_position;
""")
cols = cursor.fetchall()
print("\nColumns:")
for c in cols:
    print(f" - {c['column_name']} ({c['data_type']}) | Nullable: {c['is_nullable']} | Default: {c['column_default']}")

cursor.execute("""
    SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    WHERE tc.table_schema = 'public' AND tc.table_name = 'coa_master_timetable'
    ORDER BY tc.constraint_type, tc.constraint_name;
""")
constraints = cursor.fetchall()
print("\nConstraints:")
for c in constraints:
    print(f" - {c['constraint_type']}: {c['constraint_name']} on {c['column_name']}")

cursor.execute("SELECT * FROM coa_master_timetable LIMIT 3;")
samples = cursor.fetchall()
print(f"\nSample rows ({len(samples)}):")
for idx, s in enumerate(samples, 1):
    print(f"\n--- SAMPLE {idx} ---")
    print(json.dumps(s, indent=2, default=str))

cursor.close()
conn.close()
