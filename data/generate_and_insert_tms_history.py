"""
IMBPS - Indian Railways Track Management System (TMS) Maintenance History Generator & Inserter
Target Table: tms_civil_demands on Neon PostgreSQL Cloud
Generates and inserts 2,500 realistic, domain-aware synthetic maintenance records for SIH 2026.
"""

import os
import sys
import json
import random
import math
from datetime import datetime, date, time, timedelta
import psycopg2
from psycopg2.extras import execute_batch, RealDictCursor

# Connect using DATABASE_URL environment variable
DATABASE_URL = os.environ.get("DATABASE_URL")
if not DATABASE_URL and len(sys.argv) > 1:
    DATABASE_URL = sys.argv[1]

if not DATABASE_URL:
    raise ValueError(
        "DATABASE_URL environment variable is not set. "
        "Please set it: export DATABASE_URL='postgresql://...' or pass it as an argument."
    )

# Reproducibility seed for consistent dataset quality
random.seed(42)

# ==============================================================================
# 1. COMPREHENSIVE RAILWAY NETWORK TOPOLOGY (15 ZONES, DIVISIONS, SECTIONS, STATIONS)
# ==============================================================================

NETWORK_DATA = [
    # --- EASTERN RAILWAY (ER) ---
    {
        "zone": "Eastern Railway",
        "zone_code": "ER",
        "division": "Asansol (ASN)",
        "division_code": "ASN",
        "traffic_tier": "High_Freight",
        "sections": [
            {
                "section": "Andal - Sainthia",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Andal (UDL) - Ukhra (UKA)", "from_km": 1.165, "to_km": 4.436},
                    {"name": "Ukhra (UKA) - Pandabeswar (PAW)", "from_km": 12.981, "to_km": 15.422},
                    {"name": "Pandabeswar (PAW) - Dubrajpur (DUJ)", "from_km": 28.310, "to_km": 31.750},
                    {"name": "Dubrajpur (DUJ) - Chinpai (CPLE)", "from_km": 42.100, "to_km": 45.800},
                    {"name": "Chinpai (CPLE) - Sainthia (SNT)", "from_km": 68.250, "to_km": 72.100}
                ]
            },
            {
                "section": "Andal - Tapasi - Barabani - Sitarampur",
                "line_name": "Single Line Branch",
                "block_sections": [
                    {"name": "Andal (UDL) - Tapasi (TOP)", "from_km": 0.000, "to_km": 11.200},
                    {"name": "Tapasi (TOP) - Barabani (BBI)", "from_km": 11.200, "to_km": 24.600},
                    {"name": "Barabani (BBI) - Sitarampur (STN)", "from_km": 24.600, "to_km": 38.400}
                ]
            },
            {
                "section": "Sitarampur - Asansol - Raniganj Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Sitarampur (STN) - Asansol (ASN)", "from_km": 218.400, "to_km": 226.700},
                    {"name": "Asansol (ASN) - Kalipahari (KPK)", "from_km": 226.700, "to_km": 232.100},
                    {"name": "Kalipahari (KPK) - Raniganj (RNG)", "from_km": 232.100, "to_km": 244.500},
                    {"name": "Raniganj (RNG) - Andal (UDL)", "from_km": 244.500, "to_km": 254.200}
                ]
            },
            {
                "section": "Madhupur - Giridih",
                "line_name": "Branch Single Line",
                "block_sections": [
                    {"name": "Madhupur (MDP) - Maheshmunda (MMD)", "from_km": 0.000, "to_km": 28.500},
                    {"name": "Maheshmunda (MMD) - Giridih (GRD)", "from_km": 28.500, "to_km": 38.100}
                ]
            },
            {
                "section": "Jasidih - Baidyanathdham",
                "line_name": "Single Line (Electrified 25kV)",
                "block_sections": [
                    {"name": "Jasidih (JSME) - Baidyanathdham (BDME)", "from_km": 0.000, "to_km": 6.800}
                ]
            },
            {
                "section": "Jasidih - Dumka",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Jasidih (JSME) - Deoghar (DGHR)", "from_km": 0.000, "to_km": 5.900},
                    {"name": "Deoghar (DGHR) - Basukinath (BSKH)", "from_km": 5.900, "to_km": 42.400},
                    {"name": "Basukinath (BSKH) - Dumka (DUMK)", "from_km": 42.400, "to_km": 71.300}
                ]
            },
            {
                "section": "Deoghar - Banka",
                "line_name": "Single Line Branch",
                "block_sections": [
                    {"name": "Deoghar (DGHR) - Chandan (CHRA)", "from_km": 0.000, "to_km": 26.200},
                    {"name": "Chandan (CHRA) - Banka (BAKA)", "from_km": 26.200, "to_km": 54.800}
                ]
            }
        ]
    },
    {
        "zone": "Eastern Railway",
        "zone_code": "ER",
        "division": "Howrah (HWH)",
        "division_code": "HWH",
        "traffic_tier": "High_Passenger_Freight",
        "sections": [
            {
                "section": "Howrah - Khana Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Howrah (HWH) - Barddhaman (BWN)", "from_km": 10.400, "to_km": 107.100},
                    {"name": "Barddhaman (BWN) - Khana (KAN)", "from_km": 107.100, "to_km": 119.800},
                    {"name": "Saktigarh (SKG) - Barddhaman (BWN)", "from_km": 94.200, "to_km": 107.100}
                ]
            },
            {
                "section": "Howrah - Khana Chord Line",
                "line_name": "DN Chord Line",
                "block_sections": [
                    {"name": "Dankuni (DKAE) - Kamarkundu (KQU)", "from_km": 15.200, "to_km": 35.800},
                    {"name": "Kamarkundu (KQU) - Gurap (GRAE)", "from_km": 35.800, "to_km": 58.400},
                    {"name": "Gurap (GRAE) - Saktigarh (SKG)", "from_km": 58.400, "to_km": 88.600}
                ]
            },
            {
                "section": "Khana - Gumani",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Khana (KAN) - Bolpur Shantiniketan (BHP)", "from_km": 120.000, "to_km": 159.200},
                    {"name": "Bolpur (BHP) - Ahmadpur (AMP)", "from_km": 159.200, "to_km": 178.600},
                    {"name": "Ahmadpur (AMP) - Rampurhat (RPH)", "from_km": 178.600, "to_km": 207.300},
                    {"name": "Rampurhat (RPH) - Nalhati (NHT)", "from_km": 207.300, "to_km": 221.500},
                    {"name": "Nalhati (NHT) - Pakur (PKR)", "from_km": 221.500, "to_km": 260.400},
                    {"name": "Pakur (PKR) - Gumani (GMAN)", "from_km": 260.400, "to_km": 288.700}
                ]
            },
            {
                "section": "Bandel - Azimganj",
                "line_name": "Single Line (Electrified 25kV)",
                "block_sections": [
                    {"name": "Bandel (BDC) - Nabadwip Dham (NDAE)", "from_km": 40.000, "to_km": 105.400},
                    {"name": "Nabadwip Dham (NDAE) - Katwa (KWAE)", "from_km": 105.400, "to_km": 144.200},
                    {"name": "Katwa (KWAE) - Salar (SALE)", "from_km": 144.200, "to_km": 161.800},
                    {"name": "Salar (SALE) - Azimganj (AZ)", "from_km": 161.800, "to_km": 215.600}
                ]
            },
            {
                "section": "Rampurhat - Dumka",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Rampurhat (RPH) - Pinargaria (PRGR)", "from_km": 0.000, "to_km": 21.400},
                    {"name": "Pinargaria (PRGR) - Dumka (DUMK)", "from_km": 21.400, "to_km": 64.200}
                ]
            },
            {
                "section": "Sheoraphuli - Tarakeswar - Goghat",
                "line_name": "Single Line Branch",
                "block_sections": [
                    {"name": "Sheoraphuli (SHE) - Tarakeswar (TAK)", "from_km": 0.000, "to_km": 35.200},
                    {"name": "Tarakeswar (TAK) - Goghat (GOGT)", "from_km": 35.200, "to_km": 48.700}
                ]
            },
            {
                "section": "Dankuni - Bhattanagar",
                "line_name": "Goods Chord Line",
                "block_sections": [
                    {"name": "Dankuni (DKAE) - Bhattanagar (BTNG)", "from_km": 0.000, "to_km": 12.800}
                ]
            },
            {
                "section": "Bandel - Hooghly Ghat",
                "line_name": "Sampreeti Setu Bridge DN Line",
                "block_sections": [
                    {"name": "Bandel (BDC) - Hooghly Ghat (HYG)", "from_km": 0.000, "to_km": 7.400}
                ]
            },
            {
                "section": "Azimganj - Nalhati",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Azimganj (AZ) - Takipur (TKP)", "from_km": 0.000, "to_km": 23.500},
                    {"name": "Takipur (TKP) - Nalhati (NHT)", "from_km": 23.500, "to_km": 45.200}
                ]
            }
        ]
    },
    {
        "zone": "Eastern Railway",
        "zone_code": "ER",
        "division": "Sealdah (SDAH)",
        "division_code": "SDAH",
        "traffic_tier": "High_Suburban",
        "sections": [
            {
                "section": "Sealdah - Ranaghat Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Sealdah (SDAH) - Barrackpore (BP)", "from_km": 4.200, "to_km": 22.800},
                    {"name": "Barrackpore (BP) - Naihati (NH)", "from_km": 22.800, "to_km": 38.100},
                    {"name": "Naihati (NH) - Ranaghat (RHA)", "from_km": 38.100, "to_km": 73.600}
                ]
            },
            {
                "section": "Ranaghat - Gede International Corridor",
                "line_name": "Single Line (Electrified 25kV)",
                "block_sections": [
                    {"name": "Ranaghat (RHA) - Majhdia (MIJ)", "from_km": 0.000, "to_km": 24.500},
                    {"name": "Majhdia (MIJ) - Gede (GEDE)", "from_km": 24.500, "to_km": 43.800}
                ]
            },
            {
                "section": "Barasat - Bongaon Section",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Barasat (BT) - Habra (HB)", "from_km": 22.400, "to_km": 44.800},
                    {"name": "Habra (HB) - Bongaon (BNJ)", "from_km": 44.800, "to_km": 77.100}
                ]
            }
        ]
    },

    # --- NORTHERN RAILWAY (NR) ---
    {
        "zone": "Northern Railway",
        "zone_code": "NR",
        "division": "Ambala (UMB)",
        "division_code": "UMB",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Ambala Cantt - Ludhiana (UMB-LDH)",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Ambala Cantt (UMB) - Rajpura (RPJ)", "from_km": 200.500, "to_km": 228.400},
                    {"name": "Rajpura (RPJ) - Sirhind (SIR)", "from_km": 228.400, "to_km": 253.700},
                    {"name": "Sirhind (SIR) - Khanna (KNN)", "from_km": 253.700, "to_km": 271.800},
                    {"name": "Khanna (KNN) - Ludhiana (LDH)", "from_km": 271.800, "to_km": 314.200}
                ]
            },
            {
                "section": "Ludhiana - Bathinda (LDH-BTI)",
                "line_name": "Single Line (Electrified 25kV)",
                "block_sections": [
                    {"name": "Ludhiana (LDH) - Ahmedgarh (AHH)", "from_km": 0.000, "to_km": 25.400},
                    {"name": "Ahmedgarh (AHH) - Barnala (BNN)", "from_km": 25.400, "to_km": 68.900},
                    {"name": "Barnala (BNN) - Bathinda (BTI)", "from_km": 68.900, "to_km": 134.600}
                ]
            },
            {
                "section": "Ambala - Chandigarh - Kalka (UMB-CDG-KLK)",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Ambala Cantt (UMB) - Lalru (LLU)", "from_km": 0.000, "to_km": 18.200},
                    {"name": "Lalru (LLU) - Chandigarh (CDG)", "from_km": 18.200, "to_km": 44.800},
                    {"name": "Chandigarh (CDG) - Chandi Mandir (CNDM)", "from_km": 44.800, "to_km": 54.600},
                    {"name": "Chandi Mandir (CNDM) - Kalka (KLK)", "from_km": 54.600, "to_km": 68.400}
                ]
            },
            {
                "section": "Kalka - Shimla Heritage Railway (KLK-SML)",
                "line_name": "Narrow Gauge Heritage Track",
                "block_sections": [
                    {"name": "Kalka (KLK) - Dharampur (DMP)", "from_km": 0.000, "to_km": 33.100},
                    {"name": "Dharampur (DMP) - Barog (BOF)", "from_km": 33.100, "to_km": 42.800},
                    {"name": "Barog (BOF) - Solan (SOL)", "from_km": 42.800, "to_km": 53.400},
                    {"name": "Solan (SOL) - Shimla (SML)", "from_km": 53.400, "to_km": 96.600}
                ]
            },
            {
                "section": "Ambala - Saharanpur (UMB-SRE)",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Ambala Cantt (UMB) - Barara (RAA)", "from_km": 0.000, "to_km": 25.100},
                    {"name": "Barara (RAA) - Jagadhri Workshop (JUDW)", "from_km": 25.100, "to_km": 51.400},
                    {"name": "Yamunanagar Jagadhri (YJUD) - Saharanpur (SRE)", "from_km": 54.200, "to_km": 81.300}
                ]
            },
            {
                "section": "Ambala - Kurukshetra (UMB-KKDE)",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Ambala Cantt (UMB) - Shahbad Markanda (SHDM)", "from_km": 0.000, "to_km": 19.800},
                    {"name": "Shahbad Markanda (SHDM) - Kurukshetra (KKDE)", "from_km": 19.800, "to_km": 42.500}
                ]
            },
            {
                "section": "Rajpura - Bathinda (RPJ-BTI)",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Rajpura (RPJ) - Patiala (PTA)", "from_km": 0.000, "to_km": 25.200},
                    {"name": "Patiala (PTA) - Nabha (NBA)", "from_km": 25.200, "to_km": 51.000},
                    {"name": "Nabha (NBA) - Dhuri (DUI)", "from_km": 51.000, "to_km": 77.800},
                    {"name": "Dhuri (DUI) - Barnala (BNN)", "from_km": 77.800, "to_km": 108.400}
                ]
            },
            {
                "section": "Sirhind - Nangal Dam (SIR-NLDM)",
                "line_name": "Single Line",
                "block_sections": [
                    {"name": "Sirhind (SIR) - Morinda (MRND)", "from_km": 0.000, "to_km": 23.400},
                    {"name": "Morinda (MRND) - Rupnagar (RPAR)", "from_km": 23.400, "to_km": 48.600},
                    {"name": "Rupnagar (RPAR) - Nangal Dam (NLDM)", "from_km": 48.600, "to_km": 102.100}
                ]
            }
        ]
    },
    {
        "zone": "Northern Railway",
        "zone_code": "NR",
        "division": "Delhi (DLI)",
        "division_code": "DLI",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "New Delhi - Palwal Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "New Delhi (NDLS) - Hazrat Nizamuddin (NZM)", "from_km": 0.000, "to_km": 7.200},
                    {"name": "Hazrat Nizamuddin (NZM) - Tuglakabad (TKD)", "from_km": 7.200, "to_km": 17.500},
                    {"name": "Tuglakabad (TKD) - Faridabad (FDB)", "from_km": 17.500, "to_km": 28.900},
                    {"name": "Faridabad (FDB) - Palwal (PWL)", "from_km": 28.900, "to_km": 60.400}
                ]
            },
            {
                "section": "Delhi - Panipat - Ambala Corridor",
                "line_name": "DN Main Line",
                "block_sections": [
                    {"name": "Delhi (DLI) - Subzi Mandi (SZM)", "from_km": 0.000, "to_km": 3.800},
                    {"name": "Subzi Mandi (SZM) - Sonipat (SNP)", "from_km": 3.800, "to_km": 44.100},
                    {"name": "Sonipat (SNP) - Panipat (PNP)", "from_km": 44.100, "to_km": 88.900}
                ]
            }
        ]
    },

    # --- CENTRAL RAILWAY (CR) ---
    {
        "zone": "Central Railway",
        "zone_code": "CR",
        "division": "Mumbai (CSTM)",
        "division_code": "CR-BB",
        "traffic_tier": "High_Suburban_Ghat",
        "sections": [
            {
                "section": "CSMT - Kalyan Quadruple Corridor",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "CSMT - Dadar (DR)", "from_km": 0.000, "to_km": 9.100},
                    {"name": "Dadar (DR) - Thane (TNA)", "from_km": 9.100, "to_km": 33.800},
                    {"name": "Thane (TNA) - Kalyan (KYN)", "from_km": 33.800, "to_km": 53.900}
                ]
            },
            {
                "section": "Kalyan - Kasara - Igatpuri (Thal Ghat)",
                "line_name": "UP Freight Corridor",
                "block_sections": [
                    {"name": "Kalyan (KYN) - Titwala (TLA)", "from_km": 53.900, "to_km": 64.200},
                    {"name": "Titwala (TLA) - Kasara (KSRA)", "from_km": 64.200, "to_km": 120.600},
                    {"name": "Kasara (KSRA) - Igatpuri (IGP)", "from_km": 120.600, "to_km": 136.500}
                ]
            },
            {
                "section": "Kalyan - Karjat (Bhor Ghat Approach)",
                "line_name": "DN Main Line",
                "block_sections": [
                    {"name": "Kalyan (KYN) - Badlapur (BUD)", "from_km": 53.900, "to_km": 67.800},
                    {"name": "Badlapur (BUD) - Karjat (KJT)", "from_km": 67.800, "to_km": 100.200}
                ]
            }
        ]
    },
    {
        "zone": "Central Railway",
        "zone_code": "CR",
        "division": "Bhusawal (BSL)",
        "division_code": "CR-BSL",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Igatpuri - Manmad - Bhusawal",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Igatpuri (IGP) - Nashik Road (NK)", "from_km": 136.500, "to_km": 187.200},
                    {"name": "Nashik Road (NK) - Manmad (MMR)", "from_km": 187.200, "to_km": 260.800},
                    {"name": "Manmad (MMR) - Chalisgaon (CSN)", "from_km": 260.800, "to_km": 328.400},
                    {"name": "Chalisgaon (CSN) - Bhusawal (BSL)", "from_km": 328.400, "to_km": 423.600}
                ]
            }
        ]
    },

    # --- WESTERN RAILWAY (WR) ---
    {
        "zone": "Western Railway",
        "zone_code": "WR",
        "division": "Mumbai Central (MMCT)",
        "division_code": "WR-BCT",
        "traffic_tier": "High_Suburban_Corridor",
        "sections": [
            {
                "section": "Churchgate - Virar - Dahanu Road",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Borivali (BVI) - Bhayandar (BYR)", "from_km": 34.100, "to_km": 43.500},
                    {"name": "Bhayandar (BYR) - Virar (VR)", "from_km": 43.500, "to_km": 60.100},
                    {"name": "Virar (VR) - Palghar (PLG)", "from_km": 60.100, "to_km": 87.300},
                    {"name": "Palghar (PLG) - Dahanu Road (DRD)", "from_km": 87.300, "to_km": 124.200}
                ]
            }
        ]
    },
    {
        "zone": "Western Railway",
        "zone_code": "WR",
        "division": "Vadodara (BRC)",
        "division_code": "WR-BRC",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Surat - Vadodara Golden Corridor",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Surat (ST) - Kosamba (KSB)", "from_km": 263.000, "to_km": 294.200},
                    {"name": "Kosamba (KSB) - Bharuch (BH)", "from_km": 294.200, "to_km": 322.500},
                    {"name": "Bharuch (BH) - Vadodara (BRC)", "from_km": 322.500, "to_km": 392.100}
                ]
            }
        ]
    },

    # --- NORTH CENTRAL RAILWAY (NCR) ---
    {
        "zone": "North Central Railway",
        "zone_code": "NCR",
        "division": "Prayagraj (PRYJ)",
        "division_code": "NCR-PRYJ",
        "traffic_tier": "High_Speed_Mainline",
        "sections": [
            {
                "section": "Kanpur - Prayagraj - Pt. Deen Dayal Upadhyaya",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Kanpur Central (CNB) - Fatehpur (FTP)", "from_km": 0.000, "to_km": 78.400},
                    {"name": "Fatehpur (FTP) - Subedarganj (SFG)", "from_km": 78.400, "to_km": 188.100},
                    {"name": "Prayagraj (PRYJ) - Mirzapur (MZP)", "from_km": 194.500, "to_km": 283.400},
                    {"name": "Mirzapur (MZP) - Pt. DDU Jn (DDU)", "from_km": 283.400, "to_km": 346.800}
                ]
            }
        ]
    },
    {
        "zone": "North Central Railway",
        "zone_code": "NCR",
        "division": "Jhansi (VGLJ)",
        "division_code": "NCR-JHS",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Agra - Gwalior - Jhansi - Bina",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Agra Cantt (AGC) - Dholpur (DHO)", "from_km": 0.000, "to_km": 54.200},
                    {"name": "Dholpur (DHO) - Gwalior (GWL)", "from_km": 54.200, "to_km": 118.600},
                    {"name": "Gwalior (GWL) - VGL Jhansi (VGLJ)", "from_km": 118.600, "to_km": 216.000},
                    {"name": "VGL Jhansi (VGLJ) - Lalitpur (LAR)", "from_km": 216.000, "to_km": 306.400},
                    {"name": "Lalitpur (LAR) - Bina (BINA)", "from_km": 306.400, "to_km": 369.200}
                ]
            }
        ]
    },

    # --- SOUTHERN RAILWAY (SR) ---
    {
        "zone": "Southern Railway",
        "zone_code": "SR",
        "division": "Chennai (MAS)",
        "division_code": "SR-MAS",
        "traffic_tier": "High_Passenger",
        "sections": [
            {
                "section": "Chennai Central - Arakkonam Trunk Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Chennai Central (MAS) - Perambur (PER)", "from_km": 0.000, "to_km": 5.400},
                    {"name": "Perambur (PER) - Tiruvallur (TRL)", "from_km": 5.400, "to_km": 41.800},
                    {"name": "Tiruvallur (TRL) - Arakkonam (AJJ)", "from_km": 41.800, "to_km": 68.600}
                ]
            },
            {
                "section": "Chennai Beach - Chengalpattu Suburban",
                "line_name": "UP Loop Line",
                "block_sections": [
                    {"name": "Chennai Beach (MSB) - Tambaram (TBM)", "from_km": 0.000, "to_km": 29.100},
                    {"name": "Tambaram (TBM) - Chengalpattu (CGL)", "from_km": 29.100, "to_km": 59.800}
                ]
            }
        ]
    },
    {
        "zone": "Southern Railway",
        "zone_code": "SR",
        "division": "Palakkad (PGT)",
        "division_code": "SR-PGT",
        "traffic_tier": "Medium_Coastal_Monsoon",
        "sections": [
            {
                "section": "Palakkad - Shoranur - Kozhikode",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Palakkad (PGT) - Ottappalam (OTP)", "from_km": 0.000, "to_km": 31.400},
                    {"name": "Ottappalam (OTP) - Shoranur (SRR)", "from_km": 31.400, "to_km": 44.800},
                    {"name": "Shoranur (SRR) - Tirur (TIR)", "from_km": 44.800, "to_km": 89.200},
                    {"name": "Tirur (TIR) - Kozhikode (CLT)", "from_km": 89.200, "to_km": 130.600}
                ]
            }
        ]
    },

    # --- SOUTH CENTRAL RAILWAY (SCR) ---
    {
        "zone": "South Central Railway",
        "zone_code": "SCR",
        "division": "Secunderabad (SC)",
        "division_code": "SCR-SC",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Secunderabad - Kazipet Grand Trunk",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Secunderabad (SC) - Bhongir (BG)", "from_km": 0.000, "to_km": 46.800},
                    {"name": "Bhongir (BG) - Jangaon (ZN)", "from_km": 46.800, "to_km": 84.100},
                    {"name": "Jangaon (ZN) - Kazipet (KZJ)", "from_km": 84.100, "to_km": 131.500}
                ]
            }
        ]
    },
    {
        "zone": "South Central Railway",
        "zone_code": "SCR",
        "division": "Vijayawada (BZA)",
        "division_code": "SCR-BZA",
        "traffic_tier": "High_Freight_Coal",
        "sections": [
            {
                "section": "Kazipet - Vijayawada - Gudur Coastal Corridor",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Kazipet (KZJ) - Khammam (KMT)", "from_km": 0.000, "to_km": 118.200},
                    {"name": "Khammam (KMT) - Vijayawada (BZA)", "from_km": 118.200, "to_km": 216.500},
                    {"name": "Vijayawada (BZA) - Tenali (TEL)", "from_km": 216.500, "to_km": 247.600},
                    {"name": "Tenali (TEL) - Ongole (OGL)", "from_km": 247.600, "to_km": 354.200}
                ]
            }
        ]
    },

    # --- SOUTH EASTERN RAILWAY (SER) ---
    {
        "zone": "South Eastern Railway",
        "zone_code": "SER",
        "division": "Kharagpur (KGP)",
        "division_code": "SER-KGP",
        "traffic_tier": "High_Freight_Steel",
        "sections": [
            {
                "section": "Howrah - Kharagpur Quadruple Trunk",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Santragachi (SRC) - Uluberia (ULB)", "from_km": 7.800, "to_km": 32.100},
                    {"name": "Uluberia (ULB) - Mecheda (MCA)", "from_km": 32.100, "to_km": 58.400},
                    {"name": "Mecheda (MCA) - Kharagpur (KGP)", "from_km": 58.400, "to_km": 115.600}
                ]
            },
            {
                "section": "Kharagpur - Tatanagar Steel Link",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Kharagpur (KGP) - Jhargram (JGM)", "from_km": 0.000, "to_km": 39.400},
                    {"name": "Jhargram (JGM) - Ghatsila (GTS)", "from_km": 39.400, "to_km": 96.200},
                    {"name": "Ghatsila (GTS) - Tatanagar (TATA)", "from_km": 96.200, "to_km": 134.800}
                ]
            }
        ]
    },

    # --- EAST COAST RAILWAY (ECoR) ---
    {
        "zone": "East Coast Railway",
        "zone_code": "ECoR",
        "division": "Khurda Road (KUR)",
        "division_code": "ECoR-KUR",
        "traffic_tier": "High_Mineral_Coal",
        "sections": [
            {
                "section": "Bhadrak - Cuttack - Bhubaneswar - Khurda Road",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Bhadrak (BHC) - Jajpur Keonjhar Road (JJKR)", "from_km": 0.000, "to_km": 43.600},
                    {"name": "Jajpur (JJKR) - Cuttack (CTC)", "from_km": 43.600, "to_km": 115.800},
                    {"name": "Cuttack (CTC) - Bhubaneswar (BBS)", "from_km": 115.800, "to_km": 143.400},
                    {"name": "Bhubaneswar (BBS) - Khurda Road (KUR)", "from_km": 143.400, "to_km": 162.900}
                ]
            }
        ]
    },

    # --- SOUTH EAST CENTRAL RAILWAY (SECR) ---
    {
        "zone": "South East Central Railway",
        "zone_code": "SECR",
        "division": "Bilaspur (BSP)",
        "division_code": "SECR-BSP",
        "traffic_tier": "High_Heavy_Haul_Coal",
        "sections": [
            {
                "section": "Bilaspur - Raipur - Durg Industrial Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Bilaspur (BSP) - Bhatapara (BYT)", "from_km": 0.000, "to_km": 46.800},
                    {"name": "Bhatapara (BYT) - Raipur (R)", "from_km": 46.800, "to_km": 110.500},
                    {"name": "Raipur (R) - Durg (DURG)", "from_km": 110.500, "to_km": 147.900}
                ]
            }
        ]
    },

    # --- NORTH WESTERN RAILWAY (NWR) ---
    {
        "zone": "North Western Railway",
        "zone_code": "NWR",
        "division": "Jaipur (JP)",
        "division_code": "NWR-JP",
        "traffic_tier": "Medium_Desert_High_Thermal",
        "sections": [
            {
                "section": "Delhi - Rewari - Jaipur Section",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Rewari (RE) - Alwar (AWR)", "from_km": 0.000, "to_km": 74.500},
                    {"name": "Alwar (AWR) - Bandikui (BKI)", "from_km": 74.500, "to_km": 134.800},
                    {"name": "Bandikui (BKI) - Jaipur (JP)", "from_km": 134.800, "to_km": 224.600}
                ]
            }
        ]
    },

    # --- WEST CENTRAL RAILWAY (WCR) ---
    {
        "zone": "West Central Railway",
        "zone_code": "WCR",
        "division": "Jabalpur (JBP)",
        "division_code": "WCR-JBP",
        "traffic_tier": "High_Mainline",
        "sections": [
            {
                "section": "Itarsi - Jabalpur Trunk Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Itarsi (ET) - Pipariya (PPI)", "from_km": 0.000, "to_km": 67.200},
                    {"name": "Pipariya (PPI) - Narsinghpur (NU)", "from_km": 67.200, "to_km": 160.800},
                    {"name": "Narsinghpur (NU) - Jabalpur (JBP)", "from_km": 160.800, "to_km": 244.500}
                ]
            }
        ]
    },

    # --- SOUTH WESTERN RAILWAY (SWR) ---
    {
        "zone": "South Western Railway",
        "zone_code": "SWR",
        "division": "Bengaluru (SBC)",
        "division_code": "SWR-SBC",
        "traffic_tier": "High_Passenger",
        "sections": [
            {
                "section": "Bengaluru - Jolarpettai Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "KSR Bengaluru (SBC) - Krishnarajapuram (KJM)", "from_km": 0.000, "to_km": 14.200},
                    {"name": "Krishnarajapuram (KJM) - Bangarapet (BWT)", "from_km": 14.200, "to_km": 70.500},
                    {"name": "Bangarapet (BWT) - Jolarpettai (JTJ)", "from_km": 70.500, "to_km": 145.200}
                ]
            },
            {
                "section": "Bengaluru - Mysuru Double Line",
                "line_name": "DN Main Line",
                "block_sections": [
                    {"name": "KSR Bengaluru (SBC) - Ramanagaram (RMGM)", "from_km": 0.000, "to_km": 44.500},
                    {"name": "Ramanagaram (RMGM) - Mandya (MYA)", "from_km": 44.500, "to_km": 93.100},
                    {"name": "Mandya (MYA) - Mysuru (MYS)", "from_km": 93.100, "to_km": 137.600}
                ]
            }
        ]
    },

    # --- NORTH EASTERN RAILWAY (NER) ---
    {
        "zone": "North Eastern Railway",
        "zone_code": "NER",
        "division": "Varanasi (BSB)",
        "division_code": "NER-BSB",
        "traffic_tier": "Medium_Passenger",
        "sections": [
            {
                "section": "Gorakhpur - Chhapra Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "Gorakhpur (GKP) - Deoria Sadar (DEOS)", "from_km": 0.000, "to_km": 49.600},
                    {"name": "Deoria Sadar (DEOS) - Bhatni (BTT)", "from_km": 49.600, "to_km": 70.400},
                    {"name": "Bhatni (BTT) - Siwan (SV)", "from_km": 70.400, "to_km": 119.800},
                    {"name": "Siwan (SV) - Chhapra (CPR)", "from_km": 119.800, "to_km": 180.500}
                ]
            }
        ]
    },

    # --- NORTHEAST FRONTIER RAILWAY (NFR) ---
    {
        "zone": "Northeast Frontier Railway",
        "zone_code": "NFR",
        "division": "Katihar (KIR)",
        "division_code": "NFR-KIR",
        "traffic_tier": "Medium_High_Monsoon_Flooding",
        "sections": [
            {
                "section": "New Jalpaiguri - New Cooch Behar Main Line",
                "line_name": "UP Main Line",
                "block_sections": [
                    {"name": "New Jalpaiguri (NJP) - Jalpaiguri Road (JPE)", "from_km": 0.000, "to_km": 34.200},
                    {"name": "Jalpaiguri Road (JPE) - Dhupguri (DQG)", "from_km": 34.200, "to_km": 66.800},
                    {"name": "Dhupguri (DQG) - New Cooch Behar (NCB)", "from_km": 66.800, "to_km": 126.400}
                ]
            }
        ]
    }
]


