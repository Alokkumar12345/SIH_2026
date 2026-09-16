"""
COA Offered Slots Synthetic Data Generator.
Generates realistic Indian Railways Candidate Slot Offers & Regulation Playbooks
for weekly maintenance block planning across ECR, ER, and NR.

Planning Period: 2026-09-15 to 2027-03-15
"""

import os
import sys
import random
from datetime import date, datetime, timedelta, time
from typing import List, Dict, Any
import numpy as np

# Deterministic seed
random.seed(42)
np.random.seed(42)

# Corridors & Sections definition
CORRIDORS = [
    # -------------------------------------------------------------------------
    # 1. East Central Railway (ECR) - DDU Division (~40%)
    # -------------------------------------------------------------------------
    {
        "zone_code": "ECR",
        "division_code": "DDU",
        "sub_division": "DDU-GAYA",
        "control_board": "DDU_GAYA_MAIN_BOARD",
        "section_id": "SEC_DDU_GAYA_SSM_DOS",
        "block_section": "Sasaram (SSM) - Dehri On Sone (DOS)",
        "lines": ["UP_MAIN", "DOWN_MAIN"],
        "stations": ["SSM", "KVD", "DOS"],
        "stabling_stations": ["SSM", "DOS"],
        "weight": 0.15
    },
    {
        "zone_code": "ECR",
        "division_code": "DDU",
        "sub_division": "DDU-GAYA",
        "control_board": "DDU_GAYA_MAIN_BOARD",
        "section_id": "SEC_DDU_GAYA_DOS_GAYA",
        "block_section": "Dehri On Sone (DOS) - Gaya Jn (GAYA)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "UP_CHORD", "DOWN_CHORD"],
        "stations": ["DOS", "SEB", "AUBR", "RFJ", "GRRU", "GAYA"],
        "stabling_stations": ["SEB", "GAYA", "DOS"],
        "weight": 0.15
    },
    {
        "zone_code": "ECR",
        "division_code": "DDU",
        "sub_division": "DDU-BDL",
        "control_board": "DDU_MGS_BOARD",
        "section_id": "SEC_DDU_GAYA_KCM_SDL",
        "block_section": "Kuchman (KCM) - Sakaldiha (SDL)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "UP_LOOP", "DOWN_LOOP"],
        "stations": ["KCM", "SDL", "DDU"],
        "stabling_stations": ["KCM", "DDU"],
        "weight": 0.10
    },

    # -------------------------------------------------------------------------
    # 2. Eastern Railway (ER) - Asansol Division (~20%)
    # -------------------------------------------------------------------------
    {
        "zone_code": "ER",
        "division_code": "ASN",
        "sub_division": "ASN-UDL-SNT",
        "control_board": "ASN_UDL_BOARD",
        "section_id": "SEC_ASN_UDL_SNT",
        "block_section": "Andal Jn (UDL) - Sainthia Jn (SNT)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
        "stations": ["UDL", "UKA", "PAW", "DUJ", "SURI", "SNT"],
        "stabling_stations": ["UDL", "SNT", "PAW"],
        "weight": 0.12
    },
    {
        "zone_code": "ER",
        "division_code": "ASN",
        "sub_division": "ASN-MDP-JSME",
        "control_board": "ASN_MAIN_BOARD",
        "section_id": "SEC_ASN_MDP_GRD",
        "block_section": "Madhupur Jn (MDP) - Giridih (GRD)",
        "lines": ["SINGLE_LINE"],
        "stations": ["MDP", "JGD", "MMD", "GRD"],
        "stabling_stations": ["MDP", "GRD"],
        "weight": 0.08
    },

    # -------------------------------------------------------------------------
    # 3. Eastern Railway (ER) - Howrah Division (~20%)
    # -------------------------------------------------------------------------
    {
        "zone_code": "ER",
        "division_code": "HWH",
        "sub_division": "HWH-MAIN-CHORD",
        "control_board": "HWH_CHORD_MAIN_BOARD",
        "section_id": "SEC_HWH_MAIN_BWN",
        "block_section": "Howrah Jn (HWH) - Barddhaman Jn (BWN)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "UP_CHORD", "DOWN_CHORD"],
        "stations": ["HWH", "BLY", "SHE", "BDC", "MYM", "BWN"],
        "stabling_stations": ["BDC", "BWN", "HWH"],
        "weight": 0.12
    },
    {
        "zone_code": "ER",
        "division_code": "HWH",
        "sub_division": "HWH-MAIN-CHORD",
        "control_board": "HWH_CHORD_MAIN_BOARD",
        "section_id": "SEC_HWH_BDC_AZ",
        "block_section": "Bandel Jn (BDC) - Azimganj Jn (AZ)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
        "stations": ["BDC", "NDAE", "KWAE", "AZ"],
        "stabling_stations": ["BDC", "KWAE", "AZ"],
        "weight": 0.08
    },

    # -------------------------------------------------------------------------
    # 4. Northern Railway (NR) - Ambala Division (~20%)
    # -------------------------------------------------------------------------
    {
        "zone_code": "NR",
        "division_code": "UMB",
        "sub_division": "UMB-LDH-CORRIDOR",
        "control_board": "UMB_MAIN_BOARD",
        "section_id": "SEC_UMB_LDH_MAIN",
        "block_section": "Ambala Cantt (UMB) - Ludhiana Jn (LDH)",
        "lines": ["UP_MAIN", "DOWN_MAIN"],
        "stations": ["UMB", "RPJ", "SIR", "KNN", "LDH"],
        "stabling_stations": ["UMB", "RPJ", "LDH"],
        "weight": 0.12
    },
    {
        "zone_code": "NR",
        "division_code": "UMB",
        "sub_division": "UMB-LDH-CORRIDOR",
        "control_board": "UMB_MAIN_BOARD",
        "section_id": "SEC_UMB_CDG_KLK",
        "block_section": "Ambala Cantt (UMB) - Chandigarh (CDG)",
        "lines": ["UP_MAIN", "DOWN_MAIN", "SINGLE_LINE"],
        "stations": ["UMB", "DKT", "CDG", "KLK"],
        "stabling_stations": ["UMB", "CDG"],
        "weight": 0.08
    }
]

