# COA Candidate Slot Offers & Regulation Playbooks Population

This module populates the PostgreSQL database table `coa_offered_slots` (representing candidate maintenance slot offers and regulation playbooks) for the IMBPS project.

---

## 1. Directory Structure

```text
scripts/coa_offered_timetable/
├── inspect_schema.sql                  # PostgreSQL metadata inspection queries
├── inspect_db.py                       # Python database inspector
├── generate_coa_offered_slots.py       # Candidate slot and regulation playbook generator
├── insert_coa_offered_slots.py         # Transactional, non-destructive batch inserter
├── validate_coa_offered_slots.sql      # SQL validation queries
├── validate_coa_offered_slots.py       # Python validation runner and reporter
├── coa_offered_sample_50_preview.json  # 50 sample slot records preview
└── README.md                           # Documentation
```

---

## 2. Mandatory Safety Rules & Verification

* **Identified Target Table:** `coa_offered_slots` in schema `public`.
* **Zero Disruption Policy:**
  * No `DROP`, `TRUNCATE`, `DELETE`, `ALTER`, `CREATE`, or `UPDATE` operations.
  * Preserves all 30 existing rows untouched.
  * Only performs additive `INSERT ... ON CONFLICT (coa_slot_id) DO NOTHING` operations in batches of 250 rows.
  * Immediate transaction rollback on any unhandled error.

---

## 3. Data Specification & Features

* **Planning Period:** `2026-09-15` to `2027-03-15` covering ISO planning weeks `2026-W38` through `2027-W11`.
* **Corridors Represented:**
  * **ECR (DDU Division):** DDU–Gaya, DDU–Sasaram, Kuchman–Sakaldiha corridors (~40%).
  * **ER (Asansol & Howrah Divisions):** Andal–Sainthia, Madhupur–Giridih, Howrah–Barddhaman, Bandel–Azimganj corridors (~40%).
  * **NR (Ambala Division):** Ambala–Ludhiana, Ambala–Chandigarh corridors (~20%).
* **Timetable Integration:**
  * Each slot contains `preceding_service` (`projected_clearance_time <= start_time`) and `following_service` (`end_time <= projected_arrival_time`) with realistic 5–25 minute headway safety buffers.
* **Contingency Regulation Playbook:**
  * Regulated coaching trains with designated regulation stations and approved detention durations.
  * Regulated freight rakes with stabling station and loop allocations (CSR aware).
* **Multi-Disciplinary Maintenance Cross-References:**
  * Links to TMS (Track Maintenance), SMMS (Signal & Telecom), and TDMS (Traction Distribution) records.

---

## 4. Execution Workflow

### 1. Inspect Schema
```bash
python scripts/coa_offered_timetable/inspect_db.py
```

### 2. Generate and Insert Candidate Slot Records
```bash
python scripts/coa_offered_timetable/insert_coa_offered_slots.py
```

### 3. Run Validation Queries and Generate Report
```bash
python scripts/coa_offered_timetable/validate_coa_offered_slots.py
```