# ==============================================================================
# 2. DOMAIN-AWARE MAINTENANCE & DEFECT TAXONOMY (SECTIONS 7, 8, 11)
# ==============================================================================

MAINTENANCE_ACTIVITIES = [
    {
        "work_type": "Tamping Machine (CSM) Deployment",
        "maintenance_type": "Preventive Tamping",
        "maintenance_category": "Preventive Track Maintenance",
        "machine": "CSM Tamping Machine (CSM-952)",
        "crew_size_range": (6, 10),
        "duration_range": (120, 180),
        "block_type": "Planned Rolling Block",
        "speed_restriction_range": (45, 60),
        "power_block_prob": 0.85,
        "st_discon_prob": 0.90,
        "defect_types": [
            "Track Geometry Irregularity", "Cross Level Deviation",
            "Alignment Variation", "Differential Ballast Settlement"
        ],
        "cost_base": 85000,
        "cost_mult": 1.4
    },
    {
        "work_type": "Points & Crossing Tamping (UNIMAT)",
        "maintenance_type": "Turnout Tamping",
        "maintenance_category": "Preventive Track Maintenance",
        "machine": "UNIMAT Points & Crossing Tamping Machine",
        "crew_size_range": (6, 9),
        "duration_range": (90, 150),
        "block_type": "Planned Rolling Block",
        "speed_restriction_range": (30, 45),
        "power_block_prob": 0.70,
        "st_discon_prob": 0.95,
        "defect_types": [
            "Turnout Alignment Deviation", "Switch Rail Wear",
            "Cross Level Defect on Points", "Check Rail Clearance Error"
        ],
        "cost_base": 115000,
        "cost_mult": 1.5
    },
    {
        "work_type": "Ballast Cleaning Machine (BCM) Deep Screening",
        "maintenance_type": "Ballast Deep Screening",
        "maintenance_category": "Major Track Maintenance",
        "machine": "Ballast Cleaning Machine (BCM-083)",
        "crew_size_range": (10, 16),
        "duration_range": (210, 300),
        "block_type": "Planned Corridor Block",
        "speed_restriction_range": (20, 30),
        "power_block_prob": 0.95,
        "st_discon_prob": 0.95,
        "defect_types": [
            "Ballast Fouling", "Poor Ballast Resilience",
            "Drainage Failure Under Track", "Mud Pumping Under Sleepers"
        ],
        "cost_base": 340000,
        "cost_mult": 2.2
    },
    {
        "work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)",
        "maintenance_type": "Ballast Regulation & Stabilization",
        "maintenance_category": "Preventive Track Maintenance",
        "machine": "Dynamic Track Stabilizer + BRM-721",
        "crew_size_range": (5, 8),
        "duration_range": (90, 150),
        "block_type": "Planned Rolling Block",
        "speed_restriction_range": (50, 75),
        "power_block_prob": 0.40,
        "st_discon_prob": 0.30,
        "defect_types": [
            "Ballast Deficiency on Shoulder", "Loose Packing Post-Screening",
            "Lateral Track Instability", "Uneven Ballast Profile"
        ],
        "cost_base": 72000,
        "cost_mult": 1.2
    },
    {
        "work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion",
        "maintenance_type": "Rail Renewal",
        "maintenance_category": "Major Track Maintenance",
        "machine": "Through Rail Renewal Unit + Flash Butt Welding Plant",
        "crew_size_range": (12, 20),
        "duration_range": (180, 270),
        "block_type": "Planned Mega Block",
        "speed_restriction_range": (30, 45),
        "power_block_prob": 0.95,
        "st_discon_prob": 0.95,
        "defect_types": [
            "Severe Rail Head Wear", "Fatigue Rail Cracking",
            "Cumulative GMT Exceeded", "Thermit Weld Failure Series"
        ],
        "cost_base": 580000,
        "cost_mult": 2.5
    },
    {
        "work_type": "Rail Grinding Machine (RGM) Operations",
        "maintenance_type": "Rail Grinding",
        "maintenance_category": "Preventive Track Maintenance",
        "machine": "Rail Grinding Machine (RGM-72 Stone)",
        "crew_size_range": (8, 12),
        "duration_range": (150, 240),
        "block_type": "Night Traffic Block",
        "speed_restriction_range": (60, 75),
        "power_block_prob": 0.85,
        "st_discon_prob": 0.40,
        "defect_types": [
            "Rail Corrugation", "Rolling Contact Fatigue (RCF)",
            "Head Checking Micro-Cracks", "Wheel Burn Defects"
        ],
        "cost_base": 240000,
        "cost_mult": 1.6
    },
    {
        "work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)",
        "maintenance_type": "Corrective Rail Repair",
        "maintenance_category": "Corrective Maintenance",
        "machine": "Digital USFD Tester + Hydraulic Rail Tensor",
        "crew_size_range": (6, 10),
        "duration_range": (90, 150),
        "block_type": "Urgent Maintenance Block",
        "speed_restriction_range": (30, 50),
        "power_block_prob": 0.70,
        "st_discon_prob": 0.80,
        "defect_types": [
            "Internal Rail Flaw (IMR/OBS Defect)", "Squat Defect Propagation",
            "Thermit Weld Crack", "Horizontal Split Web Defect"
        ],
        "cost_base": 65000,
        "cost_mult": 1.3
    },
    {
        "work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)",
        "maintenance_type": "Turnout Renewal",
        "maintenance_category": "Major Track Maintenance",
        "machine": "T-28 Turnout Renewal Crane System",
        "crew_size_range": (14, 22),
        "duration_range": (240, 360),
        "block_type": "Planned Mega Block",
        "speed_restriction_range": (20, 30),
        "power_block_prob": 0.95,
        "st_discon_prob": 0.95,
        "defect_types": [
            "Worn Out Tongue & Stock Rail Assembly", "Cracked Cast Manganese Steel (CMS) Crossing",
            "Damaged Sleeper Bed on Turnout", "Switch Detection Failure Recurrence"
        ],
        "cost_base": 780000,
        "cost_mult": 2.8
    },
    {
        "work_type": "Through Sleeper Renewal (TSR) & Fastening Overhaul",
        "maintenance_type": "Sleeper Replacement",
        "maintenance_category": "Major Track Maintenance",
        "machine": "Hydraulic Sleeper Exchanger + Torque Wrench Unit",
        "crew_size_range": (10, 18),
        "duration_range": (180, 240),
        "block_type": "Planned Corridor Block",
        "speed_restriction_range": (30, 45),
        "power_block_prob": 0.60,
        "st_discon_prob": 0.75,
        "defect_types": [
            "Cracked PSC Sleepers", "Loose Elastic Rail Clips (ERC)",
            "Corroded Liners & Rubber Pads", "Sleeper Seat Cavitation"
        ],
        "cost_base": 185000,
        "cost_mult": 1.7
    },
    {
        "work_type": "Emergency Rail Fracture Restoration & Clamp Securing",
        "maintenance_type": "Emergency Restoration",
        "maintenance_category": "Emergency Maintenance",
        "machine": "Portable Abrasive Rail Cutter + Emergency Clamping Rig",
        "crew_size_range": (8, 14),
        "duration_range": (60, 120),
        "block_type": "Urgent Maintenance Block",
        "speed_restriction_range": (20, 30),
        "power_block_prob": 0.80,
        "st_discon_prob": 0.90,
        "defect_types": [
            "Complete Rail Fracture", "Sudden Thermit Weld Shearing",
            "Buckled Track Joint", "Bolt Hole Radial Crack"
        ],
        "cost_base": 95000,
        "cost_mult": 2.0
    },
    {
        "work_type": "Track Recording Car (TRC) High Speed Geometry Inspection",
        "maintenance_type": "Track Recording Car Inspection",
        "maintenance_category": "Routine Inspection",
        "machine": "High Speed Track Recording Car (TRC-624)",
        "crew_size_range": (4, 6),
        "duration_range": (60, 90),
        "block_type": "Planned Rolling Block",
        "speed_restriction_range": (75, 100),
        "power_block_prob": 0.05,
        "st_discon_prob": 0.05,
        "defect_types": [
            "Periodic Track Quality Index (TQI) Profiling", "Twist Irregularity Mapping",
            "Gauge Acceleration Spikes", "Dynamic Oscillation Verification"
        ],
        "cost_base": 18000,
        "cost_mult": 1.0
    },
    {
        "work_type": "Monsoon Embankment Scour Protection & Cess Drain Restructuring",
        "maintenance_type": "Drainage Cleaning & Cess Repair",
        "maintenance_category": "Preventive Track Maintenance",
        "machine": "Backhoe Loader Excavator + Cess Trimming Unit",
        "crew_size_range": (8, 14),
        "duration_range": (120, 180),
        "block_type": "Planned Corridor Block",
        "speed_restriction_range": (45, 60),
        "power_block_prob": 0.20,
        "st_discon_prob": 0.15,
        "defect_types": [
            "Waterlogging in Cutting", "Embankment Sloughing & Erosion",
            "Choked Side Catchwater Drains", "Subgrade Soft Soil Pumping"
        ],
        "cost_base": 88000,
        "cost_mult": 1.3
    }
]


