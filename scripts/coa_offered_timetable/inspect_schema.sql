-- ==============================================================================
-- SQL Metadata Inspection for COA Candidate Slot Offers Table
-- Table: coa_offered_slots (public schema)
-- ==============================================================================

-- 1. Check Table Existence & Schema Details
SELECT table_schema, table_name, table_type 
FROM information_schema.tables 
WHERE table_name IN ('coa_offered_slots', 'coa_offered_timetable');

-- 2. Inspect Column Structure, Data Types & Nullability
SELECT 
    column_name, 
    data_type, 
    udt_name, 
    is_nullable, 
    column_default, 
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'coa_offered_slots'
ORDER BY ordinal_position;

-- 3. Check Primary Keys and Unique Constraints
SELECT 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name 
  AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'public' 
  AND tc.table_name = 'coa_offered_slots'
ORDER BY tc.constraint_type, tc.constraint_name;

-- 4. Check Existing Indexes
SELECT 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public' 
  AND tablename = 'coa_offered_slots';

-- 5. Row Count Before Insertion
SELECT COUNT(*) AS total_rows_before 
FROM coa_offered_slots;

-- 6. Sample Existing Records
SELECT 
    coa_slot_id, 
    division_code, 
    sub_division, 
    section_id, 
    line, 
    target_date, 
    start_time, 
    end_time, 
    duration_minutes
FROM coa_offered_slots 
LIMIT 5;
