import json
import random
from datetime import datetime, timedelta

SECTIONS_CONFIG = [
    # -------------------------------------------------------------
    # EASTERN RAILWAY - ASANSOL DIVISION (ASN)
    # -------------------------------------------------------------
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_UDL",
        "section_name": "Andal - Sainthia",
        "block_sections": [
            {"from_stn": "Andal (UDL)", "to_stn": "Ukhra (UKA)", "chainage_start": 0.0, "chainage_end": 12.4},
            {"from_stn": "Ukhra (UKA)", "to_stn": "Pandabeswar (PAW)", "chainage_start": 12.4, "chainage_end": 21.0},
            {"from_stn": "Pandabeswar (PAW)", "to_stn": "Dubrajpur (DUJ)", "chainage_start": 21.0, "chainage_end": 39.8},
            {"from_stn": "Dubrajpur (DUJ)", "to_stn": "Siuri (SURI)", "chainage_start": 39.8, "chainage_end": 58.2},
            {"from_stn": "Siuri (SURI)", "to_stn": "Sainthia Jn (SNT)", "chainage_start": 58.2, "chainage_end": 73.1}
        ],
        "lines": ["Single Line", "UP Main Line", "DN Main Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_STN",
        "section_name": "Andal - Tapasi - Barabani - Sitarampur",
        "block_sections": [
            {"from_stn": "Andal Jn (UDL)", "to_stn": "Tapasi (TOP)", "chainage_start": 0.0, "chainage_end": 8.5},
            {"from_stn": "Tapasi (TOP)", "to_stn": "Ikrah Jn (IKRA)", "chainage_start": 8.5, "chainage_end": 15.2},
            {"from_stn": "Ikrah Jn (IKRA)", "to_stn": "Barabani (BBI)", "chainage_start": 15.2, "chainage_end": 28.0},
            {"from_stn": "Barabani (BBI)", "to_stn": "Sitarampur Jn (STN)", "chainage_start": 28.0, "chainage_end": 41.5}
        ],
        "lines": ["Single Line", "Goods Chord Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_MDP",
        "section_name": "Madhupur - Giridih",
        "block_sections": [
            {"from_stn": "Madhupur Jn (MDP)", "to_stn": "Jagdishpur (JGD)", "chainage_start": 0.0, "chainage_end": 11.2},
            {"from_stn": "Jagdishpur (JGD)", "to_stn": "Maheshmunda (MMD)", "chainage_start": 11.2, "chainage_end": 26.5},
            {"from_stn": "Maheshmunda (MMD)", "to_stn": "Giridih (GRD)", "chainage_start": 26.5, "chainage_end": 38.0}
        ],
        "lines": ["Single Line (Electrified 25kV)"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_JSME",
        "section_name": "Jasidih - Baidyanathdham",
        "block_sections": [
            {"from_stn": "Jasidih Jn (JSME)", "to_stn": "Deoghar Jn (DGHR)", "chainage_start": 0.0, "chainage_end": 3.8},
            {"from_stn": "Deoghar Jn (DGHR)", "to_stn": "Baidyanathdham (BDME)", "chainage_start": 3.8, "chainage_end": 6.1}
        ],
        "lines": ["Branch Single Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_JSME",
        "section_name": "Jasidih to Dumka",
        "block_sections": [
            {"from_stn": "Jasidih Jn (JSME)", "to_stn": "Deoghar Jn (DGHR)", "chainage_start": 0.0, "chainage_end": 5.8},
            {"from_stn": "Deoghar Jn (DGHR)", "to_stn": "Chandanpahari (CNPR)", "chainage_start": 5.8, "chainage_end": 22.4},
            {"from_stn": "Chandanpahari (CNPR)", "to_stn": "Basukinath (BSKH)", "chainage_start": 22.4, "chainage_end": 44.1},
            {"from_stn": "Basukinath (BSKH)", "to_stn": "Dumka (DUMK)", "chainage_start": 44.1, "chainage_end": 71.3}
        ],
        "lines": ["Single Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_PWAY_DGHR",
        "section_name": "Deoghar to Banka",
        "block_sections": [
            {"from_stn": "Deoghar Jn (DGHR)", "to_stn": "Banka Ghat / Kakwara (KKRA)", "chainage_start": 0.0, "chainage_end": 31.0},
            {"from_stn": "Kakwara (KKRA)", "to_stn": "Banka Jn (BAKA)", "chainage_start": 31.0, "chainage_end": 56.4}
        ],
        "lines": ["Single Line"]
    },

    # -------------------------------------------------------------
    # EASTERN RAILWAY - HOWRAH DIVISION (HWH)
    # -------------------------------------------------------------
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_BWN",
        "section_name": "Howrah - Khana (Main line)",
        "block_sections": [
            {"from_stn": "Howrah (HWH)", "to_stn": "Bally (BLY)", "chainage_start": 0.0, "chainage_end": 9.2},
            {"from_stn": "Bally (BLY)", "to_stn": "Bandel (BDC)", "chainage_start": 9.2, "chainage_end": 39.5},
            {"from_stn": "Bandel (BDC)", "to_stn": "Barddhaman (BWN)", "chainage_start": 39.5, "chainage_end": 107.0},
            {"from_stn": "Barddhaman (BWN)", "to_stn": "Khana Jn (KAN)", "chainage_start": 107.0, "chainage_end": 120.4}
        ],
        "lines": ["UP Main Line", "DN Main Line", "3rd Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_DKAE",
        "section_name": "Howrah - Khana (Chord line)",
        "block_sections": [
            {"from_stn": "Howrah (HWH)", "to_stn": "Dankuni Jn (DKAE)", "chainage_start": 0.0, "chainage_end": 15.0},
            {"from_stn": "Dankuni Jn (DKAE)", "to_stn": "Kamarkundu (KQU)", "chainage_start": 15.0, "chainage_end": 36.2},
            {"from_stn": "Kamarkundu (KQU)", "to_stn": "Gurap (GRAE)", "chainage_start": 36.2, "chainage_end": 58.0},
            {"from_stn": "Gurap (GRAE)", "to_stn": "Masagram (MSAE)", "chainage_start": 58.0, "chainage_end": 78.4},
            {"from_stn": "Masagram (MSAE)", "to_stn": "Saktigarh (SKG)", "chainage_start": 78.4, "chainage_end": 96.1},
            {"from_stn": "Saktigarh (SKG)", "to_stn": "Khana Jn (KAN)", "chainage_start": 96.1, "chainage_end": 113.8}
        ],
        "lines": ["UP Chord Line", "DN Chord Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_RPH",
        "section_name": "Khana - Gumani",
        "block_sections": [
            {"from_stn": "Khana Jn (KAN)", "to_stn": "Bolpur Shantiniketan (BHP)", "chainage_start": 120.0, "chainage_end": 159.2},
            {"from_stn": "Bolpur Shantiniketan (BHP)", "to_stn": "Sainthia Jn (SNT)", "chainage_start": 159.2, "chainage_end": 190.5},
            {"from_stn": "Sainthia Jn (SNT)", "to_stn": "Rampurhat Jn (RPH)", "chainage_start": 190.5, "chainage_end": 218.4},
            {"from_stn": "Rampurhat Jn (RPH)", "to_stn": "Nalhati Jn (NHT)", "chainage_start": 218.4, "chainage_end": 232.5},
            {"from_stn": "Nalhati Jn (NHT)", "to_stn": "Pakur (PKR)", "chainage_start": 232.5, "chainage_end": 264.1},
            {"from_stn": "Pakur (PKR)", "to_stn": "Gumani (GMAN)", "chainage_start": 264.1, "chainage_end": 298.6}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_RPH",
        "section_name": "Rampurhat - Dumka",
        "block_sections": [
            {"from_stn": "Rampurhat Jn (RPH)", "to_stn": "Pinargaria (PRGR)", "chainage_start": 0.0, "chainage_end": 20.8},
            {"from_stn": "Pinargaria (PRGR)", "to_stn": "Shikaripara (SKIP)", "chainage_start": 20.8, "chainage_end": 41.5},
            {"from_stn": "Shikaripara (SKIP)", "to_stn": "Dumka (DUMK)", "chainage_start": 41.5, "chainage_end": 64.2}
        ],
        "lines": ["Single Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_AZ",
        "section_name": "Bandel - Azimganj",
        "block_sections": [
            {"from_stn": "Bandel Jn (BDC)", "to_stn": "Ambika Kalna (ABKA)", "chainage_start": 40.0, "chainage_end": 81.6},
            {"from_stn": "Ambika Kalna (ABKA)", "to_stn": "Nabadwip Dham (NDAE)", "chainage_start": 81.6, "chainage_end": 105.1},
            {"from_stn": "Nabadwip Dham (NDAE)", "to_stn": "Katwa Jn (KWAE)", "chainage_start": 105.1, "chainage_end": 144.3},
            {"from_stn": "Katwa Jn (KWAE)", "to_stn": "Salar (SALE)", "chainage_start": 144.3, "chainage_end": 161.7},
            {"from_stn": "Salar (SALE)", "to_stn": "Azimganj Jn (AZ)", "chainage_start": 161.7, "chainage_end": 217.5}
        ],
        "lines": ["UP Loop Line", "DN Loop Line", "Single Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_DKAE",
        "section_name": "Dankuni - Bhattanagar & Dankuni - Rajchandrapur",
        "block_sections": [
            {"from_stn": "Dankuni Jn (DKAE)", "to_stn": "Bhattanagar (BTNG)", "chainage_start": 0.0, "chainage_end": 8.3},
            {"from_stn": "Dankuni Jn (DKAE)", "to_stn": "Rajchandrapur (RCD)", "chainage_start": 0.0, "chainage_end": 4.5}
        ],
        "lines": ["Freight Bypass UP Line", "Freight Bypass DN Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_SHE",
        "section_name": "Sheoraphuli - Tarakeswar - Goghat",
        "block_sections": [
            {"from_stn": "Sheoraphuli (SHE)", "to_stn": "Diara (DEA)", "chainage_start": 0.0, "chainage_end": 6.2},
            {"from_stn": "Diara (DEA)", "to_stn": "Haripal (HPL)", "chainage_start": 6.2, "chainage_end": 21.8},
            {"from_stn": "Haripal (HPL)", "to_stn": "Tarakeswar (TAK)", "chainage_start": 21.8, "chainage_end": 35.5},
            {"from_stn": "Tarakeswar (TAK)", "to_stn": "Arambagh (AMBG)", "chainage_start": 35.5, "chainage_end": 59.3},
            {"from_stn": "Arambagh (AMBG)", "to_stn": "Goghat (GOGT)", "chainage_start": 59.3, "chainage_end": 69.1}
        ],
        "lines": ["Suburban UP Line", "Suburban DN Line", "Single Line Branch"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_BDC",
        "section_name": "Bandel - Hooghly Ghat",
        "block_sections": [
            {"from_stn": "Bandel Jn (BDC)", "to_stn": "Hooghly Ghat (HYG)", "chainage_start": 39.5, "chainage_end": 43.4}
        ],
        "lines": ["Sampreeti Setu Bridge UP Line", "Sampreeti Setu Bridge DN Line"]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_PWAY_AZ",
        "section_name": "Azimganj - Nalhati",
        "block_sections": [
            {"from_stn": "Azimganj Jn (AZ)", "to_stn": "Sagardighi (SDI)", "chainage_start": 0.0, "chainage_end": 19.5},
            {"from_stn": "Sagardighi (SDI)", "to_stn": "Morgram (MGAE)", "chainage_start": 19.5, "chainage_end": 27.2},
            {"from_stn": "Morgram (MGAE)", "to_stn": "Nalhati Jn (NHT)", "chainage_start": 27.2, "chainage_end": 45.3}
        ],
        "lines": ["Single Line"]
    },

    # -------------------------------------------------------------
    # NORTHERN RAILWAY - AMBALA DIVISION (UMB)
    # -------------------------------------------------------------
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_UMB",
        "section_name": "UMB-LDH (Ambala Cantt - Ludhiana)",
        "block_sections": [
            {"from_stn": "Ambala Cantt (UMB)", "to_stn": "Rajpura Jn (RPJ)", "chainage_start": 198.5, "chainage_end": 226.2},
            {"from_stn": "Rajpura Jn (RPJ)", "to_stn": "Sirhind Jn (SIR)", "chainage_start": 226.2, "chainage_end": 251.8},
            {"from_stn": "Sirhind Jn (SIR)", "to_stn": "Khanna (KNN)", "chainage_start": 251.8, "chainage_end": 269.4},
            {"from_stn": "Khanna (KNN)", "to_stn": "Doraha (DOA)", "chainage_start": 269.4, "chainage_end": 290.1},
            {"from_stn": "Doraha (DOA)", "to_stn": "Ludhiana Jn (LDH)", "chainage_start": 290.1, "chainage_end": 312.5}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_LDH",
        "section_name": "LDH-BTI (Ludhiana - Bathinda)",
        "block_sections": [
            {"from_stn": "Ludhiana Jn (LDH)", "to_stn": "Mullanpur (MLX)", "chainage_start": 0.0, "chainage_end": 21.0},
            {"from_stn": "Mullanpur (MLX)", "to_stn": "Jagraon (JGN)", "chainage_start": 21.0, "chainage_end": 39.8},
            {"from_stn": "Jagraon (JGN)", "to_stn": "Moga (MOG)", "chainage_start": 39.8, "chainage_end": 69.4},
            {"from_stn": "Moga (MOG)", "to_stn": "Kotkapura Jn (KKP)", "chainage_start": 69.4, "chainage_end": 109.8},
            {"from_stn": "Kotkapura Jn (KKP)", "to_stn": "Bathinda Jn (BTI)", "chainage_start": 109.8, "chainage_end": 141.2}
        ],
        "lines": ["Single Line", "UP Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_CDG",
        "section_name": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)",
        "block_sections": [
            {"from_stn": "Ambala Cantt (UMB)", "to_stn": "Lalru (LLU)", "chainage_start": 0.0, "chainage_end": 17.5},
            {"from_stn": "Lalru (LLU)", "to_stn": "Chandigarh Jn (CDG)", "chainage_start": 17.5, "chainage_end": 44.8},
            {"from_stn": "Chandigarh Jn (CDG)", "to_stn": "Chandi Mandir (CNDM)", "chainage_start": 44.8, "chainage_end": 54.2},
            {"from_stn": "Chandi Mandir (CNDM)", "to_stn": "Kalka (KLK)", "chainage_start": 54.2, "chainage_end": 67.8}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_KLK",
        "section_name": "KLK-SML (Kalka - Shimla)",
        "block_sections": [
            {"from_stn": "Kalka (KLK)", "to_stn": "Dharampur Himachal (DMP)", "chainage_start": 0.0, "chainage_end": 32.5},
            {"from_stn": "Dharampur Himachal (DMP)", "to_stn": "Barog (BOF)", "chainage_start": 32.5, "chainage_end": 42.1},
            {"from_stn": "Barog (BOF)", "to_stn": "Solan (SOL)", "chainage_start": 42.1, "chainage_end": 52.8},
            {"from_stn": "Solan (SOL)", "to_stn": "Kandaghat (KDGF)", "chainage_start": 52.8, "chainage_end": 64.0},
            {"from_stn": "Kandaghat (KDGF)", "to_stn": "Shimla (SML)", "chainage_start": 64.0, "chainage_end": 95.6}
        ],
        "lines": ["Narrow Gauge Heritage Track"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_JUDW",
        "section_name": "UMB-SRE (Ambala - Saharanpur)",
        "block_sections": [
            {"from_stn": "Ambala Cantt (UMB)", "to_stn": "Barara (RAA)", "chainage_start": 0.0, "chainage_end": 24.6},
            {"from_stn": "Barara (RAA)", "to_stn": "Yamunanagar Jagadhri (YJUD)", "chainage_start": 24.6, "chainage_end": 51.0},
            {"from_stn": "Yamunanagar Jagadhri (YJUD)", "to_stn": "Sarsawa (SSW)", "chainage_start": 51.0, "chainage_end": 67.4},
            {"from_stn": "Sarsawa (SSW)", "to_stn": "Saharanpur Jn (SRE)", "chainage_start": 67.4, "chainage_end": 81.3}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_JUDW",
        "section_name": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)",
        "block_sections": [
            {"from_stn": "Ambala Cantt (UMB)", "to_stn": "Kesri (KES)", "chainage_start": 0.0, "chainage_end": 14.1},
            {"from_stn": "Kesri (KES)", "to_stn": "Mustafabad (MFB)", "chainage_start": 14.1, "chainage_end": 35.8},
            {"from_stn": "Mustafabad (MFB)", "to_stn": "Jagadhri Workshop (JUDW)", "chainage_start": 35.8, "chainage_end": 48.2}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_KKDE",
        "section_name": "UMB-KKDE (Ambala - Kurukshetra)",
        "block_sections": [
            {"from_stn": "Ambala Cantt (UMB)", "to_stn": "Mohri (MOY)", "chainage_start": 198.5, "chainage_end": 189.0},
            {"from_stn": "Mohri (MOY)", "to_stn": "Shahbad Markanda (SHDM)", "chainage_start": 189.0, "chainage_end": 179.3},
            {"from_stn": "Shahbad Markanda (SHDM)", "to_stn": "Kurukshetra Jn (KKDE)", "chainage_start": 179.3, "chainage_end": 157.0}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_RPJ",
        "section_name": "RPJ-BTI (Rajpura - Bathinda)",
        "block_sections": [
            {"from_stn": "Rajpura Jn (RPJ)", "to_stn": "Patiala (PTA)", "chainage_start": 0.0, "chainage_end": 25.1},
            {"from_stn": "Patiala (PTA)", "to_stn": "Nabha (NBA)", "chainage_start": 25.1, "chainage_end": 50.4},
            {"from_stn": "Nabha (NBA)", "to_stn": "Dhuri Jn (DUI)", "chainage_start": 50.4, "chainage_end": 77.2},
            {"from_stn": "Dhuri Jn (DUI)", "to_stn": "Barnala (BNN)", "chainage_start": 77.2, "chainage_end": 108.0},
            {"from_stn": "Barnala (BNN)", "to_stn": "Rampura Phul (PUL)", "chainage_start": 108.0, "chainage_end": 140.2},
            {"from_stn": "Rampura Phul (PUL)", "to_stn": "Bathinda Jn (BTI)", "chainage_start": 140.2, "chainage_end": 172.5}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_PTA",
        "section_name": "RPJ-DUI (Rajpura - Dhuri)",
        "block_sections": [
            {"from_stn": "Rajpura Jn (RPJ)", "to_stn": "Kauli (KLI)", "chainage_start": 0.0, "chainage_end": 11.2},
            {"from_stn": "Kauli (KLI)", "to_stn": "Patiala (PTA)", "chainage_start": 11.2, "chainage_end": 25.1},
            {"from_stn": "Patiala (PTA)", "to_stn": "Chhajli (CJL)", "chainage_start": 25.1, "chainage_end": 62.0},
            {"from_stn": "Chhajli (CJL)", "to_stn": "Dhuri Jn (DUI)", "chainage_start": 62.0, "chainage_end": 77.2}
        ],
        "lines": ["UP Line", "DN Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_DUI",
        "section_name": "DUI-LDH (Dhuri - Ludhiana)",
        "block_sections": [
            {"from_stn": "Dhuri Jn (DUI)", "to_stn": "Malerkotla (MET)", "chainage_start": 0.0, "chainage_end": 16.8},
            {"from_stn": "Malerkotla (MET)", "to_stn": "Ahmedgarh (AHH)", "chainage_start": 16.8, "chainage_end": 36.4},
            {"from_stn": "Ahmedgarh (AHH)", "to_stn": "Qila Raipur (QRP)", "chainage_start": 36.4, "chainage_end": 44.5},
            {"from_stn": "Qila Raipur (QRP)", "to_stn": "Ludhiana Jn (LDH)", "chainage_start": 44.5, "chainage_end": 62.1}
        ],
        "lines": ["Single Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_SIR",
        "section_name": "SIR-NLDM (Sirhind - Nangal Dam)",
        "block_sections": [
            {"from_stn": "Sirhind Jn (SIR)", "to_stn": "Morinda Jn (MRND)", "chainage_start": 0.0, "chainage_end": 24.3},
            {"from_stn": "Morinda Jn (MRND)", "to_stn": "Rupnagar (RPAR)", "chainage_start": 24.3, "chainage_end": 48.7},
            {"from_stn": "Rupnagar (RPAR)", "to_stn": "Kiratpur Sahib (KART)", "chainage_start": 48.7, "chainage_end": 75.9},
            {"from_stn": "Kiratpur Sahib (KART)", "to_stn": "Anandpur Sahib (ANSB)", "chainage_start": 75.9, "chainage_end": 84.1},
            {"from_stn": "Anandpur Sahib (ANSB)", "to_stn": "Nangal Dam (NLDM)", "chainage_start": 84.1, "chainage_end": 99.6}
        ],
        "lines": ["Single Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_SIR",
        "section_name": "SIR-AADR (Sirhind - Amb Andaura)",
        "block_sections": [
            {"from_stn": "Nangal Dam (NLDM)", "to_stn": "Mehatpur (MTPR)", "chainage_start": 99.6, "chainage_end": 106.0},
            {"from_stn": "Mehatpur (MTPR)", "to_stn": "Una Himachal (UHL)", "chainage_start": 106.0, "chainage_end": 116.5},
            {"from_stn": "Una Himachal (UHL)", "to_stn": "Churaru Takrala (CHTL)", "chainage_start": 116.5, "chainage_end": 127.3},
            {"from_stn": "Churaru Takrala (CHTL)", "to_stn": "Amb Andaura (AADR)", "chainage_start": 127.3, "chainage_end": 143.8}
        ],
        "lines": ["Hill Section Single Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_PTA",
        "section_name": "PTA-DUI (Patiala - Dhuri)",
        "block_sections": [
            {"from_stn": "Patiala (PTA)", "to_stn": "Dhablan (DBN)", "chainage_start": 25.1, "chainage_end": 37.8},
            {"from_stn": "Dhablan (DBN)", "to_stn": "Nabha (NBA)", "chainage_start": 37.8, "chainage_end": 50.4},
            {"from_stn": "Nabha (NBA)", "to_stn": "Sekha (SEQ)", "chainage_start": 50.4, "chainage_end": 64.0},
            {"from_stn": "Sekha (SEQ)", "to_stn": "Dhuri Jn (DUI)", "chainage_start": 64.0, "chainage_end": 77.2}
        ],
        "lines": ["UP Main Line", "DN Main Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_BTI",
        "section_name": "BTI-Abohar side (Bathinda - Abohar)",
        "block_sections": [
            {"from_stn": "Bathinda Jn (BTI)", "to_stn": "Balluana (BHX)", "chainage_start": 0.0, "chainage_end": 18.2},
            {"from_stn": "Balluana (BHX)", "to_stn": "Giddarbaha (GDB)", "chainage_start": 18.2, "chainage_end": 28.5},
            {"from_stn": "Giddarbaha (GDB)", "to_stn": "Malout (MOT)", "chainage_start": 28.5, "chainage_end": 44.3},
            {"from_stn": "Malout (MOT)", "to_stn": "Abohar Jn (ABS)", "chainage_start": 44.3, "chainage_end": 73.6}
        ],
        "lines": ["Single Line"]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_PWAY_SRE",
        "section_name": "SRE-UDN / connecting routes (Saharanpur area)",
        "block_sections": [
            {"from_stn": "Saharanpur Jn (SRE)", "to_stn": "Khanalampura Yard (KJGY)", "chainage_start": 0.0, "chainage_end": 5.4},
            {"from_stn": "Khanalampura Yard (KJGY)", "to_stn": "Baliakheri (BAE)", "chainage_start": 5.4, "chainage_end": 12.8},
            {"from_stn": "Baliakheri (BAE)", "to_stn": "Deoband (DBD)", "chainage_start": 12.8, "chainage_end": 34.0}
        ],
        "lines": ["UP Freight Corridor", "DN Freight Corridor", "Yard Reception Line"]
    }
]

TMS_WORK_CATALOG = [
    {
        "work_type": "Tamping Machine (CSM) Deployment",
        "demand_nature": "Planned Rolling Block",
        "duration_minutes": 150,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 50,
        "normal_speed_restoration_hrs": 48
    },
    {
        "work_type": "Ballast Cleaning Machine (BCM) Deep Screening",
        "demand_nature": "Planned Corridor Block",
        "duration_minutes": 240,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 30,
        "normal_speed_restoration_hrs": 72
    },
    {
        "work_type": "Points & Crossing Tamping (UNIMAT)",
        "demand_nature": "Planned Rolling Block",
        "duration_minutes": 180,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 45,
        "normal_speed_restoration_hrs": 36
    },
    {
        "work_type": "Rail Grinding Machine (RGM) Operations",
        "demand_nature": "Night Traffic Block",
        "duration_minutes": 210,
        "power_block_required": False,
        "st_disconnection_required": False,
        "post_work_speed_kmph": 75,
        "normal_speed_restoration_hrs": 24
    },
    {
        "work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion",
        "demand_nature": "Planned Mega Block",
        "duration_minutes": 240,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 30,
        "normal_speed_restoration_hrs": 72
    },
    {
        "work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)",
        "demand_nature": "Planned Rolling Block",
        "duration_minutes": 120,
        "power_block_required": False,
        "st_disconnection_required": False,
        "post_work_speed_kmph": 60,
        "normal_speed_restoration_hrs": 24
    },
    {
        "work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)",
        "demand_nature": "Planned Mega Block",
        "duration_minutes": 300,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 20,
        "normal_speed_restoration_hrs": 96
    },
    {
        "work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)",
        "demand_nature": "Urgent Maintenance Block",
        "duration_minutes": 90,
        "power_block_required": True,
        "st_disconnection_required": True,
        "post_work_speed_kmph": 45,
        "normal_speed_restoration_hrs": 24
    }
]

def generate_tms_records():
    records = []
    demand_counter = 501
    base_date = datetime(2026, 9, 8, 11, 0)

    for sec_idx, sec in enumerate(SECTIONS_CONFIG):
        num_records_for_section = 2 if len(sec["block_sections"]) <= 2 else 3

        for r_i in range(num_records_for_section):
            b_sec = sec["block_sections"][r_i % len(sec["block_sections"])]
            work = TMS_WORK_CATALOG[(sec_idx + r_i) % len(TMS_WORK_CATALOG)]

            # Chainage calculations
            from_km = round(b_sec["chainage_start"] + random.uniform(0.4, 2.8), 3)
            to_km = round(from_km + random.uniform(1.1, 3.8), 3)
            if to_km > b_sec["chainage_end"]:
                to_km = round(b_sec["chainage_end"], 3)

            # Mast numbers for TRD dependency reference
            km_start_int = int(from_km)
            km_end_int = int(to_km)
            mast_start = f"{km_start_int:03d}/{random.randint(2, 14):02d}"
            mast_end = f"{km_end_int:03d}/{random.randint(16, 32):02d}"

            # Time calculation
            window_date = (base_date + timedelta(days=(sec_idx // 3), hours=(r_i * 3))).strftime("%Y-%m-%d")
            start_hour = 11 + (r_i * 3) % 10
            start_min = 30 if r_i % 2 == 0 else 0
            duration = work["duration_minutes"]
            start_dt = datetime.strptime(f"{window_date} {start_hour:02d}:{start_min:02d}", "%Y-%m-%d %H:%M")
            end_dt = start_dt + timedelta(minutes=duration)

            # Requisitioning officer
            emp_id = f"{random.randint(1048000, 1099999)}"
            mobile_num = f"97714{random.randint(10000, 99999)}" if sec["zone"] == "ER" else f"97176{random.randint(10000, 99999)}"

            # Interdepartmental details
            if work["power_block_required"]:
                trd_details = f"OHE isolation required between Masts {mast_start} - {mast_end}"
            else:
                trd_details = "None. Work below rail flange level, electrical clearance not infringed"

            if work["st_disconnection_required"]:
                st_details = "Axle counters & track circuit bonding disconnection with S&T staff at site"
            else:
                st_details = "No S&T gear disconnection required"

            line_chosen = random.choice(sec["lines"])

            record = {
                "source_system": "TMS_CIVIL_ENGG",
                "demand_ref_id": f"TMS/{sec['division_code']}/2026/BLK/{demand_counter:04d}",
                "requisitioning_officer": {
                    "emp_id": emp_id,
                    "designation": f"{sec['sub_div']}_SUB_DIV",
                    "mobile": mobile_num
                },
                "location_details": {
                    "division": sec["division_name"],
                    "section": sec["section_name"],
                    "block_section": f"{b_sec['from_stn']} - {b_sec['to_stn']}",
                    "line": line_chosen,
                    "from_km": f"{from_km:.3f}",
                    "to_km": f"{to_km:.3f}"
                },
                "block_specifications": {
                    "work_type": work["work_type"],
                    "demand_nature": work["demand_nature"],
                    "preferred_date": window_date,
                    "requested_window": {
                        "duration_minutes": duration,
                        "preferred_start": start_dt.strftime("%H:%M"),
                        "preferred_end": end_dt.strftime("%H:%M")
                    }
                },
                "interdepartmental_dependencies": {
                    "power_block_required": work["power_block_required"],
                    "trd_details": trd_details,
                    "st_disconnection_required": work["st_disconnection_required"],
                    "st_details": st_details
                },
                "speed_restriction_proposed": {
                    "post_work_speed_kmph": work["post_work_speed_kmph"],
                    "normal_speed_restoration_hrs": work["normal_speed_restoration_hrs"]
                }
            }

            records.append(record)
            demand_counter += 1

    return records

if __name__ == "__main__":
    records = generate_tms_records()
    output_path = "c:/IMBPS/tms_data.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(records, f, indent=2)
    print(f"Generated {len(records)} realistic TMS Civil Engg records saved to {output_path}")
