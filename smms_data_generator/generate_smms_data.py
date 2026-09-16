"""
IMBPS - Indian Railways Signal & Telecom Maintenance Management System (SMMS)
Synthetic Data Generator module.

Generates realistic, domain-aware SMMS maintenance, disconnection, and block-planning records.
Enforces strict geographic, logical, temporal, and safety constraints.
"""

import math
import random
from datetime import date, datetime, time, timedelta
from typing import Any, Dict, List, Tuple

# Deterministic random seed for reproducibility
random.seed(42)

# ==============================================================================
# 1. AUTHENTIC RAILWAY NETWORK TOPOLOGY (15 ZONES & AUTHENTIC STATIONS)
# ==============================================================================

RAILWAY_LOCATIONS: Dict[str, Dict[str, Any]] = {
    # --- Priority Zone 1: Eastern Railway (ER) ---
    "ER": {
        "zone_name": "Eastern Railway",
        "divisions": {
            "Asansol (ASN)": {
                "div_code": "ASN",
                "weight": 0.16,
                "stations": [
                    {"code": "UDL", "name": "Andal Jn"},
                    {"code": "SNT", "name": "Sainthia Jn"},
                    {"code": "TOP", "name": "Tapasi"},
                    {"code": "BBI", "name": "Barabani"},
                    {"code": "STN", "name": "Sitarampur Jn"},
                    {"code": "MDP", "name": "Madhupur Jn"},
                    {"code": "GRD", "name": "Giridih"},
                    {"code": "JSME", "name": "Jasidih Jn"},
                    {"code": "BDME", "name": "Baidyanathdham"},
                    {"code": "DUMK", "name": "Dumka"},
                    {"code": "DGHR", "name": "Deoghar Jn"},
                    {"code": "BAKA", "name": "Banka Jn"},
                    {"code": "ASN", "name": "Asansol Jn"},
                    {"code": "RNG", "name": "Raniganj"},
                    {"code": "UKA", "name": "Ukhra"},
                    {"code": "PAW", "name": "Pandabeswar"},
                    {"code": "DUJ", "name": "Dubrajpur"},
                    {"code": "CPLE", "name": "Chinpai"},
                ],
            },
            "Howrah (HWH)": {
                "div_code": "HWH",
                "weight": 0.16,
                "stations": [
                    {"code": "HWH", "name": "Howrah Jn"},
                    {"code": "KAN", "name": "Khana Jn"},
                    {"code": "GMAN", "name": "Gumani"},
                    {"code": "RPH", "name": "Rampurhat Jn"},
                    {"code": "BDC", "name": "Bandel Jn"},
                    {"code": "AZ", "name": "Azimganj Jn"},
                    {"code": "DKAE", "name": "Dankuni Jn"},
                    {"code": "BTNG", "name": "Bhattanagar"},
                    {"code": "RCD", "name": "Rajchandrapur"},
                    {"code": "SHE", "name": "Sheoraphuli Jn"},
                    {"code": "TAK", "name": "Tarakeswar"},
                    {"code": "GOGT", "name": "Goghat"},
                    {"code": "HYG", "name": "Hooghly Ghat"},
                    {"code": "NHT", "name": "Nalhati Jn"},
                    {"code": "BWN", "name": "Barddhaman Jn"},
                    {"code": "BHP", "name": "Bolpur Shantiniketan"},
                    {"code": "PKR", "name": "Pakur"},
                    {"code": "KWAE", "name": "Katwa Jn"},
                ],
            },
            "Sealdah (SDAH)": {
                "div_code": "SDAH",
                "weight": 0.05,
                "stations": [
                    {"code": "SDAH", "name": "Sealdah"},
                    {"code": "NH", "name": "Naihati Jn"},
                    {"code": "RHA", "name": "Ranaghat Jn"},
                    {"code": "BNJ", "name": "Bongaon Jn"},
                    {"code": "BP", "name": "Barrackpore"},
                    {"code": "BT", "name": "Barasat Jn"},
                ],
            },
        },
    },
    # --- Priority Zone 2: Northern Railway (NR) ---
    "NR": {
        "zone_name": "Northern Railway",
        "divisions": {
            "Ambala (UMB)": {
                "div_code": "UMB",
                "weight": 0.17,
                "stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn"},
                    {"code": "LDH", "name": "Ludhiana Jn"},
                    {"code": "BTI", "name": "Bathinda Jn"},
                    {"code": "CDG", "name": "Chandigarh Jn"},
                    {"code": "KLK", "name": "Kalka"},
                    {"code": "SML", "name": "Shimla (Heritage NG)"},
                    {"code": "SRE", "name": "Saharanpur Jn"},
                    {"code": "JUDW", "name": "Jagadhri Workshop"},
                    {"code": "YJUD", "name": "Yamunanagar Jagadhri"},
                    {"code": "KKDE", "name": "Kurukshetra Jn"},
                    {"code": "RPJ", "name": "Rajpura Jn"},
                    {"code": "DUI", "name": "Dhuri Jn"},
                    {"code": "SIR", "name": "Sirhind Jn"},
                    {"code": "NLDM", "name": "Nangal Dam"},
                    {"code": "AADR", "name": "Amb Andaura"},
                    {"code": "PTA", "name": "Patiala"},
                    {"code": "ABH", "name": "Abohar Jn"},
                    {"code": "KNN", "name": "Khanna"},
                ],
            },
            "Delhi (DLI)": {
                "div_code": "DLI",
                "weight": 0.06,
                "stations": [
                    {"code": "NDLS", "name": "New Delhi"},
                    {"code": "NZM", "name": "Hazrat Nizamuddin"},
                    {"code": "DLI", "name": "Delhi Jn"},
                    {"code": "TKD", "name": "Tuglakabad"},
                    {"code": "FDB", "name": "Faridabad"},
                    {"code": "PWL", "name": "Palwal"},
                    {"code": "PNP", "name": "Panipat Jn"},
                    {"code": "SNP", "name": "Sonipat"},
                ],
            },
            "Lucknow (LKO-NR)": {
                "div_code": "LKO",
                "weight": 0.04,
                "stations": [
                    {"code": "LKO", "name": "Lucknow Charbagh"},
                    {"code": "ON", "name": "Unnao Jn"},
                    {"code": "RBL", "name": "Rae Bareli Jn"},
                    {"code": "AME", "name": "Amethi"},
                    {"code": "PBH", "name": "Pratapgarh Jn"},
                ],
            },
        },
    },
    # --- Priority Zone 3: South Central Railway (SCR) ---
    "SCR": {
        "zone_name": "South Central Railway",
        "divisions": {
            "Vijayawada (BZA)": {
                "div_code": "BZA",
                "weight": 0.07,
                "stations": [
                    {"code": "BZA", "name": "Vijayawada Jn"},
                    {"code": "TOU", "name": "Telaprolu"},
                    {"code": "RJY", "name": "Rajahmundry"},
                    {"code": "EE", "name": "Eluru"},
                    {"code": "TEL", "name": "Tenali Jn"},
                    {"code": "OGL", "name": "Ongole"},
                    {"code": "GDR", "name": "Gudur Jn"},
                    {"code": "SLO", "name": "Samalkot Jn"},
                ],
            },
            "Secunderabad (SC)": {
                "div_code": "SC",
                "weight": 0.06,
                "stations": [
                    {"code": "SC", "name": "Secunderabad Jn"},
                    {"code": "KZJ", "name": "Kazipet Jn"},
                    {"code": "ZN", "name": "Jangaon"},
                    {"code": "BG", "name": "Bhongir"},
                    {"code": "WL", "name": "Warangal"},
                    {"code": "KMT", "name": "Khammam"},
                    {"code": "VKB", "name": "Vikarabad Jn"},
                ],
            },
        },
    },
    # --- Central Railway (CR) ---
    "CR": {
        "zone_name": "Central Railway",
        "divisions": {
            "Mumbai (CSTM)": {
                "div_code": "CR-BB",
                "weight": 0.05,
                "stations": [
                    {"code": "CSMT", "name": "Chhatrapati Shivaji Maharaj Terminus"},
                    {"code": "DR", "name": "Dadar Central"},
                    {"code": "TNA", "name": "Thane"},
                    {"code": "KYN", "name": "Kalyan Jn"},
                    {"code": "KSRA", "name": "Kasara"},
                    {"code": "IGP", "name": "Igatpuri"},
                    {"code": "KJT", "name": "Karjat Jn"},
                    {"code": "LNL", "name": "Lonavala"},
                ],
            },
            "Bhusawal (BSL)": {
                "div_code": "CR-BSL",
                "weight": 0.04,
                "stations": [
                    {"code": "BSL", "name": "Bhusawal Jn"},
                    {"code": "MMR", "name": "Manmad Jn"},
                    {"code": "NK", "name": "Nashik Road"},
                    {"code": "CSN", "name": "Chalisgaon Jn"},
                    {"code": "JL", "name": "Jalgaon Jn"},
                ],
            },
        },
    },
    # --- Western Railway (WR) ---
    "WR": {
        "zone_name": "Western Railway",
        "divisions": {
            "Mumbai Central (MMCT)": {
                "div_code": "WR-BCT",
                "weight": 0.04,
                "stations": [
                    {"code": "CCG", "name": "Churchgate"},
                    {"code": "BVI", "name": "Borivali"},
                    {"code": "BYR", "name": "Bhayandar"},
                    {"code": "VR", "name": "Virar"},
                    {"code": "PLG", "name": "Palghar"},
                    {"code": "DRD", "name": "Dahanu Road"},
                ],
            },
            "Vadodara (BRC)": {
                "div_code": "WR-BRC",
                "weight": 0.04,
                "stations": [
                    {"code": "BRC", "name": "Vadodara Jn"},
                    {"code": "ST", "name": "Surat"},
                    {"code": "BH", "name": "Bharuch Jn"},
                    {"code": "ANND", "name": "Anand Jn"},
                    {"code": "ND", "name": "Nadiad Jn"},
                ],
            },
        },
    },
    # --- North Central Railway (NCR) ---
    "NCR": {
        "zone_name": "North Central Railway",
        "divisions": {
            "Prayagraj (PRYJ)": {
                "div_code": "NCR-PRYJ",
                "weight": 0.04,
                "stations": [
                    {"code": "PRYJ", "name": "Prayagraj Jn"},
                    {"code": "CNB", "name": "Kanpur Central"},
                    {"code": "FTP", "name": "Fatehpur"},
                    {"code": "MZP", "name": "Mirzapur"},
                    {"code": "SFG", "name": "Subedarganj"},
                ],
            },
            "Jhansi (VGLJ)": {
                "div_code": "NCR-JHS",
                "weight": 0.03,
                "stations": [
                    {"code": "VGLJ", "name": "VGL Jhansi Jn"},
                    {"code": "GWL", "name": "Gwalior Jn"},
                    {"code": "LAR", "name": "Lalitpur Jn"},
                    {"code": "BINA", "name": "Bina Jn"},
                ],
            },
        },
    },
    # --- Southern Railway (SR) ---
    "SR": {
        "zone_name": "Southern Railway",
        "divisions": {
            "Chennai (MAS)": {
                "div_code": "SR-MAS",
                "weight": 0.03,
                "stations": [
                    {"code": "MAS", "name": "Chennai Central"},
                    {"code": "PER", "name": "Perambur"},
                    {"code": "TRL", "name": "Tiruvallur"},
                    {"code": "AJJ", "name": "Arakkonam Jn"},
                    {"code": "TBM", "name": "Tambaram"},
                    {"code": "CGL", "name": "Chengalpattu Jn"},
                ],
            },
            "Palakkad (PGT)": {
                "div_code": "SR-PGT",
                "weight": 0.03,
                "stations": [
                    {"code": "PGT", "name": "Palakkad Jn"},
                    {"code": "SRR", "name": "Shoranur Jn"},
                    {"code": "OTP", "name": "Ottappalam"},
                    {"code": "TIR", "name": "Tirur"},
                    {"code": "CLT", "name": "Kozhikode"},
                ],
            },
        },
    },
    # --- South Eastern Railway (SER) ---
    "SER": {
        "zone_name": "South Eastern Railway",
        "divisions": {
            "Kharagpur (KGP)": {
                "div_code": "SER-KGP",
                "weight": 0.03,
                "stations": [
                    {"code": "KGP", "name": "Kharagpur Jn"},
                    {"code": "SRC", "name": "Santragachi Jn"},
                    {"code": "ULB", "name": "Uluberia"},
                    {"code": "MCA", "name": "Mecheda"},
                    {"code": "JGM", "name": "Jhargram"},
                    {"code": "TATA", "name": "Tatanagar Jn"},
                ],
            }
        },
    },
    # --- East Coast Railway (ECoR) ---
    "ECoR": {
        "zone_name": "East Coast Railway",
        "divisions": {
            "Khurda Road (KUR)": {
                "div_code": "ECoR-KUR",
                "weight": 0.03,
                "stations": [
                    {"code": "KUR", "name": "Khurda Road Jn"},
                    {"code": "BBS", "name": "Bhubaneswar"},
                    {"code": "CTC", "name": "Cuttack Jn"},
                    {"code": "JJKR", "name": "Jajpur Keonjhar Road"},
                    {"code": "BHC", "name": "Bhadrak"},
                    {"code": "PURI", "name": "Puri"},
                ],
            }
        },
    },
    # --- South Western Railway (SWR) ---
    "SWR": {
        "zone_name": "South Western Railway",
        "divisions": {
            "Bengaluru (SBC)": {
                "div_code": "SWR-SBC",
                "weight": 0.03,
                "stations": [
                    {"code": "SBC", "name": "KSR Bengaluru"},
                    {"code": "KJM", "name": "Krishnarajapuram"},
                    {"code": "BWT", "name": "Bangarapet Jn"},
                    {"code": "RMGM", "name": "Ramanagaram"},
                    {"code": "MYA", "name": "Mandya"},
                    {"code": "MYS", "name": "Mysuru Jn"},
                ],
            }
        },
    },
    # --- South East Central Railway (SECR) ---
    "SECR": {
        "zone_name": "South East Central Railway",
        "divisions": {
            "Bilaspur (BSP)": {
                "div_code": "SECR-BSP",
                "weight": 0.03,
                "stations": [
                    {"code": "BSP", "name": "Bilaspur Jn"},
                    {"code": "BYT", "name": "Bhatapara"},
                    {"code": "R", "name": "Raipur Jn"},
                    {"code": "DURG", "name": "Durg Jn"},
                ],
            }
        },
    },
    # --- North Western Railway (NWR) ---
    "NWR": {
        "zone_name": "North Western Railway",
        "divisions": {
            "Jaipur (JP)": {
                "div_code": "NWR-JP",
                "weight": 0.02,
                "stations": [
                    {"code": "JP", "name": "Jaipur Jn"},
                    {"code": "AWR", "name": "Alwar Jn"},
                    {"code": "BKI", "name": "Bandikui Jn"},
                    {"code": "RE", "name": "Rewari Jn"},
                ],
            }
        },
    },
    # --- West Central Railway (WCR) ---
    "WCR": {
        "zone_name": "West Central Railway",
        "divisions": {
            "Jabalpur (JBP)": {
                "div_code": "WCR-JBP",
                "weight": 0.02,
                "stations": [
                    {"code": "JBP", "name": "Jabalpur Jn"},
                    {"code": "ET", "name": "Itarsi Jn"},
                    {"code": "PPI", "name": "Pipariya"},
                    {"code": "NU", "name": "Narsinghpur"},
                    {"code": "KTE", "name": "Katni Jn"},
                ],
            }
        },
    },
    # --- North Eastern Railway (NER) ---
    "NER": {
        "zone_name": "North Eastern Railway",
        "divisions": {
            "Varanasi (BSB)": {
                "div_code": "NER-BSB",
                "weight": 0.02,
                "stations": [
                    {"code": "GKP", "name": "Gorakhpur Jn"},
                    {"code": "DEOS", "name": "Deoria Sadar"},
                    {"code": "BTT", "name": "Bhatni Jn"},
                    {"code": "SV", "name": "Siwan Jn"},
                    {"code": "CPR", "name": "Chhapra Jn"},
                ],
            }
        },
    },
    # --- Northeast Frontier Railway (NFR) ---
    "NFR": {
        "zone_name": "Northeast Frontier Railway",
        "divisions": {
            "Katihar (KIR)": {
                "div_code": "NFR-KIR",
                "weight": 0.02,
                "stations": [
                    {"code": "KIR", "name": "Katihar Jn"},
                    {"code": "NJP", "name": "New Jalpaiguri Jn"},
                    {"code": "JPE", "name": "Jalpaiguri Road"},
                    {"code": "DQG", "name": "Dhupguri"},
                    {"code": "NCB", "name": "New Cooch Behar"},
                ],
            }
        },
    },
}


