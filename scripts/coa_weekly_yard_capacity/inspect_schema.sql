-- ==============================================================================
-- SQL Metadata Inspection for COA Weekly Yard Capacity Table
-- Table: coa_weekly_yard_capacity (public schema)
-- ==============================================================================

-- 1. Table Existence & Schema Details
SELECT table_schema, table_name, table_type 
FROM information_schema.tables 
WHERE table_name = 'coa_weekly_yard_capacity';

-- 2. Inspect Column Names, Data Types, Lengths, and Nullability
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'coa_weekly_yard_capacity'
ORDER BY ordinal_position;

-- 3. Primary Key & Constraints
SELECT 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name 
  AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'public' 
  AND tc.table_name = 'coa_weekly_yard_capacity'
ORDER BY tc.constraint_type, tc.constraint_name;

-- 4. Existing Indexes
SELECT 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public' 
  AND tablename = 'coa_weekly_yard_capacity';

-- 5. Row Count Before Insertion
SELECT COUNT(*) AS total_capacity_records_before 
FROM coa_weekly_yard_capacity;

-- 6. Sample Existing Records
SELECT 
    id, 
    station_code, 
    station_name, 
    division_code, 
    sub_division, 
    target_week, 
    created_at
FROM coa_weekly_yard_capacity
LIMIT 5;
