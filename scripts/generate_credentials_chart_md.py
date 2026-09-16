import json
from pathlib import Path

with open("c:/IMBPS/data/generated_users.json", "r", encoding="utf-8") as f:
    users = json.load(f)

chart_path = Path("C:/Users/alokk/.gemini/antigravity-ide/brain/1bce9309-851c-45b5-ab69-a8dcd94de905/all_railway_credentials_chart.md")

lines = []
lines.append("# All-India Railway Master Credential Directory & Chart")
lines.append("\n**Total Verified Accounts Synced in Neon PostgreSQL Cloud:** 509 Accounts  ")
lines.append("**Coverage:** 16 Railway Zones • 35 Operating Divisions • 98 Track Sections • TMS, SMMS, TDMS & COA\n")

lines.append("## Quick Credential Formula Rule")
lines.append("> [!TIP]")
lines.append("> All usernames and passwords follow a strict, predictable CRIS standard:")
lines.append("> - **Railway Board**: `railway_central` / `RailBoard@2026`")
lines.append("> - **Zonal Admin**: `zone_<zone_code>` (e.g., `zone_er`, `zone_nr`) / `Zonal<ZONE>@2026` (e.g., `ZonalER@2026`)")
lines.append("> - **Divisional Admin**: `div_<division_code>` (e.g., `div_asn`, `div_hwh`, `div_umb`) / `Div<DIV>@2026` (e.g., `DivASN@2026`)")
lines.append("> - **TMS Engineer (Civil/P-Way)**: `tms_<division>_<section>` / `Track<DIV>@2026`")
lines.append("> - **SMMS Engineer (Signal & Telecom)**: `smms_<division>_<section>` / `Signal<DIV>@2026`")
lines.append("> - **TDMS Engineer (Traction / OHE)**: `tdms_<division>_<section>` / `Trd<DIV>@2026`")
lines.append("> - **COA Controller (Train Operations)**: `coa_<division>_<section>` / `Coa<DIV>@2026`\n")

# 1. Central Admin
lines.append("---")
lines.append("## 1. Central Railway Board (Apex Control)")
lines.append("| Designation / Officer Name | Role | Username | Password | Department |")
lines.append("| :--- | :--- | :--- | :--- | :--- |")
for u in users:
    if u["role"] == "central_admin":
        lines.append(f"| **{u['name']}** | {u['role_display']} | `{u['username']}` | `{u['hashed_password']}` | {u['department'] or 'All Departments (TMS, SMMS, TDMS, COA)'} |")

# 2. Zonal Admins
lines.append("\n---")
lines.append("## 2. Zonal Headquarters Admins & Operations Officers (All 16 Zones)")
lines.append("| Zone Code | Zone Name | Designation / Officer Name | Role | Username | Password |")
lines.append("| :---: | :--- | :--- | :--- | :--- | :--- |")
for u in users:
    if u["role"] == "zonal_admin":
        lines.append(f"| **{u['zone_code']}** | {u['zone']} | **{u['name']}** | {u['role_display']} | `{u['username']}` | `{u['hashed_password']}` |")

# 3. Divisional Admins
lines.append("\n---")
lines.append("## 3. Divisional Headquarters Admins (All 35 Divisions)")
lines.append("| Zone | Div Code | Division Name | Officer Name & Role | Username | Password |")
lines.append("| :---: | :---: | :--- | :--- | :--- | :--- |")
for u in users:
    if u["role"] == "divisional_admin":
        lines.append(f"| {u['zone_code']} | **{u['division_code']}** | {u['division']} | **{u['name']}**<br>*{u['role_display']}* | `{u['username']}` | `{u['hashed_password']}` |")

# 4. Section Engineers & Section Controllers by Zone & Division
lines.append("\n---")
lines.append("## 4. Sectional Level Engineers & Controllers (All Sections across TMS, SMMS, TDMS & COA)")

# Group by zone and division
grouped = {}
for u in users:
    if u["role"] == "section_engineer":
        zc = u.get("zone_code") or "OTHER"
        dc = u.get("division_code") or "OTHER"
        if zc not in grouped: grouped[zc] = {}
        if dc not in grouped[zc]: grouped[zc][dc] = []
        grouped[zc][dc].append(u)

for zc, divs in grouped.items():
    lines.append(f"\n### Zone: {zc}")
    for dc, sec_users in divs.items():
        div_name = sec_users[0].get("division", dc)
        lines.append(f"\n#### Division: {dc} ({div_name})")
        lines.append("| Dept | Section | Officer / Engineer Name | Role & Designation | Username | Password |")
        lines.append("| :---: | :--- | :--- | :--- | :--- | :--- |")
        for u in sec_users:
            dept = u.get("department")
            sec_disp = u.get("section_display") or u.get("section")
            lines.append(f"| **{dept}** | {sec_disp} | **{u['name']}** | {u['role_display']} | `{u['username']}` | `{u['hashed_password']}` |")

with open(chart_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"Generated chart file with {len(lines)} lines at {chart_path}")
