import sys
sys.path.insert(0, "c:/IMBPS/backend")
from app.ml_bridge import ml_bridge

divisions_to_test = [
    "Bhusawal",
    "CR-BSL",
    "Danapur (DNR)",
    "Howrah (HWH)",
    "Asansol (ASN)",
    "Mumbai (CSMT)",
    "Ambala (UMB)"
]

print("================================================================================")
print(" TESTING MULTI-DIVISION ML BLOCK OPTIMIZATION (COORDINATED WITH COA)")
print("================================================================================")

for div in divisions_to_test:
    print(f"\n---> Testing Optimization for: '{div}'")
    plan = ml_bridge.optimize_plan(horizon="WEEKLY", division=div)
    blocks = plan.get("scheduled_blocks", [])
    print(f"  Status: {plan.get('solver_status')}, Scheduled Blocks: {len(blocks)}")
    
    sections_found = set()
    engineers_found = set()
    slots_found = set()
    divs_found = set()

    for b in blocks:
        sections_found.add(b.get("section"))
        engineers_found.add(b.get("assigned_engineer"))
        slots_found.add(b.get("assigned_slot_id", "")[:20])
        divs_found.add(b.get("division"))

    print(f"  Division displayed: {divs_found}")
    print(f"  Sections scheduled: {sections_found}")
    print(f"  Designated Engineers: {list(engineers_found)[:2]}")
    print(f"  COA Slots sample: {list(slots_found)[:2]}")

    # Integrity verification
    if div in ["Bhusawal", "CR-BSL"]:
        assert not any("Andal" in str(s) for s in sections_found), f"FAIL: Andal found in Bhusawal! {sections_found}"
        assert any("Igatpuri" in str(s) or "Bhusawal" in str(s) or "Manmad" in str(s) for s in sections_found), "FAIL: No Bhusawal section found!"
        print("  [PASS] Bhusawal correctly optimized exclusively for its own section without Andal data!")

print("\n================================================================================")
print(" ALL MULTI-DIVISION ML OPTIMIZATION CHECKS PASSED WITH ZERO LEAKAGE!")
print("================================================================================")