# ==============================================================================
# 2. SMMS ASSET & MAINTENANCE CATALOG (SECTIONS 7, 8, 9, 10, 16)
# ==============================================================================

MAINTENANCE_CATALOG = [
    # --- POINT MACHINES ---
    {
        "gear_type": "Point Machine",
        "gear_id_template": "Point No. {num}{sub}",
        "asset_code_prefix": "PM",
        "category": "Point Machine Maintenance",
        "maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": True,
        "crank_handle_locked": True,
        "alternate_movement": "Main line straight movements only (Point Normal clamped and locked)",
        "duration_range": (90, 150),
        "cost_base": 32000,
        "priority_bias": "HIGH",
        "failure_type": "Motor Burnout / Detection Slip",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "Electric Point Machine",
        "gear_id_template": "Point No. {num}{sub}",
        "asset_code_prefix": "EPM",
        "category": "Point Machine Maintenance",
        "maintenance_nature": "Point Machine Lubrication, Friction Clutch Slipping Current & Obstruction Test (5mm Test)",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": True,
        "crank_handle_locked": True,
        "alternate_movement": "Facing movements on Hand Signal after crank handle padlocking",
        "duration_range": (60, 90),
        "cost_base": 12500,
        "priority_bias": "MEDIUM",
        "failure_type": "Obstruction Slip / Mechanical Drag",
        "season_affinity": ["winter", "all"],
    },
    {
        "gear_type": "Clamp Lock Point Machine",
        "gear_id_template": "Turnout No. {num} Clamp Assembly",
        "asset_code_prefix": "CLP",
        "category": "Point Machine Maintenance",
        "maintenance_nature": "Clamp Lock Overhaul, Throw Rod Adjustment & Insulation Testing",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": True,
        "crank_handle_locked": True,
        "alternate_movement": "Trailing line movements allowed with 15 kmph caution",
        "duration_range": (90, 180),
        "cost_base": 24000,
        "priority_bias": "HIGH",
        "failure_type": "Clamp Lock Wear / Lost Motion",
        "season_affinity": ["all"],
    },
    # --- ELECTRONIC & RELAY INTERLOCKING ---
    {
        "gear_type": "Electronic Interlocking (EI)",
        "gear_id_template": "EI Rack Unit #{num}",
        "asset_code_prefix": "EI",
        "category": "Relay/Electronic Interlocking Testing",
        "maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization",
        "requires_traffic_block": True,
        "requires_power_block": True,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)",
        "duration_range": (120, 240),
        "cost_base": 115000,
        "priority_bias": "CRITICAL",
        "failure_type": "Voter Board / Communication Card Degradation",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "Relay Interlocking (PI/RRI)",
        "gear_id_template": "Relay Rack Bay #{num}",
        "asset_code_prefix": "RI",
        "category": "Relay/Electronic Interlocking Testing",
        "maintenance_nature": "Plug-in Type Q-Series Relay Contact Resistance Measurement & Cross-Talk Testing",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Non-interlocked reception authorized under Line Clear confirmation",
        "duration_range": (120, 300),
        "cost_base": 42000,
        "priority_bias": "HIGH",
        "failure_type": "Contact Oxidation / High Resistance",
        "season_affinity": ["monsoon", "winter"],
    },
    # --- AXLE COUNTERS & TRACK CIRCUITS ---
    {
        "gear_type": "Digital Axle Counter (HASSDAC/MSDAC)",
        "gear_id_template": "Axle Counter Unit DP-{num}",
        "asset_code_prefix": "DAC",
        "category": "Axle Counter/Track Circuit Testing",
        "maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Block Section line clear verified via station master reset box",
        "duration_range": (60, 120),
        "cost_base": 38000,
        "priority_bias": "CRITICAL",
        "failure_type": "Phase Angle Drift / Sensor Attenuation",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "DC Track Circuit",
        "gear_id_template": "Track Circuit TC-{num}T",
        "asset_code_prefix": "TC",
        "category": "Axle Counter/Track Circuit Testing",
        "maintenance_nature": "Insulated Rail Joint (Glued Joint) End-Post renewal & Track Relay PU/DO Voltage check",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Manual track circuit clip verification before route setting",
        "duration_range": (60, 105),
        "cost_base": 16500,
        "priority_bias": "MEDIUM",
        "failure_type": "Ballast Resistance Leakage / IRJ Failure",
        "season_affinity": ["monsoon"],
    },
    # --- SIGNALS & LED UNITS ---
    {
        "gear_type": "Colour Light Signal (LED)",
        "gear_id_template": "Signal Post S-{num}",
        "asset_code_prefix": "SIG",
        "category": "Signal Lamp/LED Replacement",
        "maintenance_nature": "Main LED Signal Aspect Module Replacement and Current Regulator Tuning",
        "requires_traffic_block": False,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Visual hand signal displayed by pilot guard during aspect replacement",
        "duration_range": (30, 60),
        "cost_base": 6500,
        "priority_bias": "LOW",
        "failure_type": "LED Array Degradation / Current Sense Trip",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "Route Indicator / Shunt Signal",
        "gear_id_template": "Shunt Signal SH-{num}",
        "asset_code_prefix": "SHN",
        "category": "Signal Lamp/LED Replacement",
        "maintenance_nature": "Stencil Route Indicator LED matrix servicing & alignment verification",
        "requires_traffic_block": False,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Hand piloting for shunting operations inside yard",
        "duration_range": (45, 75),
        "cost_base": 4800,
        "priority_bias": "LOW",
        "failure_type": "Matrix LED Failure",
        "season_affinity": ["all"],
    },
    # --- CABLES & LINE INFRASTRUCTURE ---
    {
        "gear_type": "Signalling Cable (6-Core / 12-Core / 24-Core)",
        "gear_id_template": "Cable Feeder Bay #{num} Main Trunk",
        "asset_code_prefix": "CAB",
        "category": "Cable Fault Rectification",
        "maintenance_nature": "Signalling Main Underground Armoured Cable Meggering, Core Testing & Joint Enclosure Waterproofing",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Local point operation with hand crank in case of disconnection",
        "duration_range": (120, 300),
        "cost_base": 48000,
        "priority_bias": "HIGH",
        "failure_type": "Low Insulation Resistance / Water Ingress",
        "season_affinity": ["monsoon"],
    },
    # --- POWER & BATTERY SYSTEMS ---
    {
        "gear_type": "Integrated Power Supply (IPS)",
        "gear_id_template": "IPS Rack Model SMR-{num}",
        "asset_code_prefix": "IPS",
        "category": "Battery and Power System Maintenance",
        "maintenance_nature": "Switch Mode Rectifier (SMR) Module Replacement and DC-DC Inverter Overhaul",
        "requires_traffic_block": False,
        "requires_power_block": True,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Load switched to standby battery bank with zero transit interruption",
        "duration_range": (90, 180),
        "cost_base": 58000,
        "priority_bias": "HIGH",
        "failure_type": "Inverter Harmonic Distort / Rectifier Fail",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "Signalling Battery Bank (110V / 24V)",
        "gear_id_template": "Battery Bank Bay #{num} (VRLA/LM)",
        "asset_code_prefix": "BAT",
        "category": "Battery and Power System Maintenance",
        "maintenance_nature": "Specific Gravity Measurement, Electrolyte Topping & Cell Discharge Capacity Testing",
        "requires_traffic_block": False,
        "requires_power_block": True,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Main supply powering system via IPS float charger",
        "duration_range": (60, 120),
        "cost_base": 14000,
        "priority_bias": "MEDIUM",
        "failure_type": "Cell Sulphation / Weak Voltage Under Load",
        "season_affinity": ["winter"],
    },
    # --- TELECOM & OFC INFRASTRUCTURE ---
    {
        "gear_type": "Optical Fibre Cable (OFC) System",
        "gear_id_template": "OFC 24-Fiber Armoured Route Link #{num}",
        "asset_code_prefix": "OFC",
        "category": "Telecom Equipment Maintenance",
        "maintenance_nature": "OTDR Fibre Attenuation Profiling, Fusion Splicing and Splice Enclosure Sealing",
        "requires_traffic_block": False,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Traffic signals unaffected; control speech on standby copper quad cable",
        "duration_range": (90, 240),
        "cost_base": 36000,
        "priority_bias": "MEDIUM",
        "failure_type": "Fibre Cut / High Optical Attenuation",
        "season_affinity": ["spring", "all"],
    },
    {
        "gear_type": "IP-MPLS Router / SDH Equipment",
        "gear_id_template": "IP-MPLS Router Core #{num}",
        "asset_code_prefix": "RTR",
        "category": "Telecom Equipment Maintenance",
        "maintenance_nature": "Firmware security patch installation, Gigabit SFP module renewal and redundant power supply test",
        "requires_traffic_block": False,
        "requires_power_block": True,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Secondary router handling data traffic seamlessly",
        "duration_range": (60, 120),
        "cost_base": 65000,
        "priority_bias": "MEDIUM",
        "failure_type": "SFP Transceiver Drift / Port Error",
        "season_affinity": ["all"],
    },
    {
        "gear_type": "VHF / Control Communication System",
        "gear_id_template": "Station VHF Base Station 25W #{num}",
        "asset_code_prefix": "VHF",
        "category": "Telecom Equipment Maintenance",
        "maintenance_nature": "Transceiver VSWR Measurement, Antenna Mast Guy Wire Tensioning & Emergency Audio Test",
        "requires_traffic_block": False,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Walkie-talkie backup communication channels enabled",
        "duration_range": (45, 90),
        "cost_base": 9500,
        "priority_bias": "LOW",
        "failure_type": "High Antenna VSWR / RF Power Drop",
        "season_affinity": ["all"],
    },
    # --- LEVEL CROSSING INTERLOCKING ---
    {
        "gear_type": "Level Crossing (LC) Gate Interlocking",
        "gear_id_template": "LC Gate No. {num} Interlocking System",
        "asset_code_prefix": "LC",
        "category": "Scheduled Inspection",
        "maintenance_nature": "Electric Lifting Barrier Motor Servicing, Boom Interlocking Contact Overhaul & Warning Bell Testing",
        "requires_traffic_block": True,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Road traffic stopped with manual emergency chains; trains pass at normal signal",
        "duration_range": (60, 120),
        "cost_base": 22000,
        "priority_bias": "HIGH",
        "failure_type": "Barrier Interlock Failure / Microswitch Fault",
        "season_affinity": ["all"],
    },
    # --- DATA LOGGER ---
    {
        "gear_type": "Data Logger System",
        "gear_id_template": "Data Logger DL-2048 #{num}",
        "asset_code_prefix": "DL",
        "category": "Scheduled Inspection",
        "maintenance_nature": "Analog/Digital Channel Validation, Fault Logic Simulation & Network Clock Synchronization",
        "requires_traffic_block": False,
        "requires_power_block": False,
        "fouling_mark_infringed": False,
        "crank_handle_locked": False,
        "alternate_movement": "Passive monitoring equipment; zero train traffic disturbance",
        "duration_range": (45, 75),
        "cost_base": 7500,
        "priority_bias": "LOW",
        "failure_type": "Channel Optocoupler Glitch",
        "season_affinity": ["all"],
    },
]


