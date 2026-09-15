-- =====================================================
-- NEON POSTGRESQL SCHEMA FOR IR SMMS SIGNAL & TELECOM
-- =====================================================
CREATE TABLE IF NOT EXISTS smms_signal_disconnections (
    disconnection_ref_id VARCHAR(64) PRIMARY KEY,
    source_system VARCHAR(32) NOT NULL,
    form_type VARCHAR(64) NOT NULL,
    division VARCHAR(64) NOT NULL,
    station_code VARCHAR(16) NOT NULL,
    station_name VARCHAR(64) NOT NULL,
    gear_type VARCHAR(64) NOT NULL,
    gear_id VARCHAR(64) NOT NULL,
    maintenance_nature TEXT NOT NULL,
    requires_traffic_block BOOLEAN NOT NULL,
    fouling_mark_infringed BOOLEAN NOT NULL,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_minutes INTEGER NOT NULL,
    crank_handle_locked BOOLEAN NOT NULL,
    payload JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_smms_div ON smms_signal_disconnections (division);
CREATE INDEX IF NOT EXISTS idx_smms_stn ON smms_signal_disconnections (station_code);
CREATE INDEX IF NOT EXISTS idx_smms_gear ON smms_signal_disconnections (gear_type);
CREATE INDEX IF NOT EXISTS idx_smms_date ON smms_signal_disconnections (slot_date);
CREATE INDEX IF NOT EXISTS idx_smms_payload ON smms_signal_disconnections USING gin (payload);

-- =====================================================
-- INSERT STATEMENTS
-- =====================================================
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0401', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'UDL', 'Andal Jn', 'Point Machine', 'Point No. 102B',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-08', '11:00', '12:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0401", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5048484", "designation": "SSE_SIGNAL_UDL_UDL", "contact": "9771487129"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "UDL", "station_name": "Andal Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 102B", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-8", "S-27"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-08", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0402', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'UKA', 'Ukhra', 'Electronic Interlocking (EI)', 'Gear Unit #237',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-08', '14:30', '16:30', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0402", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5037741", "designation": "SSE_SIGNAL_UDL_UKA", "contact": "9771497494"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "UKA", "station_name": "Ukhra", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #237", "interlocking_affected": "Interlocking panel for Ukhra yard", "signals_affected": ["S-3"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "14:30", "end_time": "16:30", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0403', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'PAW', 'Pandabeswar', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-4',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-08', '17:00', '18:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0403", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5068694", "designation": "SSE_SIGNAL_UDL_PAW", "contact": "9771482106"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "PAW", "station_name": "Pandabeswar", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-4", "interlocking_affected": "Block overlap detection & Track clearance for PAW yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "17:00", "end_time": "18:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0404', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'UDL', 'Andal Jn', 'Electronic Interlocking (EI)', 'Gear Unit #283',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-08', '11:00', '13:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0404", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5041982", "designation": "SSE_SIGNAL_STN_UDL", "contact": "9771427836"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "UDL", "station_name": "Andal Jn", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #283", "interlocking_affected": "Interlocking panel for Andal Jn yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "11:00", "end_time": "13:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0405', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'TOP', 'Tapasi', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-4',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-08', '14:30', '15:30', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0405", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5088056", "designation": "SSE_SIGNAL_STN_TOP", "contact": "9771491133"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "TOP", "station_name": "Tapasi", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-4", "interlocking_affected": "Block overlap detection & Track clearance for TOP yard", "signals_affected": ["S-11"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "14:30", "end_time": "15:30", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0406', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'IKRA', 'Ikrah Jn', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #298',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-08', '17:00', '17:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0406", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5084701", "designation": "SSE_SIGNAL_STN_IKRA", "contact": "9771453037"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "IKRA", "station_name": "Ikrah Jn", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #298", "interlocking_affected": "Interlocking panel for Ikrah Jn yard", "signals_affected": ["S-1"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "17:00", "end_time": "17:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0407', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'MDP', 'Madhupur Jn', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-10',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-08', '11:00', '12:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0407", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5050421", "designation": "SSE_SIGNAL_MDP_MDP", "contact": "9771418147"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "MDP", "station_name": "Madhupur Jn", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-10", "interlocking_affected": "Block overlap detection & Track clearance for MDP yard", "signals_affected": ["S-4"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "11:00", "end_time": "12:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0408', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'JGD', 'Jagdishpur', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #233',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-08', '14:30', '15:15', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0408", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5071002", "designation": "SSE_SIGNAL_MDP_JGD", "contact": "9771447733"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "JGD", "station_name": "Jagdishpur", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #233", "interlocking_affected": "Interlocking panel for Jagdishpur yard", "signals_affected": ["S-3"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "14:30", "end_time": "15:15", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0409', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'MMD', 'Maheshmunda', 'Interlocked Level Crossing Gate', 'LC Gate No. 57 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-08', '17:00', '18:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0409", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5061900", "designation": "SSE_SIGNAL_MDP_MMD", "contact": "9771433936"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "MMD", "station_name": "Maheshmunda", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 57 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 57", "signals_affected": ["G-4", "G-5"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-08", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0410', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'JSME', 'Jasidih Jn', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #239',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-09', '11:00', '11:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0410", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5082052", "designation": "SSE_SIGNAL_JSME_JSME", "contact": "9771471505"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "JSME", "station_name": "Jasidih Jn", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #239", "interlocking_affected": "Interlocking panel for Jasidih Jn yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "11:00", "end_time": "11:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0411', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'DGHR', 'Deoghar Jn', 'Interlocked Level Crossing Gate', 'LC Gate No. 45 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-09', '14:30', '16:00', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0411", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5036499", "designation": "SSE_SIGNAL_JSME_DGHR", "contact": "9771434977"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "DGHR", "station_name": "Deoghar Jn", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 45 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 45", "signals_affected": ["G-1", "G-6"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0412', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'JSME', 'Jasidih Jn', 'Interlocked Level Crossing Gate', 'LC Gate No. 85 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-09', '11:00', '12:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0412", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5086387", "designation": "SSE_SIGNAL_JSME_JSME", "contact": "9771480928"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "JSME", "station_name": "Jasidih Jn", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 85 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 85", "signals_affected": ["G-1", "G-8"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0413', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'DGHR', 'Deoghar Jn', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-23 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-09', '14:30', '15:10', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0413", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5053769", "designation": "SSE_SIGNAL_JSME_DGHR", "contact": "9771489718"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "DGHR", "station_name": "Deoghar Jn", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-23 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-23", "signals_affected": ["S-23"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "14:30", "end_time": "15:10", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0414', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'CNPR', 'Chandanpahari', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #252',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-09', '17:00', '18:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0414", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5070343", "designation": "SSE_SIGNAL_JSME_CNPR", "contact": "9771428217"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "CNPR", "station_name": "Chandanpahari", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #252", "interlocking_affected": "Interlocking panel for Chandanpahari yard", "signals_affected": ["S-5"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "17:00", "end_time": "18:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0415', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'DGHR', 'Deoghar Jn', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-5 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-09', '11:00', '11:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0415", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5055557", "designation": "SSE_SIGNAL_DGHR_DGHR", "contact": "9771450896"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "DGHR", "station_name": "Deoghar Jn", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-5 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-5", "signals_affected": ["S-5"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "11:00", "end_time": "11:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/ASN/2026/DISC/0416', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Asansol (ASN)',
    'KKRA', 'Kakwara', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #250',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-09', '14:30', '16:15', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/ASN/2026/DISC/0416", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5066368", "designation": "SSE_SIGNAL_DGHR_KKRA", "contact": "9771426199"}, "asset_location": {"division": "Asansol (ASN)", "station_code": "KKRA", "station_name": "Kakwara", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #250", "interlocking_affected": "Interlocking panel for Kakwara yard", "signals_affected": ["S-9"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-09", "start_time": "14:30", "end_time": "16:15", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0417', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'HWH', 'Howrah', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #276',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-10', '11:00', '12:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0417", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5033789", "designation": "SSE_SIGNAL_BWN_HWH", "contact": "9771488727"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "HWH", "station_name": "Howrah", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #276", "interlocking_affected": "Interlocking panel for Howrah yard", "signals_affected": ["S-1"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-10", "start_time": "11:00", "end_time": "12:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0418', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BLY', 'Bally', 'Point Machine', 'Point No. 139A',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-10', '14:30', '15:45', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0418", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5031606", "designation": "SSE_SIGNAL_BWN_BLY", "contact": "9771476397"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BLY", "station_name": "Bally", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 139A", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-4", "S-36"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-10", "start_time": "14:30", "end_time": "15:45", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0419', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BDC', 'Bandel Jn', 'Point Machine', 'Point No. 131A',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-10', '17:00', '18:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0419", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5045161", "designation": "SSE_SIGNAL_BWN_BDC", "contact": "9771486957"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BDC", "station_name": "Bandel Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 131A", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-12", "S-30"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-10", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0420', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'DKAE', 'Dankuni Jn', 'Point Machine', 'Point No. 102B',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-10', '11:00', '12:15', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0420", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5067725", "designation": "SSE_SIGNAL_DKAE_DKAE", "contact": "9771449768"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "DKAE", "station_name": "Dankuni Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 102B", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-7", "S-26"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-10", "start_time": "11:00", "end_time": "12:15", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0421', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'KQU', 'Kamarkundu', 'Point Machine', 'Point No. 119B',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-10', '14:30', '16:00', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0421", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5037857", "designation": "SSE_SIGNAL_DKAE_KQU", "contact": "9771447528"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "KQU", "station_name": "Kamarkundu", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 119B", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-12", "S-29"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-10", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0422', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'GRAE', 'Gurap', 'Electronic Interlocking (EI)', 'Gear Unit #207',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-10', '17:00', '19:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0422", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5037286", "designation": "SSE_SIGNAL_DKAE_GRAE", "contact": "9771415857"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "GRAE", "station_name": "Gurap", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #207", "interlocking_affected": "Interlocking panel for Gurap yard", "signals_affected": ["S-1"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-10", "start_time": "17:00", "end_time": "19:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0423', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'KAN', 'Khana Jn', 'Point Machine', 'Point No. 116',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-10', '11:00', '12:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0423", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5043238", "designation": "SSE_SIGNAL_RPH_KAN", "contact": "9771457745"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "KAN", "station_name": "Khana Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 116", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-8", "S-32"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-10", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0424', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BHP', 'Bolpur Shantiniketan', 'Electronic Interlocking (EI)', 'Gear Unit #269',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-10', '14:30', '16:30', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0424", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5061699", "designation": "SSE_SIGNAL_RPH_BHP", "contact": "9771441821"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BHP", "station_name": "Bolpur Shantiniketan", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #269", "interlocking_affected": "Interlocking panel for Bolpur Shantiniketan yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-10", "start_time": "14:30", "end_time": "16:30", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0425', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'SNT', 'Sainthia Jn', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-7',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-10', '17:00', '18:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0425", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5083738", "designation": "SSE_SIGNAL_RPH_SNT", "contact": "9771466929"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "SNT", "station_name": "Sainthia Jn", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-7", "interlocking_affected": "Block overlap detection & Track clearance for SNT yard", "signals_affected": ["S-11"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-10", "start_time": "17:00", "end_time": "18:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0426', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'RPH', 'Rampurhat Jn', 'Electronic Interlocking (EI)', 'Gear Unit #287',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-11', '11:00', '13:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0426", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5074318", "designation": "SSE_SIGNAL_RPH_RPH", "contact": "9771441642"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "RPH", "station_name": "Rampurhat Jn", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #287", "interlocking_affected": "Interlocking panel for Rampurhat Jn yard", "signals_affected": ["S-2"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "11:00", "end_time": "13:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0427', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'PRGR', 'Pinargaria', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-4',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-11', '14:30', '15:30', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0427", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5039619", "designation": "SSE_SIGNAL_RPH_PRGR", "contact": "9771428280"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "PRGR", "station_name": "Pinargaria", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-4", "interlocking_affected": "Block overlap detection & Track clearance for PRGR yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "14:30", "end_time": "15:30", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0428', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'SKIP', 'Shikaripara', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #243',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-11', '17:00', '17:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0428", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5061339", "designation": "SSE_SIGNAL_RPH_SKIP", "contact": "9771482551"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "SKIP", "station_name": "Shikaripara", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #243", "interlocking_affected": "Interlocking panel for Shikaripara yard", "signals_affected": ["S-9"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "17:00", "end_time": "17:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0429', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BDC', 'Bandel Jn', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-10',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-11', '11:00', '12:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0429", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5042279", "designation": "SSE_SIGNAL_AZ_BDC", "contact": "9771490508"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BDC", "station_name": "Bandel Jn", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-10", "interlocking_affected": "Block overlap detection & Track clearance for BDC yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "11:00", "end_time": "12:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0430', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'ABKA', 'Ambika Kalna', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #212',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-11', '14:30', '15:15', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0430", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5070587", "designation": "SSE_SIGNAL_AZ_ABKA", "contact": "9771468903"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "ABKA", "station_name": "Ambika Kalna", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #212", "interlocking_affected": "Interlocking panel for Ambika Kalna yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "14:30", "end_time": "15:15", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0431', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'NDAE', 'Nabadwip Dham', 'Interlocked Level Crossing Gate', 'LC Gate No. 66 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-11', '17:00', '18:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0431", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5055386", "designation": "SSE_SIGNAL_AZ_NDAE", "contact": "9771418860"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "NDAE", "station_name": "Nabadwip Dham", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 66 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 66", "signals_affected": ["G-2", "G-8"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0432', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'DKAE', 'Dankuni Jn', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #213',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-11', '11:00', '11:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0432", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5098666", "designation": "SSE_SIGNAL_DKAE_DKAE", "contact": "9771481382"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "DKAE", "station_name": "Dankuni Jn", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #213", "interlocking_affected": "Interlocking panel for Dankuni Jn yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "11:00", "end_time": "11:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0433', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BTNG', 'Bhattanagar', 'Interlocked Level Crossing Gate', 'LC Gate No. 41 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-11', '14:30', '16:00', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0433", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5098692", "designation": "SSE_SIGNAL_DKAE_BTNG", "contact": "9771424786"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BTNG", "station_name": "Bhattanagar", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 41 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 41", "signals_affected": ["G-2", "G-7"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-11", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0434', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'SHE', 'Sheoraphuli Jn', 'Interlocked Level Crossing Gate', 'LC Gate No. 68 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-12', '11:00', '12:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0434", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5085227", "designation": "SSE_SIGNAL_SHE_SHE", "contact": "9771498579"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "SHE", "station_name": "Sheoraphuli Jn", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 68 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 68", "signals_affected": ["G-1", "G-5"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0435', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'DEA', 'Diara', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-7 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-12', '14:30', '15:10', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0435", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5093472", "designation": "SSE_SIGNAL_SHE_DEA", "contact": "9771498164"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "DEA", "station_name": "Diara", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-7 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-7", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "14:30", "end_time": "15:10", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0436', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'HPL', 'Haripal', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #228',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-12', '17:00', '18:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0436", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5098280", "designation": "SSE_SIGNAL_SHE_HPL", "contact": "9771477191"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "HPL", "station_name": "Haripal", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #228", "interlocking_affected": "Interlocking panel for Haripal yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "17:00", "end_time": "18:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0437', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'BDC', 'Bandel Jn', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-5 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-12', '11:00', '11:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0437", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5067042", "designation": "SSE_SIGNAL_BDC_BDC", "contact": "9771458838"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "BDC", "station_name": "Bandel Jn", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-5 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-5", "signals_affected": ["S-5"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "11:00", "end_time": "11:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0438', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'HYG', 'Hooghly Ghat', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #257',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-12', '14:30', '16:15', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0438", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5051133", "designation": "SSE_SIGNAL_BDC_HYG", "contact": "9771480391"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "HYG", "station_name": "Hooghly Ghat", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #257", "interlocking_affected": "Interlocking panel for Hooghly Ghat yard", "signals_affected": ["S-9"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "14:30", "end_time": "16:15", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0439', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'AZ', 'Azimganj Jn', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #228',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-12', '11:00', '12:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0439", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5092979", "designation": "SSE_SIGNAL_AZ_AZ", "contact": "9771498695"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "AZ", "station_name": "Azimganj Jn", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #228", "interlocking_affected": "Interlocking panel for Azimganj Jn yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-12", "start_time": "11:00", "end_time": "12:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0440', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'SDI', 'Sagardighi', 'Point Machine', 'Point No. 111B',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-12', '14:30', '15:45', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0440", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5058569", "designation": "SSE_SIGNAL_AZ_SDI", "contact": "9771456347"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "SDI", "station_name": "Sagardighi", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 111B", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-6", "S-32"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-12", "start_time": "14:30", "end_time": "15:45", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/HWH/2026/DISC/0441', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Howrah (HWH)',
    'MGAE', 'Morgram', 'Point Machine', 'Point No. 103',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-12', '17:00', '18:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/HWH/2026/DISC/0441", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5035623", "designation": "SSE_SIGNAL_AZ_MGAE", "contact": "9771417162"}, "asset_location": {"division": "Howrah (HWH)", "station_code": "MGAE", "station_name": "Morgram", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 103", "interlocking_affected": "Common Loop to Platform Line No. 2", "signals_affected": ["S-10", "S-28"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-12", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0442', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UMB', 'Ambala Cantt Jn', 'Point Machine', 'Point No. 126A',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-13', '11:00', '12:15', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0442", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5073224", "designation": "SSE_SIGNAL_UMB_UMB", "contact": "9717674426"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UMB", "station_name": "Ambala Cantt Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 126A", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-4", "S-22"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-13", "start_time": "11:00", "end_time": "12:15", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0443', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'RPJ', 'Rajpura Jn', 'Point Machine', 'Point No. 127B',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-13', '14:30', '16:00', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0443", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5058098", "designation": "SSE_SIGNAL_UMB_RPJ", "contact": "9717631903"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "RPJ", "station_name": "Rajpura Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 127B", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-8", "S-35"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-13", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0444', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'SIR', 'Sirhind Jn', 'Electronic Interlocking (EI)', 'Gear Unit #249',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-13', '17:00', '19:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0444", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5085931", "designation": "SSE_SIGNAL_UMB_SIR", "contact": "9717688454"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "SIR", "station_name": "Sirhind Jn", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #249", "interlocking_affected": "Interlocking panel for Sirhind Jn yard", "signals_affected": ["S-8"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "17:00", "end_time": "19:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0445', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'LDH', 'Ludhiana Jn', 'Point Machine', 'Point No. 130',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-13', '11:00', '12:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0445", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5047365", "designation": "SSE_SIGNAL_LDH_LDH", "contact": "9717692148"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "LDH", "station_name": "Ludhiana Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 130", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-8", "S-28"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-13", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0446', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MLX', 'Mullanpur', 'Electronic Interlocking (EI)', 'Gear Unit #222',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-13', '14:30', '16:30', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0446", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5043035", "designation": "SSE_SIGNAL_LDH_MLX", "contact": "9717618330"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MLX", "station_name": "Mullanpur", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #222", "interlocking_affected": "Interlocking panel for Mullanpur yard", "signals_affected": ["S-3"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "14:30", "end_time": "16:30", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0447', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'JGN', 'Jagraon', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-9',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-13', '17:00', '18:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0447", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5041543", "designation": "SSE_SIGNAL_LDH_JGN", "contact": "9717649080"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "JGN", "station_name": "Jagraon", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-9", "interlocking_affected": "Block overlap detection & Track clearance for JGN yard", "signals_affected": ["S-4"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "17:00", "end_time": "18:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0448', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UMB', 'Ambala Cantt Jn', 'Electronic Interlocking (EI)', 'Gear Unit #273',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-13', '11:00', '13:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0448", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5081583", "designation": "SSE_SIGNAL_CDG_UMB", "contact": "9717620035"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UMB", "station_name": "Ambala Cantt Jn", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #273", "interlocking_affected": "Interlocking panel for Ambala Cantt Jn yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "11:00", "end_time": "13:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0449', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'LLU', 'Lalru', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-11',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-13', '14:30', '15:30', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0449", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5087459", "designation": "SSE_SIGNAL_CDG_LLU", "contact": "9717654817"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "LLU", "station_name": "Lalru", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-11", "interlocking_affected": "Block overlap detection & Track clearance for LLU yard", "signals_affected": ["S-8"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "14:30", "end_time": "15:30", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0450', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'CDG', 'Chandigarh Jn', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #285',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-13', '17:00', '17:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0450", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5093259", "designation": "SSE_SIGNAL_CDG_CDG", "contact": "9717696624"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "CDG", "station_name": "Chandigarh Jn", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #285", "interlocking_affected": "Interlocking panel for Chandigarh Jn yard", "signals_affected": ["S-5"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-13", "start_time": "17:00", "end_time": "17:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0451', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'KLK', 'Kalka', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-1',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-14', '11:00', '12:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0451", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5081605", "designation": "SSE_SIGNAL_KLK_KLK", "contact": "9717686284"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "KLK", "station_name": "Kalka", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-1", "interlocking_affected": "Block overlap detection & Track clearance for KLK yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "11:00", "end_time": "12:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0452', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'DMP', 'Dharampur Himachal', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #215',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-14', '14:30', '15:15', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0452", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5032928", "designation": "SSE_SIGNAL_KLK_DMP", "contact": "9717686830"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "DMP", "station_name": "Dharampur Himachal", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #215", "interlocking_affected": "Interlocking panel for Dharampur Himachal yard", "signals_affected": ["S-4"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "14:30", "end_time": "15:15", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0453', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'BOF', 'Barog', 'Interlocked Level Crossing Gate', 'LC Gate No. 98 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-14', '17:00', '18:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0453", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5028081", "designation": "SSE_SIGNAL_KLK_BOF", "contact": "9717677446"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "BOF", "station_name": "Barog", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 98 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 98", "signals_affected": ["G-3", "G-6"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0454', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UMB', 'Ambala Cantt Jn', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #253',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-14', '11:00', '11:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0454", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5095559", "designation": "SSE_SIGNAL_JUDW_UMB", "contact": "9717698992"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UMB", "station_name": "Ambala Cantt Jn", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #253", "interlocking_affected": "Interlocking panel for Ambala Cantt Jn yard", "signals_affected": ["S-1"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "11:00", "end_time": "11:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0455', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'RAA', 'Barara', 'Interlocked Level Crossing Gate', 'LC Gate No. 17 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-14', '14:30', '16:00', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0455", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5068855", "designation": "SSE_SIGNAL_JUDW_RAA", "contact": "9717680105"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "RAA", "station_name": "Barara", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 17 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 17", "signals_affected": ["G-1", "G-7"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0456', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'YJUD', 'Yamunanagar Jagadhri', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-12 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-14', '17:00', '17:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0456", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5075562", "designation": "SSE_SIGNAL_JUDW_YJUD", "contact": "9717644930"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "YJUD", "station_name": "Yamunanagar Jagadhri", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-12 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-12", "signals_affected": ["S-12"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "17:00", "end_time": "17:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0457', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UMB', 'Ambala Cantt Jn', 'Interlocked Level Crossing Gate', 'LC Gate No. 95 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-14', '11:00', '12:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0457", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5050775", "designation": "SSE_SIGNAL_JUDW_UMB", "contact": "9717635166"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UMB", "station_name": "Ambala Cantt Jn", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 95 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 95", "signals_affected": ["G-4", "G-5"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0458', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'KES', 'Kesri', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-14 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-14', '14:30', '15:10', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0458", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5050783", "designation": "SSE_SIGNAL_JUDW_KES", "contact": "9717645495"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "KES", "station_name": "Kesri", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-14 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-14", "signals_affected": ["S-14"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "14:30", "end_time": "15:10", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0459', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MFB', 'Mustafabad', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #216',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-14', '17:00', '18:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0459", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5052136", "designation": "SSE_SIGNAL_JUDW_MFB", "contact": "9717650902"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MFB", "station_name": "Mustafabad", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #216", "interlocking_affected": "Interlocking panel for Mustafabad yard", "signals_affected": ["S-2"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-14", "start_time": "17:00", "end_time": "18:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0460', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UMB', 'Ambala Cantt Jn', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-21 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-15', '11:00', '11:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0460", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5088507", "designation": "SSE_SIGNAL_KKDE_UMB", "contact": "9717688503"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UMB", "station_name": "Ambala Cantt Jn", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-21 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-21", "signals_affected": ["S-21"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-15", "start_time": "11:00", "end_time": "11:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0461', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MOY', 'Mohri', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #270',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-15', '14:30', '16:15', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0461", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5074642", "designation": "SSE_SIGNAL_KKDE_MOY", "contact": "9717698973"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MOY", "station_name": "Mohri", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #270", "interlocking_affected": "Interlocking panel for Mohri yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-15", "start_time": "14:30", "end_time": "16:15", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0462', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'SHDM', 'Shahbad Markanda', 'Point Machine', 'Point No. 106',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-15', '17:00', '18:15', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0462", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5077522", "designation": "SSE_SIGNAL_KKDE_SHDM", "contact": "9717660146"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "SHDM", "station_name": "Shahbad Markanda", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 106", "interlocking_affected": "Up Main to Goods Siding route", "signals_affected": ["S-14", "S-24"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-15", "start_time": "17:00", "end_time": "18:15", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0463', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'RPJ', 'Rajpura Jn', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #270',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-15', '11:00', '12:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0463", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5088610", "designation": "SSE_SIGNAL_RPJ_RPJ", "contact": "9717665460"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "RPJ", "station_name": "Rajpura Jn", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #270", "interlocking_affected": "Interlocking panel for Rajpura Jn yard", "signals_affected": ["S-3"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-15", "start_time": "11:00", "end_time": "12:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0464', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'PTA', 'Patiala', 'Point Machine', 'Point No. 123B',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-15', '14:30', '15:45', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0464", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5045811", "designation": "SSE_SIGNAL_RPJ_PTA", "contact": "9717651628"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "PTA", "station_name": "Patiala", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 123B", "interlocking_affected": "Common Loop to Platform Line No. 2", "signals_affected": ["S-6", "S-24"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-15", "start_time": "14:30", "end_time": "15:45", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0465', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'NBA', 'Nabha', 'Point Machine', 'Point No. 138B',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-15', '17:00', '18:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0465", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5063171", "designation": "SSE_SIGNAL_RPJ_NBA", "contact": "9717637970"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "NBA", "station_name": "Nabha", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 138B", "interlocking_affected": "Down Loop to Down Main route", "signals_affected": ["S-2", "S-32"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-15", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0466', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'RPJ', 'Rajpura Jn', 'Point Machine', 'Point No. 108',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-15', '11:00', '12:15', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0466", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5099471", "designation": "SSE_SIGNAL_PTA_RPJ", "contact": "9717660962"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "RPJ", "station_name": "Rajpura Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 108", "interlocking_affected": "Down Loop to Down Main route", "signals_affected": ["S-6", "S-33"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-15", "start_time": "11:00", "end_time": "12:15", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0467', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'KLI', 'Kauli', 'Point Machine', 'Point No. 103B',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-15', '14:30', '16:00', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0467", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5074313", "designation": "SSE_SIGNAL_PTA_KLI", "contact": "9717675739"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "KLI", "station_name": "Kauli", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 103B", "interlocking_affected": "Common Loop to Platform Line No. 2", "signals_affected": ["S-12", "S-30"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-15", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0468', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'PTA', 'Patiala', 'Electronic Interlocking (EI)', 'Gear Unit #202',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-15', '17:00', '19:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0468", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5034528", "designation": "SSE_SIGNAL_PTA_PTA", "contact": "9717693090"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "PTA", "station_name": "Patiala", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #202", "interlocking_affected": "Interlocking panel for Patiala yard", "signals_affected": ["S-1"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-15", "start_time": "17:00", "end_time": "19:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0469', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'DUI', 'Dhuri Jn', 'Point Machine', 'Point No. 141',
    'Preventive Replacement of Point Motor and Detector Contact Assembly', TRUE, TRUE,
    '2026-09-16', '11:00', '12:30', 90,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0469", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5059462", "designation": "SSE_SIGNAL_DUI_DUI", "contact": "9717621555"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "DUI", "station_name": "Dhuri Jn", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 141", "interlocking_affected": "Down Loop to Down Main route", "signals_affected": ["S-5", "S-26"]}}, "disconnection_specifications": {"maintenance_nature": "Preventive Replacement of Point Motor and Detector Contact Assembly", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-16", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Main line straight movements only (Point Normal locked)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0470', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MET', 'Malerkotla', 'Electronic Interlocking (EI)', 'Gear Unit #221',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-16', '14:30', '16:30', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0470", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5088156", "designation": "SSE_SIGNAL_DUI_MET", "contact": "9717684665"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MET", "station_name": "Malerkotla", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #221", "interlocking_affected": "Interlocking panel for Malerkotla yard", "signals_affected": ["S-4"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "14:30", "end_time": "16:30", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0471', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'AHH', 'Ahmedgarh', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-1',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-16', '17:00', '18:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0471", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5059521", "designation": "SSE_SIGNAL_DUI_AHH", "contact": "9717618134"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "AHH", "station_name": "Ahmedgarh", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-1", "interlocking_affected": "Block overlap detection & Track clearance for AHH yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "17:00", "end_time": "18:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0472', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'SIR', 'Sirhind Jn', 'Electronic Interlocking (EI)', 'Gear Unit #269',
    'Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization', TRUE, FALSE,
    '2026-09-16', '11:00', '13:00', 120,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0472", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5084934", "designation": "SSE_SIGNAL_SIR_SIR", "contact": "9717694156"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "SIR", "station_name": "Sirhind Jn", "affected_gear": {"gear_type": "Electronic Interlocking (EI)", "gear_id": "Gear Unit #269", "interlocking_affected": "Interlocking panel for Sirhind Jn yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "Card replacement in Central Processing Unit & Warm-Standby VDU Synchronization", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "11:00", "end_time": "13:00", "duration_minutes": 120}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "All signal aspects red; movements on Calling-on / Written Authority (T/369-3b)"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0473', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MRND', 'Morinda Jn', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-3',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-16', '14:30', '15:30', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0473", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5050102", "designation": "SSE_SIGNAL_SIR_MRND", "contact": "9717623034"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MRND", "station_name": "Morinda Jn", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-3", "interlocking_affected": "Block overlap detection & Track clearance for MRND yard", "signals_affected": ["S-12"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "14:30", "end_time": "15:30", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0474', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'RPAR', 'Rupnagar', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #250',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-16', '17:00', '17:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0474", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5062854", "designation": "SSE_SIGNAL_SIR_RPAR", "contact": "9717641675"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "RPAR", "station_name": "Rupnagar", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #250", "interlocking_affected": "Interlocking panel for Rupnagar yard", "signals_affected": ["S-3"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "17:00", "end_time": "17:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0475', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'NLDM', 'Nangal Dam', 'Digital Axle Counter (HASSDAC/MSDAC)', 'Axle Counter Unit DP-7',
    'Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration', TRUE, FALSE,
    '2026-09-16', '11:00', '12:00', 60,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0475", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5053452", "designation": "SSE_SIGNAL_SIR_NLDM", "contact": "9717624412"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "NLDM", "station_name": "Nangal Dam", "affected_gear": {"gear_type": "Digital Axle Counter (HASSDAC/MSDAC)", "gear_id": "Axle Counter Unit DP-7", "interlocking_affected": "Block overlap detection & Track clearance for NLDM yard", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "Track Sensor TX/RX replacement and Wheel Detector Phase Angle calibration", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "11:00", "end_time": "12:00", "duration_minutes": 60}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Block Section line clear verified via station master reset box"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0476', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'MTPR', 'Mehatpur', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #288',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-16', '14:30', '15:15', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0476", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5043728", "designation": "SSE_SIGNAL_SIR_MTPR", "contact": "9717696119"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "MTPR", "station_name": "Mehatpur", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #288", "interlocking_affected": "Interlocking panel for Mehatpur yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "14:30", "end_time": "15:15", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0477', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'UHL', 'Una Himachal', 'Interlocked Level Crossing Gate', 'LC Gate No. 20 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-16', '17:00', '18:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0477", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5081668", "designation": "SSE_SIGNAL_SIR_UHL", "contact": "9717637318"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "UHL", "station_name": "Una Himachal", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 20 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 20", "signals_affected": ["G-2", "G-7"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-16", "start_time": "17:00", "end_time": "18:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0478', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'PTA', 'Patiala', 'Track Circuit (DC / Audio Frequency TC)', 'Gear Unit #235',
    'Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal', FALSE, FALSE,
    '2026-09-17', '11:00', '11:45', 45,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0478", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5095113", "designation": "SSE_SIGNAL_PTA_PTA", "contact": "9717667113"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "PTA", "station_name": "Patiala", "affected_gear": {"gear_type": "Track Circuit (DC / Audio Frequency TC)", "gear_id": "Gear Unit #235", "interlocking_affected": "Interlocking panel for Patiala yard", "signals_affected": ["S-6"]}}, "disconnection_specifications": {"maintenance_nature": "Choke coil, Glued Insulated Joint (GIJ) inspection and bootleg bonding renewal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "11:00", "end_time": "11:45", "duration_minutes": 45}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Normal train movement with speed restriction of 30 kmph over glued joint"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0479', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'DBN', 'Dhablan', 'Interlocked Level Crossing Gate', 'LC Gate No. 64 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-17', '14:30', '16:00', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0479", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5040384", "designation": "SSE_SIGNAL_PTA_DBN", "contact": "9717698413"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "DBN", "station_name": "Dhablan", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 64 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 64", "signals_affected": ["G-3", "G-6"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "14:30", "end_time": "16:00", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0480', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'NBA', 'Nabha', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-4 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-17', '17:00', '17:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0480", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5068814", "designation": "SSE_SIGNAL_PTA_NBA", "contact": "9717653961"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "NBA", "station_name": "Nabha", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-4 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-4", "signals_affected": ["S-4"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "17:00", "end_time": "17:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0481', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'BTI', 'Bathinda Jn', 'Interlocked Level Crossing Gate', 'LC Gate No. 83 (Spl Class)',
    'Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling', TRUE, FALSE,
    '2026-09-17', '11:00', '12:30', 90,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0481", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5028060", "designation": "SSE_SIGNAL_BTI_BTI", "contact": "9717670679"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "BTI", "station_name": "Bathinda Jn", "affected_gear": {"gear_type": "Interlocked Level Crossing Gate", "gear_id": "LC Gate No. 83 (Spl Class)", "interlocking_affected": "Up & Down Gate Signals interlocked with Gate 83", "signals_affected": ["G-1", "G-8"]}}, "disconnection_specifications": {"maintenance_nature": "Boom locking circuit test, mechanical barrier alignment and circuit controller overhauling", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "11:00", "end_time": "12:30", "duration_minutes": 90}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Gate closed to road traffic; signals taken OFF manually after emergency padlocking"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0482', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'BHX', 'Balluana', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-15 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-17', '14:30', '15:10', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0482", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5046169", "designation": "SSE_SIGNAL_BTI_BHX", "contact": "9717646719"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "BHX", "station_name": "Balluana", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-15 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-15", "signals_affected": ["S-15"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "14:30", "end_time": "15:10", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0483', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'GDB', 'Giddarbaha', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #277',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-17', '17:00', '18:45', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0483", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5061664", "designation": "SSE_SIGNAL_BTI_GDB", "contact": "9717674899"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "GDB", "station_name": "Giddarbaha", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #277", "interlocking_affected": "Interlocking panel for Giddarbaha yard", "signals_affected": ["S-7"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "17:00", "end_time": "18:45", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0484', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'SRE', 'Saharanpur Jn', 'Colour Light Signal (LED Signal Unit)', 'Signal No. S-10 (Home/Starter)',
    'Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal', FALSE, FALSE,
    '2026-09-17', '11:00', '11:40', 40,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0484", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5061716", "designation": "SSE_SIGNAL_SRE_SRE", "contact": "9717622407"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "SRE", "station_name": "Saharanpur Jn", "affected_gear": {"gear_type": "Colour Light Signal (LED Signal Unit)", "gear_id": "Signal No. S-10 (Home/Starter)", "interlocking_affected": "Reception / Dispatch route controlled by S-10", "signals_affected": ["S-10"]}}, "disconnection_specifications": {"maintenance_nature": "Current Limiter Resistor & LED ERS Unit replacement on Home/Starter Signal", "requires_traffic_block": false, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "11:00", "end_time": "11:40", "duration_minutes": 40}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Train cautioned by hand signals (Banner Flag & Detonators) by S&T pilot"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0485', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'KJGY', 'Khanalampura Yard', 'Block Instrument (Universal Fail Safe Block Interface - UFSBI)', 'Gear Unit #266',
    'OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring', TRUE, FALSE,
    '2026-09-17', '14:30', '16:15', 105,
    FALSE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0485", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5042108", "designation": "SSE_SIGNAL_SRE_KJGY", "contact": "9717699810"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "KJGY", "station_name": "Khanalampura Yard", "affected_gear": {"gear_type": "Block Instrument (Universal Fail Safe Block Interface - UFSBI)", "gear_id": "Gear Unit #266", "interlocking_affected": "Interlocking panel for Khanalampura Yard yard", "signals_affected": ["S-9"]}}, "disconnection_specifications": {"maintenance_nature": "OFC Media multiplexer testing, modem loopback diagnostic and relay rack rewiring", "requires_traffic_block": true, "fouling_mark_infringed": false, "requested_slot": {"date": "2026-09-17", "start_time": "14:30", "end_time": "16:15", "duration_minutes": 105}}, "safety_protocols": {"crank_handle_locked": false, "alternate_movement_possible": "Paper Line Clear Ticket (PLCT - T/A 1425 / T/B 1425) operation"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;
INSERT INTO smms_signal_disconnections (
    disconnection_ref_id, source_system, form_type, division,
    station_code, station_name, gear_type, gear_id,
    maintenance_nature, requires_traffic_block, fouling_mark_infringed,
    slot_date, start_time, end_time, duration_minutes,
    crank_handle_locked, payload
) VALUES (
    'SMMS/UMB/2026/DISC/0486', 'SMMS_SIGNAL_TELECOM', 'S&T(T/D) 351 (Electronic)', 'Ambala (UMB)',
    'BAE', 'Baliakheri', 'Point Machine', 'Point No. 141A',
    'Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment', TRUE, TRUE,
    '2026-09-17', '17:00', '18:15', 75,
    TRUE, '{"source_system": "SMMS_SIGNAL_TELECOM", "disconnection_ref_id": "SMMS/UMB/2026/DISC/0486", "form_type": "S&T(T/D) 351 (Electronic)", "officer_in_charge": {"emp_id": "5040529", "designation": "SSE_SIGNAL_SRE_BAE", "contact": "9717663503"}, "asset_location": {"division": "Ambala (UMB)", "station_code": "BAE", "station_name": "Baliakheri", "affected_gear": {"gear_type": "Point Machine", "gear_id": "Point No. 141A", "interlocking_affected": "Up Main Line crossovers 102/104", "signals_affected": ["S-5", "S-23"]}}, "disconnection_specifications": {"maintenance_nature": "Facing Point Lock (FPL) testing, obstacle test (5mm gauge) and tongue rail adjustment", "requires_traffic_block": true, "fouling_mark_infringed": true, "requested_slot": {"date": "2026-09-17", "start_time": "17:00", "end_time": "18:15", "duration_minutes": 75}}, "safety_protocols": {"crank_handle_locked": true, "alternate_movement_possible": "Reverse line routes clamped and padlocked"}}'::jsonb
) ON CONFLICT (disconnection_ref_id) DO UPDATE SET payload = EXCLUDED.payload;