import os
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

conn = psycopg2.connect(os.getenv("DATABASE_URL"))
cursor = conn.cursor(cursor_factory=RealDictCursor)

cursor.execute("""
    SELECT division_code, sub_division, COUNT(*) as cnt
    FROM coa_master_timetable
    GROUP BY division_code, sub_division
    ORDER BY cnt DESC;
""")
print("Existing division & sub_division breakdown:")
for r in cursor.fetchall():
    print(f" - {r['division_code']} / {r['sub_division']}: {r['cnt']} trains")

cursor.execute("SELECT train_number FROM coa_master_timetable;")
train_nums = [r["train_number"] for r in cursor.fetchall()]
print(f"Total existing train numbers: {len(train_nums)}")
print(f"Sample train numbers: {train_nums[:10]}")

# Also inspect what other maintenance tables exist in this DB
cursor.execute("""
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    ORDER BY table_name;
""")
print("\nAll public tables in this database:")
for r in cursor.fetchall():
    print(f" * {r['table_name']}")

cursor.close()
conn.close()
