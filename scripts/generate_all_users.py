import json
import re
from pathlib import Path

# Load all railway entities extracted
with open("c:/IMBPS/data/all_railway_entities.json", "r", encoding="utf-8") as f:
    zones_data = json.load(f)

# Realistic Officer / Engineer Indian Names pool
first_names = [
    "Rajesh", "Amit", "Vikram", "Sourav", "Debabrata", "Animesh", "Harpreet", 
    "Gurpreet", "Jasbir", "Alok", "Sanjay", "Manoj", "Pradeep", "Sunil", "Ramesh",
    "Suresh", "Pankaj", "Ashok", "Dinesh", "Kishore", "Anand", "Arun", "Deepak",
    "Gaurav", "Manish", "Naveen", "Pawan", "Rahul", "Sachin", "Vivek", "Abhishek",
    "Mukesh", "Rakesh", "Satish", "Vinod", "Ajay", "Devendra", "Hemant", "Kamal",
    "Bhupendra", "Santosh", "Ravindra", "Sudhir", "Girish", "Nilesh", "Praveen"
]
last_names = [
    "Kumar", "Sharma", "Sengupta", "Ghosh", "Roy", "Bose", "Singh", "Verma", 
    "Kaur", "Pandey", "Mishra", "Chatterjee", "Banerjee", "Das", "Gupta", "Yadav",
    "Patel", "Reddy", "Nair", "Iyer", "Rao", "Choudhury", "Mukherjee", "Dutta",
    "Saha", "Bhattacharya", "Tiwari", "Dubey", "Joshi", "Saxena", "Agarwal",
    "Chauhan", "Tripathi", "Shukla", "Pandit", "Deshmukh", "Kulkarni", "Meena"
]

def slugify(text: str) -> str:
    s = re.sub(r'[^a-zA-Z0-9]+', '_', text.strip()).strip('_').lower()
    return s[:30]

def clean_code(text: str) -> str:
    return re.sub(r'[^a-zA-Z0-9]+', '', text.strip()).upper()[:8]

users = []
used_usernames = set()

def add_user(username, password, name, role, role_display, zone, zone_code, division, division_code, department, department_display, section, section_display):
    u = username.lower().strip()
    if u in used_usernames:
        return
    used_usernames.add(u)
    users.append({
        "username": u,
        "hashed_password": password,
        "name": name,
        "role": role,
        "role_display": role_display,
        "zone": zone,
        "zone_code": zone_code,
        "division": division,
        "division_code": division_code,
        "department": department,
        "department_display": department_display,
        "section": section,
        "section_display": section_display,
        "is_active": True,
        "created_by": "SYSTEM"
    })

name_idx = 0
def get_name(title="Er."):
    global name_idx
    fn = first_names[name_idx % len(first_names)]
    ln = last_names[(name_idx * 3 + 1) % len(last_names)]
    name_idx += 1
    return f"{title} {fn} {ln}"

# =========================================================================
# 1. CENTRAL ADMIN (Railway Board Level - All India)
# =========================================================================
add_user(
    username="railway_central",
    password="RailBoard@2026",
    name="Shri Ashwini Vaishnaw / Member Infrastructure",
    role="central_admin",
    role_display="Centralized Railway Board Admin (All-India)",
    zone="All Zones",
    zone_code="ALL",
    division="All Divisions",
    division_code="ALL",
    department=None,
    department_display="All Departments (TMS, SMMS, TDMS, COA)",
    section="All Sections",
    section_display="Pan-India Railway Network"
)
add_user(
    username="railway_board_ops",
    password="RailBoard@2026",
    name="Shri Satish Kumar / Member Operations & BD (COA Apex)",
    role="central_admin",
    role_display="Railway Board Member Operations (COA Train Corridors)",
    zone="All Zones",
    zone_code="ALL",
    division="All Divisions",
    division_code="ALL",
    department="COA",
    department_display="Control Office Application & Operating Directorate",
    section="All Sections",
    section_display="Pan-India Traffic Corridors"
)
add_user(
    username="railway_board_advisor",
    password="RailBoard@2026",
    name="Principal Executive Director (Civil & Safety), Railway Board",
    role="central_admin",
    role_display="Railway Board Infrastructure & Safety Advisor",
    zone="All Zones",
    zone_code="ALL",
    division="All Divisions",
    division_code="ALL",
    department=None,
    department_display="All Departments (TMS, SMMS, TDMS, COA)",
    section="All Sections",
    section_display="Pan-India Operational Corridors"
)

