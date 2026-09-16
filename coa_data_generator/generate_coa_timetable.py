"""
COA Master Working Timetable Generator.
Generates realistic train timetable paths and correlated path segments
for the IMBPS project, compatible with TMS, SMMS, and TDMS maintenance data.
"""

import os
import random
from datetime import datetime, time, timedelta
from typing import List, Dict, Any
import numpy as np

from railway_location_master import LOCATION_MASTER
from train_master import (
    pick_category, pick_traction, pick_length, pick_speed,
    pick_frequency, generate_train_identity
)
from load_existing_maintenance_data import load_maintenance_records

# Deterministic seed
random.seed(42)
np.random.seed(42)

def time_to_minutes(t_str: str) -> int:
    try:
        parts = t_str.split(":")
        return int(parts[0]) * 60 + int(parts[1])
    except Exception:
        return 0

def minutes_to_time(m: int) -> str:
    m = m % (24 * 60)
    hh = m // 60
    mm = m % 60
    return f"{hh:02d}:{mm:02d}"

def check_overlap(entry_m: int, exit_m: int, block_start_str: str, block_end_str: str) -> bool:
    if not block_start_str or not block_end_str:
        return False
    b_start = time_to_minutes(block_start_str)
    b_end = time_to_minutes(block_end_str)
    if b_end < b_start:
        b_end += 24 * 60 # crosses midnight
    if exit_m < entry_m:
        exit_m += 24 * 60
    # Overlap if max(start1, start2) < min(end1, end2)
    return max(entry_m, b_start) < min(exit_m, b_end)

