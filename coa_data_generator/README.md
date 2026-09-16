# COA (Control Office Application) Master Timetable Synthetic Data Generator

This module generates and safely inserts realistic Indian Railways **COA Master Working Time Table** train movements, path segments, headway buffers, and cross-system maintenance conflict annotations into the IMBPS PostgreSQL database.

---

## 1. Project Architecture

```text
coa_data_generator/
├── .env                              # Neon PostgreSQL connection string (DATABASE_URL)
├── requirements.txt                  # Python dependencies
├── inspect_schema.py                 # Comprehensive schema inspector
├── inspect_coa_target.py             # Targeted coa_master_timetable inspector
├── load_existing_maintenance_data.py # Correlates with TMS, SMMS, TDMS records
├── railway_location_master.py        # Zones, Divisions, Sub-Divisions, Sections, Stations, CSR
├── train_master.py                   # Train categories, traction, frequencies, length, speeds
├── generate_coa_timetable.py         # Main train & path segment generator engine
├── insert_coa_timetable.py           # Safe, non-destructive batch inserter
├── validate_coa_timetable.py         # Post-insertion validation & reporting engine
├── coa_sample_50_preview.json       # 50 sample train records preview
└── README.md                         # Documentation
```

---

## 2. Strict Database Safety Guarantees

* **Zero Schema Alterations:** Never executes `CREATE TABLE`, `ALTER TABLE`, or `DROP TABLE`.
* **Zero Deletions or Overwrites:** Never executes `DELETE FROM`, `TRUNCATE TABLE`, or `UPDATE`.
* **Non-Destructive Additive INSERT:** Only inserts additional synthetic train records into `coa_master_timetable` using parameterized transactions.
* **Automatic Rollback Protection:** If any batch encounters a database or constraint error, the transaction rolls back cleanly without partial corruption.

---

## 3. Data Specification & Features

* **Target Table:** `coa_master_timetable` (Schema: `public`)
* **Architecture:** Hybrid PostgreSQL table combining indexed queryable scalar columns (`train_number`, `train_name`, `division_code`, `sub_division`, `traction`, `train_length_coaches`) with a full JSONB `payload`.
* **Timetable Validity:**
  * `effective_from`: `2026-10-01`
  * `effective_to`: `2027-03-31`
  * `generated_at`: `2026-09-15T15:02:00+05:30`
* **Geographical Coverage:**
  * High-density representation on **ECR (DDU Division)**, **ER (Asansol & Howrah Divisions)**, and **NR (Ambala Division)**.
  * Broad coverage across CR, WR, NCR, SCR, SR, SER, and WCR.
  * Logical hierarchy: `Zone -> Division -> Sub-Division -> Section -> Stations -> Path Segments`.
* **Train Categories:** Express (25%), Superfast Express (20%), Mail/Express (15%), Passenger (10%), MEMU (10%), DEMU (5%), Intercity (5%), Rajdhani/Duronto/Vande Bharat (5%), Goods/Freight (5%).
* **Cross-System Maintenance Conflict Detection:**
  * Cross-referenced with upcoming **TMS (Track Maintenance)**, **SMMS (Signalling & Telecom)**, and **TDMS (Traction Distribution)** blocks.
  * Dynamically annotates `maintenance_conflict: true`, `conflicting_system`, `conflict_type` (`TRACK_BLOCK_OVERLAP`, `SIGNAL_TRAFFIC_BLOCK_OVERLAP`, `POWER_BLOCK_OVERLAP`), and `electric_traction_affected: true`.

---

## 4. Execution Workflow

### Setup Environment
```bash
cd coa_data_generator
pip install -r requirements.txt
```

### 1. Inspect Database Schema
```bash
python inspect_schema.py
```

### 2. Generate and Insert Synthetic COA Records
```bash
python insert_coa_timetable.py
```

### 3. Validate and Generate Final Report
```bash
python validate_coa_timetable.py
```