# =========================================================================
# 2. ZONAL ADMINS (All 16 Zones: PCE Infrastructure & PCOM Operations)
# =========================================================================
for z_code, z_info in zones_data.items():
    z_name = z_info.get("name", z_code)
    u_zonal = f"zone_{z_code.lower()}"
    p_zonal = f"Zonal{clean_code(z_code)}@2026"
    div_names = ", ".join(list(z_info.get("divisions", {}).keys())[:4])
    
    # 2a. Zonal Infrastructure Admin (GM / PCE)
    add_user(
        username=u_zonal,
        password=p_zonal,
        name=f"General Manager / PCE, {z_name}",
        role="zonal_admin",
        role_display=f"Zonal Level Admin ({z_name})",
        zone=z_name,
        zone_code=z_code,
        division=f"All Divisions ({div_names})" if div_names else "All Divisions",
        division_code=f"{z_code}_ALL",
        department=None,
        department_display="All Departments (TMS, SMMS, TDMS, COA)",
        section="All Zonal Sections",
        section_display=f"Network-wide {z_name}"
    )

    # 2b. Zonal Operations / COA Admin (PCOM)
    u_zonal_ops = f"zone_{z_code.lower()}_ops"
    p_zonal_ops = f"ZonalOps{clean_code(z_code)}@2026"
    add_user(
        username=u_zonal_ops,
        password=p_zonal_ops,
        name=f"Principal Chief Operations Manager (PCOM), {z_name}",
        role="zonal_admin",
        role_display=f"Zonal Operations & COA Controller ({z_name})",
        zone=z_name,
        zone_code=z_code,
        division=f"All Divisions ({div_names})" if div_names else "All Divisions",
        division_code=f"{z_code}_ALL",
        department="COA",
        department_display="Control Office Application (Zonal Traffic Clearance)",
        section="All Zonal Sections",
        section_display=f"Zonal Freight & Passenger Corridors ({z_name})"
    )

# =========================================================================
# 3. DIVISIONAL ADMINS (All 35 Divisions: DRM / Sr. DOM & COA Chief Controllers)
# =========================================================================
for z_code, z_info in zones_data.items():
    z_name = z_info.get("name", z_code)
    for d_code, d_info in z_info.get("divisions", {}).items():
        d_name = d_info.get("name", d_code)
        c_code = clean_code(d_code)
        u_div = f"div_{slugify(d_code)}"
        p_div = f"Div{c_code}@2026"
        
        sec_sample = ", ".join([s["name"] for s in d_info.get("sections", [])[:3]])
        
        # 3a. Divisional Railway Manager / Sr. DOM
        add_user(
            username=u_div,
            password=p_div,
            name=f"Divisional Railway Manager / Sr. DOM, {d_name}",
            role="divisional_admin",
            role_display=f"Divisional Level Admin ({d_name})",
            zone=z_name,
            zone_code=z_code,
            division=d_name,
            division_code=d_code,
            department=None,
            department_display="Division-wide (TMS, SMMS, TDMS, COA)",
            section=f"All {d_code} Sections",
            section_display=sec_sample if sec_sample else f"All Sections in {d_name}"
        )

        # 3b. Divisional Chief Controller / Sr. DOM (COA Operating)
        u_div_coa = f"coa_div_{slugify(d_code)}"
        p_div_coa = f"Coa{c_code}@2026"
        add_user(
            username=u_div_coa,
            password=p_div_coa,
            name=f"Sr. Divisional Operations Manager & Chief Controller, {d_name}",
            role="divisional_admin",
            role_display=f"Divisional Traffic & COA Chief Controller ({d_name})",
            zone=z_name,
            zone_code=z_code,
            division=d_name,
            division_code=d_code,
            department="COA",
            department_display="Control Office Application (Divisional Control)",
            section=f"All {d_code} Sections",
            section_display=f"Divisional Traffic & Stabling Control ({d_name})"
        )

