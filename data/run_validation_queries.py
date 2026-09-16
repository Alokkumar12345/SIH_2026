import os
import psycopg2
from psycopg2.extras import RealDictCursor
import json

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql://neondb_owner:npg_2XePnhb5OvGF@ep-royal-sun-ax1k58cu-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
)

conn = psycopg2.connect(DATABASE_URL)
cur = conn.cursor(cursor_factory=RealDictCursor)

print("=" * 80)
print("             TMS MAINTENANCE HISTORY DATABASE VALIDATION REPORT")
print("=" * 80)

# 1. Total Record Count
cur.execute("SELECT COUNT(*) AS total_count FROM tms_civil_demands;")
total_count = cur.fetchone()['total_count']
print(f"\n1. TOTAL RECORD COUNT: {total_count}")

# 2. Zone Distribution
print("\n2. ZONE DISTRIBUTION:")
cur.execute("""
    SELECT 
        COALESCE(payload->'location_details'->>'zone', 'Legacy Records (Asansol / Howrah / Ambala)') AS zone,
        COUNT(*) AS count,
        ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 1) AS pct
    FROM tms_civil_demands
    GROUP BY 1
    ORDER BY count DESC;
""")
zones = cur.fetchall()
for z in zones:
    print(f"  - {z['zone']:45s}: {z['count']:4d} ({z['pct']}%)")
print(f"  Total zones covered: {len([z for z in zones if 'Legacy' not in z['zone']])} zones + 1 legacy group")

# 3. Division Distribution
print("\n3. DIVISION DISTRIBUTION (ALL DIVISIONS):")
cur.execute("""
    SELECT 
        division,
        COUNT(*) AS count,
        ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 1) AS pct
    FROM tms_civil_demands
    GROUP BY division
    ORDER BY count DESC;
""")
divs = cur.fetchall()
for d in divs:
    print(f"  - {d['division']:35s}: {d['count']:4d} ({d['pct']}%)")
print(f"  Total divisions covered: {len(divs)}")

# 4. Section Count & Distinct Sections
cur.execute("SELECT COUNT(DISTINCT section) AS total_sections FROM tms_civil_demands;")
total_sections = cur.fetchone()['total_sections']
print(f"\n4. SECTION COVERAGE: {total_sections} distinct sections")

# 5. Station / Block Section Count
cur.execute("SELECT COUNT(DISTINCT block_section) AS total_bsections FROM tms_civil_demands;")
total_bsections = cur.fetchone()['total_bsections']
print(f"5. BLOCK SECTIONS / STATIONS COVERAGE: {total_bsections} distinct block sections")

# 6. Maintenance Type Distribution
print("\n6. MAINTENANCE TYPE DISTRIBUTION:")
cur.execute("""
    SELECT 
        COALESCE(payload->'maintenance_details'->>'maintenance_type', work_type) AS maintenance_type,
        COUNT(*) AS count,
        ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 1) AS pct
    FROM tms_civil_demands
    GROUP BY 1
    ORDER BY count DESC;
""")
maints = cur.fetchall()
for m in maints:
    print(f"  - {m['maintenance_type']:45s}: {m['count']:4d} ({m['pct']}%)")

# 7. Defect Type Distribution
print("\n7. DEFECT TYPE DISTRIBUTION (TOP 10):")
cur.execute("""
    SELECT 
        payload->'maintenance_details'->>'defect_type' AS defect_type,
        COUNT(*) AS count
    FROM tms_civil_demands
    WHERE payload->'maintenance_details'->>'defect_type' IS NOT NULL
    GROUP BY 1
    ORDER BY count DESC
    LIMIT 10;
""")
defects = cur.fetchall()
for df in defects:
    print(f"  - {df['defect_type']:48s}: {df['count']:4d}")

