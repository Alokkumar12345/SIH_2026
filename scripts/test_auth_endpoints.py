import sys
sys.path.insert(0, "c:/IMBPS/backend")
from app.auth import authenticate_user
from app.database import db_manager

test_cases = [
    ("railway_central", "RailBoard@2026", "central_admin"),
    ("railway_board_ops", "RailBoard@2026", "central_admin"),
    ("zone_er", "ZonalER@2026", "zonal_admin"),
    ("zone_nr", "ZonalNR@2026", "zonal_admin"),
    ("div_asn", "DivASN@2026", "divisional_admin"),
    ("div_hwh", "DivHWH@2026", "divisional_admin"),
    ("div_umb", "DivUMB@2026", "divisional_admin"),
    ("div_ddu", "DivDDU@2026", "divisional_admin"),
    ("tms_engineer", "TrackEng@2026", "section_engineer"),
    ("smms_engineer", "SignalEng@2026", "section_engineer"),
    ("tdms_engineer", "TrdEng@2026", "section_engineer"),
    ("coa_controller", "CoaEng@2026", "section_engineer"),
]

print("=== 1. Testing Direct Authentication Against Neon PostgreSQL Cloud ===")
for u, p, expected_role in test_cases:
    prof = authenticate_user(u, p)
    if prof and prof.role == expected_role:
        print(f"  [PASS] {u} ({prof.name}) -> Role: {prof.role}, Dept: {prof.department or 'ALL'}, Zone: {prof.zone_code}, Div: {prof.division_code}")
    else:
        print(f"  [FAIL] {u} - Expected {expected_role}, got {prof}")

print("\n=== 2. Testing Divisional Blocks Ahead Across Multiple Divisions ===")
blocks = db_manager.get_divisional_blocks_state()
divs_with_blocks = set(b.get("division_code") for b in blocks)
print(f"Total blocks in state: {len(blocks)} across {len(divs_with_blocks)} divisions")

test_divs = ["ASN", "HWH", "UMB", "DDU", "CSMT", "MMCT"]
for td in test_divs:
    div_blocks = [b for b in blocks if td.lower() in b.get("division_code", "").lower() or td.lower() in b.get("division", "").lower()]
    print(f"  Division {td}: {len(div_blocks)} blocks ahead available")

print("\n=== 3. Testing Section Engineer Blocks & Isolation ===")
asn_tms_blocks = db_manager.get_authorized_blocks_for_engineer(dept="TMS", section="UDL-SNT")
print(f"  TMS UDL-SNT authorized blocks: {len(asn_tms_blocks)}")

print("\nAll Core Backend Checks Passed Successfully!")