# ==============================================================================
# 3. DOMAIN SYNTHESIS LOGIC (SECTIONS 11, 12, 13, 14, 15)
# ==============================================================================

OFFICER_DESIGNATIONS = [
    "SSE_SIGNAL",
    "SSE_TELECOM",
    "SSE_SIGNAL_TELECOM",
    "JE_SIGNAL",
    "JE_TELECOM",
    "ASTE",
    "ADSTE",
    "S&T Inspector",
]


def pick_season_dates() -> Tuple[date, str]:
    """
    Generates a future date strictly between 2026-09-15 and 2027-03-15 (181 days span).
    Distributes across all 6 months with realistic seasonal classification.
    """
    start_d = date(2026, 9, 15)
    end_d = date(2027, 3, 15)
    delta_days = (end_d - start_d).days

    # Realistic monthly weighting
    month_weights = [
        (0, 15, 0.12, "monsoon"),  # Late Sep
        (16, 46, 0.22, "autumn"),  # Oct (Post-monsoon water ingress / cable checks)
        (47, 76, 0.20, "winter_prep"),  # Nov (Preventive maintenance, relay room, batteries)
        (77, 107, 0.18, "winter"),  # Dec (Fog precautions, cold battery voltage)
        (108, 138, 0.16, "winter_severe"),  # Jan (Fog signalling, freezing point machines)
        (139, 181, 0.12, "spring_annual"),  # Feb-Mid Mar (Annual overhaul, renewals)
    ]

    selected_bucket = random.choices(month_weights, weights=[b[2] for b in month_weights], k=1)[0]
    day_offset = random.randint(selected_bucket[0], selected_bucket[1])
    d = start_d + timedelta(days=day_offset)
    return d, selected_bucket[3]


