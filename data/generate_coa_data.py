"""
COA (Control Office Application) Data Generator for Indian Railways
Covers 4 feeds:
1. COA_MASTER_TIMETABLE_PATHS
2. COA_PRIORITY_CONSTRAINT_POLICY
3. COA_WEEKLY_YARD_CAPACITY
4. COA_WEEKLY_OFFERED_SLOTS

Divisions & Sections:
- ER: Asansol (ASN) - 6 sections
- ER: Howrah (HWH) - 8 sections
- NR: Ambala (UMB) - 15 sections
"""

import json
from datetime import datetime

# Master configuration for subdivisions, sections and stations
SUBDIVISIONS_CONFIG = [
    # -------------------------------------------------------------
    # EASTERN RAILWAY - ASANSOL DIVISION (ASN)
    # -------------------------------------------------------------
    {
        "zone_code": "ER",
        "division_code": "ASN",
        "sub_division": "ASN-UDL-SNT",
        "control_board": "ASN_UDL_BOARD",
        "corridor_classification": "FEEDER_CORRIDOR_MINING",
        "sections": [
            {
                "section_id": "SEC_ASN_UDL_SNT",
                "section_name": "Andal - Sainthia",
                "from_station": "UDL",
                "to_station": "SNT",
                "from_station_name": "Andal Jn",
                "to_station_name": "Sainthia Jn",
                "intermediate_stations": [
                    {"code": "UDL", "name": "Andal Jn", "csr": 720},
                    {"code": "UKA", "name": "Ukhra", "csr": 680},
                    {"code": "PAW", "name": "Pandabeswar", "csr": 690},
                    {"code": "DUJ", "name": "Dubrajpur", "csr": 670},
                    {"code": "SURI", "name": "Siuri", "csr": 710},
                    {"code": "SNT", "name": "Sainthia Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "13017", "name": "Ganadevata Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "09:40", "exit": "10:45", "line": "UP_MAIN"},
                    {"no": "13051", "name": "Hool Express", "freq": ["MON", "TUE", "WED", "THU", "FRI", "SAT"], "trac": "ELECTRIC_CONVENTIONAL", "len": 16, "entry": "11:20", "exit": "12:35", "line": "DN_MAIN"},
                    {"no": "03561", "name": "Andal - Sainthia MEMU Passenger", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 8, "entry": "14:10", "exit": "15:40", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_ASN_UDL_TOP_BBI_STN",
                "section_name": "Andal - Tapasi - Barabani - Sitarampur",
                "from_station": "UDL",
                "to_station": "STN",
                "from_station_name": "Andal Jn",
                "to_station_name": "Sitarampur Jn",
                "intermediate_stations": [
                    {"code": "UDL", "name": "Andal Jn", "csr": 750},
                    {"code": "TOP", "name": "Tapasi", "csr": 680},
                    {"code": "IKRA", "name": "Ikrah Jn", "csr": 710},
                    {"code": "BBI", "name": "Barabani", "csr": 690},
                    {"code": "STN", "name": "Sitarampur Jn", "csr": 740}
                ],
                "trains": [
                    {"no": "03543", "name": "Andal - Gomoh Passenger Special", "freq": ["DAILY"], "trac": "ELECTRIC_CONVENTIONAL", "len": 12, "entry": "10:15", "exit": "11:25", "line": "GOODS_CHORD"},
                    {"no": "BOXN_COAL_ECL_01", "name": "Coal Rake ex-Pandabeswar / Barabani", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 58, "entry": "12:30", "exit": "13:50", "line": "GOODS_CHORD"}
                ]
            }
        ]
    },
    {
        "zone_code": "ER",
        "division_code": "ASN",
        "sub_division": "ASN-MDP-JSME",
        "control_board": "ASN_MAIN_BOARD",
        "corridor_classification": "HIGH_DENSITY_NETWORK_HDN1",
        "sections": [
            {
                "section_id": "SEC_ASN_MDP_GRD",
                "section_name": "Madhupur - Giridih",
                "from_station": "MDP",
                "to_station": "GRD",
                "from_station_name": "Madhupur Jn",
                "to_station_name": "Giridih",
                "intermediate_stations": [
                    {"code": "MDP", "name": "Madhupur Jn", "csr": 720},
                    {"code": "JGD", "name": "Jagdishpur", "csr": 650},
                    {"code": "MMD", "name": "Maheshmunda", "csr": 700},
                    {"code": "GRD", "name": "Giridih", "csr": 680}
                ],
                "trains": [
                    {"no": "03525", "name": "Madhupur - Giridih Passenger", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 8, "entry": "08:15", "exit": "09:20", "line": "SINGLE_LINE"},
                    {"no": "18618", "name": "Ranchi - Dumka Intercity", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "14:20", "exit": "15:10", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_ASN_JSME_BDME",
                "section_name": "Jasidih - Baidyanathdham",
                "from_station": "JSME",
                "to_station": "BDME",
                "from_station_name": "Jasidih Jn",
                "to_station_name": "Baidyanathdham",
                "intermediate_stations": [
                    {"code": "JSME", "name": "Jasidih Jn", "csr": 720},
                    {"code": "DGHR", "name": "Deoghar Jn", "csr": 700},
                    {"code": "BDME", "name": "Baidyanathdham", "csr": 640}
                ],
                "trains": [
                    {"no": "03673", "name": "Jasidih - Baidyanathdham MEMU", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 8, "entry": "11:00", "exit": "11:25", "line": "BRANCH_LINE"}
                ]
            },
            {
                "section_id": "SEC_ASN_JSME_DUMK",
                "section_name": "Jasidih to Dumka",
                "from_station": "JSME",
                "to_station": "DUMK",
                "from_station_name": "Jasidih Jn",
                "to_station_name": "Dumka",
                "intermediate_stations": [
                    {"code": "JSME", "name": "Jasidih Jn", "csr": 720},
                    {"code": "DGHR", "name": "Deoghar Jn", "csr": 710},
                    {"code": "CNPR", "name": "Chandanpahari", "csr": 670},
                    {"code": "BSKH", "name": "Basukinath", "csr": 690},
                    {"code": "DUMK", "name": "Dumka", "csr": 720}
                ],
                "trains": [
                    {"no": "13320", "name": "Ranchi - Dumka Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "10:30", "exit": "12:15", "line": "SINGLE_LINE"},
                    {"no": "03781", "name": "Jasidih - Dumka DEMU", "freq": ["DAILY"], "trac": "DIESEL_DEMU", "len": 8, "entry": "13:00", "exit": "14:40", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_ASN_DGHR_BAKA",
                "section_name": "Deoghar to Banka",
                "from_station": "DGHR",
                "to_station": "BAKA",
                "from_station_name": "Deoghar Jn",
                "to_station_name": "Banka Jn",
                "intermediate_stations": [
                    {"code": "DGHR", "name": "Deoghar Jn", "csr": 710},
                    {"code": "KKRA", "name": "Kakwara", "csr": 650},
                    {"code": "BAKA", "name": "Banka Jn", "csr": 700}
                ],
                "trains": [
                    {"no": "03241", "name": "Deoghar - Banka Passenger Special", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 8, "entry": "09:10", "exit": "10:45", "line": "SINGLE_LINE"},
                    {"no": "13242", "name": "Rajendra Nagar - Banka Intercity", "freq": ["MON", "TUE", "THU", "SAT"], "trac": "ELECTRIC_CONVENTIONAL", "len": 14, "entry": "15:20", "exit": "16:40", "line": "SINGLE_LINE"}
                ]
            }
        ]
    },

    # -------------------------------------------------------------
    # EASTERN RAILWAY - HOWRAH DIVISION (HWH)
    # -------------------------------------------------------------
    {
        "zone_code": "ER",
        "division_code": "HWH",
        "sub_division": "HWH-MAIN-CHORD",
        "control_board": "HWH_CHORD_MAIN_BOARD",
        "corridor_classification": "HIGH_DENSITY_NETWORK_HDN1",
        "sections": [
            {
                "section_id": "SEC_HWH_KAN_MAIN",
                "section_name": "Howrah - Khana (Main line)",
                "from_station": "HWH",
                "to_station": "KAN",
                "from_station_name": "Howrah",
                "to_station_name": "Khana Jn",
                "intermediate_stations": [
                    {"code": "HWH", "name": "Howrah", "csr": 750},
                    {"code": "BLY", "name": "Bally", "csr": 680},
                    {"code": "BDC", "name": "Bandel Jn", "csr": 740},
                    {"code": "BWN", "name": "Barddhaman", "csr": 750},
                    {"code": "KAN", "name": "Khana Jn", "csr": 720}
                ],
                "trains": [
                    {"no": "12303", "name": "Poorva Express (via Main)", "freq": ["MON", "TUE", "FRI", "SAT"], "trac": "ELECTRIC_3PH", "len": 22, "entry": "08:00", "exit": "09:42", "line": "UP_MAIN"},
                    {"no": "13009", "name": "Doon Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 24, "entry": "20:25", "exit": "22:18", "line": "UP_MAIN"},
                    {"no": "37811", "name": "Howrah - Barddhaman Main Line Local", "freq": ["DAILY"], "trac": "ELECTRIC_EMU", "len": 12, "entry": "10:15", "exit": "12:10", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_HWH_KAN_CHORD",
                "section_name": "Howrah - Khana (Chord line)",
                "from_station": "HWH",
                "to_station": "KAN",
                "from_station_name": "Howrah",
                "to_station_name": "Khana Jn",
                "intermediate_stations": [
                    {"code": "HWH", "name": "Howrah", "csr": 750},
                    {"code": "DKAE", "name": "Dankuni Jn", "csr": 750},
                    {"code": "KQU", "name": "Kamarkundu", "csr": 700},
                    {"code": "GRAE", "name": "Gurap", "csr": 690},
                    {"code": "MSAE", "name": "Masagram", "csr": 700},
                    {"code": "SKG", "name": "Saktigarh", "csr": 720},
                    {"code": "KAN", "name": "Khana Jn", "csr": 720}
                ],
                "trains": [
                    {"no": "12301", "name": "Howrah Rajdhani Express (via Chord)", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 22, "entry": "16:55", "exit": "18:10", "line": "UP_CHORD"},
                    {"no": "22301", "name": "Howrah - NJP Vande Bharat Express", "freq": ["MON", "TUE", "THU", "FRI", "SAT", "SUN"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "05:55", "exit": "06:50", "line": "UP_CHORD"},
                    {"no": "12313", "name": "Sealdah Rajdhani Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 20, "entry": "17:35", "exit": "18:48", "line": "UP_CHORD"}
                ]
            },
            {
                "section_id": "SEC_HWH_KAN_GMAN",
                "section_name": "Khana - Gumani",
                "from_station": "KAN",
                "to_station": "GMAN",
                "from_station_name": "Khana Jn",
                "to_station_name": "Gumani",
                "intermediate_stations": [
                    {"code": "KAN", "name": "Khana Jn", "csr": 720},
                    {"code": "BHP", "name": "Bolpur Shantiniketan", "csr": 730},
                    {"code": "SNT", "name": "Sainthia Jn", "csr": 740},
                    {"code": "RPH", "name": "Rampurhat Jn", "csr": 750},
                    {"code": "NHT", "name": "Nalhati Jn", "csr": 700},
                    {"code": "PKR", "name": "Pakur", "csr": 720},
                    {"code": "GMAN", "name": "Gumani", "csr": 710}
                ],
                "trains": [
                    {"no": "12345", "name": "Saraighat Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 24, "entry": "17:15", "exit": "19:40", "line": "UP_MAIN"},
                    {"no": "13149", "name": "Kanchan Kanya Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 22, "entry": "22:10", "exit": "01:05", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_HWH_RPH_DUMK",
                "section_name": "Rampurhat - Dumka",
                "from_station": "RPH",
                "to_station": "DUMK",
                "from_station_name": "Rampurhat Jn",
                "to_station_name": "Dumka",
                "intermediate_stations": [
                    {"code": "RPH", "name": "Rampurhat Jn", "csr": 740},
                    {"code": "PRGR", "name": "Pinargaria", "csr": 670},
                    {"code": "SKIP", "name": "Shikaripara", "csr": 680},
                    {"code": "DUMK", "name": "Dumka", "csr": 720}
                ],
                "trains": [
                    {"no": "13045", "name": "Mayurakshi Express", "freq": ["DAILY"], "trac": "ELECTRIC_CONVENTIONAL", "len": 16, "entry": "21:30", "exit": "23:05", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_HWH_BDC_AZ",
                "section_name": "Bandel - Azimganj",
                "from_station": "BDC",
                "to_station": "AZ",
                "from_station_name": "Bandel Jn",
                "to_station_name": "Azimganj Jn",
                "intermediate_stations": [
                    {"code": "BDC", "name": "Bandel Jn", "csr": 740},
                    {"code": "ABKA", "name": "Ambika Kalna", "csr": 700},
                    {"code": "NDAE", "name": "Nabadwip Dham", "csr": 720},
                    {"code": "KWAE", "name": "Katwa Jn", "csr": 750},
                    {"code": "SALE", "name": "Salar", "csr": 680},
                    {"code": "AZ", "name": "Azimganj Jn", "csr": 730}
                ],
                "trains": [
                    {"no": "13141", "name": "Teesta Torsa Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 20, "entry": "15:20", "exit": "18:45", "line": "UP_LOOP"},
                    {"no": "37915", "name": "Howrah - Katwa Local", "freq": ["DAILY"], "trac": "ELECTRIC_EMU", "len": 12, "entry": "10:00", "exit": "12:15", "line": "UP_LOOP"}
                ]
            },
            {
                "section_id": "SEC_HWH_DKAE_BTNG_RCD",
                "section_name": "Dankuni - Bhattanagar & Dankuni - Rajchandrapur",
                "from_station": "DKAE",
                "to_station": "BTNG",
                "from_station_name": "Dankuni Jn",
                "to_station_name": "Bhattanagar",
                "intermediate_stations": [
                    {"code": "DKAE", "name": "Dankuni Jn", "csr": 750},
                    {"code": "BTNG", "name": "Bhattanagar", "csr": 720},
                    {"code": "RCD", "name": "Rajchandrapur", "csr": 700}
                ],
                "trains": [
                    {"no": "CONCOR_CONTAINER_01", "name": "CONCOR Freight ex-Kolkata Dock", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 45, "entry": "02:00", "exit": "02:40", "line": "FREIGHT_BYPASS"},
                    {"no": "BOXN_STEEL_02", "name": "TATA Steel Load ex-Shalimar", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 52, "entry": "04:15", "exit": "04:55", "line": "FREIGHT_BYPASS"}
                ]
            },
            {
                "section_id": "SEC_HWH_SHE_TAK_GOGT",
                "section_name": "Sheoraphuli - Tarakeswar - Goghat",
                "from_station": "SHE",
                "to_station": "GOGT",
                "from_station_name": "Sheoraphuli Jn",
                "to_station_name": "Goghat",
                "intermediate_stations": [
                    {"code": "SHE", "name": "Sheoraphuli Jn", "csr": 720},
                    {"code": "DEA", "name": "Diara", "csr": 670},
                    {"code": "HPL", "name": "Haripal", "csr": 690},
                    {"code": "TAK", "name": "Tarakeswar", "csr": 720},
                    {"code": "AMBG", "name": "Arambagh", "csr": 700},
                    {"code": "GOGT", "name": "Goghat", "csr": 680}
                ],
                "trains": [
                    {"no": "37319", "name": "Howrah - Tarakeswar Local", "freq": ["DAILY"], "trac": "ELECTRIC_EMU", "len": 12, "entry": "10:30", "exit": "11:35", "line": "SUBURBAN_LINE"},
                    {"no": "37385", "name": "Howrah - Arambagh Local", "freq": ["DAILY"], "trac": "ELECTRIC_EMU", "len": 12, "entry": "14:15", "exit": "15:45", "line": "SUBURBAN_LINE"}
                ]
            },
            {
                "section_id": "SEC_HWH_BDC_HYG",
                "section_name": "Bandel - Hooghly Ghat",
                "from_station": "BDC",
                "to_station": "HYG",
                "from_station_name": "Bandel Jn",
                "to_station_name": "Hooghly Ghat",
                "intermediate_stations": [
                    {"code": "BDC", "name": "Bandel Jn", "csr": 740},
                    {"code": "HYG", "name": "Hooghly Ghat", "csr": 700}
                ],
                "trains": [
                    {"no": "37524", "name": "Bandel - Naihati Local (via Jubilee/Sampreeti Setu)", "freq": ["DAILY"], "trac": "ELECTRIC_EMU", "len": 9, "entry": "08:10", "exit": "08:25", "line": "BRIDGE_LINE"}
                ]
            },
            {
                "section_id": "SEC_HWH_AZ_NHT",
                "section_name": "Azimganj - Nalhati",
                "from_station": "AZ",
                "to_station": "NHT",
                "from_station_name": "Azimganj Jn",
                "to_station_name": "Nalhati Jn",
                "intermediate_stations": [
                    {"code": "AZ", "name": "Azimganj Jn", "csr": 730},
                    {"code": "SDI", "name": "Sagardighi", "csr": 690},
                    {"code": "MGAE", "name": "Morgram", "csr": 680},
                    {"code": "NHT", "name": "Nalhati Jn", "csr": 700}
                ],
                "trains": [
                    {"no": "03067", "name": "Azimganj - Rampurhat MEMU", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 8, "entry": "11:45", "exit": "12:50", "line": "SINGLE_LINE"}
                ]
            }
        ]
    },

    # -------------------------------------------------------------
    # NORTHERN RAILWAY - AMBALA DIVISION (UMB)
    # -------------------------------------------------------------
    {
        "zone_code": "NR",
        "division_code": "UMB",
        "sub_division": "UMB-LDH-CORRIDOR",
        "control_board": "UMB_MAIN_BOARD",
        "corridor_classification": "HIGH_DENSITY_NETWORK_HDN2",
        "sections": [
            {
                "section_id": "SEC_UMB_LDH",
                "section_name": "UMB-LDH (Ambala Cantt - Ludhiana)",
                "from_station": "UMB",
                "to_station": "LDH",
                "from_station_name": "Ambala Cantt Jn",
                "to_station_name": "Ludhiana Jn",
                "intermediate_stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 750},
                    {"code": "RPJ", "name": "Rajpura Jn", "csr": 740},
                    {"code": "SIR", "name": "Sirhind Jn", "csr": 740},
                    {"code": "KNN", "name": "Khanna", "csr": 710},
                    {"code": "DOA", "name": "Doraha", "csr": 700},
                    {"code": "LDH", "name": "Ludhiana Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "12013", "name": "New Delhi - Amritsar Shatabdi Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "19:05", "exit": "20:30", "line": "UP_MAIN"},
                    {"no": "22439", "name": "New Delhi - SMVD Katra Vande Bharat", "freq": ["MON", "TUE", "WED", "FRI", "SAT", "SUN"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "08:10", "exit": "09:20", "line": "UP_MAIN"},
                    {"no": "12919", "name": "Malwa Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 24, "entry": "07:30", "exit": "09:05", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_LDH_BTI",
                "section_name": "LDH-BTI (Ludhiana - Bathinda)",
                "from_station": "LDH",
                "to_station": "BTI",
                "from_station_name": "Ludhiana Jn",
                "to_station_name": "Bathinda Jn",
                "intermediate_stations": [
                    {"code": "LDH", "name": "Ludhiana Jn", "csr": 750},
                    {"code": "MLX", "name": "Mullanpur", "csr": 680},
                    {"code": "JGN", "name": "Jagraon", "csr": 700},
                    {"code": "MOG", "name": "Moga", "csr": 720},
                    {"code": "KKP", "name": "Kotkapura Jn", "csr": 710},
                    {"code": "BTI", "name": "Bathinda Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "14626", "name": "Intercity Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "11:15", "exit": "13:30", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_UMB_CDG_KLK",
                "section_name": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)",
                "from_station": "UMB",
                "to_station": "KLK",
                "from_station_name": "Ambala Cantt Jn",
                "to_station_name": "Kalka",
                "intermediate_stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 750},
                    {"code": "LLU", "name": "Lalru", "csr": 700},
                    {"code": "CDG", "name": "Chandigarh Jn", "csr": 750},
                    {"code": "CNDM", "name": "Chandi Mandir", "csr": 680},
                    {"code": "KLK", "name": "Kalka", "csr": 720}
                ],
                "trains": [
                    {"no": "12005", "name": "Kalka Shatabdi Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "19:50", "exit": "21:15", "line": "UP_MAIN"},
                    {"no": "22447", "name": "New Delhi - Amb Andaura Vande Bharat", "freq": ["MON", "TUE", "THU", "FRI", "SAT", "SUN"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "08:00", "exit": "08:45", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_KLK_SML",
                "section_name": "KLK-SML (Kalka - Shimla)",
                "from_station": "KLK",
                "to_station": "SML",
                "from_station_name": "Kalka",
                "to_station_name": "Shimla",
                "intermediate_stations": [
                    {"code": "KLK", "name": "Kalka", "csr": 220},
                    {"code": "DMP", "name": "Dharampur Himachal", "csr": 200},
                    {"code": "BOF", "name": "Barog", "csr": 210},
                    {"code": "SOL", "name": "Solan", "csr": 200},
                    {"code": "KDGF", "name": "Kandaghat", "csr": 200},
                    {"code": "SML", "name": "Shimla", "csr": 220}
                ],
                "trains": [
                    {"no": "52451", "name": "Shivalik Deluxe Express", "freq": ["DAILY"], "trac": "DIESEL_NG", "len": 7, "entry": "05:45", "exit": "10:35", "line": "HERITAGE_NG_TRACK"},
                    {"no": "52453", "name": "Kalka - Shimla Express", "freq": ["DAILY"], "trac": "DIESEL_NG", "len": 7, "entry": "06:20", "exit": "11:35", "line": "HERITAGE_NG_TRACK"}
                ]
            },
            {
                "section_id": "SEC_UMB_SRE",
                "section_name": "UMB-SRE (Ambala - Saharanpur)",
                "from_station": "UMB",
                "to_station": "SRE",
                "from_station_name": "Ambala Cantt Jn",
                "to_station_name": "Saharanpur Jn",
                "intermediate_stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 750},
                    {"code": "RAA", "name": "Barara", "csr": 710},
                    {"code": "YJUD", "name": "Yamunanagar Jagadhri", "csr": 730},
                    {"code": "SSW", "name": "Sarsawa", "csr": 700},
                    {"code": "SRE", "name": "Saharanpur Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "14674", "name": "Shaheed Express", "freq": ["TUE", "THU", "FRI", "SUN"], "trac": "ELECTRIC_3PH", "len": 22, "entry": "16:40", "exit": "18:05", "line": "UP_MAIN"},
                    {"no": "13308", "name": "Ganga Sutlej Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 24, "entry": "21:30", "exit": "23:05", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_JUDW",
                "section_name": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)",
                "from_station": "UMB",
                "to_station": "JUDW",
                "from_station_name": "Ambala Cantt Jn",
                "to_station_name": "Jagadhri Workshop",
                "intermediate_stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 750},
                    {"code": "KES", "name": "Kesri", "csr": 690},
                    {"code": "MFB", "name": "Mustafabad", "csr": 700},
                    {"code": "JUDW", "name": "Jagadhri Workshop", "csr": 740}
                ],
                "trains": [
                    {"no": "04524", "name": "Ambala - Saharanpur MEMU", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 12, "entry": "08:15", "exit": "09:25", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_KKDE",
                "section_name": "UMB-KKDE (Ambala - Kurukshetra)",
                "from_station": "UMB",
                "to_station": "KKDE",
                "from_station_name": "Ambala Cantt Jn",
                "to_station_name": "Kurukshetra Jn",
                "intermediate_stations": [
                    {"code": "UMB", "name": "Ambala Cantt Jn", "csr": 750},
                    {"code": "MOY", "name": "Mohri", "csr": 700},
                    {"code": "SHDM", "name": "Shahbad Markanda", "csr": 710},
                    {"code": "KKDE", "name": "Kurukshetra Jn", "csr": 740}
                ],
                "trains": [
                    {"no": "12012", "name": "Kalka New Delhi Shatabdi Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "19:00", "exit": "19:35", "line": "DN_MAIN"},
                    {"no": "12460", "name": "Amritsar - New Delhi Intercity", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 20, "entry": "10:50", "exit": "11:30", "line": "DN_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_RPJ_BTI",
                "section_name": "RPJ-BTI (Rajpura - Bathinda)",
                "from_station": "RPJ",
                "to_station": "BTI",
                "from_station_name": "Rajpura Jn",
                "to_station_name": "Bathinda Jn",
                "intermediate_stations": [
                    {"code": "RPJ", "name": "Rajpura Jn", "csr": 740},
                    {"code": "PTA", "name": "Patiala", "csr": 730},
                    {"code": "NBA", "name": "Nabha", "csr": 710},
                    {"code": "DUI", "name": "Dhuri Jn", "csr": 740},
                    {"code": "BNN", "name": "Barnala", "csr": 720},
                    {"code": "PUL", "name": "Rampura Phul", "csr": 710},
                    {"code": "BTI", "name": "Bathinda Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "14507", "name": "Delhi - Fazilka Intercity", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "17:30", "exit": "20:50", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_RPJ_DUI",
                "section_name": "RPJ-DUI (Rajpura - Dhuri)",
                "from_station": "RPJ",
                "to_station": "DUI",
                "from_station_name": "Rajpura Jn",
                "to_station_name": "Dhuri Jn",
                "intermediate_stations": [
                    {"code": "RPJ", "name": "Rajpura Jn", "csr": 740},
                    {"code": "KLI", "name": "Kauli", "csr": 690},
                    {"code": "PTA", "name": "Patiala", "csr": 730},
                    {"code": "CJL", "name": "Chhajli", "csr": 690},
                    {"code": "DUI", "name": "Dhuri Jn", "csr": 740}
                ],
                "trains": [
                    {"no": "04531", "name": "Ambala - Dhuri Special", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 10, "entry": "13:10", "exit": "14:45", "line": "UP_LINE"}
                ]
            },
            {
                "section_id": "SEC_UMB_DUI_LDH",
                "section_name": "DUI-LDH (Dhuri - Ludhiana)",
                "from_station": "DUI",
                "to_station": "LDH",
                "from_station_name": "Dhuri Jn",
                "to_station_name": "Ludhiana Jn",
                "intermediate_stations": [
                    {"code": "DUI", "name": "Dhuri Jn", "csr": 740},
                    {"code": "MET", "name": "Malerkotla", "csr": 710},
                    {"code": "AHH", "name": "Ahmedgarh", "csr": 700},
                    {"code": "QRP", "name": "Qila Raipur", "csr": 680},
                    {"code": "LDH", "name": "Ludhiana Jn", "csr": 750}
                ],
                "trains": [
                    {"no": "19611", "name": "Ajmer - Amritsar Express", "freq": ["THU", "SAT"], "trac": "ELECTRIC_3PH", "len": 20, "entry": "09:40", "exit": "11:05", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_UMB_SIR_NLDM",
                "section_name": "SIR-NLDM (Sirhind - Nangal Dam)",
                "from_station": "SIR",
                "to_station": "NLDM",
                "from_station_name": "Sirhind Jn",
                "to_station_name": "Nangal Dam",
                "intermediate_stations": [
                    {"code": "SIR", "name": "Sirhind Jn", "csr": 740},
                    {"code": "MRND", "name": "Morinda Jn", "csr": 720},
                    {"code": "RPAR", "name": "Rupnagar", "csr": 730},
                    {"code": "KART", "name": "Kiratpur Sahib", "csr": 710},
                    {"code": "ANSB", "name": "Anandpur Sahib", "csr": 740},
                    {"code": "NLDM", "name": "Nangal Dam", "csr": 750}
                ],
                "trains": [
                    {"no": "14553", "name": "Himachal Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "04:15", "exit": "06:40", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_UMB_SIR_AADR",
                "section_name": "SIR-AADR (Sirhind - Amb Andaura)",
                "from_station": "NLDM",
                "to_station": "AADR",
                "from_station_name": "Nangal Dam",
                "to_station_name": "Amb Andaura",
                "intermediate_stations": [
                    {"code": "NLDM", "name": "Nangal Dam", "csr": 750},
                    {"code": "MTPR", "name": "Mehatpur", "csr": 680},
                    {"code": "UHL", "name": "Una Himachal", "csr": 720},
                    {"code": "CHTL", "name": "Churaru Takrala", "csr": 670},
                    {"code": "AADR", "name": "Amb Andaura", "csr": 730}
                ],
                "trains": [
                    {"no": "22457", "name": "Vande Bharat Express to Amb Andaura", "freq": ["MON", "WED", "THU", "FRI", "SAT", "SUN"], "trac": "ELECTRIC_3PH", "len": 16, "entry": "10:15", "exit": "11:05", "line": "SINGLE_LINE"}
                ]
            },
            {
                "section_id": "SEC_UMB_PTA_DUI",
                "section_name": "PTA-DUI (Patiala - Dhuri)",
                "from_station": "PTA",
                "to_station": "DUI",
                "from_station_name": "Patiala",
                "to_station_name": "Dhuri Jn",
                "intermediate_stations": [
                    {"code": "PTA", "name": "Patiala", "csr": 730},
                    {"code": "DBN", "name": "Dhablan", "csr": 680},
                    {"code": "NBA", "name": "Nabha", "csr": 710},
                    {"code": "SEQ", "name": "Sekha", "csr": 670},
                    {"code": "DUI", "name": "Dhuri Jn", "csr": 740}
                ],
                "trains": [
                    {"no": "04764", "name": "Patiala - Bathinda Passenger", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 10, "entry": "06:30", "exit": "07:45", "line": "UP_MAIN"}
                ]
            },
            {
                "section_id": "SEC_UMB_BTI_ABOHAR",
                "section_name": "BTI-Abohar side (Bathinda - Abohar)",
                "from_station": "BTI",
                "to_station": "ABS",
                "from_station_name": "Bathinda Jn",
                "to_station_name": "Abohar Jn",
                "intermediate_stations": [
                    {"code": "BTI", "name": "Bathinda Jn", "csr": 750},
                    {"code": "BHX", "name": "Balluana", "csr": 690},
                    {"code": "GDB", "name": "Giddarbaha", "csr": 710},
                    {"code": "MOT", "name": "Malout", "csr": 710},
                    {"code": "ABS", "name": "Abohar Jn", "csr": 730}
                ],
                "trains": [
                    {"no": "14731", "name": "Kisan Express", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "22:15", "exit": "23:45", "line": "COTTON_CORRIDOR"}
                ]
            },
            {
                "section_id": "SEC_UMB_SRE_UDN",
                "section_name": "SRE-UDN / connecting routes (Saharanpur area)",
                "from_station": "SRE",
                "to_station": "DBD",
                "from_station_name": "Saharanpur Jn",
                "to_station_name": "Deoband",
                "intermediate_stations": [
                    {"code": "SRE", "name": "Saharanpur Jn", "csr": 750},
                    {"code": "KJGY", "name": "Khanalampura Yard", "csr": 780},
                    {"code": "BAE", "name": "Baliakheri", "csr": 700},
                    {"code": "DBD", "name": "Deoband", "csr": 720}
                ],
                "trains": [
                    {"no": "12056", "name": "Dehradun New Delhi Jan Shatabdi", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 18, "entry": "08:15", "exit": "09:05", "line": "UP_MAIN"},
                    {"no": "FREIGHT_KJGY_FOODGRAIN", "name": "FCI Foodgrain rake ex-KJGY", "freq": ["DAILY"], "trac": "ELECTRIC_3PH", "len": 42, "entry": "11:20", "exit": "12:15", "line": "YARD_RECEPTION"}
                ]
            }
        ]
    }
]

def build_timetable_feed():
    feeds = []
    for sub in SUBDIVISIONS_CONFIG:
        records = []
        for sec in sub["sections"]:
            for tr in sec["trains"]:
                records.append({
                    "train_number": tr["no"],
                    "train_name": tr["name"],
                    "service_frequency": tr["freq"],
                    "traction": tr["trac"],
                    "train_length_coaches": tr["len"],
                    "division_code": sub["division_code"],
                    "sub_division": sub["sub_division"],
                    "path_segments": [
                        {
                            "section_id": sec["section_id"],
                            "from_station": sec["from_station"],
                            "to_station": sec["to_station"],
                            "assigned_line": tr["line"],
                            "scheduled_entry_time": tr["entry"],
                            "scheduled_exit_time": tr["exit"],
                            "commercial_halt": True if tr["len"] >= 16 else False,
                            "station_code": sec["to_station"],
                            "halt_duration_mins": 5 if tr["len"] >= 16 else 2,
                            "operational_headway_buffer_prior_mins": 15,
                            "operational_headway_buffer_post_mins": 10
                        }
                    ]
                })

        feeds.append({
            "feed_type": "COA_MASTER_TIMETABLE_PATHS",
            "zone_code": sub["zone_code"],
            "division_code": sub["division_code"],
            "sub_division": sub["sub_division"],
            "effective_from": "2026-10-01",
            "effective_to": "2027-03-31",
            "generated_at": "2026-09-04T01:30:00+05:30",
            "timetable_records": records
        })
    return feeds

def build_priority_policy_feed():
    feeds = []
    for sub in SUBDIVISIONS_CONFIG:
        feeds.append({
            "feed_type": "COA_PRIORITY_CONSTRAINT_POLICY",
            "zone_code": sub["zone_code"],
            "division_code": sub["division_code"],
            "sub_division": sub["sub_division"],
            "corridor_classification": sub["corridor_classification"],
            "policy_year": "2026",
            "valid_from": "2026-04-01",
            "priority_definitions": [
                {
                    "tier": "TIER_1",
                    "class_labels": ["VANDE_BHARAT", "RAJDHANI", "SHATABDI", "TEJAS"],
                    "max_allowable_detention_minutes": 0,
                    "diversion_permitted": False,
                    "regulation_approval_authority": "RAILWAY_BOARD_ONLY",
                    "applies_to_subdivision": [sub["sub_division"]]
                },
                {
                    "tier": "TIER_2",
                    "class_labels": ["SUPERFAST_EXPRESS", "MAIL_EXPRESS", "GARIB_RATH"],
                    "max_allowable_detention_minutes": 20,
                    "diversion_permitted": True,
                    "regulation_approval_authority": f"SR_DOM_OPERATING_{sub['division_code']}",
                    "applies_to_subdivision": [sub["sub_division"]]
                },
                {
                    "tier": "TIER_3",
                    "class_labels": ["MEMU", "DEMU", "PASSENGER_ORDINARY"],
                    "max_allowable_detention_minutes": 45,
                    "short_termination_permitted": True,
                    "regulation_approval_authority": f"DOM_OPERATING_{sub['division_code']}",
                    "applies_to_subdivision": [sub["sub_division"]]
                },
                {
                    "tier": "TIER_4",
                    "class_labels": ["FREIGHT_CONTAINER", "FREIGHT_BULK_COAL", "EMPTY_RAKE"],
                    "max_allowable_detention_minutes": 240,
                    "yard_stabling_permitted": True,
                    "regulation_approval_authority": f"SECTION_CONTROLLER_{sub['control_board']}",
                    "applies_to_subdivision": [sub["sub_division"]]
                }
            ]
        })
    return feeds

def build_yard_capacity_feed():
    feeds = []
    for sub in SUBDIVISIONS_CONFIG:
        station_entries = []
        for sec in sub["sections"]:
            for stn in sec["intermediate_stations"]:
                station_entries.append({
                    "station_code": stn["code"],
                    "station_name": stn["name"],
                    "division_code": sub["division_code"],
                    "sub_division": sub["sub_division"],
                    "loops": [
                        {
                            "loop_number": f"LOOP_1_UP",
                            "clear_standing_room_csr_meters": stn["csr"],
                            "electrified": True,
                            "usable_for_holding_freight": True,
                            "booked_or_maintenance_lock": False
                        },
                        {
                            "loop_number": f"LOOP_2_COMMON",
                            "clear_standing_room_csr_meters": stn["csr"] - 30,
                            "electrified": True,
                            "usable_for_holding_freight": False,
                            "lock_reason": "RESERVED_FOR_CROSSING_MAIL_TRAINS"
                        }
                    ]
                })

        # Remove duplicate stations within same subdivision
        seen = set()
        deduped = []
        for s in station_entries:
            if s["station_code"] not in seen:
                seen.add(s["station_code"])
                deduped.append(s)

        feeds.append({
            "feed_type": "COA_WEEKLY_YARD_CAPACITY",
            "zone_code": sub["zone_code"],
            "division_code": sub["division_code"],
            "sub_division": sub["sub_division"],
            "target_week": "2026-W37",
            "effective_period": {
                "from": "2026-09-07",
                "to": "2026-09-13"
            },
            "snapshot_timestamp": "2026-09-04T01:30:00+05:30",
            "stations": deduped
        })
    return feeds

def build_offered_slots_feed():
    feeds = []
    slot_id_counter = 1
    for sub in SUBDIVISIONS_CONFIG:
        candidate_slots = []
        for sec in sub["sections"]:
            # Create candidate maintenance block slots
            stns = sec["intermediate_stations"]
            from_stn = stns[0]["name"]
            to_stn = stns[min(1, len(stns)-1)]["name"]
            stn_code_from = stns[0]["code"]
            stn_code_to = stns[min(1, len(stns)-1)]["code"]
            candidate_slots.append({
                "coa_slot_id": f"COA_SLOT_{sub['division_code']}_{sec['from_station']}_{sec['to_station']}_2026_W37_{slot_id_counter:03d}",
                "division_code": sub["division_code"],
                "sub_division": sub["sub_division"],
                "section_id": sec["section_id"],
                "block_section": f"{from_stn} ({stn_code_from}) - {to_stn} ({stn_code_to})",
                "line": "UP_MAIN" if "MAIN" in sec["section_name"].upper() else "SINGLE_LINE",
                "target_date": "2026-09-09",
                "day_of_week": "WEDNESDAY",
                "slot_window": {
                    "start_time": "11:45",
                    "end_time": "14:15",
                    "duration_minutes": 150
                },
                "preceding_service": {
                    "train_no": sec["trains"][0]["no"] if sec["trains"] else "12301",
                    "train_name": sec["trains"][0]["name"] if sec["trains"] else "Express",
                    "type": "SUPERFAST" if "Express" in (sec["trains"][0]["name"] if sec["trains"] else "") else "MAIL",
                    "projected_clearance_time_at_to_station": "11:40"
                },
                "following_service": {
                    "train_no": sec["trains"][1]["no"] if len(sec["trains"]) > 1 else "13010",
                    "train_name": sec["trains"][1]["name"] if len(sec["trains"]) > 1 else "Passenger",
                    "type": "MAIL_EXPRESS",
                    "projected_arrival_time_at_from_station": "14:25"
                },
                "contingency_regulation_playbook": {
                    "regulated_coaching_trains": [
                        {
                            "train_no": sec["trains"][1]["no"] if len(sec["trains"]) > 1 else "13010",
                            "train_name": sec["trains"][1]["name"] if len(sec["trains"]) > 1 else "Passenger",
                            "regulation_station": stn_code_from,
                            "detention_time_mins": 15,
                            "sr_dom_approved": True
                        }
                    ],
                    "regulated_freight_rakes": [
                        {
                            "freight_id": f"FREIGHT_LOAD_{sub['division_code']}_{slot_id_counter:03d}",
                            "stabling_station": stn_code_from,
                            "stabling_loop": "LOOP_1_UP",
                            "planned_hold_minutes": 120
                        }
                    ]
                }
            })
            slot_id_counter += 1

        feeds.append({
            "feed_type": "COA_WEEKLY_OFFERED_SLOTS",
            "zone_code": sub["zone_code"],
            "division_code": sub["division_code"],
            "sub_division": sub["sub_division"],
            "control_board": sub["control_board"],
            "planning_week": "2026-W37",
            "candidate_slots": candidate_slots
        })
    return feeds

def generate_all_coa():
    master_timetable = build_timetable_feed()
    priority_policy = build_priority_policy_feed()
    yard_capacity = build_yard_capacity_feed()
    offered_slots = build_offered_slots_feed()

    coa_package = {
        "master_timetable_feeds": master_timetable,
        "priority_policy_feeds": priority_policy,
        "yard_capacity_feeds": yard_capacity,
        "offered_slots_feeds": offered_slots
    }

    with open("c:/IMBPS/coa_data.json", "w", encoding="utf-8") as f:
        json.dump(coa_package, f, indent=2)

    # Count total items
    total_timetable_records = sum(len(f["timetable_records"]) for f in master_timetable)
    total_slots = sum(len(f["candidate_slots"]) for f in offered_slots)
    total_stations = sum(len(f["stations"]) for f in yard_capacity)

    print(f"[+] Successfully generated coa_data.json:")
    print(f"    - Master Timetable Records: {total_timetable_records} trains across {len(master_timetable)} subdivisions")
    print(f"    - Priority Policies: {len(priority_policy)} subdivisions")
    print(f"    - Yard Capacity Stations: {total_stations} stations")
    print(f"    - Offered Maintenance Slots: {total_slots} candidate slots covering all sections")

if __name__ == "__main__":
    generate_all_coa()
