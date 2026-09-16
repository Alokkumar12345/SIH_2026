import os
from dotenv import load_dotenv
import psycopg2

load_dotenv()
conn = psycopg2.connect(os.getenv("DATABASE_URL"))
cur = conn.cursor()
cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
tables = cur.fetchall()
print("Tables in public schema:", tables)
for t in tables:
    cur.execute(f'SELECT COUNT(*) FROM "{t[0]}";')
    print(f"Table {t[0]}: {cur.fetchone()[0]} rows")
conn.close()
