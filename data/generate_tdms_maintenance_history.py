"""
Script to generate realistic Indian Railways TDMS (Traction Distribution Management System - Electrical TRD)
Maintenance History data for:
- Eastern Railway (Asansol Division - 6 sections)
- Eastern Railway (Howrah Division - 8 sections)
- Northern Railway (Ambala Division - 15 sections)

Adheres strictly to official Indian Railways Electrical Traction (TRD/TDMS) engineering standards,
equipment naming, and SIH schema requirements.
"""

import json
import random
from datetime import datetime, timedelta

# =========================================================================
# CONFIGURATION: SECTIONS AND BLOCK SECTIONS
# =========================================================================

SECTIONS_CONFIG = [
    # =========================================================================
    # EASTERN RAILWAY (ER) - ASANSOL DIVISION (ASN)
    # =========================================================================
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "UDL-SNT",
        "section_display": "Andal-Sainthia",
        "block_sections": [
            {"code": "UDL-UKA", "name": "Andal - Ukhra"},
            {"code": "UKA-PAW", "name": "Ukhra - Pandabeswar"},
            {"code": "PAW-DUJ", "name": "Pandabeswar - Dubrajpur"},
            {"code": "DUJ-SURI", "name": "Dubrajpur - Siuri"},
            {"code": "SURI-SNT", "name": "Siuri - Sainthia"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN", "SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "UDL-TOP-BBI-STN",
        "section_display": "Andal–Tapasi–Barabani–Sitarampur",
        "block_sections": [
            {"code": "UDL-TOP", "name": "Andal - Tapasi"},
            {"code": "TOP-IKRA", "name": "Tapasi - Ikrah"},
            {"code": "IKRA-BBI", "name": "Ikrah - Barabani"},
            {"code": "BBI-STN", "name": "Barabani - Sitarampur"}
        ],
        "lines": ["SINGLE_LINE", "GOODS_CHORD"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "MDP-GRD",
        "section_display": "Madhupur–Giridih",
        "block_sections": [
            {"code": "MDP-JGD", "name": "Madhupur - Jagdishpur"},
            {"code": "JGD-MMD", "name": "Jagdishpur - Maheshmunda"},
            {"code": "MMD-GRD", "name": "Maheshmunda - Giridih"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "JSME-BDME",
        "section_display": "Jasidih–Baidyanathdham",
        "block_sections": [
            {"code": "JSME-DGHR", "name": "Jasidih - Deoghar"},
            {"code": "DGHR-BDME", "name": "Deoghar - Baidyanathdham"}
        ],
        "lines": ["BRANCH_SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "JSME-DUMK",
        "section_display": "Jasidih to Dumka",
        "block_sections": [
            {"code": "JSME-DGHR", "name": "Jasidih - Deoghar"},
            {"code": "DGHR-CNPR", "name": "Deoghar - Chandanpahari"},
            {"code": "CNPR-BSKH", "name": "Chandanpahari - Basukinath"},
            {"code": "BSKH-DUMK", "name": "Basukinath - Dumka"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "ASN",
        "division_name": "Asansol",
        "section": "DGHR-BAKA",
        "section_display": "Deoghar to Banka",
        "block_sections": [
            {"code": "DGHR-KKRA", "name": "Deoghar - Kakwara"},
            {"code": "KKRA-BAKA", "name": "Kakwara - Banka"}
        ],
        "lines": ["SINGLE_LINE"]
    },

    # =========================================================================
    # EASTERN RAILWAY (ER) - HOWRAH DIVISION (HWH)
    # =========================================================================
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "HWH-KAN (Main line)",
        "section_display": "Howrah – Khana (Main line)",
        "block_sections": [
            {"code": "HWH-BLY", "name": "Howrah - Bally"},
            {"code": "BLY-BDC", "name": "Bally - Bandel"},
            {"code": "BDC-BWN", "name": "Bandel - Barddhaman"},
            {"code": "BWN-KAN", "name": "Barddhaman - Khana"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN", "3RD_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "HWH-KAN (Chord line)",
        "section_display": "Howrah – Khana (Chord line)",
        "block_sections": [
            {"code": "HWH-DKAE", "name": "Howrah - Dankuni"},
            {"code": "DKAE-KQU", "name": "Dankuni - Kamarkundu"},
            {"code": "KQU-GRAE", "name": "Kamarkundu - Gurap"},
            {"code": "GRAE-MSAE", "name": "Gurap - Masagram"},
            {"code": "MSAE-SKG", "name": "Masagram - Saktigarh"},
            {"code": "SKG-KAN", "name": "Saktigarh - Khana"}
        ],
        "lines": ["UP_CHORD", "DN_CHORD"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "KAN-GMAN",
        "section_display": "Khana – Gumani",
        "block_sections": [
            {"code": "KAN-BHP", "name": "Khana - Bolpur Shantiniketan"},
            {"code": "BHP-SNT", "name": "Bolpur - Sainthia"},
            {"code": "SNT-RPH", "name": "Sainthia - Rampurhat"},
            {"code": "RPH-NHT", "name": "Rampurhat - Nalhati"},
            {"code": "NHT-PKR", "name": "Nalhati - Pakur"},
            {"code": "PKR-GMAN", "name": "Pakur - Gumani"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "RPH-DUMK",
        "section_display": "Rampurhat – Dumka",
        "block_sections": [
            {"code": "RPH-PRGR", "name": "Rampurhat - Pinargaria"},
            {"code": "PRGR-SKIP", "name": "Pinargaria - Shikaripara"},
            {"code": "SKIP-DUMK", "name": "Shikaripara - Dumka"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "BDC-AZ",
        "section_display": "Bandel – Azimganj",
        "block_sections": [
            {"code": "BDC-ABKA", "name": "Bandel - Ambika Kalna"},
            {"code": "ABKA-NDAE", "name": "Ambika Kalna - Nabadwip Dham"},
            {"code": "NDAE-KWAE", "name": "Nabadwip Dham - Katwa"},
            {"code": "KWAE-SALE", "name": "Katwa - Salar"},
            {"code": "SALE-AZ", "name": "Salar - Azimganj"}
        ],
        "lines": ["UP_LOOP", "DN_LOOP", "SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "DKAE-BTNG-RCD",
        "section_display": "Dankuni – Bhattanagar & Dankuni – Rajchandrapur",
        "block_sections": [
            {"code": "DKAE-BTNG", "name": "Dankuni - Bhattanagar"},
            {"code": "DKAE-RCD", "name": "Dankuni - Rajchandrapur"}
        ],
        "lines": ["FREIGHT_BYPASS_UP", "FREIGHT_BYPASS_DN"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "SHE-TAK-GOGT",
        "section_display": "Sheoraphuli – Tarakeswar – Goghat",
        "block_sections": [
            {"code": "SHE-DEA", "name": "Sheoraphuli - Diara"},
            {"code": "DEA-HPL", "name": "Diara - Haripal"},
            {"code": "HPL-TAK", "name": "Haripal - Tarakeswar"},
            {"code": "TAK-AMBG", "name": "Tarakeswar - Arambagh"},
            {"code": "AMBG-GOGT", "name": "Arambagh - Goghat"}
        ],
        "lines": ["SUBURBAN_UP", "SUBURBAN_DN", "BRANCH_SINGLE_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "BDC-HYG",
        "section_display": "Bandel – Hooghly Ghat",
        "block_sections": [
            {"code": "BDC-HYG", "name": "Bandel - Hooghly Ghat"}
        ],
        "lines": ["BRIDGE_UP_LINE", "BRIDGE_DN_LINE"]
    },
    {
        "zone": "EASTERN RAILWAY",
        "zone_code": "ER",
        "division": "HWH",
        "division_name": "Howrah",
        "section": "AZ-NHT",
        "section_display": "Azimganj – Nalhati",
        "block_sections": [
            {"code": "AZ-SDI", "name": "Azimganj - Sagardighi"},
            {"code": "SDI-MGAE", "name": "Sagardighi - Morgram"},
            {"code": "MGAE-NHT", "name": "Morgram - Nalhati"}
        ],
        "lines": ["SINGLE_LINE"]
    },

    # =========================================================================
    # NORTHERN RAILWAY (NR) - AMBALA DIVISION (UMB)
    # =========================================================================
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "UMB-LDH",
        "section_display": "UMB–LDH (Ambala Cantt–Ludhiana)",
        "block_sections": [
            {"code": "UMB-RPJ", "name": "Ambala Cantt - Rajpura"},
            {"code": "RPJ-SIR", "name": "Rajpura - Sirhind"},
            {"code": "SIR-KNN", "name": "Sirhind - Khanna"},
            {"code": "KNN-DOA", "name": "Khanna - Doraha"},
            {"code": "DOA-LDH", "name": "Doraha - Ludhiana"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "LDH-BTI",
        "section_display": "LDH–BTI (Ludhiana–Bathinda)",
        "block_sections": [
            {"code": "LDH-MLX", "name": "Ludhiana - Mullanpur"},
            {"code": "MLX-JGN", "name": "Mullanpur - Jagraon"},
            {"code": "JGN-MOG", "name": "Jagraon - Moga"},
            {"code": "MOG-KKP", "name": "Moga - Kotkapura"},
            {"code": "KKP-BTI", "name": "Kotkapura - Bathinda"}
        ],
        "lines": ["SINGLE_LINE", "UP_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "UMB-CDG-KLK",
        "section_display": "UMB–CDG–KLK (Ambala–Chandigarh–Kalka)",
        "block_sections": [
            {"code": "UMB-LLU", "name": "Ambala Cantt - Lalru"},
            {"code": "LLU-CDG", "name": "Lalru - Chandigarh"},
            {"code": "CDG-CNDM", "name": "Chandigarh - Chandi Mandir"},
            {"code": "CNDM-KLK", "name": "Chandi Mandir - Kalka"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "KLK-SML",
        "section_display": "KLK–SML (Kalka–Shimla)",
        "block_sections": [
            {"code": "KLK-DMP", "name": "Kalka - Dharampur Himachal"},
            {"code": "DMP-BOF", "name": "Dharampur - Barog"},
            {"code": "BOF-SOL", "name": "Barog - Solan"},
            {"code": "SOL-KDGF", "name": "Solan - Kandaghat"},
            {"code": "KDGF-SML", "name": "Kandaghat - Shimla"}
        ],
        "lines": ["HILL_TRANSMISSION_LINE", "POWER_SUPPLY_LINE", "YARD_ELECTRICAL_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "UMB-SRE",
        "section_display": "UMB–SRE (Ambala–Saharanpur)",
        "block_sections": [
            {"code": "UMB-RAA", "name": "Ambala Cantt - Barara"},
            {"code": "RAA-YJUD", "name": "Barara - Yamunanagar Jagadhri"},
            {"code": "YJUD-SSW", "name": "Yamunanagar - Sarsawa"},
            {"code": "SSW-SRE", "name": "Sarsawa - Saharanpur"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "UMB-JUDW",
        "section_display": "UMB–JUDW (Ambala–Jagadhri/Yamunanagar)",
        "block_sections": [
            {"code": "UMB-KES", "name": "Ambala Cantt - Kesri"},
            {"code": "KES-MFB", "name": "Kesri - Mustafabad"},
            {"code": "MFB-JUDW", "name": "Mustafabad - Jagadhri Workshop"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "UMB-KKDE",
        "section_display": "UMB–KKDE (Ambala–Kurukshetra)",
        "block_sections": [
            {"code": "UMB-MOY", "name": "Ambala Cantt - Mohri"},
            {"code": "MOY-SHDM", "name": "Mohri - Shahbad Markanda"},
            {"code": "SHDM-KKDE", "name": "Shahbad Markanda - Kurukshetra"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "RPJ-BTI",
        "section_display": "RPJ–BTI (Rajpura–Bathinda)",
        "block_sections": [
            {"code": "RPJ-PTA", "name": "Rajpura - Patiala"},
            {"code": "PTA-NBA", "name": "Patiala - Nabha"},
            {"code": "NBA-DUI", "name": "Nabha - Dhuri"},
            {"code": "DUI-BNN", "name": "Dhuri - Barnala"},
            {"code": "BNN-PUL", "name": "Barnala - Rampura Phul"},
            {"code": "PUL-BTI", "name": "Rampura Phul - Bathinda"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "RPJ-DUI",
        "section_display": "RPJ–DUI (Rajpura–Dhuri)",
        "block_sections": [
            {"code": "RPJ-KLI", "name": "Rajpura - Kauli"},
            {"code": "KLI-PTA", "name": "Kauli - Patiala"},
            {"code": "PTA-CJL", "name": "Patiala - Chhajli"},
            {"code": "CJL-DUI", "name": "Chhajli - Dhuri"}
        ],
        "lines": ["UP_LINE", "DN_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "DUI-LDH",
        "section_display": "DUI–LDH (Dhuri–Ludhiana)",
        "block_sections": [
            {"code": "DUI-MET", "name": "Dhuri - Malerkotla"},
            {"code": "MET-AHH", "name": "Malerkotla - Ahmedgarh"},
            {"code": "AHH-QRP", "name": "Ahmedgarh - Qila Raipur"},
            {"code": "QRP-LDH", "name": "Qila Raipur - Ludhiana"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "SIR-NLDM",
        "section_display": "SIR–NLDM (Sirhind–Nangal Dam)",
        "block_sections": [
            {"code": "SIR-MRND", "name": "Sirhind - Morinda"},
            {"code": "MRND-RPAR", "name": "Morinda - Rupnagar"},
            {"code": "RPAR-KART", "name": "Rupnagar - Kiratpur Sahib"},
            {"code": "KART-ANSB", "name": "Kiratpur Sahib - Anandpur Sahib"},
            {"code": "ANSB-NLDM", "name": "Anandpur Sahib - Nangal Dam"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "SIR-AADR",
        "section_display": "SIR–AADR (Sirhind–Amb Andaura)",
        "block_sections": [
            {"code": "NLDM-MTPR", "name": "Nangal Dam - Mehatpur"},
            {"code": "MTPR-UHL", "name": "Mehatpur - Una Himachal"},
            {"code": "UHL-CHTL", "name": "Una Himachal - Churaru Takrala"},
            {"code": "CHTL-AADR", "name": "Churaru Takrala - Amb Andaura"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "PTA-DUI",
        "section_display": "PTA–DUI (Patiala–Dhuri)",
        "block_sections": [
            {"code": "PTA-DBN", "name": "Patiala - Dhablan"},
            {"code": "DBN-NBA", "name": "Dhablan - Nabha"},
            {"code": "NBA-SEQ", "name": "Nabha - Sekha"},
            {"code": "SEQ-DUI", "name": "Sekha - Dhuri"}
        ],
        "lines": ["UP_MAIN", "DN_MAIN"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "BTI-ABS",
        "section_display": "BTI–Abohar side (Bathinda–Abohar)",
        "block_sections": [
            {"code": "BTI-BHX", "name": "Bathinda - Balluana"},
            {"code": "BHX-GDB", "name": "Balluana - Giddarbaha"},
            {"code": "GDB-MOT", "name": "Giddarbaha - Malout"},
            {"code": "MOT-ABS", "name": "Malout - Abohar"}
        ],
        "lines": ["SINGLE_LINE"]
    },
    {
        "zone": "NORTHERN RAILWAY",
        "zone_code": "NR",
        "division": "UMB",
        "division_name": "Ambala",
        "section": "SRE-KJGY-DBD",
        "section_display": "SRE–UDN / connecting routes (Saharanpur area)",
        "block_sections": [
            {"code": "SRE-KJGY", "name": "Saharanpur - Khanalampura Yard"},
            {"code": "KJGY-BAE", "name": "Khanalampura Yard - Baliakheri"},
            {"code": "BAE-DBD", "name": "Baliakheri - Deoband"}
        ],
        "lines": ["FREIGHT_UP", "FREIGHT_DN", "YARD_LINE"]
    }
]

# =========================================================================
# REALISTIC INDIAN RAILWAYS ELECTRICAL TRD / TDMS WORK CATALOG
# =========================================================================

TDMS_WORK_CATALOG = [
    # 1. OHE Line Equipment
    {
        "work_type": "OHE Wire Replacement",
        "asset_type": "OHE",
        "equipment": "Tower Wagon",
        "severity_weights": [("High", 0.6), ("Critical", 0.3), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.6), ("High", 0.35), ("Medium", 0.05)],
        "base_duration": 120,
        "crew_min": 7,
        "crew_max": 10
    },
    {
        "work_type": "Dropper Renewal",
        "asset_type": "OHE",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "criticality_weights": [("High", 0.55), ("Critical", 0.3), ("Medium", 0.15)],
        "base_duration": 90,
        "crew_min": 5,
        "crew_max": 7
    },
    {
        "work_type": "Catenary Maintenance",
        "asset_type": "OHE",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Critical", 0.1)],
        "criticality_weights": [("High", 0.5), ("Critical", 0.4), ("Medium", 0.1)],
        "base_duration": 150,
        "crew_min": 6,
        "crew_max": 8
    },
    {
        "work_type": "Contact Wire Height & Stagger Adjustment",
        "asset_type": "OHE",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.6), ("High", 0.3), ("Low", 0.1)],
        "criticality_weights": [("High", 0.55), ("Medium", 0.35), ("Critical", 0.1)],
        "base_duration": 105,
        "crew_min": 5,
        "crew_max": 7
    },
    {
        "work_type": "Section Insulator Inspection",
        "asset_type": "OHE",
        "equipment": "Inspection Vehicle",
        "severity_weights": [("Low", 0.5), ("Medium", 0.4), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "base_duration": 60,
        "crew_min": 4,
        "crew_max": 5
    },
    {
        "work_type": "Section Insulator Overhauling & Replacement",
        "asset_type": "Section Insulator",
        "equipment": "Tower Wagon",
        "severity_weights": [("High", 0.5), ("Critical", 0.3), ("Medium", 0.2)],
        "criticality_weights": [("Critical", 0.55), ("High", 0.35), ("Medium", 0.1)],
        "base_duration": 90,
        "crew_min": 5,
        "crew_max": 7
    },
    {
        "work_type": "Cantilever Assembly Overhaul & Adjustment",
        "asset_type": "Cantilever",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "criticality_weights": [("High", 0.6), ("Critical", 0.25), ("Medium", 0.15)],
        "base_duration": 105,
        "crew_min": 5,
        "crew_max": 7
    },
    {
        "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration",
        "asset_type": "ATD",
        "equipment": "Ladder & Tension Meter",
        "severity_weights": [("Medium", 0.5), ("High", 0.35), ("Critical", 0.15)],
        "criticality_weights": [("High", 0.55), ("Critical", 0.35), ("Medium", 0.1)],
        "base_duration": 75,
        "crew_min": 4,
        "crew_max": 6
    },
    {
        "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check",
        "asset_type": "Neutral Section",
        "equipment": "Tower Wagon",
        "severity_weights": [("High", 0.5), ("Critical", 0.4), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.7), ("High", 0.25), ("Medium", 0.05)],
        "base_duration": 120,
        "crew_min": 6,
        "crew_max": 8
    },
    {
        "work_type": "OHE Foot Patrol & Current Collection Test",
        "asset_type": "OHE",
        "equipment": "Inspection Vehicle",
        "severity_weights": [("Low", 0.6), ("Medium", 0.3), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.6), ("Low", 0.2), ("High", 0.2)],
        "base_duration": 60,
        "crew_min": 3,
        "crew_max": 5
    },
    {
        "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement",
        "asset_type": "OHE",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "criticality_weights": [("High", 0.5), ("Medium", 0.4), ("Critical", 0.1)],
        "base_duration": 75,
        "crew_min": 4,
        "crew_max": 6
    },
    {
        "work_type": "Structure Bonding & Earth Continuity Testing",
        "asset_type": "Earthing System",
        "equipment": "Earth Tester & Bonding Kit",
        "severity_weights": [("Low", 0.5), ("Medium", 0.4), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "base_duration": 60,
        "crew_min": 3,
        "crew_max": 5
    },

    # 2. Insulator Maintenance
    {
        "work_type": "Insulator Replacement",
        "asset_type": "Insulator",
        "equipment": "Tower Wagon",
        "severity_weights": [("High", 0.6), ("Critical", 0.3), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.6), ("High", 0.35), ("Medium", 0.05)],
        "base_duration": 120,
        "crew_min": 5,
        "crew_max": 7
    },
    {
        "work_type": "Stay & Bracket Insulator Replacement",
        "asset_type": "Insulator",
        "equipment": "Tower Wagon",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Critical", 0.1)],
        "criticality_weights": [("High", 0.6), ("Critical", 0.3), ("Medium", 0.1)],
        "base_duration": 90,
        "crew_min": 4,
        "crew_max": 6
    },
    {
        "work_type": "Composite Silicon Rubber Insulator Inspection",
        "asset_type": "Insulator",
        "equipment": "Inspection Vehicle",
        "severity_weights": [("Low", 0.5), ("Medium", 0.4), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.6), ("High", 0.3), ("Low", 0.1)],
        "base_duration": 60,
        "crew_min": 3,
        "crew_max": 4
    },

    # 3. Switching, Isolators & Interrupters
    {
        "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment",
        "asset_type": "Isolator",
        "equipment": "Ladder & Contact Burnisher",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Low", 0.1)],
        "criticality_weights": [("High", 0.55), ("Medium", 0.35), ("Critical", 0.1)],
        "base_duration": 75,
        "crew_min": 4,
        "crew_max": 5
    },
    {
        "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check",
        "asset_type": "Switchgear",
        "equipment": "SF6 Gas Filling Kit",
        "severity_weights": [("High", 0.5), ("Critical", 0.35), ("Medium", 0.15)],
        "criticality_weights": [("Critical", 0.6), ("High", 0.35), ("Medium", 0.05)],
        "base_duration": 105,
        "crew_min": 4,
        "crew_max": 6
    },

    # 4. Power Supply Installation (PSI / TSS / SP / SSP)
    {
        "work_type": "Traction Transformer Oil Filtration & DGA",
        "asset_type": "Traction Transformer",
        "equipment": "Oil Filtration Plant",
        "severity_weights": [("High", 0.5), ("Critical", 0.4), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.7), ("High", 0.25), ("Medium", 0.05)],
        "base_duration": 180,
        "crew_min": 6,
        "crew_max": 8
    },
    {
        "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul",
        "asset_type": "Circuit Breaker",
        "equipment": "CB Timing Analyzer",
        "severity_weights": [("High", 0.5), ("Critical", 0.4), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.65), ("High", 0.3), ("Medium", 0.05)],
        "base_duration": 135,
        "crew_min": 4,
        "crew_max": 6
    },
    {
        "work_type": "Protection Relay Calibration & Tripping Scheme Verification",
        "asset_type": "Protection Relay",
        "equipment": "Secondary Injection Test Set",
        "severity_weights": [("Medium", 0.5), ("High", 0.4), ("Critical", 0.1)],
        "criticality_weights": [("High", 0.6), ("Critical", 0.3), ("Medium", 0.1)],
        "base_duration": 90,
        "crew_min": 3,
        "crew_max": 4
    },
    {
        "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics",
        "asset_type": "SCADA",
        "equipment": "RTU Diagnostic Terminal",
        "severity_weights": [("Medium", 0.5), ("Low", 0.3), ("High", 0.2)],
        "criticality_weights": [("High", 0.5), ("Medium", 0.4), ("Critical", 0.1)],
        "base_duration": 75,
        "crew_min": 3,
        "crew_max": 4
    }
]

def pick_weighted(options):
    items, weights = zip(*options)
    return random.choices(items, weights=weights, k=1)[0]

def generate_tdms_data():
    random.seed(108)  # Deterministic seed for reproducible railway data
    start_history_date = datetime(2026, 7, 1, 0, 0, 0)
    end_history_date = datetime(2026, 9, 8, 23, 59, 59)
    total_seconds = int((end_history_date - start_history_date).total_seconds())

    records = []
    job_counter = 1
    target_records = 2500
    base_records, remainder = divmod(target_records, len(SECTIONS_CONFIG))

    # Typical Indian Railways TRD traffic & power block windows:
    # Day maintenance block: 11:00 to 14:30
    # Night shadow block: 00:30 to 04:30
    # Afternoon / early evening: 15:00 to 17:30
    typical_windows = [
        (0, 4),    # Night window 00:00 to 04:59
        (11, 14),  # Midday traffic block 11:00 to 14:59
        (15, 17)   # Afternoon window 15:00 to 17:59
    ]

    for section_index, sec in enumerate(SECTIONS_CONFIG):
        div = sec["division"]
        sec_code = sec["section"]
        bsecs = sec["block_sections"]
        lines = sec["lines"]

        # Distribute the target evenly so every configured section is represented.
        num_records_for_section = base_records + (1 if section_index < remainder else 0)

        # Generate timestamps evenly distributed across date range
        timestamps = []
        for _ in range(num_records_for_section):
            rand_sec = random.randint(0, total_seconds)
            d = start_history_date + timedelta(seconds=rand_sec)
            win = random.choice(typical_windows)
            h = random.randint(win[0], win[1])
            m = random.choice([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55])
            s = 0
            timestamps.append(d.replace(hour=h, minute=m, second=s))

        timestamps.sort()

        for ts in timestamps:
            bsec = random.choice(bsecs)
            line = random.choice(lines)
            act = random.choice(TDMS_WORK_CATALOG)

            job_id = f"TDMS-H{job_counter:04d}"
            job_counter += 1

            sev = pick_weighted(act["severity_weights"])
            crit = pick_weighted(act["criticality_weights"])

            # Overdue days logic:
            if crit == "Critical" or sev == "Critical":
                overdue_days = random.choices([0, 1, 2, 3, 4, 5, 6, 7, 8], weights=[0.15, 0.2, 0.2, 0.15, 0.12, 0.08, 0.05, 0.03, 0.02])[0]
            elif crit == "High":
                overdue_days = random.choices([0, 1, 2, 3, 4], weights=[0.35, 0.3, 0.2, 0.1, 0.05])[0]
            else:
                overdue_days = random.choices([0, 1, 2], weights=[0.6, 0.3, 0.1])[0]

            crew = random.randint(act["crew_min"], act["crew_max"])
            base_dur = act["base_duration"]
            req_duration = random.choice([base_dur - 15, base_dur, base_dur + 15, base_dur + 30])
            if req_duration < 45:
                req_duration = 45

            # Actual duration variance: -10 to +22 minutes around requested
            dur_variance = random.randint(-10, 22)
            actual_duration = max(40, req_duration + dur_variance)

            actual_start_dt = ts
            actual_end_dt = actual_start_dt + timedelta(minutes=actual_duration)

            record = {
                "job_id": job_id,
                "division": div,
                "section": sec_code,
                "block_section": bsec["code"],
                "line": line,
                "work_type": act["work_type"],
                "asset_type": act["asset_type"],
                "severity": sev,
                "criticality": crit,
                "overdue_days": overdue_days,
                "crew_size": crew,
                "equipment": act["equipment"],
                "requested_duration_min": req_duration,
                "actual_duration_min": actual_duration,
                "actual_start": actual_start_dt.strftime("%Y-%m-%dT%H:%M:%S"),
                "actual_end": actual_end_dt.strftime("%Y-%m-%dT%H:%M:%S"),
                "completion_status": "Completed"
            }
            records.append(record)

    output_doc = {
        "source_system": "TDMS_ELECTRICAL_TRD",
        "department": "TRD",
        "maintenance_history": records
    }

    output_path = "c:/IMBPS/tdms_maintenance_history.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(output_doc, f, indent=2)

    print(f"[OK] Generated {len(records)} realistic TDMS Electrical TRD maintenance history records.")
    print(f"[OK] Output saved to: {output_path}")

    # Print summary statistics
    division_counts = {}
    asset_counts = {}
    work_counts = {}
    for r in records:
        d = r["division"]
        division_counts[d] = division_counts.get(d, 0) + 1
        a = r["asset_type"]
        asset_counts[a] = asset_counts.get(a, 0) + 1
        w = r["work_type"]
        work_counts[w] = work_counts.get(w, 0) + 1

    print("\n--- Division Breakdown ---")
    for d, c in division_counts.items():
        print(f"  {d}: {c} records")

    print("\n--- Asset Type Breakdown ---")
    for a, c in sorted(asset_counts.items(), key=lambda x: x[1], reverse=True):
        print(f"  {a}: {c} records")

if __name__ == "__main__":
    generate_tdms_data()
