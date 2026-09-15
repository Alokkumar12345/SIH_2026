-- =====================================================
-- NEON POSTGRESQL SCHEMA FOR IR TMS CIVIL ENGINEERING
-- =====================================================
CREATE TABLE IF NOT EXISTS tms_civil_demands (
    demand_ref_id VARCHAR(64) PRIMARY KEY,
    source_system VARCHAR(32) NOT NULL,
    division VARCHAR(64) NOT NULL,
    section VARCHAR(128) NOT NULL,
    block_section VARCHAR(128) NOT NULL,
    line_name VARCHAR(128) NOT NULL,
    work_type VARCHAR(128) NOT NULL,
    demand_nature VARCHAR(64) NOT NULL,
    preferred_date DATE NOT NULL,
    duration_minutes INTEGER NOT NULL,
    preferred_start TIME NOT NULL,
    preferred_end TIME NOT NULL,
    power_block_required BOOLEAN NOT NULL,
    st_disconnection_required BOOLEAN NOT NULL,
    post_work_speed_kmph INTEGER,
    payload JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tms_div ON tms_civil_demands (division);
CREATE INDEX IF NOT EXISTS idx_tms_section ON tms_civil_demands (section);
CREATE INDEX IF NOT EXISTS idx_tms_date ON tms_civil_demands (preferred_date);
CREATE INDEX IF NOT EXISTS idx_tms_payload ON tms_civil_demands USING gin (payload);

-- =====================================================
-- TMS DATA INSERT STATEMENTS
-- =====================================================
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0501', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Sainthia', 'Andal (UDL) - Ukhra (UKA)', 'Single Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-08', 150,
    '11:30', '14:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0501", "requisitioning_officer": {"emp_id": "1052907", "designation": "SSE_PWAY_UDL_SUB_DIV", "mobile": "9771422115"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Sainthia", "block_section": "Andal (UDL) - Ukhra (UKA)", "line": "Single Line", "from_km": "1.165", "to_km": "4.436"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 150, "preferred_start": "11:30", "preferred_end": "14:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/08 - 004/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0502', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Sainthia', 'Ukhra (UKA) - Pandabeswar (PAW)', 'UP Main Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-08', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0502", "requisitioning_officer": {"emp_id": "1049126", "designation": "SSE_PWAY_UDL_SUB_DIV", "mobile": "9771435993"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Sainthia", "block_section": "Ukhra (UKA) - Pandabeswar (PAW)", "line": "UP Main Line", "from_km": "12.981", "to_km": "15.422"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 012/08 - 015/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0503', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Sainthia', 'Pandabeswar (PAW) - Dubrajpur (DUJ)', 'DN Main Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-08', 180,
    '17:30', '20:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0503", "requisitioning_officer": {"emp_id": "1076465", "designation": "SSE_PWAY_UDL_SUB_DIV", "mobile": "9771448681"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Sainthia", "block_section": "Pandabeswar (PAW) - Dubrajpur (DUJ)", "line": "DN Main Line", "from_km": "22.501", "to_km": "23.752"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 180, "preferred_start": "17:30", "preferred_end": "20:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 022/10 - 023/21", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0504', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Tapasi - Barabani - Sitarampur', 'Andal Jn (UDL) - Tapasi (TOP)', 'Single Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-08', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0504", "requisitioning_officer": {"emp_id": "1076987", "designation": "SSE_PWAY_STN_SUB_DIV", "mobile": "9771466262"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Tapasi - Barabani - Sitarampur", "block_section": "Andal Jn (UDL) - Tapasi (TOP)", "line": "Single Line", "from_km": "2.479", "to_km": "5.593"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/03 - 005/29", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0505', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Tapasi - Barabani - Sitarampur', 'Tapasi (TOP) - Ikrah Jn (IKRA)', 'Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-08', 180,
    '14:00', '17:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0505", "requisitioning_officer": {"emp_id": "1066804", "designation": "SSE_PWAY_STN_SUB_DIV", "mobile": "9771415809"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Tapasi - Barabani - Sitarampur", "block_section": "Tapasi (TOP) - Ikrah Jn (IKRA)", "line": "Single Line", "from_km": "10.231", "to_km": "12.736"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 180, "preferred_start": "14:00", "preferred_end": "17:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 010/05 - 012/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0506', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Andal - Tapasi - Barabani - Sitarampur', 'Ikrah Jn (IKRA) - Barabani (BBI)', 'Goods Chord Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-08', 210,
    '17:30', '21:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0506", "requisitioning_officer": {"emp_id": "1077003", "designation": "SSE_PWAY_STN_SUB_DIV", "mobile": "9771443623"}, "location_details": {"division": "Asansol (ASN)", "section": "Andal - Tapasi - Barabani - Sitarampur", "block_section": "Ikrah Jn (IKRA) - Barabani (BBI)", "line": "Goods Chord Line", "from_km": "15.607", "to_km": "18.105"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 210, "preferred_start": "17:30", "preferred_end": "21:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0507', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Madhupur - Giridih', 'Madhupur Jn (MDP) - Jagdishpur (JGD)', 'Single Line (Electrified 25kV)',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-08', 180,
    '11:30', '14:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0507", "requisitioning_officer": {"emp_id": "1094813", "designation": "SSE_PWAY_MDP_SUB_DIV", "mobile": "9771453926"}, "location_details": {"division": "Asansol (ASN)", "section": "Madhupur - Giridih", "block_section": "Madhupur Jn (MDP) - Jagdishpur (JGD)", "line": "Single Line (Electrified 25kV)", "from_km": "0.828", "to_km": "1.969"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 180, "preferred_start": "11:30", "preferred_end": "14:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 000/08 - 001/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0508', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Madhupur - Giridih', 'Jagdishpur (JGD) - Maheshmunda (MMD)', 'Single Line (Electrified 25kV)',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-08', 210,
    '14:00', '17:30', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0508", "requisitioning_officer": {"emp_id": "1081295", "designation": "SSE_PWAY_MDP_SUB_DIV", "mobile": "9771423898"}, "location_details": {"division": "Asansol (ASN)", "section": "Madhupur - Giridih", "block_section": "Jagdishpur (JGD) - Maheshmunda (MMD)", "line": "Single Line (Electrified 25kV)", "from_km": "12.099", "to_km": "15.195"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 210, "preferred_start": "14:00", "preferred_end": "17:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0509', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Madhupur - Giridih', 'Maheshmunda (MMD) - Giridih (GRD)', 'Single Line (Electrified 25kV)',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-08', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0509", "requisitioning_officer": {"emp_id": "1069378", "designation": "SSE_PWAY_MDP_SUB_DIV", "mobile": "9771463695"}, "location_details": {"division": "Asansol (ASN)", "section": "Madhupur - Giridih", "block_section": "Maheshmunda (MMD) - Giridih (GRD)", "line": "Single Line (Electrified 25kV)", "from_km": "28.643", "to_km": "32.288"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-08", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 028/09 - 032/18", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0510', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Jasidih - Baidyanathdham', 'Jasidih Jn (JSME) - Deoghar Jn (DGHR)', 'Branch Single Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-09', 210,
    '11:30', '15:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0510", "requisitioning_officer": {"emp_id": "1097588", "designation": "SSE_PWAY_JSME_SUB_DIV", "mobile": "9771424186"}, "location_details": {"division": "Asansol (ASN)", "section": "Jasidih - Baidyanathdham", "block_section": "Jasidih Jn (JSME) - Deoghar Jn (DGHR)", "line": "Branch Single Line", "from_km": "0.655", "to_km": "2.800"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 210, "preferred_start": "11:30", "preferred_end": "15:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0511', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Jasidih - Baidyanathdham', 'Deoghar Jn (DGHR) - Baidyanathdham (BDME)', 'Branch Single Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-09', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0511", "requisitioning_officer": {"emp_id": "1062960", "designation": "SSE_PWAY_JSME_SUB_DIV", "mobile": "9771487030"}, "location_details": {"division": "Asansol (ASN)", "section": "Jasidih - Baidyanathdham", "block_section": "Deoghar Jn (DGHR) - Baidyanathdham (BDME)", "line": "Branch Single Line", "from_km": "6.139", "to_km": "6.100"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 006/08 - 006/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0512', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Jasidih to Dumka', 'Jasidih Jn (JSME) - Deoghar Jn (DGHR)', 'Single Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-09', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0512", "requisitioning_officer": {"emp_id": "1084432", "designation": "SSE_PWAY_JSME_SUB_DIV", "mobile": "9771479091"}, "location_details": {"division": "Asansol (ASN)", "section": "Jasidih to Dumka", "block_section": "Jasidih Jn (JSME) - Deoghar Jn (DGHR)", "line": "Single Line", "from_km": "1.293", "to_km": "2.600"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/09 - 002/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0513', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Jasidih to Dumka', 'Deoghar Jn (DGHR) - Chandanpahari (CNPR)', 'Single Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-09', 120,
    '14:00', '16:00', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0513", "requisitioning_officer": {"emp_id": "1058791", "designation": "SSE_PWAY_JSME_SUB_DIV", "mobile": "9771440158"}, "location_details": {"division": "Asansol (ASN)", "section": "Jasidih to Dumka", "block_section": "Deoghar Jn (DGHR) - Chandanpahari (CNPR)", "line": "Single Line", "from_km": "8.116", "to_km": "9.757"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 120, "preferred_start": "14:00", "preferred_end": "16:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0514', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Jasidih to Dumka', 'Chandanpahari (CNPR) - Basukinath (BSKH)', 'Single Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-09', 300,
    '17:30', '22:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0514", "requisitioning_officer": {"emp_id": "1048026", "designation": "SSE_PWAY_JSME_SUB_DIV", "mobile": "9771420496"}, "location_details": {"division": "Asansol (ASN)", "section": "Jasidih to Dumka", "block_section": "Chandanpahari (CNPR) - Basukinath (BSKH)", "line": "Single Line", "from_km": "23.258", "to_km": "26.375"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 300, "preferred_start": "17:30", "preferred_end": "22:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 023/08 - 026/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0515', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Deoghar to Banka', 'Deoghar Jn (DGHR) - Banka Ghat / Kakwara (KKRA)', 'Single Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-09', 120,
    '11:30', '13:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0515", "requisitioning_officer": {"emp_id": "1066132", "designation": "SSE_PWAY_DGHR_SUB_DIV", "mobile": "9771413876"}, "location_details": {"division": "Asansol (ASN)", "section": "Deoghar to Banka", "block_section": "Deoghar Jn (DGHR) - Banka Ghat / Kakwara (KKRA)", "line": "Single Line", "from_km": "1.044", "to_km": "4.255"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 120, "preferred_start": "11:30", "preferred_end": "13:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/ASN/2026/BLK/0516', 'TMS_CIVIL_ENGG', 'Asansol (ASN)', 'Deoghar to Banka', 'Kakwara (KKRA) - Banka Jn (BAKA)', 'Single Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-09', 300,
    '14:00', '19:00', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/ASN/2026/BLK/0516", "requisitioning_officer": {"emp_id": "1075120", "designation": "SSE_PWAY_DGHR_SUB_DIV", "mobile": "9771489837"}, "location_details": {"division": "Asansol (ASN)", "section": "Deoghar to Banka", "block_section": "Kakwara (KKRA) - Banka Jn (BAKA)", "line": "Single Line", "from_km": "32.592", "to_km": "35.528"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-09", "requested_window": {"duration_minutes": 300, "preferred_start": "14:00", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 032/02 - 035/28", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0517', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Main line)', 'Howrah (HWH) - Bally (BLY)', 'UP Main Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-10', 300,
    '11:30', '16:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0517", "requisitioning_officer": {"emp_id": "1080779", "designation": "SSE_PWAY_BWN_SUB_DIV", "mobile": "9771473006"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Main line)", "block_section": "Howrah (HWH) - Bally (BLY)", "line": "UP Main Line", "from_km": "2.597", "to_km": "5.737"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 300, "preferred_start": "11:30", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/03 - 005/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0518', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Main line)', 'Bally (BLY) - Bandel (BDC)', '3rd Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-10', 90,
    '14:00', '15:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0518", "requisitioning_officer": {"emp_id": "1096476", "designation": "SSE_PWAY_BWN_SUB_DIV", "mobile": "9771421673"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Main line)", "block_section": "Bally (BLY) - Bandel (BDC)", "line": "3rd Line", "from_km": "11.238", "to_km": "12.815"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 90, "preferred_start": "14:00", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 011/06 - 012/16", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0519', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Main line)', 'Bandel (BDC) - Barddhaman (BWN)', 'DN Main Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-10', 150,
    '17:30', '20:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0519", "requisitioning_officer": {"emp_id": "1064745", "designation": "SSE_PWAY_BWN_SUB_DIV", "mobile": "9771415663"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Main line)", "block_section": "Bandel (BDC) - Barddhaman (BWN)", "line": "DN Main Line", "from_km": "40.293", "to_km": "42.891"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 150, "preferred_start": "17:30", "preferred_end": "20:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 040/13 - 042/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0520', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Chord line)', 'Howrah (HWH) - Dankuni Jn (DKAE)', 'DN Chord Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-10', 90,
    '11:30', '13:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0520", "requisitioning_officer": {"emp_id": "1057585", "designation": "SSE_PWAY_DKAE_SUB_DIV", "mobile": "9771450677"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Chord line)", "block_section": "Howrah (HWH) - Dankuni Jn (DKAE)", "line": "DN Chord Line", "from_km": "0.724", "to_km": "2.162"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 90, "preferred_start": "11:30", "preferred_end": "13:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 000/05 - 002/17", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0521', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Chord line)', 'Dankuni Jn (DKAE) - Kamarkundu (KQU)', 'DN Chord Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-10', 150,
    '14:00', '16:30', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0521", "requisitioning_officer": {"emp_id": "1077289", "designation": "SSE_PWAY_DKAE_SUB_DIV", "mobile": "9771476590"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Chord line)", "block_section": "Dankuni Jn (DKAE) - Kamarkundu (KQU)", "line": "DN Chord Line", "from_km": "16.835", "to_km": "18.930"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 150, "preferred_start": "14:00", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 016/05 - 018/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0522', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Howrah - Khana (Chord line)', 'Kamarkundu (KQU) - Gurap (GRAE)', 'DN Chord Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-10', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0522", "requisitioning_officer": {"emp_id": "1086359", "designation": "SSE_PWAY_DKAE_SUB_DIV", "mobile": "9771436541"}, "location_details": {"division": "Howrah (HWH)", "section": "Howrah - Khana (Chord line)", "block_section": "Kamarkundu (KQU) - Gurap (GRAE)", "line": "DN Chord Line", "from_km": "38.934", "to_km": "42.488"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 038/10 - 042/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0523', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Khana - Gumani', 'Khana Jn (KAN) - Bolpur Shantiniketan (BHP)', 'DN Main Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-10', 150,
    '11:30', '14:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0523", "requisitioning_officer": {"emp_id": "1095304", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771420385"}, "location_details": {"division": "Howrah (HWH)", "section": "Khana - Gumani", "block_section": "Khana Jn (KAN) - Bolpur Shantiniketan (BHP)", "line": "DN Main Line", "from_km": "120.606", "to_km": "122.515"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 150, "preferred_start": "11:30", "preferred_end": "14:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 120/10 - 122/20", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0524', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Khana - Gumani', 'Bolpur Shantiniketan (BHP) - Sainthia Jn (SNT)', 'UP Main Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-10', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0524", "requisitioning_officer": {"emp_id": "1082492", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771441367"}, "location_details": {"division": "Howrah (HWH)", "section": "Khana - Gumani", "block_section": "Bolpur Shantiniketan (BHP) - Sainthia Jn (SNT)", "line": "UP Main Line", "from_km": "161.789", "to_km": "165.425"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 161/11 - 165/31", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0525', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Khana - Gumani', 'Sainthia Jn (SNT) - Rampurhat Jn (RPH)', 'DN Main Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-10', 180,
    '17:30', '20:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0525", "requisitioning_officer": {"emp_id": "1086418", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771475540"}, "location_details": {"division": "Howrah (HWH)", "section": "Khana - Gumani", "block_section": "Sainthia Jn (SNT) - Rampurhat Jn (RPH)", "line": "DN Main Line", "from_km": "193.155", "to_km": "196.696"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-10", "requested_window": {"duration_minutes": 180, "preferred_start": "17:30", "preferred_end": "20:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 193/10 - 196/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0526', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Rampurhat - Dumka', 'Rampurhat Jn (RPH) - Pinargaria (PRGR)', 'Single Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-11', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0526", "requisitioning_officer": {"emp_id": "1054862", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771449680"}, "location_details": {"division": "Howrah (HWH)", "section": "Rampurhat - Dumka", "block_section": "Rampurhat Jn (RPH) - Pinargaria (PRGR)", "line": "Single Line", "from_km": "2.794", "to_km": "4.707"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/06 - 004/30", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0527', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Rampurhat - Dumka', 'Pinargaria (PRGR) - Shikaripara (SKIP)', 'Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-11', 180,
    '14:00', '17:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0527", "requisitioning_officer": {"emp_id": "1063110", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771448913"}, "location_details": {"division": "Howrah (HWH)", "section": "Rampurhat - Dumka", "block_section": "Pinargaria (PRGR) - Shikaripara (SKIP)", "line": "Single Line", "from_km": "21.489", "to_km": "25.227"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 180, "preferred_start": "14:00", "preferred_end": "17:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 021/03 - 025/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0528', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Rampurhat - Dumka', 'Shikaripara (SKIP) - Dumka (DUMK)', 'Single Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-11', 210,
    '17:30', '21:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0528", "requisitioning_officer": {"emp_id": "1077476", "designation": "SSE_PWAY_RPH_SUB_DIV", "mobile": "9771477898"}, "location_details": {"division": "Howrah (HWH)", "section": "Rampurhat - Dumka", "block_section": "Shikaripara (SKIP) - Dumka (DUMK)", "line": "Single Line", "from_km": "42.914", "to_km": "46.324"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 210, "preferred_start": "17:30", "preferred_end": "21:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0529', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Bandel - Azimganj', 'Bandel Jn (BDC) - Ambika Kalna (ABKA)', 'DN Loop Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-11', 180,
    '11:30', '14:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0529", "requisitioning_officer": {"emp_id": "1080107", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771476479"}, "location_details": {"division": "Howrah (HWH)", "section": "Bandel - Azimganj", "block_section": "Bandel Jn (BDC) - Ambika Kalna (ABKA)", "line": "DN Loop Line", "from_km": "42.064", "to_km": "45.766"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 180, "preferred_start": "11:30", "preferred_end": "14:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 042/11 - 045/29", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0530', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Bandel - Azimganj', 'Ambika Kalna (ABKA) - Nabadwip Dham (NDAE)', 'DN Loop Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-11', 210,
    '14:00', '17:30', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0530", "requisitioning_officer": {"emp_id": "1086427", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771486766"}, "location_details": {"division": "Howrah (HWH)", "section": "Bandel - Azimganj", "block_section": "Ambika Kalna (ABKA) - Nabadwip Dham (NDAE)", "line": "DN Loop Line", "from_km": "84.290", "to_km": "88.030"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 210, "preferred_start": "14:00", "preferred_end": "17:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0531', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Bandel - Azimganj', 'Nabadwip Dham (NDAE) - Katwa Jn (KWAE)', 'UP Loop Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-11', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0531", "requisitioning_officer": {"emp_id": "1062271", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771499949"}, "location_details": {"division": "Howrah (HWH)", "section": "Bandel - Azimganj", "block_section": "Nabadwip Dham (NDAE) - Katwa Jn (KWAE)", "line": "UP Loop Line", "from_km": "107.488", "to_km": "109.047"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 107/05 - 109/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0532', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Dankuni - Bhattanagar & Dankuni - Rajchandrapur', 'Dankuni Jn (DKAE) - Bhattanagar (BTNG)', 'Freight Bypass DN Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-11', 210,
    '11:30', '15:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0532", "requisitioning_officer": {"emp_id": "1054033", "designation": "SSE_PWAY_DKAE_SUB_DIV", "mobile": "9771446343"}, "location_details": {"division": "Howrah (HWH)", "section": "Dankuni - Bhattanagar & Dankuni - Rajchandrapur", "block_section": "Dankuni Jn (DKAE) - Bhattanagar (BTNG)", "line": "Freight Bypass DN Line", "from_km": "0.492", "to_km": "2.208"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 210, "preferred_start": "11:30", "preferred_end": "15:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0533', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Dankuni - Bhattanagar & Dankuni - Rajchandrapur', 'Dankuni Jn (DKAE) - Rajchandrapur (RCD)', 'Freight Bypass UP Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-11', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0533", "requisitioning_officer": {"emp_id": "1087669", "designation": "SSE_PWAY_DKAE_SUB_DIV", "mobile": "9771477337"}, "location_details": {"division": "Howrah (HWH)", "section": "Dankuni - Bhattanagar & Dankuni - Rajchandrapur", "block_section": "Dankuni Jn (DKAE) - Rajchandrapur (RCD)", "line": "Freight Bypass UP Line", "from_km": "0.828", "to_km": "2.752"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-11", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 000/11 - 002/31", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0534', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Sheoraphuli - Tarakeswar - Goghat', 'Sheoraphuli (SHE) - Diara (DEA)', 'Single Line Branch',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-12', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0534", "requisitioning_officer": {"emp_id": "1057529", "designation": "SSE_PWAY_SHE_SUB_DIV", "mobile": "9771453350"}, "location_details": {"division": "Howrah (HWH)", "section": "Sheoraphuli - Tarakeswar - Goghat", "block_section": "Sheoraphuli (SHE) - Diara (DEA)", "line": "Single Line Branch", "from_km": "1.807", "to_km": "3.825"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/07 - 003/18", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0535', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Sheoraphuli - Tarakeswar - Goghat', 'Diara (DEA) - Haripal (HPL)', 'Single Line Branch',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-12', 120,
    '14:00', '16:00', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0535", "requisitioning_officer": {"emp_id": "1094024", "designation": "SSE_PWAY_SHE_SUB_DIV", "mobile": "9771452124"}, "location_details": {"division": "Howrah (HWH)", "section": "Sheoraphuli - Tarakeswar - Goghat", "block_section": "Diara (DEA) - Haripal (HPL)", "line": "Single Line Branch", "from_km": "8.547", "to_km": "10.880"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 120, "preferred_start": "14:00", "preferred_end": "16:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0536', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Sheoraphuli - Tarakeswar - Goghat', 'Haripal (HPL) - Tarakeswar (TAK)', 'Single Line Branch',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-12', 300,
    '17:30', '22:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0536", "requisitioning_officer": {"emp_id": "1052045", "designation": "SSE_PWAY_SHE_SUB_DIV", "mobile": "9771446974"}, "location_details": {"division": "Howrah (HWH)", "section": "Sheoraphuli - Tarakeswar - Goghat", "block_section": "Haripal (HPL) - Tarakeswar (TAK)", "line": "Single Line Branch", "from_km": "24.250", "to_km": "26.434"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 300, "preferred_start": "17:30", "preferred_end": "22:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 024/13 - 026/17", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0537', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Bandel - Hooghly Ghat', 'Bandel Jn (BDC) - Hooghly Ghat (HYG)', 'Sampreeti Setu Bridge DN Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-12', 120,
    '11:30', '13:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0537", "requisitioning_officer": {"emp_id": "1079839", "designation": "SSE_PWAY_BDC_SUB_DIV", "mobile": "9771435830"}, "location_details": {"division": "Howrah (HWH)", "section": "Bandel - Hooghly Ghat", "block_section": "Bandel Jn (BDC) - Hooghly Ghat (HYG)", "line": "Sampreeti Setu Bridge DN Line", "from_km": "40.018", "to_km": "43.400"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 120, "preferred_start": "11:30", "preferred_end": "13:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0538', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Bandel - Hooghly Ghat', 'Bandel Jn (BDC) - Hooghly Ghat (HYG)', 'Sampreeti Setu Bridge DN Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-12', 300,
    '14:00', '19:00', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0538", "requisitioning_officer": {"emp_id": "1088315", "designation": "SSE_PWAY_BDC_SUB_DIV", "mobile": "9771458833"}, "location_details": {"division": "Howrah (HWH)", "section": "Bandel - Hooghly Ghat", "block_section": "Bandel Jn (BDC) - Hooghly Ghat (HYG)", "line": "Sampreeti Setu Bridge DN Line", "from_km": "41.726", "to_km": "43.400"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 300, "preferred_start": "14:00", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 041/02 - 043/17", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0539', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Azimganj - Nalhati', 'Azimganj Jn (AZ) - Sagardighi (SDI)', 'Single Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-12', 300,
    '11:30', '16:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0539", "requisitioning_officer": {"emp_id": "1074901", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771448228"}, "location_details": {"division": "Howrah (HWH)", "section": "Azimganj - Nalhati", "block_section": "Azimganj Jn (AZ) - Sagardighi (SDI)", "line": "Single Line", "from_km": "1.190", "to_km": "2.883"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 300, "preferred_start": "11:30", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/05 - 002/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0540', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Azimganj - Nalhati', 'Sagardighi (SDI) - Morgram (MGAE)', 'Single Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-12', 90,
    '14:00', '15:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0540", "requisitioning_officer": {"emp_id": "1049402", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771439076"}, "location_details": {"division": "Howrah (HWH)", "section": "Azimganj - Nalhati", "block_section": "Sagardighi (SDI) - Morgram (MGAE)", "line": "Single Line", "from_km": "20.367", "to_km": "22.243"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 90, "preferred_start": "14:00", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 020/13 - 022/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/HWH/2026/BLK/0541', 'TMS_CIVIL_ENGG', 'Howrah (HWH)', 'Azimganj - Nalhati', 'Morgram (MGAE) - Nalhati Jn (NHT)', 'Single Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-12', 150,
    '17:30', '20:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/HWH/2026/BLK/0541", "requisitioning_officer": {"emp_id": "1095892", "designation": "SSE_PWAY_AZ_SUB_DIV", "mobile": "9771469146"}, "location_details": {"division": "Howrah (HWH)", "section": "Azimganj - Nalhati", "block_section": "Morgram (MGAE) - Nalhati Jn (NHT)", "line": "Single Line", "from_km": "28.979", "to_km": "30.400"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-12", "requested_window": {"duration_minutes": 150, "preferred_start": "17:30", "preferred_end": "20:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 028/06 - 030/17", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0542', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-LDH (Ambala Cantt - Ludhiana)', 'Ambala Cantt (UMB) - Rajpura Jn (RPJ)', 'DN Main Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-13', 90,
    '11:30', '13:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0542", "requisitioning_officer": {"emp_id": "1074896", "designation": "SSE_PWAY_UMB_SUB_DIV", "mobile": "9717676308"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-LDH (Ambala Cantt - Ludhiana)", "block_section": "Ambala Cantt (UMB) - Rajpura Jn (RPJ)", "line": "DN Main Line", "from_km": "199.759", "to_km": "203.197"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 90, "preferred_start": "11:30", "preferred_end": "13:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 199/11 - 203/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0543', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-LDH (Ambala Cantt - Ludhiana)', 'Rajpura Jn (RPJ) - Sirhind Jn (SIR)', 'UP Main Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-13', 150,
    '14:00', '16:30', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0543", "requisitioning_officer": {"emp_id": "1066197", "designation": "SSE_PWAY_UMB_SUB_DIV", "mobile": "9717695257"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-LDH (Ambala Cantt - Ludhiana)", "block_section": "Rajpura Jn (RPJ) - Sirhind Jn (SIR)", "line": "UP Main Line", "from_km": "228.663", "to_km": "229.946"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 150, "preferred_start": "14:00", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 228/13 - 229/28", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0544', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-LDH (Ambala Cantt - Ludhiana)', 'Sirhind Jn (SIR) - Khanna (KNN)', 'UP Main Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-13', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0544", "requisitioning_officer": {"emp_id": "1054025", "designation": "SSE_PWAY_UMB_SUB_DIV", "mobile": "9717640710"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-LDH (Ambala Cantt - Ludhiana)", "block_section": "Sirhind Jn (SIR) - Khanna (KNN)", "line": "UP Main Line", "from_km": "254.142", "to_km": "257.730"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 254/06 - 257/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0545', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'LDH-BTI (Ludhiana - Bathinda)', 'Ludhiana Jn (LDH) - Mullanpur (MLX)', 'Single Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-13', 150,
    '11:30', '14:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0545", "requisitioning_officer": {"emp_id": "1095115", "designation": "SSE_PWAY_LDH_SUB_DIV", "mobile": "9717636774"}, "location_details": {"division": "Ambala (UMB)", "section": "LDH-BTI (Ludhiana - Bathinda)", "block_section": "Ludhiana Jn (LDH) - Mullanpur (MLX)", "line": "Single Line", "from_km": "1.588", "to_km": "3.934"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 150, "preferred_start": "11:30", "preferred_end": "14:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/11 - 003/16", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0546', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'LDH-BTI (Ludhiana - Bathinda)', 'Mullanpur (MLX) - Jagraon (JGN)', 'Single Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-13', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0546", "requisitioning_officer": {"emp_id": "1096654", "designation": "SSE_PWAY_LDH_SUB_DIV", "mobile": "9717648522"}, "location_details": {"division": "Ambala (UMB)", "section": "LDH-BTI (Ludhiana - Bathinda)", "block_section": "Mullanpur (MLX) - Jagraon (JGN)", "line": "Single Line", "from_km": "21.521", "to_km": "24.964"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 021/02 - 024/18", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0547', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'LDH-BTI (Ludhiana - Bathinda)', 'Jagraon (JGN) - Moga (MOG)', 'Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-13', 180,
    '17:30', '20:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0547", "requisitioning_officer": {"emp_id": "1086776", "designation": "SSE_PWAY_LDH_SUB_DIV", "mobile": "9717698577"}, "location_details": {"division": "Ambala (UMB)", "section": "LDH-BTI (Ludhiana - Bathinda)", "block_section": "Jagraon (JGN) - Moga (MOG)", "line": "Single Line", "from_km": "40.548", "to_km": "41.929"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 180, "preferred_start": "17:30", "preferred_end": "20:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 040/03 - 041/21", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0548', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-CDG-KLK (Ambala - Chandigarh - Kalka)', 'Ambala Cantt (UMB) - Lalru (LLU)', 'DN Main Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-13', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0548", "requisitioning_officer": {"emp_id": "1097940", "designation": "SSE_PWAY_CDG_SUB_DIV", "mobile": "9717697942"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)", "block_section": "Ambala Cantt (UMB) - Lalru (LLU)", "line": "DN Main Line", "from_km": "1.592", "to_km": "5.315"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/03 - 005/17", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0549', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-CDG-KLK (Ambala - Chandigarh - Kalka)', 'Lalru (LLU) - Chandigarh Jn (CDG)', 'UP Main Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-13', 180,
    '14:00', '17:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0549", "requisitioning_officer": {"emp_id": "1097664", "designation": "SSE_PWAY_CDG_SUB_DIV", "mobile": "9717635137"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)", "block_section": "Lalru (LLU) - Chandigarh Jn (CDG)", "line": "UP Main Line", "from_km": "19.665", "to_km": "22.049"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 180, "preferred_start": "14:00", "preferred_end": "17:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 019/08 - 022/24", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0550', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-CDG-KLK (Ambala - Chandigarh - Kalka)', 'Chandigarh Jn (CDG) - Chandi Mandir (CNDM)', 'UP Main Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-13', 210,
    '17:30', '21:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0550", "requisitioning_officer": {"emp_id": "1094452", "designation": "SSE_PWAY_CDG_SUB_DIV", "mobile": "9717628185"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-CDG-KLK (Ambala - Chandigarh - Kalka)", "block_section": "Chandigarh Jn (CDG) - Chandi Mandir (CNDM)", "line": "UP Main Line", "from_km": "47.293", "to_km": "49.623"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-13", "requested_window": {"duration_minutes": 210, "preferred_start": "17:30", "preferred_end": "21:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0551', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'KLK-SML (Kalka - Shimla)', 'Kalka (KLK) - Dharampur Himachal (DMP)', 'Narrow Gauge Heritage Track',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-14', 180,
    '11:30', '14:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0551", "requisitioning_officer": {"emp_id": "1084530", "designation": "SSE_PWAY_KLK_SUB_DIV", "mobile": "9717617581"}, "location_details": {"division": "Ambala (UMB)", "section": "KLK-SML (Kalka - Shimla)", "block_section": "Kalka (KLK) - Dharampur Himachal (DMP)", "line": "Narrow Gauge Heritage Track", "from_km": "1.340", "to_km": "2.711"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 180, "preferred_start": "11:30", "preferred_end": "14:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/12 - 002/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0552', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'KLK-SML (Kalka - Shimla)', 'Dharampur Himachal (DMP) - Barog (BOF)', 'Narrow Gauge Heritage Track',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-14', 210,
    '14:00', '17:30', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0552", "requisitioning_officer": {"emp_id": "1071268", "designation": "SSE_PWAY_KLK_SUB_DIV", "mobile": "9717664888"}, "location_details": {"division": "Ambala (UMB)", "section": "KLK-SML (Kalka - Shimla)", "block_section": "Dharampur Himachal (DMP) - Barog (BOF)", "line": "Narrow Gauge Heritage Track", "from_km": "35.096", "to_km": "37.733"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 210, "preferred_start": "14:00", "preferred_end": "17:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0553', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'KLK-SML (Kalka - Shimla)', 'Barog (BOF) - Solan (SOL)', 'Narrow Gauge Heritage Track',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-14', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0553", "requisitioning_officer": {"emp_id": "1058560", "designation": "SSE_PWAY_KLK_SUB_DIV", "mobile": "9717699408"}, "location_details": {"division": "Ambala (UMB)", "section": "KLK-SML (Kalka - Shimla)", "block_section": "Barog (BOF) - Solan (SOL)", "line": "Narrow Gauge Heritage Track", "from_km": "43.574", "to_km": "47.226"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 043/04 - 047/20", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0554', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-SRE (Ambala - Saharanpur)', 'Ambala Cantt (UMB) - Barara (RAA)', 'UP Main Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-14', 210,
    '11:30', '15:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0554", "requisitioning_officer": {"emp_id": "1055489", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717611007"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-SRE (Ambala - Saharanpur)", "block_section": "Ambala Cantt (UMB) - Barara (RAA)", "line": "UP Main Line", "from_km": "0.463", "to_km": "3.689"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 210, "preferred_start": "11:30", "preferred_end": "15:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0555', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-SRE (Ambala - Saharanpur)', 'Barara (RAA) - Yamunanagar Jagadhri (YJUD)', 'DN Main Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-14', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0555", "requisitioning_officer": {"emp_id": "1088712", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717639552"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-SRE (Ambala - Saharanpur)", "block_section": "Barara (RAA) - Yamunanagar Jagadhri (YJUD)", "line": "DN Main Line", "from_km": "26.756", "to_km": "28.963"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 026/08 - 028/31", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0556', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-SRE (Ambala - Saharanpur)', 'Yamunanagar Jagadhri (YJUD) - Sarsawa (SSW)', 'DN Main Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-14', 120,
    '17:30', '19:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0556", "requisitioning_officer": {"emp_id": "1068857", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717699207"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-SRE (Ambala - Saharanpur)", "block_section": "Yamunanagar Jagadhri (YJUD) - Sarsawa (SSW)", "line": "DN Main Line", "from_km": "53.285", "to_km": "57.042"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 120, "preferred_start": "17:30", "preferred_end": "19:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0557', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-JUDW (Ambala - Jagadhri / Yamunanagar)', 'Ambala Cantt (UMB) - Kesri (KES)', 'UP Main Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-14', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0557", "requisitioning_officer": {"emp_id": "1099560", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717655150"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)", "block_section": "Ambala Cantt (UMB) - Kesri (KES)", "line": "UP Main Line", "from_km": "1.784", "to_km": "3.808"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/11 - 003/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0558', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-JUDW (Ambala - Jagadhri / Yamunanagar)', 'Kesri (KES) - Mustafabad (MFB)', 'UP Main Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-14', 120,
    '14:00', '16:00', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0558", "requisitioning_officer": {"emp_id": "1058983", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717684055"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)", "block_section": "Kesri (KES) - Mustafabad (MFB)", "line": "UP Main Line", "from_km": "15.603", "to_km": "18.390"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 120, "preferred_start": "14:00", "preferred_end": "16:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0559', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-JUDW (Ambala - Jagadhri / Yamunanagar)', 'Mustafabad (MFB) - Jagadhri Workshop (JUDW)', 'DN Main Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-14', 300,
    '17:30', '22:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0559", "requisitioning_officer": {"emp_id": "1050424", "designation": "SSE_PWAY_JUDW_SUB_DIV", "mobile": "9717633672"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-JUDW (Ambala - Jagadhri / Yamunanagar)", "block_section": "Mustafabad (MFB) - Jagadhri Workshop (JUDW)", "line": "DN Main Line", "from_km": "37.929", "to_km": "39.465"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-14", "requested_window": {"duration_minutes": 300, "preferred_start": "17:30", "preferred_end": "22:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 037/13 - 039/18", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0560', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-KKDE (Ambala - Kurukshetra)', 'Ambala Cantt (UMB) - Mohri (MOY)', 'UP Main Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-15', 120,
    '11:30', '13:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0560", "requisitioning_officer": {"emp_id": "1075312", "designation": "SSE_PWAY_KKDE_SUB_DIV", "mobile": "9717691646"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-KKDE (Ambala - Kurukshetra)", "block_section": "Ambala Cantt (UMB) - Mohri (MOY)", "line": "UP Main Line", "from_km": "200.579", "to_km": "189.000"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 120, "preferred_start": "11:30", "preferred_end": "13:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0561', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-KKDE (Ambala - Kurukshetra)', 'Mohri (MOY) - Shahbad Markanda (SHDM)', 'UP Main Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-15', 300,
    '14:00', '19:00', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0561", "requisitioning_officer": {"emp_id": "1086388", "designation": "SSE_PWAY_KKDE_SUB_DIV", "mobile": "9717613613"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-KKDE (Ambala - Kurukshetra)", "block_section": "Mohri (MOY) - Shahbad Markanda (SHDM)", "line": "UP Main Line", "from_km": "190.763", "to_km": "179.300"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 300, "preferred_start": "14:00", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 190/13 - 179/20", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0562', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'UMB-KKDE (Ambala - Kurukshetra)', 'Shahbad Markanda (SHDM) - Kurukshetra Jn (KKDE)', 'UP Main Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-15', 90,
    '17:30', '19:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0562", "requisitioning_officer": {"emp_id": "1087514", "designation": "SSE_PWAY_KKDE_SUB_DIV", "mobile": "9717628405"}, "location_details": {"division": "Ambala (UMB)", "section": "UMB-KKDE (Ambala - Kurukshetra)", "block_section": "Shahbad Markanda (SHDM) - Kurukshetra Jn (KKDE)", "line": "UP Main Line", "from_km": "181.141", "to_km": "157.000"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 90, "preferred_start": "17:30", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 181/13 - 157/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0563', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-BTI (Rajpura - Bathinda)', 'Rajpura Jn (RPJ) - Patiala (PTA)', 'UP Main Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-15', 300,
    '11:30', '16:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0563", "requisitioning_officer": {"emp_id": "1088903", "designation": "SSE_PWAY_RPJ_SUB_DIV", "mobile": "9717698215"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-BTI (Rajpura - Bathinda)", "block_section": "Rajpura Jn (RPJ) - Patiala (PTA)", "line": "UP Main Line", "from_km": "1.576", "to_km": "2.777"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 300, "preferred_start": "11:30", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/14 - 002/30", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0564', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-BTI (Rajpura - Bathinda)', 'Patiala (PTA) - Nabha (NBA)', 'UP Main Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-15', 90,
    '14:00', '15:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0564", "requisitioning_officer": {"emp_id": "1088290", "designation": "SSE_PWAY_RPJ_SUB_DIV", "mobile": "9717623171"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-BTI (Rajpura - Bathinda)", "block_section": "Patiala (PTA) - Nabha (NBA)", "line": "UP Main Line", "from_km": "27.870", "to_km": "30.408"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 90, "preferred_start": "14:00", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 027/11 - 030/19", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0565', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-BTI (Rajpura - Bathinda)', 'Nabha (NBA) - Dhuri Jn (DUI)', 'UP Main Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-15', 150,
    '17:30', '20:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0565", "requisitioning_officer": {"emp_id": "1071614", "designation": "SSE_PWAY_RPJ_SUB_DIV", "mobile": "9717683132"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-BTI (Rajpura - Bathinda)", "block_section": "Nabha (NBA) - Dhuri Jn (DUI)", "line": "UP Main Line", "from_km": "52.068", "to_km": "55.656"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 150, "preferred_start": "17:30", "preferred_end": "20:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 052/09 - 055/31", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0566', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-DUI (Rajpura - Dhuri)', 'Rajpura Jn (RPJ) - Kauli (KLI)', 'UP Line',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-15', 90,
    '11:30', '13:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0566", "requisitioning_officer": {"emp_id": "1058133", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717617365"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-DUI (Rajpura - Dhuri)", "block_section": "Rajpura Jn (RPJ) - Kauli (KLI)", "line": "UP Line", "from_km": "2.166", "to_km": "5.543"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 90, "preferred_start": "11:30", "preferred_end": "13:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/08 - 005/29", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0567', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-DUI (Rajpura - Dhuri)', 'Kauli (KLI) - Patiala (PTA)', 'UP Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-15', 150,
    '14:00', '16:30', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0567", "requisitioning_officer": {"emp_id": "1071848", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717648813"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-DUI (Rajpura - Dhuri)", "block_section": "Kauli (KLI) - Patiala (PTA)", "line": "UP Line", "from_km": "11.751", "to_km": "12.853"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 150, "preferred_start": "14:00", "preferred_end": "16:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 011/07 - 012/26", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0568', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'RPJ-DUI (Rajpura - Dhuri)', 'Patiala (PTA) - Chhajli (CJL)', 'UP Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-15', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0568", "requisitioning_officer": {"emp_id": "1062617", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717689678"}, "location_details": {"division": "Ambala (UMB)", "section": "RPJ-DUI (Rajpura - Dhuri)", "block_section": "Patiala (PTA) - Chhajli (CJL)", "line": "UP Line", "from_km": "26.914", "to_km": "29.616"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-15", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 026/03 - 029/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0569', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'DUI-LDH (Dhuri - Ludhiana)', 'Dhuri Jn (DUI) - Malerkotla (MET)', 'Single Line',
    'Tamping Machine (CSM) Deployment', 'Planned Rolling Block', '2026-09-16', 150,
    '11:30', '14:00', TRUE, TRUE,
    50, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0569", "requisitioning_officer": {"emp_id": "1095361", "designation": "SSE_PWAY_DUI_SUB_DIV", "mobile": "9717668089"}, "location_details": {"division": "Ambala (UMB)", "section": "DUI-LDH (Dhuri - Ludhiana)", "block_section": "Dhuri Jn (DUI) - Malerkotla (MET)", "line": "Single Line", "from_km": "1.444", "to_km": "4.438"}, "block_specifications": {"work_type": "Tamping Machine (CSM) Deployment", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 150, "preferred_start": "11:30", "preferred_end": "14:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 001/02 - 004/21", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 50, "normal_speed_restoration_hrs": 48}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0570', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'DUI-LDH (Dhuri - Ludhiana)', 'Malerkotla (MET) - Ahmedgarh (AHH)', 'Single Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-16', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0570", "requisitioning_officer": {"emp_id": "1087122", "designation": "SSE_PWAY_DUI_SUB_DIV", "mobile": "9717619225"}, "location_details": {"division": "Ambala (UMB)", "section": "DUI-LDH (Dhuri - Ludhiana)", "block_section": "Malerkotla (MET) - Ahmedgarh (AHH)", "line": "Single Line", "from_km": "19.214", "to_km": "20.362"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 019/06 - 020/27", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0571', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'DUI-LDH (Dhuri - Ludhiana)', 'Ahmedgarh (AHH) - Qila Raipur (QRP)', 'Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-16', 180,
    '17:30', '20:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0571", "requisitioning_officer": {"emp_id": "1093722", "designation": "SSE_PWAY_DUI_SUB_DIV", "mobile": "9717667434"}, "location_details": {"division": "Ambala (UMB)", "section": "DUI-LDH (Dhuri - Ludhiana)", "block_section": "Ahmedgarh (AHH) - Qila Raipur (QRP)", "line": "Single Line", "from_km": "37.127", "to_km": "40.785"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 180, "preferred_start": "17:30", "preferred_end": "20:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 037/05 - 040/32", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0572', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-NLDM (Sirhind - Nangal Dam)', 'Sirhind Jn (SIR) - Morinda Jn (MRND)', 'Single Line',
    'Ballast Cleaning Machine (BCM) Deep Screening', 'Planned Corridor Block', '2026-09-16', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0572", "requisitioning_officer": {"emp_id": "1081988", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717681138"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-NLDM (Sirhind - Nangal Dam)", "block_section": "Sirhind Jn (SIR) - Morinda Jn (MRND)", "line": "Single Line", "from_km": "2.629", "to_km": "4.705"}, "block_specifications": {"work_type": "Ballast Cleaning Machine (BCM) Deep Screening", "demand_nature": "Planned Corridor Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/08 - 004/25", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0573', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-NLDM (Sirhind - Nangal Dam)', 'Morinda Jn (MRND) - Rupnagar (RPAR)', 'Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-16', 180,
    '14:00', '17:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0573", "requisitioning_officer": {"emp_id": "1054273", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717648258"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-NLDM (Sirhind - Nangal Dam)", "block_section": "Morinda Jn (MRND) - Rupnagar (RPAR)", "line": "Single Line", "from_km": "25.578", "to_km": "27.056"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 180, "preferred_start": "14:00", "preferred_end": "17:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 025/11 - 027/20", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0574', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-NLDM (Sirhind - Nangal Dam)', 'Rupnagar (RPAR) - Kiratpur Sahib (KART)', 'Single Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-16', 210,
    '17:30', '21:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0574", "requisitioning_officer": {"emp_id": "1084712", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717670430"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-NLDM (Sirhind - Nangal Dam)", "block_section": "Rupnagar (RPAR) - Kiratpur Sahib (KART)", "line": "Single Line", "from_km": "50.667", "to_km": "52.769"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 210, "preferred_start": "17:30", "preferred_end": "21:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0575', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-AADR (Sirhind - Amb Andaura)', 'Nangal Dam (NLDM) - Mehatpur (MTPR)', 'Hill Section Single Line',
    'Points & Crossing Tamping (UNIMAT)', 'Planned Rolling Block', '2026-09-16', 180,
    '11:30', '14:30', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0575", "requisitioning_officer": {"emp_id": "1093615", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717658156"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-AADR (Sirhind - Amb Andaura)", "block_section": "Nangal Dam (NLDM) - Mehatpur (MTPR)", "line": "Hill Section Single Line", "from_km": "100.681", "to_km": "103.205"}, "block_specifications": {"work_type": "Points & Crossing Tamping (UNIMAT)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 180, "preferred_start": "11:30", "preferred_end": "14:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 100/09 - 103/31", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 36}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0576', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-AADR (Sirhind - Amb Andaura)', 'Mehatpur (MTPR) - Una Himachal (UHL)', 'Hill Section Single Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-16', 210,
    '14:00', '17:30', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0576", "requisitioning_officer": {"emp_id": "1094600", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717691449"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-AADR (Sirhind - Amb Andaura)", "block_section": "Mehatpur (MTPR) - Una Himachal (UHL)", "line": "Hill Section Single Line", "from_km": "106.666", "to_km": "108.904"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 210, "preferred_start": "14:00", "preferred_end": "17:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0577', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SIR-AADR (Sirhind - Amb Andaura)', 'Una Himachal (UHL) - Churaru Takrala (CHTL)', 'Hill Section Single Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-16', 240,
    '17:30', '21:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0577", "requisitioning_officer": {"emp_id": "1061755", "designation": "SSE_PWAY_SIR_SUB_DIV", "mobile": "9717630738"}, "location_details": {"division": "Ambala (UMB)", "section": "SIR-AADR (Sirhind - Amb Andaura)", "block_section": "Una Himachal (UHL) - Churaru Takrala (CHTL)", "line": "Hill Section Single Line", "from_km": "118.753", "to_km": "122.171"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-16", "requested_window": {"duration_minutes": 240, "preferred_start": "17:30", "preferred_end": "21:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 118/14 - 122/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0578', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'PTA-DUI (Patiala - Dhuri)', 'Patiala (PTA) - Dhablan (DBN)', 'UP Main Line',
    'Rail Grinding Machine (RGM) Operations', 'Night Traffic Block', '2026-09-17', 210,
    '11:30', '15:00', FALSE, FALSE,
    75, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0578", "requisitioning_officer": {"emp_id": "1063799", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717640647"}, "location_details": {"division": "Ambala (UMB)", "section": "PTA-DUI (Patiala - Dhuri)", "block_section": "Patiala (PTA) - Dhablan (DBN)", "line": "UP Main Line", "from_km": "27.727", "to_km": "30.325"}, "block_specifications": {"work_type": "Rail Grinding Machine (RGM) Operations", "demand_nature": "Night Traffic Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 210, "preferred_start": "11:30", "preferred_end": "15:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 75, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0579', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'PTA-DUI (Patiala - Dhuri)', 'Dhablan (DBN) - Nabha (NBA)', 'UP Main Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-17', 240,
    '14:00', '18:00', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0579", "requisitioning_officer": {"emp_id": "1069550", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717630153"}, "location_details": {"division": "Ambala (UMB)", "section": "PTA-DUI (Patiala - Dhuri)", "block_section": "Dhablan (DBN) - Nabha (NBA)", "line": "UP Main Line", "from_km": "39.650", "to_km": "42.614"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 240, "preferred_start": "14:00", "preferred_end": "18:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 039/02 - 042/21", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0580', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'PTA-DUI (Patiala - Dhuri)', 'Nabha (NBA) - Sekha (SEQ)', 'UP Main Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-17', 120,
    '17:30', '19:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0580", "requisitioning_officer": {"emp_id": "1069973", "designation": "SSE_PWAY_PTA_SUB_DIV", "mobile": "9717610289"}, "location_details": {"division": "Ambala (UMB)", "section": "PTA-DUI (Patiala - Dhuri)", "block_section": "Nabha (NBA) - Sekha (SEQ)", "line": "UP Main Line", "from_km": "51.867", "to_km": "53.796"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 120, "preferred_start": "17:30", "preferred_end": "19:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0581', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'BTI-Abohar side (Bathinda - Abohar)', 'Bathinda Jn (BTI) - Balluana (BHX)', 'Single Line',
    'Through Rail Renewal (TRR) / Rail Panel Insertion', 'Planned Mega Block', '2026-09-17', 240,
    '11:30', '15:30', TRUE, TRUE,
    30, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0581", "requisitioning_officer": {"emp_id": "1078005", "designation": "SSE_PWAY_BTI_SUB_DIV", "mobile": "9717673400"}, "location_details": {"division": "Ambala (UMB)", "section": "BTI-Abohar side (Bathinda - Abohar)", "block_section": "Bathinda Jn (BTI) - Balluana (BHX)", "line": "Single Line", "from_km": "2.354", "to_km": "5.837"}, "block_specifications": {"work_type": "Through Rail Renewal (TRR) / Rail Panel Insertion", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 240, "preferred_start": "11:30", "preferred_end": "15:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 002/06 - 005/25", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 30, "normal_speed_restoration_hrs": 72}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0582', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'BTI-Abohar side (Bathinda - Abohar)', 'Balluana (BHX) - Giddarbaha (GDB)', 'Single Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-17', 120,
    '14:00', '16:00', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0582", "requisitioning_officer": {"emp_id": "1083341", "designation": "SSE_PWAY_BTI_SUB_DIV", "mobile": "9717651353"}, "location_details": {"division": "Ambala (UMB)", "section": "BTI-Abohar side (Bathinda - Abohar)", "block_section": "Balluana (BHX) - Giddarbaha (GDB)", "line": "Single Line", "from_km": "19.628", "to_km": "21.010"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 120, "preferred_start": "14:00", "preferred_end": "16:00"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0583', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'BTI-Abohar side (Bathinda - Abohar)', 'Giddarbaha (GDB) - Malout (MOT)', 'Single Line',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-17', 300,
    '17:30', '22:30', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0583", "requisitioning_officer": {"emp_id": "1055504", "designation": "SSE_PWAY_BTI_SUB_DIV", "mobile": "9717693897"}, "location_details": {"division": "Ambala (UMB)", "section": "BTI-Abohar side (Bathinda - Abohar)", "block_section": "Giddarbaha (GDB) - Malout (MOT)", "line": "Single Line", "from_km": "30.769", "to_km": "32.762"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 300, "preferred_start": "17:30", "preferred_end": "22:30"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 030/08 - 032/26", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0584', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SRE-UDN / connecting routes (Saharanpur area)', 'Saharanpur Jn (SRE) - Khanalampura Yard (KJGY)', 'Yard Reception Line',
    'Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)', 'Planned Rolling Block', '2026-09-17', 120,
    '11:30', '13:30', FALSE, FALSE,
    60, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0584", "requisitioning_officer": {"emp_id": "1051904", "designation": "SSE_PWAY_SRE_SUB_DIV", "mobile": "9717623888"}, "location_details": {"division": "Ambala (UMB)", "section": "SRE-UDN / connecting routes (Saharanpur area)", "block_section": "Saharanpur Jn (SRE) - Khanalampura Yard (KJGY)", "line": "Yard Reception Line", "from_km": "2.782", "to_km": "3.911"}, "block_specifications": {"work_type": "Dynamic Track Stabilizer (DTS) & Ballast Regulating (BRM)", "demand_nature": "Planned Rolling Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 120, "preferred_start": "11:30", "preferred_end": "13:30"}}, "interdepartmental_dependencies": {"power_block_required": false, "trd_details": "None. Work below rail flange level, electrical clearance not infringed", "st_disconnection_required": false, "st_details": "No S&T gear disconnection required"}, "speed_restriction_proposed": {"post_work_speed_kmph": 60, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0585', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SRE-UDN / connecting routes (Saharanpur area)', 'Khanalampura Yard (KJGY) - Baliakheri (BAE)', 'DN Freight Corridor',
    'Turnout Renewal (T-28 Machine / Portal Crane Deployment)', 'Planned Mega Block', '2026-09-17', 300,
    '14:00', '19:00', TRUE, TRUE,
    20, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0585", "requisitioning_officer": {"emp_id": "1048860", "designation": "SSE_PWAY_SRE_SUB_DIV", "mobile": "9717645014"}, "location_details": {"division": "Ambala (UMB)", "section": "SRE-UDN / connecting routes (Saharanpur area)", "block_section": "Khanalampura Yard (KJGY) - Baliakheri (BAE)", "line": "DN Freight Corridor", "from_km": "5.973", "to_km": "9.576"}, "block_specifications": {"work_type": "Turnout Renewal (T-28 Machine / Portal Crane Deployment)", "demand_nature": "Planned Mega Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 300, "preferred_start": "14:00", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 005/12 - 009/23", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 20, "normal_speed_restoration_hrs": 96}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO tms_civil_demands (
    demand_ref_id, source_system, division, section, block_section, line_name,
    work_type, demand_nature, preferred_date, duration_minutes,
    preferred_start, preferred_end, power_block_required, st_disconnection_required,
    post_work_speed_kmph, payload
) VALUES (
    'TMS/UMB/2026/BLK/0586', 'TMS_CIVIL_ENGG', 'Ambala (UMB)', 'SRE-UDN / connecting routes (Saharanpur area)', 'Baliakheri (BAE) - Deoband (DBD)', 'UP Freight Corridor',
    'Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)', 'Urgent Maintenance Block', '2026-09-17', 90,
    '17:30', '19:00', TRUE, TRUE,
    45, '{"source_system": "TMS_CIVIL_ENGG", "demand_ref_id": "TMS/UMB/2026/BLK/0586", "requisitioning_officer": {"emp_id": "1085483", "designation": "SSE_PWAY_SRE_SUB_DIV", "mobile": "9717685383"}, "location_details": {"division": "Ambala (UMB)", "section": "SRE-UDN / connecting routes (Saharanpur area)", "block_section": "Baliakheri (BAE) - Deoband (DBD)", "line": "UP Freight Corridor", "from_km": "14.594", "to_km": "18.272"}, "block_specifications": {"work_type": "Ultrasonic Flaw Detection (USFD) Defect Rail Piece Replacement (Casual Renewal)", "demand_nature": "Urgent Maintenance Block", "preferred_date": "2026-09-17", "requested_window": {"duration_minutes": 90, "preferred_start": "17:30", "preferred_end": "19:00"}}, "interdepartmental_dependencies": {"power_block_required": true, "trd_details": "OHE isolation required between Masts 014/07 - 018/30", "st_disconnection_required": true, "st_details": "Axle counters & track circuit bonding disconnection with S&T staff at site"}, "speed_restriction_proposed": {"post_work_speed_kmph": 45, "normal_speed_restoration_hrs": 24}}'::jsonb
) ON CONFLICT (demand_ref_id) DO UPDATE SET payload = EXCLUDED.payload;