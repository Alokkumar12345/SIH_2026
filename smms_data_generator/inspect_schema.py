"""
Schema and Table Inspector for SMMS Neon PostgreSQL Database.
Strictly read-only inspection.
"""

import os
import json
from pathlib import Path
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import RealDictCursor

# Load environment variable
env_path = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_path)

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable is not set. Please set it in .env or environment.")


def inspect_database():
    print("=" * 80)
    print("           SMMS DATABASE SCHEMA & STRUCTURE INSPECTION")
    print("=" * 80)

    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # 1. Discover all non-system tables
    cur.execute("""
        SELECT table_schema, table_name, table_type
        FROM information_schema.tables
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY table_schema, table_name;
    """)
    tables = cur.fetchall()
    print(f"\n[1] Discovered {len(tables)} tables/views across non-system schemas:")
    for t in tables:
        cur.execute(f"SELECT COUNT(*) FROM \"{t['table_schema']}\".\"{t['table_name']}\";")
        cnt = cur.fetchone()['count']
        print(f"  - Schema: {t['table_schema']:12s} | Table: {t['table_name']:30s} | Type: {t['table_type']:10s} | Rows: {cnt}")

    # 2. Detailed Inspection of candidate SMMS tables
    for t in tables:
        schema = t['table_schema']
        tname = t['table_name']
        print("\n" + "=" * 80)
        print(f"  DETAILED INSPECTION: {schema}.{tname}")
        print("=" * 80)

        # Columns
        cur.execute("""
            SELECT 
                column_name, data_type, character_maximum_length, 
                is_nullable, column_default
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position;
        """, (schema, tname))
        cols = cur.fetchall()
        print("\n  Columns:")
        for c in cols:
            max_len = f"({c['character_maximum_length']})" if c['character_maximum_length'] else ""
            print(f"    - {c['column_name']:28s} {c['data_type'] + max_len:25s} | Nullable: {c['is_nullable']:3s} | Default: {c['column_default']}")

        # Primary & Unique Constraints
        cur.execute("""
            SELECT tc.constraint_name, tc.constraint_type, kcu.column_name
            FROM information_schema.table_constraints tc
            JOIN information_schema.key_column_usage kcu
              ON tc.constraint_name = kcu.constraint_name
              AND tc.table_schema = kcu.table_schema
            WHERE tc.table_schema = %s AND tc.table_name = %s
            ORDER BY tc.constraint_type, kcu.ordinal_position;
        """, (schema, tname))
        constraints = cur.fetchall()
        print("\n  Constraints:")
        for con in constraints:
            print(f"    - [{con['constraint_type']}] {con['constraint_name']} on ({con['column_name']})")

        # Indexes
        cur.execute("""
            SELECT indexname, indexdef
            FROM pg_indexes
            WHERE schemaname = %s AND tablename = %s;
        """, (schema, tname))
        indexes = cur.fetchall()
        print("\n  Indexes:")
        for idx in indexes:
            print(f"    - {idx['indexname']}: {idx['indexdef']}")

        # Sample Records
        cur.execute(f"SELECT * FROM \"{schema}\".\"{tname}\" LIMIT 3;")
        sample_rows = cur.fetchall()
        print(f"\n  Sample Records ({len(sample_rows)} rows):")
        for i, r in enumerate(sample_rows):
            print(f"\n  --- Row {i + 1} ---")
            d = dict(r)
            for k, v in d.items():
                if isinstance(v, (dict, list)):
                    print(f"    {k}: (JSONB)")
                    print(json.dumps(v, indent=6, default=str))
                else:
                    print(f"    {k}: {v}")

    conn.close()
    print("\n[+] Inspection completed successfully.")


if __name__ == "__main__":
    inspect_database()
