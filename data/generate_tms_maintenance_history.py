"""
Script to generate realistic Indian Railways TMS Maintenance History data
for Eastern Railway (Asansol and Howrah Divisions) and Northern Railway (Ambala Division),
adhering strictly to official railway engineering practices, codes, and the requested SIH schema.
"""

import json
import random
from datetime import datetime, timedelta

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
        "lines": ["NARROW_GAUGE_MAIN"]
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

# Real Indian Railways Civil Track Maintenance Activity Catalog
WORK_TYPES_CATALOG = [
    {
        "work_type": "Tamping",
        "asset_type": "Track",
        "equipment": "CSM",
        "severity_weights": [("High", 0.4), ("Medium", 0.4), ("Critical", 0.2)],
        "criticality_weights": [("Critical", 0.5), ("High", 0.35), ("Medium", 0.15)],
        "base_duration": 150,
        "crew_min": 7,
        "crew_max": 10
    },
    {
        "work_type": "Track Renewal",
        "asset_type": "Rail",
        "equipment": "Tamping Machine",
        "severity_weights": [("High", 0.5), ("Medium", 0.4), ("Critical", 0.1)],
        "criticality_weights": [("High", 0.5), ("Critical", 0.4), ("Medium", 0.1)],
        "base_duration": 240,
        "crew_min": 10,
        "crew_max": 16
    },
    {
        "work_type": "Ultrasonic Testing",
        "asset_type": "Rail",
        "equipment": "USFD Machine",
        "severity_weights": [("Low", 0.5), ("Medium", 0.4), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.5), ("Low", 0.3), ("High", 0.2)],
        "base_duration": 120,
        "crew_min": 4,
        "crew_max": 6
    },
    {
        "work_type": "Ballast Cleaning",
        "asset_type": "Track",
        "equipment": "BCM",
        "severity_weights": [("High", 0.4), ("Medium", 0.5), ("Critical", 0.1)],
        "criticality_weights": [("High", 0.6), ("Critical", 0.3), ("Medium", 0.1)],
        "base_duration": 210,
        "crew_min": 11,
        "crew_max": 15
    },
    {
        "work_type": "Rail Grinding",
        "asset_type": "Rail",
        "equipment": "Rail Grinder",
        "severity_weights": [("High", 0.5), ("Medium", 0.3), ("Critical", 0.2)],
        "criticality_weights": [("Critical", 0.6), ("High", 0.3), ("Medium", 0.1)],
        "base_duration": 180,
        "crew_min": 6,
        "crew_max": 9
    },
    {
        "work_type": "Points & Crossing Tamping",
        "asset_type": "Turnout",
        "equipment": "UNIMAT",
        "severity_weights": [("High", 0.45), ("Medium", 0.4), ("Critical", 0.15)],
        "criticality_weights": [("Critical", 0.55), ("High", 0.35), ("Medium", 0.1)],
        "base_duration": 180,
        "crew_min": 8,
        "crew_max": 12
    },
    {
        "work_type": "Turnout Renewal",
        "asset_type": "Turnout",
        "equipment": "T-28 Machine",
        "severity_weights": [("Critical", 0.4), ("High", 0.5), ("Medium", 0.1)],
        "criticality_weights": [("Critical", 0.7), ("High", 0.3)],
        "base_duration": 270,
        "crew_min": 12,
        "crew_max": 18
    },
    {
        "work_type": "Track Stabilization",
        "asset_type": "Track",
        "equipment": "DTS",
        "severity_weights": [("Medium", 0.6), ("Low", 0.3), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.6), ("High", 0.3), ("Low", 0.1)],
        "base_duration": 120,
        "crew_min": 5,
        "crew_max": 8
    },
    {
        "work_type": "Ballast Regulating",
        "asset_type": "Ballast",
        "equipment": "BRM",
        "severity_weights": [("Medium", 0.5), ("Low", 0.4), ("High", 0.1)],
        "criticality_weights": [("Medium", 0.6), ("Low", 0.3), ("High", 0.1)],
        "base_duration": 135,
        "crew_min": 6,
        "crew_max": 8
    },
    {
        "work_type": "De-stressing of LWR",
        "asset_type": "Rail",
        "equipment": "Hydraulic Rail Tensor",
        "severity_weights": [("High", 0.5), ("Critical", 0.3), ("Medium", 0.2)],
        "criticality_weights": [("Critical", 0.6), ("High", 0.3), ("Medium", 0.1)],
        "base_duration": 180,
        "crew_min": 10,
        "crew_max": 14
    }
]