# ==============================================================================
# 3. STATISTICAL & DOMAIN-AWARE SYNTHESIS GENERATOR
# ==============================================================================

def generate_record(seq_id, network_item):
    """
    Synthesizes a single domain-consistent, realistic TMS maintenance history record.
    Implements multi-variable physical correlations across track age, traffic, weather,
    machine matching, costs, and ML predictive indicators.
    """
    zone_name = network_item["zone"]
    division_name = network_item["division"]
    division_code = network_item["division_code"]
    traffic_tier = network_item["traffic_tier"]

    # Choose section & block section
    section_item = random.choice(network_item["sections"])
    section_name = section_item["section"]
    block_item = random.choice(section_item["block_sections"])
    block_section_name = block_item["name"]
    line_name = section_item.get("line_name", "UP Main Line")

    # Date distribution across 2020-01-01 to 2025-12-31
    start_date = date(2020, 1, 1)
    end_date = date(2025, 12, 31)
    days_range = (end_date - start_date).days
    event_date = start_date + timedelta(days=random.randint(0, days_range))
    month = event_date.month

    # Seasonality
    is_monsoon = month in [6, 7, 8, 9]
    is_summer = month in [4, 5]
    is_winter = month in [12, 1, 2]

    # Filter activity based on season / topology
    activity_pool = list(MAINTENANCE_ACTIVITIES)
    if is_monsoon:
        # Higher weight to drainage, ballast cleaning, rail replacement
        weights = [1.5 if "Drain" in a["work_type"] or "Ballast" in a["work_type"] else 1.0 for a in activity_pool]
    elif is_summer:
        # Higher weight to rail renewal, fracture, grinding (thermal stresses)
        weights = [1.6 if "Rail" in a["work_type"] or "Grinding" in a["work_type"] else 1.0 for a in activity_pool]
    elif is_winter:
        # Higher weight to fracture, USFD, tamping
        weights = [1.8 if "Fracture" in a["work_type"] or "USFD" in a["work_type"] else 1.0 for a in activity_pool]
    else:
        weights = [1.0] * len(activity_pool)

    # Hill railway adjustment (Kalka-Shimla)
    if "Narrow Gauge" in line_name:
        # Tamping on narrow gauge uses light tamping, manual or smaller machine
        activity = random.choice([a for a in activity_pool if "Mega Block" not in a["block_type"]])
    else:
        activity = random.choices(activity_pool, weights=weights, k=1)[0]

    work_type = activity["work_type"]
    maint_type = activity["maintenance_type"]
    maint_cat = activity["maintenance_category"]
    demand_nature = activity["block_type"]

    # Physical track characteristics
    is_heritage_ng = "Narrow Gauge" in line_name
    if is_heritage_ng:
        gauge_name = "Narrow Gauge (762 mm)"
        rail_type = "Legacy 30 lb/yd Rail"
        sleeper_type = random.choice(["Wooden Sleeper (Sal Wood)", "Steel Trough Sleeper"])
        traffic_trains_per_day = random.randint(4, 12)
        freight_pct = 5.0
        track_age_years = random.randint(18, 45)
    else:
        gauge_name = "Broad Gauge (1676 mm)"
        rail_type = random.choice(["60 kg/m UIC Rail (90 UTS)", "60 kg/m R260 Rail", "52 kg/m Rail"])
        sleeper_type = "Prestressed Concrete Sleeper (PSC-RT2496)"
        if "Heavy_Haul" in traffic_tier or "Freight" in traffic_tier:
            traffic_trains_per_day = random.randint(70, 140)
            freight_pct = round(random.uniform(55.0, 85.0), 1)
        elif "Suburban" in traffic_tier:
            traffic_trains_per_day = random.randint(120, 190)
            freight_pct = round(random.uniform(10.0, 30.0), 1)
        else:
            traffic_trains_per_day = random.randint(50, 110)
            freight_pct = round(random.uniform(30.0, 60.0), 1)
        track_age_years = random.randint(2, 28)

    rail_age_years = max(1, int(track_age_years * random.uniform(0.4, 0.85)))
    sleeper_age_years = max(1, int(track_age_years * random.uniform(0.6, 0.95)))

    # Correlation: Track Age & Wear -> Geometry Degradation
    age_factor = min(1.8, max(0.6, track_age_years / 15.0))
    traffic_factor = min(1.7, max(0.7, traffic_trains_per_day / 80.0))
    degradation_scale = age_factor * traffic_factor

    gauge_var = round(random.uniform(0.8, 3.2) * degradation_scale, 2)
    align_var = round(random.uniform(1.0, 3.5) * degradation_scale, 2)
    cross_level = round(random.uniform(1.2, 3.8) * degradation_scale, 2)
    twist_mm = round(random.uniform(0.8, 2.8) * degradation_scale, 2)
    rail_wear_pct = round(min(42.0, random.uniform(3.0, 14.0) * (rail_age_years / 7.0)), 1)

    # Track Condition Score (TQI based, 100 = perfect, lower = degraded)
    raw_condition = 100.0 - (gauge_var * 4.2 + align_var * 3.8 + cross_level * 3.5 + twist_mm * 4.0 + rail_wear_pct * 0.4)
    condition_score = round(max(38.0, min(97.5, raw_condition + random.uniform(-3.0, 3.0))), 1)

    # Weather Parameters
    if is_monsoon:
        weather_cond = "Monsoon Heavy Rain"
        rainfall_mm = round(random.uniform(65.0, 240.0), 1)
        temp_c = round(random.uniform(26.0, 32.0), 1)
    elif is_summer:
        weather_cond = "Intense Summer Heat"
        rainfall_mm = round(random.uniform(0.0, 12.0), 1)
        temp_c = round(random.uniform(36.0, 46.5), 1)
    elif is_winter:
        weather_cond = "Cold Wave Foggy"
        rainfall_mm = round(random.uniform(0.0, 8.0), 1)
        temp_c = round(random.uniform(5.0, 18.0), 1)
    else:
        weather_cond = "Clear Pleasant"
        rainfall_mm = round(random.uniform(0.0, 25.0), 1)
        temp_c = round(random.uniform(22.0, 31.0), 1)

    # Duration & Time Windows
    dur_min = random.randint(activity["duration_range"][0], activity["duration_range"][1])
    dur_min = int(round(dur_min / 15.0) * 15)  # round to nearest 15 mins

    # Preferred start time based on block type
    if demand_nature == "Night Traffic Block":
        start_hour = random.choice([0, 1, 2])
        start_min = random.choice([0, 15, 30])
    elif "Corridor" in demand_nature or "Mega" in demand_nature:
        start_hour = random.choice([10, 11, 12, 13])
        start_min = random.choice([0, 30])
    else:
        start_hour = random.choice([11, 12, 13, 14, 15])
        start_min = random.choice([0, 15, 30, 45])

    pref_start = time(start_hour, start_min)
    pref_start_dt = datetime.combine(event_date, pref_start)
    pref_end_dt = pref_start_dt + timedelta(minutes=dur_min)
    pref_end = pref_end_dt.time()

    # Interdepartmental dependencies
    power_block = random.random() < activity["power_block_prob"]
    st_discon = random.random() < activity["st_discon_prob"]

    # Speed Restriction Post Work
    post_speed = random.choice(
        [20, 30, 45, 50, 60] if "Renewal" in work_type or "Deep" in work_type else [50, 60, 75]
    )

    # Defect Details
    defect_type = random.choice(activity["defect_types"])
    if "Emergency" in maint_cat or condition_score < 55:
        defect_severity = "Critical"
        maint_priority = "Emergency" if "Emergency" in maint_cat else "Critical"
    elif condition_score < 70 or "Renewal" in work_type:
        defect_severity = "High"
        maint_priority = "High"
    elif condition_score < 84:
        defect_severity = "Medium"
        maint_priority = "Medium"
    else:
        defect_severity = "Low"
        maint_priority = "Routine"

    # Costs (INR) correlated with machine hours, duration, material
    cost_base = activity["cost_base"]
    dur_factor = dur_min / 150.0
    material_cost = int(round(cost_base * 0.45 * dur_factor * random.uniform(0.85, 1.25)))
    machine_cost = int(round(cost_base * 0.35 * dur_factor * random.uniform(0.90, 1.20)))
    crew_size = random.randint(activity["crew_size_range"][0], activity["crew_size_range"][1])
    labor_cost = int(round(crew_size * (dur_min / 60.0) * 850 * random.uniform(0.90, 1.15)))
    total_cost = material_cost + machine_cost + labor_cost

    # ML Target Variables
    # Risk score between 15 and 95
    base_risk = (100.0 - condition_score) * 0.85 + (rail_wear_pct * 0.45) + (freight_pct * 0.15)
    if is_summer and "Rail" in work_type:
        base_risk += 8.5
    if is_monsoon and ("Drain" in work_type or "Ballast" in work_type):
        base_risk += 6.5
    risk_score = round(max(12.0, min(95.8, base_risk + random.uniform(-4.0, 4.0))), 1)

    # Predicted failure probability (sigmoid calibrated)
    prob_x = (risk_score - 55.0) / 12.0
    pred_fail_prob = round(1.0 / (1.0 + math.exp(-prob_x)), 3)

    # Did failure actually occur prior to this maintenance?
    # Emergency activities: 92% failure occurred; High risk: ~25-40%; Routine: ~3%
    if "Emergency" in maint_cat:
        failure_occurred = True
    elif risk_score > 75:
        failure_occurred = random.random() < 0.42
    elif risk_score > 60:
        failure_occurred = random.random() < 0.16
    else:
        failure_occurred = random.random() < 0.03

    days_until_next = random.randint(7, 45) if risk_score > 70 else random.randint(45, 180)
    days_since_last = random.randint(14, 280)
    freq_last_12m = random.randint(2, 9) if traffic_trains_per_day > 90 else random.randint(1, 4)

    # Location KM Boundaries
    f_km = block_item["from_km"] + round(random.uniform(0.2, 1.5), 3)
    t_km = min(block_item["to_km"], f_km + round(random.uniform(1.2, 3.8), 3))

    # Requisitioning Officer
    officer_emp_id = str(random.randint(1045000, 1089000))
    officer_phone = f"97{random.randint(10000000, 99999999)}"
    div_clean = division_code.replace("-", "_")
    designation = f"SSE_PWAY_{div_clean}_{random.choice(['NORTH', 'SOUTH', 'MAIN', 'CENTRAL'])}"

    # Unique Demand Reference ID
    year_str = str(event_date.year)
    demand_ref_id = f"TMS/{div_clean}/{year_str}/MH/{seq_id:05d}"

    # Nested Rich Payload matching schema and prompt requirements
    payload = {
        "source_system": "TMS_CIVIL_ENGG",
        "demand_ref_id": demand_ref_id,
        "requisitioning_officer": {
            "emp_id": officer_emp_id,
            "designation": designation,
            "mobile": officer_phone
        },
        "location_details": {
            "zone": zone_name,
            "zone_code": network_item["zone_code"],
            "division": division_name,
            "division_code": division_code,
            "section": section_name,
            "block_section": block_section_name,
            "line": line_name,
            "from_km": f"{f_km:.3f}",
            "to_km": f"{t_km:.3f}"
        },
        "maintenance_details": {
            "maintenance_type": maint_type,
            "maintenance_category": maint_cat,
            "maintenance_date": event_date.isoformat(),
            "work_type": work_type,
            "defect_type": defect_type,
            "defect_severity": defect_severity,
            "machine_used": activity["machine"],
            "crew_size": crew_size
        },
        "track_condition": {
            "gauge_variation_mm": gauge_var,
            "alignment_variation_mm": align_var,
            "cross_level_mm": cross_level,
            "twist_mm": twist_mm,
            "rail_wear_percentage": rail_wear_pct,
            "track_condition_score": condition_score,
            "gauge_standard": gauge_name,
            "rail_section": rail_type,
            "sleeper_type": sleeper_type
        },
        "block_specifications": {
            "block_required": True,
            "block_type": demand_nature,
            "duration_minutes": dur_min,
            "power_block_required": power_block,
            "st_disconnection_required": st_discon,
            "preferred_date": event_date.isoformat(),
            "requested_window": {
                "preferred_start": pref_start.strftime("%H:%M"),
                "preferred_end": pref_end.strftime("%H:%M"),
                "duration_minutes": dur_min
            }
        },
        "interdepartmental_dependencies": {
            "power_block_required": power_block,
            "trd_details": (
                f"25kV OHE isolation & grounding between KM {f_km:.2f} - {t_km:.2f}"
                if power_block else "No TRD power shutoff needed"
            ),
            "st_disconnection_required": st_discon,
            "st_details": (
                "Axle counter bonding & point motor disconnection with S&T SSE"
                if st_discon else "Normal signaling intact"
            )
        },
        "speed_restriction_proposed": {
            "post_work_speed_kmph": post_speed,
            "normal_speed_restoration_hrs": 48 if post_speed >= 45 else 72
        },
        "operational_context": {
            "track_age_years": track_age_years,
            "rail_age_years": rail_age_years,
            "sleeper_age_years": sleeper_age_years,
            "average_daily_train_count": traffic_trains_per_day,
            "freight_train_percentage": freight_pct,
            "days_since_last_maintenance": days_since_last,
            "maintenance_frequency_last_12_months": freq_last_12m,
            "weather_condition": weather_cond,
            "rainfall_mm": rainfall_mm,
            "temperature_celsius": temp_c
        },
        "maintenance_cost": {
            "material_cost_inr": material_cost,
            "labor_cost_inr": labor_cost,
            "machine_cost_inr": machine_cost,
            "total_cost_inr": total_cost
        },
        "ml_features": {
            "risk_score": risk_score,
            "predicted_failure_probability": pred_fail_prob,
            "failure_occurred": failure_occurred,
            "maintenance_priority": maint_priority,
            "days_until_next_failure": days_until_next
        }
    }

    # Flat tuple matching tms_civil_demands SQL columns:
    # demand_ref_id, source_system, division, section, block_section, line_name,
    # work_type, demand_nature, preferred_date, duration_minutes,
    # preferred_start, preferred_end, power_block_required, st_disconnection_required,
    # post_work_speed_kmph, payload
    record_tuple = (
        demand_ref_id,
        "TMS_CIVIL_ENGG",
        division_name,
        section_name,
        block_section_name,
        line_name,
        work_type,
        demand_nature,
        event_date,
        dur_min,
        pref_start,
        pref_end,
        power_block,
        st_discon,
        post_speed,
        json.dumps(payload)
    )

    return record_tuple, payload


