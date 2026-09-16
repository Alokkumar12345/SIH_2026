import psycopg2
from psycopg2.extras import RealDictCursor
import json

urls = {
    'TMS': 'postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'SMMS': 'postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'TDMS': 'postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'COA': 'postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require'
}

# Check all distinct zones, divisions, sections across all 4 databases
data_found = {
    "TMS": set(),
    "SMMS": set(),
    "TDMS": set(),
    "COA": set()
}

all_found_zones = set()
all_found_divs = set()
all_found_sections = set()

for dept in ['TMS', 'SMMS', 'TDMS']:
    conn = psycopg2.connect(urls[dept])
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute(f"SELECT DISTINCT zone, zone_code, division, section FROM {dept.lower()}_maintenance_history")
    rows = cur.fetchall()
    for r in rows:
        z = r['zone_code'] or r['zone']
        d = r['division']
        s = r['section']
        data_found[dept].add((z, d, s))
        if z: all_found_zones.add(z)
        if d: all_found_divs.add(d)
        if s: all_found_sections.add(s)
    conn.close()

# COA
conn = psycopg2.connect(urls['COA'])
cur = conn.cursor(cursor_factory=RealDictCursor)
cur.execute("SELECT DISTINCT division_code, sub_division FROM coa_master_timetable")
for r in cur.fetchall():
    d = r['division_code']
    s = r['sub_division']
    data_found['COA'].add((None, d, s))
    if d: all_found_divs.add(d)
    if s: all_found_sections.add(s)
conn.close()

# Check what is in app_users
conn = psycopg2.connect(urls['TMS'])
cur = conn.cursor(cursor_factory=RealDictCursor)
cur.execute("SELECT role, COUNT(*) FROM app_users GROUP BY role")
roles = cur.fetchall()
print("Current app_users by role:")
for r in roles:
    print(f"  {r['role']}: {r['count']}")

cur.execute("SELECT DISTINCT zone_code, division_code, section, department, role FROM app_users")
app_users_entries = cur.fetchall()
conn.close()

print(f"\nTotal distinct zones found across systems: {len(all_found_zones)}")
print(f"Total distinct divisions found across systems: {len(all_found_divs)}")
print(f"Total distinct sections found across systems: {len(all_found_sections)}")

# Check how many of these divisions have a divisional_admin
user_divs = set(u['division_code'] for u in app_users_entries if u['role'] == 'divisional_admin')
print(f"Divisions with divisional_admin: {len(user_divs)}")
missing_div_admins = all_found_divs - user_divs
print(f"Divisions without divisional_admin: {missing_div_admins}")

# Check sections with section_engineers
user_sections = set(u['section'] for u in app_users_entries if u['role'] == 'section_engineer')
print(f"Sections with section_engineer: {len(user_sections)}")
missing_sec_engineers = all_found_sections - user_sections
print(f"Sections without section_engineer in app_users: {len(missing_sec_engineers)}")
if missing_sec_engineers:
    print("Sample missing sections:", list(missing_sec_engineers)[:10])