def choose_weighted(weights_list):
    choices, weights = zip(*weights_list)
    return random.choices(choices, weights=weights, k=1)[0]

def generate_maintenance_history():
    random.seed(42)  # For reproducible, high-quality, realistic dataset
    history_records = []
    job_counter = 1

    # Date range: 2026-08-01 to 2026-09-08
    start_base_date = datetime(2026, 8, 1, 9, 0)
    
    # We will generate 8 to 10 maintenance history records per section
    # Ensuring rich coverage across all 30 requested sections
    for sec_idx, sec in enumerate(SECTIONS_CONFIG):
        # Determine number of records for this section based on importance/size
        num_records = 10 if len(sec["block_sections"]) >= 4 else 8

        for r_i in range(num_records):
            b_sec = sec["block_sections"][r_i % len(sec["block_sections"])]
            work_def = WORK_TYPES_CATALOG[(sec_idx * 3 + r_i) % len(WORK_TYPES_CATALOG)]
            line_chosen = sec["lines"][r_i % len(sec["lines"])]

            # Job ID format: TMS-H001, TMS-H002 ...
            job_id = f"TMS-H{job_counter:03d}"
            job_counter += 1

            # Realistic overdue days: 0 to 12 days
            # Critical / High items tend to have slight overdue days in Indian Railways traffic block requisition
            severity = choose_weighted(work_def["severity_weights"])
            criticality = choose_weighted(work_def["criticality_weights"])

            if criticality == "Critical":
                overdue_days = random.choice([4, 5, 7, 8, 10, 12])
            elif criticality == "High":
                overdue_days = random.choice([1, 2, 3, 4, 5, 6])
            else:
                overdue_days = random.choice([0, 0, 1, 2])

            crew_size = random.randint(work_def["crew_min"], work_def["crew_max"])
            equipment = work_def["equipment"]
            req_dur = work_def["base_duration"]

            # Actual duration: in real railway maintenance, actual can be slightly shorter (-15 min) or longer (+25 min)
            duration_delta = random.choice([-15, -10, -5, 0, 5, 10, 15, 18, 20, 25])
            actual_dur = max(60, req_dur + duration_delta)

            # Execution date distribution across Aug 01 to Sep 08
            day_offset = int((sec_idx * 1.2 + r_i * 3.5)) % 38
            # Traffic block hours: mostly day blocks 10:00 - 15:00 or night blocks 01:00 - 05:00
            if random.random() < 0.25:
                # Night block
                block_hour = random.choice([1, 2])
                block_min = random.choice([0, 15, 20, 30, 45])
            else:
                # Day block / mid-day shadow block
                block_hour = random.choice([10, 11, 12, 13, 14])
                block_min = random.choice([5, 12, 15, 20, 30, 40, 52])

            actual_start_dt = start_base_date + timedelta(days=day_offset, hours=block_hour - 9, minutes=block_min)
            actual_end_dt = actual_start_dt + timedelta(minutes=actual_dur)

            # Completion status
            if duration_delta >= 20:
                completion_status = random.choice(["Completed", "Completed with Speed Restriction"])
            elif duration_delta <= -15 and random.random() < 0.2:
                completion_status = "Partially Completed"
            else:
                completion_status = "Completed"

            record = {
                "job_id": job_id,
                "division": sec["division"],
                "section": sec["section"],
                "block_section": b_sec["code"],
                "line": line_chosen,
                "work_type": work_def["work_type"],
                "asset_type": work_def["asset_type"],
                "severity": severity,
                "criticality": criticality,
                "overdue_days": overdue_days,
                "crew_size": crew_size,
                "equipment": equipment,
                "requested_duration_min": req_dur,
                "actual_duration_min": actual_dur,
                "actual_start": actual_start_dt.strftime("%Y-%m-%dT%H:%M:%S"),
                "actual_end": actual_end_dt.strftime("%Y-%m-%dT%H:%M:%S"),
                "completion_status": completion_status
            }

            history_records.append(record)

    output_payload = {
        "source_system": "TMS_CIVIL_ENGG",
        "department": "ENGINEERING",
        "maintenance_history": history_records
    }

    return output_payload

if __name__ == "__main__":
    data = generate_maintenance_history()
    output_file = "c:/IMBPS/tms_maintenance_history.json"
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)

    total_records = len(data["maintenance_history"])
    print(f"[+] Successfully generated {total_records} realistic IR TMS maintenance history records!")
    print(f"[+] Saved to: {output_file}")
