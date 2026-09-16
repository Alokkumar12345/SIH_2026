import json
from pathlib import Path

with open("c:/IMBPS/data/generated_users.json", "r", encoding="utf-8") as f:
    users = json.load(f)

txt_file_path = Path("c:/IMBPS/ALL_RAILWAY_CREDENTIALS.txt")

lines = []
lines.append("=" * 115)
lines.append(" INDIAN RAILWAYS - INTEGRATED MAINTENANCE & BLOCK PLANNING SYSTEM (IMBPS)")
lines.append(" MASTER USER CREDENTIALS DIRECTORY (SYNCED WITH NEON POSTGRESQL CLOUD)")
lines.append(" Total Verified Accounts: 509 | 16 Zones | 35 Divisions | 98 Sections")
lines.append("=" * 115)
lines.append("")
lines.append("UNIVERSAL CREDENTIAL RULE:")
lines.append("  - Railway Board:         railway_central / RailBoard@2026")
lines.append("  - Zonal Admin:           zone_<zone_code> (e.g. zone_er) / Zonal<ZONE>@2026 (e.g. ZonalER@2026)")
lines.append("  - Divisional Admin:      div_<division_code> (e.g. div_asn) / Div<DIV>@2026 (e.g. DivASN@2026)")
lines.append("  - TMS Engineer (P-Way):  tms_<div_section> / Track<DIV>@2026")
lines.append("  - SMMS Engineer (Signal):smms_<div_section> / Signal<DIV>@2026")
lines.append("  - TDMS Engineer (TRD):   tdms_<div_section> / Trd<DIV>@2026")
lines.append("  - COA Controller (Ops):  coa_<div_section> / Coa<DIV>@2026")
lines.append("-" * 115)
lines.append("")

# 1. Central Admin
lines.append("===================================================================================================")
lines.append("1. CENTRAL RAILWAY BOARD (APEX NATIONAL LEVEL)")
lines.append("===================================================================================================")
lines.append(f"{'ROLE / TITLE':<25} | {'OFFICER NAME':<40} | {'USERNAME':<22} | {'PASSWORD'}")
lines.append("-" * 115)
for u in users:
    if u["role"] == "central_admin":
        lines.append(f"{u['role_display'][:25]:<25} | {u['name'][:40]:<40} | {u['username']:<22} | {u['hashed_password']}")
lines.append("")

# 2. Zonal Admins
lines.append("===================================================================================================")
lines.append("2. ZONAL HEADQUARTERS ADMINS (ALL 16 ZONES)")
lines.append("===================================================================================================")
lines.append(f"{'ZONE':<6} | {'OFFICER NAME / DESIGNATION':<48} | {'USERNAME':<20} | {'PASSWORD'}")
lines.append("-" * 115)
for u in users:
    if u["role"] == "zonal_admin":
        lines.append(f"{u['zone_code']:<6} | {u['name'][:48]:<48} | {u['username']:<20} | {u['hashed_password']}")
lines.append("")

# 3. Divisional Admins
lines.append("===================================================================================================")
lines.append("3. DIVISIONAL HEADQUARTERS ADMINS (ALL 35 DIVISIONS)")
lines.append("===================================================================================================")
lines.append(f"{'ZONE':<6} | {'DIV':<8} | {'OFFICER NAME / DESIGNATION':<42} | {'USERNAME':<20} | {'PASSWORD'}")
lines.append("-" * 115)
for u in users:
    if u["role"] == "divisional_admin":
        lines.append(f"{u['zone_code']:<6} | {u['division_code'][:8]:<8} | {u['name'][:42]:<42} | {u['username']:<20} | {u['hashed_password']}")
lines.append("")

# 4. Section Engineers & Controllers
lines.append("===================================================================================================")
lines.append("4. SECTIONAL LEVEL ENGINEERS & OPERATING CONTROLLERS (TMS, SMMS, TDMS, COA)")
lines.append("===================================================================================================")
lines.append(f"{'DEPT':<6} | {'DIV':<6} | {'SECTION':<26} | {'OFFICER NAME':<30} | {'USERNAME':<24} | {'PASSWORD'}")
lines.append("-" * 115)

for u in users:
    if u["role"] == "section_engineer":
        dept = u.get("department") or "SEC"
        div = u.get("division_code") or "DIV"
        sec = (u.get("section") or "")[:26]
        name = u["name"][:30]
        uname = u["username"][:24]
        pwd = u["hashed_password"]
        lines.append(f"{dept:<6} | {div:<6} | {sec:<26} | {name:<30} | {uname:<24} | {pwd}")

lines.append("")
lines.append("=" * 115)
lines.append(" END OF FILE - TOTAL 509 USERS LOADED IN NEON POSTGRESQL CLOUD")
lines.append("=" * 115)

with open(txt_file_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"Wrote text file to {txt_file_path} with {len(lines)} lines")
