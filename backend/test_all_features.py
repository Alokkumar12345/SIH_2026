import requests
import json
import sys

BASE_URL = "http://localhost:8000"
FRONTEND_URL = "http://localhost:5173"

def run_tests():
    print("=" * 70)
    print("      IMBPS COMPREHENSIVE E2E VERIFICATION TEST SUITE")
    print("=" * 70)

    # 1. Frontend & Static Assets
    print("\n[TEST 1] Checking Frontend & Static Railway Imagery...")
    r_fe = requests.get(FRONTEND_URL)
    print(f"  -> Frontend HTTP {r_fe.status_code}, HTML length: {len(r_fe.text)}")
    assert r_fe.status_code == 200

    r_img = requests.get(f"{FRONTEND_URL}/images/track_inspection.jpg")
    print(f"  -> Inspection Image HTTP {r_img.status_code}, Size: {len(r_img.content)} bytes")
    assert r_img.status_code == 200

    # 2. Authentication for All Roles
    print("\n[TEST 2] Verifying Authentication for All 3 Admin Levels & 3 Section Engineers...")
    test_users = [
        ("railway_central", "RailBoard@2026", "central_admin"),
        ("zone_er", "ZonalER@2026", "zonal_admin"),
        ("zone_nr", "ZonalNR@2026", "zonal_admin"),
        ("div_asn", "DivASN@2026", "divisional_admin"),
        ("div_hwh", "DivHWH@2026", "divisional_admin"),
        ("div_umb", "DivUMB@2026", "divisional_admin"),
        ("tms_engineer", "TrackEng@2026", "section_engineer"),
        ("smms_engineer", "SignalEng@2026", "section_engineer"),
        ("tdms_engineer", "TrdEng@2026", "section_engineer"),
    ]
    for u, p, role in test_users:
        r = requests.post(f"{BASE_URL}/api/auth/login", json={"username": u, "password": p})
        assert r.status_code == 200, f"Login failed for {u}: {r.text}"
        data = r.json()
        assert data["user"]["role"] == role
        print(f"  [PASS] Logged in: {u} -> {data['user']['role_display']}")

    # 3. Centralized Admin Panel
    print("\n[TEST 3] Verifying Centralized Admin Panel...")
    r_zonal = requests.get(f"{BASE_URL}/api/central/zonal-summary")
    assert r_zonal.status_code == 200
    zdata = r_zonal.json()
    print(f"  -> Pan-India National Totals: {zdata['national_totals']}")
    print(f"  -> Zones Tracked: {[z['zone_name'] for z in zdata['zonal_data']]}")

    r_train = requests.post(f"{BASE_URL}/api/central/train-model", json={"trigger_reason": "BOARD_TEST"})
    assert r_train.status_code == 200
    print(f"  -> ML Retraining Triggered: {r_train.json()['status']}, {r_train.json()['message']}")

    # 4. Zonal Level Admin Panel
    print("\n[TEST 4] Verifying Zonal Level Admin Panel (Eastern Railway ER)...")
    r_div = requests.get(f"{BASE_URL}/api/zonal/divisions-summary?zone_code=ER")
    assert r_div.status_code == 200
    div_data = r_div.json()
    print(f"  -> ER Zonal Totals: {div_data['zonal_totals']}")
    print(f"  -> Divisions in ER: {[d['division_name'] for d in div_data['divisions_data']]}")

    # 5. Divisional Level Admin Panel
    print("\n[TEST 5] Verifying Divisional Level Optimization, Improvisation (Edit), and Authorization...")
    # (a) Generate Monthly Plan
    r_month = requests.post(f"{BASE_URL}/api/divisional/optimize-monthly?division=Asansol (ASN)")
    assert r_month.status_code == 200
    m_data = r_month.json()
    print(f"  -> Monthly Optimization Solver: {m_data['solver_status']}, Scheduled Blocks: {m_data['kpis']['jobs_scheduled']}")

    # (b) Generate Weekly Plan
    r_week = requests.post(f"{BASE_URL}/api/divisional/optimize-weekly?division=Asansol (ASN)")
    assert r_week.status_code == 200
    w_data = r_week.json()
    print(f"  -> Weekly Optimization Solver: {w_data['solver_status']}, Scheduled Blocks: {w_data['kpis']['jobs_scheduled']}")

    # (c) 1-Week Ahead Blocks
    r_ahead = requests.get(f"{BASE_URL}/api/divisional/blocks-ahead?division=Asansol (ASN)")
    assert r_ahead.status_code == 200
    blocks = r_ahead.json()["blocks"]
    print(f"  -> 1-Week Ahead Schedule Blocks: {len(blocks)}")
    test_block = blocks[0]
    test_id = test_block["block_id"]

    # (d) Edit Block
    r_edit = requests.post(f"{BASE_URL}/api/divisional/edit-block", json={
        "block_id": test_id,
        "duration_min": 180,
        "preferred_start": "11:00",
        "preferred_end": "14:00",
        "line": "BOTH_MAIN",
        "notes": "Improvised by Sr. DOM Asansol to optimize freight corridor headway"
    })
    assert r_edit.status_code == 200
    edited_blk = r_edit.json()["block"]
    assert edited_blk["is_edited"] is True
    print(f"  -> Block {test_id} successfully edited. is_edited = {edited_blk['is_edited']}")

    # (e) Authorize Block
    r_auth = requests.post(f"{BASE_URL}/api/divisional/authorize-block", json={"block_id": test_id})
    assert r_auth.status_code == 200
    auth_blk = r_auth.json()["block"]
    assert auth_blk["authorized"] is True
    print(f"  -> Block {test_id} successfully authorized. Dispatched to: {auth_blk['assigned_to']}")

    # 6. User Portal (Sectional Engineers)
    print("\n[TEST 6] Verifying User Portal for TMS Engineer...")
    # Section 1: Current Maintenance Report (Present Week)
    r_curr = requests.get(f"{BASE_URL}/api/engineer/current-blocks?department=TMS&section=UDL-SNT")
    assert r_curr.status_code == 200
    tms_authorized = r_curr.json()["authorized_blocks"]
    print(f"  -> TMS Engineer Received Authorized Blocks: {len(tms_authorized)}")
    assert len(tms_authorized) >= 1, "Expected at least 1 authorized block for TMS Engineer"
    print(f"     First authorized block: {tms_authorized[0]['block_id']} ({tms_authorized[0]['work_type']})")

    # Section 2: Log Maintenance History to Neon PostgreSQL
    print("\n[TEST 7] Logging Completed Maintenance into Neon PostgreSQL Database...")
    r_log = requests.post(f"{BASE_URL}/api/engineer/log-history", json={
        "block_id": test_id,
        "department": "TMS",
        "division": "Asansol (ASN)",
        "section": "UDL-SNT",
        "block_section": "UDL-UKA",
        "line": "UP_MAIN",
        "work_type": "Track Tamping (CSM-952)",
        "actual_duration_min": 180,
        "actual_start": "2026-09-08T11:00:00",
        "actual_end": "2026-09-08T14:00:00",
        "crew_size": 8,
        "equipment": "CSM-952",
        "completion_status": "Completed",
        "train_detention_minutes": 0,
        "work_remarks": "Completed successfully in assigned block window without detention.",
        "logged_by": "Er. Rajesh Kumar (SSE/P-Way)"
    })
    assert r_log.status_code == 200
    log_res = r_log.json()
    print(f"  -> Log Insertion Status: {log_res['status']}")
    print(f"  -> Job ID: {log_res['job_id']}")
    print(f"  -> Neon Cloud Synced: {log_res['neon_synced']}")
    print(f"  -> Message: {log_res['message']}")

    print("\n" + "=" * 70)
    print("      [SUCCESS] ALL 7 TEST SUITES PASSED FLAWLESSLY!")
    print("=" * 70)

if __name__ == "__main__":
    run_tests()
