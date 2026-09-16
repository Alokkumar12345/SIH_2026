# TDMS Electrical TRD Synthetic Data Generator

This module generates and safely inserts realistic Indian Railways **Traction Distribution (TRD)**, **Overhead Equipment (OHE)**, **Power Block**, and **Traffic Block** maintenance records into the IMBPS PostgreSQL database.

---

## 1. Project Structure

```text
tdms_data_generator/
├── .env                          # Neon PostgreSQL connection string (DATABASE_URL)
├── requirements.txt              # Required python dependencies
├── inspect_schema.py             # Pre-insertion database inspector
├── generate_tdms_data.py         # TRD domain generator engine & ML feature constructor
├── insert_tdms_data.py           # Safe, non-destructive batch inserter
├── validate_tdms_data.py         # Post-insertion validator & reporting script
├── tdms_sample_50_preview.json   # 50 sample records preview
└── README.md                     # Comprehensive documentation
```

---

## 2. Strict Database Safety Guarantees

* **No Schema Modifications:** Does not execute `CREATE TABLE`, `ALTER TABLE`, or `DROP TABLE`.
* **Zero Overwrites or Deletions:** Does not execute `TRUNCATE TABLE`, `DELETE FROM`, or `UPDATE`.
* **Additive INSERT Only:** Exclusively executes parameterized `INSERT INTO tdms_requisitions` in transactional batches.
* **Rollback Protection:** If any batch encounters an issue, the active transaction is rolled back immediately, preserving database integrity.

---

## 3. Data Specification & Features

* **Target Table:** `tdms_requisitions` (Schema: `public`)
* **Architecture:** Hybrid PostgreSQL table combining indexed queryable scalar columns (`requisition_id`, `preferred_date`, `zone`, `division`, `nature_of_work`, `duration_minutes`) with a full JSONB `payload`.
* **Date Range:** `2026-09-15` to `2027-03-15` (Upcoming 6 months, strictly future-looking).
* **Seasonal Variation:**
  * *September–October:* Post-monsoon OHE inspections, water ingress checks, drainage clearing, insulator mud-clearing.
  * *November–December:* Preventive OHE maintenance, isolator servicing, earthing checks, contact-wire ultrasonic wear surveys, dropper renewals.
  * *January:* Fog-season inspections, winter equipment reliability checks, thermal imaging, emergency preparedness.
  * *February–March:* Planned annual overhauling (AOH), catenary renewals, transformer testing, tower-wagon deployment.
* **Geographical Coverage:**
  * High-density focus on **ECR (DDU Division)**, **ER (Asansol & Howrah Divisions)**, and **NR (Ambala Division)**.
  * Broad coverage across CR, WR, NCR, SCR, SR, SER, and WCR.
  * Complete spatial chain: `Zone -> Division -> Section -> Block Section -> TSS -> FP -> Elementary Section -> Masts & Chainage`.
* **Machine Learning & Predictive Maintenance Features:**
  * Asset condition metrics: `contact_wire_wear_mm`, `catenary_tension_kn`, `OHE_height_mm`, `OHE_stagger_mm`, `insulation_resistance_megaohm`, `earth_resistance_ohm`.
  * Operational counters: `isolator_operation_count`, `circuit_breaker_operation_count`, `feeder_load_percent`, `peak_current_ampere`.
  * Environmental & weather factors: `rainfall_mm`, `humidity_percent`, `temperature_celsius`.
  * Target variables: `risk_score` (0.05–0.98), `failure_probability` (0.02–0.95), `estimated_cost_inr`, `estimated_downtime_minutes`, and `failure_type`.

---

## 4. Execution Instructions

### Setup Environment
```bash
cd tdms_data_generator
pip install -r requirements.txt
```

### 1. Inspect Schema
```bash
python inspect_schema.py
```

### 2. Generate and Insert Synthetic Records
```bash
python insert_tdms_data.py
```

### 3. Validate and Generate Final Report
```bash
python validate_tdms_data.py
```
