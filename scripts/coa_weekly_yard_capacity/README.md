# COA Weekly Station Yard & Loop Line Stabling Envelope (`coa_weekly_yard_capacity`)

This module provides production-grade data generation, batch insertion, and verification scripts for populating the `coa_weekly_yard_capacity` table in the PostgreSQL / Neon database for the **Integrated Maintenance & Block Planning System (IMBPS)**.

Conceptual Feed Type: **`COA_WEEKLY_YARD_CAPACITY`**

---

## 1. Directory Structure

```text
scripts/coa_weekly_yard_capacity/
├── inspect_schema.sql                      # SQL metadata queries for table schema & constraints
├── inspect_db.py                           # Python inspection utility for PostgreSQL schema
├── generate_weekly_yard_capacity.py        # Realistic generator for weekly station yard capacity snapshots
├── insert_weekly_yard_capacity.py          # Safe parameterized batch inserter (additive only)
├── validate_weekly_yard_capacity.sql       # Pure SQL validation queries
├── validate_weekly_yard_capacity.py        # Python automated validator & completion report generator
├── coa_yard_capacity_sample_50_preview.json# Exported 50-record sample preview
└── README.md                               # Module documentation (this file)
```

---

## 2. Table Schema Overview

Table: `public.coa_weekly_yard_capacity`

| Column Name | Data Type | Nullable | Description |
| :--- | :--- | :--- | :--- |
| `id` | `integer` (SERIAL PK) | NO | Auto-incrementing primary key |
| `station_code` | `varchar(16)` | NO | Station code (e.g., `DDU`, `SSM`, `GAYA`) |
| `station_name` | `varchar(64)` | NO | Full station name |
| `division_code` | `varchar(16)` | NO | Railway division code (e.g., `DDU`, `ASN`, `HWH`, `UMB`) |
| `sub_division` | `varchar(64)` | NO | Sub-division / corridor identifier (e.g., `DDU-GAYA`, `HWH-MAIN-CHORD`) |
| `target_week` | `varchar(16)` | NO | Target ISO week format (e.g., `2026-W38`) |
| `payload` | `jsonb` | NO | Full nested capacity structure, loops array, and ML features |
| `created_at` | `timestamptz` | YES | Timestamp of record creation (DEFAULT CURRENT_TIMESTAMP) |

---

## 3. JSONB Payload Structure

Each record contains a comprehensive JSONB payload matching Indian Railways operational standards:

```json
{
  "feed_type": "COA_WEEKLY_YARD_CAPACITY",
  "zone_code": "ECR",
  "division_code": "DDU",
  "sub_division": "DDU-GAYA",
  "station_code": "SSM",
  "station_name": "Sasaram Jn",
  "station_category": "JUNCTION",
  "yard_type": "MAJOR_JUNCTION_YARD",
  "target_week": "2026-W38",
  "effective_period": {
    "from": "2026-09-14",
    "to": "2026-09-20"
  },
  "snapshot_timestamp": "2026-09-11T02:15:00+05:30",
  "station_operational_status": "OPERATIONAL",
  "total_loop_count": 4,
  "total_stabling_capacity_meters": 3120,
  "available_stabling_capacity_meters": 1640,
  "occupied_capacity_meters": 820,
  "reserved_capacity_meters": 660,
  "maintenance_blocked_capacity_meters": 0,
  "capacity_utilization_percentage": 47.4,
  "loops": [
    {
      "loop_number": "LOOP_1_UP",
      "loop_direction": "UP",
      "loop_type": "PASSENGER_LOOP",
      "clear_standing_room_csr_meters": 740,
      "electrified": true,
      "usable_for_holding_freight": true,
      "booked_or_maintenance_lock": false,
      "lock_reason": null,
      "current_occupancy_meters": 0,
      "available_capacity_meters": 740
    },
    {
      "loop_number": "LOOP_2_DOWN",
      "loop_direction": "DOWN",
      "loop_type": "FREIGHT_LOOP",
      "clear_standing_room_csr_meters": 880,
      "electrified": true,
      "usable_for_holding_freight": true,
      "booked_or_maintenance_lock": false,
      "lock_reason": null,
      "current_occupancy_meters": 820,
      "available_capacity_meters": 60
    }
  ],
  "predictive_ml_features": {
    "capacity_utilization_percentage": 47.4,
    "freight_demand_score": 0.72,
    "coaching_demand_score": 0.65,
    "yard_congestion_score": 0.45,
    "stabling_feasibility_score": 0.54,
    "loop_availability_score": 0.53,
    "capacity_shortage_risk": 0.39,
    "regulation_support_score": 0.81,
    "synthetic_record": true
  }
}
```

---

## 4. Mandatory Safety Rules & Guarantees

1. **Additive Only:** Only parameterized SQL `INSERT` statements are used.
2. **Forbidden Operations:** `DROP`, `TRUNCATE`, `DELETE`, `UPDATE`, `ALTER`, and `CREATE` are strictly prohibited.
3. **No Overwrite / Deduplication:** The inserter inspects existing `(station_code, target_week)` tuples before generating, ensuring 100% idempotency and zero duplicates.
4. **Transaction Integrity:** Batches of 200 records are committed sequentially; any batch failure rolls back safely.
5. **No Credential Exposure:** Database URLs and passwords are read securely from `.env` and never logged or committed.

---

## 5. Execution Workflow

### Step 1: Inspect Schema & Existing Records
```bash
python scripts/coa_weekly_yard_capacity/inspect_db.py
```

### Step 2: Run Additive Batch Inserter
```bash
python scripts/coa_weekly_yard_capacity/insert_weekly_yard_capacity.py
```

### Step 3: Run Validation & Generate Section 18 Report
```bash
python scripts/coa_weekly_yard_capacity/validate_weekly_yard_capacity.py
```
Or execute [`validate_weekly_yard_capacity.sql`](./validate_weekly_yard_capacity.sql) in psql / Neon console.
