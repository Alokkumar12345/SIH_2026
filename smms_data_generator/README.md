# IMBPS - SMMS Synthetic Data Generator & Pipeline

Integrated Maintenance & Block Planning System (IMBPS) for Indian Railways.
Module: **Signal & Telecom Maintenance Management System (SMMS)** Data Pipeline.

---

## 1. Overview

This module generates, validates, and safely batch-inserts realistic synthetic Signal & Telecom (S&T) disconnection, maintenance, and inspection records directly into the live Neon PostgreSQL database table (`smms_signal_disconnections`).

All records strictly conform to:
- **Form Standard:** `S&T(T/D) 351 (Electronic)` Electronic Disconnection & Reconnection Notice.
- **Planning Window:** Upcoming 6 months (`2026-09-15` to `2027-03-15`).
- **Domain Accuracy:** 15 Indian Railway zones, 24 divisions, authentic station codes, logical interlocking constraints, realistic gear types, and machine learning telemetry features.

---

## 2. Directory Structure

```text
c:\IMBPS\smms_data_generator\
├── .env                              # Environment configuration (DATABASE_URL)
├── requirements.txt                  # Python dependencies
├── inspect_schema.py                 # Non-destructive schema and table inspector
├── generate_smms_data.py             # Domain synthesis engine (geography, assets, ML features)
├── insert_smms_data.py               # Safe batch insertion pipeline with transactions
├── validate_smms_data.py             # 21-point automated post-insertion validation suite
├── sample_smms_preview_50.json       # Preview artifact of 50 sample records
└── README.md                         # Documentation and operational manual
```

---

## 3. Database Safety & Integrity Rules

The pipeline enforces strict database safety guarantees:
* **Additive Only:** Performs solely parameterized `INSERT` operations.
* **Non-Destructive:** Explicitly forbids `DROP`, `TRUNCATE`, `ALTER`, `DELETE`, or `UPDATE` commands.
* **Pre-existing Data Preserved:** All 86 pre-existing baseline records remain completely intact.
* **Transaction Resilience:** Batch inserts in chunks of 500 records with automatic rollback if an error occurs.
* **Zero Credential Hardcoding:** Credentials are read dynamically via `DATABASE_URL` environment variables.

---

## 4. Key Architectural Modules

### `generate_smms_data.py`
* Implements the **Railway Network Master Topology** covering 15 zones (ER, NR, SCR, CR, WR, NCR, SR, SER, ECoR, SECR, SWR, WCR, NER, NFR, NWR) with strong focus on Eastern Railway (Asansol, Howrah) and Northern Railway (Ambala).
* Models 17 distinct equipment categories across Signalling, Telecom, and Power.
* Enforces mathematical duration consistency: $\text{end\_time} - \text{start\_time} = \text{duration\_minutes}$.
* Generates correlated predictive maintenance telemetry: `condition_score`, `risk_score`, `failure_probability`, `battery_voltage`, `insulation_resistance_mohm`, and `operation_count`.
* Respects operational block logic:
  - Point Machine overhaul $\rightarrow$ `requires_traffic_block = true`, `fouling_mark_infringed = true`, `crank_handle_locked = true`
  - Battery / Telecom routine testing $\rightarrow$ `requires_traffic_block = false`, `requires_power_block = true/false`

### `insert_smms_data.py`
* Connects via `DATABASE_URL` using `psycopg2`.
* Indexes all pre-existing primary keys (`disconnection_ref_id`) to prevent collisions.
* Inserts 2,600 new unique records in batches of 500 with committed transactions.
* Outputs `sample_smms_preview_50.json`.

### `validate_smms_data.py`
* Automated test suite validating:
  - Row counts ($\ge 2,000$ target verification)
  - Date bounds (`2026-09-15` $\le$ `slot_date` $\le$ `2027-03-15`)
  - Primary key uniqueness (0 duplicates)
  - Null validation across mandatory schema columns (0 nulls)
  - Geographic zone-division-station relationships
  - Traffic and power block logic integrity
  - Priority distribution calibration (LOW 20%, MEDIUM 40%, HIGH 30%, CRITICAL 10%)
  - Statistical averages for cost, downtime, and risk scores.

---

## 5. Execution Instructions

### Setup Environment
```bash
cd c:\IMBPS\smms_data_generator
pip install -r requirements.txt
```

### Configure Database URL in `.env`
```env
DATABASE_URL=postgresql://neondb_owner:npg_6BKvskhxM7yt@ep-noisy-glitter-aersnkh1-pooler.c-2.us-east-2.aws.neon.tech/neondb?sslmode=require&channel_binding=require
```

### Run Schema Inspector
```bash
python inspect_schema.py
```

### Run Batch Inserter
```bash
python insert_smms_data.py
```

### Run Full Validation Report
```bash
python validate_smms_data.py
```
