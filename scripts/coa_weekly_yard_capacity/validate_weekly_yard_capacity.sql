-- ==============================================================================
-- SQL Validation Script for COA Weekly Yard Capacity
-- Table: coa_weekly_yard_capacity
-- ==============================================================================

-- 1. Total Row Count in coa_weekly_yard_capacity
SELECT COUNT(*) AS total_rows
FROM coa_weekly_yard_capacity;

-- 2. Weekly Distribution (Count per target_week)
SELECT target_week, COUNT(*) AS stations_count
FROM coa_weekly_yard_capacity
GROUP BY target_week
ORDER BY target_week;

-- 3. Zone and Division Distribution
SELECT 
    payload->>'zone_code' AS zone_code, 
    division_code, 
    COUNT(*) AS records_count
FROM coa_weekly_yard_capacity
GROUP BY payload->>'zone_code', division_code
ORDER BY zone_code, division_code;

-- 4. Station Distribution (Top 25 stations by snapshot count)
SELECT 
    station_code, 
    station_name, 
    division_code,
    COUNT(*) AS snapshot_count
FROM coa_weekly_yard_capacity
GROUP BY station_code, station_name, division_code
ORDER BY snapshot_count DESC, station_code ASC
LIMIT 25;

-- 5. Duplicate Station/Week Check (Must return 0 rows)
SELECT 
    target_week, 
    station_code, 
    COUNT(*) AS duplicate_count
FROM coa_weekly_yard_capacity
GROUP BY target_week, station_code
HAVING COUNT(*) > 1;

-- 6. Duplicate Loop Number Check within Station & Week (Must return 0 rows)
SELECT 
    target_week, 
    station_code, 
    l->>'loop_number' AS loop_number, 
    COUNT(*) AS duplicate_loops
FROM coa_weekly_yard_capacity,
     jsonb_array_elements(payload->'loops') AS l
GROUP BY target_week, station_code, l->>'loop_number'
HAVING COUNT(*) > 1;

-- 7. Loop CSR Sanity Check (CSR must be strictly positive > 0, returns 0 rows if valid)
SELECT 
    id, 
    station_code, 
    target_week, 
    l->>'loop_number' AS loop_num,
    (l->>'clear_standing_room_csr_meters')::numeric AS csr
FROM coa_weekly_yard_capacity,
     jsonb_array_elements(payload->'loops') AS l
WHERE (l->>'clear_standing_room_csr_meters')::numeric <= 0;

-- 8. Capacity Utilization Percentage Bounds Check (0 to 100%, returns 0 rows if valid)
SELECT 
    id, 
    station_code, 
    target_week, 
    (payload->>'capacity_utilization_percentage')::numeric AS util_pct
FROM coa_weekly_yard_capacity
WHERE (payload->>'capacity_utilization_percentage')::numeric < 0
   OR (payload->>'capacity_utilization_percentage')::numeric > 100;

-- 9. Locked Loop Validation (All locked loops must have a valid non-null lock reason, returns 0 rows if valid)
SELECT 
    id, 
    station_code, 
    target_week, 
    l->>'loop_number' AS loop_num, 
    l->>'booked_or_maintenance_lock' AS is_locked, 
    l->>'lock_reason' AS lock_reason
FROM coa_weekly_yard_capacity,
     jsonb_array_elements(payload->'loops') AS l
WHERE (l->>'booked_or_maintenance_lock')::boolean = true
  AND (l->>'lock_reason' IS NULL OR l->>'lock_reason' = '');

-- 10. Capacity Mathematical Balance Check (Occupied + Reserved + Maintenance <= Total Usable Capacity)
SELECT 
    id, 
    station_code, 
    target_week,
    (payload->>'total_stabling_capacity_meters')::numeric AS total_cap,
    (payload->>'occupied_capacity_meters')::numeric AS occ_cap,
    (payload->>'reserved_capacity_meters')::numeric AS res_cap,
    (payload->>'maintenance_blocked_capacity_meters')::numeric AS maint_cap
FROM coa_weekly_yard_capacity
WHERE (payload->>'occupied_capacity_meters')::numeric 
    + (payload->>'reserved_capacity_meters')::numeric 
    + (payload->>'maintenance_blocked_capacity_meters')::numeric 
    > (payload->>'total_stabling_capacity_meters')::numeric;

-- 11. Aggregate Capacity & Loop Breakdown
SELECT 
    COUNT(*) AS total_station_weeks,
    SUM((payload->>'total_loop_count')::int) AS total_loops,
    ROUND(AVG((payload->>'capacity_utilization_percentage')::numeric), 2) AS avg_utilization_pct,
    MAX((payload->>'capacity_utilization_percentage')::numeric) AS max_utilization_pct,
    SUM((payload->>'available_stabling_capacity_meters')::numeric) AS total_available_meters,
    SUM((payload->>'occupied_capacity_meters')::numeric) AS total_occupied_meters,
    SUM((payload->>'reserved_capacity_meters')::numeric) AS total_reserved_meters,
    SUM((payload->>'maintenance_blocked_capacity_meters')::numeric) AS total_maint_blocked_meters
FROM coa_weekly_yard_capacity;