# ==============================================================================
# 4. MAIN ORCHESTRATION & SAFE BATCH INSERTION
# ==============================================================================

def main():
    print("=" * 75)
    print("      IMBPS REALISTIC TMS MAINTENANCE HISTORY SYNTHESIS & INGESTION")
    print("                Indian Railways Decision Support System")
    print("=" * 75)

    print("\n[*] Step 1: Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    print("[+] Connected to Neon Cloud PostgreSQL instance successfully.")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS tms_civil_demands (
            demand_ref_id VARCHAR(64) PRIMARY KEY,
            source_system VARCHAR(32) NOT NULL,
            division VARCHAR(64) NOT NULL,
            section VARCHAR(128) NOT NULL,
            block_section VARCHAR(128) NOT NULL,
            line_name VARCHAR(128) NOT NULL,
            work_type VARCHAR(128) NOT NULL,
            demand_nature VARCHAR(64) NOT NULL,
            preferred_date DATE NOT NULL,
            duration_minutes INTEGER NOT NULL,
            preferred_start TIME NOT NULL,
            preferred_end TIME NOT NULL,
            power_block_required BOOLEAN NOT NULL,
            st_disconnection_required BOOLEAN NOT NULL,
            post_work_speed_kmph INTEGER,
            payload JSONB NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        CREATE INDEX IF NOT EXISTS idx_tms_civil_div ON tms_civil_demands (division);
        CREATE INDEX IF NOT EXISTS idx_tms_civil_section ON tms_civil_demands (section);
        CREATE INDEX IF NOT EXISTS idx_tms_civil_date ON tms_civil_demands (preferred_date);
        CREATE INDEX IF NOT EXISTS idx_tms_civil_payload ON tms_civil_demands USING gin (payload);
    """)
    conn.commit()
    print("[+] Verified target table 'tms_civil_demands' and indexes.")

    # Inspect existing state
    cur.execute("SELECT COUNT(*) FROM tms_civil_demands;")
    initial_count = cur.fetchone()['count']
    print(f"[*] Existing verified records in 'tms_civil_demands': {initial_count}")

    # Check existing demand_ref_ids to guarantee absolute uniqueness
    cur.execute("SELECT demand_ref_id FROM tms_civil_demands;")
    existing_ids = set([r['demand_ref_id'] for r in cur.fetchall()])
    print(f"[*] Indexed {len(existing_ids)} existing demand_ref_ids.")

    # Target: 2,500 new records for pan-India zone/division/section coverage.
    TARGET_NEW_RECORDS = 2500
    print(f"\n[*] Step 2: Generating {TARGET_NEW_RECORDS} domain-aware records across 15 Railway Zones...")

    # Define weights for zones to respect prompt prioritization:
    # Priority: Eastern Railway (Asansol, Howrah), Northern Railway (Ambala), then Pan-India
    zone_weights = []
    for item in NETWORK_DATA:
        div = item["division"]
        if "Asansol" in div:
            w = 0.15  # ~337 records
        elif "Howrah" in div:
            w = 0.16  # ~360 records
        elif "Ambala" in div:
            w = 0.16  # ~360 records
        elif "Sealdah" in div or "Delhi" in div:
            w = 0.08  # ~180 records each
        elif "Central" in item["zone"] or "Western" in item["zone"]:
            w = 0.07  # ~157 records each
        else:
            w = 0.04  # ~90 records each
        zone_weights.append(w)

    records_to_insert = []
    payloads_list = []
    seq_counter = 1

    while len(records_to_insert) < TARGET_NEW_RECORDS:
        selected_network = random.choices(NETWORK_DATA, weights=zone_weights, k=1)[0]
        rec_tuple, rec_payload = generate_record(seq_counter, selected_network)
        ref_id = rec_tuple[0]

        if ref_id not in existing_ids:
            existing_ids.add(ref_id)
            records_to_insert.append(rec_tuple)
            payloads_list.append(rec_payload)
            seq_counter += 1

    print(f"[+] Successfully synthesized {len(records_to_insert)} unique records.")

    # Insertion SQL Statement
    insert_sql = """
    INSERT INTO tms_civil_demands (
        demand_ref_id, source_system, division, section, block_section, line_name,
        work_type, demand_nature, preferred_date, duration_minutes,
        preferred_start, preferred_end, power_block_required, st_disconnection_required,
        post_work_speed_kmph, payload
    ) VALUES (
        %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s, %s, %s,
        %s, %s::jsonb
    );
    """

    BATCH_SIZE = 500
    total_inserted = 0
    print(f"\n[*] Step 3: Executing batch insertion (Batch size: {BATCH_SIZE})...")

    try:
        for i in range(0, len(records_to_insert), BATCH_SIZE):
            batch = records_to_insert[i:i + BATCH_SIZE]
            execute_batch(cur, insert_sql, batch)
            conn.commit()
            total_inserted += len(batch)
            pct = (total_inserted / len(records_to_insert)) * 100
            print(f"  [+] Inserted batch {i // BATCH_SIZE + 1}: {total_inserted}/{len(records_to_insert)} ({pct:.1f}%)")

        print(f"\n[SUCCESS] Successfully inserted {total_inserted} new records into Neon PostgreSQL!")
    except Exception as e:
        conn.rollback()
        print(f"[-] Insertion Error encountered: {e}")
        conn.close()
        sys.exit(1)

    # Step 4: Verification & Comprehensive Validation Queries
    print("\n" + "=" * 75)
    print("                     POST-INSERTION VERIFICATION")
    print("=" * 75)

    cur.execute("SELECT COUNT(*) FROM tms_civil_demands;")
    final_count = cur.fetchone()['count']
    net_increase = final_count - initial_count
    print(f"[*] Final Record Count in tms_civil_demands: {final_count}")
    print(f"[*] Net New Records Added: {net_increase} (Requirement >= 2000: {'PASSED' if net_increase >= 2000 else 'FAILED'})")

    # 1. Zone Distribution (via JSONB payload)
    print("\n--- 1. ZONE DISTRIBUTION ---")
    cur.execute("""
        SELECT payload->'location_details'->>'zone' AS zone, COUNT(*)
        FROM tms_civil_demands
        GROUP BY 1
        ORDER BY COUNT(*) DESC;
    """)
    zone_stats = cur.fetchall()
    for z in zone_stats:
        print(f"  {z['zone']:32s} : {z['count']:4d} records")

    # 2. Division Distribution
    print("\n--- 2. DIVISION DISTRIBUTION (TOP 12) ---")
    cur.execute("""
        SELECT division, COUNT(*)
        FROM tms_civil_demands
        GROUP BY division
        ORDER BY COUNT(*) DESC
        LIMIT 12;
    """)
    div_stats = cur.fetchall()
    for d in div_stats:
        print(f"  {d['division']:32s} : {d['count']:4d} records")

    # 3. Section Count & Distinct Sections
    cur.execute("SELECT COUNT(DISTINCT section) AS total_sections FROM tms_civil_demands;")
    total_sections = cur.fetchone()['total_sections']
    print(f"\n[*] Total Distinct Sections Represented: {total_sections}")

    cur.execute("SELECT COUNT(DISTINCT block_section) AS total_bsections FROM tms_civil_demands;")
    total_bsections = cur.fetchone()['total_bsections']
    print(f"[*] Total Distinct Block Sections (Stations) Represented: {total_bsections}")

    # 4. Maintenance Activity Distribution
    print("\n--- 3. MAINTENANCE TYPE DISTRIBUTION ---")
    cur.execute("""
        SELECT payload->'maintenance_details'->>'maintenance_type' AS maintenance_type, COUNT(*)
        FROM tms_civil_demands
        GROUP BY 1
        ORDER BY COUNT(*) DESC;
    """)
    maint_stats = cur.fetchall()
    for m in maint_stats:
        print(f"  {m['maintenance_type']:36s} : {m['count']:4d}")

    # 5. Defect Type Distribution (Top 8)
    print("\n--- 4. DEFECT TYPE DISTRIBUTION (TOP 8) ---")
    cur.execute("""
        SELECT payload->'maintenance_details'->>'defect_type' AS defect_type, COUNT(*)
        FROM tms_civil_demands
        GROUP BY 1
        ORDER BY COUNT(*) DESC
        LIMIT 8;
    """)
    defect_stats = cur.fetchall()
    for df in defect_stats:
        print(f"  {df['defect_type']:42s} : {df['count']:4d}")

    # 6. Failure Occurred Distribution
    print("\n--- 5. FAILURE DISTRIBUTION (ML TARGET) ---")
    cur.execute("""
        SELECT (payload->'ml_features'->>'failure_occurred')::boolean AS failure_occurred, COUNT(*)
        FROM tms_civil_demands
        GROUP BY 1;
    """)
    fail_stats = cur.fetchall()
    for f in fail_stats:
        label = "True (Failure Preceded)" if f['failure_occurred'] else "False (Routine/Preventive)"
        print(f"  {label:30s} : {f['count']:4d}")

    # 7. Priority Distribution
    print("\n--- 6. MAINTENANCE PRIORITY DISTRIBUTION ---")
    cur.execute("""
        SELECT payload->'ml_features'->>'maintenance_priority' AS priority, COUNT(*)
        FROM tms_civil_demands
        GROUP BY 1
        ORDER BY COUNT(*) DESC;
    """)
    prio_stats = cur.fetchall()
    for p in prio_stats:
        if p['priority']:
            print(f"  {p['priority']:20s} : {p['count']:4d}")

    # 8. Statistical Averages (Risk Score & Maintenance Cost)
    cur.execute("""
        SELECT 
            ROUND(AVG((payload->'ml_features'->>'risk_score')::numeric), 2) AS avg_risk,
            ROUND(AVG((payload->'maintenance_cost'->>'total_cost_inr')::numeric), 2) AS avg_cost,
            ROUND(AVG(duration_minutes), 1) AS avg_duration
        FROM tms_civil_demands;
    """)
    avgs = cur.fetchone()
    print(f"\n[*] Average Predictive Risk Score: {avgs['avg_risk']} / 100")
    print(f"[*] Average Maintenance Cost: INR {avgs['avg_cost']:,.2f}")
    print(f"[*] Average Block Duration: {avgs['avg_duration']} minutes")

    # 9. Null Check
    cur.execute("""
        SELECT COUNT(*) AS null_count
        FROM tms_civil_demands
        WHERE division IS NULL
           OR section IS NULL
           OR block_section IS NULL
           OR work_type IS NULL
           OR payload IS NULL;
    """)
    null_cnt = cur.fetchone()['null_count']
    print(f"[*] Null Records Validation (Critical Columns): {null_cnt} (Integrity: {'PERFECT' if null_cnt == 0 else 'WARNING'})")

    # 10. Date Span Range
    cur.execute("SELECT MIN(preferred_date) AS min_d, MAX(preferred_date) AS max_d FROM tms_civil_demands;")
    dates = cur.fetchone()
    print(f"[*] Dataset Historical Span: {dates['min_d']} to {dates['max_d']}")

    conn.close()
    print("\n" + "=" * 75)
    print("      [COMPLETED] ALL OPERATIONS EXECUTED & COMMITTED WITH INTEGRITY!")
    print("=" * 75)


if __name__ == "__main__":
    main()
