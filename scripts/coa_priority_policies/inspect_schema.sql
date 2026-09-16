-- ==============================================================================
-- SQL Metadata Inspection for COA Service Priority & Constraint Policies Table
-- Table: coa_priority_policies (public schema)
-- ==============================================================================

-- 1. Table Existence & Schema Details
SELECT table_schema, table_name, table_type 
FROM information_schema.tables 
WHERE table_name = 'coa_priority_policies';

-- 2. Inspect Column Names, Data Types, Defaults, and Nullability
SELECT 
    column_name, 
    data_type, 
    udt_name, 
    is_nullable, 
    column_default, 
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'coa_priority_policies'
ORDER BY ordinal_position;

-- 3. Primary Key & Unique Constraints
SELECT 
    tc.constraint_name, 
    tc.constraint_type, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name 
  AND tc.table_schema = kcu.table_schema
WHERE tc.table_schema = 'public' 
  AND tc.table_name = 'coa_priority_policies'
ORDER BY tc.constraint_type, tc.constraint_name;

-- 4. Existing Indexes
SELECT 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE schemaname = 'public' 
  AND tablename = 'coa_priority_policies';

-- 5. Row Count Before Insertion
SELECT COUNT(*) AS total_policies_before 
FROM coa_priority_policies;

-- 6. Inspect Sample Policies
SELECT 
    id, 
    zone_code, 
    division_code, 
    sub_division, 
    corridor_classification, 
    policy_year, 
    created_at
FROM coa_priority_policies
ORDER BY id;
