"""
COA Weekly Station Yard & Loop Line Stabling Envelope Generator.
Generates realistic weekly capacity snapshots, loop availability,
maintenance block restrictions, and freight/coaching stabling metrics.
"""

import os
import sys
import random
from datetime import date, datetime, timedelta
from typing import List, Dict, Any, Tuple
import numpy as np

# Deterministic seed
random.seed(42)
np.random.seed(42)

# Stations Master with category, yard type, and sub-division mapping
STATIONS_MASTER = [
    # -------------------------------------------------------------------------
    # 1. East Central Railway (ECR) - DDU Division Priority (~40%)
    # -------------------------------------------------------------------------
    {"code": "DDU", "name": "Pt. Deen Dayal Upadhyaya Jn", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "GAYA", "name": "Gaya Jn", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 5},
    {"code": "SSM", "name": "Sasaram Jn", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 4},
    {"code": "DOS", "name": "Dehri On Sone", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "KTQ", "name": "Kudra", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "BDL", "name": "Bhabua Road", "zone": "ECR", "div": "DDU", "sub": "DDU-BDL", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "KCM", "name": "Kuchman", "zone": "ECR", "div": "DDU", "sub": "DDU-BDL", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "SDL", "name": "Sakaldiha", "zone": "ECR", "div": "DDU", "sub": "DDU-BDL", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "CDMR", "name": "Chandauli Majhwar", "zone": "ECR", "div": "DDU", "sub": "DDU-BDL", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "SEB", "name": "Son Nagar Jn", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "JUNCTION", "yard": "FREIGHT_YARD", "loops": 5},
    {"code": "AUBR", "name": "Anugraha Narayan Road", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "RFJ", "name": "Rafiganj", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "GRRU", "name": "Guraru", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "MTGE", "name": "Muthani", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "KVD", "name": "Khurmabad Road", "zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    # Other ECR Stations
    {"code": "DNR", "name": "Danapur", "zone": "ECR", "div": "DNR", "sub": "DNR-MKA", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 5},
    {"code": "PNBE", "name": "Patna Jn", "zone": "ECR", "div": "DNR", "sub": "DNR-MKA", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 6},
    {"code": "MKA", "name": "Mokama Jn", "zone": "ECR", "div": "DNR", "sub": "DNR-MKA", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "BXR", "name": "Buxar", "zone": "ECR", "div": "DNR", "sub": "DNR-ARA-BXR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "DHN", "name": "Dhanbad Jn", "zone": "ECR", "div": "DHN", "sub": "DHN-GMO-KQR", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "GMO", "name": "NSCB Gomoh Jn", "zone": "ECR", "div": "DHN", "sub": "DHN-GMO-KQR", "cat": "JUNCTION", "yard": "FREIGHT_YARD", "loops": 5},
    {"code": "KQR", "name": "Koderma Jn", "zone": "ECR", "div": "DHN", "sub": "DHN-GMO-KQR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},

    # -------------------------------------------------------------------------
    # 2. Eastern Railway (ER) - Asansol Division (~20%)
    # -------------------------------------------------------------------------
    {"code": "ASN", "name": "Asansol Jn", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "UDL", "name": "Andal Jn", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "JUNCTION", "yard": "FREIGHT_YARD", "loops": 6},
    {"code": "UKA", "name": "Ukhra", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "PAW", "name": "Pandabeswar", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "DUJ", "name": "Dubrajpur", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "SURI", "name": "Siuri", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "SNT", "name": "Sainthia Jn", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "TOP", "name": "Tapasi", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "BBI", "name": "Barabani", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 2},
    {"code": "STN", "name": "Sitarampur Jn", "zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "MDP", "name": "Madhupur Jn", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "JSME", "name": "Jasidih Jn", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 5},
    {"code": "DGHR", "name": "Deoghar Jn", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 3},
    {"code": "GRD", "name": "Giridih", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 3},
    {"code": "CRJ", "name": "Chittaranjan", "zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "DGR", "name": "Durgapur", "zone": "ER", "div": "ASN", "sub": "ASN-DGR", "cat": "JUNCTION", "yard": "FREIGHT_YARD", "loops": 5},
    {"code": "RPH", "name": "Rampurhat Jn", "zone": "ER", "div": "ASN", "sub": "ASN-RPH", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 5},

    # -------------------------------------------------------------------------
    # 3. Eastern Railway (ER) - Howrah Division (~20%)
    # -------------------------------------------------------------------------
    {"code": "HWH", "name": "Howrah Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "TERMINAL", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "BWN", "name": "Barddhaman Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "BDC", "name": "Bandel Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 5},
    {"code": "DKAE", "name": "Dankuni Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "FREIGHT_YARD", "loops": 5},
    {"code": "SHE", "name": "Sheoraphuli Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "SUBURBAN_STATION", "loops": 4},
    {"code": "BLY", "name": "Bally", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "MYM", "name": "Memari", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "TAK", "name": "Tarakeswar", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 3},
    {"code": "KWAE", "name": "Katwa Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "AZ", "name": "Azimganj Jn", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "BHP", "name": "Bolpur Shantiniketan", "zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},

    # -------------------------------------------------------------------------
    # 4. Northern Railway (NR) - Ambala Division (~20%)
    # -------------------------------------------------------------------------
    {"code": "UMB", "name": "Ambala Cantt Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "LDH", "name": "Ludhiana Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "RPJ", "name": "Rajpura Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "SIR", "name": "Sirhind Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "KNN", "name": "Khanna", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "CDG", "name": "Chandigarh Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 5},
    {"code": "KLK", "name": "Kalka", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "TERMINAL", "yard": "PASSENGER_TERMINAL_YARD", "loops": 4},
    {"code": "SRE", "name": "Saharanpur Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "JUDW", "name": "Jagadhri Workshop", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "GOODS_STATION", "yard": "FREIGHT_YARD", "loops": 4},
    {"code": "YJUD", "name": "Yamunanagar Jagadhri", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "KKDE", "name": "Kurukshetra Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},
    {"code": "BTI", "name": "Bathinda Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "PTA", "name": "Patiala", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "CROSSING_STATION", "yard": "LOOP_STABLING_YARD", "loops": 3},
    {"code": "DUI", "name": "Dhuri Jn", "zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "cat": "JUNCTION", "yard": "MIXED_TRAFFIC_YARD", "loops": 4},

    # -------------------------------------------------------------------------
    # 5. Major Network Junctions in Other Zones
    # -------------------------------------------------------------------------
    {"code": "CNB", "name": "Kanpur Central", "zone": "NCR", "div": "PRYJ", "sub": "PRYJ-CNB", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "PRYJ", "name": "Prayagraj Jn", "zone": "NCR", "div": "PRYJ", "sub": "PRYJ-CNB", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "BRC", "name": "Vadodara Jn", "zone": "WR", "div": "BRC", "sub": "ST-BRC", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "KGP", "name": "Kharagpur Jn", "zone": "SER", "div": "KGP", "sub": "HWH-KGP-TATA", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 6},
    {"code": "KOTA", "name": "Kota Jn", "zone": "WCR", "div": "KOTA", "sub": "KOTA-SWM", "cat": "JUNCTION", "yard": "MAJOR_JUNCTION_YARD", "loops": 5}
]

# Possible Lock Reasons (Section 10)
LOCK_REASONS = [
    "RESERVED_FOR_CROSSING_MAIL_TRAINS",
    "RESERVED_FOR_PREMIUM_COACHING_SERVICES",
    "TRACK_MAINTENANCE",
    "SIGNAL_MAINTENANCE",
    "OHE_MAINTENANCE",
    "TEMPORARY_FREIGHT_RESTRICTION",
    "SAFETY_INSPECTION",
    "EMERGENCY_OPERATING_RESTRICTION"
]

def get_iso_week_bounds(year: int, week: int) -> Tuple[date, date]:
    # Monday of the ISO week
    first_day = date.fromisocalendar(year, week, 1)
    # Sunday of the ISO week
    last_day = date.fromisocalendar(year, week, 7)
    return first_day, last_day

def generate_loops_for_station(st_info: Dict[str, Any], is_high_density: bool) -> Tuple[List[Dict[str, Any]], Dict[str, int]]:
    num_loops = st_info["loops"]
    loops_data = []

    loop_types_pool = [
        ("LOOP_1_UP", "FREIGHT_LOOP", (680, 780), True),
        ("LOOP_2_COMMON", "COMMON_LOOP", (650, 720), True),
        ("LOOP_3_DOWN", "FREIGHT_LOOP", (680, 780), True),
        ("GOODS_LOOP_UP", "GOODS_LOOP", (710, 850), True),
        ("GOODS_LOOP_DN", "GOODS_LOOP", (710, 850), True),
        ("YARD_LOOP_A", "YARD_LOOP", (750, 1100), True)
    ]

    total_csr = 0
    total_occupied = 0
    total_reserved = 0
    total_maint = 0

    for i in range(num_loops):
        l_name, l_type, (min_csr, max_csr), is_elec = loop_types_pool[i % len(loop_types_pool)]
        csr = random.randint(min_csr, max_csr)
        total_csr += csr

        # Determine lock / reservation
        # ~65% available, ~15% reserved, ~8% freight restricted, ~7% maintenance locked
        p = random.random()
        if p < 0.65:
            # Available
            is_locked = False
            lock_reason = None
            usable_freight = True
            # Partial occupancy
            occ = random.choice([0, 0, int(csr * random.uniform(0.3, 0.8))])
            total_occupied += occ
        elif p < 0.80:
            # Reserved for crossing / passenger
            is_locked = True
            lock_reason = random.choice(["RESERVED_FOR_CROSSING_MAIL_TRAINS", "RESERVED_FOR_PREMIUM_COACHING_SERVICES"])
            usable_freight = False
            occ = 0
            total_reserved += csr
        elif p < 0.90:
            # Maintenance lock (TMS, SMMS, or TDMS)
            is_locked = True
            lock_reason = random.choice(["TRACK_MAINTENANCE", "SIGNAL_MAINTENANCE", "OHE_MAINTENANCE"])
            usable_freight = False
            occ = 0
            total_maint += csr
        else:
            # Operational / Temporary restriction
            is_locked = True
            lock_reason = random.choice(["TEMPORARY_FREIGHT_RESTRICTION", "EMERGENCY_OPERATING_RESTRICTION"])
            usable_freight = False
            occ = 0
            total_reserved += csr

        avail = max(0, csr - occ) if not is_locked else 0

        loops_data.append({
            "loop_number": l_name,
            "loop_type": l_type,
            "clear_standing_room_csr_meters": csr,
            "electrified": is_elec,
            "usable_for_holding_freight": usable_freight,
            "booked_or_maintenance_lock": is_locked,
            "lock_reason": lock_reason,
            "current_occupancy_meters": occ,
            "available_capacity_meters": avail
        })

    avail_stabling = max(0, total_csr - total_occupied - total_reserved - total_maint)

    metrics = {
        "total_csr": total_csr,
        "occupied": total_occupied,
        "reserved": total_reserved,
        "maintenance_blocked": total_maint,
        "available": avail_stabling
    }
    return loops_data, metrics

def generate_weekly_capacity_dataset(existing_keys: set = None) -> List[Dict[str, Any]]:
    if existing_keys is None:
        existing_keys = set()

    # Generate weeks from 2026-W37 through 2027-W11
    # 2026 weeks: W37 to W52
    # 2027 weeks: W01 to W11
    weeks_list = []
    for w in range(37, 53):
        weeks_list.append((2026, w))
    for w in range(1, 12):
        weeks_list.append((2027, w))

    dataset = []
    print(f"Generating weekly yard capacity snapshots across {len(weeks_list)} ISO weeks...")

    for yr, wk in weeks_list:
        target_week = f"{yr}-W{wk:02d}"
        from_date, to_date = get_iso_week_bounds(yr, wk)

        # Snapshot timestamp: typically preceding Friday or Saturday 01:30 - 03:30 AM
        snap_date = from_date - timedelta(days=random.choice([2, 3]))
        snap_hour = random.choice([1, 2, 3])
        snap_min = random.choice([0, 15, 30, 45])
        snap_timestamp = f"{snap_date.isoformat()}T{snap_hour:02d}:{snap_min:02d}:00+05:30"

        for st in STATIONS_MASTER:
            st_code = st["code"]
            unique_key = (st_code, target_week)

            if unique_key in existing_keys:
                continue

            st_name = st["name"]
            div_code = st["div"]
            sub_div = st["sub"]
            zone_code = st["zone"]
            st_cat = st["cat"]
            yard_type = st["yard"]

            is_hdn = div_code in ["DDU", "HWH", "PRYJ"]

            loops_data, metrics = generate_loops_for_station(st, is_hdn)
            total_csr = metrics["total_csr"]
            avail_csr = metrics["available"]
            occ_csr = metrics["occupied"]
            res_csr = metrics["reserved"]
            maint_csr = metrics["maintenance_blocked"]

            utilization = round(((total_csr - avail_csr) / total_csr) * 100, 1) if total_csr > 0 else 0.0

            # ML Scores
            congestion = round(utilization / 100.0 * 0.85 + random.uniform(0.02, 0.10), 2)
            stabling_feasibility = round(max(0.05, min(0.95, (avail_csr / total_csr) * 0.90 + random.uniform(0.02, 0.08))), 2)

            payload = {
                "feed_type": "COA_WEEKLY_YARD_CAPACITY",
                "zone_code": zone_code,
                "division_code": div_code,
                "sub_division": sub_div,
                "station_code": st_code,
                "station_name": st_name,
                "station_category": st_cat,
                "yard_type": yard_type,
                "target_week": target_week,
                "effective_period": {
                    "from": from_date.isoformat(),
                    "to": to_date.isoformat()
                },
                "snapshot_timestamp": snap_timestamp,
                "station_operational_status": "OPERATIONAL" if maint_csr == 0 else "MAINTENANCE_RESTRICTION",
                "total_loop_count": len(loops_data),
                "total_stabling_capacity_meters": total_csr,
                "available_stabling_capacity_meters": avail_csr,
                "occupied_capacity_meters": occ_csr,
                "reserved_capacity_meters": res_csr,
                "maintenance_blocked_capacity_meters": maint_csr,
                "capacity_utilization_percentage": utilization,
                "loops": loops_data,
                "predictive_ml_features": {
                    "capacity_utilization_percentage": utilization,
                    "freight_demand_score": round(random.uniform(0.40, 0.85), 2),
                    "coaching_demand_score": round(random.uniform(0.50, 0.90), 2),
                    "yard_congestion_score": congestion,
                    "stabling_feasibility_score": stabling_feasibility,
                    "loop_availability_score": round(avail_csr / total_csr, 2) if total_csr > 0 else 0.0,
                    "capacity_shortage_risk": round(max(0.05, min(0.95, (1.0 - stabling_feasibility) * 0.85)), 2),
                    "regulation_support_score": round(random.uniform(0.60, 0.95), 2),
                    "synthetic_record": True
                }
            }

            row_record = {
                "station_code": st_code,
                "station_name": st_name,
                "division_code": div_code,
                "sub_division": sub_div,
                "target_week": target_week,
                "payload": payload
            }

            dataset.append(row_record)
            existing_keys.add(unique_key)

    print(f"Successfully generated {len(dataset)} weekly station yard capacity records.")
    return dataset

if __name__ == "__main__":
    import json
    data = generate_weekly_capacity_dataset()
    print(f"Total records generated: {len(data)}")
    print("\nSample Record:")
    print("Station:", data[0]["station_code"], "Week:", data[0]["target_week"], "Div:", data[0]["division_code"])
    print("\nPayload:")
    print(json.dumps(data[0]["payload"], indent=2))
