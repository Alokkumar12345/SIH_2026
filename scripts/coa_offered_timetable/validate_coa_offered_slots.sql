-- ==============================================================================
-- COA Offered Slots Validation Queries
-- ==============================================================================

-- 1. Total Rows After Insertion
SELECT COUNT(*) AS total_rows_after 
FROM coa_offered_slots;

-- 2. Duplicate Slot IDs Check
SELECT coa_slot_id, COUNT(*)
FROM coa_offered_slots
GROUP BY coa_slot_id
HAVING COUNT(*) > 1;

-- 3. Division Distribution
SELECT 
    payload->>'zone_code' AS zone_code,
    division_code, 
    COUNT(*) AS slot_count
FROM coa_offered_slots
GROUP BY payload->>'zone_code', division_code
ORDER BY zone_code, division_code;

-- 4. Planning Week Distribution
SELECT 
    payload->>'planning_week' AS planning_week, 
    COUNT(*) AS slot_count
FROM coa_offered_slots
GROUP BY payload->>'planning_week'
ORDER BY planning_week;

-- 5. Slot Status Distribution
SELECT 
    payload->>'slot_status' AS slot_status, 
    COUNT(*) AS slot_count
FROM coa_offered_slots
GROUP BY payload->>'slot_status'
ORDER BY slot_count DESC;

-- 6. Slot Purpose Distribution
SELECT 
    payload->>'slot_purpose' AS slot_purpose, 
    COUNT(*) AS slot_count
FROM coa_offered_slots
GROUP BY payload->>'slot_purpose'
ORDER BY slot_count DESC;

-- 7. Date Range Validation
SELECT 
    MIN(target_date) AS earliest_slot_date, 
    MAX(target_date) AS latest_slot_date
FROM coa_offered_slots;

-- 8. Invalid Duration Check (Must be 0 rows)
SELECT coa_slot_id, duration_minutes
FROM coa_offered_slots
WHERE duration_minutes <= 0;

-- 9. Missing Regulation Playbook Check (Must be 0 rows)
SELECT COUNT(*) AS missing_playbook_count
FROM coa_offered_slots
WHERE payload->'contingency_regulation_playbook' IS NULL;