# =========================================================================
# 4. PRESERVED POPULAR DEMO ACCOUNTS (Asansol, Howrah, Ambala)
# =========================================================================
add_user(
    username="tms_engineer",
    password="TrackEng@2026",
    name="Er. Rajesh Kumar (SSE/P-Way)",
    role="section_engineer",
    role_display="Section Engineer - Track Management System (TMS)",
    zone="Eastern Railway",
    zone_code="ER",
    division="Asansol (ASN)",
    division_code="ASN",
    department="TMS",
    department_display="Track Management System (Civil Track / P-Way)",
    section="UDL-SNT",
    section_display="Andal (UDL) - Sainthia (SNT) Section"
)
add_user(
    username="smms_engineer",
    password="SignalEng@2026",
    name="Er. Amit Sharma (SSE/Signal)",
    role="section_engineer",
    role_display="Section Engineer - Signalling Maintenance Management (SMMS)",
    zone="Eastern Railway",
    zone_code="ER",
    division="Asansol (ASN)",
    division_code="ASN",
    department="SMMS",
    department_display="Signal & Telecom Maintenance (SMMS)",
    section="UDL-SNT",
    section_display="Andal Junction & Associated Interlocking"
)
add_user(
    username="tdms_engineer",
    password="TrdEng@2026",
    name="Er. Vikram Sengupta (SSE/TRD)",
    role="section_engineer",
    role_display="Section Engineer - Traction Distribution (TDMS / OHE)",
    zone="Eastern Railway",
    zone_code="ER",
    division="Asansol (ASN)",
    division_code="ASN",
    department="TDMS",
    department_display="Traction Distribution (Electrical TRD / OHE)",
    section="UDL-SNT",
    section_display="Andal - Sainthia OHE Sub-Division"
)
add_user(
    username="coa_controller",
    password="CoaEng@2026",
    name="Shri Alok Kumar (Dy. Chief Controller / COA)",
    role="section_engineer",
    role_display="Section Controller - Control Office Application (COA)",
    zone="Eastern Railway",
    zone_code="ER",
    division="Asansol (ASN)",
    division_code="ASN",
    department="COA",
    department_display="Control Office Application (Operating & Traffic)",
    section="UDL-SNT",
    section_display="Andal - Sainthia Sectional Train Board"
)

# Howrah Demo Accounts
add_user("tms_hwh", "TrackHWH@2026", "Er. Sourav Ghosh (SSE/P-Way)", "section_engineer", "Section Engineer - Track Management System (TMS)", "Eastern Railway", "ER", "Howrah (HWH)", "HWH", "TMS", "Track Management System (Civil Track / P-Way)", "HWH-BDC", "Howrah (HWH) - Bandel (BDC) Main Line")
add_user("smms_hwh", "SignalHWH@2026", "Er. Debabrata Roy (SSE/Signal)", "section_engineer", "Section Engineer - Signalling Maintenance Management (SMMS)", "Eastern Railway", "ER", "Howrah (HWH)", "HWH", "SMMS", "Signal & Telecom Maintenance (SMMS)", "HWH-BDC", "Howrah - Bandel Electronic Interlocking")
add_user("tdms_hwh", "TrdHWH@2026", "Er. Animesh Bose (SSE/TRD)", "section_engineer", "Section Engineer - Traction Distribution (TDMS / OHE)", "Eastern Railway", "ER", "Howrah (HWH)", "HWH", "TDMS", "Traction Distribution (Electrical TRD / OHE)", "HWH-BDC", "Howrah - Bandel 25kV Traction Sub-Station")
add_user("coa_hwh", "CoaHWH@2026", "Shri Subhasish Mukherjee (Section Controller / COA)", "section_engineer", "Section Controller - Control Office Application (COA)", "Eastern Railway", "ER", "Howrah (HWH)", "HWH", "COA", "Control Office Application (Operating & Traffic)", "HWH-BDC", "Howrah - Bandel Suburban & Main Line Corridor")

# Ambala Demo Accounts
add_user("tms_umb", "TrackUMB@2026", "Er. Harpreet Singh (SSE/P-Way)", "section_engineer", "Section Engineer - Track Management System (TMS)", "Northern Railway", "NR", "Ambala (UMB)", "UMB", "TMS", "Track Management System (Civil Track / P-Way)", "UMB-SRE", "Ambala Cantt (UMB) - Saharanpur (SRE) Section")
add_user("smms_umb", "SignalUMB@2026", "Er. Gurpreet Verma (SSE/Signal)", "section_engineer", "Section Engineer - Signalling Maintenance Management (SMMS)", "Northern Railway", "NR", "Ambala (UMB)", "UMB", "SMMS", "Signal & Telecom Maintenance (SMMS)", "UMB-SRE", "Ambala - Saharanpur Automatic Signalling")
add_user("tdms_umb", "TrdUMB@2026", "Er. Jasbir Kaur (SSE/TRD)", "section_engineer", "Section Engineer - Traction Distribution (TDMS / OHE)", "Northern Railway", "NR", "Ambala (UMB)", "UMB", "TDMS", "Traction Distribution (Electrical TRD / OHE)", "UMB-SRE", "Ambala - Saharanpur 25kV OHE Maintenance Unit")
add_user("coa_umb", "CoaUMB@2026", "Shri Balwinder Singh (Section Controller / COA)", "section_engineer", "Section Controller - Control Office Application (COA)", "Northern Railway", "NR", "Ambala (UMB)", "UMB", "COA", "Control Office Application (Operating & Traffic)", "UMB-SRE", "Ambala - Saharanpur Main Line Operations")