def generate_coa_dataset(num_records: int = 2200, existing_numbers: set = None) -> List[Dict[str, Any]]:
    if existing_numbers is None:
        existing_numbers = set()

    maint_data = load_maintenance_records()
    tms_list = maint_data["tms"]
    smms_list = maint_data["smms"]
    tdms_list = maint_data["tdms"]

    # Zone distribution weights: High priority to ECR, ER, NR
    zone_weights = {
        "ECR": 0.32,
        "ER":  0.30,
        "NR":  0.20,
        "CR":  0.03,
        "WR":  0.03,
        "NCR": 0.03,
        "SCR": 0.03,
        "SR":  0.02,
        "SER": 0.02,
        "WCR": 0.02
    }
    zones = list(zone_weights.keys())
    probs = list(zone_weights.values())

    dataset = []
    print(f"Generating {num_records} synthetic COA Master Timetable records...")

    effective_from = "2026-10-01"
    effective_to = "2027-03-31"
    generated_at = "2026-09-15T15:02:00+05:30"

    for i in range(num_records):
        # 1. Select Zone
        z_code = np.random.choice(zones, p=probs)
        z_info = LOCATION_MASTER[z_code]

        # 2. Select Division
        div_codes = list(z_info["divisions"].keys())
        div_code = random.choice(div_codes)
        div_info = z_info["divisions"][div_code]

        # 3. Select Sub-Division
        sub_divs = list(div_info["sub_divisions"].keys())
        sub_div = random.choice(sub_divs)
        sub_info = div_info["sub_divisions"][sub_div]

        # 4. Select Section
        sec_info = random.choice(sub_info["sections"])
        sec_id = sec_info["section_id"]
        sec_name = sec_info["section_name"]
        assigned_line = random.choice(sec_info["lines"])
        stations = sec_info["stations"]

        origin_station = stations[0]
        dest_station = stations[-1]

        # 5. Select Train Characteristics
        category = pick_category()
        traction = pick_traction(category)
        coaches = pick_length(category)
        speed_kmph = pick_speed(category)
        frequency = pick_frequency(category)

        t_num, t_name = generate_train_identity(
            category, origin_station["name"], dest_station["name"], i + 1, existing_numbers
        )

        # 6. Generate Path Segments
        # Path segments across intermediate stations
        path_segments = []
        
        # Base departure time across the day (00:00 to 23:59)
        base_departure_minutes = random.randint(0, 1420)
        curr_time_m = base_departure_minutes

        # Decide whether train covers single section as 1 segment or step-by-step
        num_intermediate = len(stations) - 1
        if num_intermediate <= 2 or random.random() < 0.35:
            # Single composite segment across the whole section
            total_dist = sec_info["distance_km"]
            travel_mins = max(12, int((total_dist / speed_kmph) * 60 + random.uniform(-3, 6)))
            entry_m = curr_time_m
            exit_m = entry_m + travel_mins

            entry_str = minutes_to_time(entry_m)
            exit_str = minutes_to_time(exit_m)

            has_halt = category not in ["Goods/Freight", "Rajdhani/Duronto/Vande Bharat"] and random.random() < 0.4
            halt_dur = random.choice([2, 5, 10]) if has_halt else None

            # Prior and post buffer
            prior_buf = random.choice([10, 15, 20])
            post_buf = random.choice([5, 10, 15])

            # Check maintenance conflicts
            maint_conflict = False
            conf_sys = None
            conf_type = None
            elec_affected = False

            # Match with TMS
            for tms in tms_list:
                if sec_name.lower() in str(tms.get("section", "")).lower() or div_code in str(tms.get("division", "")):
                    if check_overlap(entry_m, exit_m, tms.get("start_time"), tms.get("end_time")):
                        maint_conflict = True
                        conf_sys = "TMS"
                        conf_type = "TRACK_BLOCK_OVERLAP"
                        break

            # Match with SMMS
            if not maint_conflict:
                for smms in smms_list:
                    if smms.get("station_code") in [origin_station["code"], dest_station["code"]]:
                        if check_overlap(entry_m, exit_m, smms.get("start_time"), smms.get("end_time")):
                            maint_conflict = True
                            conf_sys = "SMMS"
                            conf_type = "SIGNAL_TRAFFIC_BLOCK_OVERLAP"
                            break

            # Match with TDMS
            if not maint_conflict:
                for tdms in tdms_list:
                    if sec_name.lower() in str(tdms.get("section", "")).lower() or div_code in str(tdms.get("block_section", "")):
                        if check_overlap(entry_m, exit_m, tdms.get("start_time"), tdms.get("end_time")):
                            maint_conflict = True
                            conf_sys = "TDMS"
                            conf_type = "POWER_BLOCK_OVERLAP"
                            if "ELECTRIC" in traction:
                                elec_affected = True
                            break

            seg = {
                "section_id": sec_id,
                "from_station": origin_station["code"],
                "to_station": dest_station["code"],
                "station_code": dest_station["code"],
                "assigned_line": assigned_line,
                "scheduled_entry_time": entry_str,
                "scheduled_exit_time": exit_str,
                "commercial_halt": has_halt,
                "halt_duration_mins": halt_dur,
                "operational_headway_buffer_prior_mins": prior_buf,
                "operational_headway_buffer_post_mins": post_buf
            }
            if maint_conflict:
                seg["maintenance_conflict"] = True
                seg["conflicting_system"] = conf_sys
                seg["conflict_type"] = conf_type
                if elec_affected:
                    seg["electric_traction_affected"] = True

            path_segments.append(seg)

        else:
            # Multiple station-to-station segments
            avg_seg_dist = sec_info["distance_km"] / max(1, (len(stations) - 1))
            for st_idx in range(len(stations) - 1):
                st_from = stations[st_idx]
                st_to = stations[st_idx + 1]
                sub_sec_id = f"{sec_id}_{st_from['code']}_{st_to['code']}"

                travel_mins = max(8, int((avg_seg_dist / speed_kmph) * 60 + random.uniform(-2, 4)))
                entry_m = curr_time_m
                exit_m = entry_m + travel_mins

                entry_str = minutes_to_time(entry_m)
                exit_str = minutes_to_time(exit_m)

                is_junc = st_to.get("junction", False)
                if is_junc:
                    has_halt = category != "Goods/Freight"
                    halt_dur = random.choice([3, 5, 8]) if has_halt else None
                else:
                    has_halt = category in ["Passenger", "MEMU", "DEMU"] or (category == "Express" and random.random() < 0.25)
                    halt_dur = random.choice([1, 2, 3]) if has_halt else None

                prior_buf = random.choice([10, 15])
                post_buf = random.choice([5, 10])

                maint_conflict = False
                conf_sys = None
                conf_type = None
                elec_affected = False

                for tms in tms_list:
                    if st_from["code"] in str(tms.get("block_section", "")) or st_to["code"] in str(tms.get("block_section", "")):
                        if check_overlap(entry_m, exit_m, tms.get("start_time"), tms.get("end_time")):
                            maint_conflict = True
                            conf_sys = "TMS"
                            conf_type = "TRACK_BLOCK_OVERLAP"
                            break

                if not maint_conflict:
                    for tdms in tdms_list:
                        if sec_name.lower() in str(tdms.get("section", "")).lower() or div_code in str(tdms.get("block_section", "")):
                            if check_overlap(entry_m, exit_m, tdms.get("start_time"), tdms.get("end_time")):
                                maint_conflict = True
                                conf_sys = "TDMS"
                                conf_type = "POWER_BLOCK_OVERLAP"
                                if "ELECTRIC" in traction:
                                    elec_affected = True
                                break

                seg = {
                    "section_id": sub_sec_id,
                    "from_station": st_from["code"],
                    "to_station": st_to["code"],
                    "station_code": st_to["code"],
                    "assigned_line": assigned_line,
                    "scheduled_entry_time": entry_str,
                    "scheduled_exit_time": exit_str,
                    "commercial_halt": has_halt,
                    "halt_duration_mins": halt_dur,
                    "operational_headway_buffer_prior_mins": prior_buf,
                    "operational_headway_buffer_post_mins": post_buf
                }
                if maint_conflict:
                    seg["maintenance_conflict"] = True
                    seg["conflicting_system"] = conf_sys
                    seg["conflict_type"] = conf_type
                    if elec_affected:
                        seg["electric_traction_affected"] = True

                path_segments.append(seg)
                curr_time_m = exit_m + (halt_dur if has_halt and halt_dur else 0)

        # 7. Construct Full Hybrid Payload
        payload = {
            "feed_type": "COA_MASTER_TIMETABLE_PATHS",
            "zone_code": z_code,
            "division_code": div_code,
            "sub_division": sub_div,
            "effective_from": effective_from,
            "effective_to": effective_to,
            "generated_at": generated_at,
            "train_number": t_num,
            "train_name": t_name,
            "service_frequency": frequency,
            "traction": traction,
            "train_length_coaches": coaches,
            "train_category": category,
            "synthetic_record": True,
            "data_source": "GENERATED_RESEARCH_DATA",
            "source_system": "COA",
            "feed_version": "IMBPS-COA-SYNTHETIC-2026-09",
            "record_status": "ACTIVE",
            "path_segments": path_segments
        }

        # 8. Construct Row Record for `coa_master_timetable`
        row_record = {
            "train_number": t_num,
            "train_name": t_name,
            "division_code": div_code,
            "sub_division": sub_div,
            "traction": traction,
            "train_length_coaches": coaches,
            "payload": payload
        }

        dataset.append(row_record)

    print(f"Successfully generated {len(dataset)} train timetable records.")
    return dataset

if __name__ == "__main__":
    import json
    data = generate_coa_dataset(5)
    print("\nSample Generated Train Record:")
    print(json.dumps(data[0]["payload"], indent=2))
