"""
Update dates of TMS schema (tms_civil_demands) on Neon PostgreSQL to upcoming dates
within the next 6 months for predictive ML modeling and block planning.
"""

import os
import sys
import json
import random
from datetime import date, timedelta
import psycopg2
from psycopg2.extras import execute_batch, RealDictCursor

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
)

# Anchor starting date: Tomorrow (2026-09-17)
START_DATE = date(2026, 9, 17)
MAX_DAYS_AHEAD = 180  # Exactly 6 months (until ~2027-03-15)

random.seed(101)  # Predictable, well-distributed dates

def main():
    print("=" * 75)
    print("     UPDATING TMS DATES TO UPCOMING HORIZON (NOT EXCEEDING 6 MONTHS)")
    print(f"     Anchor Start: {START_DATE} | Maximum Span: 180 Days (<= 6 Months)")
    print("=" * 75)

    print("\n[*] Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute("SELECT demand_ref_id, preferred_date, payload FROM tms_civil_demands ORDER BY demand_ref_id;")
    rows = cur.fetchall()
    total_records = len(rows)
    print(f"[*] Retrieved {total_records} records to update.")

    update_tuples = []

    # Distribution profile:
    # 25% in Month 1 (Sep 17 - Oct 16) - active corridor execution & 1-week ahead review
    # 20% in Month 2 (Oct 17 - Nov 16) - monthly block planning
    # 18% in Month 3 (Nov 17 - Dec 16) - winter preventive window
    # 15% in Month 4 (Dec 17 - Jan 16)
    # 12% in Month 5 (Jan 17 - Feb 15)
    # 10% in Month 6 (Feb 16 - Mar 15)
    day_ranges = [
        (1, 30, 0.25),
        (31, 60, 0.20),
        (61, 90, 0.18),
        (91, 120, 0.15),
        (121, 150, 0.12),
        (151, 180, 0.10)
    ]

    for r in rows:
        demand_id = r['demand_ref_id']
        payload = r['payload']

        # Pick bucket
        bucket = random.choices(day_ranges, weights=[w for _, _, w in day_ranges], k=1)[0]
        days_ahead = random.randint(bucket[0], bucket[1])
        new_date = START_DATE + timedelta(days=days_ahead)
        new_date_str = new_date.isoformat()

        # Update payload JSONB
        if 'block_specifications' in payload:
            payload['block_specifications']['preferred_date'] = new_date_str
            if 'requested_window' in payload['block_specifications']:
                # preserve existing preferred times
                pass

        if 'maintenance_details' in payload:
            if 'maintenance_date' in payload['maintenance_details']:
                payload['maintenance_details']['maintenance_date'] = new_date_str

        update_tuples.append((
            new_date,
            json.dumps(payload),
            demand_id
        ))

    print(f"[*] Prepared {len(update_tuples)} update parameter sets.")

    update_sql = """
    UPDATE tms_civil_demands
    SET 
        preferred_date = %s,
        payload = %s::jsonb
    WHERE demand_ref_id = %s;
    """

    BATCH_SIZE = 500
    print(f"[*] Executing batch updates in chunks of {BATCH_SIZE}...")
    try:
        for i in range(0, len(update_tuples), BATCH_SIZE):
            batch = update_tuples[i:i + BATCH_SIZE]
            execute_batch(cur, update_sql, batch)
            conn.commit()
            print(f"  [+] Updated batch {i // BATCH_SIZE + 1}: {min(i + BATCH_SIZE, len(update_tuples))}/{len(update_tuples)}")
        print("[+] All batch updates committed successfully!")
    except Exception as e:
        conn.rollback()
        print(f"[-] Error during update: {e}")
        conn.close()
        sys.exit(1)

    # Verification
    print("\n" + "=" * 75)
    print("                    POST-UPDATE VERIFICATION")
    print("=" * 75)

    cur.execute("SELECT MIN(preferred_date) AS min_date, MAX(preferred_date) AS max_date, COUNT(*) AS count FROM tms_civil_demands;")
    stats = cur.fetchone()
    min_d = stats['min_date']
    max_d = stats['max_date']
    cnt = stats['count']

    days_diff = (max_d - min_d).days
    print(f"[*] Total Records Verified: {cnt}")
    print(f"[*] Earliest Upcoming Date: {min_d}")
    print(f"[*] Latest Upcoming Date:   {max_d}")
    print(f"[*] Total Horizon Span:     {days_diff} days (Max Allowed: 180 days)")
    assert days_diff <= 180, f"Span {days_diff} exceeds 180 days!"

    # Monthly Distribution
    print("\n--- MONTHLY DISTRIBUTION ACROSS UPCOMING 6 MONTHS ---")
    cur.execute("""
        SELECT 
            TO_CHAR(preferred_date, 'YYYY-MM (Month)') AS month_bucket,
            COUNT(*) AS count,
            ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 1) AS pct
        FROM tms_civil_demands
        GROUP BY 1
        ORDER BY 1;
    """)
    for m in cur.fetchall():
        print(f"  {m['month_bucket']:24s} : {m['count']:4d} records ({m['pct']}%)")

    # Sync verification between column and payload
    cur.execute("""
        SELECT COUNT(*) AS mismatch_count
        FROM tms_civil_demands
        WHERE preferred_date::text != (payload->'block_specifications'->>'preferred_date');
    """)
    mismatches = cur.fetchone()['mismatch_count']
    print(f"\n[*] Synchronization Mismatch Check (Column vs JSONB Payload): {mismatches} (Integrity: {'PERFECT (100% IN SYNC)' if mismatches == 0 else 'WARNING'})")

    conn.close()
    print("\n[SUCCESS] Date update completed cleanly across all TMS schema records!")

if __name__ == "__main__":
    main()