# Slot duration categories and probabilities
SLOT_DURATIONS = [
    (45, 0.15),
    (60, 0.20),
    (90, 0.30),
    (120, 0.20),
    (150, 0.10),
    (180, 0.05)
]

# Slot purposes and probabilities (matching Section 10)
SLOT_PURPOSES = [
    ("TMS_TRACK_MAINTENANCE", 0.25),
    ("SMMS_SIGNAL_MAINTENANCE", 0.15),
    ("SMMS_TELECOM_MAINTENANCE", 0.10),
    ("TDMS_OHE_MAINTENANCE", 0.20),
    ("TDMS_TRACTION_POWER", 0.10),
    ("COMBINED_TMS_SMMS", 0.10),
    ("COMBINED_TMS_TDMS", 0.05),
    ("INTEGRATED_MAINTENANCE", 0.05)
]

# Slot statuses
SLOT_STATUSES = [
    ("OFFERED", 0.50),
    ("CONDITIONALLY_OFFERED", 0.25),
    ("REQUIRES_REGULATION", 0.15),
    ("RESERVED_FOR_MAINTENANCE", 0.10)
]

# Candidate Trains for preceding / following / regulation
COACHING_SERVICES = [
    ("12301", "Howrah Rajdhani Express", "RAJDHANI"),
    ("12802", "Purushottam Express", "SUPERFAST"),
    ("12381", "Poorva Express", "SUPERFAST"),
    ("13009", "Doon Express", "MAIL_EXPRESS"),
    ("13017", "Ganadevata Express", "EXPRESS"),
    ("13051", "Hool Express", "EXPRESS"),
    ("13308", "Ganga Sutlej Express", "MAIL_EXPRESS"),
    ("22301", "Vande Bharat Express", "VANDE_BHARAT"),
    ("12423", "Dibrugarh Rajdhani Express", "RAJDHANI"),
    ("03543", "Andal - Gomoh Passenger Special", "PASSENGER"),
    ("03561", "Andal - Sainthia MEMU", "MEMU"),
    ("12011", "Kalka Shatabdi Express", "SHATABDI"),
    ("14507", "Fazilka Express", "MAIL_EXPRESS"),
    ("12313", "Sealdah Rajdhani Express", "RAJDHANI"),
    ("18618", "Ranchi - Dumka Intercity", "INTERCITY")
]

FREIGHT_COMMODITIES = ["COAL", "CEMENT", "FOODGRAINS", "CONTAINERS", "STEEL", "FERTILIZER"]
FREIGHT_RAKE_TYPES = ["BOXN", "BCN", "BTPN", "BOST", "CONTAINER"]

def minutes_to_hhmm(m: int) -> str:
    m = m % (24 * 60)
    return f"{m // 60:02d}:{m % 60:02d}"

