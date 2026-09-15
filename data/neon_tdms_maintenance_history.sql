-- ========================================================================
-- NEON POSTGRESQL SCHEMA & INSERTS FOR INDIAN RAILWAYS TDMS MAINTENANCE HISTORY
-- SIH Problem Statement - Traction Distribution Management System (TDMS / Electrical TRD)
-- Zones: EASTERN RAILWAY (ASN & HWH Divisions), NORTHERN RAILWAY (UMB Division)
-- ========================================================================

CREATE TABLE IF NOT EXISTS tdms_maintenance_history (
    job_id VARCHAR(64) PRIMARY KEY,
    source_system VARCHAR(32) NOT NULL DEFAULT 'TDMS_ELECTRICAL_TRD',
    department VARCHAR(32) NOT NULL DEFAULT 'TRD',
    zone VARCHAR(64) NOT NULL,
    zone_code VARCHAR(16) NOT NULL,
    division VARCHAR(32) NOT NULL,
    division_name VARCHAR(64) NOT NULL,
    section VARCHAR(128) NOT NULL,
    section_display VARCHAR(128) NOT NULL,
    block_section VARCHAR(128) NOT NULL,
    block_section_name VARCHAR(128) NOT NULL,
    line VARCHAR(64) NOT NULL,
    work_type VARCHAR(128) NOT NULL,
    asset_type VARCHAR(64) NOT NULL,
    severity VARCHAR(32) NOT NULL,
    criticality VARCHAR(32) NOT NULL,
    overdue_days INTEGER NOT NULL,
    crew_size INTEGER NOT NULL,
    equipment VARCHAR(128) NOT NULL,
    requested_duration_min INTEGER NOT NULL,
    actual_duration_min INTEGER NOT NULL,
    actual_start TIMESTAMP NOT NULL,
    actual_end TIMESTAMP NOT NULL,
    completion_status VARCHAR(64) NOT NULL,
    payload JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tdms_mh_div ON tdms_maintenance_history (division);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_zone ON tdms_maintenance_history (zone_code);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_section ON tdms_maintenance_history (section);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_bsec ON tdms_maintenance_history (block_section);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_work ON tdms_maintenance_history (work_type);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_asset ON tdms_maintenance_history (asset_type);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_start ON tdms_maintenance_history (actual_start);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_crit ON tdms_maintenance_history (criticality);
CREATE INDEX IF NOT EXISTS idx_tdms_mh_payload ON tdms_maintenance_history USING gin (payload);

CREATE OR REPLACE VIEW maintenance_history AS SELECT * FROM tdms_maintenance_history;

CREATE TABLE IF NOT EXISTS tdms_maintenance_feed (
    id SERIAL PRIMARY KEY,
    source_system VARCHAR(32) NOT NULL,
    department VARCHAR(32) NOT NULL,
    record_count INTEGER NOT NULL,
    payload JSONB NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------
-- INSERT STATEMENTS FOR 767 TDMS RECORDS
-- ------------------------------------------------------------------------

INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0001', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'DUJ-SURI', 'Dubrajpur - Siuri', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'High',
    4, 7, 'Tower Wagon',
    90, 105, '2026-07-04T02:10:00', '2026-07-04T03:55:00',
    'Completed', '{"job_id": "TDMS-H0001", "division": "ASN", "section": "UDL-SNT", "block_section": "DUJ-SURI", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 105, "actual_start": "2026-07-04T02:10:00", "actual_end": "2026-07-04T03:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0002', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UKA-PAW', 'Ukhra - Pandabeswar', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    2, 5, 'Tower Wagon',
    60, 78, '2026-07-06T17:45:00', '2026-07-06T19:03:00',
    'Completed', '{"job_id": "TDMS-H0002", "division": "ASN", "section": "UDL-SNT", "block_section": "UKA-PAW", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 78, "actual_start": "2026-07-06T17:45:00", "actual_end": "2026-07-06T19:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0003', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Critical',
    0, 7, 'Tower Wagon',
    90, 84, '2026-07-07T11:30:00', '2026-07-07T12:54:00',
    'Completed', '{"job_id": "TDMS-H0003", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 84, "actual_start": "2026-07-07T11:30:00", "actual_end": "2026-07-07T12:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0004', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Medium',
    1, 4, 'Tower Wagon',
    90, 107, '2026-07-10T16:50:00', '2026-07-10T18:37:00',
    'Completed', '{"job_id": "TDMS-H0004", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 107, "actual_start": "2026-07-10T16:50:00", "actual_end": "2026-07-10T18:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0005', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    4, 5, 'Ladder & Contact Burnisher',
    60, 55, '2026-07-15T04:10:00', '2026-07-15T05:05:00',
    'Completed', '{"job_id": "TDMS-H0005", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 4, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-07-15T04:10:00", "actual_end": "2026-07-15T05:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0006', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'DUJ-SURI', 'Dubrajpur - Siuri', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    1, 7, 'Tower Wagon',
    90, 105, '2026-07-19T04:30:00', '2026-07-19T06:15:00',
    'Completed', '{"job_id": "TDMS-H0006", "division": "ASN", "section": "UDL-SNT", "block_section": "DUJ-SURI", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 105, "actual_start": "2026-07-19T04:30:00", "actual_end": "2026-07-19T06:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0007', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'SURI-SNT', 'Siuri - Sainthia', 'DN_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Medium', 'High',
    1, 8, 'Oil Filtration Plant',
    165, 165, '2026-07-19T04:50:00', '2026-07-19T07:35:00',
    'Completed', '{"job_id": "TDMS-H0007", "division": "ASN", "section": "UDL-SNT", "block_section": "SURI-SNT", "line": "DN_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 165, "actual_start": "2026-07-19T04:50:00", "actual_end": "2026-07-19T07:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0008', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'Medium', 'Critical',
    5, 10, 'Tower Wagon',
    120, 113, '2026-07-19T12:55:00', '2026-07-19T14:48:00',
    'Completed', '{"job_id": "TDMS-H0008", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 113, "actual_start": "2026-07-19T12:55:00", "actual_end": "2026-07-19T14:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0009', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    0, 9, 'Tower Wagon',
    150, 143, '2026-07-23T16:35:00', '2026-07-23T18:58:00',
    'Completed', '{"job_id": "TDMS-H0009", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 143, "actual_start": "2026-07-23T16:35:00", "actual_end": "2026-07-23T18:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0010', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'SURI-SNT', 'Siuri - Sainthia', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    4, 4, 'Inspection Vehicle',
    90, 92, '2026-07-27T12:05:00', '2026-07-27T13:37:00',
    'Completed', '{"job_id": "TDMS-H0010", "division": "ASN", "section": "UDL-SNT", "block_section": "SURI-SNT", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 4, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 92, "actual_start": "2026-07-27T12:05:00", "actual_end": "2026-07-27T13:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0011', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    4, 6, 'Ladder & Tension Meter',
    105, 116, '2026-07-30T01:15:00', '2026-07-30T03:11:00',
    'Completed', '{"job_id": "TDMS-H0011", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 116, "actual_start": "2026-07-30T01:15:00", "actual_end": "2026-07-30T03:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0012', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    0, 6, 'Tower Wagon',
    90, 80, '2026-08-02T15:15:00', '2026-08-02T16:35:00',
    'Completed', '{"job_id": "TDMS-H0012", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-08-02T15:15:00", "actual_end": "2026-08-02T16:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0013', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'SURI-SNT', 'Siuri - Sainthia', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    3, 5, 'Tower Wagon',
    120, 120, '2026-08-04T01:45:00', '2026-08-04T03:45:00',
    'Completed', '{"job_id": "TDMS-H0013", "division": "ASN", "section": "UDL-SNT", "block_section": "SURI-SNT", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 120, "actual_start": "2026-08-04T01:45:00", "actual_end": "2026-08-04T03:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0014', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'DN_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Low', 'Medium',
    0, 5, 'Tower Wagon',
    75, 72, '2026-08-05T15:00:00', '2026-08-05T16:12:00',
    'Completed', '{"job_id": "TDMS-H0014", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "DN_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 72, "actual_start": "2026-08-05T15:00:00", "actual_end": "2026-08-05T16:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0015', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    1, 4, 'Earth Tester & Bonding Kit',
    45, 61, '2026-08-07T04:50:00', '2026-08-07T05:51:00',
    'Completed', '{"job_id": "TDMS-H0015", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 61, "actual_start": "2026-08-07T04:50:00", "actual_end": "2026-08-07T05:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0016', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UKA-PAW', 'Ukhra - Pandabeswar', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Critical',
    3, 5, 'Tower Wagon',
    60, 62, '2026-08-08T15:35:00', '2026-08-08T16:37:00',
    'Completed', '{"job_id": "TDMS-H0016", "division": "ASN", "section": "UDL-SNT", "block_section": "UKA-PAW", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 62, "actual_start": "2026-08-08T15:35:00", "actual_end": "2026-08-08T16:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0017', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'DUJ-SURI', 'Dubrajpur - Siuri', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    1, 5, 'Inspection Vehicle',
    45, 66, '2026-08-12T17:00:00', '2026-08-12T18:06:00',
    'Completed', '{"job_id": "TDMS-H0017", "division": "ASN", "section": "UDL-SNT", "block_section": "DUJ-SURI", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 66, "actual_start": "2026-08-12T17:00:00", "actual_end": "2026-08-12T18:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0018', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'DN_MAIN',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    1, 7, 'Tower Wagon',
    150, 147, '2026-08-13T02:55:00', '2026-08-13T05:22:00',
    'Completed', '{"job_id": "TDMS-H0018", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "DN_MAIN", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 147, "actual_start": "2026-08-13T02:55:00", "actual_end": "2026-08-13T05:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0019', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    1, 7, 'Tower Wagon',
    105, 117, '2026-08-18T11:30:00', '2026-08-18T13:27:00',
    'Completed', '{"job_id": "TDMS-H0019", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-08-18T11:30:00", "actual_end": "2026-08-18T13:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0020', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'DUJ-SURI', 'Dubrajpur - Siuri', 'UP_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    90, 83, '2026-08-19T12:00:00', '2026-08-19T13:23:00',
    'Completed', '{"job_id": "TDMS-H0020", "division": "ASN", "section": "UDL-SNT", "block_section": "DUJ-SURI", "line": "UP_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-08-19T12:00:00", "actual_end": "2026-08-19T13:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0021', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'High',
    1, 5, 'CB Timing Analyzer',
    165, 166, '2026-08-22T11:20:00', '2026-08-22T14:06:00',
    'Completed', '{"job_id": "TDMS-H0021", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 166, "actual_start": "2026-08-22T11:20:00", "actual_end": "2026-08-22T14:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0022', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UKA-PAW', 'Ukhra - Pandabeswar', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'High', 'Medium',
    0, 4, 'Earth Tester & Bonding Kit',
    60, 56, '2026-08-24T02:20:00', '2026-08-24T03:16:00',
    'Completed', '{"job_id": "TDMS-H0022", "division": "ASN", "section": "UDL-SNT", "block_section": "UKA-PAW", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 56, "actual_start": "2026-08-24T02:20:00", "actual_end": "2026-08-24T03:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0023', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'UDL-UKA', 'Andal - Ukhra', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    45, 43, '2026-09-07T13:20:00', '2026-09-07T14:03:00',
    'Completed', '{"job_id": "TDMS-H0023", "division": "ASN", "section": "UDL-SNT", "block_section": "UDL-UKA", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 43, "actual_start": "2026-09-07T13:20:00", "actual_end": "2026-09-07T14:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0024', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'DUJ-SURI', 'Dubrajpur - Siuri', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    2, 6, 'Ladder & Tension Meter',
    105, 127, '2026-09-08T03:55:00', '2026-09-08T06:02:00',
    'Completed', '{"job_id": "TDMS-H0024", "division": "ASN", "section": "UDL-SNT", "block_section": "DUJ-SURI", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 127, "actual_start": "2026-09-08T03:55:00", "actual_end": "2026-09-08T06:02:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0025', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-SNT', 'Andal-Sainthia', 'PAW-DUJ', 'Pandabeswar - Dubrajpur', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    0, 3, 'Earth Tester & Bonding Kit',
    75, 82, '2026-09-08T12:05:00', '2026-09-08T13:27:00',
    'Completed', '{"job_id": "TDMS-H0025", "division": "ASN", "section": "UDL-SNT", "block_section": "PAW-DUJ", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-09-08T12:05:00", "actual_end": "2026-09-08T13:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0026', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'TOP-IKRA', 'Tapasi - Ikrah', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    0, 6, 'Tower Wagon',
    120, 142, '2026-07-06T02:20:00', '2026-07-06T04:42:00',
    'Completed', '{"job_id": "TDMS-H0026", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "TOP-IKRA", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 142, "actual_start": "2026-07-06T02:20:00", "actual_end": "2026-07-06T04:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0027', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    0, 7, 'Tower Wagon',
    105, 108, '2026-07-15T12:10:00', '2026-07-15T13:58:00',
    'Completed', '{"job_id": "TDMS-H0027", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 108, "actual_start": "2026-07-15T12:10:00", "actual_end": "2026-07-15T13:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0028', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'GOODS_CHORD',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'High', 'High',
    2, 3, 'Inspection Vehicle',
    45, 41, '2026-07-15T12:40:00', '2026-07-15T13:21:00',
    'Completed', '{"job_id": "TDMS-H0028", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "GOODS_CHORD", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 41, "actual_start": "2026-07-15T12:40:00", "actual_end": "2026-07-15T13:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0029', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'TOP-IKRA', 'Tapasi - Ikrah', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    4, 4, 'Secondary Injection Test Set',
    105, 122, '2026-07-15T17:55:00', '2026-07-15T19:57:00',
    'Completed', '{"job_id": "TDMS-H0029", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "TOP-IKRA", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 122, "actual_start": "2026-07-15T17:55:00", "actual_end": "2026-07-15T19:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0030', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'UDL-TOP', 'Andal - Tapasi', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Low', 'Medium',
    0, 7, 'Tower Wagon',
    120, 125, '2026-07-18T11:25:00', '2026-07-18T13:30:00',
    'Completed', '{"job_id": "TDMS-H0030", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "UDL-TOP", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 125, "actual_start": "2026-07-18T11:25:00", "actual_end": "2026-07-18T13:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0031', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'High',
    1, 5, 'Earth Tester & Bonding Kit',
    60, 50, '2026-07-19T13:15:00', '2026-07-19T14:05:00',
    'Completed', '{"job_id": "TDMS-H0031", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 50, "actual_start": "2026-07-19T13:15:00", "actual_end": "2026-07-19T14:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0032', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'UDL-TOP', 'Andal - Tapasi', 'GOODS_CHORD',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    45, 40, '2026-07-20T02:20:00', '2026-07-20T03:00:00',
    'Completed', '{"job_id": "TDMS-H0032", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "UDL-TOP", "line": "GOODS_CHORD", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-07-20T02:20:00", "actual_end": "2026-07-20T03:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0033', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'High',
    1, 5, 'Tower Wagon',
    105, 127, '2026-07-20T15:25:00', '2026-07-20T17:32:00',
    'Completed', '{"job_id": "TDMS-H0033", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 127, "actual_start": "2026-07-20T15:25:00", "actual_end": "2026-07-20T17:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0034', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'GOODS_CHORD',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    150, 168, '2026-07-22T15:40:00', '2026-07-22T18:28:00',
    'Completed', '{"job_id": "TDMS-H0034", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "GOODS_CHORD", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 168, "actual_start": "2026-07-22T15:40:00", "actual_end": "2026-07-22T18:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0035', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'GOODS_CHORD',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    1, 4, 'Earth Tester & Bonding Kit',
    75, 69, '2026-07-22T16:30:00', '2026-07-22T17:39:00',
    'Completed', '{"job_id": "TDMS-H0035", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "GOODS_CHORD", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 69, "actual_start": "2026-07-22T16:30:00", "actual_end": "2026-07-22T17:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0036', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'GOODS_CHORD',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    120, 116, '2026-07-24T16:05:00', '2026-07-24T18:01:00',
    'Completed', '{"job_id": "TDMS-H0036", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "GOODS_CHORD", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 116, "actual_start": "2026-07-24T16:05:00", "actual_end": "2026-07-24T18:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0037', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    60, 61, '2026-07-24T16:35:00', '2026-07-24T17:36:00',
    'Completed', '{"job_id": "TDMS-H0037", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 61, "actual_start": "2026-07-24T16:35:00", "actual_end": "2026-07-24T17:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0038', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'TOP-IKRA', 'Tapasi - Ikrah', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    1, 5, 'Inspection Vehicle',
    45, 44, '2026-07-27T12:20:00', '2026-07-27T13:04:00',
    'Completed', '{"job_id": "TDMS-H0038", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "TOP-IKRA", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 44, "actual_start": "2026-07-27T12:20:00", "actual_end": "2026-07-27T13:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0039', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'Low',
    0, 5, 'Inspection Vehicle',
    75, 87, '2026-07-31T03:05:00', '2026-07-31T04:32:00',
    'Completed', '{"job_id": "TDMS-H0039", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "Low", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 87, "actual_start": "2026-07-31T03:05:00", "actual_end": "2026-07-31T04:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0040', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'UDL-TOP', 'Andal - Tapasi', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'Medium',
    1, 4, 'Inspection Vehicle',
    60, 50, '2026-08-08T01:10:00', '2026-08-08T02:00:00',
    'Completed', '{"job_id": "TDMS-H0040", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "UDL-TOP", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 50, "actual_start": "2026-08-08T01:10:00", "actual_end": "2026-08-08T02:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0041', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'UDL-TOP', 'Andal - Tapasi', 'GOODS_CHORD',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    75, 78, '2026-08-10T17:40:00', '2026-08-10T18:58:00',
    'Completed', '{"job_id": "TDMS-H0041", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "UDL-TOP", "line": "GOODS_CHORD", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 78, "actual_start": "2026-08-10T17:40:00", "actual_end": "2026-08-10T18:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0042', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'UDL-TOP', 'Andal - Tapasi', 'GOODS_CHORD',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    1, 4, 'Inspection Vehicle',
    75, 88, '2026-08-11T13:30:00', '2026-08-11T14:58:00',
    'Completed', '{"job_id": "TDMS-H0042", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "UDL-TOP", "line": "GOODS_CHORD", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 88, "actual_start": "2026-08-11T13:30:00", "actual_end": "2026-08-11T14:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0043', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'GOODS_CHORD',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'Critical',
    0, 5, 'Tower Wagon',
    120, 113, '2026-08-15T14:05:00', '2026-08-15T15:58:00',
    'Completed', '{"job_id": "TDMS-H0043", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "GOODS_CHORD", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 113, "actual_start": "2026-08-15T14:05:00", "actual_end": "2026-08-15T15:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0044', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'GOODS_CHORD',
    'OHE Wire Replacement', 'OHE', 'Medium', 'Critical',
    5, 8, 'Tower Wagon',
    120, 117, '2026-08-16T11:50:00', '2026-08-16T13:47:00',
    'Completed', '{"job_id": "TDMS-H0044", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "GOODS_CHORD", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 117, "actual_start": "2026-08-16T11:50:00", "actual_end": "2026-08-16T13:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0045', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    3, 5, 'Ladder & Contact Burnisher',
    75, 68, '2026-08-20T12:00:00', '2026-08-20T13:08:00',
    'Completed', '{"job_id": "TDMS-H0045", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-08-20T12:00:00", "actual_end": "2026-08-20T13:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0046', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'IKRA-BBI', 'Ikrah - Barabani', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 3, 'Inspection Vehicle',
    75, 94, '2026-08-24T16:15:00', '2026-08-24T17:49:00',
    'Completed', '{"job_id": "TDMS-H0046", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "IKRA-BBI", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 94, "actual_start": "2026-08-24T16:15:00", "actual_end": "2026-08-24T17:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0047', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'TOP-IKRA', 'Tapasi - Ikrah', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    3, 6, 'Ladder & Tension Meter',
    105, 124, '2026-08-27T16:00:00', '2026-08-27T18:04:00',
    'Completed', '{"job_id": "TDMS-H0047", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "TOP-IKRA", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 124, "actual_start": "2026-08-27T16:00:00", "actual_end": "2026-08-27T18:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0048', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'TOP-IKRA', 'Tapasi - Ikrah', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    1, 7, 'Oil Filtration Plant',
    195, 201, '2026-08-28T11:25:00', '2026-08-28T14:46:00',
    'Completed', '{"job_id": "TDMS-H0048", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "TOP-IKRA", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 201, "actual_start": "2026-08-28T11:25:00", "actual_end": "2026-08-28T14:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0049', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'GOODS_CHORD',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    1, 7, 'Tower Wagon',
    135, 151, '2026-08-29T03:50:00', '2026-08-29T06:21:00',
    'Completed', '{"job_id": "TDMS-H0049", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "GOODS_CHORD", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 151, "actual_start": "2026-08-29T03:50:00", "actual_end": "2026-08-29T06:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0050', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'UDL-TOP-BBI-STN', 'Andal–Tapasi–Barabani–Sitarampur', 'BBI-STN', 'Barabani - Sitarampur', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    0, 5, 'Ladder & Tension Meter',
    105, 109, '2026-09-04T03:05:00', '2026-09-04T04:54:00',
    'Completed', '{"job_id": "TDMS-H0050", "division": "ASN", "section": "UDL-TOP-BBI-STN", "block_section": "BBI-STN", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-09-04T03:05:00", "actual_end": "2026-09-04T04:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0051', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    0, 7, 'Oil Filtration Plant',
    195, 194, '2026-07-03T04:55:00', '2026-07-03T08:09:00',
    'Completed', '{"job_id": "TDMS-H0051", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 194, "actual_start": "2026-07-03T04:55:00", "actual_end": "2026-07-03T08:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0052', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    135, 128, '2026-07-03T11:05:00', '2026-07-03T13:13:00',
    'Completed', '{"job_id": "TDMS-H0052", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 128, "actual_start": "2026-07-03T11:05:00", "actual_end": "2026-07-03T13:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0053', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'Medium',
    0, 4, 'RTU Diagnostic Terminal',
    60, 50, '2026-07-05T13:15:00', '2026-07-05T14:05:00',
    'Completed', '{"job_id": "TDMS-H0053", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 50, "actual_start": "2026-07-05T13:15:00", "actual_end": "2026-07-05T14:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0054', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    4, 7, 'Tower Wagon',
    75, 90, '2026-07-14T02:55:00', '2026-07-14T04:25:00',
    'Completed', '{"job_id": "TDMS-H0054", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 90, "actual_start": "2026-07-14T02:55:00", "actual_end": "2026-07-14T04:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0055', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    120, 128, '2026-07-14T11:40:00', '2026-07-14T13:48:00',
    'Completed', '{"job_id": "TDMS-H0055", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 128, "actual_start": "2026-07-14T11:40:00", "actual_end": "2026-07-14T13:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0056', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    1, 3, 'Inspection Vehicle',
    45, 40, '2026-07-14T12:00:00', '2026-07-14T12:40:00',
    'Completed', '{"job_id": "TDMS-H0056", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-07-14T12:00:00", "actual_end": "2026-07-14T12:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0057', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'High',
    1, 3, 'Inspection Vehicle',
    60, 76, '2026-07-18T14:30:00', '2026-07-18T15:46:00',
    'Completed', '{"job_id": "TDMS-H0057", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 76, "actual_start": "2026-07-18T14:30:00", "actual_end": "2026-07-18T15:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0058', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    2, 7, 'Oil Filtration Plant',
    165, 179, '2026-07-20T17:10:00', '2026-07-20T20:09:00',
    'Completed', '{"job_id": "TDMS-H0058", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 179, "actual_start": "2026-07-20T17:10:00", "actual_end": "2026-07-20T20:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0059', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    105, 100, '2026-07-22T16:05:00', '2026-07-22T17:45:00',
    'Completed', '{"job_id": "TDMS-H0059", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 100, "actual_start": "2026-07-22T16:05:00", "actual_end": "2026-07-22T17:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0060', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    0, 5, 'Ladder & Contact Burnisher',
    105, 105, '2026-07-27T14:50:00', '2026-07-27T16:35:00',
    'Completed', '{"job_id": "TDMS-H0060", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 105, "actual_duration_min": 105, "actual_start": "2026-07-27T14:50:00", "actual_end": "2026-07-27T16:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0061', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'Medium',
    1, 3, 'RTU Diagnostic Terminal',
    60, 82, '2026-07-30T03:35:00', '2026-07-30T04:57:00',
    'Completed', '{"job_id": "TDMS-H0061", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 82, "actual_start": "2026-07-30T03:35:00", "actual_end": "2026-07-30T04:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0062', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Low', 'High',
    0, 6, 'Tower Wagon',
    90, 104, '2026-08-07T01:20:00', '2026-08-07T03:04:00',
    'Completed', '{"job_id": "TDMS-H0062", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 104, "actual_start": "2026-08-07T01:20:00", "actual_end": "2026-08-07T03:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0063', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    1, 6, 'Tower Wagon',
    120, 133, '2026-08-11T04:40:00', '2026-08-11T06:53:00',
    'Completed', '{"job_id": "TDMS-H0063", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-08-11T04:40:00", "actual_end": "2026-08-11T06:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0064', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    120, 141, '2026-08-12T11:35:00', '2026-08-12T13:56:00',
    'Completed', '{"job_id": "TDMS-H0064", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 141, "actual_start": "2026-08-12T11:35:00", "actual_end": "2026-08-12T13:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0065', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Critical',
    4, 5, 'Tower Wagon',
    120, 138, '2026-08-14T16:25:00', '2026-08-14T18:43:00',
    'Completed', '{"job_id": "TDMS-H0065", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 138, "actual_start": "2026-08-14T16:25:00", "actual_end": "2026-08-14T18:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0066', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 5, 'Ladder & Tension Meter',
    105, 125, '2026-08-15T00:30:00', '2026-08-15T02:35:00',
    'Completed', '{"job_id": "TDMS-H0066", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 125, "actual_start": "2026-08-15T00:30:00", "actual_end": "2026-08-15T02:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0067', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    1, 6, 'SF6 Gas Filling Kit',
    90, 88, '2026-08-15T01:10:00', '2026-08-15T02:38:00',
    'Completed', '{"job_id": "TDMS-H0067", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 88, "actual_start": "2026-08-15T01:10:00", "actual_end": "2026-08-15T02:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0068', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    1, 5, 'Tower Wagon',
    90, 112, '2026-08-16T11:30:00', '2026-08-16T13:22:00',
    'Completed', '{"job_id": "TDMS-H0068", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 112, "actual_start": "2026-08-16T11:30:00", "actual_end": "2026-08-16T13:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0069', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    1, 6, 'Tower Wagon',
    135, 153, '2026-08-19T00:05:00', '2026-08-19T02:38:00',
    'Completed', '{"job_id": "TDMS-H0069", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 153, "actual_start": "2026-08-19T00:05:00", "actual_end": "2026-08-19T02:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0070', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    1, 4, 'Ladder & Contact Burnisher',
    90, 112, '2026-08-28T04:45:00', '2026-08-28T06:37:00',
    'Completed', '{"job_id": "TDMS-H0070", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 112, "actual_start": "2026-08-28T04:45:00", "actual_end": "2026-08-28T06:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0071', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'JGD-MMD', 'Jagdishpur - Maheshmunda', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    1, 7, 'Tower Wagon',
    135, 127, '2026-09-01T11:20:00', '2026-09-01T13:27:00',
    'Completed', '{"job_id": "TDMS-H0071", "division": "ASN", "section": "MDP-GRD", "block_section": "JGD-MMD", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 127, "actual_start": "2026-09-01T11:20:00", "actual_end": "2026-09-01T13:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0072', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MMD-GRD', 'Maheshmunda - Giridih', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 6, 'Tower Wagon',
    105, 109, '2026-09-03T17:05:00', '2026-09-03T18:54:00',
    'Completed', '{"job_id": "TDMS-H0072", "division": "ASN", "section": "MDP-GRD", "block_section": "MMD-GRD", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-09-03T17:05:00", "actual_end": "2026-09-03T18:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0073', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Medium',
    2, 4, 'SF6 Gas Filling Kit',
    105, 123, '2026-09-05T12:10:00', '2026-09-05T14:13:00',
    'Completed', '{"job_id": "TDMS-H0073", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 123, "actual_start": "2026-09-05T12:10:00", "actual_end": "2026-09-05T14:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0074', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'MDP-GRD', 'Madhupur–Giridih', 'MDP-JGD', 'Madhupur - Jagdishpur', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    1, 5, 'Tower Wagon',
    90, 101, '2026-09-07T15:40:00', '2026-09-07T17:21:00',
    'Completed', '{"job_id": "TDMS-H0074", "division": "ASN", "section": "MDP-GRD", "block_section": "MDP-JGD", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 101, "actual_start": "2026-09-07T15:40:00", "actual_end": "2026-09-07T17:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0075', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Medium', 'Critical',
    3, 6, 'SF6 Gas Filling Kit',
    105, 127, '2026-07-02T15:10:00', '2026-07-02T17:17:00',
    'Completed', '{"job_id": "TDMS-H0075", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 127, "actual_start": "2026-07-02T15:10:00", "actual_end": "2026-07-02T17:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0076', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    6, 6, 'CB Timing Analyzer',
    135, 129, '2026-07-09T16:05:00', '2026-07-09T18:14:00',
    'Completed', '{"job_id": "TDMS-H0076", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 6, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 129, "actual_start": "2026-07-09T16:05:00", "actual_end": "2026-07-09T18:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0077', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Medium',
    1, 8, 'Tower Wagon',
    150, 166, '2026-07-10T11:25:00', '2026-07-10T14:11:00',
    'Completed', '{"job_id": "TDMS-H0077", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 166, "actual_start": "2026-07-10T11:25:00", "actual_end": "2026-07-10T14:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0078', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    0, 4, 'Ladder & Contact Burnisher',
    75, 86, '2026-07-14T16:15:00', '2026-07-14T17:41:00',
    'Completed', '{"job_id": "TDMS-H0078", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 86, "actual_start": "2026-07-14T16:15:00", "actual_end": "2026-07-14T17:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0079', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Critical',
    1, 5, 'Tower Wagon',
    105, 111, '2026-07-15T12:05:00', '2026-07-15T13:56:00',
    'Completed', '{"job_id": "TDMS-H0079", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-07-15T12:05:00", "actual_end": "2026-07-15T13:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0080', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    1, 6, 'Tower Wagon',
    75, 83, '2026-07-16T13:10:00', '2026-07-16T14:33:00',
    'Completed', '{"job_id": "TDMS-H0080", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 83, "actual_start": "2026-07-16T13:10:00", "actual_end": "2026-07-16T14:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0081', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'High',
    1, 4, 'Inspection Vehicle',
    90, 102, '2026-07-18T15:25:00', '2026-07-18T17:07:00',
    'Completed', '{"job_id": "TDMS-H0081", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-07-18T15:25:00", "actual_end": "2026-07-18T17:07:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0082', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    2, 4, 'Inspection Vehicle',
    90, 107, '2026-07-23T12:35:00', '2026-07-23T14:22:00',
    'Completed', '{"job_id": "TDMS-H0082", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 107, "actual_start": "2026-07-23T12:35:00", "actual_end": "2026-07-23T14:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0083', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    3, 4, 'Tower Wagon',
    90, 109, '2026-07-25T03:40:00', '2026-07-25T05:29:00',
    'Completed', '{"job_id": "TDMS-H0083", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-07-25T03:40:00", "actual_end": "2026-07-25T05:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0084', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Critical',
    0, 6, 'Tower Wagon',
    105, 100, '2026-07-26T03:20:00', '2026-07-26T05:00:00',
    'Completed', '{"job_id": "TDMS-H0084", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 100, "actual_start": "2026-07-26T03:20:00", "actual_end": "2026-07-26T05:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0085', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    1, 5, 'Inspection Vehicle',
    75, 72, '2026-07-30T16:20:00', '2026-07-30T17:32:00',
    'Completed', '{"job_id": "TDMS-H0085", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 72, "actual_start": "2026-07-30T16:20:00", "actual_end": "2026-07-30T17:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0086', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Medium',
    1, 7, 'Tower Wagon',
    90, 93, '2026-08-01T14:30:00', '2026-08-01T16:03:00',
    'Completed', '{"job_id": "TDMS-H0086", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-08-01T14:30:00", "actual_end": "2026-08-01T16:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0087', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    2, 4, 'CB Timing Analyzer',
    135, 135, '2026-08-08T01:20:00', '2026-08-08T03:35:00',
    'Completed', '{"job_id": "TDMS-H0087", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 135, "actual_start": "2026-08-08T01:20:00", "actual_end": "2026-08-08T03:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0088', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    1, 5, 'Tower Wagon',
    60, 56, '2026-08-09T16:35:00', '2026-08-09T17:31:00',
    'Completed', '{"job_id": "TDMS-H0088", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 56, "actual_start": "2026-08-09T16:35:00", "actual_end": "2026-08-09T17:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0089', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    1, 4, 'Inspection Vehicle',
    60, 51, '2026-08-10T12:35:00', '2026-08-10T13:26:00',
    'Completed', '{"job_id": "TDMS-H0089", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 51, "actual_start": "2026-08-10T12:35:00", "actual_end": "2026-08-10T13:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0090', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    2, 9, 'Tower Wagon',
    135, 144, '2026-08-15T14:20:00', '2026-08-15T16:44:00',
    'Completed', '{"job_id": "TDMS-H0090", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-08-15T14:20:00", "actual_end": "2026-08-15T16:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0091', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    4, 7, 'Tower Wagon',
    135, 143, '2026-08-17T15:45:00', '2026-08-17T18:08:00',
    'Completed', '{"job_id": "TDMS-H0091", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 143, "actual_start": "2026-08-17T15:45:00", "actual_end": "2026-08-17T18:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0092', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    0, 7, 'Tower Wagon',
    120, 111, '2026-08-20T04:15:00', '2026-08-20T06:06:00',
    'Completed', '{"job_id": "TDMS-H0092", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 111, "actual_start": "2026-08-20T04:15:00", "actual_end": "2026-08-20T06:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0093', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 3, 'Earth Tester & Bonding Kit',
    45, 57, '2026-08-23T01:30:00', '2026-08-23T02:27:00',
    'Completed', '{"job_id": "TDMS-H0093", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 57, "actual_start": "2026-08-23T01:30:00", "actual_end": "2026-08-23T02:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0094', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Critical',
    3, 6, 'Tower Wagon',
    105, 101, '2026-08-23T16:00:00', '2026-08-23T17:41:00',
    'Completed', '{"job_id": "TDMS-H0094", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 101, "actual_start": "2026-08-23T16:00:00", "actual_end": "2026-08-23T17:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0095', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    3, 6, 'Tower Wagon',
    105, 113, '2026-08-28T11:10:00', '2026-08-28T13:03:00',
    'Completed', '{"job_id": "TDMS-H0095", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-08-28T11:10:00", "actual_end": "2026-08-28T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0096', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    0, 4, 'Ladder & Contact Burnisher',
    75, 73, '2026-08-28T16:05:00', '2026-08-28T17:18:00',
    'Completed', '{"job_id": "TDMS-H0096", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 73, "actual_start": "2026-08-28T16:05:00", "actual_end": "2026-08-28T17:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0097', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    2, 4, 'Inspection Vehicle',
    90, 109, '2026-09-05T15:10:00', '2026-09-05T16:59:00',
    'Completed', '{"job_id": "TDMS-H0097", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-09-05T15:10:00", "actual_end": "2026-09-05T16:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0098', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'JSME-DGHR', 'Jasidih - Deoghar', 'BRANCH_SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'High',
    2, 3, 'RTU Diagnostic Terminal',
    105, 106, '2026-09-06T15:35:00', '2026-09-06T17:21:00',
    'Completed', '{"job_id": "TDMS-H0098", "division": "ASN", "section": "JSME-BDME", "block_section": "JSME-DGHR", "line": "BRANCH_SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-09-06T15:35:00", "actual_end": "2026-09-06T17:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0099', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'Critical',
    5, 8, 'Tower Wagon',
    135, 150, '2026-09-07T00:50:00', '2026-09-07T03:20:00',
    'Completed', '{"job_id": "TDMS-H0099", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 150, "actual_start": "2026-09-07T00:50:00", "actual_end": "2026-09-07T03:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0100', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-BDME', 'Jasidih–Baidyanathdham', 'DGHR-BDME', 'Deoghar - Baidyanathdham', 'BRANCH_SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    3, 6, 'CB Timing Analyzer',
    165, 178, '2026-09-07T16:20:00', '2026-09-07T19:18:00',
    'Completed', '{"job_id": "TDMS-H0100", "division": "ASN", "section": "JSME-BDME", "block_section": "DGHR-BDME", "line": "BRANCH_SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 178, "actual_start": "2026-09-07T16:20:00", "actual_end": "2026-09-07T19:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0101', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'High',
    2, 6, 'Tower Wagon',
    90, 80, '2026-07-01T17:55:00', '2026-07-01T19:15:00',
    'Completed', '{"job_id": "TDMS-H0101", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-07-01T17:55:00", "actual_end": "2026-07-01T19:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0102', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    0, 8, 'Oil Filtration Plant',
    210, 224, '2026-07-02T04:55:00', '2026-07-02T08:39:00',
    'Completed', '{"job_id": "TDMS-H0102", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 224, "actual_start": "2026-07-02T04:55:00", "actual_end": "2026-07-02T08:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0103', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    1, 4, 'Tower Wagon',
    75, 76, '2026-07-02T13:15:00', '2026-07-02T14:31:00',
    'Completed', '{"job_id": "TDMS-H0103", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 76, "actual_start": "2026-07-02T13:15:00", "actual_end": "2026-07-02T14:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0104', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Medium', 'High',
    1, 7, 'Oil Filtration Plant',
    195, 199, '2026-07-05T11:10:00', '2026-07-05T14:29:00',
    'Completed', '{"job_id": "TDMS-H0104", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 199, "actual_start": "2026-07-05T11:10:00", "actual_end": "2026-07-05T14:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0105', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    5, 7, 'Tower Wagon',
    75, 73, '2026-07-05T15:35:00', '2026-07-05T16:48:00',
    'Completed', '{"job_id": "TDMS-H0105", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 73, "actual_start": "2026-07-05T15:35:00", "actual_end": "2026-07-05T16:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0106', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'DGHR-CNPR', 'Deoghar - Chandanpahari', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Medium',
    3, 7, 'Oil Filtration Plant',
    210, 220, '2026-07-07T01:10:00', '2026-07-07T04:50:00',
    'Completed', '{"job_id": "TDMS-H0106", "division": "ASN", "section": "JSME-DUMK", "block_section": "DGHR-CNPR", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Medium", "overdue_days": 3, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 220, "actual_start": "2026-07-07T01:10:00", "actual_end": "2026-07-07T04:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0107', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    0, 6, 'Tower Wagon',
    75, 72, '2026-07-10T11:25:00', '2026-07-10T12:37:00',
    'Completed', '{"job_id": "TDMS-H0107", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 72, "actual_start": "2026-07-10T11:25:00", "actual_end": "2026-07-10T12:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0108', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    8, 5, 'Tower Wagon',
    120, 126, '2026-07-10T15:05:00', '2026-07-10T17:11:00',
    'Completed', '{"job_id": "TDMS-H0108", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 8, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 126, "actual_start": "2026-07-10T15:05:00", "actual_end": "2026-07-10T17:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0109', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Critical',
    2, 4, 'Secondary Injection Test Set',
    90, 106, '2026-07-17T13:45:00', '2026-07-17T15:31:00',
    'Completed', '{"job_id": "TDMS-H0109", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-07-17T13:45:00", "actual_end": "2026-07-17T15:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0110', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Critical',
    2, 6, 'Tower Wagon',
    60, 53, '2026-07-20T15:30:00', '2026-07-20T16:23:00',
    'Completed', '{"job_id": "TDMS-H0110", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 53, "actual_start": "2026-07-20T15:30:00", "actual_end": "2026-07-20T16:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0111', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'DGHR-CNPR', 'Deoghar - Chandanpahari', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Low',
    0, 4, 'Earth Tester & Bonding Kit',
    90, 109, '2026-07-24T01:35:00', '2026-07-24T03:24:00',
    'Completed', '{"job_id": "TDMS-H0111", "division": "ASN", "section": "JSME-DUMK", "block_section": "DGHR-CNPR", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-07-24T01:35:00", "actual_end": "2026-07-24T03:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0112', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    75, 79, '2026-07-27T01:05:00', '2026-07-27T02:24:00',
    'Completed', '{"job_id": "TDMS-H0112", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 79, "actual_start": "2026-07-27T01:05:00", "actual_end": "2026-07-27T02:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0113', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'DGHR-CNPR', 'Deoghar - Chandanpahari', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 3, 'Earth Tester & Bonding Kit',
    45, 57, '2026-07-28T13:20:00', '2026-07-28T14:17:00',
    'Completed', '{"job_id": "TDMS-H0113", "division": "ASN", "section": "JSME-DUMK", "block_section": "DGHR-CNPR", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 57, "actual_start": "2026-07-28T13:20:00", "actual_end": "2026-07-28T14:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0114', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    1, 8, 'Tower Wagon',
    135, 145, '2026-08-01T11:15:00', '2026-08-01T13:40:00',
    'Completed', '{"job_id": "TDMS-H0114", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 145, "actual_start": "2026-08-01T11:15:00", "actual_end": "2026-08-01T13:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0115', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    2, 6, 'Tower Wagon',
    90, 112, '2026-08-04T03:55:00', '2026-08-04T05:47:00',
    'Completed', '{"job_id": "TDMS-H0115", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 112, "actual_start": "2026-08-04T03:55:00", "actual_end": "2026-08-04T05:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0116', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Low', 'High',
    0, 4, 'Tower Wagon',
    60, 70, '2026-08-10T13:15:00', '2026-08-10T14:25:00',
    'Completed', '{"job_id": "TDMS-H0116", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 70, "actual_start": "2026-08-10T13:15:00", "actual_end": "2026-08-10T14:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0117', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    4, 6, 'CB Timing Analyzer',
    150, 146, '2026-08-12T11:20:00', '2026-08-12T13:46:00',
    'Completed', '{"job_id": "TDMS-H0117", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 146, "actual_start": "2026-08-12T11:20:00", "actual_end": "2026-08-12T13:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0118', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'High', 'High',
    3, 5, 'Earth Tester & Bonding Kit',
    45, 63, '2026-08-16T14:45:00', '2026-08-16T15:48:00',
    'Completed', '{"job_id": "TDMS-H0118", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 63, "actual_start": "2026-08-16T14:45:00", "actual_end": "2026-08-16T15:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0119', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    8, 8, 'Tower Wagon',
    135, 145, '2026-08-18T00:25:00', '2026-08-18T02:50:00',
    'Completed', '{"job_id": "TDMS-H0119", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 8, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 145, "actual_start": "2026-08-18T00:25:00", "actual_end": "2026-08-18T02:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0120', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    75, 82, '2026-08-18T16:30:00', '2026-08-18T17:52:00',
    'Completed', '{"job_id": "TDMS-H0120", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-08-18T16:30:00", "actual_end": "2026-08-18T17:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0121', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'DGHR-CNPR', 'Deoghar - Chandanpahari', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    60, 82, '2026-08-19T02:30:00', '2026-08-19T03:52:00',
    'Completed', '{"job_id": "TDMS-H0121", "division": "ASN", "section": "JSME-DUMK", "block_section": "DGHR-CNPR", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 82, "actual_start": "2026-08-19T02:30:00", "actual_end": "2026-08-19T03:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0122', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'High',
    0, 9, 'Tower Wagon',
    135, 130, '2026-08-22T15:55:00', '2026-08-22T18:05:00',
    'Completed', '{"job_id": "TDMS-H0122", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 130, "actual_start": "2026-08-22T15:55:00", "actual_end": "2026-08-22T18:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0123', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'CNPR-BSKH', 'Chandanpahari - Basukinath', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    90, 87, '2026-08-23T15:05:00', '2026-08-23T16:32:00',
    'Completed', '{"job_id": "TDMS-H0123", "division": "ASN", "section": "JSME-DUMK", "block_section": "CNPR-BSKH", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-08-23T15:05:00", "actual_end": "2026-08-23T16:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0124', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    4, 8, 'Tower Wagon',
    135, 140, '2026-08-25T01:20:00', '2026-08-25T03:40:00',
    'Completed', '{"job_id": "TDMS-H0124", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 140, "actual_start": "2026-08-25T01:20:00", "actual_end": "2026-08-25T03:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0125', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'Critical',
    5, 6, 'Tower Wagon',
    75, 68, '2026-08-25T14:45:00', '2026-08-25T15:53:00',
    'Completed', '{"job_id": "TDMS-H0125", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-08-25T14:45:00", "actual_end": "2026-08-25T15:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0126', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'BSKH-DUMK', 'Basukinath - Dumka', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    3, 6, 'Tower Wagon',
    135, 131, '2026-09-02T04:00:00', '2026-09-02T06:11:00',
    'Completed', '{"job_id": "TDMS-H0126", "division": "ASN", "section": "JSME-DUMK", "block_section": "BSKH-DUMK", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 131, "actual_start": "2026-09-02T04:00:00", "actual_end": "2026-09-02T06:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0127', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'JSME-DUMK', 'Jasidih to Dumka', 'JSME-DGHR', 'Jasidih - Deoghar', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Medium',
    1, 4, 'Secondary Injection Test Set',
    120, 113, '2026-09-06T00:15:00', '2026-09-06T02:08:00',
    'Completed', '{"job_id": "TDMS-H0127", "division": "ASN", "section": "JSME-DUMK", "block_section": "JSME-DGHR", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 113, "actual_start": "2026-09-06T00:15:00", "actual_end": "2026-09-06T02:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0128', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Critical',
    6, 4, 'Secondary Injection Test Set',
    105, 98, '2026-07-02T17:25:00', '2026-07-02T19:03:00',
    'Completed', '{"job_id": "TDMS-H0128", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Critical", "overdue_days": 6, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 98, "actual_start": "2026-07-02T17:25:00", "actual_end": "2026-07-02T19:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0129', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    0, 5, 'Earth Tester & Bonding Kit',
    60, 60, '2026-07-03T04:45:00', '2026-07-03T05:45:00',
    'Completed', '{"job_id": "TDMS-H0129", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 60, "actual_start": "2026-07-03T04:45:00", "actual_end": "2026-07-03T05:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0130', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'Critical',
    2, 5, 'Tower Wagon',
    75, 77, '2026-07-04T16:00:00', '2026-07-04T17:17:00',
    'Completed', '{"job_id": "TDMS-H0130", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 77, "actual_start": "2026-07-04T16:00:00", "actual_end": "2026-07-04T17:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0131', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    75, 82, '2026-07-15T15:15:00', '2026-07-15T16:37:00',
    'Completed', '{"job_id": "TDMS-H0131", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-07-15T15:15:00", "actual_end": "2026-07-15T16:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0132', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    1, 6, 'Tower Wagon',
    105, 126, '2026-07-24T15:10:00', '2026-07-24T17:16:00',
    'Completed', '{"job_id": "TDMS-H0132", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 126, "actual_start": "2026-07-24T15:10:00", "actual_end": "2026-07-24T17:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0133', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'Critical',
    6, 7, 'Tower Wagon',
    90, 111, '2026-07-25T14:35:00', '2026-07-25T16:26:00',
    'Completed', '{"job_id": "TDMS-H0133", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 6, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 111, "actual_start": "2026-07-25T14:35:00", "actual_end": "2026-07-25T16:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0134', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    1, 8, 'Oil Filtration Plant',
    210, 201, '2026-07-25T17:15:00', '2026-07-25T20:36:00',
    'Completed', '{"job_id": "TDMS-H0134", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 201, "actual_start": "2026-07-25T17:15:00", "actual_end": "2026-07-25T20:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0135', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    0, 6, 'Tower Wagon',
    105, 101, '2026-07-26T11:30:00', '2026-07-26T13:11:00',
    'Completed', '{"job_id": "TDMS-H0135", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 101, "actual_start": "2026-07-26T11:30:00", "actual_end": "2026-07-26T13:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0136', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    1, 4, 'Secondary Injection Test Set',
    75, 69, '2026-08-04T01:05:00', '2026-08-04T02:14:00',
    'Completed', '{"job_id": "TDMS-H0136", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 75, "actual_duration_min": 69, "actual_start": "2026-08-04T01:05:00", "actual_end": "2026-08-04T02:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0137', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    105, 107, '2026-08-04T17:40:00', '2026-08-04T19:27:00',
    'Completed', '{"job_id": "TDMS-H0137", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 107, "actual_start": "2026-08-04T17:40:00", "actual_end": "2026-08-04T19:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0138', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    3, 4, 'Secondary Injection Test Set',
    90, 91, '2026-08-10T17:50:00', '2026-08-10T19:21:00',
    'Completed', '{"job_id": "TDMS-H0138", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 91, "actual_start": "2026-08-10T17:50:00", "actual_end": "2026-08-10T19:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0139', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    0, 4, 'Inspection Vehicle',
    60, 73, '2026-08-12T00:20:00', '2026-08-12T01:33:00',
    'Completed', '{"job_id": "TDMS-H0139", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 73, "actual_start": "2026-08-12T00:20:00", "actual_end": "2026-08-12T01:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0140', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    45, 48, '2026-08-14T04:40:00', '2026-08-14T05:28:00',
    'Completed', '{"job_id": "TDMS-H0140", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 48, "actual_start": "2026-08-14T04:40:00", "actual_end": "2026-08-14T05:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0141', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    1, 4, 'CB Timing Analyzer',
    135, 147, '2026-08-15T01:20:00', '2026-08-15T03:47:00',
    'Completed', '{"job_id": "TDMS-H0141", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 147, "actual_start": "2026-08-15T01:20:00", "actual_end": "2026-08-15T03:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0142', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    75, 70, '2026-08-15T17:40:00', '2026-08-15T18:50:00',
    'Completed', '{"job_id": "TDMS-H0142", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-08-15T17:40:00", "actual_end": "2026-08-15T18:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0143', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    3, 5, 'Tower Wagon',
    75, 84, '2026-08-18T17:20:00', '2026-08-18T18:44:00',
    'Completed', '{"job_id": "TDMS-H0143", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 84, "actual_start": "2026-08-18T17:20:00", "actual_end": "2026-08-18T18:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0144', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    1, 6, 'Tower Wagon',
    120, 127, '2026-08-23T16:00:00', '2026-08-23T18:07:00',
    'Completed', '{"job_id": "TDMS-H0144", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 127, "actual_start": "2026-08-23T16:00:00", "actual_end": "2026-08-23T18:07:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0145', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'Critical',
    1, 5, 'Ladder & Contact Burnisher',
    60, 80, '2026-08-24T16:45:00', '2026-08-24T18:05:00',
    'Completed', '{"job_id": "TDMS-H0145", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 80, "actual_start": "2026-08-24T16:45:00", "actual_end": "2026-08-24T18:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0146', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    180, 175, '2026-08-26T00:20:00', '2026-08-26T03:15:00',
    'Completed', '{"job_id": "TDMS-H0146", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 175, "actual_start": "2026-08-26T00:20:00", "actual_end": "2026-08-26T03:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0147', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'High',
    2, 5, 'Inspection Vehicle',
    45, 40, '2026-08-28T16:00:00', '2026-08-28T16:40:00',
    'Completed', '{"job_id": "TDMS-H0147", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-28T16:00:00", "actual_end": "2026-08-28T16:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0148', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    3, 5, 'Ladder & Tension Meter',
    75, 80, '2026-08-29T11:15:00', '2026-08-29T12:35:00',
    'Completed', '{"job_id": "TDMS-H0148", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 80, "actual_start": "2026-08-29T11:15:00", "actual_end": "2026-08-29T12:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0149', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'Medium',
    0, 5, 'Ladder & Contact Burnisher',
    60, 53, '2026-08-30T14:30:00', '2026-08-30T15:23:00',
    'Completed', '{"job_id": "TDMS-H0149", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 53, "actual_start": "2026-08-30T14:30:00", "actual_end": "2026-08-30T15:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0150', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    120, 125, '2026-09-01T14:30:00', '2026-09-01T16:35:00',
    'Completed', '{"job_id": "TDMS-H0150", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 125, "actual_start": "2026-09-01T14:30:00", "actual_end": "2026-09-01T16:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0151', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'DGHR-KKRA', 'Deoghar - Kakwara', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Critical', 'Critical',
    2, 6, 'Tower Wagon',
    135, 151, '2026-09-02T16:45:00', '2026-09-02T19:16:00',
    'Completed', '{"job_id": "TDMS-H0151", "division": "ASN", "section": "DGHR-BAKA", "block_section": "DGHR-KKRA", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 151, "actual_start": "2026-09-02T16:45:00", "actual_end": "2026-09-02T19:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0152', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'ASN', 'Asansol',
    'DGHR-BAKA', 'Deoghar to Banka', 'KKRA-BAKA', 'Kakwara - Banka', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Critical',
    0, 5, 'Tower Wagon',
    105, 125, '2026-09-05T12:35:00', '2026-09-05T14:40:00',
    'Completed', '{"job_id": "TDMS-H0152", "division": "ASN", "section": "DGHR-BAKA", "block_section": "KKRA-BAKA", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 125, "actual_start": "2026-09-05T12:35:00", "actual_end": "2026-09-05T14:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0153', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    0, 4, 'Secondary Injection Test Set',
    90, 80, '2026-07-02T17:30:00', '2026-07-02T18:50:00',
    'Completed', '{"job_id": "TDMS-H0153", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-07-02T17:30:00", "actual_end": "2026-07-02T18:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0154', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    1, 4, 'Inspection Vehicle',
    90, 96, '2026-07-03T17:10:00', '2026-07-03T18:46:00',
    'Completed', '{"job_id": "TDMS-H0154", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 96, "actual_start": "2026-07-03T17:10:00", "actual_end": "2026-07-03T18:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0155', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BDC-BWN', 'Bandel - Barddhaman', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    1, 3, 'Inspection Vehicle',
    45, 41, '2026-07-05T17:30:00', '2026-07-05T18:11:00',
    'Completed', '{"job_id": "TDMS-H0155", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BDC-BWN", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 41, "actual_start": "2026-07-05T17:30:00", "actual_end": "2026-07-05T18:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0156', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    3, 6, 'Tower Wagon',
    105, 95, '2026-07-06T12:20:00', '2026-07-06T13:55:00',
    'Completed', '{"job_id": "TDMS-H0156", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 95, "actual_start": "2026-07-06T12:20:00", "actual_end": "2026-07-06T13:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0157', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', '3RD_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    2, 3, 'Earth Tester & Bonding Kit',
    90, 103, '2026-07-07T02:30:00', '2026-07-07T04:13:00',
    'Completed', '{"job_id": "TDMS-H0157", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "3RD_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 103, "actual_start": "2026-07-07T02:30:00", "actual_end": "2026-07-07T04:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0158', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'DN_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    0, 5, 'SF6 Gas Filling Kit',
    105, 119, '2026-07-10T04:50:00', '2026-07-10T06:49:00',
    'Completed', '{"job_id": "TDMS-H0158", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "DN_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 119, "actual_start": "2026-07-10T04:50:00", "actual_end": "2026-07-10T06:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0159', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'HWH-BLY', 'Howrah - Bally', '3RD_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Critical', 'High',
    2, 6, 'Ladder & Tension Meter',
    105, 106, '2026-07-11T16:05:00', '2026-07-11T17:51:00',
    'Completed', '{"job_id": "TDMS-H0159", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "HWH-BLY", "line": "3RD_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Critical", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-07-11T16:05:00", "actual_end": "2026-07-11T17:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0160', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'Medium', 'Critical',
    4, 8, 'Tower Wagon',
    135, 138, '2026-07-14T17:25:00', '2026-07-14T19:43:00',
    'Completed', '{"job_id": "TDMS-H0160", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 138, "actual_start": "2026-07-14T17:25:00", "actual_end": "2026-07-14T19:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0161', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'HWH-BLY', 'Howrah - Bally', 'DN_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    2, 5, 'CB Timing Analyzer',
    135, 140, '2026-07-22T11:50:00', '2026-07-22T14:10:00',
    'Completed', '{"job_id": "TDMS-H0161", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "HWH-BLY", "line": "DN_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 140, "actual_start": "2026-07-22T11:50:00", "actual_end": "2026-07-22T14:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0162', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', '3RD_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    1, 7, 'Tower Wagon',
    135, 127, '2026-07-26T13:25:00', '2026-07-26T15:32:00',
    'Completed', '{"job_id": "TDMS-H0162", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "3RD_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 127, "actual_start": "2026-07-26T13:25:00", "actual_end": "2026-07-26T15:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0163', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', '3RD_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    4, 7, 'Tower Wagon',
    105, 102, '2026-07-26T15:00:00', '2026-07-26T16:42:00',
    'Completed', '{"job_id": "TDMS-H0163", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "3RD_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 102, "actual_start": "2026-07-26T15:00:00", "actual_end": "2026-07-26T16:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0164', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'Critical',
    2, 8, 'Tower Wagon',
    135, 152, '2026-07-30T02:40:00', '2026-07-30T05:12:00',
    'Completed', '{"job_id": "TDMS-H0164", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 152, "actual_start": "2026-07-30T02:40:00", "actual_end": "2026-07-30T05:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0165', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'Critical',
    2, 6, 'Tower Wagon',
    165, 162, '2026-08-01T11:40:00', '2026-08-01T14:22:00',
    'Completed', '{"job_id": "TDMS-H0165", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 162, "actual_start": "2026-08-01T11:40:00", "actual_end": "2026-08-01T14:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0166', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', '3RD_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Medium',
    0, 6, 'Oil Filtration Plant',
    165, 171, '2026-08-06T00:50:00', '2026-08-06T03:41:00',
    'Completed', '{"job_id": "TDMS-H0166", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "3RD_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 171, "actual_start": "2026-08-06T00:50:00", "actual_end": "2026-08-06T03:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0167', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    4, 9, 'Tower Wagon',
    105, 117, '2026-08-09T16:30:00', '2026-08-09T18:27:00',
    'Completed', '{"job_id": "TDMS-H0167", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-08-09T16:30:00", "actual_end": "2026-08-09T18:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0168', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'HWH-BLY', 'Howrah - Bally', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    3, 5, 'SF6 Gas Filling Kit',
    105, 118, '2026-08-12T12:40:00', '2026-08-12T14:38:00',
    'Completed', '{"job_id": "TDMS-H0168", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "HWH-BLY", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-08-12T12:40:00", "actual_end": "2026-08-12T14:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0169', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    2, 5, 'Tower Wagon',
    120, 120, '2026-08-16T01:50:00', '2026-08-16T03:50:00',
    'Completed', '{"job_id": "TDMS-H0169", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 120, "actual_start": "2026-08-16T01:50:00", "actual_end": "2026-08-16T03:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0170', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BDC-BWN', 'Bandel - Barddhaman', 'UP_MAIN',
    'Section Insulator Inspection', 'OHE', 'Low', 'Low',
    2, 5, 'Inspection Vehicle',
    90, 92, '2026-08-17T17:10:00', '2026-08-17T18:42:00',
    'Completed', '{"job_id": "TDMS-H0170", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BDC-BWN", "line": "UP_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 92, "actual_start": "2026-08-17T17:10:00", "actual_end": "2026-08-17T18:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0171', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Critical',
    4, 3, 'Secondary Injection Test Set',
    90, 97, '2026-08-20T14:45:00', '2026-08-20T16:22:00',
    'Completed', '{"job_id": "TDMS-H0171", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-08-20T14:45:00", "actual_end": "2026-08-20T16:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0172', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BDC-BWN', 'Bandel - Barddhaman', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    0, 6, 'Tower Wagon',
    105, 101, '2026-08-22T12:45:00', '2026-08-22T14:26:00',
    'Completed', '{"job_id": "TDMS-H0172", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BDC-BWN", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 101, "actual_start": "2026-08-22T12:45:00", "actual_end": "2026-08-22T14:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0173', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BDC-BWN', 'Bandel - Barddhaman', '3RD_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    2, 7, 'Tower Wagon',
    105, 121, '2026-08-24T15:00:00', '2026-08-24T17:01:00',
    'Completed', '{"job_id": "TDMS-H0173", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BDC-BWN", "line": "3RD_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 121, "actual_start": "2026-08-24T15:00:00", "actual_end": "2026-08-24T17:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0174', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'HWH-BLY', 'Howrah - Bally', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    2, 4, 'Inspection Vehicle',
    45, 40, '2026-08-26T04:15:00', '2026-08-26T04:55:00',
    'Completed', '{"job_id": "TDMS-H0174", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "HWH-BLY", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-26T04:15:00", "actual_end": "2026-08-26T04:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0175', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    1, 4, 'Tower Wagon',
    105, 110, '2026-08-27T11:15:00', '2026-08-27T13:05:00',
    'Completed', '{"job_id": "TDMS-H0175", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 110, "actual_start": "2026-08-27T11:15:00", "actual_end": "2026-08-27T13:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0176', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BDC-BWN', 'Bandel - Barddhaman', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Medium',
    2, 5, 'Tower Wagon',
    105, 104, '2026-09-03T11:35:00', '2026-09-03T13:19:00',
    'Completed', '{"job_id": "TDMS-H0176", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BDC-BWN", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 104, "actual_start": "2026-09-03T11:35:00", "actual_end": "2026-09-03T13:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0177', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BWN-KAN', 'Barddhaman - Khana', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    90, 102, '2026-09-07T12:05:00', '2026-09-07T13:47:00',
    'Completed', '{"job_id": "TDMS-H0177", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BWN-KAN", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-09-07T12:05:00", "actual_end": "2026-09-07T13:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0178', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Main line)', 'Howrah – Khana (Main line)', 'BLY-BDC', 'Bally - Bandel', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    75, 70, '2026-09-08T13:50:00', '2026-09-08T15:00:00',
    'Completed', '{"job_id": "TDMS-H0178", "division": "HWH", "section": "HWH-KAN (Main line)", "block_section": "BLY-BDC", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-09-08T13:50:00", "actual_end": "2026-09-08T15:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0179', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'KQU-GRAE', 'Kamarkundu - Gurap', 'DN_CHORD',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    1, 4, 'Tower Wagon',
    90, 93, '2026-07-01T15:20:00', '2026-07-01T16:53:00',
    'Completed', '{"job_id": "TDMS-H0179", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "KQU-GRAE", "line": "DN_CHORD", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-07-01T15:20:00", "actual_end": "2026-07-01T16:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0180', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'DN_CHORD',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'Medium',
    0, 3, 'RTU Diagnostic Terminal',
    90, 95, '2026-07-02T17:55:00', '2026-07-02T19:30:00',
    'Completed', '{"job_id": "TDMS-H0180", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "DN_CHORD", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 90, "actual_duration_min": 95, "actual_start": "2026-07-02T17:55:00", "actual_end": "2026-07-02T19:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0181', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'GRAE-MSAE', 'Gurap - Masagram', 'DN_CHORD',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    135, 142, '2026-07-03T00:35:00', '2026-07-03T02:57:00',
    'Completed', '{"job_id": "TDMS-H0181", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "GRAE-MSAE", "line": "DN_CHORD", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 142, "actual_start": "2026-07-03T00:35:00", "actual_end": "2026-07-03T02:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0182', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'GRAE-MSAE', 'Gurap - Masagram', 'DN_CHORD',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    90, 109, '2026-07-07T11:35:00', '2026-07-07T13:24:00',
    'Completed', '{"job_id": "TDMS-H0182", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "GRAE-MSAE", "line": "DN_CHORD", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-07-07T11:35:00", "actual_end": "2026-07-07T13:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0183', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'DN_CHORD',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Critical',
    3, 5, 'Tower Wagon',
    120, 125, '2026-07-07T12:25:00', '2026-07-07T14:30:00',
    'Completed', '{"job_id": "TDMS-H0183", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "DN_CHORD", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 125, "actual_start": "2026-07-07T12:25:00", "actual_end": "2026-07-07T14:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0184', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'HWH-DKAE', 'Howrah - Dankuni', 'UP_CHORD',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Critical',
    1, 5, 'Tower Wagon',
    90, 106, '2026-07-08T11:20:00', '2026-07-08T13:06:00',
    'Completed', '{"job_id": "TDMS-H0184", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "HWH-DKAE", "line": "UP_CHORD", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-07-08T11:20:00", "actual_end": "2026-07-08T13:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0185', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'HWH-DKAE', 'Howrah - Dankuni', 'DN_CHORD',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    5, 6, 'Ladder & Tension Meter',
    90, 102, '2026-07-10T00:25:00', '2026-07-10T02:07:00',
    'Completed', '{"job_id": "TDMS-H0185", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "HWH-DKAE", "line": "DN_CHORD", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-07-10T00:25:00", "actual_end": "2026-07-10T02:07:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0186', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'DKAE-KQU', 'Dankuni - Kamarkundu', 'UP_CHORD',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    3, 4, 'CB Timing Analyzer',
    120, 122, '2026-07-15T15:35:00', '2026-07-15T17:37:00',
    'Completed', '{"job_id": "TDMS-H0186", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "DKAE-KQU", "line": "UP_CHORD", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 122, "actual_start": "2026-07-15T15:35:00", "actual_end": "2026-07-15T17:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0187', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'KQU-GRAE', 'Kamarkundu - Gurap', 'DN_CHORD',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    60, 79, '2026-07-17T11:15:00', '2026-07-17T12:34:00',
    'Completed', '{"job_id": "TDMS-H0187", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "KQU-GRAE", "line": "DN_CHORD", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 79, "actual_start": "2026-07-17T11:15:00", "actual_end": "2026-07-17T12:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0188', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'GRAE-MSAE', 'Gurap - Masagram', 'UP_CHORD',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Low',
    2, 4, 'Inspection Vehicle',
    60, 55, '2026-07-17T14:50:00', '2026-07-17T15:45:00',
    'Completed', '{"job_id": "TDMS-H0188", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "GRAE-MSAE", "line": "UP_CHORD", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Low", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-07-17T14:50:00", "actual_end": "2026-07-17T15:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0189', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'DKAE-KQU', 'Dankuni - Kamarkundu', 'UP_CHORD',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    1, 4, 'SF6 Gas Filling Kit',
    90, 98, '2026-07-24T14:45:00', '2026-07-24T16:23:00',
    'Completed', '{"job_id": "TDMS-H0189", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "DKAE-KQU", "line": "UP_CHORD", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 98, "actual_start": "2026-07-24T14:45:00", "actual_end": "2026-07-24T16:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0190', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'DKAE-KQU', 'Dankuni - Kamarkundu', 'UP_CHORD',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    135, 128, '2026-07-25T11:55:00', '2026-07-25T14:03:00',
    'Completed', '{"job_id": "TDMS-H0190", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "DKAE-KQU", "line": "UP_CHORD", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 128, "actual_start": "2026-07-25T11:55:00", "actual_end": "2026-07-25T14:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0191', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'UP_CHORD',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    1, 7, 'Tower Wagon',
    135, 154, '2026-08-03T11:20:00', '2026-08-03T13:54:00',
    'Completed', '{"job_id": "TDMS-H0191", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "UP_CHORD", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 154, "actual_start": "2026-08-03T11:20:00", "actual_end": "2026-08-03T13:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0192', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'HWH-DKAE', 'Howrah - Dankuni', 'UP_CHORD',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'Critical',
    3, 7, 'Tower Wagon',
    75, 76, '2026-08-04T16:00:00', '2026-08-04T17:16:00',
    'Completed', '{"job_id": "TDMS-H0192", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "HWH-DKAE", "line": "UP_CHORD", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 76, "actual_start": "2026-08-04T16:00:00", "actual_end": "2026-08-04T17:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0193', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'DN_CHORD',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    1, 4, 'Ladder & Tension Meter',
    60, 59, '2026-08-11T00:10:00', '2026-08-11T01:09:00',
    'Completed', '{"job_id": "TDMS-H0193", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "DN_CHORD", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 59, "actual_start": "2026-08-11T00:10:00", "actual_end": "2026-08-11T01:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0194', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'SKG-KAN', 'Saktigarh - Khana', 'UP_CHORD',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    90, 94, '2026-08-16T01:05:00', '2026-08-16T02:39:00',
    'Completed', '{"job_id": "TDMS-H0194", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "SKG-KAN", "line": "UP_CHORD", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-08-16T01:05:00", "actual_end": "2026-08-16T02:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0195', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'KQU-GRAE', 'Kamarkundu - Gurap', 'DN_CHORD',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    3, 8, 'Tower Wagon',
    105, 120, '2026-08-16T15:30:00', '2026-08-16T17:30:00',
    'Completed', '{"job_id": "TDMS-H0195", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "KQU-GRAE", "line": "DN_CHORD", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 120, "actual_start": "2026-08-16T15:30:00", "actual_end": "2026-08-16T17:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0196', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'DKAE-KQU', 'Dankuni - Kamarkundu', 'UP_CHORD',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    0, 7, 'Oil Filtration Plant',
    180, 185, '2026-08-17T00:20:00', '2026-08-17T03:25:00',
    'Completed', '{"job_id": "TDMS-H0196", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "DKAE-KQU", "line": "UP_CHORD", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 185, "actual_start": "2026-08-17T00:20:00", "actual_end": "2026-08-17T03:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0197', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'KQU-GRAE', 'Kamarkundu - Gurap', 'UP_CHORD',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    3, 5, 'Tower Wagon',
    90, 107, '2026-08-19T02:00:00', '2026-08-19T03:47:00',
    'Completed', '{"job_id": "TDMS-H0197", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "KQU-GRAE", "line": "UP_CHORD", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 107, "actual_start": "2026-08-19T02:00:00", "actual_end": "2026-08-19T03:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0198', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'SKG-KAN', 'Saktigarh - Khana', 'DN_CHORD',
    'Dropper Renewal', 'OHE', 'High', 'High',
    3, 5, 'Tower Wagon',
    75, 83, '2026-08-21T13:45:00', '2026-08-21T15:08:00',
    'Completed', '{"job_id": "TDMS-H0198", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "SKG-KAN", "line": "DN_CHORD", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 83, "actual_start": "2026-08-21T13:45:00", "actual_end": "2026-08-21T15:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0199', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'DN_CHORD',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    1, 6, 'Tower Wagon',
    105, 119, '2026-08-27T02:25:00', '2026-08-27T04:24:00',
    'Completed', '{"job_id": "TDMS-H0199", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "DN_CHORD", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 119, "actual_start": "2026-08-27T02:25:00", "actual_end": "2026-08-27T04:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0200', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'DN_CHORD',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    3, 8, 'Oil Filtration Plant',
    180, 175, '2026-08-30T12:50:00', '2026-08-30T15:45:00',
    'Completed', '{"job_id": "TDMS-H0200", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "DN_CHORD", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 175, "actual_start": "2026-08-30T12:50:00", "actual_end": "2026-08-30T15:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0201', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'GRAE-MSAE', 'Gurap - Masagram', 'UP_CHORD',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    2, 7, 'Tower Wagon',
    150, 143, '2026-08-30T17:10:00', '2026-08-30T19:33:00',
    'Completed', '{"job_id": "TDMS-H0201", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "GRAE-MSAE", "line": "UP_CHORD", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 143, "actual_start": "2026-08-30T17:10:00", "actual_end": "2026-08-30T19:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0202', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'UP_CHORD',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    2, 5, 'Tower Wagon',
    135, 150, '2026-08-31T03:05:00', '2026-08-31T05:35:00',
    'Completed', '{"job_id": "TDMS-H0202", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "UP_CHORD", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 150, "actual_start": "2026-08-31T03:05:00", "actual_end": "2026-08-31T05:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0203', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'MSAE-SKG', 'Masagram - Saktigarh', 'UP_CHORD',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    1, 7, 'Tower Wagon',
    120, 110, '2026-09-02T11:20:00', '2026-09-02T13:10:00',
    'Completed', '{"job_id": "TDMS-H0203", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "MSAE-SKG", "line": "UP_CHORD", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 110, "actual_start": "2026-09-02T11:20:00", "actual_end": "2026-09-02T13:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0204', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'DKAE-KQU', 'Dankuni - Kamarkundu', 'DN_CHORD',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    2, 6, 'SF6 Gas Filling Kit',
    105, 118, '2026-09-03T02:40:00', '2026-09-03T04:38:00',
    'Completed', '{"job_id": "TDMS-H0204", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "DKAE-KQU", "line": "DN_CHORD", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-09-03T02:40:00", "actual_end": "2026-09-03T04:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0205', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'HWH-KAN (Chord line)', 'Howrah – Khana (Chord line)', 'HWH-DKAE', 'Howrah - Dankuni', 'DN_CHORD',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    2, 7, 'Tower Wagon',
    150, 169, '2026-09-03T16:45:00', '2026-09-03T19:34:00',
    'Completed', '{"job_id": "TDMS-H0205", "division": "HWH", "section": "HWH-KAN (Chord line)", "block_section": "HWH-DKAE", "line": "DN_CHORD", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 169, "actual_start": "2026-09-03T16:45:00", "actual_end": "2026-09-03T19:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0206', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'SNT-RPH', 'Sainthia - Rampurhat', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    2, 5, 'Ladder & Tension Meter',
    75, 92, '2026-07-07T15:40:00', '2026-07-07T17:12:00',
    'Completed', '{"job_id": "TDMS-H0206", "division": "HWH", "section": "KAN-GMAN", "block_section": "SNT-RPH", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 92, "actual_start": "2026-07-07T15:40:00", "actual_end": "2026-07-07T17:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0207', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'PKR-GMAN', 'Pakur - Gumani', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    0, 3, 'Inspection Vehicle',
    45, 44, '2026-07-08T02:35:00', '2026-07-08T03:19:00',
    'Completed', '{"job_id": "TDMS-H0207", "division": "HWH", "section": "KAN-GMAN", "block_section": "PKR-GMAN", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 44, "actual_start": "2026-07-08T02:35:00", "actual_end": "2026-07-08T03:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0208', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'SNT-RPH', 'Sainthia - Rampurhat', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    1, 4, 'Inspection Vehicle',
    45, 45, '2026-07-10T03:40:00', '2026-07-10T04:25:00',
    'Completed', '{"job_id": "TDMS-H0208", "division": "HWH", "section": "KAN-GMAN", "block_section": "SNT-RPH", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 45, "actual_start": "2026-07-10T03:40:00", "actual_end": "2026-07-10T04:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0209', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'NHT-PKR', 'Nalhati - Pakur', 'DN_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    0, 7, 'Oil Filtration Plant',
    180, 176, '2026-07-10T11:15:00', '2026-07-10T14:11:00',
    'Completed', '{"job_id": "TDMS-H0209", "division": "HWH", "section": "KAN-GMAN", "block_section": "NHT-PKR", "line": "DN_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 176, "actual_start": "2026-07-10T11:15:00", "actual_end": "2026-07-10T14:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0210', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'NHT-PKR', 'Nalhati - Pakur', 'DN_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    3, 6, 'Tower Wagon',
    60, 71, '2026-07-14T00:15:00', '2026-07-14T01:26:00',
    'Completed', '{"job_id": "TDMS-H0210", "division": "HWH", "section": "KAN-GMAN", "block_section": "NHT-PKR", "line": "DN_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 71, "actual_start": "2026-07-14T00:15:00", "actual_end": "2026-07-14T01:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0211', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'UP_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'Critical',
    3, 4, 'Ladder & Contact Burnisher',
    75, 78, '2026-07-16T11:05:00', '2026-07-16T12:23:00',
    'Completed', '{"job_id": "TDMS-H0211", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "UP_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 78, "actual_start": "2026-07-16T11:05:00", "actual_end": "2026-07-16T12:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0212', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'NHT-PKR', 'Nalhati - Pakur', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    45, 61, '2026-07-18T12:50:00', '2026-07-18T13:51:00',
    'Completed', '{"job_id": "TDMS-H0212", "division": "HWH", "section": "KAN-GMAN", "block_section": "NHT-PKR", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 61, "actual_start": "2026-07-18T12:50:00", "actual_end": "2026-07-18T13:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0213', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'KAN-BHP', 'Khana - Bolpur Shantiniketan', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    0, 4, 'Tower Wagon',
    120, 133, '2026-07-19T04:10:00', '2026-07-19T06:23:00',
    'Completed', '{"job_id": "TDMS-H0213", "division": "HWH", "section": "KAN-GMAN", "block_section": "KAN-BHP", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-07-19T04:10:00", "actual_end": "2026-07-19T06:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0214', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'RPH-NHT', 'Rampurhat - Nalhati', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    1, 3, 'Inspection Vehicle',
    45, 45, '2026-07-23T03:55:00', '2026-07-23T04:40:00',
    'Completed', '{"job_id": "TDMS-H0214", "division": "HWH", "section": "KAN-GMAN", "block_section": "RPH-NHT", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 45, "actual_start": "2026-07-23T03:55:00", "actual_end": "2026-07-23T04:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0215', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    1, 6, 'Ladder & Tension Meter',
    75, 68, '2026-07-26T01:40:00', '2026-07-26T02:48:00',
    'Completed', '{"job_id": "TDMS-H0215", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-07-26T01:40:00", "actual_end": "2026-07-26T02:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0216', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'SNT-RPH', 'Sainthia - Rampurhat', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'Critical',
    0, 6, 'SF6 Gas Filling Kit',
    90, 91, '2026-08-01T15:35:00', '2026-08-01T17:06:00',
    'Completed', '{"job_id": "TDMS-H0216", "division": "HWH", "section": "KAN-GMAN", "block_section": "SNT-RPH", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 91, "actual_start": "2026-08-01T15:35:00", "actual_end": "2026-08-01T17:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0217', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'PKR-GMAN', 'Pakur - Gumani', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    1, 4, 'CB Timing Analyzer',
    135, 151, '2026-08-08T16:50:00', '2026-08-08T19:21:00',
    'Completed', '{"job_id": "TDMS-H0217", "division": "HWH", "section": "KAN-GMAN", "block_section": "PKR-GMAN", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 151, "actual_start": "2026-08-08T16:50:00", "actual_end": "2026-08-08T19:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0218', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Medium',
    1, 7, 'Tower Wagon',
    90, 93, '2026-08-10T00:10:00', '2026-08-10T01:43:00',
    'Completed', '{"job_id": "TDMS-H0218", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-08-10T00:10:00", "actual_end": "2026-08-10T01:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0219', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'NHT-PKR', 'Nalhati - Pakur', 'DN_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    8, 5, 'SF6 Gas Filling Kit',
    105, 103, '2026-08-11T02:15:00', '2026-08-11T03:58:00',
    'Completed', '{"job_id": "TDMS-H0219", "division": "HWH", "section": "KAN-GMAN", "block_section": "NHT-PKR", "line": "DN_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 8, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-08-11T02:15:00", "actual_end": "2026-08-11T03:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0220', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'Critical',
    2, 7, 'Tower Wagon',
    165, 155, '2026-08-17T12:30:00', '2026-08-17T15:05:00',
    'Completed', '{"job_id": "TDMS-H0220", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 155, "actual_start": "2026-08-17T12:30:00", "actual_end": "2026-08-17T15:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0221', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'PKR-GMAN', 'Pakur - Gumani', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    1, 4, 'Inspection Vehicle',
    60, 74, '2026-08-23T00:45:00', '2026-08-23T01:59:00',
    'Completed', '{"job_id": "TDMS-H0221", "division": "HWH", "section": "KAN-GMAN", "block_section": "PKR-GMAN", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 74, "actual_start": "2026-08-23T00:45:00", "actual_end": "2026-08-23T01:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0222', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'SNT-RPH', 'Sainthia - Rampurhat', 'DN_MAIN',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    0, 7, 'Tower Wagon',
    120, 116, '2026-08-23T17:25:00', '2026-08-23T19:21:00',
    'Completed', '{"job_id": "TDMS-H0222", "division": "HWH", "section": "KAN-GMAN", "block_section": "SNT-RPH", "line": "DN_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 116, "actual_start": "2026-08-23T17:25:00", "actual_end": "2026-08-23T19:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0223', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'RPH-NHT', 'Rampurhat - Nalhati', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    5, 7, 'Tower Wagon',
    135, 146, '2026-08-29T01:05:00', '2026-08-29T03:31:00',
    'Completed', '{"job_id": "TDMS-H0223", "division": "HWH", "section": "KAN-GMAN", "block_section": "RPH-NHT", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 5, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 146, "actual_start": "2026-08-29T01:05:00", "actual_end": "2026-08-29T03:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0224', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'SNT-RPH', 'Sainthia - Rampurhat', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'High',
    1, 5, 'CB Timing Analyzer',
    150, 150, '2026-08-29T11:15:00', '2026-08-29T13:45:00',
    'Completed', '{"job_id": "TDMS-H0224", "division": "HWH", "section": "KAN-GMAN", "block_section": "SNT-RPH", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 150, "actual_start": "2026-08-29T11:15:00", "actual_end": "2026-08-29T13:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0225', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'RPH-NHT', 'Rampurhat - Nalhati', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    2, 4, 'Ladder & Tension Meter',
    90, 110, '2026-09-01T02:30:00', '2026-09-01T04:20:00',
    'Completed', '{"job_id": "TDMS-H0225", "division": "HWH", "section": "KAN-GMAN", "block_section": "RPH-NHT", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 110, "actual_start": "2026-09-01T02:30:00", "actual_end": "2026-09-01T04:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0226', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    3, 7, 'Tower Wagon',
    75, 93, '2026-09-04T03:55:00', '2026-09-04T05:28:00',
    'Completed', '{"job_id": "TDMS-H0226", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 93, "actual_start": "2026-09-04T03:55:00", "actual_end": "2026-09-04T05:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0227', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'NHT-PKR', 'Nalhati - Pakur', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    5, 5, 'Tower Wagon',
    135, 136, '2026-09-05T13:30:00', '2026-09-05T15:46:00',
    'Completed', '{"job_id": "TDMS-H0227", "division": "HWH", "section": "KAN-GMAN", "block_section": "NHT-PKR", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 5, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 136, "actual_start": "2026-09-05T13:30:00", "actual_end": "2026-09-05T15:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0228', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'RPH-NHT', 'Rampurhat - Nalhati', 'DN_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    1, 8, 'Oil Filtration Plant',
    210, 205, '2026-09-05T17:20:00', '2026-09-05T20:45:00',
    'Completed', '{"job_id": "TDMS-H0228", "division": "HWH", "section": "KAN-GMAN", "block_section": "RPH-NHT", "line": "DN_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 205, "actual_start": "2026-09-05T17:20:00", "actual_end": "2026-09-05T20:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0229', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'KAN-GMAN', 'Khana – Gumani', 'BHP-SNT', 'Bolpur - Sainthia', 'UP_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    2, 7, 'Oil Filtration Plant',
    195, 198, '2026-09-06T15:20:00', '2026-09-06T18:38:00',
    'Completed', '{"job_id": "TDMS-H0229", "division": "HWH", "section": "KAN-GMAN", "block_section": "BHP-SNT", "line": "UP_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 198, "actual_start": "2026-09-06T15:20:00", "actual_end": "2026-09-06T18:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0230', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    4, 6, 'SF6 Gas Filling Kit',
    90, 104, '2026-07-03T17:50:00', '2026-07-03T19:34:00',
    'Completed', '{"job_id": "TDMS-H0230", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 104, "actual_start": "2026-07-03T17:50:00", "actual_end": "2026-07-03T19:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0231', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Medium', 'Critical',
    7, 4, 'SF6 Gas Filling Kit',
    120, 112, '2026-07-13T16:25:00', '2026-07-13T18:17:00',
    'Completed', '{"job_id": "TDMS-H0231", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Medium", "criticality": "Critical", "overdue_days": 7, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 112, "actual_start": "2026-07-13T16:25:00", "actual_end": "2026-07-13T18:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0232', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Medium',
    2, 5, 'Tower Wagon',
    120, 117, '2026-07-14T11:00:00', '2026-07-14T12:57:00',
    'Completed', '{"job_id": "TDMS-H0232", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 117, "actual_start": "2026-07-14T11:00:00", "actual_end": "2026-07-14T12:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0233', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    4, 8, 'Tower Wagon',
    105, 120, '2026-07-16T02:05:00', '2026-07-16T04:05:00',
    'Completed', '{"job_id": "TDMS-H0233", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 120, "actual_start": "2026-07-16T02:05:00", "actual_end": "2026-07-16T04:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0234', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    2, 5, 'Ladder & Contact Burnisher',
    60, 82, '2026-07-16T15:00:00', '2026-07-16T16:22:00',
    'Completed', '{"job_id": "TDMS-H0234", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 82, "actual_start": "2026-07-16T15:00:00", "actual_end": "2026-07-16T16:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0235', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    75, 80, '2026-07-21T12:55:00', '2026-07-21T14:15:00',
    'Completed', '{"job_id": "TDMS-H0235", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 80, "actual_start": "2026-07-21T12:55:00", "actual_end": "2026-07-21T14:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0236', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    8, 10, 'Tower Wagon',
    105, 127, '2026-07-21T16:50:00', '2026-07-21T18:57:00',
    'Completed', '{"job_id": "TDMS-H0236", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 8, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 127, "actual_start": "2026-07-21T16:50:00", "actual_end": "2026-07-21T18:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0237', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'High',
    2, 3, 'Earth Tester & Bonding Kit',
    90, 108, '2026-07-22T17:30:00', '2026-07-22T19:18:00',
    'Completed', '{"job_id": "TDMS-H0237", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 108, "actual_start": "2026-07-22T17:30:00", "actual_end": "2026-07-22T19:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0238', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Critical', 'High',
    3, 5, 'Ladder & Tension Meter',
    105, 101, '2026-07-24T13:40:00', '2026-07-24T15:21:00',
    'Completed', '{"job_id": "TDMS-H0238", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 101, "actual_start": "2026-07-24T13:40:00", "actual_end": "2026-07-24T15:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0239', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    1, 4, 'Ladder & Tension Meter',
    105, 111, '2026-07-30T11:45:00', '2026-07-30T13:36:00',
    'Completed', '{"job_id": "TDMS-H0239", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-07-30T11:45:00", "actual_end": "2026-07-30T13:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0240', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    3, 7, 'Oil Filtration Plant',
    165, 161, '2026-08-03T16:25:00', '2026-08-03T19:06:00',
    'Completed', '{"job_id": "TDMS-H0240", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 161, "actual_start": "2026-08-03T16:25:00", "actual_end": "2026-08-03T19:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0241', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    0, 7, 'Tower Wagon',
    150, 154, '2026-08-05T15:15:00', '2026-08-05T17:49:00',
    'Completed', '{"job_id": "TDMS-H0241", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 154, "actual_start": "2026-08-05T15:15:00", "actual_end": "2026-08-05T17:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0242', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Critical',
    8, 5, 'Tower Wagon',
    105, 96, '2026-08-08T01:40:00', '2026-08-08T03:16:00',
    'Completed', '{"job_id": "TDMS-H0242", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 8, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 96, "actual_start": "2026-08-08T01:40:00", "actual_end": "2026-08-08T03:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0243', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'High',
    0, 3, 'Inspection Vehicle',
    45, 40, '2026-08-09T01:35:00', '2026-08-09T02:15:00',
    'Completed', '{"job_id": "TDMS-H0243", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-09T01:35:00", "actual_end": "2026-08-09T02:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0244', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    1, 5, 'Inspection Vehicle',
    75, 71, '2026-08-10T17:50:00', '2026-08-10T19:01:00',
    'Completed', '{"job_id": "TDMS-H0244", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 71, "actual_start": "2026-08-10T17:50:00", "actual_end": "2026-08-10T19:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0245', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'High', 'Medium',
    0, 4, 'Inspection Vehicle',
    90, 80, '2026-08-11T04:45:00', '2026-08-11T06:05:00',
    'Completed', '{"job_id": "TDMS-H0245", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-08-11T04:45:00", "actual_end": "2026-08-11T06:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0246', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    2, 3, 'Inspection Vehicle',
    60, 52, '2026-08-11T13:35:00', '2026-08-11T14:27:00',
    'Completed', '{"job_id": "TDMS-H0246", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 52, "actual_start": "2026-08-11T13:35:00", "actual_end": "2026-08-11T14:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0247', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    0, 6, 'Tower Wagon',
    60, 57, '2026-08-12T15:30:00', '2026-08-12T16:27:00',
    'Completed', '{"job_id": "TDMS-H0247", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 57, "actual_start": "2026-08-12T15:30:00", "actual_end": "2026-08-12T16:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0248', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    3, 5, 'SF6 Gas Filling Kit',
    120, 133, '2026-08-14T01:00:00', '2026-08-14T03:13:00',
    'Completed', '{"job_id": "TDMS-H0248", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-08-14T01:00:00", "actual_end": "2026-08-14T03:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0249', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    1, 7, 'Oil Filtration Plant',
    180, 184, '2026-08-16T16:25:00', '2026-08-16T19:29:00',
    'Completed', '{"job_id": "TDMS-H0249", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 184, "actual_start": "2026-08-16T16:25:00", "actual_end": "2026-08-16T19:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0250', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    2, 5, 'Tower Wagon',
    90, 88, '2026-08-16T17:10:00', '2026-08-16T18:38:00',
    'Completed', '{"job_id": "TDMS-H0250", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 88, "actual_start": "2026-08-16T17:10:00", "actual_end": "2026-08-16T18:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0251', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'Medium',
    1, 4, 'RTU Diagnostic Terminal',
    75, 74, '2026-08-19T11:50:00', '2026-08-19T13:04:00',
    'Completed', '{"job_id": "TDMS-H0251", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 75, "actual_duration_min": 74, "actual_start": "2026-08-19T11:50:00", "actual_end": "2026-08-19T13:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0252', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    1, 4, 'Ladder & Contact Burnisher',
    90, 96, '2026-08-25T12:00:00', '2026-08-25T13:36:00',
    'Completed', '{"job_id": "TDMS-H0252", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 96, "actual_start": "2026-08-25T12:00:00", "actual_end": "2026-08-25T13:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0253', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    1, 4, 'Tower Wagon',
    120, 124, '2026-08-26T02:15:00', '2026-08-26T04:19:00',
    'Completed', '{"job_id": "TDMS-H0253", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 124, "actual_start": "2026-08-26T02:15:00", "actual_end": "2026-08-26T04:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0254', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'RPH-PRGR', 'Rampurhat - Pinargaria', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 6, 'Tower Wagon',
    105, 117, '2026-08-26T11:35:00', '2026-08-26T13:32:00',
    'Completed', '{"job_id": "TDMS-H0254", "division": "HWH", "section": "RPH-DUMK", "block_section": "RPH-PRGR", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-08-26T11:35:00", "actual_end": "2026-08-26T13:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0255', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'PRGR-SKIP', 'Pinargaria - Shikaripara', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    1, 4, 'Inspection Vehicle',
    75, 76, '2026-09-06T15:20:00', '2026-09-06T16:36:00',
    'Completed', '{"job_id": "TDMS-H0255", "division": "HWH", "section": "RPH-DUMK", "block_section": "PRGR-SKIP", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 76, "actual_start": "2026-09-06T15:20:00", "actual_end": "2026-09-06T16:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0256', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'RPH-DUMK', 'Rampurhat – Dumka', 'SKIP-DUMK', 'Shikaripara - Dumka', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'High',
    2, 4, 'RTU Diagnostic Terminal',
    105, 124, '2026-09-08T13:50:00', '2026-09-08T15:54:00',
    'Completed', '{"job_id": "TDMS-H0256", "division": "HWH", "section": "RPH-DUMK", "block_section": "SKIP-DUMK", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 105, "actual_duration_min": 124, "actual_start": "2026-09-08T13:50:00", "actual_end": "2026-09-08T15:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0257', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'DN_LOOP',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Medium',
    1, 3, 'Secondary Injection Test Set',
    120, 119, '2026-07-02T15:15:00', '2026-07-02T17:14:00',
    'Completed', '{"job_id": "TDMS-H0257", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "DN_LOOP", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 119, "actual_start": "2026-07-02T15:15:00", "actual_end": "2026-07-02T17:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0258', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'KWAE-SALE', 'Katwa - Salar', 'DN_LOOP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 5, 'Tower Wagon',
    105, 113, '2026-07-04T11:10:00', '2026-07-04T13:03:00',
    'Completed', '{"job_id": "TDMS-H0258", "division": "HWH", "section": "BDC-AZ", "block_section": "KWAE-SALE", "line": "DN_LOOP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-07-04T11:10:00", "actual_end": "2026-07-04T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0259', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'DN_LOOP',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'High',
    2, 5, 'Ladder & Tension Meter',
    60, 73, '2026-07-06T04:25:00', '2026-07-06T05:38:00',
    'Completed', '{"job_id": "TDMS-H0259", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "DN_LOOP", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 73, "actual_start": "2026-07-06T04:25:00", "actual_end": "2026-07-06T05:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0260', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'KWAE-SALE', 'Katwa - Salar', 'UP_LOOP',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    1, 5, 'Tower Wagon',
    150, 154, '2026-07-06T12:25:00', '2026-07-06T14:59:00',
    'Completed', '{"job_id": "TDMS-H0260", "division": "HWH", "section": "BDC-AZ", "block_section": "KWAE-SALE", "line": "UP_LOOP", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 154, "actual_start": "2026-07-06T12:25:00", "actual_end": "2026-07-06T14:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0261', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'ABKA-NDAE', 'Ambika Kalna - Nabadwip Dham', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Critical', 'High',
    4, 4, 'Tower Wagon',
    120, 118, '2026-07-09T15:15:00', '2026-07-09T17:13:00',
    'Completed', '{"job_id": "TDMS-H0261", "division": "HWH", "section": "BDC-AZ", "block_section": "ABKA-NDAE", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 4, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 118, "actual_start": "2026-07-09T15:15:00", "actual_end": "2026-07-09T17:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0262', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'DN_LOOP',
    'Dropper Renewal', 'OHE', 'High', 'High',
    0, 7, 'Tower Wagon',
    90, 103, '2026-07-10T15:55:00', '2026-07-10T17:38:00',
    'Completed', '{"job_id": "TDMS-H0262", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "DN_LOOP", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 103, "actual_start": "2026-07-10T15:55:00", "actual_end": "2026-07-10T17:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0263', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'KWAE-SALE', 'Katwa - Salar', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    4, 6, 'SF6 Gas Filling Kit',
    105, 107, '2026-07-11T13:35:00', '2026-07-11T15:22:00',
    'Completed', '{"job_id": "TDMS-H0263", "division": "HWH", "section": "BDC-AZ", "block_section": "KWAE-SALE", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 107, "actual_start": "2026-07-11T13:35:00", "actual_end": "2026-07-11T15:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0264', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'High',
    0, 8, 'Tower Wagon',
    150, 146, '2026-07-13T11:25:00', '2026-07-13T13:51:00',
    'Completed', '{"job_id": "TDMS-H0264", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 146, "actual_start": "2026-07-13T11:25:00", "actual_end": "2026-07-13T13:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0265', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'UP_LOOP',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    2, 6, 'Tower Wagon',
    75, 89, '2026-07-14T17:30:00', '2026-07-14T18:59:00',
    'Completed', '{"job_id": "TDMS-H0265", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "UP_LOOP", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 89, "actual_start": "2026-07-14T17:30:00", "actual_end": "2026-07-14T18:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0266', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'ABKA-NDAE', 'Ambika Kalna - Nabadwip Dham', 'DN_LOOP',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'High',
    4, 3, 'RTU Diagnostic Terminal',
    60, 56, '2026-07-16T12:50:00', '2026-07-16T13:46:00',
    'Completed', '{"job_id": "TDMS-H0266", "division": "HWH", "section": "BDC-AZ", "block_section": "ABKA-NDAE", "line": "DN_LOOP", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "High", "overdue_days": 4, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 56, "actual_start": "2026-07-16T12:50:00", "actual_end": "2026-07-16T13:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0267', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'ABKA-NDAE', 'Ambika Kalna - Nabadwip Dham', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    0, 6, 'Tower Wagon',
    120, 119, '2026-07-16T15:55:00', '2026-07-16T17:54:00',
    'Completed', '{"job_id": "TDMS-H0267", "division": "HWH", "section": "BDC-AZ", "block_section": "ABKA-NDAE", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 119, "actual_start": "2026-07-16T15:55:00", "actual_end": "2026-07-16T17:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0268', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'SALE-AZ', 'Salar - Azimganj', 'UP_LOOP',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    2, 5, 'Tower Wagon',
    150, 169, '2026-07-18T11:15:00', '2026-07-18T14:04:00',
    'Completed', '{"job_id": "TDMS-H0268", "division": "HWH", "section": "BDC-AZ", "block_section": "SALE-AZ", "line": "UP_LOOP", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 169, "actual_start": "2026-07-18T11:15:00", "actual_end": "2026-07-18T14:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0269', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'SALE-AZ', 'Salar - Azimganj', 'DN_LOOP',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Medium', 'Critical',
    4, 4, 'SF6 Gas Filling Kit',
    90, 83, '2026-07-24T04:15:00', '2026-07-24T05:38:00',
    'Completed', '{"job_id": "TDMS-H0269", "division": "HWH", "section": "BDC-AZ", "block_section": "SALE-AZ", "line": "DN_LOOP", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-07-24T04:15:00", "actual_end": "2026-07-24T05:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0270', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'UP_LOOP',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Medium',
    1, 4, 'Secondary Injection Test Set',
    105, 105, '2026-07-26T04:30:00', '2026-07-26T06:15:00',
    'Completed', '{"job_id": "TDMS-H0270", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "UP_LOOP", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 105, "actual_start": "2026-07-26T04:30:00", "actual_end": "2026-07-26T06:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0271', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'UP_LOOP',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 4, 'Tower Wagon',
    75, 75, '2026-07-28T02:50:00', '2026-07-28T04:05:00',
    'Completed', '{"job_id": "TDMS-H0271", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "UP_LOOP", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 75, "actual_start": "2026-07-28T02:50:00", "actual_end": "2026-07-28T04:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0272', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'KWAE-SALE', 'Katwa - Salar', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    0, 6, 'Tower Wagon',
    75, 92, '2026-07-31T14:05:00', '2026-07-31T15:37:00',
    'Completed', '{"job_id": "TDMS-H0272", "division": "HWH", "section": "BDC-AZ", "block_section": "KWAE-SALE", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 92, "actual_start": "2026-07-31T14:05:00", "actual_end": "2026-07-31T15:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0273', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    7, 6, 'Tower Wagon',
    75, 84, '2026-08-14T14:40:00', '2026-08-14T16:04:00',
    'Completed', '{"job_id": "TDMS-H0273", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 7, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 84, "actual_start": "2026-08-14T14:40:00", "actual_end": "2026-08-14T16:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0274', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'ABKA-NDAE', 'Ambika Kalna - Nabadwip Dham', 'DN_LOOP',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    90, 81, '2026-08-19T12:50:00', '2026-08-19T14:11:00',
    'Completed', '{"job_id": "TDMS-H0274", "division": "HWH", "section": "BDC-AZ", "block_section": "ABKA-NDAE", "line": "DN_LOOP", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 81, "actual_start": "2026-08-19T12:50:00", "actual_end": "2026-08-19T14:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0275', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Medium', 'High',
    3, 5, 'Tower Wagon',
    120, 133, '2026-08-29T02:25:00', '2026-08-29T04:38:00',
    'Completed', '{"job_id": "TDMS-H0275", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-08-29T02:25:00", "actual_end": "2026-08-29T04:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0276', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'DN_LOOP',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    5, 5, 'SF6 Gas Filling Kit',
    105, 118, '2026-08-29T11:40:00', '2026-08-29T13:38:00',
    'Completed', '{"job_id": "TDMS-H0276", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "DN_LOOP", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 5, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-08-29T11:40:00", "actual_end": "2026-08-29T13:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0277', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'DN_LOOP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    0, 7, 'Oil Filtration Plant',
    165, 186, '2026-08-30T00:35:00', '2026-08-30T03:41:00',
    'Completed', '{"job_id": "TDMS-H0277", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "DN_LOOP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 186, "actual_start": "2026-08-30T00:35:00", "actual_end": "2026-08-30T03:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0278', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'SALE-AZ', 'Salar - Azimganj', 'DN_LOOP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Medium', 'Critical',
    3, 7, 'Oil Filtration Plant',
    165, 155, '2026-08-30T15:05:00', '2026-08-30T17:40:00',
    'Completed', '{"job_id": "TDMS-H0278", "division": "HWH", "section": "BDC-AZ", "block_section": "SALE-AZ", "line": "DN_LOOP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 155, "actual_start": "2026-08-30T15:05:00", "actual_end": "2026-08-30T17:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0279', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    3, 4, 'Tower Wagon',
    105, 99, '2026-09-05T17:20:00', '2026-09-05T18:59:00',
    'Completed', '{"job_id": "TDMS-H0279", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 99, "actual_start": "2026-09-05T17:20:00", "actual_end": "2026-09-05T18:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0280', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'NDAE-KWAE', 'Nabadwip Dham - Katwa', 'UP_LOOP',
    'Dropper Renewal', 'OHE', 'High', 'High',
    2, 7, 'Tower Wagon',
    120, 127, '2026-09-06T03:30:00', '2026-09-06T05:37:00',
    'Completed', '{"job_id": "TDMS-H0280", "division": "HWH", "section": "BDC-AZ", "block_section": "NDAE-KWAE", "line": "UP_LOOP", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 127, "actual_start": "2026-09-06T03:30:00", "actual_end": "2026-09-06T05:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0281', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'BDC-ABKA', 'Bandel - Ambika Kalna', 'UP_LOOP',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'High',
    0, 4, 'RTU Diagnostic Terminal',
    90, 80, '2026-09-06T04:05:00', '2026-09-06T05:25:00',
    'Completed', '{"job_id": "TDMS-H0281", "division": "HWH", "section": "BDC-AZ", "block_section": "BDC-ABKA", "line": "UP_LOOP", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-09-06T04:05:00", "actual_end": "2026-09-06T05:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0282', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'SALE-AZ', 'Salar - Azimganj', 'DN_LOOP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    0, 6, 'Tower Wagon',
    120, 125, '2026-09-06T15:55:00', '2026-09-06T18:00:00',
    'Completed', '{"job_id": "TDMS-H0282", "division": "HWH", "section": "BDC-AZ", "block_section": "SALE-AZ", "line": "DN_LOOP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 125, "actual_start": "2026-09-06T15:55:00", "actual_end": "2026-09-06T18:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0283', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-AZ', 'Bandel – Azimganj', 'SALE-AZ', 'Salar - Azimganj', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    0, 6, 'CB Timing Analyzer',
    135, 132, '2026-09-06T17:30:00', '2026-09-06T19:42:00',
    'Completed', '{"job_id": "TDMS-H0283", "division": "HWH", "section": "BDC-AZ", "block_section": "SALE-AZ", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 132, "actual_start": "2026-09-06T17:30:00", "actual_end": "2026-09-06T19:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0284', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    2, 8, 'Oil Filtration Plant',
    195, 206, '2026-07-06T03:15:00', '2026-07-06T06:41:00',
    'Completed', '{"job_id": "TDMS-H0284", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 206, "actual_start": "2026-07-06T03:15:00", "actual_end": "2026-07-06T06:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0285', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    3, 6, 'Tower Wagon',
    105, 124, '2026-07-12T04:30:00', '2026-07-12T06:34:00',
    'Completed', '{"job_id": "TDMS-H0285", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 124, "actual_start": "2026-07-12T04:30:00", "actual_end": "2026-07-12T06:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0286', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    3, 5, 'Ladder & Contact Burnisher',
    75, 70, '2026-07-12T17:20:00', '2026-07-12T18:30:00',
    'Completed', '{"job_id": "TDMS-H0286", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-07-12T17:20:00", "actual_end": "2026-07-12T18:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0287', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_DN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    2, 5, 'Ladder & Tension Meter',
    90, 93, '2026-07-14T11:05:00', '2026-07-14T12:38:00',
    'Completed', '{"job_id": "TDMS-H0287", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_DN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-07-14T11:05:00", "actual_end": "2026-07-14T12:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0288', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    4, 5, 'CB Timing Analyzer',
    120, 135, '2026-07-14T15:05:00', '2026-07-14T17:20:00',
    'Completed', '{"job_id": "TDMS-H0288", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 135, "actual_start": "2026-07-14T15:05:00", "actual_end": "2026-07-14T17:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0289', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_DN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    1, 4, 'Inspection Vehicle',
    90, 87, '2026-07-14T17:50:00', '2026-07-14T19:17:00',
    'Completed', '{"job_id": "TDMS-H0289", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_DN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-07-14T17:50:00", "actual_end": "2026-07-14T19:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0290', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_DN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 4, 'Tower Wagon',
    75, 90, '2026-07-26T11:00:00', '2026-07-26T12:30:00',
    'Completed', '{"job_id": "TDMS-H0290", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_DN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 90, "actual_start": "2026-07-26T11:00:00", "actual_end": "2026-07-26T12:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0291', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    0, 6, 'Oil Filtration Plant',
    195, 193, '2026-07-30T04:45:00', '2026-07-30T07:58:00',
    'Completed', '{"job_id": "TDMS-H0291", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 193, "actual_start": "2026-07-30T04:45:00", "actual_end": "2026-07-30T07:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0292', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 45, '2026-07-31T01:00:00', '2026-07-31T01:45:00',
    'Completed', '{"job_id": "TDMS-H0292", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 45, "actual_start": "2026-07-31T01:00:00", "actual_end": "2026-07-31T01:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0293', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    2, 5, 'Earth Tester & Bonding Kit',
    75, 82, '2026-08-01T16:55:00', '2026-08-01T18:17:00',
    'Completed', '{"job_id": "TDMS-H0293", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-08-01T16:55:00", "actual_end": "2026-08-01T18:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0294', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_DN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    0, 6, 'Tower Wagon',
    105, 106, '2026-08-03T14:20:00', '2026-08-03T16:06:00',
    'Completed', '{"job_id": "TDMS-H0294", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_DN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-08-03T14:20:00", "actual_end": "2026-08-03T16:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0295', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_DN',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    5, 10, 'Tower Wagon',
    150, 150, '2026-08-10T12:10:00', '2026-08-10T14:40:00',
    'Completed', '{"job_id": "TDMS-H0295", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_DN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 150, "actual_start": "2026-08-10T12:10:00", "actual_end": "2026-08-10T14:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0296', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    1, 5, 'SF6 Gas Filling Kit',
    120, 129, '2026-08-11T04:10:00', '2026-08-11T06:19:00',
    'Completed', '{"job_id": "TDMS-H0296", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 129, "actual_start": "2026-08-11T04:10:00", "actual_end": "2026-08-11T06:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0297', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    2, 5, 'Tower Wagon',
    150, 158, '2026-08-19T02:10:00', '2026-08-19T04:48:00',
    'Completed', '{"job_id": "TDMS-H0297", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 158, "actual_start": "2026-08-19T02:10:00", "actual_end": "2026-08-19T04:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0298', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Critical',
    3, 3, 'Secondary Injection Test Set',
    90, 97, '2026-08-19T15:50:00', '2026-08-19T17:27:00',
    'Completed', '{"job_id": "TDMS-H0298", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-08-19T15:50:00", "actual_end": "2026-08-19T17:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0299', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'High', 'Medium',
    2, 4, 'Inspection Vehicle',
    60, 64, '2026-08-20T15:15:00', '2026-08-20T16:19:00',
    'Completed', '{"job_id": "TDMS-H0299", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 64, "actual_start": "2026-08-20T15:15:00", "actual_end": "2026-08-20T16:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0300', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    1, 8, 'Tower Wagon',
    135, 131, '2026-08-21T14:10:00', '2026-08-21T16:21:00',
    'Completed', '{"job_id": "TDMS-H0300", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 131, "actual_start": "2026-08-21T14:10:00", "actual_end": "2026-08-21T16:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0301', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    3, 5, 'Tower Wagon',
    90, 102, '2026-08-23T16:30:00', '2026-08-23T18:12:00',
    'Completed', '{"job_id": "TDMS-H0301", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-08-23T16:30:00", "actual_end": "2026-08-23T18:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0302', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'Critical',
    3, 5, 'SF6 Gas Filling Kit',
    105, 103, '2026-08-25T13:45:00', '2026-08-25T15:28:00',
    'Completed', '{"job_id": "TDMS-H0302", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-08-25T13:45:00", "actual_end": "2026-08-25T15:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0303', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_DN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    3, 3, 'Earth Tester & Bonding Kit',
    90, 110, '2026-08-28T04:00:00', '2026-08-28T05:50:00',
    'Completed', '{"job_id": "TDMS-H0303", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_DN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 110, "actual_start": "2026-08-28T04:00:00", "actual_end": "2026-08-28T05:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0304', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    2, 10, 'Tower Wagon',
    135, 142, '2026-08-28T15:05:00', '2026-08-28T17:27:00',
    'Completed', '{"job_id": "TDMS-H0304", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 142, "actual_start": "2026-08-28T15:05:00", "actual_end": "2026-08-28T17:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0305', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_DN',
    'OHE Wire Replacement', 'OHE', 'Medium', 'Critical',
    4, 7, 'Tower Wagon',
    150, 157, '2026-08-30T01:20:00', '2026-08-30T03:57:00',
    'Completed', '{"job_id": "TDMS-H0305", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_DN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 157, "actual_start": "2026-08-30T01:20:00", "actual_end": "2026-08-30T03:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0306', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_DN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    1, 5, 'Tower Wagon',
    90, 97, '2026-09-01T02:15:00', '2026-09-01T03:52:00',
    'Completed', '{"job_id": "TDMS-H0306", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_DN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-09-01T02:15:00", "actual_end": "2026-09-01T03:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0307', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_DN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    1, 5, 'Tower Wagon',
    75, 65, '2026-09-05T17:45:00', '2026-09-05T18:50:00',
    'Completed', '{"job_id": "TDMS-H0307", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_DN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 65, "actual_start": "2026-09-05T17:45:00", "actual_end": "2026-09-05T18:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0308', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-BTNG', 'Dankuni - Bhattanagar', 'FREIGHT_BYPASS_UP',
    'Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    4, 5, 'Tower Wagon',
    135, 153, '2026-09-06T00:30:00', '2026-09-06T03:03:00',
    'Completed', '{"job_id": "TDMS-H0308", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-BTNG", "line": "FREIGHT_BYPASS_UP", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 153, "actual_start": "2026-09-06T00:30:00", "actual_end": "2026-09-06T03:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0309', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'DKAE-BTNG-RCD', 'Dankuni – Bhattanagar & Dankuni – Rajchandrapur', 'DKAE-RCD', 'Dankuni - Rajchandrapur', 'FREIGHT_BYPASS_UP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Critical',
    0, 5, 'Tower Wagon',
    90, 105, '2026-09-07T11:00:00', '2026-09-07T12:45:00',
    'Completed', '{"job_id": "TDMS-H0309", "division": "HWH", "section": "DKAE-BTNG-RCD", "block_section": "DKAE-RCD", "line": "FREIGHT_BYPASS_UP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 105, "actual_start": "2026-09-07T11:00:00", "actual_end": "2026-09-07T12:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0310', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'SHE-DEA', 'Sheoraphuli - Diara', 'SUBURBAN_UP',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'High',
    0, 5, 'Inspection Vehicle',
    75, 88, '2026-07-02T13:30:00', '2026-07-02T14:58:00',
    'Completed', '{"job_id": "TDMS-H0310", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "SHE-DEA", "line": "SUBURBAN_UP", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 88, "actual_start": "2026-07-02T13:30:00", "actual_end": "2026-07-02T14:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0311', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'SUBURBAN_UP',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Medium',
    0, 4, 'Tower Wagon',
    75, 65, '2026-07-02T15:05:00', '2026-07-02T16:10:00',
    'Completed', '{"job_id": "TDMS-H0311", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "SUBURBAN_UP", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 65, "actual_start": "2026-07-02T15:05:00", "actual_end": "2026-07-02T16:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0312', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'DEA-HPL', 'Diara - Haripal', 'SUBURBAN_UP',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Critical',
    0, 5, 'Tower Wagon',
    75, 88, '2026-07-02T16:15:00', '2026-07-02T17:43:00',
    'Completed', '{"job_id": "TDMS-H0312", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "DEA-HPL", "line": "SUBURBAN_UP", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 88, "actual_start": "2026-07-02T16:15:00", "actual_end": "2026-07-02T17:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0313', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'BRANCH_SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'Critical',
    2, 4, 'RTU Diagnostic Terminal',
    75, 65, '2026-07-06T16:40:00', '2026-07-06T17:45:00',
    'Completed', '{"job_id": "TDMS-H0313", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "BRANCH_SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 75, "actual_duration_min": 65, "actual_start": "2026-07-06T16:40:00", "actual_end": "2026-07-06T17:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0314', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'DEA-HPL', 'Diara - Haripal', 'SUBURBAN_DN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    3, 7, 'Tower Wagon',
    165, 158, '2026-07-11T14:50:00', '2026-07-11T17:28:00',
    'Completed', '{"job_id": "TDMS-H0314", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "DEA-HPL", "line": "SUBURBAN_DN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 158, "actual_start": "2026-07-11T14:50:00", "actual_end": "2026-07-11T17:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0315', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'SUBURBAN_DN',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    4, 8, 'Tower Wagon',
    120, 115, '2026-07-15T13:30:00', '2026-07-15T15:25:00',
    'Completed', '{"job_id": "TDMS-H0315", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "SUBURBAN_DN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 115, "actual_start": "2026-07-15T13:30:00", "actual_end": "2026-07-15T15:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0316', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'SUBURBAN_UP',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'Critical',
    4, 4, 'Ladder & Tension Meter',
    60, 62, '2026-07-15T14:45:00', '2026-07-15T15:47:00',
    'Completed', '{"job_id": "TDMS-H0316", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "SUBURBAN_UP", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 62, "actual_start": "2026-07-15T14:45:00", "actual_end": "2026-07-15T15:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0317', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'SUBURBAN_DN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    4, 4, 'Secondary Injection Test Set',
    90, 109, '2026-07-16T14:45:00', '2026-07-16T16:34:00',
    'Completed', '{"job_id": "TDMS-H0317", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "SUBURBAN_DN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-07-16T14:45:00", "actual_end": "2026-07-16T16:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0318', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'SHE-DEA', 'Sheoraphuli - Diara', 'SUBURBAN_UP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    1, 7, 'Tower Wagon',
    135, 145, '2026-07-17T17:15:00', '2026-07-17T19:40:00',
    'Completed', '{"job_id": "TDMS-H0318", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "SHE-DEA", "line": "SUBURBAN_UP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 145, "actual_start": "2026-07-17T17:15:00", "actual_end": "2026-07-17T19:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0319', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'BRANCH_SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    1, 5, 'Earth Tester & Bonding Kit',
    60, 70, '2026-07-20T03:20:00', '2026-07-20T04:30:00',
    'Completed', '{"job_id": "TDMS-H0319", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "BRANCH_SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 70, "actual_start": "2026-07-20T03:20:00", "actual_end": "2026-07-20T04:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0320', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'SUBURBAN_UP',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    0, 10, 'Tower Wagon',
    135, 129, '2026-07-29T02:25:00', '2026-07-29T04:34:00',
    'Completed', '{"job_id": "TDMS-H0320", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "SUBURBAN_UP", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 129, "actual_start": "2026-07-29T02:25:00", "actual_end": "2026-07-29T04:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0321', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'BRANCH_SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Medium',
    1, 5, 'Tower Wagon',
    120, 131, '2026-08-02T01:15:00', '2026-08-02T03:26:00',
    'Completed', '{"job_id": "TDMS-H0321", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "BRANCH_SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 131, "actual_start": "2026-08-02T01:15:00", "actual_end": "2026-08-02T03:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0322', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'SUBURBAN_UP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    2, 6, 'Oil Filtration Plant',
    195, 206, '2026-08-04T15:30:00', '2026-08-04T18:56:00',
    'Completed', '{"job_id": "TDMS-H0322", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "SUBURBAN_UP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 206, "actual_start": "2026-08-04T15:30:00", "actual_end": "2026-08-04T18:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0323', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'DEA-HPL', 'Diara - Haripal', 'SUBURBAN_DN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Medium',
    1, 8, 'Tower Wagon',
    120, 133, '2026-08-06T16:30:00', '2026-08-06T18:43:00',
    'Completed', '{"job_id": "TDMS-H0323", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "DEA-HPL", "line": "SUBURBAN_DN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Medium", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-08-06T16:30:00", "actual_end": "2026-08-06T18:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0324', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'SUBURBAN_DN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'Critical',
    0, 7, 'Tower Wagon',
    120, 125, '2026-08-09T01:30:00', '2026-08-09T03:35:00',
    'Completed', '{"job_id": "TDMS-H0324", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "SUBURBAN_DN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 125, "actual_start": "2026-08-09T01:30:00", "actual_end": "2026-08-09T03:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0325', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'DEA-HPL', 'Diara - Haripal', 'SUBURBAN_DN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    2, 4, 'Inspection Vehicle',
    90, 100, '2026-08-10T01:45:00', '2026-08-10T03:25:00',
    'Completed', '{"job_id": "TDMS-H0325", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "DEA-HPL", "line": "SUBURBAN_DN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 100, "actual_start": "2026-08-10T01:45:00", "actual_end": "2026-08-10T03:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0326', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'BRANCH_SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    0, 5, 'Ladder & Contact Burnisher',
    75, 93, '2026-08-12T12:20:00', '2026-08-12T13:53:00',
    'Completed', '{"job_id": "TDMS-H0326", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "BRANCH_SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 93, "actual_start": "2026-08-12T12:20:00", "actual_end": "2026-08-12T13:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0327', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'SUBURBAN_UP',
    'Catenary Maintenance', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    165, 176, '2026-08-12T13:50:00', '2026-08-12T16:46:00',
    'Completed', '{"job_id": "TDMS-H0327", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "SUBURBAN_UP", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 176, "actual_start": "2026-08-12T13:50:00", "actual_end": "2026-08-12T16:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0328', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'SUBURBAN_DN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    90, 83, '2026-08-18T04:30:00', '2026-08-18T05:53:00',
    'Completed', '{"job_id": "TDMS-H0328", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "SUBURBAN_DN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-08-18T04:30:00", "actual_end": "2026-08-18T05:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0329', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'SUBURBAN_UP',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 3, 'Inspection Vehicle',
    75, 83, '2026-08-20T02:35:00', '2026-08-20T03:58:00',
    'Completed', '{"job_id": "TDMS-H0329", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "SUBURBAN_UP", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 83, "actual_start": "2026-08-20T02:35:00", "actual_end": "2026-08-20T03:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0330', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'BRANCH_SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'Medium',
    0, 5, 'Ladder & Contact Burnisher',
    105, 116, '2026-08-22T00:05:00', '2026-08-22T02:01:00',
    'Completed', '{"job_id": "TDMS-H0330", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "BRANCH_SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 105, "actual_duration_min": 116, "actual_start": "2026-08-22T00:05:00", "actual_end": "2026-08-22T02:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0331', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'BRANCH_SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Critical',
    3, 5, 'Tower Wagon',
    105, 103, '2026-08-24T01:50:00', '2026-08-24T03:33:00',
    'Completed', '{"job_id": "TDMS-H0331", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "BRANCH_SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-08-24T01:50:00", "actual_end": "2026-08-24T03:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0332', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'BRANCH_SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    90, 91, '2026-08-24T03:55:00', '2026-08-24T05:26:00',
    'Completed', '{"job_id": "TDMS-H0332", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "BRANCH_SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 91, "actual_start": "2026-08-24T03:55:00", "actual_end": "2026-08-24T05:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0333', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'HPL-TAK', 'Haripal - Tarakeswar', 'SUBURBAN_DN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    0, 7, 'Oil Filtration Plant',
    195, 186, '2026-08-25T00:40:00', '2026-08-25T03:46:00',
    'Completed', '{"job_id": "TDMS-H0333", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "HPL-TAK", "line": "SUBURBAN_DN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 186, "actual_start": "2026-08-25T00:40:00", "actual_end": "2026-08-25T03:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0334', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'SUBURBAN_DN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    3, 7, 'Tower Wagon',
    105, 107, '2026-08-27T00:50:00', '2026-08-27T02:37:00',
    'Completed', '{"job_id": "TDMS-H0334", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "SUBURBAN_DN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 107, "actual_start": "2026-08-27T00:50:00", "actual_end": "2026-08-27T02:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0335', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'TAK-AMBG', 'Tarakeswar - Arambagh', 'SUBURBAN_UP',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    45, 48, '2026-09-03T02:50:00', '2026-09-03T03:38:00',
    'Completed', '{"job_id": "TDMS-H0335", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "TAK-AMBG", "line": "SUBURBAN_UP", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 48, "actual_start": "2026-09-03T02:50:00", "actual_end": "2026-09-03T03:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0336', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'SHE-TAK-GOGT', 'Sheoraphuli – Tarakeswar – Goghat', 'AMBG-GOGT', 'Arambagh - Goghat', 'SUBURBAN_UP',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    2, 6, 'Oil Filtration Plant',
    195, 209, '2026-09-08T15:15:00', '2026-09-08T18:44:00',
    'Completed', '{"job_id": "TDMS-H0336", "division": "HWH", "section": "SHE-TAK-GOGT", "block_section": "AMBG-GOGT", "line": "SUBURBAN_UP", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 209, "actual_start": "2026-09-08T15:15:00", "actual_end": "2026-09-08T18:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0337', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    2, 10, 'Tower Wagon',
    135, 135, '2026-07-03T01:55:00', '2026-07-03T04:10:00',
    'Completed', '{"job_id": "TDMS-H0337", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 2, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 135, "actual_start": "2026-07-03T01:55:00", "actual_end": "2026-07-03T04:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0338', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    120, 130, '2026-07-06T01:50:00', '2026-07-06T04:00:00',
    'Completed', '{"job_id": "TDMS-H0338", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 130, "actual_start": "2026-07-06T01:50:00", "actual_end": "2026-07-06T04:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0339', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    0, 6, 'SF6 Gas Filling Kit',
    135, 142, '2026-07-07T15:10:00', '2026-07-07T17:32:00',
    'Completed', '{"job_id": "TDMS-H0339", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 142, "actual_start": "2026-07-07T15:10:00", "actual_end": "2026-07-07T17:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0340', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'Critical',
    7, 4, 'RTU Diagnostic Terminal',
    60, 68, '2026-07-08T15:00:00', '2026-07-08T16:08:00',
    'Completed', '{"job_id": "TDMS-H0340", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "Critical", "overdue_days": 7, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 68, "actual_start": "2026-07-08T15:00:00", "actual_end": "2026-07-08T16:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0341', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'High',
    0, 6, 'Tower Wagon',
    135, 155, '2026-07-17T00:55:00', '2026-07-17T03:30:00',
    'Completed', '{"job_id": "TDMS-H0341", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 155, "actual_start": "2026-07-17T00:55:00", "actual_end": "2026-07-17T03:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0342', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'Medium',
    2, 4, 'Ladder & Contact Burnisher',
    75, 82, '2026-07-19T00:35:00', '2026-07-19T01:57:00',
    'Completed', '{"job_id": "TDMS-H0342", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-07-19T00:35:00", "actual_end": "2026-07-19T01:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0343', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    60, 50, '2026-07-21T11:40:00', '2026-07-21T12:30:00',
    'Completed', '{"job_id": "TDMS-H0343", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 50, "actual_start": "2026-07-21T11:40:00", "actual_end": "2026-07-21T12:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0344', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Low',
    0, 5, 'Inspection Vehicle',
    45, 40, '2026-07-29T02:00:00', '2026-07-29T02:40:00',
    'Completed', '{"job_id": "TDMS-H0344", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Low", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-07-29T02:00:00", "actual_end": "2026-07-29T02:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0345', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'Critical',
    0, 6, 'Tower Wagon',
    90, 111, '2026-07-31T13:45:00', '2026-07-31T15:36:00',
    'Completed', '{"job_id": "TDMS-H0345", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 111, "actual_start": "2026-07-31T13:45:00", "actual_end": "2026-07-31T15:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0346', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    6, 7, 'Oil Filtration Plant',
    210, 218, '2026-08-03T04:30:00', '2026-08-03T08:08:00',
    'Completed', '{"job_id": "TDMS-H0346", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 6, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 218, "actual_start": "2026-08-03T04:30:00", "actual_end": "2026-08-03T08:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0347', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'High',
    0, 3, 'RTU Diagnostic Terminal',
    90, 85, '2026-08-05T03:35:00', '2026-08-05T05:00:00',
    'Completed', '{"job_id": "TDMS-H0347", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 90, "actual_duration_min": 85, "actual_start": "2026-08-05T03:35:00", "actual_end": "2026-08-05T05:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0348', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    2, 7, 'Oil Filtration Plant',
    195, 205, '2026-08-06T14:55:00', '2026-08-06T18:20:00',
    'Completed', '{"job_id": "TDMS-H0348", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 205, "actual_start": "2026-08-06T14:55:00", "actual_end": "2026-08-06T18:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0349', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'High',
    0, 7, 'Tower Wagon',
    90, 85, '2026-08-15T16:55:00', '2026-08-15T18:20:00',
    'Completed', '{"job_id": "TDMS-H0349", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 85, "actual_start": "2026-08-15T16:55:00", "actual_end": "2026-08-15T18:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0350', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    0, 5, 'Tower Wagon',
    120, 137, '2026-08-16T04:35:00', '2026-08-16T06:52:00',
    'Completed', '{"job_id": "TDMS-H0350", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 137, "actual_start": "2026-08-16T04:35:00", "actual_end": "2026-08-16T06:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0351', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    4, 9, 'Tower Wagon',
    120, 131, '2026-08-20T14:40:00', '2026-08-20T16:51:00',
    'Completed', '{"job_id": "TDMS-H0351", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 131, "actual_start": "2026-08-20T14:40:00", "actual_end": "2026-08-20T16:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0352', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    2, 7, 'Tower Wagon',
    90, 87, '2026-08-23T11:10:00', '2026-08-23T12:37:00',
    'Completed', '{"job_id": "TDMS-H0352", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-08-23T11:10:00", "actual_end": "2026-08-23T12:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0353', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    105, 126, '2026-08-23T13:20:00', '2026-08-23T15:26:00',
    'Completed', '{"job_id": "TDMS-H0353", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 126, "actual_start": "2026-08-23T13:20:00", "actual_end": "2026-08-23T15:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0354', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'High',
    0, 4, 'CB Timing Analyzer',
    165, 184, '2026-08-23T17:45:00', '2026-08-23T20:49:00',
    'Completed', '{"job_id": "TDMS-H0354", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 184, "actual_start": "2026-08-23T17:45:00", "actual_end": "2026-08-23T20:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0355', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'High',
    5, 5, 'CB Timing Analyzer',
    150, 149, '2026-08-29T17:25:00', '2026-08-29T19:54:00',
    'Completed', '{"job_id": "TDMS-H0355", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "High", "overdue_days": 5, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 149, "actual_start": "2026-08-29T17:25:00", "actual_end": "2026-08-29T19:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0356', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'High',
    3, 5, 'CB Timing Analyzer',
    165, 167, '2026-08-30T04:10:00', '2026-08-30T06:57:00',
    'Completed', '{"job_id": "TDMS-H0356", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 167, "actual_start": "2026-08-30T04:10:00", "actual_end": "2026-08-30T06:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0357', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    1, 8, 'Oil Filtration Plant',
    195, 186, '2026-08-30T11:35:00', '2026-08-30T14:41:00',
    'Completed', '{"job_id": "TDMS-H0357", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 186, "actual_start": "2026-08-30T11:35:00", "actual_end": "2026-08-30T14:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0358', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'High',
    2, 5, 'Earth Tester & Bonding Kit',
    90, 87, '2026-09-01T13:45:00', '2026-09-01T15:12:00',
    'Completed', '{"job_id": "TDMS-H0358", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-09-01T13:45:00", "actual_end": "2026-09-01T15:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0359', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    2, 4, 'Tower Wagon',
    105, 123, '2026-09-01T13:50:00', '2026-09-01T15:53:00',
    'Completed', '{"job_id": "TDMS-H0359", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 123, "actual_start": "2026-09-01T13:50:00", "actual_end": "2026-09-01T15:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0360', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Medium',
    3, 6, 'CB Timing Analyzer',
    165, 181, '2026-09-03T11:00:00', '2026-09-03T14:01:00',
    'Completed', '{"job_id": "TDMS-H0360", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Medium", "overdue_days": 3, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 181, "actual_start": "2026-09-03T11:00:00", "actual_end": "2026-09-03T14:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0361', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_DN_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 8, 'Tower Wagon',
    135, 126, '2026-09-04T03:55:00', '2026-09-04T06:01:00',
    'Completed', '{"job_id": "TDMS-H0361", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_DN_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 126, "actual_start": "2026-09-04T03:55:00", "actual_end": "2026-09-04T06:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0362', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'BDC-HYG', 'Bandel – Hooghly Ghat', 'BDC-HYG', 'Bandel - Hooghly Ghat', 'BRIDGE_UP_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'High',
    0, 9, 'Tower Wagon',
    120, 124, '2026-09-06T17:50:00', '2026-09-06T19:54:00',
    'Completed', '{"job_id": "TDMS-H0362", "division": "HWH", "section": "BDC-HYG", "block_section": "BDC-HYG", "line": "BRIDGE_UP_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 124, "actual_start": "2026-09-06T17:50:00", "actual_end": "2026-09-06T19:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0363', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    90, 86, '2026-07-02T00:45:00', '2026-07-02T02:11:00',
    'Completed', '{"job_id": "TDMS-H0363", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 86, "actual_start": "2026-07-02T00:45:00", "actual_end": "2026-07-02T02:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0364', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    60, 81, '2026-07-04T12:30:00', '2026-07-04T13:51:00',
    'Completed', '{"job_id": "TDMS-H0364", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 81, "actual_start": "2026-07-04T12:30:00", "actual_end": "2026-07-04T13:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0365', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'MGAE-NHT', 'Morgram - Nalhati', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    2, 5, 'Tower Wagon',
    150, 147, '2026-07-05T13:55:00', '2026-07-05T16:22:00',
    'Completed', '{"job_id": "TDMS-H0365", "division": "HWH", "section": "AZ-NHT", "block_section": "MGAE-NHT", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 147, "actual_start": "2026-07-05T13:55:00", "actual_end": "2026-07-05T16:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0366', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    3, 5, 'Tower Wagon',
    150, 148, '2026-07-07T17:50:00', '2026-07-07T20:18:00',
    'Completed', '{"job_id": "TDMS-H0366", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 148, "actual_start": "2026-07-07T17:50:00", "actual_end": "2026-07-07T20:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0367', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'MGAE-NHT', 'Morgram - Nalhati', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Critical', 'Critical',
    1, 6, 'Ladder & Tension Meter',
    90, 104, '2026-07-11T01:40:00', '2026-07-11T03:24:00',
    'Completed', '{"job_id": "TDMS-H0367", "division": "HWH", "section": "AZ-NHT", "block_section": "MGAE-NHT", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 104, "actual_start": "2026-07-11T01:40:00", "actual_end": "2026-07-11T03:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0368', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    0, 5, 'Inspection Vehicle',
    60, 69, '2026-07-22T11:35:00', '2026-07-22T12:44:00',
    'Completed', '{"job_id": "TDMS-H0368", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 69, "actual_start": "2026-07-22T11:35:00", "actual_end": "2026-07-22T12:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0369', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Critical',
    0, 3, 'Secondary Injection Test Set',
    90, 94, '2026-07-25T01:35:00', '2026-07-25T03:09:00',
    'Completed', '{"job_id": "TDMS-H0369", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-07-25T01:35:00", "actual_end": "2026-07-25T03:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0370', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    1, 5, 'SF6 Gas Filling Kit',
    105, 102, '2026-07-25T16:45:00', '2026-07-25T18:27:00',
    'Completed', '{"job_id": "TDMS-H0370", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 102, "actual_start": "2026-07-25T16:45:00", "actual_end": "2026-07-25T18:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0371', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    3, 7, 'Tower Wagon',
    135, 150, '2026-07-28T02:05:00', '2026-07-28T04:35:00',
    'Completed', '{"job_id": "TDMS-H0371", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 150, "actual_start": "2026-07-28T02:05:00", "actual_end": "2026-07-28T04:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0372', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    0, 5, 'Tower Wagon',
    75, 68, '2026-07-28T15:50:00', '2026-07-28T16:58:00',
    'Completed', '{"job_id": "TDMS-H0372", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-07-28T15:50:00", "actual_end": "2026-07-28T16:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0373', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    1, 4, 'Secondary Injection Test Set',
    120, 129, '2026-07-30T11:20:00', '2026-07-30T13:29:00',
    'Completed', '{"job_id": "TDMS-H0373", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 129, "actual_start": "2026-07-30T11:20:00", "actual_end": "2026-07-30T13:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0374', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'MGAE-NHT', 'Morgram - Nalhati', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'High',
    2, 5, 'CB Timing Analyzer',
    135, 144, '2026-07-31T00:50:00', '2026-07-31T03:14:00',
    'Completed', '{"job_id": "TDMS-H0374", "division": "HWH", "section": "AZ-NHT", "block_section": "MGAE-NHT", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-07-31T00:50:00", "actual_end": "2026-07-31T03:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0375', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'High',
    1, 4, 'RTU Diagnostic Terminal',
    90, 88, '2026-08-01T15:50:00', '2026-08-01T17:18:00',
    'Completed', '{"job_id": "TDMS-H0375", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 90, "actual_duration_min": 88, "actual_start": "2026-08-01T15:50:00", "actual_end": "2026-08-01T17:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0376', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    2, 6, 'Tower Wagon',
    105, 109, '2026-08-03T03:50:00', '2026-08-03T05:39:00',
    'Completed', '{"job_id": "TDMS-H0376", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-08-03T03:50:00", "actual_end": "2026-08-03T05:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0377', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    75, 80, '2026-08-04T01:45:00', '2026-08-04T03:05:00',
    'Completed', '{"job_id": "TDMS-H0377", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 80, "actual_start": "2026-08-04T01:45:00", "actual_end": "2026-08-04T03:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0378', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    2, 5, 'CB Timing Analyzer',
    165, 165, '2026-08-06T03:45:00', '2026-08-06T06:30:00',
    'Completed', '{"job_id": "TDMS-H0378", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 165, "actual_start": "2026-08-06T03:45:00", "actual_end": "2026-08-06T06:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0379', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    2, 7, 'Tower Wagon',
    165, 166, '2026-08-06T15:35:00', '2026-08-06T18:21:00',
    'Completed', '{"job_id": "TDMS-H0379", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 166, "actual_start": "2026-08-06T15:35:00", "actual_end": "2026-08-06T18:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0380', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Medium',
    0, 6, 'Tower Wagon',
    135, 157, '2026-08-15T11:15:00', '2026-08-15T13:52:00',
    'Completed', '{"job_id": "TDMS-H0380", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 157, "actual_start": "2026-08-15T11:15:00", "actual_end": "2026-08-15T13:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0381', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'High', 'Medium',
    0, 4, 'Inspection Vehicle',
    90, 94, '2026-08-17T15:20:00', '2026-08-17T16:54:00',
    'Completed', '{"job_id": "TDMS-H0381", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-08-17T15:20:00", "actual_end": "2026-08-17T16:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0382', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    2, 8, 'Oil Filtration Plant',
    210, 208, '2026-08-17T17:20:00', '2026-08-17T20:48:00',
    'Completed', '{"job_id": "TDMS-H0382", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 208, "actual_start": "2026-08-17T17:20:00", "actual_end": "2026-08-17T20:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0383', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Low', 'High',
    0, 6, 'Tower Wagon',
    120, 123, '2026-08-18T12:05:00', '2026-08-18T14:08:00',
    'Completed', '{"job_id": "TDMS-H0383", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 123, "actual_start": "2026-08-18T12:05:00", "actual_end": "2026-08-18T14:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0384', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'SDI-MGAE', 'Sagardighi - Morgram', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    6, 7, 'Tower Wagon',
    150, 144, '2026-08-26T15:20:00', '2026-08-26T17:44:00',
    'Completed', '{"job_id": "TDMS-H0384", "division": "HWH", "section": "AZ-NHT", "block_section": "SDI-MGAE", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 6, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 144, "actual_start": "2026-08-26T15:20:00", "actual_end": "2026-08-26T17:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0385', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    2, 7, 'Tower Wagon',
    105, 111, '2026-08-27T17:20:00', '2026-08-27T19:11:00',
    'Completed', '{"job_id": "TDMS-H0385", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-08-27T17:20:00", "actual_end": "2026-08-27T19:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0386', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    3, 6, 'Tower Wagon',
    120, 118, '2026-08-29T11:40:00', '2026-08-29T13:38:00',
    'Completed', '{"job_id": "TDMS-H0386", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 118, "actual_start": "2026-08-29T11:40:00", "actual_end": "2026-08-29T13:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0387', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    3, 6, 'Tower Wagon',
    150, 168, '2026-08-29T15:25:00', '2026-08-29T18:13:00',
    'Completed', '{"job_id": "TDMS-H0387", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 168, "actual_start": "2026-08-29T15:25:00", "actual_end": "2026-08-29T18:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0388', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'MGAE-NHT', 'Morgram - Nalhati', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'Critical',
    1, 6, 'SF6 Gas Filling Kit',
    90, 94, '2026-08-29T15:35:00', '2026-08-29T17:09:00',
    'Completed', '{"job_id": "TDMS-H0388", "division": "HWH", "section": "AZ-NHT", "block_section": "MGAE-NHT", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-08-29T15:35:00", "actual_end": "2026-08-29T17:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0389', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'EASTERN RAILWAY', 'ER', 'HWH', 'Howrah',
    'AZ-NHT', 'Azimganj – Nalhati', 'AZ-SDI', 'Azimganj - Sagardighi', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    135, 138, '2026-09-02T00:50:00', '2026-09-02T03:08:00',
    'Completed', '{"job_id": "TDMS-H0389", "division": "HWH", "section": "AZ-NHT", "block_section": "AZ-SDI", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 138, "actual_start": "2026-09-02T00:50:00", "actual_end": "2026-09-02T03:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0390', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'DN_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    4, 5, 'Tower Wagon',
    60, 66, '2026-07-04T12:35:00', '2026-07-04T13:41:00',
    'Completed', '{"job_id": "TDMS-H0390", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "DN_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 66, "actual_start": "2026-07-04T12:35:00", "actual_end": "2026-07-04T13:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0391', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'KNN-DOA', 'Khanna - Doraha', 'DN_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'High',
    2, 6, 'CB Timing Analyzer',
    165, 160, '2026-07-12T15:50:00', '2026-07-12T18:30:00',
    'Completed', '{"job_id": "TDMS-H0391", "division": "UMB", "section": "UMB-LDH", "block_section": "KNN-DOA", "line": "DN_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 160, "actual_start": "2026-07-12T15:50:00", "actual_end": "2026-07-12T18:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0392', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    1, 4, 'Earth Tester & Bonding Kit',
    90, 86, '2026-07-13T01:35:00', '2026-07-13T03:01:00',
    'Completed', '{"job_id": "TDMS-H0392", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 86, "actual_start": "2026-07-13T01:35:00", "actual_end": "2026-07-13T03:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0393', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    2, 4, 'Inspection Vehicle',
    45, 53, '2026-07-14T01:25:00', '2026-07-14T02:18:00',
    'Completed', '{"job_id": "TDMS-H0393", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 53, "actual_start": "2026-07-14T01:25:00", "actual_end": "2026-07-14T02:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0394', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    120, 123, '2026-07-15T03:15:00', '2026-07-15T05:18:00',
    'Completed', '{"job_id": "TDMS-H0394", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 123, "actual_start": "2026-07-15T03:15:00", "actual_end": "2026-07-15T05:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0395', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'DN_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'Critical',
    0, 5, 'Tower Wagon',
    105, 103, '2026-07-15T14:45:00', '2026-07-15T16:28:00',
    'Completed', '{"job_id": "TDMS-H0395", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "DN_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-07-15T14:45:00", "actual_end": "2026-07-15T16:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0396', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    1, 4, 'Tower Wagon',
    120, 118, '2026-07-15T17:45:00', '2026-07-15T19:43:00',
    'Completed', '{"job_id": "TDMS-H0396", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 118, "actual_start": "2026-07-15T17:45:00", "actual_end": "2026-07-15T19:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0397', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    1, 3, 'Earth Tester & Bonding Kit',
    75, 79, '2026-07-16T12:05:00', '2026-07-16T13:24:00',
    'Completed', '{"job_id": "TDMS-H0397", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 79, "actual_start": "2026-07-16T12:05:00", "actual_end": "2026-07-16T13:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0398', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    0, 4, 'Tower Wagon',
    75, 97, '2026-07-23T01:35:00', '2026-07-23T03:12:00',
    'Completed', '{"job_id": "TDMS-H0398", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 97, "actual_start": "2026-07-23T01:35:00", "actual_end": "2026-07-23T03:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0399', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    7, 6, 'Tower Wagon',
    105, 106, '2026-07-28T14:55:00', '2026-07-28T16:41:00',
    'Completed', '{"job_id": "TDMS-H0399", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 7, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-07-28T14:55:00", "actual_end": "2026-07-28T16:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0400', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'DN_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    3, 4, 'SF6 Gas Filling Kit',
    120, 140, '2026-08-01T03:25:00', '2026-08-01T05:45:00',
    'Completed', '{"job_id": "TDMS-H0400", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "DN_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 140, "actual_start": "2026-08-01T03:25:00", "actual_end": "2026-08-01T05:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0401', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'UP_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    135, 133, '2026-08-02T12:40:00', '2026-08-02T14:53:00',
    'Completed', '{"job_id": "TDMS-H0401", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "UP_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 133, "actual_start": "2026-08-02T12:40:00", "actual_end": "2026-08-02T14:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0402', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 4, 'Ladder & Tension Meter',
    105, 103, '2026-08-04T03:25:00', '2026-08-04T05:08:00',
    'Completed', '{"job_id": "TDMS-H0402", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-08-04T03:25:00", "actual_end": "2026-08-04T05:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0403', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Low', 'Medium',
    1, 5, 'Tower Wagon',
    90, 103, '2026-08-04T11:55:00', '2026-08-04T13:38:00',
    'Completed', '{"job_id": "TDMS-H0403", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 103, "actual_start": "2026-08-04T11:55:00", "actual_end": "2026-08-04T13:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0404', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    6, 7, 'Tower Wagon',
    180, 198, '2026-08-05T14:55:00', '2026-08-05T18:13:00',
    'Completed', '{"job_id": "TDMS-H0404", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 6, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 198, "actual_start": "2026-08-05T14:55:00", "actual_end": "2026-08-05T18:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0405', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Low', 'High',
    0, 6, 'Tower Wagon',
    120, 138, '2026-08-07T13:10:00', '2026-08-07T15:28:00',
    'Completed', '{"job_id": "TDMS-H0405", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 138, "actual_start": "2026-08-07T13:10:00", "actual_end": "2026-08-07T15:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0406', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'KNN-DOA', 'Khanna - Doraha', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 4, 'Ladder & Tension Meter',
    105, 114, '2026-08-12T04:00:00', '2026-08-12T05:54:00',
    'Completed', '{"job_id": "TDMS-H0406", "division": "UMB", "section": "UMB-LDH", "block_section": "KNN-DOA", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 114, "actual_start": "2026-08-12T04:00:00", "actual_end": "2026-08-12T05:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0407', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'High',
    3, 5, 'CB Timing Analyzer',
    150, 146, '2026-08-13T12:55:00', '2026-08-13T15:21:00',
    'Completed', '{"job_id": "TDMS-H0407", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 146, "actual_start": "2026-08-13T12:55:00", "actual_end": "2026-08-13T15:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0408', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    2, 4, 'SF6 Gas Filling Kit',
    105, 104, '2026-08-19T11:15:00', '2026-08-19T12:59:00',
    'Completed', '{"job_id": "TDMS-H0408", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 104, "actual_start": "2026-08-19T11:15:00", "actual_end": "2026-08-19T12:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0409', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    90, 103, '2026-08-19T16:05:00', '2026-08-19T17:48:00',
    'Completed', '{"job_id": "TDMS-H0409", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 103, "actual_start": "2026-08-19T16:05:00", "actual_end": "2026-08-19T17:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0410', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'KNN-DOA', 'Khanna - Doraha', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    1, 5, 'Earth Tester & Bonding Kit',
    60, 60, '2026-08-21T17:15:00', '2026-08-21T18:15:00',
    'Completed', '{"job_id": "TDMS-H0410", "division": "UMB", "section": "UMB-LDH", "block_section": "KNN-DOA", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 60, "actual_start": "2026-08-21T17:15:00", "actual_end": "2026-08-21T18:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0411', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'UMB-RPJ', 'Ambala Cantt - Rajpura', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    2, 4, 'Tower Wagon',
    120, 138, '2026-08-25T12:25:00', '2026-08-25T14:43:00',
    'Completed', '{"job_id": "TDMS-H0411", "division": "UMB", "section": "UMB-LDH", "block_section": "UMB-RPJ", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 138, "actual_start": "2026-08-25T12:25:00", "actual_end": "2026-08-25T14:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0412', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'RPJ-SIR', 'Rajpura - Sirhind', 'DN_MAIN',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    4, 7, 'Tower Wagon',
    120, 135, '2026-08-25T14:00:00', '2026-08-25T16:15:00',
    'Completed', '{"job_id": "TDMS-H0412", "division": "UMB", "section": "UMB-LDH", "block_section": "RPJ-SIR", "line": "DN_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 135, "actual_start": "2026-08-25T14:00:00", "actual_end": "2026-08-25T16:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0413', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'KNN-DOA', 'Khanna - Doraha', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 5, 'Earth Tester & Bonding Kit',
    90, 81, '2026-08-29T16:15:00', '2026-08-29T17:36:00',
    'Completed', '{"job_id": "TDMS-H0413", "division": "UMB", "section": "UMB-LDH", "block_section": "KNN-DOA", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 81, "actual_start": "2026-08-29T16:15:00", "actual_end": "2026-08-29T17:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0414', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'DOA-LDH', 'Doraha - Ludhiana', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    6, 5, 'Ladder & Tension Meter',
    90, 106, '2026-08-31T11:50:00', '2026-08-31T13:36:00',
    'Completed', '{"job_id": "TDMS-H0414", "division": "UMB", "section": "UMB-LDH", "block_section": "DOA-LDH", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 6, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-08-31T11:50:00", "actual_end": "2026-08-31T13:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0415', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-LDH', 'UMB–LDH (Ambala Cantt–Ludhiana)', 'SIR-KNN', 'Sirhind - Khanna', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Critical',
    2, 7, 'Tower Wagon',
    120, 111, '2026-09-07T15:05:00', '2026-09-07T16:56:00',
    'Completed', '{"job_id": "TDMS-H0415", "division": "UMB", "section": "UMB-LDH", "block_section": "SIR-KNN", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 111, "actual_start": "2026-09-07T15:05:00", "actual_end": "2026-09-07T16:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0416', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Critical',
    7, 4, 'Secondary Injection Test Set',
    90, 101, '2026-07-01T11:00:00', '2026-07-01T12:41:00',
    'Completed', '{"job_id": "TDMS-H0416", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Critical", "overdue_days": 7, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 101, "actual_start": "2026-07-01T11:00:00", "actual_end": "2026-07-01T12:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0417', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'LDH-MLX', 'Ludhiana - Mullanpur', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Medium',
    2, 7, 'Tower Wagon',
    105, 106, '2026-07-01T11:45:00', '2026-07-01T13:31:00',
    'Completed', '{"job_id": "TDMS-H0417", "division": "UMB", "section": "LDH-BTI", "block_section": "LDH-MLX", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-07-01T11:45:00", "actual_end": "2026-07-01T13:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0418', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    105, 109, '2026-07-03T16:35:00', '2026-07-03T18:24:00',
    'Completed', '{"job_id": "TDMS-H0418", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-07-03T16:35:00", "actual_end": "2026-07-03T18:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0419', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    1, 5, 'Tower Wagon',
    135, 129, '2026-07-06T01:45:00', '2026-07-06T03:54:00',
    'Completed', '{"job_id": "TDMS-H0419", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 129, "actual_start": "2026-07-06T01:45:00", "actual_end": "2026-07-06T03:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0420', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'JGN-MOG', 'Jagraon - Moga', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Medium',
    0, 5, 'Tower Wagon',
    135, 151, '2026-07-11T14:40:00', '2026-07-11T17:11:00',
    'Completed', '{"job_id": "TDMS-H0420", "division": "UMB", "section": "LDH-BTI", "block_section": "JGN-MOG", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 151, "actual_start": "2026-07-11T14:40:00", "actual_end": "2026-07-11T17:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0421', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    2, 4, 'CB Timing Analyzer',
    120, 115, '2026-07-23T04:55:00', '2026-07-23T06:50:00',
    'Completed', '{"job_id": "TDMS-H0421", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 115, "actual_start": "2026-07-23T04:55:00", "actual_end": "2026-07-23T06:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0422', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    0, 5, 'Tower Wagon',
    135, 146, '2026-07-25T01:10:00', '2026-07-25T03:36:00',
    'Completed', '{"job_id": "TDMS-H0422", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 146, "actual_start": "2026-07-25T01:10:00", "actual_end": "2026-07-25T03:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0423', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    2, 5, 'Ladder & Contact Burnisher',
    90, 82, '2026-07-26T17:15:00', '2026-07-26T18:37:00',
    'Completed', '{"job_id": "TDMS-H0423", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 82, "actual_start": "2026-07-26T17:15:00", "actual_end": "2026-07-26T18:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0424', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    3, 5, 'CB Timing Analyzer',
    135, 144, '2026-07-29T04:50:00', '2026-07-29T07:14:00',
    'Completed', '{"job_id": "TDMS-H0424", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-07-29T04:50:00", "actual_end": "2026-07-29T07:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0425', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'JGN-MOG', 'Jagraon - Moga', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    120, 131, '2026-07-31T11:40:00', '2026-07-31T13:51:00',
    'Completed', '{"job_id": "TDMS-H0425", "division": "UMB", "section": "LDH-BTI", "block_section": "JGN-MOG", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 131, "actual_start": "2026-07-31T11:40:00", "actual_end": "2026-07-31T13:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0426', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'JGN-MOG', 'Jagraon - Moga', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Critical',
    2, 3, 'Secondary Injection Test Set',
    105, 109, '2026-08-02T14:20:00', '2026-08-02T16:09:00',
    'Completed', '{"job_id": "TDMS-H0426", "division": "UMB", "section": "LDH-BTI", "block_section": "JGN-MOG", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-08-02T14:20:00", "actual_end": "2026-08-02T16:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0427', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'High', 'Low',
    1, 4, 'Inspection Vehicle',
    45, 53, '2026-08-03T11:50:00', '2026-08-03T12:43:00',
    'Completed', '{"job_id": "TDMS-H0427", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "High", "criticality": "Low", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 53, "actual_start": "2026-08-03T11:50:00", "actual_end": "2026-08-03T12:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0428', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    3, 6, 'Oil Filtration Plant',
    195, 207, '2026-08-07T04:05:00', '2026-08-07T07:32:00',
    'Completed', '{"job_id": "TDMS-H0428", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 207, "actual_start": "2026-08-07T04:05:00", "actual_end": "2026-08-07T07:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0429', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 7, 'Tower Wagon',
    135, 154, '2026-08-09T00:05:00', '2026-08-09T02:39:00',
    'Completed', '{"job_id": "TDMS-H0429", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 154, "actual_start": "2026-08-09T00:05:00", "actual_end": "2026-08-09T02:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0430', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'High', 'Medium',
    0, 5, 'Tower Wagon',
    120, 126, '2026-08-09T01:05:00', '2026-08-09T03:11:00',
    'Completed', '{"job_id": "TDMS-H0430", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 126, "actual_start": "2026-08-09T01:05:00", "actual_end": "2026-08-09T03:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0431', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    2, 5, 'Inspection Vehicle',
    90, 83, '2026-08-15T11:40:00', '2026-08-15T13:03:00',
    'Completed', '{"job_id": "TDMS-H0431", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-08-15T11:40:00", "actual_end": "2026-08-15T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0432', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'High',
    3, 4, 'RTU Diagnostic Terminal',
    60, 70, '2026-08-17T16:30:00', '2026-08-17T17:40:00',
    'Completed', '{"job_id": "TDMS-H0432", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 70, "actual_start": "2026-08-17T16:30:00", "actual_end": "2026-08-17T17:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0433', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MLX-JGN', 'Mullanpur - Jagraon', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    5, 9, 'Tower Wagon',
    105, 103, '2026-08-26T16:55:00', '2026-08-26T18:38:00',
    'Completed', '{"job_id": "TDMS-H0433", "division": "UMB", "section": "LDH-BTI", "block_section": "MLX-JGN", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 103, "actual_start": "2026-08-26T16:55:00", "actual_end": "2026-08-26T18:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0434', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'LDH-MLX', 'Ludhiana - Mullanpur', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'High', 'Low',
    1, 4, 'Inspection Vehicle',
    60, 55, '2026-08-31T12:00:00', '2026-08-31T12:55:00',
    'Completed', '{"job_id": "TDMS-H0434", "division": "UMB", "section": "LDH-BTI", "block_section": "LDH-MLX", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "High", "criticality": "Low", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-08-31T12:00:00", "actual_end": "2026-08-31T12:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0435', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MLX-JGN', 'Mullanpur - Jagraon', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    2, 3, 'Secondary Injection Test Set',
    75, 73, '2026-09-02T11:10:00', '2026-09-02T12:23:00',
    'Completed', '{"job_id": "TDMS-H0435", "division": "UMB", "section": "LDH-BTI", "block_section": "MLX-JGN", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 75, "actual_duration_min": 73, "actual_start": "2026-09-02T11:10:00", "actual_end": "2026-09-02T12:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0436', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    3, 4, 'Tower Wagon',
    90, 99, '2026-09-02T16:20:00', '2026-09-02T17:59:00',
    'Completed', '{"job_id": "TDMS-H0436", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 99, "actual_start": "2026-09-02T16:20:00", "actual_end": "2026-09-02T17:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0437', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MOG-KKP', 'Moga - Kotkapura', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    3, 4, 'Earth Tester & Bonding Kit',
    75, 75, '2026-09-05T03:55:00', '2026-09-05T05:10:00',
    'Completed', '{"job_id": "TDMS-H0437", "division": "UMB", "section": "LDH-BTI", "block_section": "MOG-KKP", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 75, "actual_start": "2026-09-05T03:55:00", "actual_end": "2026-09-05T05:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0438', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'KKP-BTI', 'Kotkapura - Bathinda', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    90, 93, '2026-09-07T00:20:00', '2026-09-07T01:53:00',
    'Completed', '{"job_id": "TDMS-H0438", "division": "UMB", "section": "LDH-BTI", "block_section": "KKP-BTI", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-09-07T00:20:00", "actual_end": "2026-09-07T01:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0439', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'LDH-BTI', 'LDH–BTI (Ludhiana–Bathinda)', 'MLX-JGN', 'Mullanpur - Jagraon', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    0, 5, 'SF6 Gas Filling Kit',
    90, 94, '2026-09-08T02:30:00', '2026-09-08T04:04:00',
    'Completed', '{"job_id": "TDMS-H0439", "division": "UMB", "section": "LDH-BTI", "block_section": "MLX-JGN", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-09-08T02:30:00", "actual_end": "2026-09-08T04:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0440', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'UP_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    1, 5, 'Inspection Vehicle',
    90, 93, '2026-07-01T16:55:00', '2026-07-01T18:28:00',
    'Completed', '{"job_id": "TDMS-H0440", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "UP_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-07-01T16:55:00", "actual_end": "2026-07-01T18:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0441', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'High',
    1, 7, 'Tower Wagon',
    120, 126, '2026-07-03T16:25:00', '2026-07-03T18:31:00',
    'Completed', '{"job_id": "TDMS-H0441", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 126, "actual_start": "2026-07-03T16:25:00", "actual_end": "2026-07-03T18:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0442', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'High',
    1, 5, 'Earth Tester & Bonding Kit',
    45, 44, '2026-07-05T01:35:00', '2026-07-05T02:19:00',
    'Completed', '{"job_id": "TDMS-H0442", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 44, "actual_start": "2026-07-05T01:35:00", "actual_end": "2026-07-05T02:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0443', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    0, 7, 'Tower Wagon',
    120, 128, '2026-07-07T00:40:00', '2026-07-07T02:48:00',
    'Completed', '{"job_id": "TDMS-H0443", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 128, "actual_start": "2026-07-07T00:40:00", "actual_end": "2026-07-07T02:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0444', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CDG-CNDM', 'Chandigarh - Chandi Mandir', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Critical',
    0, 4, 'Tower Wagon',
    90, 91, '2026-07-10T04:25:00', '2026-07-10T05:56:00',
    'Completed', '{"job_id": "TDMS-H0444", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CDG-CNDM", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 91, "actual_start": "2026-07-10T04:25:00", "actual_end": "2026-07-10T05:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0445', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'Critical',
    4, 6, 'Tower Wagon',
    135, 127, '2026-07-12T14:35:00', '2026-07-12T16:42:00',
    'Completed', '{"job_id": "TDMS-H0445", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 127, "actual_start": "2026-07-12T14:35:00", "actual_end": "2026-07-12T16:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0446', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'DN_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    4, 4, 'CB Timing Analyzer',
    150, 164, '2026-07-13T14:50:00', '2026-07-13T17:34:00',
    'Completed', '{"job_id": "TDMS-H0446", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "DN_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 164, "actual_start": "2026-07-13T14:50:00", "actual_end": "2026-07-13T17:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0447', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    1, 8, 'Tower Wagon',
    105, 112, '2026-07-15T17:05:00', '2026-07-15T18:57:00',
    'Completed', '{"job_id": "TDMS-H0447", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 112, "actual_start": "2026-07-15T17:05:00", "actual_end": "2026-07-15T18:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0448', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CDG-CNDM', 'Chandigarh - Chandi Mandir', 'DN_MAIN',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'High',
    0, 8, 'Tower Wagon',
    135, 144, '2026-07-19T15:30:00', '2026-07-19T17:54:00',
    'Completed', '{"job_id": "TDMS-H0448", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CDG-CNDM", "line": "DN_MAIN", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-07-19T15:30:00", "actual_end": "2026-07-19T17:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0449', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CDG-CNDM', 'Chandigarh - Chandi Mandir', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    45, 53, '2026-07-20T02:15:00', '2026-07-20T03:08:00',
    'Completed', '{"job_id": "TDMS-H0449", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CDG-CNDM", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 53, "actual_start": "2026-07-20T02:15:00", "actual_end": "2026-07-20T03:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0450', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'UP_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    3, 7, 'Tower Wagon',
    105, 123, '2026-07-20T11:10:00', '2026-07-20T13:13:00',
    'Completed', '{"job_id": "TDMS-H0450", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "UP_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 123, "actual_start": "2026-07-20T11:10:00", "actual_end": "2026-07-20T13:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0451', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 5, 'Earth Tester & Bonding Kit',
    45, 44, '2026-07-20T16:00:00', '2026-07-20T16:44:00',
    'Completed', '{"job_id": "TDMS-H0451", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 44, "actual_start": "2026-07-20T16:00:00", "actual_end": "2026-07-20T16:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0452', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    45, 59, '2026-07-30T04:15:00', '2026-07-30T05:14:00',
    'Completed', '{"job_id": "TDMS-H0452", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 59, "actual_start": "2026-07-30T04:15:00", "actual_end": "2026-07-30T05:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0453', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Medium',
    1, 3, 'Secondary Injection Test Set',
    75, 75, '2026-08-05T12:05:00', '2026-08-05T13:20:00',
    'Completed', '{"job_id": "TDMS-H0453", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 75, "actual_duration_min": 75, "actual_start": "2026-08-05T12:05:00", "actual_end": "2026-08-05T13:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0454', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CDG-CNDM', 'Chandigarh - Chandi Mandir', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    2, 4, 'Inspection Vehicle',
    60, 55, '2026-08-08T03:55:00', '2026-08-08T04:50:00',
    'Completed', '{"job_id": "TDMS-H0454", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CDG-CNDM", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-08-08T03:55:00", "actual_end": "2026-08-08T04:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0455', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    165, 184, '2026-08-08T12:45:00', '2026-08-08T15:49:00',
    'Completed', '{"job_id": "TDMS-H0455", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 184, "actual_start": "2026-08-08T12:45:00", "actual_end": "2026-08-08T15:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0456', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'High', 'High',
    0, 5, 'Earth Tester & Bonding Kit',
    90, 89, '2026-08-09T12:55:00', '2026-08-09T14:24:00',
    'Completed', '{"job_id": "TDMS-H0456", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 89, "actual_start": "2026-08-09T12:55:00", "actual_end": "2026-08-09T14:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0457', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    5, 6, 'Tower Wagon',
    180, 178, '2026-08-12T03:35:00', '2026-08-12T06:33:00',
    'Completed', '{"job_id": "TDMS-H0457", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 5, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 178, "actual_start": "2026-08-12T03:35:00", "actual_end": "2026-08-12T06:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0458', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    6, 7, 'Tower Wagon',
    180, 179, '2026-08-13T16:15:00', '2026-08-13T19:14:00',
    'Completed', '{"job_id": "TDMS-H0458", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 6, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 179, "actual_start": "2026-08-13T16:15:00", "actual_end": "2026-08-13T19:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0459', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    4, 5, 'Tower Wagon',
    135, 125, '2026-08-20T04:25:00', '2026-08-20T06:30:00',
    'Completed', '{"job_id": "TDMS-H0459", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 125, "actual_start": "2026-08-20T04:25:00", "actual_end": "2026-08-20T06:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0460', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    1, 6, 'Tower Wagon',
    75, 81, '2026-08-25T04:10:00', '2026-08-25T05:31:00',
    'Completed', '{"job_id": "TDMS-H0460", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 81, "actual_start": "2026-08-25T04:10:00", "actual_end": "2026-08-25T05:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0461', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'CNDM-KLK', 'Chandi Mandir - Kalka', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    4, 6, 'Tower Wagon',
    105, 109, '2026-08-25T13:30:00', '2026-08-25T15:19:00',
    'Completed', '{"job_id": "TDMS-H0461", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "CNDM-KLK", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-08-25T13:30:00", "actual_end": "2026-08-25T15:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0462', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    0, 5, 'Earth Tester & Bonding Kit',
    45, 48, '2026-08-30T11:50:00', '2026-08-30T12:38:00',
    'Completed', '{"job_id": "TDMS-H0462", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 48, "actual_start": "2026-08-30T11:50:00", "actual_end": "2026-08-30T12:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0463', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'LLU-CDG', 'Lalru - Chandigarh', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Low',
    2, 3, 'Inspection Vehicle',
    45, 40, '2026-09-04T17:10:00', '2026-09-04T17:50:00',
    'Completed', '{"job_id": "TDMS-H0463", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "LLU-CDG", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Low", "overdue_days": 2, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-09-04T17:10:00", "actual_end": "2026-09-04T17:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0464', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-CDG-KLK', 'UMB–CDG–KLK (Ambala–Chandigarh–Kalka)', 'UMB-LLU', 'Ambala Cantt - Lalru', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    1, 3, 'Secondary Injection Test Set',
    90, 86, '2026-09-07T17:35:00', '2026-09-07T19:01:00',
    'Completed', '{"job_id": "TDMS-H0464", "division": "UMB", "section": "UMB-CDG-KLK", "block_section": "UMB-LLU", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 86, "actual_start": "2026-09-07T17:35:00", "actual_end": "2026-09-07T19:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0465', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'YARD_ELECTRICAL_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    4, 6, 'Tower Wagon',
    120, 112, '2026-07-03T13:40:00', '2026-07-03T15:32:00',
    'Completed', '{"job_id": "TDMS-H0465", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "YARD_ELECTRICAL_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 112, "actual_start": "2026-07-03T13:40:00", "actual_end": "2026-07-03T15:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0466', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'BOF-SOL', 'Barog - Solan', 'POWER_SUPPLY_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    105, 116, '2026-07-07T03:15:00', '2026-07-07T05:11:00',
    'Completed', '{"job_id": "TDMS-H0466", "division": "UMB", "section": "KLK-SML", "block_section": "BOF-SOL", "line": "POWER_SUPPLY_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 116, "actual_start": "2026-07-07T03:15:00", "actual_end": "2026-07-07T05:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0467', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'POWER_SUPPLY_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    135, 150, '2026-07-10T02:20:00', '2026-07-10T04:50:00',
    'Completed', '{"job_id": "TDMS-H0467", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "POWER_SUPPLY_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 150, "actual_start": "2026-07-10T02:20:00", "actual_end": "2026-07-10T04:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0468', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'POWER_SUPPLY_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'High', 'Medium',
    2, 4, 'Inspection Vehicle',
    45, 40, '2026-07-13T15:30:00', '2026-07-13T16:10:00',
    'Completed', '{"job_id": "TDMS-H0468", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "POWER_SUPPLY_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-07-13T15:30:00", "actual_end": "2026-07-13T16:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0469', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'SOL-KDGF', 'Solan - Kandaghat', 'YARD_ELECTRICAL_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    60, 52, '2026-07-14T14:00:00', '2026-07-14T14:52:00',
    'Completed', '{"job_id": "TDMS-H0469", "division": "UMB", "section": "KLK-SML", "block_section": "SOL-KDGF", "line": "YARD_ELECTRICAL_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 52, "actual_start": "2026-07-14T14:00:00", "actual_end": "2026-07-14T14:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0470', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'YARD_ELECTRICAL_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    4, 10, 'Tower Wagon',
    120, 138, '2026-07-15T14:35:00', '2026-07-15T16:53:00',
    'Completed', '{"job_id": "TDMS-H0470", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "YARD_ELECTRICAL_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 138, "actual_start": "2026-07-15T14:35:00", "actual_end": "2026-07-15T16:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0471', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'POWER_SUPPLY_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Medium',
    0, 7, 'Tower Wagon',
    90, 108, '2026-07-16T01:40:00', '2026-07-16T03:28:00',
    'Completed', '{"job_id": "TDMS-H0471", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "POWER_SUPPLY_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 108, "actual_start": "2026-07-16T01:40:00", "actual_end": "2026-07-16T03:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0472', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'HILL_TRANSMISSION_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    3, 7, 'Tower Wagon',
    105, 118, '2026-07-17T16:55:00', '2026-07-17T18:53:00',
    'Completed', '{"job_id": "TDMS-H0472", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "HILL_TRANSMISSION_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-07-17T16:55:00", "actual_end": "2026-07-17T18:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0473', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'YARD_ELECTRICAL_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    75, 82, '2026-07-19T16:35:00', '2026-07-19T17:57:00',
    'Completed', '{"job_id": "TDMS-H0473", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "YARD_ELECTRICAL_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 82, "actual_start": "2026-07-19T16:35:00", "actual_end": "2026-07-19T17:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0474', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'BOF-SOL', 'Barog - Solan', 'HILL_TRANSMISSION_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    2, 5, 'SF6 Gas Filling Kit',
    120, 121, '2026-07-25T04:55:00', '2026-07-25T06:56:00',
    'Completed', '{"job_id": "TDMS-H0474", "division": "UMB", "section": "KLK-SML", "block_section": "BOF-SOL", "line": "HILL_TRANSMISSION_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 121, "actual_start": "2026-07-25T04:55:00", "actual_end": "2026-07-25T06:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0475', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'YARD_ELECTRICAL_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    75, 87, '2026-07-28T02:20:00', '2026-07-28T03:47:00',
    'Completed', '{"job_id": "TDMS-H0475", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "YARD_ELECTRICAL_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 87, "actual_start": "2026-07-28T02:20:00", "actual_end": "2026-07-28T03:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0476', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'YARD_ELECTRICAL_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'Medium',
    1, 6, 'Ladder & Tension Meter',
    90, 91, '2026-07-31T04:50:00', '2026-07-31T06:21:00',
    'Completed', '{"job_id": "TDMS-H0476", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "YARD_ELECTRICAL_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 91, "actual_start": "2026-07-31T04:50:00", "actual_end": "2026-07-31T06:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0477', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'YARD_ELECTRICAL_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    0, 8, 'Tower Wagon',
    135, 141, '2026-08-15T12:50:00', '2026-08-15T15:11:00',
    'Completed', '{"job_id": "TDMS-H0477", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "YARD_ELECTRICAL_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 141, "actual_start": "2026-08-15T12:50:00", "actual_end": "2026-08-15T15:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0478', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'YARD_ELECTRICAL_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    2, 8, 'Tower Wagon',
    105, 95, '2026-08-16T01:55:00', '2026-08-16T03:30:00',
    'Completed', '{"job_id": "TDMS-H0478", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "YARD_ELECTRICAL_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 95, "actual_start": "2026-08-16T01:55:00", "actual_end": "2026-08-16T03:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0479', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'HILL_TRANSMISSION_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Medium',
    0, 3, 'Secondary Injection Test Set',
    105, 108, '2026-08-18T16:05:00', '2026-08-18T17:53:00',
    'Completed', '{"job_id": "TDMS-H0479", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "HILL_TRANSMISSION_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 108, "actual_start": "2026-08-18T16:05:00", "actual_end": "2026-08-18T17:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0480', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'HILL_TRANSMISSION_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    0, 5, 'Ladder & Contact Burnisher',
    60, 55, '2026-08-19T00:05:00', '2026-08-19T01:00:00',
    'Completed', '{"job_id": "TDMS-H0480", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "HILL_TRANSMISSION_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-08-19T00:05:00", "actual_end": "2026-08-19T01:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0481', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'POWER_SUPPLY_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Medium',
    0, 7, 'Tower Wagon',
    105, 102, '2026-08-20T14:00:00', '2026-08-20T15:42:00',
    'Completed', '{"job_id": "TDMS-H0481", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "POWER_SUPPLY_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 102, "actual_start": "2026-08-20T14:00:00", "actual_end": "2026-08-20T15:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0482', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KDGF-SML', 'Kandaghat - Shimla', 'YARD_ELECTRICAL_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'High',
    1, 5, 'CB Timing Analyzer',
    165, 180, '2026-08-24T17:20:00', '2026-08-24T20:20:00',
    'Completed', '{"job_id": "TDMS-H0482", "division": "UMB", "section": "KLK-SML", "block_section": "KDGF-SML", "line": "YARD_ELECTRICAL_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 180, "actual_start": "2026-08-24T17:20:00", "actual_end": "2026-08-24T20:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0483', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'KLK-DMP', 'Kalka - Dharampur Himachal', 'YARD_ELECTRICAL_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    3, 6, 'Tower Wagon',
    105, 115, '2026-08-26T12:40:00', '2026-08-26T14:35:00',
    'Completed', '{"job_id": "TDMS-H0483", "division": "UMB", "section": "KLK-SML", "block_section": "KLK-DMP", "line": "YARD_ELECTRICAL_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 115, "actual_start": "2026-08-26T12:40:00", "actual_end": "2026-08-26T14:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0484', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'SOL-KDGF', 'Solan - Kandaghat', 'POWER_SUPPLY_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Critical',
    0, 5, 'Ladder & Tension Meter',
    105, 123, '2026-08-28T17:20:00', '2026-08-28T19:23:00',
    'Completed', '{"job_id": "TDMS-H0484", "division": "UMB", "section": "KLK-SML", "block_section": "SOL-KDGF", "line": "POWER_SUPPLY_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 123, "actual_start": "2026-08-28T17:20:00", "actual_end": "2026-08-28T19:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0485', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'BOF-SOL', 'Barog - Solan', 'HILL_TRANSMISSION_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    4, 5, 'Ladder & Tension Meter',
    75, 91, '2026-09-02T01:25:00', '2026-09-02T02:56:00',
    'Completed', '{"job_id": "TDMS-H0485", "division": "UMB", "section": "KLK-SML", "block_section": "BOF-SOL", "line": "HILL_TRANSMISSION_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 91, "actual_start": "2026-09-02T01:25:00", "actual_end": "2026-09-02T02:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0486', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'SOL-KDGF', 'Solan - Kandaghat', 'POWER_SUPPLY_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    2, 5, 'Ladder & Contact Burnisher',
    75, 86, '2026-09-02T17:40:00', '2026-09-02T19:06:00',
    'Completed', '{"job_id": "TDMS-H0486", "division": "UMB", "section": "KLK-SML", "block_section": "SOL-KDGF", "line": "POWER_SUPPLY_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 86, "actual_start": "2026-09-02T17:40:00", "actual_end": "2026-09-02T19:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0487', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'HILL_TRANSMISSION_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    3, 5, 'Ladder & Contact Burnisher',
    75, 70, '2026-09-06T12:50:00', '2026-09-06T14:00:00',
    'Completed', '{"job_id": "TDMS-H0487", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "HILL_TRANSMISSION_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-09-06T12:50:00", "actual_end": "2026-09-06T14:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0488', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'KLK-SML', 'KLK–SML (Kalka–Shimla)', 'DMP-BOF', 'Dharampur - Barog', 'YARD_ELECTRICAL_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Low',
    0, 4, 'Inspection Vehicle',
    75, 69, '2026-09-08T16:00:00', '2026-09-08T17:09:00',
    'Completed', '{"job_id": "TDMS-H0488", "division": "UMB", "section": "KLK-SML", "block_section": "DMP-BOF", "line": "YARD_ELECTRICAL_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 69, "actual_start": "2026-09-08T16:00:00", "actual_end": "2026-09-08T17:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0489', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'UMB-RAA', 'Ambala Cantt - Barara', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Medium', 'High',
    0, 6, 'SF6 Gas Filling Kit',
    90, 104, '2026-07-03T17:45:00', '2026-07-03T19:29:00',
    'Completed', '{"job_id": "TDMS-H0489", "division": "UMB", "section": "UMB-SRE", "block_section": "UMB-RAA", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 104, "actual_start": "2026-07-03T17:45:00", "actual_end": "2026-07-03T19:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0490', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'SSW-SRE', 'Sarsawa - Saharanpur', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    0, 6, 'Ladder & Tension Meter',
    105, 109, '2026-07-07T02:35:00', '2026-07-07T04:24:00',
    'Completed', '{"job_id": "TDMS-H0490", "division": "UMB", "section": "UMB-SRE", "block_section": "SSW-SRE", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-07-07T02:35:00", "actual_end": "2026-07-07T04:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0491', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'SSW-SRE', 'Sarsawa - Saharanpur', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Low', 'Critical',
    2, 5, 'Tower Wagon',
    60, 57, '2026-07-12T12:15:00', '2026-07-12T13:12:00',
    'Completed', '{"job_id": "TDMS-H0491", "division": "UMB", "section": "UMB-SRE", "block_section": "SSW-SRE", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Low", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 57, "actual_start": "2026-07-12T12:15:00", "actual_end": "2026-07-12T13:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0492', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 67, '2026-07-19T11:55:00', '2026-07-19T13:02:00',
    'Completed', '{"job_id": "TDMS-H0492", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 67, "actual_start": "2026-07-19T11:55:00", "actual_end": "2026-07-19T13:02:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0493', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    2, 6, 'CB Timing Analyzer',
    165, 185, '2026-07-27T03:25:00', '2026-07-27T06:30:00',
    'Completed', '{"job_id": "TDMS-H0493", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 185, "actual_start": "2026-07-27T03:25:00", "actual_end": "2026-07-27T06:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0494', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'High', 'Critical',
    2, 5, 'Tower Wagon',
    90, 90, '2026-07-27T14:50:00', '2026-07-27T16:20:00',
    'Completed', '{"job_id": "TDMS-H0494", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 90, "actual_start": "2026-07-27T14:50:00", "actual_end": "2026-07-27T16:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0495', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'UMB-RAA', 'Ambala Cantt - Barara', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Medium',
    1, 6, 'Tower Wagon',
    90, 103, '2026-07-28T13:20:00', '2026-07-28T15:03:00',
    'Completed', '{"job_id": "TDMS-H0495", "division": "UMB", "section": "UMB-SRE", "block_section": "UMB-RAA", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 103, "actual_start": "2026-07-28T13:20:00", "actual_end": "2026-07-28T15:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0496', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'High',
    3, 5, 'Ladder & Tension Meter',
    60, 68, '2026-07-31T17:25:00', '2026-07-31T18:33:00',
    'Completed', '{"job_id": "TDMS-H0496", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 68, "actual_start": "2026-07-31T17:25:00", "actual_end": "2026-07-31T18:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0497', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'DN_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'Critical',
    3, 4, 'Ladder & Contact Burnisher',
    60, 59, '2026-08-01T11:00:00', '2026-08-01T11:59:00',
    'Completed', '{"job_id": "TDMS-H0497", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "DN_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 59, "actual_start": "2026-08-01T11:00:00", "actual_end": "2026-08-01T11:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0498', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    105, 112, '2026-08-01T16:45:00', '2026-08-01T18:37:00',
    'Completed', '{"job_id": "TDMS-H0498", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 112, "actual_start": "2026-08-01T16:45:00", "actual_end": "2026-08-01T18:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0499', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    2, 3, 'Inspection Vehicle',
    60, 55, '2026-08-02T11:15:00', '2026-08-02T12:10:00',
    'Completed', '{"job_id": "TDMS-H0499", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 2, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 55, "actual_start": "2026-08-02T11:15:00", "actual_end": "2026-08-02T12:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0500', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'SSW-SRE', 'Sarsawa - Saharanpur', 'DN_MAIN',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'Critical',
    2, 3, 'RTU Diagnostic Terminal',
    60, 82, '2026-08-02T16:45:00', '2026-08-02T18:07:00',
    'Completed', '{"job_id": "TDMS-H0500", "division": "UMB", "section": "UMB-SRE", "block_section": "SSW-SRE", "line": "DN_MAIN", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 82, "actual_start": "2026-08-02T16:45:00", "actual_end": "2026-08-02T18:07:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0501', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Critical',
    2, 4, 'Secondary Injection Test Set',
    105, 96, '2026-08-05T02:15:00', '2026-08-05T03:51:00',
    'Completed', '{"job_id": "TDMS-H0501", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 96, "actual_start": "2026-08-05T02:15:00", "actual_end": "2026-08-05T03:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0502', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'UMB-RAA', 'Ambala Cantt - Barara', 'DN_MAIN',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'High',
    0, 7, 'Tower Wagon',
    150, 152, '2026-08-05T13:05:00', '2026-08-05T15:37:00',
    'Completed', '{"job_id": "TDMS-H0502", "division": "UMB", "section": "UMB-SRE", "block_section": "UMB-RAA", "line": "DN_MAIN", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 152, "actual_start": "2026-08-05T13:05:00", "actual_end": "2026-08-05T15:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0503', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    1, 5, 'Tower Wagon',
    75, 83, '2026-08-12T12:50:00', '2026-08-12T14:13:00',
    'Completed', '{"job_id": "TDMS-H0503", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 83, "actual_start": "2026-08-12T12:50:00", "actual_end": "2026-08-12T14:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0504', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    1, 5, 'Tower Wagon',
    90, 108, '2026-08-15T01:20:00', '2026-08-15T03:08:00',
    'Completed', '{"job_id": "TDMS-H0504", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 108, "actual_start": "2026-08-15T01:20:00", "actual_end": "2026-08-15T03:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0505', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    0, 5, 'CB Timing Analyzer',
    165, 186, '2026-08-15T04:55:00', '2026-08-15T08:01:00',
    'Completed', '{"job_id": "TDMS-H0505", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 186, "actual_start": "2026-08-15T04:55:00", "actual_end": "2026-08-15T08:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0506', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    0, 5, 'Tower Wagon',
    105, 105, '2026-08-20T01:00:00', '2026-08-20T02:45:00',
    'Completed', '{"job_id": "TDMS-H0506", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 105, "actual_start": "2026-08-20T01:00:00", "actual_end": "2026-08-20T02:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0507', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'SSW-SRE', 'Sarsawa - Saharanpur', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'Medium', 'High',
    0, 10, 'Tower Wagon',
    150, 140, '2026-08-20T04:40:00', '2026-08-20T07:00:00',
    'Completed', '{"job_id": "TDMS-H0507", "division": "UMB", "section": "UMB-SRE", "block_section": "SSW-SRE", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 10, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 140, "actual_start": "2026-08-20T04:40:00", "actual_end": "2026-08-20T07:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0508', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 6, 'Ladder & Tension Meter',
    60, 80, '2026-08-23T14:50:00', '2026-08-23T16:10:00',
    'Completed', '{"job_id": "TDMS-H0508", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 80, "actual_start": "2026-08-23T14:50:00", "actual_end": "2026-08-23T16:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0509', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'UMB-RAA', 'Ambala Cantt - Barara', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    0, 4, 'SF6 Gas Filling Kit',
    90, 85, '2026-08-24T17:50:00', '2026-08-24T19:15:00',
    'Completed', '{"job_id": "TDMS-H0509", "division": "UMB", "section": "UMB-SRE", "block_section": "UMB-RAA", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 85, "actual_start": "2026-08-24T17:50:00", "actual_end": "2026-08-24T19:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0510', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'SSW-SRE', 'Sarsawa - Saharanpur', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    1, 6, 'Tower Wagon',
    60, 79, '2026-08-25T01:20:00', '2026-08-25T02:39:00',
    'Completed', '{"job_id": "TDMS-H0510", "division": "UMB", "section": "UMB-SRE", "block_section": "SSW-SRE", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 79, "actual_start": "2026-08-25T01:20:00", "actual_end": "2026-08-25T02:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0511', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    0, 4, 'Ladder & Tension Meter',
    75, 96, '2026-08-25T17:05:00', '2026-08-25T18:41:00',
    'Completed', '{"job_id": "TDMS-H0511", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 96, "actual_start": "2026-08-25T17:05:00", "actual_end": "2026-08-25T18:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0512', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'UP_MAIN',
    'Insulator Replacement', 'Insulator', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    120, 130, '2026-09-03T16:50:00', '2026-09-03T19:00:00',
    'Completed', '{"job_id": "TDMS-H0512", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "UP_MAIN", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 130, "actual_start": "2026-09-03T16:50:00", "actual_end": "2026-09-03T19:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0513', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'YJUD-SSW', 'Yamunanagar - Sarsawa', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 5, 'Ladder & Tension Meter',
    60, 72, '2026-09-06T12:55:00', '2026-09-06T14:07:00',
    'Completed', '{"job_id": "TDMS-H0513", "division": "UMB", "section": "UMB-SRE", "block_section": "YJUD-SSW", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 72, "actual_start": "2026-09-06T12:55:00", "actual_end": "2026-09-06T14:07:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0514', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'UMB-RAA', 'Ambala Cantt - Barara', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    0, 4, 'Secondary Injection Test Set',
    90, 109, '2026-09-07T11:20:00', '2026-09-07T13:09:00',
    'Completed', '{"job_id": "TDMS-H0514", "division": "UMB", "section": "UMB-SRE", "block_section": "UMB-RAA", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-09-07T11:20:00", "actual_end": "2026-09-07T13:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0515', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-SRE', 'UMB–SRE (Ambala–Saharanpur)', 'RAA-YJUD', 'Barara - Yamunanagar Jagadhri', 'UP_MAIN',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'Medium',
    0, 3, 'RTU Diagnostic Terminal',
    105, 100, '2026-09-08T17:55:00', '2026-09-08T19:35:00',
    'Completed', '{"job_id": "TDMS-H0515", "division": "UMB", "section": "UMB-SRE", "block_section": "RAA-YJUD", "line": "UP_MAIN", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 105, "actual_duration_min": 100, "actual_start": "2026-09-08T17:55:00", "actual_end": "2026-09-08T19:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0516', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    1, 4, 'Earth Tester & Bonding Kit',
    75, 87, '2026-07-04T13:30:00', '2026-07-04T14:57:00',
    'Completed', '{"job_id": "TDMS-H0516", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 87, "actual_start": "2026-07-04T13:30:00", "actual_end": "2026-07-04T14:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0517', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'Low', 'Medium',
    0, 7, 'Tower Wagon',
    90, 86, '2026-07-06T15:35:00', '2026-07-06T17:01:00',
    'Completed', '{"job_id": "TDMS-H0517", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 86, "actual_start": "2026-07-06T15:35:00", "actual_end": "2026-07-06T17:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0518', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Medium',
    1, 6, 'Tower Wagon',
    90, 80, '2026-07-08T00:45:00', '2026-07-08T02:05:00',
    'Completed', '{"job_id": "TDMS-H0518", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-07-08T00:45:00", "actual_end": "2026-07-08T02:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0519', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    3, 7, 'Tower Wagon',
    105, 98, '2026-07-08T13:40:00', '2026-07-08T15:18:00',
    'Completed', '{"job_id": "TDMS-H0519", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 98, "actual_start": "2026-07-08T13:40:00", "actual_end": "2026-07-08T15:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0520', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    0, 4, 'Tower Wagon',
    60, 62, '2026-07-15T03:20:00', '2026-07-15T04:22:00',
    'Completed', '{"job_id": "TDMS-H0520", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 62, "actual_start": "2026-07-15T03:20:00", "actual_end": "2026-07-15T04:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0521', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    75, 77, '2026-07-15T13:25:00', '2026-07-15T14:42:00',
    'Completed', '{"job_id": "TDMS-H0521", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 77, "actual_start": "2026-07-15T13:25:00", "actual_end": "2026-07-15T14:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0522', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    0, 4, 'Ladder & Contact Burnisher',
    90, 106, '2026-07-15T15:25:00', '2026-07-15T17:11:00',
    'Completed', '{"job_id": "TDMS-H0522", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-07-15T15:25:00", "actual_end": "2026-07-15T17:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0523', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    1, 5, 'Tower Wagon',
    135, 156, '2026-07-15T16:15:00', '2026-07-15T18:51:00',
    'Completed', '{"job_id": "TDMS-H0523", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 156, "actual_start": "2026-07-15T16:15:00", "actual_end": "2026-07-15T18:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0524', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    0, 8, 'Tower Wagon',
    150, 149, '2026-07-15T17:30:00', '2026-07-15T19:59:00',
    'Completed', '{"job_id": "TDMS-H0524", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 149, "actual_start": "2026-07-15T17:30:00", "actual_end": "2026-07-15T19:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0525', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'DN_MAIN',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'High',
    0, 3, 'RTU Diagnostic Terminal',
    105, 104, '2026-07-17T16:50:00', '2026-07-17T18:34:00',
    'Completed', '{"job_id": "TDMS-H0525", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "DN_MAIN", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 105, "actual_duration_min": 104, "actual_start": "2026-07-17T16:50:00", "actual_end": "2026-07-17T18:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0526', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'UP_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 40, '2026-07-22T00:35:00', '2026-07-22T01:15:00',
    'Completed', '{"job_id": "TDMS-H0526", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "UP_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-07-22T00:35:00", "actual_end": "2026-07-22T01:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0527', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 3, 'Inspection Vehicle',
    60, 68, '2026-07-22T11:55:00', '2026-07-22T13:03:00',
    'Completed', '{"job_id": "TDMS-H0527", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 68, "actual_start": "2026-07-22T11:55:00", "actual_end": "2026-07-22T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0528', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    75, 89, '2026-07-29T14:50:00', '2026-07-29T16:19:00',
    'Completed', '{"job_id": "TDMS-H0528", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 89, "actual_start": "2026-07-29T14:50:00", "actual_end": "2026-07-29T16:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0529', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'DN_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    0, 4, 'Ladder & Contact Burnisher',
    90, 93, '2026-08-01T15:35:00', '2026-08-01T17:08:00',
    'Completed', '{"job_id": "TDMS-H0529", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "DN_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-08-01T15:35:00", "actual_end": "2026-08-01T17:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0530', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 8, 'Tower Wagon',
    165, 159, '2026-08-01T16:55:00', '2026-08-01T19:34:00',
    'Completed', '{"job_id": "TDMS-H0530", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 159, "actual_start": "2026-08-01T16:55:00", "actual_end": "2026-08-01T19:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0531', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    2, 6, 'Tower Wagon',
    105, 111, '2026-08-02T01:35:00', '2026-08-02T03:26:00',
    'Completed', '{"job_id": "TDMS-H0531", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-08-02T01:35:00", "actual_end": "2026-08-02T03:26:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0532', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Low',
    0, 4, 'Inspection Vehicle',
    45, 40, '2026-08-04T13:40:00', '2026-08-04T14:20:00',
    'Completed', '{"job_id": "TDMS-H0532", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Low", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-04T13:40:00", "actual_end": "2026-08-04T14:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0533', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    75, 83, '2026-08-15T12:10:00', '2026-08-15T13:33:00',
    'Completed', '{"job_id": "TDMS-H0533", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 83, "actual_start": "2026-08-15T12:10:00", "actual_end": "2026-08-15T13:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0534', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    0, 4, 'Secondary Injection Test Set',
    75, 68, '2026-08-20T03:10:00', '2026-08-20T04:18:00',
    'Completed', '{"job_id": "TDMS-H0534", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-08-20T03:10:00", "actual_end": "2026-08-20T04:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0535', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    60, 73, '2026-08-22T01:05:00', '2026-08-22T02:18:00',
    'Completed', '{"job_id": "TDMS-H0535", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 73, "actual_start": "2026-08-22T01:05:00", "actual_end": "2026-08-22T02:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0536', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    0, 6, 'SF6 Gas Filling Kit',
    135, 153, '2026-08-23T02:25:00', '2026-08-23T04:58:00',
    'Completed', '{"job_id": "TDMS-H0536", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 153, "actual_start": "2026-08-23T02:25:00", "actual_end": "2026-08-23T04:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0537', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'UP_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Low', 'Medium',
    0, 5, 'Ladder & Contact Burnisher',
    90, 85, '2026-08-23T04:25:00', '2026-08-23T05:50:00',
    'Completed', '{"job_id": "TDMS-H0537", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "UP_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 85, "actual_start": "2026-08-23T04:25:00", "actual_end": "2026-08-23T05:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0538', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    1, 3, 'Secondary Injection Test Set',
    105, 108, '2026-08-24T11:00:00', '2026-08-24T12:48:00',
    'Completed', '{"job_id": "TDMS-H0538", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 108, "actual_start": "2026-08-24T11:00:00", "actual_end": "2026-08-24T12:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0539', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'KES-MFB', 'Kesri - Mustafabad', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Low', 'Medium',
    0, 5, 'Tower Wagon',
    105, 109, '2026-08-26T11:50:00', '2026-08-26T13:39:00',
    'Completed', '{"job_id": "TDMS-H0539", "division": "UMB", "section": "UMB-JUDW", "block_section": "KES-MFB", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-08-26T11:50:00", "actual_end": "2026-08-26T13:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0540', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'High',
    2, 4, 'Ladder & Tension Meter',
    75, 94, '2026-08-31T01:30:00', '2026-08-31T03:04:00',
    'Completed', '{"job_id": "TDMS-H0540", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 94, "actual_start": "2026-08-31T01:30:00", "actual_end": "2026-08-31T03:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0541', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'MFB-JUDW', 'Mustafabad - Jagadhri Workshop', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'Critical',
    1, 8, 'Tower Wagon',
    180, 191, '2026-08-31T14:05:00', '2026-08-31T17:16:00',
    'Completed', '{"job_id": "TDMS-H0541", "division": "UMB", "section": "UMB-JUDW", "block_section": "MFB-JUDW", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 191, "actual_start": "2026-08-31T14:05:00", "actual_end": "2026-08-31T17:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0542', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-JUDW', 'UMB–JUDW (Ambala–Jagadhri/Yamunanagar)', 'UMB-KES', 'Ambala Cantt - Kesri', 'UP_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Critical',
    2, 5, 'Tower Wagon',
    120, 120, '2026-09-02T01:45:00', '2026-09-02T03:45:00',
    'Completed', '{"job_id": "TDMS-H0542", "division": "UMB", "section": "UMB-JUDW", "block_section": "UMB-KES", "line": "UP_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 120, "actual_start": "2026-09-02T01:45:00", "actual_end": "2026-09-02T03:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0543', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'High',
    1, 5, 'Inspection Vehicle',
    90, 93, '2026-07-02T02:35:00', '2026-07-02T04:08:00',
    'Completed', '{"job_id": "TDMS-H0543", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-07-02T02:35:00", "actual_end": "2026-07-02T04:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0544', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Critical',
    0, 3, 'Secondary Injection Test Set',
    90, 90, '2026-07-03T01:35:00', '2026-07-03T03:05:00',
    'Completed', '{"job_id": "TDMS-H0544", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 90, "actual_start": "2026-07-03T01:35:00", "actual_end": "2026-07-03T03:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0545', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    75, 79, '2026-07-05T15:50:00', '2026-07-05T17:09:00',
    'Completed', '{"job_id": "TDMS-H0545", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 79, "actual_start": "2026-07-05T15:50:00", "actual_end": "2026-07-05T17:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0546', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Medium',
    1, 4, 'Secondary Injection Test Set',
    120, 131, '2026-07-10T14:30:00', '2026-07-10T16:41:00',
    'Completed', '{"job_id": "TDMS-H0546", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 131, "actual_start": "2026-07-10T14:30:00", "actual_end": "2026-07-10T16:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0547', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    1, 7, 'Tower Wagon',
    105, 109, '2026-07-10T17:50:00', '2026-07-10T19:39:00',
    'Completed', '{"job_id": "TDMS-H0547", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 109, "actual_start": "2026-07-10T17:50:00", "actual_end": "2026-07-10T19:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0548', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'UP_MAIN',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Medium', 'High',
    3, 8, 'Tower Wagon',
    105, 111, '2026-07-12T03:25:00', '2026-07-12T05:16:00',
    'Completed', '{"job_id": "TDMS-H0548", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "UP_MAIN", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-07-12T03:25:00", "actual_end": "2026-07-12T05:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0549', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Critical',
    0, 7, 'Tower Wagon',
    75, 88, '2026-07-14T04:40:00', '2026-07-14T06:08:00',
    'Completed', '{"job_id": "TDMS-H0549", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 88, "actual_start": "2026-07-14T04:40:00", "actual_end": "2026-07-14T06:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0550', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    1, 4, 'Inspection Vehicle',
    45, 48, '2026-07-15T11:55:00', '2026-07-15T12:43:00',
    'Completed', '{"job_id": "TDMS-H0550", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 48, "actual_start": "2026-07-15T11:55:00", "actual_end": "2026-07-15T12:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0551', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    1, 4, 'Inspection Vehicle',
    90, 83, '2026-07-15T12:55:00', '2026-07-15T14:18:00',
    'Completed', '{"job_id": "TDMS-H0551", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-07-15T12:55:00", "actual_end": "2026-07-15T14:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0552', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    0, 4, 'Earth Tester & Bonding Kit',
    90, 102, '2026-07-16T01:55:00', '2026-07-16T03:37:00',
    'Completed', '{"job_id": "TDMS-H0552", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-07-16T01:55:00", "actual_end": "2026-07-16T03:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0553', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'UP_MAIN',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    2, 4, 'Tower Wagon',
    90, 87, '2026-07-21T01:10:00', '2026-07-21T02:37:00',
    'Completed', '{"job_id": "TDMS-H0553", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "UP_MAIN", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-07-21T01:10:00", "actual_end": "2026-07-21T02:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0554', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'Medium',
    1, 6, 'Tower Wagon',
    90, 104, '2026-07-21T17:40:00', '2026-07-21T19:24:00',
    'Completed', '{"job_id": "TDMS-H0554", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 104, "actual_start": "2026-07-21T17:40:00", "actual_end": "2026-07-21T19:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0555', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'High', 'High',
    4, 6, 'Tower Wagon',
    75, 66, '2026-08-04T14:35:00', '2026-08-04T15:41:00',
    'Completed', '{"job_id": "TDMS-H0555", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 66, "actual_start": "2026-08-04T14:35:00", "actual_end": "2026-08-04T15:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0556', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    2, 3, 'Earth Tester & Bonding Kit',
    45, 40, '2026-08-06T03:30:00', '2026-08-06T04:10:00',
    'Completed', '{"job_id": "TDMS-H0556", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-06T03:30:00", "actual_end": "2026-08-06T04:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0557', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'DN_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    0, 4, 'Secondary Injection Test Set',
    105, 113, '2026-08-07T11:05:00', '2026-08-07T12:58:00',
    'Completed', '{"job_id": "TDMS-H0557", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "DN_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-08-07T11:05:00", "actual_end": "2026-08-07T12:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0558', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    5, 7, 'Tower Wagon',
    120, 129, '2026-08-12T00:30:00', '2026-08-12T02:39:00',
    'Completed', '{"job_id": "TDMS-H0558", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 129, "actual_start": "2026-08-12T00:30:00", "actual_end": "2026-08-12T02:39:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0559', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    2, 7, 'Tower Wagon',
    165, 174, '2026-08-12T03:30:00', '2026-08-12T06:24:00',
    'Completed', '{"job_id": "TDMS-H0559", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 174, "actual_start": "2026-08-12T03:30:00", "actual_end": "2026-08-12T06:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0560', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    1, 5, 'Earth Tester & Bonding Kit',
    75, 75, '2026-08-13T16:10:00', '2026-08-13T17:25:00',
    'Completed', '{"job_id": "TDMS-H0560", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 75, "actual_start": "2026-08-13T16:10:00", "actual_end": "2026-08-13T17:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0561', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'SHDM-KKDE', 'Shahbad Markanda - Kurukshetra', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    75, 78, '2026-08-15T01:30:00', '2026-08-15T02:48:00',
    'Completed', '{"job_id": "TDMS-H0561", "division": "UMB", "section": "UMB-KKDE", "block_section": "SHDM-KKDE", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 78, "actual_start": "2026-08-15T01:30:00", "actual_end": "2026-08-15T02:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0562', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    90, 82, '2026-08-15T13:15:00', '2026-08-15T14:37:00',
    'Completed', '{"job_id": "TDMS-H0562", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 82, "actual_start": "2026-08-15T13:15:00", "actual_end": "2026-08-15T14:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0563', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    2, 6, 'CB Timing Analyzer',
    135, 125, '2026-08-17T16:30:00', '2026-08-17T18:35:00',
    'Completed', '{"job_id": "TDMS-H0563", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 125, "actual_start": "2026-08-17T16:30:00", "actual_end": "2026-08-17T18:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0564', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    4, 6, 'SF6 Gas Filling Kit',
    135, 146, '2026-08-21T12:10:00', '2026-08-21T14:36:00',
    'Completed', '{"job_id": "TDMS-H0564", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 146, "actual_start": "2026-08-21T12:10:00", "actual_end": "2026-08-21T14:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0565', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 4, 'Earth Tester & Bonding Kit',
    75, 78, '2026-08-29T13:20:00', '2026-08-29T14:38:00',
    'Completed', '{"job_id": "TDMS-H0565", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 78, "actual_start": "2026-08-29T13:20:00", "actual_end": "2026-08-29T14:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0566', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'MOY-SHDM', 'Mohri - Shahbad Markanda', 'UP_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'High',
    2, 6, 'Ladder & Tension Meter',
    60, 58, '2026-09-01T17:25:00', '2026-09-01T18:23:00',
    'Completed', '{"job_id": "TDMS-H0566", "division": "UMB", "section": "UMB-KKDE", "block_section": "MOY-SHDM", "line": "UP_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 58, "actual_start": "2026-09-01T17:25:00", "actual_end": "2026-09-01T18:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0567', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'UMB-KKDE', 'UMB–KKDE (Ambala–Kurukshetra)', 'UMB-MOY', 'Ambala Cantt - Mohri', 'UP_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    4, 6, 'Tower Wagon',
    75, 80, '2026-09-02T14:35:00', '2026-09-02T15:55:00',
    'Completed', '{"job_id": "TDMS-H0567", "division": "UMB", "section": "UMB-KKDE", "block_section": "UMB-MOY", "line": "UP_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 80, "actual_start": "2026-09-02T14:35:00", "actual_end": "2026-09-02T15:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0568', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'RPJ-PTA', 'Rajpura - Patiala', 'UP_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    1, 6, 'Oil Filtration Plant',
    165, 159, '2026-07-04T02:40:00', '2026-07-04T05:19:00',
    'Completed', '{"job_id": "TDMS-H0568", "division": "UMB", "section": "RPJ-BTI", "block_section": "RPJ-PTA", "line": "UP_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 159, "actual_start": "2026-07-04T02:40:00", "actual_end": "2026-07-04T05:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0569', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'DUI-BNN', 'Dhuri - Barnala', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'Medium',
    0, 6, 'Ladder & Tension Meter',
    105, 107, '2026-07-06T12:30:00', '2026-07-06T14:17:00',
    'Completed', '{"job_id": "TDMS-H0569", "division": "UMB", "section": "RPJ-BTI", "block_section": "DUI-BNN", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 105, "actual_duration_min": 107, "actual_start": "2026-07-06T12:30:00", "actual_end": "2026-07-06T14:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0570', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'RPJ-PTA', 'Rajpura - Patiala', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    2, 5, 'Tower Wagon',
    90, 108, '2026-07-07T03:20:00', '2026-07-07T05:08:00',
    'Completed', '{"job_id": "TDMS-H0570", "division": "UMB", "section": "RPJ-BTI", "block_section": "RPJ-PTA", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 108, "actual_start": "2026-07-07T03:20:00", "actual_end": "2026-07-07T05:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0571', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'BNN-PUL', 'Barnala - Rampura Phul', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    1, 6, 'Tower Wagon',
    135, 157, '2026-07-10T02:10:00', '2026-07-10T04:47:00',
    'Completed', '{"job_id": "TDMS-H0571", "division": "UMB", "section": "RPJ-BTI", "block_section": "BNN-PUL", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 157, "actual_start": "2026-07-10T02:10:00", "actual_end": "2026-07-10T04:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0572', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'DUI-BNN', 'Dhuri - Barnala', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'Medium',
    0, 8, 'Tower Wagon',
    165, 165, '2026-07-11T04:15:00', '2026-07-11T07:00:00',
    'Completed', '{"job_id": "TDMS-H0572", "division": "UMB", "section": "RPJ-BTI", "block_section": "DUI-BNN", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 165, "actual_start": "2026-07-11T04:15:00", "actual_end": "2026-07-11T07:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0573', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'DUI-BNN', 'Dhuri - Barnala', 'DN_MAIN',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'High',
    0, 3, 'RTU Diagnostic Terminal',
    75, 94, '2026-07-11T15:35:00', '2026-07-11T17:09:00',
    'Completed', '{"job_id": "TDMS-H0573", "division": "UMB", "section": "RPJ-BTI", "block_section": "DUI-BNN", "line": "DN_MAIN", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 75, "actual_duration_min": 94, "actual_start": "2026-07-11T15:35:00", "actual_end": "2026-07-11T17:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0574', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'RPJ-PTA', 'Rajpura - Patiala', 'DN_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    3, 4, 'SF6 Gas Filling Kit',
    120, 142, '2026-07-14T04:25:00', '2026-07-14T06:47:00',
    'Completed', '{"job_id": "TDMS-H0574", "division": "UMB", "section": "RPJ-BTI", "block_section": "RPJ-PTA", "line": "DN_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 120, "actual_duration_min": 142, "actual_start": "2026-07-14T04:25:00", "actual_end": "2026-07-14T06:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0575', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'UP_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'High',
    1, 5, 'SF6 Gas Filling Kit',
    90, 105, '2026-07-14T17:35:00', '2026-07-14T19:20:00',
    'Completed', '{"job_id": "TDMS-H0575", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "UP_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 90, "actual_duration_min": 105, "actual_start": "2026-07-14T17:35:00", "actual_end": "2026-07-14T19:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0576', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    0, 8, 'Tower Wagon',
    150, 159, '2026-07-19T01:30:00', '2026-07-19T04:09:00',
    'Completed', '{"job_id": "TDMS-H0576", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 159, "actual_start": "2026-07-19T01:30:00", "actual_end": "2026-07-19T04:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0577', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'RPJ-PTA', 'Rajpura - Patiala', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'High',
    1, 3, 'Inspection Vehicle',
    60, 69, '2026-07-25T13:40:00', '2026-07-25T14:49:00',
    'Completed', '{"job_id": "TDMS-H0577", "division": "UMB", "section": "RPJ-BTI", "block_section": "RPJ-PTA", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 69, "actual_start": "2026-07-25T13:40:00", "actual_end": "2026-07-25T14:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0578', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'DUI-BNN', 'Dhuri - Barnala', 'UP_MAIN',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Medium',
    0, 3, 'Secondary Injection Test Set',
    90, 87, '2026-07-28T02:55:00', '2026-07-28T04:22:00',
    'Completed', '{"job_id": "TDMS-H0578", "division": "UMB", "section": "RPJ-BTI", "block_section": "DUI-BNN", "line": "UP_MAIN", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 90, "actual_duration_min": 87, "actual_start": "2026-07-28T02:55:00", "actual_end": "2026-07-28T04:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0579', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'PUL-BTI', 'Rampura Phul - Bathinda', 'UP_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    1, 5, 'Earth Tester & Bonding Kit',
    90, 97, '2026-07-28T12:05:00', '2026-07-28T13:42:00',
    'Completed', '{"job_id": "TDMS-H0579", "division": "UMB", "section": "RPJ-BTI", "block_section": "PUL-BTI", "line": "UP_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-07-28T12:05:00", "actual_end": "2026-07-28T13:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0580', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'DN_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 5, 'Inspection Vehicle',
    45, 45, '2026-07-29T01:15:00', '2026-07-29T02:00:00',
    'Completed', '{"job_id": "TDMS-H0580", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "DN_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 45, "actual_start": "2026-07-29T01:15:00", "actual_end": "2026-07-29T02:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0581', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'RPJ-PTA', 'Rajpura - Patiala', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    0, 5, 'Tower Wagon',
    120, 116, '2026-08-01T03:40:00', '2026-08-01T05:36:00',
    'Completed', '{"job_id": "TDMS-H0581", "division": "UMB", "section": "RPJ-BTI", "block_section": "RPJ-PTA", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 116, "actual_start": "2026-08-01T03:40:00", "actual_end": "2026-08-01T05:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0582', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'UP_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Medium',
    1, 6, 'Tower Wagon',
    120, 110, '2026-08-04T16:45:00', '2026-08-04T18:35:00',
    'Completed', '{"job_id": "TDMS-H0582", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "UP_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 110, "actual_start": "2026-08-04T16:45:00", "actual_end": "2026-08-04T18:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0583', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'Critical',
    2, 5, 'Tower Wagon',
    90, 98, '2026-08-07T15:30:00', '2026-08-07T17:08:00',
    'Completed', '{"job_id": "TDMS-H0583", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 98, "actual_start": "2026-08-07T15:30:00", "actual_end": "2026-08-07T17:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0584', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'PUL-BTI', 'Rampura Phul - Bathinda', 'UP_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 6, 'Tower Wagon',
    135, 126, '2026-08-11T13:45:00', '2026-08-11T15:51:00',
    'Completed', '{"job_id": "TDMS-H0584", "division": "UMB", "section": "RPJ-BTI", "block_section": "PUL-BTI", "line": "UP_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 126, "actual_start": "2026-08-11T13:45:00", "actual_end": "2026-08-11T15:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0585', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'DUI-BNN', 'Dhuri - Barnala', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    1, 4, 'Inspection Vehicle',
    75, 91, '2026-08-13T01:50:00', '2026-08-13T03:21:00',
    'Completed', '{"job_id": "TDMS-H0585", "division": "UMB", "section": "RPJ-BTI", "block_section": "DUI-BNN", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 91, "actual_start": "2026-08-13T01:50:00", "actual_end": "2026-08-13T03:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0586', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'PUL-BTI', 'Rampura Phul - Bathinda', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'Medium',
    0, 7, 'Tower Wagon',
    120, 132, '2026-08-19T02:20:00', '2026-08-19T04:32:00',
    'Completed', '{"job_id": "TDMS-H0586", "division": "UMB", "section": "RPJ-BTI", "block_section": "PUL-BTI", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 132, "actual_start": "2026-08-19T02:20:00", "actual_end": "2026-08-19T04:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0587', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'DN_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Low', 'Medium',
    1, 5, 'Ladder & Contact Burnisher',
    90, 105, '2026-08-20T12:50:00', '2026-08-20T14:35:00',
    'Completed', '{"job_id": "TDMS-H0587", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "DN_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 105, "actual_start": "2026-08-20T12:50:00", "actual_end": "2026-08-20T14:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0588', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'PUL-BTI', 'Rampura Phul - Bathinda', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    1, 3, 'Inspection Vehicle',
    60, 74, '2026-08-22T00:45:00', '2026-08-22T01:59:00',
    'Completed', '{"job_id": "TDMS-H0588", "division": "UMB", "section": "RPJ-BTI", "block_section": "PUL-BTI", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 74, "actual_start": "2026-08-22T00:45:00", "actual_end": "2026-08-22T01:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0589', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'DN_MAIN',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    60, 74, '2026-08-22T04:05:00', '2026-08-22T05:19:00',
    'Completed', '{"job_id": "TDMS-H0589", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "DN_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 74, "actual_start": "2026-08-22T04:05:00", "actual_end": "2026-08-22T05:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0590', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'BNN-PUL', 'Barnala - Rampura Phul', 'DN_MAIN',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    4, 8, 'Oil Filtration Plant',
    180, 194, '2026-08-25T01:45:00', '2026-08-25T04:59:00',
    'Completed', '{"job_id": "TDMS-H0590", "division": "UMB", "section": "RPJ-BTI", "block_section": "BNN-PUL", "line": "DN_MAIN", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 194, "actual_start": "2026-08-25T01:45:00", "actual_end": "2026-08-25T04:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0591', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'PTA-NBA', 'Patiala - Nabha', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    1, 8, 'Tower Wagon',
    180, 195, '2026-08-27T03:25:00', '2026-08-27T06:40:00',
    'Completed', '{"job_id": "TDMS-H0591", "division": "UMB", "section": "RPJ-BTI", "block_section": "PTA-NBA", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 195, "actual_start": "2026-08-27T03:25:00", "actual_end": "2026-08-27T06:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0592', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-BTI', 'RPJ–BTI (Rajpura–Bathinda)', 'NBA-DUI', 'Nabha - Dhuri', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    90, 106, '2026-09-05T04:20:00', '2026-09-05T06:06:00',
    'Completed', '{"job_id": "TDMS-H0592", "division": "UMB", "section": "RPJ-BTI", "block_section": "NBA-DUI", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-09-05T04:20:00", "actual_end": "2026-09-05T06:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0593', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'DN_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    1, 5, 'Inspection Vehicle',
    90, 112, '2026-07-07T01:40:00', '2026-07-07T03:32:00',
    'Completed', '{"job_id": "TDMS-H0593", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "DN_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 112, "actual_start": "2026-07-07T01:40:00", "actual_end": "2026-07-07T03:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0594', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'DN_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    3, 4, 'Ladder & Contact Burnisher',
    75, 72, '2026-07-10T17:40:00', '2026-07-10T18:52:00',
    'Completed', '{"job_id": "TDMS-H0594", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "DN_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 72, "actual_start": "2026-07-10T17:40:00", "actual_end": "2026-07-10T18:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0595', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'DN_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'High', 'Medium',
    1, 4, 'Earth Tester & Bonding Kit',
    60, 68, '2026-07-12T14:45:00', '2026-07-12T15:53:00',
    'Completed', '{"job_id": "TDMS-H0595", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "DN_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 68, "actual_start": "2026-07-12T14:45:00", "actual_end": "2026-07-12T15:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0596', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'CJL-DUI', 'Chhajli - Dhuri', 'DN_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'High',
    1, 5, 'Inspection Vehicle',
    75, 90, '2026-07-14T14:00:00', '2026-07-14T15:30:00',
    'Completed', '{"job_id": "TDMS-H0596", "division": "UMB", "section": "RPJ-DUI", "block_section": "CJL-DUI", "line": "DN_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 90, "actual_start": "2026-07-14T14:00:00", "actual_end": "2026-07-14T15:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0597', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'DN_LINE',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    4, 7, 'Tower Wagon',
    90, 97, '2026-07-17T02:05:00', '2026-07-17T03:42:00',
    'Completed', '{"job_id": "TDMS-H0597", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "DN_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 4, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-07-17T02:05:00", "actual_end": "2026-07-17T03:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0598', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'DN_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    105, 97, '2026-07-18T13:55:00', '2026-07-18T15:32:00',
    'Completed', '{"job_id": "TDMS-H0598", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "DN_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 97, "actual_start": "2026-07-18T13:55:00", "actual_end": "2026-07-18T15:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0599', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'UP_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'High',
    1, 4, 'Earth Tester & Bonding Kit',
    45, 44, '2026-07-22T13:50:00', '2026-07-22T14:34:00',
    'Completed', '{"job_id": "TDMS-H0599", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "UP_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 44, "actual_start": "2026-07-22T13:50:00", "actual_end": "2026-07-22T14:34:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0600', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'DN_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    1, 4, 'Earth Tester & Bonding Kit',
    75, 80, '2026-07-23T01:35:00', '2026-07-23T02:55:00',
    'Completed', '{"job_id": "TDMS-H0600", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "DN_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 80, "actual_start": "2026-07-23T01:35:00", "actual_end": "2026-07-23T02:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0601', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'DN_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    60, 79, '2026-07-25T03:45:00', '2026-07-25T05:04:00',
    'Completed', '{"job_id": "TDMS-H0601", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "DN_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 79, "actual_start": "2026-07-25T03:45:00", "actual_end": "2026-07-25T05:04:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0602', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'UP_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'Critical', 'Critical',
    6, 5, 'CB Timing Analyzer',
    120, 114, '2026-07-25T13:50:00', '2026-07-25T15:44:00',
    'Completed', '{"job_id": "TDMS-H0602", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "UP_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "Critical", "criticality": "Critical", "overdue_days": 6, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 114, "actual_start": "2026-07-25T13:50:00", "actual_end": "2026-07-25T15:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0603', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'UP_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'Critical',
    5, 5, 'Ladder & Tension Meter',
    60, 60, '2026-07-30T15:55:00', '2026-07-30T16:55:00',
    'Completed', '{"job_id": "TDMS-H0603", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "UP_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 60, "actual_start": "2026-07-30T15:55:00", "actual_end": "2026-07-30T16:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0604', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'CJL-DUI', 'Chhajli - Dhuri', 'UP_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 5, 'Inspection Vehicle',
    45, 58, '2026-08-01T12:05:00', '2026-08-01T13:03:00',
    'Completed', '{"job_id": "TDMS-H0604", "division": "UMB", "section": "RPJ-DUI", "block_section": "CJL-DUI", "line": "UP_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 58, "actual_start": "2026-08-01T12:05:00", "actual_end": "2026-08-01T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0605', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'DN_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    0, 5, 'Ladder & Tension Meter',
    90, 100, '2026-08-06T12:00:00', '2026-08-06T13:40:00',
    'Completed', '{"job_id": "TDMS-H0605", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "DN_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 100, "actual_start": "2026-08-06T12:00:00", "actual_end": "2026-08-06T13:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0606', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'UP_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    1, 6, 'Tower Wagon',
    135, 140, '2026-08-06T15:25:00', '2026-08-06T17:45:00',
    'Completed', '{"job_id": "TDMS-H0606", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "UP_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 140, "actual_start": "2026-08-06T15:25:00", "actual_end": "2026-08-06T17:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0607', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'DN_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    150, 155, '2026-08-07T17:35:00', '2026-08-07T20:10:00',
    'Completed', '{"job_id": "TDMS-H0607", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "DN_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 155, "actual_start": "2026-08-07T17:35:00", "actual_end": "2026-08-07T20:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0608', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'UP_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Medium', 'Medium',
    2, 4, 'Earth Tester & Bonding Kit',
    45, 45, '2026-08-10T17:05:00', '2026-08-10T17:50:00',
    'Completed', '{"job_id": "TDMS-H0608", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "UP_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 45, "actual_duration_min": 45, "actual_start": "2026-08-10T17:05:00", "actual_end": "2026-08-10T17:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0609', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'UP_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    2, 7, 'Tower Wagon',
    105, 110, '2026-08-11T14:40:00', '2026-08-11T16:30:00',
    'Completed', '{"job_id": "TDMS-H0609", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "UP_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 110, "actual_start": "2026-08-11T14:40:00", "actual_end": "2026-08-11T16:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0610', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'DN_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 62, '2026-08-15T03:55:00', '2026-08-15T04:57:00',
    'Completed', '{"job_id": "TDMS-H0610", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "DN_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 62, "actual_start": "2026-08-15T03:55:00", "actual_end": "2026-08-15T04:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0611', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'RPJ-KLI', 'Rajpura - Kauli', 'UP_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    0, 5, 'Tower Wagon',
    120, 141, '2026-08-19T00:40:00', '2026-08-19T03:01:00',
    'Completed', '{"job_id": "TDMS-H0611", "division": "UMB", "section": "RPJ-DUI", "block_section": "RPJ-KLI", "line": "UP_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 141, "actual_start": "2026-08-19T00:40:00", "actual_end": "2026-08-19T03:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0612', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'UP_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    0, 5, 'Tower Wagon',
    135, 131, '2026-08-19T15:50:00', '2026-08-19T18:01:00',
    'Completed', '{"job_id": "TDMS-H0612", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "UP_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 131, "actual_start": "2026-08-19T15:50:00", "actual_end": "2026-08-19T18:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0613', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'CJL-DUI', 'Chhajli - Dhuri', 'DN_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    1, 8, 'Tower Wagon',
    120, 126, '2026-08-21T11:05:00', '2026-08-21T13:11:00',
    'Completed', '{"job_id": "TDMS-H0613", "division": "UMB", "section": "RPJ-DUI", "block_section": "CJL-DUI", "line": "DN_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 126, "actual_start": "2026-08-21T11:05:00", "actual_end": "2026-08-21T13:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0614', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'KLI-PTA', 'Kauli - Patiala', 'UP_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    3, 8, 'Tower Wagon',
    150, 168, '2026-08-25T17:50:00', '2026-08-25T20:38:00',
    'Completed', '{"job_id": "TDMS-H0614", "division": "UMB", "section": "RPJ-DUI", "block_section": "KLI-PTA", "line": "UP_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 168, "actual_start": "2026-08-25T17:50:00", "actual_end": "2026-08-25T20:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0615', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'CJL-DUI', 'Chhajli - Dhuri', 'DN_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Low',
    2, 4, 'Earth Tester & Bonding Kit',
    75, 73, '2026-08-26T11:40:00', '2026-08-26T12:53:00',
    'Completed', '{"job_id": "TDMS-H0615", "division": "UMB", "section": "RPJ-DUI", "block_section": "CJL-DUI", "line": "DN_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Low", "overdue_days": 2, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 73, "actual_start": "2026-08-26T11:40:00", "actual_end": "2026-08-26T12:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0616', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'RPJ-DUI', 'RPJ–DUI (Rajpura–Dhuri)', 'PTA-CJL', 'Patiala - Chhajli', 'DN_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 5, 'Inspection Vehicle',
    45, 66, '2026-08-28T15:05:00', '2026-08-28T16:11:00',
    'Completed', '{"job_id": "TDMS-H0616", "division": "UMB", "section": "RPJ-DUI", "block_section": "PTA-CJL", "line": "DN_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 66, "actual_start": "2026-08-28T15:05:00", "actual_end": "2026-08-28T16:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0617', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    135, 132, '2026-07-02T11:15:00', '2026-07-02T13:27:00',
    'Completed', '{"job_id": "TDMS-H0617", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 132, "actual_start": "2026-07-02T11:15:00", "actual_end": "2026-07-02T13:27:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0618', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    3, 6, 'Oil Filtration Plant',
    165, 162, '2026-07-03T12:35:00', '2026-07-03T15:17:00',
    'Completed', '{"job_id": "TDMS-H0618", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 162, "actual_start": "2026-07-03T12:35:00", "actual_end": "2026-07-03T15:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0619', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    1, 6, 'CB Timing Analyzer',
    135, 130, '2026-07-05T11:50:00', '2026-07-05T14:00:00',
    'Completed', '{"job_id": "TDMS-H0619", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 135, "actual_duration_min": 130, "actual_start": "2026-07-05T11:50:00", "actual_end": "2026-07-05T14:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0620', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'AHH-QRP', 'Ahmedgarh - Qila Raipur', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'Medium',
    1, 5, 'Tower Wagon',
    90, 102, '2026-07-05T12:55:00', '2026-07-05T14:37:00',
    'Completed', '{"job_id": "TDMS-H0620", "division": "UMB", "section": "DUI-LDH", "block_section": "AHH-QRP", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-07-05T12:55:00", "actual_end": "2026-07-05T14:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0621', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'Medium',
    0, 5, 'Tower Wagon',
    105, 95, '2026-07-08T12:15:00', '2026-07-08T13:50:00',
    'Completed', '{"job_id": "TDMS-H0621", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 95, "actual_start": "2026-07-08T12:15:00", "actual_end": "2026-07-08T13:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0622', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'Critical',
    2, 7, 'Oil Filtration Plant',
    210, 205, '2026-07-15T14:15:00', '2026-07-15T17:40:00',
    'Completed', '{"job_id": "TDMS-H0622", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "Critical", "overdue_days": 2, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 210, "actual_duration_min": 205, "actual_start": "2026-07-15T14:15:00", "actual_end": "2026-07-15T17:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0623', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'Medium',
    2, 5, 'Inspection Vehicle',
    75, 85, '2026-07-15T14:20:00', '2026-07-15T15:45:00',
    'Completed', '{"job_id": "TDMS-H0623", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 85, "actual_start": "2026-07-15T14:20:00", "actual_end": "2026-07-15T15:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0624', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Low',
    0, 4, 'Inspection Vehicle',
    45, 41, '2026-07-22T11:40:00', '2026-07-22T12:21:00',
    'Completed', '{"job_id": "TDMS-H0624", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Low", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 41, "actual_start": "2026-07-22T11:40:00", "actual_end": "2026-07-22T12:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0625', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    4, 8, 'Tower Wagon',
    135, 144, '2026-07-23T12:25:00', '2026-07-23T14:49:00',
    'Completed', '{"job_id": "TDMS-H0625", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-07-23T12:25:00", "actual_end": "2026-07-23T14:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0626', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    60, 59, '2026-07-28T17:25:00', '2026-07-28T18:24:00',
    'Completed', '{"job_id": "TDMS-H0626", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 59, "actual_start": "2026-07-28T17:25:00", "actual_end": "2026-07-28T18:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0627', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'AHH-QRP', 'Ahmedgarh - Qila Raipur', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'Medium',
    5, 7, 'Tower Wagon',
    75, 86, '2026-07-29T03:45:00', '2026-07-29T05:11:00',
    'Completed', '{"job_id": "TDMS-H0627", "division": "UMB", "section": "DUI-LDH", "block_section": "AHH-QRP", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "Medium", "overdue_days": 5, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 86, "actual_start": "2026-07-29T03:45:00", "actual_end": "2026-07-29T05:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0628', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    2, 5, 'Inspection Vehicle',
    90, 82, '2026-07-30T03:40:00', '2026-07-30T05:02:00',
    'Completed', '{"job_id": "TDMS-H0628", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 82, "actual_start": "2026-07-30T03:40:00", "actual_end": "2026-07-30T05:02:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0629', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'AHH-QRP', 'Ahmedgarh - Qila Raipur', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    2, 4, 'Ladder & Contact Burnisher',
    90, 110, '2026-08-05T12:45:00', '2026-08-05T14:35:00',
    'Completed', '{"job_id": "TDMS-H0629", "division": "UMB", "section": "DUI-LDH", "block_section": "AHH-QRP", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 110, "actual_start": "2026-08-05T12:45:00", "actual_end": "2026-08-05T14:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0630', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    4, 9, 'Tower Wagon',
    135, 144, '2026-08-06T03:30:00', '2026-08-06T05:54:00',
    'Completed', '{"job_id": "TDMS-H0630", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 144, "actual_start": "2026-08-06T03:30:00", "actual_end": "2026-08-06T05:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0631', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'High',
    3, 7, 'Tower Wagon',
    105, 117, '2026-08-07T16:55:00', '2026-08-07T18:52:00',
    'Completed', '{"job_id": "TDMS-H0631", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-08-07T16:55:00", "actual_end": "2026-08-07T18:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0632', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    0, 6, 'Tower Wagon',
    105, 118, '2026-08-08T00:35:00', '2026-08-08T02:33:00',
    'Completed', '{"job_id": "TDMS-H0632", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-08-08T00:35:00", "actual_end": "2026-08-08T02:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0633', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'MET-AHH', 'Malerkotla - Ahmedgarh', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    2, 6, 'CB Timing Analyzer',
    150, 141, '2026-08-08T13:20:00', '2026-08-08T15:41:00',
    'Completed', '{"job_id": "TDMS-H0633", "division": "UMB", "section": "DUI-LDH", "block_section": "MET-AHH", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 141, "actual_start": "2026-08-08T13:20:00", "actual_end": "2026-08-08T15:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0634', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'AHH-QRP', 'Ahmedgarh - Qila Raipur', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    0, 8, 'Oil Filtration Plant',
    195, 204, '2026-08-09T17:50:00', '2026-08-09T21:14:00',
    'Completed', '{"job_id": "TDMS-H0634", "division": "UMB", "section": "DUI-LDH", "block_section": "AHH-QRP", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 204, "actual_start": "2026-08-09T17:50:00", "actual_end": "2026-08-09T21:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0635', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'High', 'High',
    0, 7, 'Tower Wagon',
    105, 113, '2026-08-10T11:10:00', '2026-08-10T13:03:00',
    'Completed', '{"job_id": "TDMS-H0635", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-08-10T11:10:00", "actual_end": "2026-08-10T13:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0636', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    2, 6, 'Tower Wagon',
    120, 116, '2026-08-14T14:15:00', '2026-08-14T16:11:00',
    'Completed', '{"job_id": "TDMS-H0636", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 116, "actual_start": "2026-08-14T14:15:00", "actual_end": "2026-08-14T16:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0637', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    0, 7, 'Tower Wagon',
    120, 116, '2026-08-23T11:40:00', '2026-08-23T13:36:00',
    'Completed', '{"job_id": "TDMS-H0637", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 116, "actual_start": "2026-08-23T11:40:00", "actual_end": "2026-08-23T13:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0638', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'QRP-LDH', 'Qila Raipur - Ludhiana', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    4, 8, 'Tower Wagon',
    135, 131, '2026-08-30T12:25:00', '2026-08-30T14:36:00',
    'Completed', '{"job_id": "TDMS-H0638", "division": "UMB", "section": "DUI-LDH", "block_section": "QRP-LDH", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 131, "actual_start": "2026-08-30T12:25:00", "actual_end": "2026-08-30T14:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0639', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'AHH-QRP', 'Ahmedgarh - Qila Raipur', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    1, 4, 'Secondary Injection Test Set',
    75, 93, '2026-08-31T14:55:00', '2026-08-31T16:28:00',
    'Completed', '{"job_id": "TDMS-H0639", "division": "UMB", "section": "DUI-LDH", "block_section": "AHH-QRP", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 75, "actual_duration_min": 93, "actual_start": "2026-08-31T14:55:00", "actual_end": "2026-08-31T16:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0640', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'DUI-LDH', 'DUI–LDH (Dhuri–Ludhiana)', 'DUI-MET', 'Dhuri - Malerkotla', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 5, 'Inspection Vehicle',
    45, 55, '2026-09-03T17:55:00', '2026-09-03T18:50:00',
    'Completed', '{"job_id": "TDMS-H0640", "division": "UMB", "section": "DUI-LDH", "block_section": "DUI-MET", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 55, "actual_start": "2026-09-03T17:55:00", "actual_end": "2026-09-03T18:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0641', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'Medium',
    0, 4, 'Inspection Vehicle',
    60, 69, '2026-07-04T13:45:00', '2026-07-04T14:54:00',
    'Completed', '{"job_id": "TDMS-H0641", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 69, "actual_start": "2026-07-04T13:45:00", "actual_end": "2026-07-04T14:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0642', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'High',
    0, 4, 'Inspection Vehicle',
    60, 74, '2026-07-07T02:15:00', '2026-07-07T03:29:00',
    'Completed', '{"job_id": "TDMS-H0642", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 74, "actual_start": "2026-07-07T02:15:00", "actual_end": "2026-07-07T03:29:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0643', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'MRND-RPAR', 'Morinda - Rupnagar', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'High', 'High',
    2, 4, 'Tower Wagon',
    75, 74, '2026-07-07T16:10:00', '2026-07-07T17:24:00',
    'Completed', '{"job_id": "TDMS-H0643", "division": "UMB", "section": "SIR-NLDM", "block_section": "MRND-RPAR", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 74, "actual_start": "2026-07-07T16:10:00", "actual_end": "2026-07-07T17:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0644', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    75, 97, '2026-07-09T11:05:00', '2026-07-09T12:42:00',
    'Completed', '{"job_id": "TDMS-H0644", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 97, "actual_start": "2026-07-09T11:05:00", "actual_end": "2026-07-09T12:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0645', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'Critical',
    1, 3, 'Secondary Injection Test Set',
    105, 113, '2026-07-11T01:50:00', '2026-07-11T03:43:00',
    'Completed', '{"job_id": "TDMS-H0645", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-07-11T01:50:00", "actual_end": "2026-07-11T03:43:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0646', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    1, 9, 'Tower Wagon',
    135, 140, '2026-07-18T17:00:00', '2026-07-18T19:20:00',
    'Completed', '{"job_id": "TDMS-H0646", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 140, "actual_start": "2026-07-18T17:00:00", "actual_end": "2026-07-18T19:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0647', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Medium', 'Medium',
    0, 5, 'Inspection Vehicle',
    75, 94, '2026-07-22T14:15:00', '2026-07-22T15:49:00',
    'Completed', '{"job_id": "TDMS-H0647", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 94, "actual_start": "2026-07-22T14:15:00", "actual_end": "2026-07-22T15:49:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0648', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'High',
    3, 5, 'Ladder & Tension Meter',
    60, 61, '2026-07-24T15:20:00', '2026-07-24T16:21:00',
    'Completed', '{"job_id": "TDMS-H0648", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 60, "actual_duration_min": 61, "actual_start": "2026-07-24T15:20:00", "actual_end": "2026-07-24T16:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0649', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'MRND-RPAR', 'Morinda - Rupnagar', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    4, 7, 'Oil Filtration Plant',
    165, 175, '2026-07-26T11:00:00', '2026-07-26T13:55:00',
    'Completed', '{"job_id": "TDMS-H0649", "division": "UMB", "section": "SIR-NLDM", "block_section": "MRND-RPAR", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 4, "crew_size": 7, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 175, "actual_start": "2026-07-26T11:00:00", "actual_end": "2026-07-26T13:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0650', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Low', 'High',
    0, 5, 'Tower Wagon',
    90, 110, '2026-07-27T04:25:00', '2026-07-27T06:15:00',
    'Completed', '{"job_id": "TDMS-H0650", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 110, "actual_start": "2026-07-27T04:25:00", "actual_end": "2026-07-27T06:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0651', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Critical', 'Medium',
    6, 6, 'Tower Wagon',
    105, 96, '2026-07-28T02:05:00', '2026-07-28T03:41:00',
    'Completed', '{"job_id": "TDMS-H0651", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Medium", "overdue_days": 6, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 96, "actual_start": "2026-07-28T02:05:00", "actual_end": "2026-07-28T03:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0652', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    2, 6, 'Tower Wagon',
    105, 113, '2026-07-29T00:00:00', '2026-07-29T01:53:00',
    'Completed', '{"job_id": "TDMS-H0652", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 113, "actual_start": "2026-07-29T00:00:00", "actual_end": "2026-07-29T01:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0653', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'MRND-RPAR', 'Morinda - Rupnagar', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    4, 4, 'CB Timing Analyzer',
    120, 120, '2026-07-31T13:55:00', '2026-07-31T15:55:00',
    'Completed', '{"job_id": "TDMS-H0653", "division": "UMB", "section": "SIR-NLDM", "block_section": "MRND-RPAR", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 120, "actual_start": "2026-07-31T13:55:00", "actual_end": "2026-07-31T15:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0654', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'High',
    4, 5, 'Tower Wagon',
    120, 121, '2026-08-03T13:30:00', '2026-08-03T15:31:00',
    'Completed', '{"job_id": "TDMS-H0654", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "High", "overdue_days": 4, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 121, "actual_start": "2026-08-03T13:30:00", "actual_end": "2026-08-03T15:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0655', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'High',
    3, 6, 'Tower Wagon',
    105, 122, '2026-08-07T00:50:00', '2026-08-07T02:52:00',
    'Completed', '{"job_id": "TDMS-H0655", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 122, "actual_start": "2026-08-07T00:50:00", "actual_end": "2026-08-07T02:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0656', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'SIR-MRND', 'Sirhind - Morinda', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    3, 9, 'Tower Wagon',
    150, 171, '2026-08-09T13:55:00', '2026-08-09T16:46:00',
    'Completed', '{"job_id": "TDMS-H0656", "division": "UMB", "section": "SIR-NLDM", "block_section": "SIR-MRND", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 171, "actual_start": "2026-08-09T13:55:00", "actual_end": "2026-08-09T16:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0657', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Critical',
    1, 8, 'Tower Wagon',
    135, 143, '2026-08-09T16:10:00', '2026-08-09T18:33:00',
    'Completed', '{"job_id": "TDMS-H0657", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 143, "actual_start": "2026-08-09T16:10:00", "actual_end": "2026-08-09T18:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0658', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 8, 'Tower Wagon',
    165, 170, '2026-08-14T04:40:00', '2026-08-14T07:30:00',
    'Completed', '{"job_id": "TDMS-H0658", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 170, "actual_start": "2026-08-14T04:40:00", "actual_end": "2026-08-14T07:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0659', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    5, 4, 'CB Timing Analyzer',
    120, 111, '2026-08-15T12:50:00', '2026-08-15T14:41:00',
    'Completed', '{"job_id": "TDMS-H0659", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 5, "crew_size": 4, "equipment": "CB Timing Analyzer", "requested_duration_min": 120, "actual_duration_min": 111, "actual_start": "2026-08-15T12:50:00", "actual_end": "2026-08-15T14:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0660', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'High', 'Medium',
    1, 4, 'RTU Diagnostic Terminal',
    60, 53, '2026-08-23T04:40:00', '2026-08-23T05:33:00',
    'Completed', '{"job_id": "TDMS-H0660", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "High", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 60, "actual_duration_min": 53, "actual_start": "2026-08-23T04:40:00", "actual_end": "2026-08-23T05:33:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0661', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'Medium',
    0, 4, 'Ladder & Contact Burnisher',
    75, 78, '2026-08-23T12:30:00', '2026-08-23T13:48:00',
    'Completed', '{"job_id": "TDMS-H0661", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 75, "actual_duration_min": 78, "actual_start": "2026-08-23T12:30:00", "actual_end": "2026-08-23T13:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0662', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    3, 5, 'Ladder & Tension Meter',
    75, 87, '2026-08-25T13:25:00', '2026-08-25T14:52:00',
    'Completed', '{"job_id": "TDMS-H0662", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 87, "actual_start": "2026-08-25T13:25:00", "actual_end": "2026-08-25T14:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0663', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'MRND-RPAR', 'Morinda - Rupnagar', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'High', 'High',
    1, 3, 'Secondary Injection Test Set',
    120, 117, '2026-08-27T13:55:00', '2026-08-27T15:52:00',
    'Completed', '{"job_id": "TDMS-H0663", "division": "UMB", "section": "SIR-NLDM", "block_section": "MRND-RPAR", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 117, "actual_start": "2026-08-27T13:55:00", "actual_end": "2026-08-27T15:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0664', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    0, 3, 'Inspection Vehicle',
    90, 80, '2026-08-27T16:40:00', '2026-08-27T18:00:00',
    'Completed', '{"job_id": "TDMS-H0664", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 80, "actual_start": "2026-08-27T16:40:00", "actual_end": "2026-08-27T18:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0665', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'RPAR-KART', 'Rupnagar - Kiratpur Sahib', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    2, 4, 'Inspection Vehicle',
    45, 40, '2026-08-28T15:20:00', '2026-08-28T16:00:00',
    'Completed', '{"job_id": "TDMS-H0665", "division": "UMB", "section": "SIR-NLDM", "block_section": "RPAR-KART", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-28T15:20:00", "actual_end": "2026-08-28T16:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0666', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'KART-ANSB', 'Kiratpur Sahib - Anandpur Sahib', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'Critical', 'Critical',
    1, 6, 'Tower Wagon',
    150, 156, '2026-08-30T12:10:00', '2026-08-30T14:46:00',
    'Completed', '{"job_id": "TDMS-H0666", "division": "UMB", "section": "SIR-NLDM", "block_section": "KART-ANSB", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 156, "actual_start": "2026-08-30T12:10:00", "actual_end": "2026-08-30T14:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0667', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-NLDM', 'SIR–NLDM (Sirhind–Nangal Dam)', 'ANSB-NLDM', 'Anandpur Sahib - Nangal Dam', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 5, 'Earth Tester & Bonding Kit',
    60, 58, '2026-09-01T17:00:00', '2026-09-01T17:58:00',
    'Completed', '{"job_id": "TDMS-H0667", "division": "UMB", "section": "SIR-NLDM", "block_section": "ANSB-NLDM", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 5, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 58, "actual_start": "2026-09-01T17:00:00", "actual_end": "2026-09-01T17:58:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0668', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    0, 4, 'Inspection Vehicle',
    45, 52, '2026-07-03T01:20:00', '2026-07-03T02:12:00',
    'Completed', '{"job_id": "TDMS-H0668", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 52, "actual_start": "2026-07-03T01:20:00", "actual_end": "2026-07-03T02:12:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0669', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    3, 5, 'Tower Wagon',
    120, 129, '2026-07-05T04:10:00', '2026-07-05T06:19:00',
    'Completed', '{"job_id": "TDMS-H0669", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 129, "actual_start": "2026-07-05T04:10:00", "actual_end": "2026-07-05T06:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0670', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    1, 6, 'SF6 Gas Filling Kit',
    105, 117, '2026-07-05T15:45:00', '2026-07-05T17:42:00',
    'Completed', '{"job_id": "TDMS-H0670", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 1, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-07-05T15:45:00", "actual_end": "2026-07-05T17:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0671', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    3, 8, 'Tower Wagon',
    150, 155, '2026-07-09T15:00:00', '2026-07-09T17:35:00',
    'Completed', '{"job_id": "TDMS-H0671", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 155, "actual_start": "2026-07-09T15:00:00", "actual_end": "2026-07-09T17:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0672', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    1, 5, 'Tower Wagon',
    75, 91, '2026-07-12T11:00:00', '2026-07-12T12:31:00',
    'Completed', '{"job_id": "TDMS-H0672", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 91, "actual_start": "2026-07-12T11:00:00", "actual_end": "2026-07-12T12:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0673', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'MTPR-UHL', 'Mehatpur - Una Himachal', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 7, 'Tower Wagon',
    165, 175, '2026-07-13T15:25:00', '2026-07-13T18:20:00',
    'Completed', '{"job_id": "TDMS-H0673", "division": "UMB", "section": "SIR-AADR", "block_section": "MTPR-UHL", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 175, "actual_start": "2026-07-13T15:25:00", "actual_end": "2026-07-13T18:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0674', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    2, 5, 'Tower Wagon',
    60, 60, '2026-07-15T11:35:00', '2026-07-15T12:35:00',
    'Completed', '{"job_id": "TDMS-H0674", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 60, "actual_duration_min": 60, "actual_start": "2026-07-15T11:35:00", "actual_end": "2026-07-15T12:35:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0675', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    2, 8, 'Tower Wagon',
    150, 172, '2026-07-15T12:05:00', '2026-07-15T14:57:00',
    'Completed', '{"job_id": "TDMS-H0675", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 2, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 172, "actual_start": "2026-07-15T12:05:00", "actual_end": "2026-07-15T14:57:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0676', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'MTPR-UHL', 'Mehatpur - Una Himachal', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'High',
    2, 9, 'Tower Wagon',
    105, 125, '2026-07-15T15:10:00', '2026-07-15T17:15:00',
    'Completed', '{"job_id": "TDMS-H0676", "division": "UMB", "section": "SIR-AADR", "block_section": "MTPR-UHL", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 9, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 125, "actual_start": "2026-07-15T15:10:00", "actual_end": "2026-07-15T17:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0677', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'High', 'Medium',
    0, 3, 'Earth Tester & Bonding Kit',
    90, 99, '2026-07-21T02:05:00', '2026-07-21T03:44:00',
    'Completed', '{"job_id": "TDMS-H0677", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 90, "actual_duration_min": 99, "actual_start": "2026-07-21T02:05:00", "actual_end": "2026-07-21T03:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0678', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'MTPR-UHL', 'Mehatpur - Una Himachal', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Critical',
    0, 4, 'Tower Wagon',
    105, 106, '2026-07-22T12:10:00', '2026-07-22T13:56:00',
    'Completed', '{"job_id": "TDMS-H0678", "division": "UMB", "section": "SIR-AADR", "block_section": "MTPR-UHL", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 106, "actual_start": "2026-07-22T12:10:00", "actual_end": "2026-07-22T13:56:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0679', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'High',
    0, 5, 'Tower Wagon',
    105, 110, '2026-07-23T14:05:00', '2026-07-23T15:55:00',
    'Completed', '{"job_id": "TDMS-H0679", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 110, "actual_start": "2026-07-23T14:05:00", "actual_end": "2026-07-23T15:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0680', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    1, 3, 'Inspection Vehicle',
    45, 61, '2026-07-31T15:30:00', '2026-07-31T16:31:00',
    'Completed', '{"job_id": "TDMS-H0680", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 61, "actual_start": "2026-07-31T15:30:00", "actual_end": "2026-07-31T16:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0681', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'Critical', 'Critical',
    3, 6, 'Tower Wagon',
    150, 157, '2026-08-06T00:25:00', '2026-08-06T03:02:00',
    'Completed', '{"job_id": "TDMS-H0681", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 157, "actual_start": "2026-08-06T00:25:00", "actual_end": "2026-08-06T03:02:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0682', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Low', 'Critical',
    5, 5, 'Tower Wagon',
    135, 151, '2026-08-09T14:35:00', '2026-08-09T17:06:00',
    'Completed', '{"job_id": "TDMS-H0682", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Low", "criticality": "Critical", "overdue_days": 5, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 151, "actual_start": "2026-08-09T14:35:00", "actual_end": "2026-08-09T17:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0683', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'MTPR-UHL', 'Mehatpur - Una Himachal', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    105, 122, '2026-08-13T04:35:00', '2026-08-13T06:37:00',
    'Completed', '{"job_id": "TDMS-H0683", "division": "UMB", "section": "SIR-AADR", "block_section": "MTPR-UHL", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 122, "actual_start": "2026-08-13T04:35:00", "actual_end": "2026-08-13T06:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0684', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'MTPR-UHL', 'Mehatpur - Una Himachal', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'Critical',
    0, 5, 'Tower Wagon',
    90, 85, '2026-08-15T15:35:00', '2026-08-15T17:00:00',
    'Completed', '{"job_id": "TDMS-H0684", "division": "UMB", "section": "SIR-AADR", "block_section": "MTPR-UHL", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 85, "actual_start": "2026-08-15T15:35:00", "actual_end": "2026-08-15T17:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0685', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'High',
    2, 8, 'Oil Filtration Plant',
    195, 209, '2026-08-19T04:15:00', '2026-08-19T07:44:00',
    'Completed', '{"job_id": "TDMS-H0685", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 195, "actual_duration_min": 209, "actual_start": "2026-08-19T04:15:00", "actual_end": "2026-08-19T07:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0686', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    1, 6, 'Tower Wagon',
    75, 76, '2026-08-19T15:50:00', '2026-08-19T17:06:00',
    'Completed', '{"job_id": "TDMS-H0686", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 76, "actual_start": "2026-08-19T15:50:00", "actual_end": "2026-08-19T17:06:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0687', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'CHTL-AADR', 'Churaru Takrala - Amb Andaura', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'Medium', 'Medium',
    1, 5, 'Ladder & Tension Meter',
    75, 71, '2026-08-26T16:30:00', '2026-08-26T17:41:00',
    'Completed', '{"job_id": "TDMS-H0687", "division": "UMB", "section": "SIR-AADR", "block_section": "CHTL-AADR", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 71, "actual_start": "2026-08-26T16:30:00", "actual_end": "2026-08-26T17:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0688', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    1, 6, 'SF6 Gas Filling Kit',
    135, 156, '2026-08-29T13:25:00', '2026-08-29T16:01:00',
    'Completed', '{"job_id": "TDMS-H0688", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 156, "actual_start": "2026-08-29T13:25:00", "actual_end": "2026-08-29T16:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0689', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    90, 109, '2026-08-29T13:35:00', '2026-08-29T15:24:00',
    'Completed', '{"job_id": "TDMS-H0689", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-08-29T13:35:00", "actual_end": "2026-08-29T15:24:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0690', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'UHL-CHTL', 'Una Himachal - Churaru Takrala', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'High', 'Critical',
    0, 8, 'Oil Filtration Plant',
    165, 185, '2026-08-29T14:15:00', '2026-08-29T17:20:00',
    'Completed', '{"job_id": "TDMS-H0690", "division": "UMB", "section": "SIR-AADR", "block_section": "UHL-CHTL", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Oil Filtration Plant", "requested_duration_min": 165, "actual_duration_min": 185, "actual_start": "2026-08-29T14:15:00", "actual_end": "2026-08-29T17:20:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0691', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SIR-AADR', 'SIR–AADR (Sirhind–Amb Andaura)', 'NLDM-MTPR', 'Nangal Dam - Mehatpur', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    2, 7, 'Tower Wagon',
    135, 141, '2026-08-31T02:25:00', '2026-08-31T04:46:00',
    'Completed', '{"job_id": "TDMS-H0691", "division": "UMB", "section": "SIR-AADR", "block_section": "NLDM-MTPR", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 141, "actual_start": "2026-08-31T02:25:00", "actual_end": "2026-08-31T04:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0692', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'DN_MAIN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'High',
    3, 4, 'Earth Tester & Bonding Kit',
    75, 70, '2026-07-04T17:45:00', '2026-07-04T18:55:00',
    'Completed', '{"job_id": "TDMS-H0692", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "DN_MAIN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "High", "overdue_days": 3, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-07-04T17:45:00", "actual_end": "2026-07-04T18:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0693', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'NBA-SEQ', 'Nabha - Sekha', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'Low',
    1, 4, 'Inspection Vehicle',
    90, 93, '2026-07-05T16:35:00', '2026-07-05T18:08:00',
    'Completed', '{"job_id": "TDMS-H0693", "division": "UMB", "section": "PTA-DUI", "block_section": "NBA-SEQ", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "Low", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 93, "actual_start": "2026-07-05T16:35:00", "actual_end": "2026-07-05T18:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0694', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    0, 4, 'Inspection Vehicle',
    75, 95, '2026-07-10T16:05:00', '2026-07-10T17:40:00',
    'Completed', '{"job_id": "TDMS-H0694", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 95, "actual_start": "2026-07-10T16:05:00", "actual_end": "2026-07-10T17:40:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0695', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'DN_MAIN',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    4, 6, 'Tower Wagon',
    105, 110, '2026-07-11T12:10:00', '2026-07-11T14:00:00',
    'Completed', '{"job_id": "TDMS-H0695", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "DN_MAIN", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 4, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 110, "actual_start": "2026-07-11T12:10:00", "actual_end": "2026-07-11T14:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0696', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'UP_MAIN',
    'OHE Wire Replacement', 'OHE', 'Medium', 'Critical',
    3, 8, 'Tower Wagon',
    105, 110, '2026-07-13T03:55:00', '2026-07-13T05:45:00',
    'Completed', '{"job_id": "TDMS-H0696", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "UP_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Critical", "overdue_days": 3, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 110, "actual_start": "2026-07-13T03:55:00", "actual_end": "2026-07-13T05:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0697', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'DN_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    2, 5, 'Ladder & Contact Burnisher',
    105, 111, '2026-07-17T12:20:00', '2026-07-17T14:11:00',
    'Completed', '{"job_id": "TDMS-H0697", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "DN_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-07-17T12:20:00", "actual_end": "2026-07-17T14:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0698', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    1, 3, 'Inspection Vehicle',
    60, 74, '2026-07-21T13:55:00', '2026-07-21T15:09:00',
    'Completed', '{"job_id": "TDMS-H0698", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 74, "actual_start": "2026-07-21T13:55:00", "actual_end": "2026-07-21T15:09:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0699', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'DN_MAIN',
    'Dropper Renewal', 'OHE', 'High', 'High',
    3, 5, 'Tower Wagon',
    90, 107, '2026-07-24T11:05:00', '2026-07-24T12:52:00',
    'Completed', '{"job_id": "TDMS-H0699", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "DN_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 107, "actual_start": "2026-07-24T11:05:00", "actual_end": "2026-07-24T12:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0700', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'DN_MAIN',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    2, 6, 'Ladder & Tension Meter',
    90, 106, '2026-07-29T16:00:00', '2026-07-29T17:46:00',
    'Completed', '{"job_id": "TDMS-H0700", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "DN_MAIN", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 6, "equipment": "Ladder & Tension Meter", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-07-29T16:00:00", "actual_end": "2026-07-29T17:46:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0701', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'NBA-SEQ', 'Nabha - Sekha', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Low',
    1, 3, 'Inspection Vehicle',
    90, 97, '2026-07-31T16:55:00', '2026-07-31T18:32:00',
    'Completed', '{"job_id": "TDMS-H0701", "division": "UMB", "section": "PTA-DUI", "block_section": "NBA-SEQ", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Low", "overdue_days": 1, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 97, "actual_start": "2026-07-31T16:55:00", "actual_end": "2026-07-31T18:32:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0702', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'UP_MAIN',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Low', 'Medium',
    1, 3, 'RTU Diagnostic Terminal',
    75, 85, '2026-08-05T03:45:00', '2026-08-05T05:10:00',
    'Completed', '{"job_id": "TDMS-H0702", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "UP_MAIN", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 75, "actual_duration_min": 85, "actual_start": "2026-08-05T03:45:00", "actual_end": "2026-08-05T05:10:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0703', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    5, 8, 'Tower Wagon',
    105, 96, '2026-08-06T12:25:00', '2026-08-06T14:01:00',
    'Completed', '{"job_id": "TDMS-H0703", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 5, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 96, "actual_start": "2026-08-06T12:25:00", "actual_end": "2026-08-06T14:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0704', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'NBA-SEQ', 'Nabha - Sekha', 'UP_MAIN',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'Critical',
    0, 5, 'Tower Wagon',
    105, 117, '2026-08-09T13:20:00', '2026-08-09T15:17:00',
    'Completed', '{"job_id": "TDMS-H0704", "division": "UMB", "section": "PTA-DUI", "block_section": "NBA-SEQ", "line": "UP_MAIN", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 117, "actual_start": "2026-08-09T13:20:00", "actual_end": "2026-08-09T15:17:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0705', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'Medium',
    0, 4, 'Tower Wagon',
    90, 88, '2026-08-11T16:50:00', '2026-08-11T18:18:00',
    'Completed', '{"job_id": "TDMS-H0705", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 88, "actual_start": "2026-08-11T16:50:00", "actual_end": "2026-08-11T18:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0706', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    0, 7, 'Tower Wagon',
    150, 144, '2026-08-16T14:55:00', '2026-08-16T17:19:00',
    'Completed', '{"job_id": "TDMS-H0706", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 144, "actual_start": "2026-08-16T14:55:00", "actual_end": "2026-08-16T17:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0707', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'NBA-SEQ', 'Nabha - Sekha', 'DN_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 43, '2026-08-17T13:55:00', '2026-08-17T14:38:00',
    'Completed', '{"job_id": "TDMS-H0707", "division": "UMB", "section": "PTA-DUI", "block_section": "NBA-SEQ", "line": "DN_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 43, "actual_start": "2026-08-17T13:55:00", "actual_end": "2026-08-17T14:38:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0708', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    120, 122, '2026-08-18T15:20:00', '2026-08-18T17:22:00',
    'Completed', '{"job_id": "TDMS-H0708", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 122, "actual_start": "2026-08-18T15:20:00", "actual_end": "2026-08-18T17:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0709', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'NBA-SEQ', 'Nabha - Sekha', 'UP_MAIN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'High',
    0, 3, 'Inspection Vehicle',
    75, 68, '2026-08-21T16:15:00', '2026-08-21T17:23:00',
    'Completed', '{"job_id": "TDMS-H0709", "division": "UMB", "section": "PTA-DUI", "block_section": "NBA-SEQ", "line": "UP_MAIN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 68, "actual_start": "2026-08-21T16:15:00", "actual_end": "2026-08-21T17:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0710', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'DN_MAIN',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Low', 'Medium',
    2, 6, 'Tower Wagon',
    90, 108, '2026-08-23T01:30:00', '2026-08-23T03:18:00',
    'Completed', '{"job_id": "TDMS-H0710", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "DN_MAIN", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 108, "actual_start": "2026-08-23T01:30:00", "actual_end": "2026-08-23T03:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0711', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'SEQ-DUI', 'Sekha - Dhuri', 'UP_MAIN',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    2, 5, 'Inspection Vehicle',
    75, 73, '2026-08-28T01:00:00', '2026-08-28T02:13:00',
    'Completed', '{"job_id": "TDMS-H0711", "division": "UMB", "section": "PTA-DUI", "block_section": "SEQ-DUI", "line": "UP_MAIN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 73, "actual_start": "2026-08-28T01:00:00", "actual_end": "2026-08-28T02:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0712', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'UP_MAIN',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Medium', 'High',
    0, 3, 'Inspection Vehicle',
    75, 70, '2026-08-29T11:45:00', '2026-08-29T12:55:00',
    'Completed', '{"job_id": "TDMS-H0712", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "UP_MAIN", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 70, "actual_start": "2026-08-29T11:45:00", "actual_end": "2026-08-29T12:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0713', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'DN_MAIN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'Critical', 'Critical',
    3, 4, 'SF6 Gas Filling Kit',
    135, 135, '2026-08-29T11:45:00', '2026-08-29T14:00:00',
    'Completed', '{"job_id": "TDMS-H0713", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "DN_MAIN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 4, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 135, "actual_start": "2026-08-29T11:45:00", "actual_end": "2026-08-29T14:00:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0714', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'UP_MAIN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'Medium',
    1, 5, 'Ladder & Contact Burnisher',
    105, 99, '2026-08-29T13:20:00', '2026-08-29T14:59:00',
    'Completed', '{"job_id": "TDMS-H0714", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "UP_MAIN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 105, "actual_duration_min": 99, "actual_start": "2026-08-29T13:20:00", "actual_end": "2026-08-29T14:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0715', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    0, 8, 'Tower Wagon',
    105, 100, '2026-08-31T14:05:00', '2026-08-31T15:45:00',
    'Completed', '{"job_id": "TDMS-H0715", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 100, "actual_start": "2026-08-31T14:05:00", "actual_end": "2026-08-31T15:45:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0716', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'DBN-NBA', 'Dhablan - Nabha', 'UP_MAIN',
    'Dropper Renewal', 'OHE', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    75, 74, '2026-09-06T03:30:00', '2026-09-06T04:44:00',
    'Completed', '{"job_id": "TDMS-H0716", "division": "UMB", "section": "PTA-DUI", "block_section": "DBN-NBA", "line": "UP_MAIN", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 74, "actual_start": "2026-09-06T03:30:00", "actual_end": "2026-09-06T04:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0717', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'PTA-DUI', 'PTA–DUI (Patiala–Dhuri)', 'PTA-DBN', 'Patiala - Dhablan', 'DN_MAIN',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'High', 'High',
    1, 5, 'Tower Wagon',
    120, 141, '2026-09-08T13:00:00', '2026-09-08T15:21:00',
    'Completed', '{"job_id": "TDMS-H0717", "division": "UMB", "section": "PTA-DUI", "block_section": "PTA-DBN", "line": "DN_MAIN", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 141, "actual_start": "2026-09-08T13:00:00", "actual_end": "2026-09-08T15:21:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0718', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'GDB-MOT', 'Giddarbaha - Malout', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    180, 186, '2026-07-06T13:35:00', '2026-07-06T16:41:00',
    'Completed', '{"job_id": "TDMS-H0718", "division": "UMB", "section": "BTI-ABS", "block_section": "GDB-MOT", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 186, "actual_start": "2026-07-06T13:35:00", "actual_end": "2026-07-06T16:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0719', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BTI-BHX', 'Bathinda - Balluana', 'SINGLE_LINE',
    'Auto Tensioning Device (ATD) Inspection & Calibration', 'ATD', 'High', 'High',
    1, 4, 'Ladder & Tension Meter',
    75, 97, '2026-07-06T15:15:00', '2026-07-06T16:52:00',
    'Completed', '{"job_id": "TDMS-H0719", "division": "UMB", "section": "BTI-ABS", "block_section": "BTI-BHX", "line": "SINGLE_LINE", "work_type": "Auto Tensioning Device (ATD) Inspection & Calibration", "asset_type": "ATD", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 4, "equipment": "Ladder & Tension Meter", "requested_duration_min": 75, "actual_duration_min": 97, "actual_start": "2026-07-06T15:15:00", "actual_end": "2026-07-06T16:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0720', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    90, 109, '2026-07-13T02:55:00', '2026-07-13T04:44:00',
    'Completed', '{"job_id": "TDMS-H0720", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 109, "actual_start": "2026-07-13T02:55:00", "actual_end": "2026-07-13T04:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0721', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    'Traction Transformer Oil Filtration & DGA', 'Traction Transformer', 'Critical', 'High',
    1, 6, 'Oil Filtration Plant',
    180, 198, '2026-07-16T03:00:00', '2026-07-16T06:18:00',
    'Completed', '{"job_id": "TDMS-H0721", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "Traction Transformer Oil Filtration & DGA", "asset_type": "Traction Transformer", "severity": "Critical", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Oil Filtration Plant", "requested_duration_min": 180, "actual_duration_min": 198, "actual_start": "2026-07-16T03:00:00", "actual_end": "2026-07-16T06:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0722', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'High',
    1, 6, 'CB Timing Analyzer',
    165, 185, '2026-07-17T03:45:00', '2026-07-17T06:50:00',
    'Completed', '{"job_id": "TDMS-H0722", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "CB Timing Analyzer", "requested_duration_min": 165, "actual_duration_min": 185, "actual_start": "2026-07-17T03:45:00", "actual_end": "2026-07-17T06:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0723', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    1, 8, 'Tower Wagon',
    180, 192, '2026-07-27T17:25:00', '2026-07-27T20:37:00',
    'Completed', '{"job_id": "TDMS-H0723", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 192, "actual_start": "2026-07-27T17:25:00", "actual_end": "2026-07-27T20:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0724', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    'Cantilever Assembly Overhaul & Adjustment', 'Cantilever', 'Medium', 'High',
    0, 7, 'Tower Wagon',
    105, 125, '2026-07-28T13:50:00', '2026-07-28T15:55:00',
    'Completed', '{"job_id": "TDMS-H0724", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "Cantilever Assembly Overhaul & Adjustment", "asset_type": "Cantilever", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 125, "actual_start": "2026-07-28T13:50:00", "actual_end": "2026-07-28T15:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0725', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'High', 'Medium',
    0, 4, 'Inspection Vehicle',
    75, 85, '2026-07-30T11:25:00', '2026-07-30T12:50:00',
    'Completed', '{"job_id": "TDMS-H0725", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "High", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 85, "actual_start": "2026-07-30T11:25:00", "actual_end": "2026-07-30T12:50:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0726', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BTI-BHX', 'Bathinda - Balluana', 'SINGLE_LINE',
    'Dropper Renewal', 'OHE', 'High', 'High',
    1, 5, 'Tower Wagon',
    90, 83, '2026-08-04T14:45:00', '2026-08-04T16:08:00',
    'Completed', '{"job_id": "TDMS-H0726", "division": "UMB", "section": "BTI-ABS", "block_section": "BTI-BHX", "line": "SINGLE_LINE", "work_type": "Dropper Renewal", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-08-04T14:45:00", "actual_end": "2026-08-04T16:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0727', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'GDB-MOT', 'Giddarbaha - Malout', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'High', 'Critical',
    1, 8, 'Tower Wagon',
    105, 108, '2026-08-04T17:20:00', '2026-08-04T19:08:00',
    'Completed', '{"job_id": "TDMS-H0727", "division": "UMB", "section": "BTI-ABS", "block_section": "GDB-MOT", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 108, "actual_start": "2026-08-04T17:20:00", "actual_end": "2026-08-04T19:08:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0728', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Insulator Replacement', 'Insulator', 'High', 'High',
    2, 7, 'Tower Wagon',
    120, 114, '2026-08-05T16:50:00', '2026-08-05T18:44:00',
    'Completed', '{"job_id": "TDMS-H0728", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 114, "actual_start": "2026-08-05T16:50:00", "actual_end": "2026-08-05T18:44:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0729', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'GDB-MOT', 'Giddarbaha - Malout', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    60, 59, '2026-08-08T17:15:00', '2026-08-08T18:14:00',
    'Completed', '{"job_id": "TDMS-H0729", "division": "UMB", "section": "BTI-ABS", "block_section": "GDB-MOT", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 59, "actual_start": "2026-08-08T17:15:00", "actual_end": "2026-08-08T18:14:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0730', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BTI-BHX', 'Bathinda - Balluana', 'SINGLE_LINE',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Low', 'High',
    3, 5, 'Tower Wagon',
    135, 138, '2026-08-10T01:55:00', '2026-08-10T04:13:00',
    'Completed', '{"job_id": "TDMS-H0730", "division": "UMB", "section": "BTI-ABS", "block_section": "BTI-BHX", "line": "SINGLE_LINE", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 3, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 135, "actual_duration_min": 138, "actual_start": "2026-08-10T01:55:00", "actual_end": "2026-08-10T04:13:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0731', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BTI-BHX', 'Bathinda - Balluana', 'SINGLE_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'High',
    0, 6, 'Tower Wagon',
    165, 165, '2026-08-11T16:10:00', '2026-08-11T18:55:00',
    'Completed', '{"job_id": "TDMS-H0731", "division": "UMB", "section": "BTI-ABS", "block_section": "BTI-BHX", "line": "SINGLE_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 165, "actual_duration_min": 165, "actual_start": "2026-08-11T16:10:00", "actual_end": "2026-08-11T18:55:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0732', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'GDB-MOT', 'Giddarbaha - Malout', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    0, 3, 'Inspection Vehicle',
    60, 63, '2026-08-14T12:50:00', '2026-08-14T13:53:00',
    'Completed', '{"job_id": "TDMS-H0732", "division": "UMB", "section": "BTI-ABS", "block_section": "GDB-MOT", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 63, "actual_start": "2026-08-14T12:50:00", "actual_end": "2026-08-14T13:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0733', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    2, 5, 'Tower Wagon',
    75, 92, '2026-08-14T17:30:00', '2026-08-14T19:02:00',
    'Completed', '{"job_id": "TDMS-H0733", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 92, "actual_start": "2026-08-14T17:30:00", "actual_end": "2026-08-14T19:02:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0734', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'Medium', 'High',
    1, 5, 'Ladder & Contact Burnisher',
    60, 72, '2026-08-16T03:35:00', '2026-08-16T04:47:00',
    'Completed', '{"job_id": "TDMS-H0734", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 72, "actual_start": "2026-08-16T03:35:00", "actual_end": "2026-08-16T04:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0735', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'Critical',
    7, 7, 'Tower Wagon',
    120, 120, '2026-08-21T01:30:00', '2026-08-21T03:30:00',
    'Completed', '{"job_id": "TDMS-H0735", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "Critical", "overdue_days": 7, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 120, "actual_start": "2026-08-21T01:30:00", "actual_end": "2026-08-21T03:30:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0736', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'High',
    1, 5, 'Inspection Vehicle',
    45, 53, '2026-08-24T13:55:00', '2026-08-24T14:48:00',
    'Completed', '{"job_id": "TDMS-H0736", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 53, "actual_start": "2026-08-24T13:55:00", "actual_end": "2026-08-24T14:48:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0737', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'Medium',
    1, 3, 'Secondary Injection Test Set',
    105, 118, '2026-08-25T01:20:00', '2026-08-25T03:18:00',
    'Completed', '{"job_id": "TDMS-H0737", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 3, "equipment": "Secondary Injection Test Set", "requested_duration_min": 105, "actual_duration_min": 118, "actual_start": "2026-08-25T01:20:00", "actual_end": "2026-08-25T03:18:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0738', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Section Insulator Inspection', 'OHE', 'Low', 'Low',
    0, 4, 'Inspection Vehicle',
    45, 40, '2026-08-26T11:35:00', '2026-08-26T12:15:00',
    'Completed', '{"job_id": "TDMS-H0738", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 40, "actual_start": "2026-08-26T11:35:00", "actual_end": "2026-08-26T12:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0739', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BTI-BHX', 'Bathinda - Balluana', 'SINGLE_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 3, 'Inspection Vehicle',
    60, 66, '2026-08-27T15:25:00', '2026-08-27T16:31:00',
    'Completed', '{"job_id": "TDMS-H0739", "division": "UMB", "section": "BTI-ABS", "block_section": "BTI-BHX", "line": "SINGLE_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 66, "actual_start": "2026-08-27T15:25:00", "actual_end": "2026-08-27T16:31:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0740', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'MOT-ABS', 'Malout - Abohar', 'SINGLE_LINE',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'High',
    0, 4, 'Ladder & Contact Burnisher',
    60, 61, '2026-09-04T13:40:00', '2026-09-04T14:41:00',
    'Completed', '{"job_id": "TDMS-H0740", "division": "UMB", "section": "BTI-ABS", "block_section": "MOT-ABS", "line": "SINGLE_LINE", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 4, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 60, "actual_duration_min": 61, "actual_start": "2026-09-04T13:40:00", "actual_end": "2026-09-04T14:41:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0741', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'BTI-ABS', 'BTI–Abohar side (Bathinda–Abohar)', 'BHX-GDB', 'Balluana - Giddarbaha', 'SINGLE_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    0, 6, 'Tower Wagon',
    105, 111, '2026-09-08T03:20:00', '2026-09-08T05:11:00',
    'Completed', '{"job_id": "TDMS-H0741", "division": "UMB", "section": "BTI-ABS", "block_section": "BHX-GDB", "line": "SINGLE_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 111, "actual_start": "2026-09-08T03:20:00", "actual_end": "2026-09-08T05:11:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0742', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'YARD_LINE',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    90, 83, '2026-07-03T00:05:00', '2026-07-03T01:28:00',
    'Completed', '{"job_id": "TDMS-H0742", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "YARD_LINE", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 90, "actual_duration_min": 83, "actual_start": "2026-07-03T00:05:00", "actual_end": "2026-07-03T01:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0743', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'Jumper Wire (G-Jumper & In-Span) Replacement', 'OHE', 'Medium', 'Medium',
    1, 4, 'Tower Wagon',
    90, 106, '2026-07-04T15:50:00', '2026-07-04T17:36:00',
    'Completed', '{"job_id": "TDMS-H0743", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "Jumper Wire (G-Jumper & In-Span) Replacement", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-07-04T15:50:00", "actual_end": "2026-07-04T17:36:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0744', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 5, 'Inspection Vehicle',
    75, 85, '2026-07-07T11:40:00', '2026-07-07T13:05:00',
    'Completed', '{"job_id": "TDMS-H0744", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 85, "actual_start": "2026-07-07T11:40:00", "actual_end": "2026-07-07T13:05:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0745', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_DN',
    'Structure Bonding & Earth Continuity Testing', 'Earthing System', 'Low', 'Medium',
    0, 4, 'Earth Tester & Bonding Kit',
    60, 73, '2026-07-17T17:40:00', '2026-07-17T18:53:00',
    'Completed', '{"job_id": "TDMS-H0745", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_DN", "work_type": "Structure Bonding & Earth Continuity Testing", "asset_type": "Earthing System", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Earth Tester & Bonding Kit", "requested_duration_min": 60, "actual_duration_min": 73, "actual_start": "2026-07-17T17:40:00", "actual_end": "2026-07-17T18:53:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0746', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_DN',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    0, 4, 'Inspection Vehicle',
    60, 63, '2026-07-19T03:25:00', '2026-07-19T04:28:00',
    'Completed', '{"job_id": "TDMS-H0746", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_DN", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 60, "actual_duration_min": 63, "actual_start": "2026-07-19T03:25:00", "actual_end": "2026-07-19T04:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0747', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'YARD_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Medium',
    1, 4, 'Inspection Vehicle',
    45, 67, '2026-07-19T12:30:00', '2026-07-19T13:37:00',
    'Completed', '{"job_id": "TDMS-H0747", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "YARD_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 1, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 67, "actual_start": "2026-07-19T12:30:00", "actual_end": "2026-07-19T13:37:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0748', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'YARD_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Medium', 'High',
    1, 5, 'Tower Wagon',
    120, 121, '2026-07-20T01:50:00', '2026-07-20T03:51:00',
    'Completed', '{"job_id": "TDMS-H0748", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "YARD_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 121, "actual_start": "2026-07-20T01:50:00", "actual_end": "2026-07-20T03:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0749', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'KJGY-BAE', 'Khanalampura Yard - Baliakheri', 'FREIGHT_UP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'Medium',
    0, 6, 'Tower Wagon',
    120, 132, '2026-07-23T01:10:00', '2026-07-23T03:22:00',
    'Completed', '{"job_id": "TDMS-H0749", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "KJGY-BAE", "line": "FREIGHT_UP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 132, "actual_start": "2026-07-23T01:10:00", "actual_end": "2026-07-23T03:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0750', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_DN',
    '25 kV Vacuum Circuit Breaker (VCB) Overhaul', 'Circuit Breaker', 'High', 'Critical',
    1, 5, 'CB Timing Analyzer',
    150, 152, '2026-07-25T14:15:00', '2026-07-25T16:47:00',
    'Completed', '{"job_id": "TDMS-H0750", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_DN", "work_type": "25 kV Vacuum Circuit Breaker (VCB) Overhaul", "asset_type": "Circuit Breaker", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "CB Timing Analyzer", "requested_duration_min": 150, "actual_duration_min": 152, "actual_start": "2026-07-25T14:15:00", "actual_end": "2026-07-25T16:47:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0751', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'YARD_LINE',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'High', 'High',
    0, 5, 'Tower Wagon',
    75, 75, '2026-07-25T16:10:00', '2026-07-25T17:25:00',
    'Completed', '{"job_id": "TDMS-H0751", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "YARD_LINE", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "High", "criticality": "High", "overdue_days": 0, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 75, "actual_duration_min": 75, "actual_start": "2026-07-25T16:10:00", "actual_end": "2026-07-25T17:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0752', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'OHE Wire Replacement', 'OHE', 'Critical', 'High',
    5, 8, 'Tower Wagon',
    150, 162, '2026-07-27T11:40:00', '2026-07-27T14:22:00',
    'Completed', '{"job_id": "TDMS-H0752", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "OHE Wire Replacement", "asset_type": "OHE", "severity": "Critical", "criticality": "High", "overdue_days": 5, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 162, "actual_start": "2026-07-27T11:40:00", "actual_end": "2026-07-27T14:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0753', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'FREIGHT_UP',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'High', 'High',
    1, 7, 'Tower Wagon',
    90, 102, '2026-07-28T17:10:00', '2026-07-28T18:52:00',
    'Completed', '{"job_id": "TDMS-H0753", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "FREIGHT_UP", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 90, "actual_duration_min": 102, "actual_start": "2026-07-28T17:10:00", "actual_end": "2026-07-28T18:52:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0754', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'KJGY-BAE', 'Khanalampura Yard - Baliakheri', 'FREIGHT_UP',
    'Stay & Bracket Insulator Replacement', 'Insulator', 'Critical', 'Medium',
    3, 6, 'Tower Wagon',
    105, 104, '2026-08-03T04:15:00', '2026-08-03T05:59:00',
    'Completed', '{"job_id": "TDMS-H0754", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "KJGY-BAE", "line": "FREIGHT_UP", "work_type": "Stay & Bracket Insulator Replacement", "asset_type": "Insulator", "severity": "Critical", "criticality": "Medium", "overdue_days": 3, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 105, "actual_duration_min": 104, "actual_start": "2026-08-03T04:15:00", "actual_end": "2026-08-03T05:59:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0755', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'FREIGHT_DN',
    'Pole-Mounted Isolator Contact Cleaning & Alignment', 'Isolator', 'High', 'Critical',
    1, 5, 'Ladder & Contact Burnisher',
    90, 94, '2026-08-04T11:45:00', '2026-08-04T13:19:00',
    'Completed', '{"job_id": "TDMS-H0755", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "FREIGHT_DN", "work_type": "Pole-Mounted Isolator Contact Cleaning & Alignment", "asset_type": "Isolator", "severity": "High", "criticality": "Critical", "overdue_days": 1, "crew_size": 5, "equipment": "Ladder & Contact Burnisher", "requested_duration_min": 90, "actual_duration_min": 94, "actual_start": "2026-08-04T11:45:00", "actual_end": "2026-08-04T13:19:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0756', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'Protection Relay Calibration & Tripping Scheme Verification', 'Protection Relay', 'Medium', 'High',
    2, 4, 'Secondary Injection Test Set',
    120, 135, '2026-08-12T01:00:00', '2026-08-12T03:15:00',
    'Completed', '{"job_id": "TDMS-H0756", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "Protection Relay Calibration & Tripping Scheme Verification", "asset_type": "Protection Relay", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 4, "equipment": "Secondary Injection Test Set", "requested_duration_min": 120, "actual_duration_min": 135, "actual_start": "2026-08-12T01:00:00", "actual_end": "2026-08-12T03:15:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0757', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'OHE Foot Patrol & Current Collection Test', 'OHE', 'Low', 'Low',
    0, 3, 'Inspection Vehicle',
    75, 93, '2026-08-13T00:55:00', '2026-08-13T02:28:00',
    'Completed', '{"job_id": "TDMS-H0757", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "OHE Foot Patrol & Current Collection Test", "asset_type": "OHE", "severity": "Low", "criticality": "Low", "overdue_days": 0, "crew_size": 3, "equipment": "Inspection Vehicle", "requested_duration_min": 75, "actual_duration_min": 93, "actual_start": "2026-08-13T00:55:00", "actual_end": "2026-08-13T02:28:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0758', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'KJGY-BAE', 'Khanalampura Yard - Baliakheri', 'YARD_LINE',
    'SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics', 'SCADA', 'Medium', 'Medium',
    2, 4, 'RTU Diagnostic Terminal',
    90, 106, '2026-08-18T15:15:00', '2026-08-18T17:01:00',
    'Completed', '{"job_id": "TDMS-H0758", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "KJGY-BAE", "line": "YARD_LINE", "work_type": "SCADA Remote Terminal Unit (RTU) & Telemetry Diagnostics", "asset_type": "SCADA", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 4, "equipment": "RTU Diagnostic Terminal", "requested_duration_min": 90, "actual_duration_min": 106, "actual_start": "2026-08-18T15:15:00", "actual_end": "2026-08-18T17:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0759', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'KJGY-BAE', 'Khanalampura Yard - Baliakheri', 'FREIGHT_UP',
    'Section Insulator Inspection', 'OHE', 'Low', 'Medium',
    2, 5, 'Inspection Vehicle',
    45, 61, '2026-08-19T01:00:00', '2026-08-19T02:01:00',
    'Completed', '{"job_id": "TDMS-H0759", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "KJGY-BAE", "line": "FREIGHT_UP", "work_type": "Section Insulator Inspection", "asset_type": "OHE", "severity": "Low", "criticality": "Medium", "overdue_days": 2, "crew_size": 5, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 61, "actual_start": "2026-08-19T01:00:00", "actual_end": "2026-08-19T02:01:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0760', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_UP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    1, 6, 'Tower Wagon',
    120, 115, '2026-08-19T16:30:00', '2026-08-19T18:25:00',
    'Completed', '{"job_id": "TDMS-H0760", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_UP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 115, "actual_start": "2026-08-19T16:30:00", "actual_end": "2026-08-19T18:25:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0761', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'YARD_LINE',
    'Catenary Maintenance', 'OHE', 'Medium', 'Medium',
    2, 7, 'Tower Wagon',
    150, 141, '2026-08-24T02:55:00', '2026-08-24T05:16:00',
    'Completed', '{"job_id": "TDMS-H0761", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "YARD_LINE", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "Medium", "criticality": "Medium", "overdue_days": 2, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 141, "actual_start": "2026-08-24T02:55:00", "actual_end": "2026-08-24T05:16:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0762', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'YARD_LINE',
    'PTFE Neutral Section Overhaul & Arc Horn Check', 'Neutral Section', 'High', 'Critical',
    0, 8, 'Tower Wagon',
    150, 144, '2026-08-26T16:30:00', '2026-08-26T18:54:00',
    'Completed', '{"job_id": "TDMS-H0762", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "YARD_LINE", "work_type": "PTFE Neutral Section Overhaul & Arc Horn Check", "asset_type": "Neutral Section", "severity": "High", "criticality": "Critical", "overdue_days": 0, "crew_size": 8, "equipment": "Tower Wagon", "requested_duration_min": 150, "actual_duration_min": 144, "actual_start": "2026-08-26T16:30:00", "actual_end": "2026-08-26T18:54:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0763', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'FREIGHT_DN',
    'Interrupter (BM) Mechanism Servicing & SF6 Gas Check', 'Switchgear', 'High', 'High',
    1, 6, 'SF6 Gas Filling Kit',
    135, 153, '2026-08-29T14:30:00', '2026-08-29T17:03:00',
    'Completed', '{"job_id": "TDMS-H0763", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "FREIGHT_DN", "work_type": "Interrupter (BM) Mechanism Servicing & SF6 Gas Check", "asset_type": "Switchgear", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "SF6 Gas Filling Kit", "requested_duration_min": 135, "actual_duration_min": 153, "actual_start": "2026-08-29T14:30:00", "actual_end": "2026-08-29T17:03:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0764', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'BAE-DBD', 'Baliakheri - Deoband', 'FREIGHT_UP',
    'Contact Wire Height & Stagger Adjustment', 'OHE', 'Medium', 'High',
    2, 5, 'Tower Wagon',
    120, 132, '2026-09-01T14:10:00', '2026-09-01T16:22:00',
    'Completed', '{"job_id": "TDMS-H0764", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "BAE-DBD", "line": "FREIGHT_UP", "work_type": "Contact Wire Height & Stagger Adjustment", "asset_type": "OHE", "severity": "Medium", "criticality": "High", "overdue_days": 2, "crew_size": 5, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 132, "actual_start": "2026-09-01T14:10:00", "actual_end": "2026-09-01T16:22:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0765', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'KJGY-BAE', 'Khanalampura Yard - Baliakheri', 'FREIGHT_UP',
    'Section Insulator Overhauling & Replacement', 'Section Insulator', 'Critical', 'Critical',
    3, 7, 'Tower Wagon',
    120, 133, '2026-09-01T17:10:00', '2026-09-01T19:23:00',
    'Completed', '{"job_id": "TDMS-H0765", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "KJGY-BAE", "line": "FREIGHT_UP", "work_type": "Section Insulator Overhauling & Replacement", "asset_type": "Section Insulator", "severity": "Critical", "criticality": "Critical", "overdue_days": 3, "crew_size": 7, "equipment": "Tower Wagon", "requested_duration_min": 120, "actual_duration_min": 133, "actual_start": "2026-09-01T17:10:00", "actual_end": "2026-09-01T19:23:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0766', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_DN',
    'Composite Silicon Rubber Insulator Inspection', 'Insulator', 'Medium', 'Medium',
    0, 4, 'Inspection Vehicle',
    45, 66, '2026-09-05T03:45:00', '2026-09-05T04:51:00',
    'Completed', '{"job_id": "TDMS-H0766", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_DN", "work_type": "Composite Silicon Rubber Insulator Inspection", "asset_type": "Insulator", "severity": "Medium", "criticality": "Medium", "overdue_days": 0, "crew_size": 4, "equipment": "Inspection Vehicle", "requested_duration_min": 45, "actual_duration_min": 66, "actual_start": "2026-09-05T03:45:00", "actual_end": "2026-09-05T04:51:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;
INSERT INTO tdms_maintenance_history (
    job_id, source_system, department, zone, zone_code, division, division_name,
    section, section_display, block_section, block_section_name, line,
    work_type, asset_type, severity, criticality, overdue_days, crew_size, equipment,
    requested_duration_min, actual_duration_min, actual_start, actual_end,
    completion_status, payload
) VALUES (
    'TDMS-H0767', 'TDMS_ELECTRICAL_TRD', 'TRD',
    'NORTHERN RAILWAY', 'NR', 'UMB', 'Ambala',
    'SRE-KJGY-DBD', 'SRE–UDN / connecting routes (Saharanpur area)', 'SRE-KJGY', 'Saharanpur - Khanalampura Yard', 'FREIGHT_UP',
    'Catenary Maintenance', 'OHE', 'High', 'High',
    1, 6, 'Tower Wagon',
    180, 192, '2026-09-07T16:30:00', '2026-09-07T19:42:00',
    'Completed', '{"job_id": "TDMS-H0767", "division": "UMB", "section": "SRE-KJGY-DBD", "block_section": "SRE-KJGY", "line": "FREIGHT_UP", "work_type": "Catenary Maintenance", "asset_type": "OHE", "severity": "High", "criticality": "High", "overdue_days": 1, "crew_size": 6, "equipment": "Tower Wagon", "requested_duration_min": 180, "actual_duration_min": 192, "actual_start": "2026-09-07T16:30:00", "actual_end": "2026-09-07T19:42:00", "completion_status": "Completed"}'::jsonb
) ON CONFLICT (job_id) DO NOTHING;