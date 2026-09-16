"""
Train Master data and generator for COA Master Working Timetable.
Provides realistic Indian Railways train categories, traction distribution,
frequencies, speed profiles, and length specifications.
"""

import random

TRAIN_CATEGORIES_DIST = [
    ("Express", 0.25),
    ("Superfast Express", 0.20),
    ("Mail/Express", 0.15),
    ("Passenger", 0.10),
    ("MEMU", 0.10),
    ("DEMU", 0.05),
    ("Intercity Express", 0.05),
    ("Rajdhani/Duronto/Vande Bharat", 0.05),
    ("Goods/Freight", 0.05)
]

TRACTION_BY_CATEGORY = {
    "Rajdhani/Duronto/Vande Bharat": [("ELECTRIC_3PH", 1.0)],
    "Superfast Express": [("ELECTRIC_3PH", 0.85), ("ELECTRIC_CONVENTIONAL", 0.10), ("DIESEL", 0.05)],
    "Express": [("ELECTRIC_3PH", 0.70), ("ELECTRIC_CONVENTIONAL", 0.20), ("DIESEL", 0.10)],
    "Mail/Express": [("ELECTRIC_3PH", 0.70), ("ELECTRIC_CONVENTIONAL", 0.20), ("DIESEL", 0.10)],
    "Intercity Express": [("ELECTRIC_3PH", 0.80), ("ELECTRIC_CONVENTIONAL", 0.15), ("DIESEL", 0.05)],
    "MEMU": [("ELECTRIC_MEMU", 0.70), ("ELECTRIC_3PH", 0.30)],
    "DEMU": [("DIESEL_MULTIPLE_UNIT", 0.85), ("DIESEL", 0.15)],
    "Passenger": [("ELECTRIC_CONVENTIONAL", 0.50), ("ELECTRIC_3PH", 0.30), ("DIESEL", 0.20)],
    "Goods/Freight": [("ELECTRIC_FREIGHT", 0.70), ("ELECTRIC_3PH", 0.15), ("DIESEL_FREIGHT", 0.15)]
}

COACH_LENGTH_RANGES = {
    "Rajdhani/Duronto/Vande Bharat": (18, 22),
    "Superfast Express": (18, 24),
    "Express": (16, 24),
    "Mail/Express": (16, 24),
    "Intercity Express": (12, 20),
    "MEMU": (8, 16),
    "DEMU": (8, 16),
    "Passenger": (8, 18),
    "Goods/Freight": (32, 58) # Wagons / Rakes
}

SPEED_RANGES_KMPH = {
    "Rajdhani/Duronto/Vande Bharat": (85, 130),
    "Superfast Express": (70, 115),
    "Express": (60, 100),
    "Mail/Express": (60, 95),
    "Intercity Express": (65, 100),
    "MEMU": (40, 75),
    "DEMU": (35, 65),
    "Passenger": (30, 60),
    "Goods/Freight": (30, 70)
}

TRAIN_NAME_TEMPLATES = {
    "Rajdhani/Duronto/Vande Bharat": [
        "{dest} Vande Bharat Express", "{origin} - {dest} Rajdhani Express",
        "{dest} Tejas Express", "{origin} Duronto Express"
    ],
    "Superfast Express": [
        "{origin} - {dest} Superfast Express", "{dest} Express (SF)",
        "Purushottam Express", "Poorva Express", "Kalka Mail",
        "{origin} Garib Rath Express", "Shramjeevi Superfast Express"
    ],
    "Express": [
        "{origin} - {dest} Express", "Doon Express", "Amritsar Express",
        "Kisan Express", "Coalfield Express", "Agnibina Express"
    ],
    "Mail/Express": [
        "{dest} Mail", "Hool Express", "Ganadevata Express",
        "{origin} - {dest} Janta Express", "Black Diamond Express"
    ],
    "Intercity Express": [
        "{origin} - {dest} Intercity Express", "{dest} Intercity",
        "Patliputra Intercity Express", "Gaya Intercity"
    ],
    "MEMU": [
        "{origin} - {dest} MEMU Passenger", "{dest} MEMU Special",
        "{origin} Local MEMU", "{origin} - {dest} Fast MEMU"
    ],
    "DEMU": [
        "{origin} - {dest} DEMU Passenger", "{dest} DEMU Special"
    ],
    "Passenger": [
        "{origin} - {dest} Passenger", "{dest} Passenger Special",
        "{origin} - {dest} Ordinary Passenger"
    ],
    "Goods/Freight": [
        "BOXN Coal Rake ex-{origin}", "BCN Cement Freight Link",
        "BTPN POL Petroleum Freight", "Container Express (CONCOR)",
        "Steel Rake Link ex-{origin}", "Empty Box Rake Shuttle"
    ]
}

def pick_category():
    cats, probs = zip(*TRAIN_CATEGORIES_DIST)
    return random.choices(cats, weights=probs)[0]

def pick_traction(category: str):
    options = TRACTION_BY_CATEGORY[category]
    tracs, probs = zip(*options)
    return random.choices(tracs, weights=probs)[0]

def pick_length(category: str):
    min_len, max_len = COACH_LENGTH_RANGES[category]
    return random.randint(min_len, max_len)

def pick_speed(category: str):
    min_s, max_s = SPEED_RANGES_KMPH[category]
    return random.uniform(min_s, max_s)

def pick_frequency(category: str):
    if category in ["MEMU", "DEMU", "Passenger"]:
        return ["MON", "TUE", "WED", "THU", "FRI", "SAT"] if random.random() < 0.3 else ["DAILY"]
    elif category == "Goods/Freight":
        return ["DAILY"] if random.random() < 0.6 else ["MON", "WED", "FRI"]
    elif category == "Rajdhani/Duronto/Vande Bharat":
        return ["DAILY"] if random.random() < 0.5 else ["MON", "TUE", "WED", "FRI", "SAT", "SUN"]
    else:
        # Standard Express
        p = random.random()
        if p < 0.55:
            return ["DAILY"]
        elif p < 0.75:
            return ["MON", "WED", "FRI"]
        elif p < 0.90:
            return ["TUE", "THU", "SAT"]
        else:
            return ["SUN"]

def generate_train_identity(category: str, origin_name: str, dest_name: str, train_idx: int, existing_numbers: set):
    template = random.choice(TRAIN_NAME_TEMPLATES[category])
    t_name = template.format(origin=origin_name, dest=dest_name)
    
    # Generate unique 5-digit train number (or unique freight code)
    if category == "Goods/Freight":
        t_num = f"FREIGHT_{origin_name[:3].upper()}_{train_idx:04d}"
    elif category in ["MEMU", "DEMU", "Passenger"]:
        t_num = f"0{random.randint(3, 7)}{random.randint(100, 999)}"
    elif category == "Rajdhani/Duronto/Vande Bharat":
        t_num = f"22{random.randint(400, 999)}"
    elif category == "Superfast Express":
        t_num = f"12{random.randint(300, 999)}"
    else:
        t_num = f"13{random.randint(100, 999)}"
        
    while t_num in existing_numbers:
        if category == "Goods/Freight":
            train_idx += 1
            t_num = f"FREIGHT_{origin_name[:3].upper()}_{train_idx:04d}"
        else:
            t_num = f"{random.randint(1, 2)}{random.randint(1000, 9999)}"
            
    existing_numbers.add(t_num)
    return t_num, t_name
