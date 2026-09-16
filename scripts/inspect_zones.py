import json

with open('c:/IMBPS/data/all_railway_entities.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

print(f"Total Zones: {len(d)}")
for zc, zd in d.items():
    divs = list(zd['divisions'].keys())
    sec_count = sum(len(dd['sections']) for dd in zd['divisions'].values())
    print(f"{zc} ({zd['name']}): {len(divs)} divisions {divs}, {sec_count} sections")
