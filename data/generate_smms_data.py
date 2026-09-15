import json
import random
from datetime import datetime, timedelta

# Master Data definition for realistic Indian Railways SMMS (Signal & Telecom Management System) assets

SECTIONS_CONFIG = [
    # -------------------------------------------------------------
    # EASTERN RAILWAY - ASANSOL DIVISION (ASN)
    # -------------------------------------------------------------
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_UDL",
        "section_name": "Andal - Sainthia",
        "stations": [
            {"code": "UDL", "name": "Andal Jn"},
            {"code": "UKA", "name": "Ukhra"},
            {"code": "PAW", "name": "Pandabeswar"},
            {"code": "DUJ", "name": "Dubrajpur"},
            {"code": "SURI", "name": "Siuri"},
            {"code": "SNT", "name": "Sainthia Jn"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_STN",
        "section_name": "Andal - Tapasi - Barabani - Sitarampur",
        "stations": [
            {"code": "UDL", "name": "Andal Jn"},
            {"code": "TOP", "name": "Tapasi"},
            {"code": "IKRA", "name": "Ikrah Jn"},
            {"code": "BBI", "name": "Barabani"},
            {"code": "STN", "name": "Sitarampur Jn"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_MDP",
        "section_name": "Madhupur - Giridih",
        "stations": [
            {"code": "MDP", "name": "Madhupur Jn"},
            {"code": "JGD", "name": "Jagdishpur"},
            {"code": "MMD", "name": "Maheshmunda"},
            {"code": "GRD", "name": "Giridih"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_JSME",
        "section_name": "Jasidih - Baidyanathdham",
        "stations": [
            {"code": "JSME", "name": "Jasidih Jn"},
            {"code": "DGHR", "name": "Deoghar Jn"},
            {"code": "BDME", "name": "Baidyanathdham"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_JSME",
        "section_name": "Jasidih to Dumka",
        "stations": [
            {"code": "JSME", "name": "Jasidih Jn"},
            {"code": "DGHR", "name": "Deoghar Jn"},
            {"code": "CNPR", "name": "Chandanpahari"},
            {"code": "BSKH", "name": "Basukinath"},
            {"code": "DUMK", "name": "Dumka"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "ASN",
        "division_name": "Asansol (ASN)",
        "sub_div": "SSE_SIGNAL_DGHR",
        "section_name": "Deoghar to Banka",
        "stations": [
            {"code": "DGHR", "name": "Deoghar Jn"},
            {"code": "KKRA", "name": "Kakwara"},
            {"code": "BAKA", "name": "Banka Jn"}
        ]
    },

    # -------------------------------------------------------------
    # EASTERN RAILWAY - HOWRAH DIVISION (HWH)
    # -------------------------------------------------------------
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_BWN",
        "section_name": "Howrah - Khana (Main line)",
        "stations": [
            {"code": "HWH", "name": "Howrah"},
            {"code": "BLY", "name": "Bally"},
            {"code": "BDC", "name": "Bandel Jn"},
            {"code": "BWN", "name": "Barddhaman"},
            {"code": "KAN", "name": "Khana Jn"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_DKAE",
        "section_name": "Howrah - Khana (Chord line)",
        "stations": [
            {"code": "DKAE", "name": "Dankuni Jn"},
            {"code": "KQU", "name": "Kamarkundu"},
            {"code": "GRAE", "name": "Gurap"},
            {"code": "MSAE", "name": "Masagram"},
            {"code": "SKG", "name": "Saktigarh"},
            {"code": "KAN", "name": "Khana Jn"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_RPH",
        "section_name": "Khana - Gumani",
        "stations": [
            {"code": "KAN", "name": "Khana Jn"},
            {"code": "BHP", "name": "Bolpur Shantiniketan"},
            {"code": "SNT", "name": "Sainthia Jn"},
            {"code": "RPH", "name": "Rampurhat Jn"},
            {"code": "NHT", "name": "Nalhati Jn"},
            {"code": "PKR", "name": "Pakur"},
            {"code": "GMAN", "name": "Gumani"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_RPH",
        "section_name": "Rampurhat - Dumka",
        "stations": [
            {"code": "RPH", "name": "Rampurhat Jn"},
            {"code": "PRGR", "name": "Pinargaria"},
            {"code": "SKIP", "name": "Shikaripara"},
            {"code": "DUMK", "name": "Dumka"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_AZ",
        "section_name": "Bandel - Azimganj",
        "stations": [
            {"code": "BDC", "name": "Bandel Jn"},
            {"code": "ABKA", "name": "Ambika Kalna"},
            {"code": "NDAE", "name": "Nabadwip Dham"},
            {"code": "KWAE", "name": "Katwa Jn"},
            {"code": "SALE", "name": "Salar"},
            {"code": "AZ", "name": "Azimganj Jn"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_DKAE",
        "section_name": "Dankuni - Bhattanagar & Dankuni - Rajchandrapur",
        "stations": [
            {"code": "DKAE", "name": "Dankuni Jn"},
            {"code": "BTNG", "name": "Bhattanagar"},
            {"code": "RCD", "name": "Rajchandrapur"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_SHE",
        "section_name": "Sheoraphuli - Tarakeswar - Goghat",
        "stations": [
            {"code": "SHE", "name": "Sheoraphuli Jn"},
            {"code": "DEA", "name": "Diara"},
            {"code": "HPL", "name": "Haripal"},
            {"code": "TAK", "name": "Tarakeswar"},
            {"code": "AMBG", "name": "Arambagh"},
            {"code": "GOGT", "name": "Goghat"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_BDC",
        "section_name": "Bandel - Hooghly Ghat",
        "stations": [
            {"code": "BDC", "name": "Bandel Jn"},
            {"code": "HYG", "name": "Hooghly Ghat"}
        ]
    },
    {
        "zone": "ER",
        "zone_name": "EASTERN RAILWAY",
        "division_code": "HWH",
        "division_name": "Howrah (HWH)",
        "sub_div": "SSE_SIGNAL_AZ",
        "section_name": "Azimganj - Nalhati",
        "stations": [
            {"code": "AZ", "name": "Azimganj Jn"},
            {"code": "SDI", "name": "Sagardighi"},
            {"code": "MGAE", "name": "Morgram"},
            {"code": "NHT", "name": "Nalhati Jn"}
        ]
    },

    # -------------------------------------------------------------
    # NORTHERN RAILWAY - AMBALA DIVISION (UMB)
    # -------------------------------------------------------------
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_UMB",
        "section_name": "UMB-LDH (Ambala Cantt - Ludhiana)",
        "stations": [
            {"code": "UMB", "name": "Ambala Cantt Jn"},
            {"code": "RPJ", "name": "Rajpura Jn"},
            {"code": "SIR", "name": "Sirhind Jn"},
            {"code": "KNN", "name": "Khanna"},
            {"code": "DOA", "name": "Doraha"},
            {"code": "LDH", "name": "Ludhiana Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_LDH",
        "section_name": "LDH-BTI (Ludhiana - Bathinda)",
        "stations": [
            {"code": "LDH", "name": "Ludhiana Jn"},
            {"code": "MLX", "name": "Mullanpur"},
            {"code": "JGN", "name": "Jagraon"},
            {"code": "MOG", "name": "Moga"},
            {"code": "KKP", "name": "Kotkapura Jn"},
            {"code": "BTI", "name": "Bathinda Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_CDG",
        "section_name": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)",
        "stations": [
            {"code": "UMB", "name": "Ambala Cantt Jn"},
            {"code": "LLU", "name": "Lalru"},
            {"code": "CDG", "name": "Chandigarh Jn"},
            {"code": "CNDM", "name": "Chandi Mandir"},
            {"code": "KLK", "name": "Kalka"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_KLK",
        "section_name": "KLK-SML (Kalka - Shimla)",
        "stations": [
            {"code": "KLK", "name": "Kalka"},
            {"code": "DMP", "name": "Dharampur Himachal"},
            {"code": "BOF", "name": "Barog"},
            {"code": "SOL", "name": "Solan"},
            {"code": "KDGF", "name": "Kandaghat"},
            {"code": "SML", "name": "Shimla"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_JUDW",
        "section_name": "UMB-SRE (Ambala - Saharanpur)",
        "stations": [
            {"code": "UMB", "name": "Ambala Cantt Jn"},
            {"code": "RAA", "name": "Barara"},
            {"code": "YJUD", "name": "Yamunanagar Jagadhri"},
            {"code": "SSW", "name": "Sarsawa"},
            {"code": "SRE", "name": "Saharanpur Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_JUDW",
        "section_name": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)",
        "stations": [
            {"code": "UMB", "name": "Ambala Cantt Jn"},
            {"code": "KES", "name": "Kesri"},
            {"code": "MFB", "name": "Mustafabad"},
            {"code": "JUDW", "name": "Jagadhri Workshop"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_KKDE",
        "section_name": "UMB-KKDE (Ambala - Kurukshetra)",
        "stations": [
            {"code": "UMB", "name": "Ambala Cantt Jn"},
            {"code": "MOY", "name": "Mohri"},
            {"code": "SHDM", "name": "Shahbad Markanda"},
            {"code": "KKDE", "name": "Kurukshetra Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_RPJ",
        "section_name": "RPJ-BTI (Rajpura - Bathinda)",
        "stations": [
            {"code": "RPJ", "name": "Rajpura Jn"},
            {"code": "PTA", "name": "Patiala"},
            {"code": "NBA", "name": "Nabha"},
            {"code": "DUI", "name": "Dhuri Jn"},
            {"code": "BNN", "name": "Barnala"},
            {"code": "PUL", "name": "Rampura Phul"},
            {"code": "BTI", "name": "Bathinda Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_PTA",
        "section_name": "RPJ-DUI (Rajpura - Dhuri)",
        "stations": [
            {"code": "RPJ", "name": "Rajpura Jn"},
            {"code": "KLI", "name": "Kauli"},
            {"code": "PTA", "name": "Patiala"},
            {"code": "CJL", "name": "Chhajli"},
            {"code": "DUI", "name": "Dhuri Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_DUI",
        "section_name": "DUI-LDH (Dhuri - Ludhiana)",
        "stations": [
            {"code": "DUI", "name": "Dhuri Jn"},
            {"code": "MET", "name": "Malerkotla"},
            {"code": "AHH", "name": "Ahmedgarh"},
            {"code": "QRP", "name": "Qila Raipur"},
            {"code": "LDH", "name": "Ludhiana Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_SIR",
        "section_name": "SIR-NLDM (Sirhind - Nangal Dam)",
        "stations": [
            {"code": "SIR", "name": "Sirhind Jn"},
            {"code": "MRND", "name": "Morinda Jn"},
            {"code": "RPAR", "name": "Rupnagar"},
            {"code": "KART", "name": "Kiratpur Sahib"},
            {"code": "ANSB", "name": "Anandpur Sahib"},
            {"code": "NLDM", "name": "Nangal Dam"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_SIR",
        "section_name": "SIR-AADR (Sirhind - Amb Andaura)",
        "stations": [
            {"code": "NLDM", "name": "Nangal Dam"},
            {"code": "MTPR", "name": "Mehatpur"},
            {"code": "UHL", "name": "Una Himachal"},
            {"code": "CHTL", "name": "Churaru Takrala"},
            {"code": "AADR", "name": "Amb Andaura"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_PTA",
        "section_name": "PTA-DUI (Patiala - Dhuri)",
        "stations": [
            {"code": "PTA", "name": "Patiala"},
            {"code": "DBN", "name": "Dhablan"},
            {"code": "NBA", "name": "Nabha"},
            {"code": "SEQ", "name": "Sekha"},
            {"code": "DUI", "name": "Dhuri Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_BTI",
        "section_name": "BTI-Abohar side (Bathinda - Abohar)",
        "stations": [
            {"code": "BTI", "name": "Bathinda Jn"},
            {"code": "BHX", "name": "Balluana"},
            {"code": "GDB", "name": "Giddarbaha"},
            {"code": "MOT", "name": "Malout"},
            {"code": "ABS", "name": "Abohar Jn"}
        ]
    },
    {
        "zone": "NR",
        "zone_name": "NORTHERN RAILWAY",
        "division_code": "UMB",
        "division_name": "Ambala (UMB)",
        "sub_div": "SSE_SIGNAL_SRE",
        "section_name": "SRE-UDN / connecting routes (Saharanpur area)",
        "stations": [
            {"code": "SRE", "name": "Saharanpur Jn"},
            {"code": "KJGY", "name": "Khanalampura Yard"},
            {"code": "BAE", "name": "Baliakheri"},
            {"code": "DBD", "name": "Deoband"}
        ]
    }
]

# Realistic S&T Gear and Disconnection Maintenance Catalog
SMMS_GEAR_CATALOG = [
    {
        "gear_type": "Point Machine",
        "maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly",
        "requires_traffic_block": True,
        "fouling_mark_infringed": True,
        "duration_minutes": 90,
        "crank_handle_locked": True,
        "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"
    },
    {
        "gear_type": "Electronic Interlocking (EI)",
        "maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization",
        "requires_traffic_block": True,
        "fouling_mark_infringed": False,
        "duration_minutes": 120,
        "crank_handle_locked": False,
        "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"
    },
    {
        "gear_type": "Digital Axle Counter (HASSDAC/MSDAC)",
        "maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration",
        "requires_traffic_block": True,
        "fouling_mark_infringed": False,
        "duration_minutes": 60,
        "crank_handle_locked": False,
        "alternate_movement_possible": "Block Section line clear verified via station master reset box"
    },
    {
        "gear_type": "Track Circuit (DC / Audio Frequency TC)",
        "maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal",
        "requires_traffic_block": False,
        "fouling_mark_infringed": False,
        "duration_minutes": 45,
        "crank_handle_locked": False,
        "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"
    },
    {
        "gear_type": "Interlocked Level Crossing Gate",
        "maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling",
        "requires_traffic_block": True,
        "fouling_mark_infringed": False,
        "duration_minutes": 90,
        "crank_handle_locked": False,
        "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"
    },
    {
        "gear_type": "Colour Light Signal (LED Signal Unit)",
        "maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal",
        "requires_traffic_block": False,
        "fouling_mark_infringed": False,
        "duration_minutes": 40,
        "crank_handle_locked": False,
        "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"
    },
    {
        "gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)",
        "maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring",
        "requires_traffic_block": True,
        "fouling_mark_infringed": False,
        "duration_minutes": 105,
        "crank_handle_locked": False,
        "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"
    },
    {
        "gear_type": "Point Machine",
        "maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment",
        "requires_traffic_block": True,
        "fouling_mark_infringed": True,
        "duration_minutes": 75,
        "crank_handle_locked": True,
        "alternate_movement_possible": "Reverse line routes clamped and padlocked"
    }
]

def generate_smms_records():
    records = []
    disc_counter = 401
    base_date = datetime(2026, 9, 8, 11, 30)

    for sec_idx, sec in enumerate(SECTIONS_CONFIG):
        num_records_for_section = 2 if len(sec["stations"]) <= 3 else 3

        for r_i in range(num_records_for_section):
            stn = sec["stations"][r_i % len(sec["stations"])]
            gear_template = SMMS_GEAR_CATALOG[(sec_idx + r_i) % len(SMMS_GEAR_CATALOG)]

            # Point or Gear ID
            point_num = random.randint(101, 148)
            point_sub = random.choice(["A", "B", ""])
            gear_type = gear_template["gear_type"]
            if gear_type == "Point Machine":
                gear_id = f"Point No. {point_num}{point_sub}"
                interlocking = random.choice([
                    "Down Loop to Down Main route",
                    "Up Main to Goods Siding route",
                    "Common Loop to Platform Line No. 2",
                    "Up Main Line crossovers 102/104"
                ])
                signals = [f"S-{random.randint(2, 18)}", f"S-{random.randint(20, 36)}"]
            elif gear_type == "Colour Light Signal (LED Signal Unit)":
                sig_no = random.randint(2, 28)
                gear_id = f"Signal No. S-{sig_no} (Home/Starter)"
                interlocking = f"Reception / Dispatch route controlled by S-{sig_no}"
                signals = [f"S-{sig_no}"]
            elif gear_type == "Interlocked Level Crossing Gate":
                lc_no = random.randint(12, 98)
                gear_id = f"LC Gate No. {lc_no} (Spl Class)"
                interlocking = f"Up & Down Gate Signals interlocked with Gate {lc_no}"
                signals = [f"G-{random.randint(1, 4)}", f"G-{random.randint(5, 8)}"]
            elif gear_type == "Digital Axle Counter (HASSDAC/MSDAC)":
                ac_no = random.randint(1, 12)
                gear_id = f"Axle Counter Unit DP-{ac_no}"
                interlocking = f"Block overlap detection & Track clearance for {stn['code']} yard"
                signals = [f"S-{random.randint(4, 12)}"]
            else:
                gear_id = f"Gear Unit #{random.randint(201, 299)}"
                interlocking = f"Interlocking panel for {stn['name']} yard"
                signals = [f"S-{random.randint(1, 10)}"]

            # Time calculation
            window_date = (base_date + timedelta(days=(sec_idx // 3), hours=(r_i * 3))).strftime("%Y-%m-%d")
            start_hour = 11 + (r_i * 3) % 10
            start_min = 0 if r_i % 2 == 0 else 30
            duration = gear_template["duration_minutes"]
            start_dt = datetime.strptime(f"{window_date} {start_hour:02d}:{start_min:02d}", "%Y-%m-%d %H:%M")
            end_dt = start_dt + timedelta(minutes=duration)

            emp_id = f"{random.randint(5028000, 5099999)}"
            contact = f"97714{random.randint(10000, 99999)}" if sec["zone"] == "ER" else f"97176{random.randint(10000, 99999)}"

            record = {
                "source_system": "SMMS_SIGNAL_TELECOM",
                "disconnection_ref_id": f"SMMS/{sec['division_code']}/2026/DISC/{disc_counter:04d}",
                "form_type": "S&T(T/D) 351 (Electronic)",
                "officer_in_charge": {
                    "emp_id": emp_id,
                    "designation": f"{sec['sub_div']}_{stn['code']}",
                    "contact": contact
                },
                "asset_location": {
                    "division": sec["division_name"],
                    "station_code": stn["code"],
                    "station_name": stn["name"],
                    "affected_gear": {
                        "gear_type": gear_type,
                        "gear_id": gear_id,
                        "interlocking_affected": interlocking,
                        "signals_affected": signals
                    }
                },
                "disconnection_specifications": {
                    "maintenance_nature": gear_template["maintenance_nature"],
                    "requires_traffic_block": gear_template["requires_traffic_block"],
                    "fouling_mark_infringed": gear_template["fouling_mark_infringed"],
                    "requested_slot": {
                        "date": window_date,
                        "start_time": start_dt.strftime("%H:%M"),
                        "end_time": end_dt.strftime("%H:%M"),
                        "duration_minutes": duration
                    }
                },
                "safety_protocols": {
                    "crank_handle_locked": gear_template["crank_handle_locked"],
                    "alternate_movement_possible": gear_template["alternate_movement_possible"]
                }
            }

            records.append(record)
            disc_counter += 1

    return records

if __name__ == "__main__":
    records = generate_smms_records()
    output_path = "c:/IMBPS/smms_data.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(records, f, indent=2)
    print(f"Generated {len(records)} realistic SMMS S&T records saved to {output_path}")