def generate_time_slot(duration_minutes: int) -> Tuple[time, time]:
    """
    Generates realistic maintenance time window between 08:00 and 22:00
    ensuring mathematical consistency: end_time - start_time = duration_minutes.
    """
    # Start hour between 08 and (21 - duration/60)
    max_start_hour = max(8, 21 - int(math.ceil(duration_minutes / 60.0)))
    start_hour = random.randint(8, max_start_hour)
    start_min = random.choice([0, 15, 30, 45])

    total_start_mins = start_hour * 60 + start_min
    total_end_mins = total_start_mins + duration_minutes

    end_hour = total_end_mins // 60
    end_min = total_end_mins % 60

    if end_hour >= 24:
        end_hour = 23
        end_min = 59

    return time(start_hour, start_min), time(end_hour, end_min)


def generate_officer(division_code: str, station_code: str) -> Dict[str, str]:
    """Generates synthetic railway personnel with masked contact and synthetic emp_id."""
    emp_id = str(random.randint(5000001, 5999999))
    prefix = random.choice(["97014", "98480", "97714", "98290", "94190", "99370"])
    contact = f"{prefix}XXXXX"
    clean_div = division_code.replace("-", "_").replace(" ", "_")
    desig = f"{random.choice(OFFICER_DESIGNATIONS)}_{clean_div}_{station_code}"
    return {"emp_id": emp_id, "designation": desig, "contact": contact}


