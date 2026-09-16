import psycopg2
from psycopg2.extras import RealDictCursor
import json
import sys
from pathlib import Path

# Add project root to sys.path
sys.path.insert(0, "c:/IMBPS")
from coa_data_generator.railway_location_master import LOCATION_MASTER

urls = {
    'TMS': 'postgresql://neondb_owner:npg_mjEA8tvwsK3c@ep-jolly-union-aybfki8l-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'SMMS': 'postgresql://neondb_owner:npg_PjDr9ftS1isK@ep-soft-flower-ax8umez8-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'TDMS': 'postgresql://neondb_owner:npg_K5ZlxBYHoq6h@ep-winter-base-aya1ug0a-pooler.c-5.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require',
    'COA': 'postgresql://neondb_owner:npg_S93zlKUAetXr@ep-rough-resonance-ae5xzzjf-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require'
}

all_zones = {} # code -> {name, divisions: {div_code: {name, sections: set()}}}

# 1. From LOCATION_MASTER
for z_code, z_data in LOCATION_MASTER.items():
    z_name = z_data.get("zone_name", z_code)
    if z_code not in all_zones:
        all_zones[z_code] = {"name": z_name, "divisions": {}}
    for d_code, d_data in z_data.get("divisions", {}).items():
        d_name = d_data.get("name", d_code)
        if d_code not in all_zones[z_code]["divisions"]:
            all_zones[z_code]["divisions"][d_code] = {"name": d_name, "sections": set()}
        for sub_id, sub_data in d_data.get("sub_divisions", {}).items():
            for sec in sub_data.get("sections", []):
                sec_name = sec.get("section_name", sec.get("section_id"))
                all_zones[z_code]["divisions"][d_code]["sections"].add((sec.get("section_id"), sec_name))

# 2. From TMS, SMMS, TDMS maintenance history tables
for dept in ['TMS', 'SMMS', 'TDMS']:
    conn = psycopg2.connect(urls[dept])
    cur = conn.cursor(cursor_factory=RealDictCursor)
    tbl = f"{dept.lower()}_maintenance_history"
    cur.execute(f"""
        SELECT DISTINCT zone, zone_code, division, division_name, section, section_display 
        FROM {tbl};
    """)
    rows = cur.fetchall()
    for r in rows:
        z_name = r.get("zone") or "INDIAN RAILWAYS"
        z_code = r.get("zone_code") or z_name[:3].upper()
        if z_code not in all_zones:
            all_zones[z_code] = {"name": z_name, "divisions": {}}
        
        d_code = r.get("division") or "GEN"
        d_name = r.get("division_name") or d_code
        if d_code not in all_zones[z_code]["divisions"]:
            all_zones[z_code]["divisions"][d_code] = {"name": d_name, "sections": set()}
        
        sec_code = r.get("section") or "SEC-01"
        sec_name = r.get("section_display") or sec_code
        all_zones[z_code]["divisions"][d_code]["sections"].add((sec_code, sec_name))
    conn.close()

# 3. From COA database
conn_coa = psycopg2.connect(urls['COA'])
cur_coa = conn_coa.cursor(cursor_factory=RealDictCursor)
cur_coa.execute("""
    SELECT DISTINCT division_code, sub_division 
    FROM coa_master_timetable;
""")
coa_rows = cur_coa.fetchall()
for r in coa_rows:
    d_code = r.get("division_code")
    sub_div = r.get("sub_division")
    # find zone for d_code
    found_zone = None
    for zc, zd in all_zones.items():
        if d_code in zd["divisions"]:
            found_zone = zc
            break
    if not found_zone:
        found_zone = "ECR" if "DDU" in d_code or "DNR" in d_code else "IR"
        if found_zone not in all_zones:
            all_zones[found_zone] = {"name": "Indian Railways", "divisions": {}}
        if d_code not in all_zones[found_zone]["divisions"]:
            all_zones[found_zone]["divisions"][d_code] = {"name": d_code, "sections": set()}
    all_zones[found_zone]["divisions"][d_code]["sections"].add((sub_div, sub_div))
conn_coa.close()

print(f"Total Zones mapped: {len(all_zones)}")
total_divisions = sum(len(z["divisions"]) for z in all_zones.values())
print(f"Total Divisions mapped: {total_divisions}")
total_sections = sum(len(d["sections"]) for z in all_zones.values() for d in z["divisions"].values())
print(f"Total Sections mapped: {total_sections}")

# Serialize and save mapping
serializable = {}
for zc, zd in all_zones.items():
    serializable[zc] = {
        "name": zd["name"],
        "divisions": {
            dc: {
                "name": dd["name"],
                "sections": [{"code": s[0], "name": s[1]} for s in dd["sections"]]
            }
            for dc, dd in zd["divisions"].items()
        }
    }

with open("c:/IMBPS/data/all_railway_entities.json", "w", encoding="utf-8") as f:
    json.dump(serializable, f, indent=2)

print("Saved mapping to c:/IMBPS/data/all_railway_entities.json")
