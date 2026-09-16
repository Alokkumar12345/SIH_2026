"""
COA Priority Policies Synthetic Data Generator.
Generates realistic Indian Railways Service Priority & Operational Constraint Rules
across all major railway zones, divisions, sub-divisions, and seasonal policy versions.
"""

import os
import sys
import random
from datetime import date
from typing import List, Dict, Any

# Deterministic seed
random.seed(42)

# Sub-division and Corridor configurations
SUBDIVISION_CONFIGS = [
    # -------------------------------------------------------------
    # 1. EAST CENTRAL RAILWAY (ECR) - DDU Priority (~40%)
    # -------------------------------------------------------------
    {"zone": "ECR", "div": "DDU", "sub": "DDU-GAYA", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DDU_GAYA_MAIN_BOARD"},
    {"zone": "ECR", "div": "DDU", "sub": "DDU-BDL", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DDU_MGS_BOARD"},
    {"zone": "ECR", "div": "DDU", "sub": "DDU-SASARAM", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DDU_GAYA_MAIN_BOARD"},
    {"zone": "ECR", "div": "DDU", "sub": "DDU-PRYJ", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DDU_WEST_BOARD"},
    {"zone": "ECR", "div": "DDU", "sub": "DDU-PNBE", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DDU_EAST_BOARD"},
    {"zone": "ECR", "div": "DNR", "sub": "DNR-MKA", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DNR_MAIN_BOARD"},
    {"zone": "ECR", "div": "DNR", "sub": "DNR-ARA-BXR", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DNR_WEST_BOARD"},
    {"zone": "ECR", "div": "DHN", "sub": "DHN-GMO-KQR", "class": "FEEDER_CORRIDOR_MINING", "board": "DHN_GRAND_CHORD_BOARD"},
    {"zone": "ECR", "div": "DHN", "sub": "DHN-BKSC", "class": "FEEDER_CORRIDOR_MINING", "board": "DHN_COAL_BOARD"},
    {"zone": "ECR", "div": "SPJ", "sub": "SPJ-MFP-HJP", "class": "MEDIUM_DENSITY_NETWORK", "board": "SPJ_MAIN_BOARD"},
    {"zone": "ECR", "div": "SEE", "sub": "SEE-CPR-SV", "class": "MEDIUM_DENSITY_NETWORK", "board": "SEE_MAIN_BOARD"},

    # -------------------------------------------------------------
    # 2. EASTERN RAILWAY (ER) - Asansol & Howrah (~30%)
    # -------------------------------------------------------------
    {"zone": "ER", "div": "ASN", "sub": "ASN-UDL-SNT", "class": "FEEDER_CORRIDOR_MINING", "board": "ASN_UDL_BOARD"},
    {"zone": "ER", "div": "ASN", "sub": "ASN-MDP-JSME", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "ASN_MAIN_BOARD"},
    {"zone": "ER", "div": "ASN", "sub": "ASN-DGR", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "ASN_EAST_BOARD"},
    {"zone": "ER", "div": "ASN", "sub": "ASN-RPH", "class": "FEEDER_CORRIDOR_MINING", "board": "ASN_LOOP_BOARD"},
    {"zone": "ER", "div": "ASN", "sub": "ASN-JAJ", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "ASN_WEST_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-MAIN-CHORD", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "HWH_CHORD_MAIN_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-BWN", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "HWH_MAIN_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-BDC", "class": "SUBURBAN_AND_MAINLINE", "board": "HWH_SUBURBAN_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-KGP", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "HWH_SOUTH_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-SHE-TAK", "class": "SUBURBAN_AND_MAINLINE", "board": "HWH_BRANCH_BOARD"},
    {"zone": "ER", "div": "HWH", "sub": "HWH-BDC-AZ", "class": "MEDIUM_DENSITY_NETWORK", "board": "HWH_LOOP_BOARD"},
    {"zone": "ER", "div": "SDAH", "sub": "SDAH-NH-RHA", "class": "SUBURBAN_AND_MAINLINE", "board": "SDAH_MAIN_BOARD"},
    {"zone": "ER", "div": "MLDT", "sub": "MLDT-NFK-SBG", "class": "MEDIUM_DENSITY_NETWORK", "board": "MLDT_MAIN_BOARD"},

    # -------------------------------------------------------------
    # 3. NORTHERN RAILWAY (NR) - Ambala Priority (~20%)
    # -------------------------------------------------------------
    {"zone": "NR", "div": "UMB", "sub": "UMB-LDH-CORRIDOR", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "UMB_MAIN_BOARD"},
    {"zone": "NR", "div": "UMB", "sub": "UMB-SRE", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "UMB_EAST_BOARD"},
    {"zone": "NR", "div": "UMB", "sub": "UMB-KKDE", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "UMB_SOUTH_BOARD"},
    {"zone": "NR", "div": "UMB", "sub": "UMB-CDG", "class": "MEDIUM_DENSITY_NETWORK", "board": "UMB_NORTH_BOARD"},
    {"zone": "NR", "div": "UMB", "sub": "UMB-RPJ-BTI", "class": "FEEDER_CORRIDOR_AGRICULTURE", "board": "UMB_WEST_BOARD"},
    {"zone": "NR", "div": "DLI", "sub": "DLI-NDLS-GZB", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "DLI_CENTRAL_BOARD"},
    {"zone": "NR", "div": "DLI", "sub": "DLI-PNP", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "DLI_NORTH_BOARD"},
    {"zone": "NR", "div": "LKO", "sub": "LKO-RBL-BSB", "class": "MEDIUM_DENSITY_NETWORK", "board": "LKO_MAIN_BOARD"},
    {"zone": "NR", "div": "MB", "sub": "MB-RMU-BE", "class": "MEDIUM_DENSITY_NETWORK", "board": "MB_MAIN_BOARD"},
    {"zone": "NR", "div": "FZR", "sub": "FZR-JUC-ASR", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "FZR_MAIN_BOARD"},

    # -------------------------------------------------------------
    # 4. OTHER MAJOR ZONES (~10%)
    # -------------------------------------------------------------
    {"zone": "CR", "div": "CSMT", "sub": "CSMT-KYN-KSRA", "class": "SUBURBAN_AND_MAINLINE", "board": "CSMT_MAIN_BOARD"},
    {"zone": "CR", "div": "BSL", "sub": "BSL-IGP-MMR", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "BSL_MAIN_BOARD"},
    {"zone": "CR", "div": "PUNE", "sub": "PUNE-LNL", "class": "SUBURBAN_AND_MAINLINE", "board": "PUNE_MAIN_BOARD"},
    {"zone": "WR", "div": "MMCT", "sub": "BVI-VR-DRD", "class": "SUBURBAN_AND_MAINLINE", "board": "MMCT_MAIN_BOARD"},
    {"zone": "WR", "div": "BRC", "sub": "ST-BRC", "class": "HIGH_DENSITY_NETWORK_HDN3", "board": "BRC_MAIN_BOARD"},
    {"zone": "WR", "div": "RTM", "sub": "RTM-GDA-DHD", "class": "HIGH_SPEED_TRUNK", "board": "RTM_MAIN_BOARD"},
    {"zone": "NCR", "div": "PRYJ", "sub": "PRYJ-CNB", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "PRYJ_MAIN_BOARD"},
    {"zone": "NCR", "div": "PRYJ", "sub": "PRYJ-MZP-DDU", "class": "HIGH_DENSITY_NETWORK_HDN1", "board": "PRYJ_EAST_BOARD"},
    {"zone": "NCR", "div": "AGC", "sub": "AGC-MTJ", "class": "HIGH_SPEED_TRUNK", "board": "AGC_MAIN_BOARD"},
    {"zone": "SCR", "div": "SC", "sub": "KZJ-SC", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "SC_MAIN_BOARD"},
    {"zone": "SCR", "div": "BZA", "sub": "BZA-TEL-OGL", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "BZA_MAIN_BOARD"},
    {"zone": "SR", "div": "MAS", "sub": "MAS-AJJ-KPD", "class": "HIGH_DENSITY_NETWORK_HDN2", "board": "MAS_MAIN_BOARD"},
    {"zone": "SER", "div": "KGP", "sub": "HWH-KGP-TATA", "class": "FEEDER_CORRIDOR_MINING", "board": "KGP_MAIN_BOARD"},
    {"zone": "SER", "div": "CKP", "sub": "CKP-ROU-JSG", "class": "FEEDER_CORRIDOR_MINING", "board": "CKP_MAIN_BOARD"},
    {"zone": "WCR", "div": "KOTA", "sub": "KOTA-SWM", "class": "HIGH_SPEED_TRUNK", "board": "KOTA_MAIN_BOARD"},
    {"zone": "WCR", "div": "JBP", "sub": "JBP-PPI-ET", "class": "MEDIUM_DENSITY_NETWORK", "board": "JBP_MAIN_BOARD"}
]

# Policy versions / seasons mapping
POLICY_VARIANTS = [
    {
        "year": "2026",
        "name_suffix": "Master Working Plan",
        "valid_from": "2026-04-01",
        "valid_to": "2027-03-31",
        "status": "ACTIVE",
        "version": "v2.0"
    },
    {
        "year": "2026-MONSOON",
        "name_suffix": "Monsoon Precautionary Regulation Policy",
        "valid_from": "2026-07-01",
        "valid_to": "2026-10-15",
        "status": "ACTIVE",
        "version": "v2.1-M"
    },
    {
        "year": "2026-WINTER",
        "name_suffix": "Fog & Cold Weather Operating Constraint Policy",
        "valid_from": "2026-12-01",
        "valid_to": "2027-02-15",
        "status": "PROVISIONAL",
        "version": "v2.2-W"
    },
    {
        "year": "2025",
        "name_suffix": "Historical Baseline Operational Policy",
        "valid_from": "2025-04-01",
        "valid_to": "2026-03-31",
        "status": "SUPERSEDED",
        "version": "v1.0"
    },
    {
        "year": "2027",
        "name_suffix": "Advance Projected Operating Policy",
        "valid_from": "2027-04-01",
        "valid_to": "2028-03-31",
        "status": "PROVISIONAL",
        "version": "v3.0"
    },
    {
        "year": "2026-IMBPS",
        "name_suffix": "IMBPS Multi-Disciplinary Maintenance Block Protocol",
        "valid_from": "2026-09-15",
        "valid_to": "2027-03-15",
        "status": "ACTIVE",
        "version": "v2.5-IMBPS"
    }
]

def generate_priority_definitions(cfg: Dict[str, Any], variant: Dict[str, Any]) -> List[Dict[str, Any]]:
    div = cfg["div"]
    sub = cfg["sub"]
    board = cfg["board"]
    c_class = cfg["class"]
    is_winter = "WINTER" in variant["year"]
    is_monsoon = "MONSOON" in variant["year"]

    # Maximum allowable detention minutes adjustments
    t1_detention = 0
    t2_detention = 20 if "HDN1" in c_class else (25 if "HDN2" in c_class else 30)
    t3_detention = 45 if "HDN1" in c_class else (50 if "HDN2" in c_class else 60)
    t4_detention = 240 if "HDN1" in c_class else (300 if "MINING" in c_class else 180)

    # Weather adjustments
    if is_winter:
        t2_detention += 10
        t3_detention += 15
    elif is_monsoon:
        t2_detention += 5
        t4_detention += 60

    tiers = [
        {
            "tier": "TIER_1",
            "tier_name": "National Priority & High-Speed Passenger Services",
            "class_labels": ["VANDE_BHARAT", "RAJDHANI", "SHATABDI", "TEJAS", "DURONTO"],
            "max_allowable_detention_minutes": t1_detention,
            "diversion_permitted": False,
            "short_termination_permitted": False,
            "yard_stabling_permitted": False,
            "precedence_priority_rank": 1,
            "regulation_approval_authority": "RAILWAY_BOARD_ONLY",
            "applies_to_subdivision": [sub]
        },
        {
            "tier": "TIER_2",
            "tier_name": "Major Trunk Long-Distance Express & Mail Services",
            "class_labels": ["SUPERFAST_EXPRESS", "MAIL_EXPRESS", "GARIB_RATH", "INTERCITY_EXPRESS", "JAN_SHATABDI"],
            "max_allowable_detention_minutes": t2_detention,
            "diversion_permitted": True,
            "short_termination_permitted": False,
            "yard_stabling_permitted": False,
            "precedence_priority_rank": 2,
            "regulation_approval_authority": f"SR_DOM_OPERATING_{div}",
            "applies_to_subdivision": [sub]
        },
        {
            "tier": "TIER_3",
            "tier_name": "Regional Passenger, Suburban & Commuter Services",
            "class_labels": ["MEMU", "DEMU", "PASSENGER_ORDINARY", "LOCAL_PASSENGER", "SUBURBAN_SERVICE"],
            "max_allowable_detention_minutes": t3_detention,
            "diversion_permitted": True,
            "short_termination_permitted": True,
            "yard_stabling_permitted": False,
            "precedence_priority_rank": 3,
            "regulation_approval_authority": f"DOM_OPERATING_{div}",
            "applies_to_subdivision": [sub]
        },
        {
            "tier": "TIER_4",
            "tier_name": "Freight, Heavy-Haul Bulk & Empty Rake Movements",
            "class_labels": ["FREIGHT_CONTAINER", "FREIGHT_BULK_COAL", "FREIGHT_CEMENT", "FREIGHT_FOODGRAIN", "EMPTY_RAKE", "BOXN_RAKE", "BCN_RAKE"],
            "max_allowable_detention_minutes": t4_detention,
            "diversion_permitted": True,
            "short_termination_permitted": False,
            "yard_stabling_permitted": True,
            "precedence_priority_rank": 4,
            "regulation_approval_authority": f"SECTION_CONTROLLER_{board}",
            "applies_to_subdivision": [sub]
        },
        {
            "tier": "TIER_SPECIAL",
            "tier_name": "Emergency Breakdown, Medical Relief & Tower Wagon Moves",
            "class_labels": ["ACCIDENT_RELIEF_TRAIN_ARME", "BREAKDOWN_CRANE_SPECIAL", "OHE_TOWER_WAGON_EMERGENCY"],
            "max_allowable_detention_minutes": 0,
            "diversion_permitted": False,
            "short_termination_permitted": False,
            "yard_stabling_permitted": False,
            "precedence_priority_rank": 0,
            "regulation_approval_authority": f"SENIOR_DIVISIONAL_SAFETY_OFFICER_{div}",
            "applies_to_subdivision": [sub]
        }
    ]
    return tiers

def generate_priority_policies_dataset(existing_keys: set = None) -> List[Dict[str, Any]]:
    if existing_keys is None:
        existing_keys = set()

    dataset = []
    print("Generating synthetic COA Priority Policies...")

    for cfg in SUBDIVISION_CONFIGS:
        z = cfg["zone"]
        d = cfg["div"]
        sub = cfg["sub"]
        c_class = cfg["class"]
        board = cfg["board"]

        for variant in POLICY_VARIANTS:
            p_year = variant["year"]
            unique_key = (z, d, sub, p_year)

            # Avoid collisions with existing records
            if unique_key in existing_keys:
                continue

            v_from = variant["valid_from"]
            v_to = variant["valid_to"]
            status = variant["status"]
            v_num = variant["version"]
            policy_desc = f"{sub} {variant['name_suffix']}"

            # Priority definitions
            tiers = generate_priority_definitions(cfg, variant)

            # ML & Operational metadata
            is_hdn = "HDN1" in c_class or "HDN2" in c_class
            density_score = round(random.uniform(0.75, 0.95) if is_hdn else random.uniform(0.40, 0.70), 2)
            delay_sens = round(random.uniform(0.80, 0.95) if is_hdn else random.uniform(0.50, 0.75), 2)
            reg_flex = round(random.uniform(0.40, 0.65) if is_hdn else random.uniform(0.65, 0.90), 2)
            op_risk = round(density_score * 0.55 + (1.0 - reg_flex) * 0.45, 2)

            # Full nested payload matching hybrid schema
            payload = {
                "feed_type": "COA_PRIORITY_CONSTRAINT_POLICY",
                "zone_code": z,
                "division_code": d,
                "sub_division": sub,
                "corridor_classification": c_class,
                "control_board": board,
                "policy_year": p_year,
                "policy_version": v_num,
                "policy_title": policy_desc,
                "valid_from": v_from,
                "valid_to": v_to,
                "effective_status": status,
                "priority_definitions": tiers,
                "operational_rules": {
                    "minimum_headway_minutes": 10 if "HDN1" in c_class else 15,
                    "regulation_notice_required_minutes": 45 if is_hdn else 30,
                    "precedence_allowed": True,
                    "crossing_priority": "COACHING_OVER_FREIGHT",
                    "maintenance_block_override_allowed": False,
                    "emergency_override_allowed": True,
                    "integrated_block_regulation_protocol": "STABLE_FREIGHT_FIRST"
                },
                "maintenance_interaction_rules": {
                    "tms_track_maintenance": "Divert or regulate Tier 4 first; permit Tier 2/3 regulation up to allowed max",
                    "smms_signalling_maintenance": "Absolute signal safety protection; emergency override requires DOM approval",
                    "tdms_ohe_power_block": "Apply 25kV traction dead constraints; stable electric freight in electrified yards"
                },
                "predictive_ml_metadata": {
                    "traffic_density_score": density_score,
                    "delay_sensitivity_score": delay_sens,
                    "regulation_flexibility_score": reg_flex,
                    "diversion_feasibility_score": round(random.uniform(0.35, 0.80), 2),
                    "operational_risk_score": op_risk,
                    "approval_complexity_score": round(random.uniform(0.40, 0.85), 2),
                    "synthetic_record": True
                }
            }

            row_record = {
                "zone_code": z,
                "division_code": d,
                "sub_division": sub,
                "corridor_classification": c_class,
                "policy_year": p_year,
                "payload": payload
            }

            dataset.append(row_record)
            existing_keys.add(unique_key)

    print(f"Successfully generated {len(dataset)} priority policy records.")
    return dataset

if __name__ == "__main__":
    import json
    data = generate_priority_policies_dataset()
    print(f"Total policies generated: {len(data)}")
    print("\nSample Policy Row:")
    print("Zone:", data[0]["zone_code"], "Division:", data[0]["division_code"], "Sub-Div:", data[0]["sub_division"], "Year:", data[0]["policy_year"])
    print("\nSample Payload:")
    print(json.dumps(data[0]["payload"], indent=2))