def generate_smms_record(seq_id: int) -> Tuple[Tuple[Any, ...], Dict[str, Any]]:
    """
    Generates a single comprehensive synthetic SMMS record.
    Returns:
      (flat_tuple_for_sql_insert, rich_jsonb_payload)
    """
    # 1. Zone & Division Selection (weighted by prompt focus)
    zone_code = random.choices(
        list(RAILWAY_LOCATIONS.keys()),
        weights=[sum(d["weight"] for d in z["divisions"].values()) for z in RAILWAY_LOCATIONS.values()],
        k=1,
    )[0]
    zone_data = RAILWAY_LOCATIONS[zone_code]
    zone_name = zone_data["zone_name"]

    division_name = random.choices(
        list(zone_data["divisions"].keys()),
        weights=[d["weight"] for d in zone_data["divisions"].values()],
        k=1,
    )[0]
    div_info = zone_data["divisions"][division_name]
    division_code = div_info["div_code"]

    # 2. Station Selection from Division Master
    station_info = random.choice(div_info["stations"])
    station_code = station_info["code"]
    station_name = station_info["name"]

    # 3. Temporal Slot & Seasonality
    slot_date, season = pick_season_dates()

    # Filter/weight maintenance activity based on season
    filtered_catalog = []
    catalog_weights = []
    for act in MAINTENANCE_CATALOG:
        aff = act["season_affinity"]
        w = 1.0
        if "all" in aff:
            w = 1.0
        elif season == "monsoon" and "monsoon" in aff:
            w = 2.5
        elif "winter" in season and "winter" in aff:
            w = 2.2
        elif season == "spring_annual" and "spring" in aff:
            w = 2.0
        else:
            w = 0.5
        filtered_catalog.append(act)
        catalog_weights.append(w)

    activity = random.choices(filtered_catalog, weights=catalog_weights, k=1)[0]

    # 4. Duration & Time Window
    dur_range = activity["duration_range"]
    duration_minutes = random.randint(dur_range[0], dur_range[1])
    duration_minutes = int(round(duration_minutes / 15.0) * 15)  # align to 15 mins
    start_time, end_time = generate_time_slot(duration_minutes)

    # 5. Gear ID & Affected Equipment
    gear_type = activity["gear_type"]
    gear_num = random.randint(101, 480)
    sub_letter = random.choice(["A", "B", "C", "D"])
    gear_id = activity["gear_id_template"].format(num=gear_num, sub=sub_letter)

    # Signals affected
    sig_count = random.randint(1, 3)
    signals_affected = [f"S-{random.randint(1, 42)}" for _ in range(sig_count)]
    interlocking_affected = random.choice([
        f"Up Main to Down Loop route at {station_name}",
        f"Down Main straight corridor signals S-2/S-4 at {station_name}",
        f"Yard Reception Siding and Shunting Neck No. 3",
        f"Block Overlap detection circuit for {station_name} yard",
        f"Interlocking panel / Central VDU routing for {station_name}",
        f"Level Crossing Gate interlocked with Home Signal",
    ])

    # 6. Physical & Predictive Condition Telemetry (ML Features)
    asset_age_years = round(random.uniform(1.0, 18.0), 1)
    condition_score = round(max(25.0, min(98.0, 100.0 - (asset_age_years * 3.2) + random.uniform(-10.0, 8.0))), 1)

    # Environmental factors
    if season in ["monsoon", "autumn"]:
        rainfall_mm = round(random.uniform(40.0, 210.0), 1)
        temp_c = round(random.uniform(25.0, 32.0), 1)
        humidity = round(random.uniform(75.0, 95.0), 1)
        insulation_res = round(max(0.2, random.uniform(0.5, 8.0)), 2)
    elif "winter" in season:
        rainfall_mm = round(random.uniform(0.0, 15.0), 1)
        temp_c = round(random.uniform(4.0, 18.0), 1)
        humidity = round(random.uniform(60.0, 90.0), 1)
        insulation_res = round(random.uniform(5.0, 50.0), 2)
    else:
        rainfall_mm = round(random.uniform(0.0, 20.0), 1)
        temp_c = round(random.uniform(22.0, 35.0), 1)
        humidity = round(random.uniform(40.0, 70.0), 1)
        insulation_res = round(random.uniform(10.0, 80.0), 2)

    battery_v = round(random.uniform(104.0, 122.0) if "IPS" in gear_type or "BAT" in gear_type else random.uniform(22.5, 27.5), 1)
    op_count = int(asset_age_years * random.randint(3500, 9500)) if "Point" in gear_type else random.randint(120, 2400)
    cable_faults = random.randint(0, 4) if insulation_res < 2.0 else random.randint(0, 1)

    # Failure probability & Risk score
    risk_raw = (100.0 - condition_score) * 0.75 + (asset_age_years * 1.5) + (cable_faults * 4.0)
    if rainfall_mm > 100:
        risk_raw += 6.5
    if temp_c < 8.0 and "Battery" in gear_type:
        risk_raw += 8.0
    risk_score = round(max(10.0, min(96.0, risk_raw + random.uniform(-4.0, 4.0))), 1)

    # Sigmoid calibrated probability
    fail_prob = round(1.0 / (1.0 + math.exp(-(risk_score - 52.0) / 11.0)), 3)

    # 7. Priority Distribution (Strictly controlled: LOW 20%, MEDIUM 40%, HIGH 30%, CRITICAL 10%)
    prio_rand = random.random()
    if prio_rand < 0.20:
        priority = "LOW"
    elif prio_rand < 0.60:
        priority = "MEDIUM"
    elif prio_rand < 0.90:
        priority = "HIGH"
    else:
        priority = "CRITICAL"

    condition_status = (
        "Degraded" if priority in ["HIGH", "CRITICAL"] else ("Fair" if priority == "MEDIUM" else "Good")
    )
    failure_occurred = priority == "CRITICAL" or (priority == "HIGH" and random.random() < 0.35)

    # 8. Cost Generation (Correlated with category, duration, and criticality)
    cost_base = activity["cost_base"]
    dur_factor = duration_minutes / 90.0
    prio_factor = {"LOW": 0.85, "MEDIUM": 1.0, "HIGH": 1.35, "CRITICAL": 1.8}[priority]
    estimated_cost = int(round(cost_base * dur_factor * prio_factor * random.uniform(0.90, 1.15)))

    # 9. Personnel Data
    officer = generate_officer(division_code, station_code)

    # 10. Unique Disconnection Reference ID
    year_str = str(slot_date.year)
    clean_div_tag = division_code.replace("-", "_").split("_")[-1]
    ref_id = f"SMMS/{clean_div_tag}/{year_str}/DISC/{seq_id:05d}"

    # 11. Structured Asset ID
    prefix = activity["asset_code_prefix"]
    asset_id_str = f"{prefix}-{zone_code}-{clean_div_tag}-{station_code}-{gear_num:03d}"

    # 12. Rich JSONB Payload (Schema Section 4)
    payload = {
        "source_system": "SMMS_SIGNAL_TELECOM",
        "disconnection_ref_id": ref_id,
        "form_type": "S&T(T/D) 351 (Electronic)",
        "officer_in_charge": officer,
        "asset_location": {
            "zone": zone_name,
            "zone_code": zone_code,
            "division": division_name,
            "division_code": division_code,
            "station_code": station_code,
            "station_name": station_name,
            "affected_gear": {
                "gear_type": gear_type,
                "gear_id": gear_id,
                "structured_asset_id": asset_id_str,
                "signals_affected": signals_affected,
                "interlocking_affected": interlocking_affected,
            },
        },
        "disconnection_specifications": {
            "maintenance_nature": activity["maintenance_nature"],
            "maintenance_category": activity["category"],
            "requires_traffic_block": activity["requires_traffic_block"],
            "requires_power_block": activity["requires_power_block"],
            "fouling_mark_infringed": activity["fouling_mark_infringed"],
            "requested_slot": {
                "date": slot_date.isoformat(),
                "start_time": start_time.strftime("%H:%M"),
                "end_time": end_time.strftime("%H:%M"),
                "duration_minutes": duration_minutes,
            },
        },
        "safety_protocols": {
            "crank_handle_locked": activity["crank_handle_locked"],
            "alternate_movement_possible": activity["alternate_movement"],
            "signal_aspect_protection": True,
            "route_release_verified": True,
            "line_clear_confirmed": True,
            "electrical_isolation_verified": activity["requires_power_block"],
            "staff_protection_confirmed": True,
            "emergency_restoration_plan_available": True,
        },
        "maintenance_metadata": {
            "priority": priority,
            "condition_status": condition_status,
            "failure_probability": fail_prob,
            "estimated_cost_inr": estimated_cost,
            "planned_by": "SSE_SIGNAL_TELECOM",
            "work_status": "Planned",
            "estimated_downtime_minutes": duration_minutes,
        },
        "predictive_condition": {
            "asset_age_years": asset_age_years,
            "condition_score": condition_score,
            "risk_score": risk_score,
            "battery_voltage": battery_v,
            "insulation_resistance_mohm": insulation_res,
            "operation_count": op_count,
            "cable_fault_count": cable_faults,
            "rainfall_mm": rainfall_mm,
            "temperature_celsius": temp_c,
            "humidity_percent": humidity,
            "failure_occurred": failure_occurred,
            "failure_type": activity["failure_type"],
            "season": season,
        },
    }

    # Flat SQL Tuple matching smms_signal_disconnections:
    # disconnection_ref_id, source_system, form_type, division, station_code, station_name,
    # gear_type, gear_id, maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    # slot_date, start_time, end_time, duration_minutes, crank_handle_locked, payload
    record_tuple = (
        ref_id,
        "SMMS_SIGNAL_TELECOM",
        "S&T(T/D) 351 (Electronic)",
        division_name,
        station_code,
        station_name,
        gear_type,
        gear_id,
        activity["maintenance_nature"],
        activity["requires_traffic_block"],
        activity["fouling_mark_infringed"],
        slot_date,
        start_time,
        end_time,
        duration_minutes,
        activity["crank_handle_locked"],
        payload,  # Psycopg2 serializes dict to JSONB automatically
    )

    return record_tuple, payload


def generate_smms_dataset(target_count: int = 2600, existing_ids: set = None) -> Tuple[List[Tuple], List[Dict]]:
    """Generates a batch of distinct, unique SMMS records."""
    if existing_ids is None:
        existing_ids = set()

    tuples_list = []
    payloads_list = []
    seq = 1

    while len(tuples_list) < target_count:
        rec_tuple, rec_payload = generate_smms_record(seq)
        ref_id = rec_tuple[0]

        if ref_id not in existing_ids:
            existing_ids.add(ref_id)
            tuples_list.append(rec_tuple)
            payloads_list.append(rec_payload)
            seq += 1

    return tuples_list, payloads_list