# 8. Failure Occurred Distribution (ML Target)
print("\n8. FAILURE DISTRIBUTION (ML TARGET VARIABLE):")
cur.execute("""
    SELECT 
        COALESCE((payload->'ml_features'->>'failure_occurred')::boolean, FALSE) AS failure_occurred,
        COUNT(*) AS count,
        ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 1) AS pct
    FROM tms_civil_demands
    GROUP BY 1;
""")
failures = cur.fetchall()
for f in failures:
    status_str = "True (Failure Preceded / Emergency Defect)" if f['failure_occurred'] else "False (Routine / Preventive)"
    print(f"  - {status_str:48s}: {f['count']:4d} ({f['pct']}%)")

# 9. Maintenance Priority Distribution
print("\n9. MAINTENANCE PRIORITY DISTRIBUTION:")
cur.execute("""
    SELECT 
        payload->'ml_features'->>'maintenance_priority' AS priority,
        COUNT(*) AS count
    FROM tms_civil_demands
    WHERE payload->'ml_features'->>'maintenance_priority' IS NOT NULL
    GROUP BY 1
    ORDER BY count DESC;
""")
for p in cur.fetchall():
    print(f"  - {p['priority']:25s}: {p['count']:4d}")

# 10. Statistical Averages (Risk Score, Costs, Duration)
print("\n10. STATISTICAL AVERAGES & ML METRICS:")
cur.execute("""
    SELECT 
        ROUND(AVG((payload->'ml_features'->>'risk_score')::numeric), 2) AS avg_risk,
        ROUND(AVG((payload->'ml_features'->>'predicted_failure_probability')::numeric), 3) AS avg_fail_prob,
        ROUND(AVG((payload->'maintenance_cost'->>'total_cost_inr')::numeric), 2) AS avg_cost,
        ROUND(MIN((payload->'maintenance_cost'->>'total_cost_inr')::numeric), 2) AS min_cost,
        ROUND(MAX((payload->'maintenance_cost'->>'total_cost_inr')::numeric), 2) AS max_cost,
        ROUND(AVG(duration_minutes), 1) AS avg_duration
    FROM tms_civil_demands
    WHERE payload->'ml_features' IS NOT NULL;
""")
stats = cur.fetchone()
print(f"  - Average Predictive Risk Score: {stats['avg_risk']} / 100")
print(f"  - Average Predicted Failure Probability: {stats['avg_fail_prob']}")
print(f"  - Average Maintenance Cost: INR {stats['avg_cost']:,.2f}")
print(f"  - Cost Range: INR {stats['min_cost']:,.2f} to INR {stats['max_cost']:,.2f}")
print(f"  - Average Block Duration: {stats['avg_duration']} minutes")

# 11. Null Check Validation
print("\n11. DATA INTEGRITY & NULL CHECK:")
cur.execute("""
    SELECT COUNT(*) AS null_count
    FROM tms_civil_demands
    WHERE division IS NULL
       OR section IS NULL
       OR block_section IS NULL
       OR line_name IS NULL
       OR work_type IS NULL
       OR demand_nature IS NULL
       OR preferred_date IS NULL
       OR duration_minutes IS NULL
       OR payload IS NULL;
""")
null_count = cur.fetchone()['null_count']
print(f"  - Null Count across essential schema fields: {null_count} (Data Integrity: {'PERFECT (0 NULLS)' if null_count == 0 else 'WARNING'})")

# 12. Duplicate Check
cur.execute("""
    SELECT COUNT(demand_ref_id) - COUNT(DISTINCT demand_ref_id) AS dup_count
    FROM tms_civil_demands;
""")
dup_count = cur.fetchone()['dup_count']
print(f"  - Duplicate Primary Keys (demand_ref_id): {dup_count} (Unique Check: {'PERFECT (0 DUPLICATES)' if dup_count == 0 else 'WARNING'})")

# 13. Historical Date Range
cur.execute("SELECT MIN(preferred_date) AS min_date, MAX(preferred_date) AS max_date FROM tms_civil_demands;")
dates = cur.fetchone()
print(f"  - Historical Date Range: {dates['min_date']} to {dates['max_date']}")

conn.close()
