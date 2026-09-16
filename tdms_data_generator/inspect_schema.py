import os
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL is not configured in .env")

def inspect_database_schema():
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    
    print("=== CONNECTED TO NEON POSTGRESQL ===")
    
    cursor.execute("""
        SELECT table_schema, table_name, table_type 
        FROM information_schema.tables 
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY table_schema, table_name;
    """)
    tables = cursor.fetchall()
    print(f"Total tables found: {len(tables)}")
    for t in tables:
        schema = t['table_schema']
        t_name = t['table_name']
        try:
            cursor.execute(f'SELECT COUNT(*) FROM "{schema}"."{t_name}";')
            cnt = cursor.fetchone()['count']
            print(f"  * {schema}.{t_name}: {cnt} rows")
        except Exception as e:
            print(f"  * {schema}.{t_name}: Error ({e})")
            conn.rollback()
    
    # 1. List all tables across schemas
    cursor.execute("""
        SELECT table_schema, table_name, table_type 
        FROM information_schema.tables 
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY table_schema, table_name;
    """)
    tables = cursor.fetchall()
    print(f"\nDiscovered Tables ({len(tables)}):")
    for t in tables:
        schema = t['table_schema']
        t_name = t['table_name']
        try:
            cursor.execute(f'SELECT COUNT(*) FROM "{schema}"."{t_name}";')
            cnt = cursor.fetchone()['count']
            print(f" - [{schema}] {t_name} ({t['table_type']}): {cnt} rows")
        except Exception as e:
            print(f" - [{schema}] {t_name}: Error ({e})")
            conn.rollback()

    # Specifically identify TDMS tables
    tdms_tables = [t for t in tables if 'tdms' in t['table_name'].lower() or 'trd' in t['table_name'].lower() or 'electric' in t['table_name'].lower()]
    candidate_names = [f"{t['table_schema']}.{t['table_name']}" for t in tdms_tables]
    print(f"\nIdentified TDMS / TRD candidate tables: {candidate_names}")

    for t in tdms_tables:
        schema = t['table_schema']
        t_name = t['table_name']
        print(f"\n=======================================================")
        print(f"Detailed Inspection for table: {schema}.{t_name}")
        print(f"=======================================================")
        
        # Columns
        cursor.execute("""
            SELECT column_name, data_type, udt_name, is_nullable, column_default, character_maximum_length
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, t_name))
        columns = cursor.fetchall()
        print("\nColumns:")
        for col in columns:
            print(f"  * {col['column_name']} | Type: {col['data_type']} ({col['udt_name']}) | Nullable: {col['is_nullable']} | Default: {col['column_default']}")
            
        # Primary Keys & Unique Constraints
        cursor.execute("""
            SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
              ON tc.constraint_name = kcu.constraint_name
              AND tc.table_schema = kcu.table_schema
            WHERE tc.table_schema = %s AND tc.table_name = %s
            ORDER BY tc.constraint_type, tc.constraint_name, kcu.ordinal_position;
        """, (schema, t_name))
        constraints = cursor.fetchall()
        print("\nConstraints:")
        for c in constraints:
            print(f"  * {c['constraint_type']}: {c['constraint_name']} on {c['column_name']}")
            
        # Sample rows
        try:
            cursor.execute(f'SELECT * FROM "{schema}"."{t_name}" LIMIT 3;')
            samples = cursor.fetchall()
            print(f"\nSample Rows ({len(samples)}):")
            for idx, r in enumerate(samples, 1):
                print(f"--- Sample {idx} ---")
                print(json.dumps(r, indent=2, default=str))
        except Exception as e:
            print(f"Error reading sample rows: {e}")
            conn.rollback()

    cursor.close()
    conn.close()

if __name__ == "__main__":
    inspect_database_schema()
