-- ==============================================================================
-- Validation Queries for COA Service Priority & Operational Constraint Rules
-- Table: coa_priority_policies (public schema)
-- ==============================================================================

-- 1. Total Rows After Insertion
SELECT COUNT(*) AS total_policies_after 
FROM coa_priority_policies;

-- 2. Division Distribution
SELECT 
    zone_code, 
    division_code, 
    COUNT(*) AS policy_count
FROM coa_priority_policies
GROUP BY zone_code, division_code
ORDER BY zone_code, division_code;

-- 3. Policy Year Distribution
SELECT 
    policy_year, 
    COUNT(*) AS policy_count
FROM coa_priority_policies
GROUP BY policy_year
ORDER BY policy_year;

-- 4. Priority Tier Distribution
SELECT 
    tier_elem->>'tier' AS tier, 
    COUNT(*) AS tier_definition_count
FROM coa_priority_policies,
LATERAL jsonb_array_elements(payload->'priority_definitions') AS tier_elem
GROUP BY tier_elem->>'tier'
ORDER BY tier;

-- 5. Policy Status Distribution
SELECT 
    payload->>'effective_status' AS effective_status, 
    COUNT(*) AS status_count
FROM coa_priority_policies
GROUP BY payload->>'effective_status';

-- 6. Duplicate Policy Check (Must return 0 rows)
SELECT 
    zone_code, 
    division_code, 
    sub_division, 
    policy_year, 
    COUNT(*) AS duplicate_count
FROM coa_priority_policies
GROUP BY zone_code, division_code, sub_division, policy_year
HAVING COUNT(*) > 1;

-- 7. Date Range Validation
SELECT 
    MIN(payload->>'valid_from') AS earliest_validity, 
    MAX(payload->>'valid_to') AS latest_validity
FROM coa_priority_policies;

-- 8. Invalid Detention Check (Must return 0 rows)
SELECT 
    id, 
    sub_division, 
    policy_year, 
    tier_elem->>'tier' AS tier, 
    tier_elem->>'max_allowable_detention_minutes' AS detention
FROM coa_priority_policies,
LATERAL jsonb_array_elements(payload->'priority_definitions') AS tier_elem
WHERE (tier_elem->>'max_allowable_detention_minutes')::int < 0;
