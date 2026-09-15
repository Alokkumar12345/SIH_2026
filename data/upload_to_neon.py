import os
import sys
import json

def upload_to_neon(db_url=None):
    if not db_url:
        db_url = os.environ.get("DATABASE_URL")
    
    if not db_url:
        if len(sys.argv) > 1:
            db_url = sys.argv[1]
            
    if not db_url:
        print("[-] Error: DATABASE_URL not provided.")
        print("Usage: python upload_to_neon.py \"postgresql://user:pass@ep-xyz.neon.tech/neondb?sslmode=require\"")
        print("Or set DATABASE_URL environment variable.")
        sys.exit(1)

    try:
        import psycopg2
    except ImportError:
        print("[*] Installing psycopg2-binary...")
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "psycopg2-binary"])
        import psycopg2

    print("[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(db_url)
    conn.autocommit = True
    cur = conn.cursor()

    sql_file = os.path.join(os.path.dirname(__file__), "neon_schema_and_inserts.sql")
    print(f"[*] Reading SQL statements from {sql_file}...")
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_content = f.read()

    print("[*] Executing schema and data migration...")
    # Execute the script
    cur.execute(sql_content)

    cur.execute("SELECT COUNT(*) FROM tdms_requisitions;")
    count = cur.fetchone()[0]
    print(f"[+] SUCCESS: Successfully uploaded and verified {count} records in 'tdms_requisitions' table on Neon Cloud!")

    cur.close()
    conn.close()

if __name__ == "__main__":
    upload_to_neon()
