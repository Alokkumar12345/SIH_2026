# COA Service Priority & Operational Constraint Policies Population

This module populates the PostgreSQL table `coa_priority_policies` (conceptual feed name `COA_PRIORITY_RULES`) with realistic Indian Railways service priority rules, regulation guidelines, and corridor operational constraints.

---

## 1. Directory Structure

```text
scripts/coa_priority_policies/
├── inspect_schema.sql                       # PostgreSQL schema inspection queries
├── inspect_db.py                            # Python database inspector
├── generate_priority_policies.py            # Priority tiers & constraint rules generator
├── insert_priority_policies.py              # Safe, non-destructive batch inserter
├── validate_priority_policies.sql           # SQL validation queries
├── validate_priority_policies.py            # Python validation runner and reporter
├── coa_priority_policies_sample_50_preview.json # 50 sample policies preview
└── README.md                                # Documentation
```

---

## 2. Mandatory Safety Rules

* **Target Table:** `coa_priority_policies` in schema `public`.
* **Zero Disruption Policy:**
  * No `DROP`, `TRUNCATE`, `DELETE`, `ALTER`, `CREATE`, or `UPDATE` operations.
  * All 4 pre-existing rows remain untouched.
  * Non-destructive additive batch `INSERT` operations with automatic rollback protection.

---

## 3. Data Specification & Features

* **Corridor Coverage:**
  * Strong representation for **ECR (DDU Division ~40%)**: DDU-GAYA, DDU-BDL, DDU-SASARAM, DDU-PRYJ, DDU-PNBE.
  * **ER (Asansol & Howrah Divisions ~30%)**: ASN-UDL-SNT, ASN-MDP-JSME, ASN-DGR, HWH-MAIN-CHORD, HWH-BWN, HWH-BDC, HWH-KGP.
  * **NR (Ambala Division ~20%)**: UMB-LDH-CORRIDOR, UMB-SRE, UMB-KKDE, UMB-CDG, UMB-RPJ-BTI.
  * Major routes across CR, WR, NCR, SCR, SR, SER, and WCR.
* **5 Priority Tiers per Policy:**
  * **Tier 1 (National Priority):** Vande Bharat, Rajdhani, Shatabdi, Tejas (0 detention, Railway Board approval).
  * **Tier 2 (Major Trunk Express):** Superfast, Mail/Express, Garib Rath (10–30 min detention, Sr. DOM approval).
  * **Tier 3 (Regional / Suburban):** MEMU, DEMU, Passenger (30–60 min detention, DOM approval, short-termination allowed).
  * **Tier 4 (Freight / Bulk):** Container, Coal, Cement, Foodgrain, Empty Rake (120–300 min detention, Section Controller approval, yard stabling allowed).
  * **Tier Special:** Breakdown Crane, Tower Wagon, Accident Relief Train (0 min detention, emergency precedence).
* **Policy Versions & Seasons:**
  * Master 2026 working plan (`policy_year: "2026"`).
  * Monsoon precautionary regulation policy (`policy_year: "2026-MONSOON"`).
  * Fog & cold weather constraint policy (`policy_year: "2026-WINTER"`).
  * IMBPS multi-disciplinary maintenance protocol (`policy_year: "2026-BLOCK-OPTIMAL"`).
  * Historical baseline 2025 (`policy_year: "2025"`).
  * Advance projected policy 2027 (`policy_year: "2027"`).

---

## 4. Execution Workflow

### 1. Inspect Schema
```bash
python scripts/coa_priority_policies/inspect_db.py
```

### 2. Generate and Insert Priority Policies
```bash
python scripts/coa_priority_policies/insert_priority_policies.py
```

### 3. Run Validation Queries and Generate Report
```bash
python scripts/coa_priority_policies/validate_priority_policies.py
```
