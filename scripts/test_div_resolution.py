import json
import re

with open("c:/IMBPS/data/all_railway_entities.json", "r", encoding="utf-8") as f:
    entities = json.load(f)

# Build a comprehensive lookup table
div_lookup = {}
for z_code, z_data in entities.items():
    for d_code, d_data in z_data.get("divisions", {}).items():
        d_name = d_data.get("name", d_code)
        div_lookup[d_code.upper()] = (d_code, d_name, z_code)
        div_lookup[d_name.upper()] = (d_code, d_name, z_code)
        # also stripped names
        clean_name = re.sub(r'\(.*?\)', '', d_name).strip().upper()
        if clean_name:
            div_lookup[clean_name] = (d_code, d_name, z_code)
        # also code without prefix e.g. CR-BSL -> BSL
        if "-" in d_code:
            short_code = d_code.split("-")[-1].upper()
            div_lookup[short_code] = (d_code, d_name, z_code)

def resolve_division(div_str: str):
    if not div_str:
        return "ASN", "Asansol (ASN)", "ER"
    raw = div_str.strip().upper()
    if raw in div_lookup:
        return div_lookup[raw]
    # Check if code inside parentheses
    m = re.search(r'\((.*?)\)', raw)
    if m and m.group(1) in div_lookup:
        return div_lookup[m.group(1)]
    # Partial matching
    for k, v in div_lookup.items():
        if k in raw or raw in k:
            return v
    return "ASN", "Asansol (ASN)", "ER"

# Test cases
test_inputs = [
    "Bhusawal", "CR-BSL", "Bhusawal (CR-BSL)", "BSL",
    "Howrah (HWH)", "HWH", "Howrah",
    "Ambala (UMB)", "UMB", "Ambala",
    "Pt. Deen Dayal Upadhyaya (DDU)", "DDU",
    "Danapur (DNR)", "DNR",
    "Dhanbad (DHN)", "DHN",
    "Mumbai (CSMT)", "CSMT",
    "Mumbai Central (MMCT)", "MMCT",
    "Vadodara (BRC)", "BRC",
    "Prayagraj (PRYJ)", "PRYJ",
    "Jhansi (NCR-JHS)", "NCR-JHS", "JHS",
    "Secunderabad (SC)", "SC",
    "Kharagpur (KGP)", "KGP",
    "Kota (KOTA)", "KOTA",
    "Sealdah (SDAH)", "SDAH",
    "Asansol (ASN)", "ASN"
]

print("=== Division Resolution Tests ===")
for inp in test_inputs:
    code, name, zone = resolve_division(inp)
    print(f"'{inp}' -> Code: {code}, Name: {name}, Zone: {zone}")