# =========================================================================
# 5. SECTION ENGINEERS & CONTROLLERS FOR ALL 98 SECTIONS (TMS, SMMS, TDMS, COA)
# =========================================================================
for z_code, z_info in zones_data.items():
    z_name = z_info.get("name", z_code)
    for d_code, d_info in z_info.get("divisions", {}).items():
        d_name = d_info.get("name", d_code)
        c_code = clean_code(d_code)
        for sec in d_info.get("sections", []):
            s_code = sec.get("code", "SEC")
            s_name = sec.get("name", s_code)
            s_slug = slugify(f"{d_code}_{s_code}")
            
            # (a) TMS Engineer (SSE/P-Way)
            u_tms = f"tms_{s_slug}"
            p_tms = f"Track{c_code}@2026"
            add_user(
                username=u_tms,
                password=p_tms,
                name=f"{get_name('Er.')} (SSE/P-Way)",
                role="section_engineer",
                role_display="Section Engineer - Track Management System (TMS)",
                zone=z_name,
                zone_code=z_code,
                division=d_name,
                division_code=d_code,
                department="TMS",
                department_display="Track Management System (Civil Track / P-Way)",
                section=s_code,
                section_display=f"{s_name} Section"
            )
            
            # (b) SMMS Engineer (SSE/Signal)
            u_smms = f"smms_{s_slug}"
            p_smms = f"Signal{c_code}@2026"
            add_user(
                username=u_smms,
                password=p_smms,
                name=f"{get_name('Er.')} (SSE/Signal)",
                role="section_engineer",
                role_display="Section Engineer - Signalling Maintenance Management (SMMS)",
                zone=z_name,
                zone_code=z_code,
                division=d_name,
                division_code=d_code,
                department="SMMS",
                department_display="Signal & Telecom Maintenance (SMMS)",
                section=s_code,
                section_display=f"{s_name} Signalling & Interlocking"
            )
            
            # (c) TDMS Engineer (SSE/TRD)
            u_tdms = f"tdms_{s_slug}"
            p_tdms = f"Trd{c_code}@2026"
            add_user(
                username=u_tdms,
                password=p_tdms,
                name=f"{get_name('Er.')} (SSE/TRD)",
                role="section_engineer",
                role_display="Section Engineer - Traction Distribution (TDMS / OHE)",
                zone=z_name,
                zone_code=z_code,
                division=d_name,
                division_code=d_code,
                department="TDMS",
                department_display="Traction Distribution (Electrical TRD / OHE)",
                section=s_code,
                section_display=f"{s_name} 25kV OHE Unit"
            )

            # (d) COA Section Controller (Operating & Train Traffic)
            u_coa = f"coa_{s_slug}"
            p_coa = f"Coa{c_code}@2026"
            add_user(
                username=u_coa,
                password=p_coa,
                name=f"{get_name('Shri')} (Section Controller / COA)",
                role="section_engineer",
                role_display="Section Controller - Control Office Application (COA)",
                zone=z_name,
                zone_code=z_code,
                division=d_name,
                division_code=d_code,
                department="COA",
                department_display="Control Office Application (Operating & Traffic)",
                section=s_code,
                section_display=f"{s_name} Train Operating Section"
            )

print(f"Total Users Generated: {len(users)}")
by_role = {}
by_dept = {}
for u in users:
    r = u["role"]
    d = u["department"] or "ALL_DEPTS"
    by_role[r] = by_role.get(r, 0) + 1
    by_dept[d] = by_dept.get(d, 0) + 1

print("Users by role:", by_role)
print("Users by department:", by_dept)

# Save to JSON
with open("c:/IMBPS/data/generated_users.json", "w", encoding="utf-8") as f:
    json.dump(users, f, indent=2)

print("Successfully saved users to c:/IMBPS/data/generated_users.json")