def generate_slot_record(record_idx: int, target_date: date, existing_slot_ids: set) -> Dict[str, Any]:
    # 1. Pick corridor based on weights
    corridor_weights = [c["weight"] for c in CORRIDORS]
    corridor = np.random.choice(CORRIDORS, p=corridor_weights)

    z_code = corridor["zone_code"]
    div_code = corridor["division_code"]
    sub_div = corridor["sub_division"]
    board = corridor["control_board"]
    sec_id = corridor["section_id"]
    block_sec = corridor["block_section"]
    line = random.choice(corridor["lines"])

    # 2. Planning week
    cal = target_date.isocalendar()
    planning_week = f"{cal[0]}-W{cal[1]:02d}"

    # 3. Unique Slot ID
    # Format: COA_SLOT_{DIV}_{SUB_SEC}_{YEAR}_W{WEEK:02d}_{SEQ:04d}
    sec_tag = sec_id.split("_")[-1]
    slot_seq = 1000 + record_idx
    coa_slot_id = f"COA_SLOT_{div_code}_{sec_tag}_{cal[0]}_W{cal[1]:02d}_{slot_seq:04d}"
    while coa_slot_id in existing_slot_ids:
        slot_seq += 1
        coa_slot_id = f"COA_SLOT_{div_code}_{sec_tag}_{cal[0]}_W{cal[1]:02d}_{slot_seq:04d}"
    existing_slot_ids.add(coa_slot_id)

    # 4. Slot Window
    dur_choices, dur_probs = zip(*SLOT_DURATIONS)
    duration_min = int(np.random.choice(dur_choices, p=dur_probs))

    # Pick maintenance start time: typically mid-day (10:00 - 15:30) or night window (00:30 - 04:30)
    if random.random() < 0.70:
        start_m = random.randint(600, 870) # 10:00 to 14:30
    else:
        start_m = random.randint(30, 210)  # 00:30 to 03:30

    start_m = (start_m // 15) * 15
    end_m = start_m + duration_min

    start_time_str = minutes_to_hhmm(start_m)
    end_time_str = minutes_to_hhmm(end_m)

    # 5. Preceding and Following Services
    prec_train = random.choice(COACHING_SERVICES)
    foll_train = random.choice(COACHING_SERVICES)
    while foll_train[0] == prec_train[0]:
        foll_train = random.choice(COACHING_SERVICES)

    prec_clearance_m = start_m - random.randint(5, 18)
    foll_arrival_m = end_m + random.randint(8, 25)

    prec_clearance_str = minutes_to_hhmm(prec_clearance_m)
    foll_arrival_str = minutes_to_hhmm(foll_arrival_m)

    # 6. Slot Purpose & Status
    purposes, purp_probs = zip(*SLOT_PURPOSES)
    slot_purpose = np.random.choice(purposes, p=purp_probs)

    statuses, stat_probs = zip(*SLOT_STATUSES)
    slot_status = np.random.choice(statuses, p=stat_probs)

    conflict_severity = "NONE"
    if slot_status == "CONDITIONALLY_OFFERED":
        conflict_severity = random.choice(["LOW", "MEDIUM"])
    elif slot_status == "REQUIRES_REGULATION":
        conflict_severity = random.choice(["MEDIUM", "HIGH", "CRITICAL"])

    # 7. Contingency Regulation Playbook
    reg_coaching = []
    reg_freight = []

    if slot_status in ["CONDITIONALLY_OFFERED", "REQUIRES_REGULATION", "RESERVED_FOR_MAINTENANCE"]:
        # 1-2 coaching trains regulated
        num_coaching = random.randint(1, 2)
        for _ in range(num_coaching):
            reg_t = random.choice(COACHING_SERVICES)
            reg_st = random.choice(corridor["stations"])
            detention = random.randint(8, 35)
            reg_coaching.append({
                "train_no": reg_t[0],
                "train_name": reg_t[1],
                "type": reg_t[2],
                "regulation_station": reg_st,
                "detention_time_mins": detention,
                "sr_dom_approved": random.random() < 0.85
            })

        # 0-1 freight rakes stabled
        if random.random() < 0.60:
            comm = random.choice(FREIGHT_COMMODITIES)
            rtype = random.choice(FREIGHT_RAKE_TYPES)
            st_station = random.choice(corridor["stabling_stations"])
            loop = random.choice(["LOOP_1_UP", "LOOP_2_COMMON", "GOODS_LOOP", "YARD_LINE_3"])
            hold_mins = random.choice([60, 90, 120, 150, 180])
            reg_freight.append({
                "freight_id": f"{rtype}_{comm}_{div_code}_{random.randint(100, 999)}",
                "commodity": comm,
                "rake_type": rtype,
                "stabling_station": st_station,
                "stabling_loop": loop,
                "planned_hold_minutes": hold_mins
            })

    # 8. Maintenance cross-references
    maint_ref = {
        "TMS_TRACK_MAINTENANCE": f"TMS/{div_code}/{target_date.year}/BLK/{random.randint(100, 999)}",
        "SMMS_SIGNAL_MAINTENANCE": f"SMMS/{div_code}/{target_date.year}/DISC/{random.randint(100, 999)}",
        "SMMS_TELECOM_MAINTENANCE": f"SMMS/{div_code}/{target_date.year}/TEL/{random.randint(100, 999)}",
        "TDMS_OHE_MAINTENANCE": f"TDMS/{z_code}/{div_code}/{target_date.year}/PB/{random.randint(1000, 3500)}",
        "TDMS_TRACTION_POWER": f"TDMS/{z_code}/{div_code}/{target_date.year}/PB/{random.randint(1000, 3500)}",
        "COMBINED_TMS_SMMS": f"TMS/{div_code}/{target_date.year}/BLK/{random.randint(100, 999)}",
        "COMBINED_TMS_TDMS": f"TDMS/{z_code}/{div_code}/{target_date.year}/PB/{random.randint(1000, 3500)}",
        "INTEGRATED_MAINTENANCE": f"IMBPS/{div_code}/{target_date.year}/INTEG/{random.randint(100, 999)}"
    }.get(slot_purpose, f"REF-{div_code}-{random.randint(1000, 9999)}")

    # 9. ML Predictive Scores
    traffic_density_score = round(random.uniform(0.35, 0.95), 2)
    complexity = round(random.uniform(0.20, 0.85), 2)
    pred_delay = int(round(random.uniform(0, 40) * traffic_density_score))
    acceptance_prob = round(max(0.10, min(0.98, 1.0 - (traffic_density_score * 0.45 + (1 if reg_coaching else 0) * 0.25))), 2)

    # 10. Construct Full Payload
    payload = {
        "coa_slot_id": coa_slot_id,
        "feed_type": "COA_WEEKLY_OFFERED_SLOTS",
        "zone_code": z_code,
        "division_code": div_code,
        "sub_division": sub_div,
        "control_board": board,
        "planning_week": planning_week,
        "target_date": target_date.isoformat(),
        "day_of_week": target_date.strftime("%A").upper(),
        "section_id": sec_id,
        "block_section": block_sec,
        "line": line,
        "slot_purpose": slot_purpose,
        "slot_status": slot_status,
        "conflict_severity": conflict_severity,
        "maintenance_reference_id": maint_ref,
        "slot_window": {
            "start_time": start_time_str,
            "end_time": end_time_str,
            "duration_minutes": duration_min
        },
        "preceding_service": {
            "train_no": prec_train[0],
            "train_name": prec_train[1],
            "type": prec_train[2],
            "projected_clearance_time": prec_clearance_str
        },
        "following_service": {
            "train_no": foll_train[0],
            "train_name": foll_train[1],
            "type": foll_train[2],
            "projected_arrival_time": foll_arrival_str
        },
        "contingency_regulation_playbook": {
            "regulated_coaching_trains": reg_coaching,
            "regulated_freight_rakes": reg_freight,
            "maximum_permissible_delay_minutes": 30 if reg_coaching else 0,
            "alternative_routes": ["VIA_CHORD_LINE"] if "CHORD" in line else []
        },
        "predictive_ml_metadata": {
            "traffic_density_score": traffic_density_score,
            "maintenance_complexity_score": complexity,
            "predicted_delay_minutes": pred_delay,
            "slot_acceptance_probability": acceptance_prob,
            "operational_risk_score": round(complexity * 0.6 + traffic_density_score * 0.4, 2),
            "synthetic_record": True
        }
    }

    # 11. Row Record for `coa_offered_slots`
    row_record = {
        "coa_slot_id": coa_slot_id,
        "division_code": div_code,
        "sub_division": sub_div,
        "section_id": sec_id,
        "block_section": block_sec,
        "line": line,
        "target_date": target_date,
        "start_time": start_time_str + ":00",
        "end_time": end_time_str + ":00",
        "duration_minutes": duration_min,
        "payload": payload
    }

    return row_record

def generate_coa_offered_dataset(num_records: int = 2500, existing_slot_ids: set = None) -> List[Dict[str, Any]]:
    if existing_slot_ids is None:
        existing_slot_ids = set()

    start_date = date(2026, 9, 15)
    end_date = date(2027, 3, 15)
    total_days = (end_date - start_date).days

    dataset = []
    print(f"Generating {num_records} synthetic candidate slot offer records from {start_date} to {end_date}...")

    for i in range(num_records):
        day_offset = int(np.random.uniform(0, total_days))
        rec_date = start_date + timedelta(days=day_offset)
        record = generate_slot_record(i + 1, rec_date, existing_slot_ids)
        dataset.append(record)

    print(f"Successfully generated {len(dataset)} candidate slot offer records.")
    return dataset

if __name__ == "__main__":
    import json
    data = generate_coa_offered_dataset(5)
    print("\nSample Generated Record:")
    print(json.dumps(data[0]["payload"], indent=2, default=str))
