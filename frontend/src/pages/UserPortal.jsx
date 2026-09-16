import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { PrintHeader } from '../components/PrintHeader';
import { 
  Wrench, Radio, Zap, CheckCircle2, AlertCircle, Clock, 
  Calendar, Printer, Send, Database, HardHat, FileText, CheckCircle
} from 'lucide-react';

export const UserPortal = () => {
  const { user } = useAuth();
  const department = user?.department || 'TMS';
  const deptDisplay = user?.department_display || 'Track Management System (Civil)';
  const userSection = user?.section || 'UDL-SNT';
  const userSectionDisplay = user?.section_display || 'Andal - Sainthia Section';

  // Tabs: 'current_report' (Section 1) or 'log_work' (Section 2) or 'my_logs'
  const [activeTab, setActiveTab] = useState('current_report');
  const [currentBlocks, setCurrentBlocks] = useState([]);
  const [myHistory, setMyHistory] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // Form State for Section 2: Log Maintenance History to Neon PostgreSQL
  const [logForm, setLogForm] = useState({
    block_id: '',
    department: department,
    division: user?.division || 'Asansol (ASN)',
    section: userSection,
    block_section: 'UDL-UKA',
    line: 'UP_MAIN',
    work_type: department === 'TMS' ? 'Track Tamping & Lining (CSM-952)' : department === 'SMMS' ? 'Point Machine Motor Overhaul' : 'OHE Contact Wire Replacement',
    asset_type: department === 'TMS' ? 'Track' : department === 'SMMS' ? 'Point Machine' : 'OHE Catenary Wire',
    crew_size: 8,
    equipment: department === 'TMS' ? 'CSM-952' : department === 'SMMS' ? 'Torque Wrench & Relay Test Kit' : '8-Wheeler Tower Wagon',
    requested_duration_min: 150,
    actual_duration_min: 150,
    actual_start: new Date(Date.now() - 7 * 86400000).toISOString().substring(0, 10) + 'T11:30',
    actual_end: new Date(Date.now() - 7 * 86400000).toISOString().substring(0, 10) + 'T14:00',
    completion_status: 'Completed',
    train_detention_minutes: 0,
    work_remarks: 'Completed all scheduled maintenance tasks in the planned window without any train detention.',
    logged_by: user?.name || 'Section Engineer'
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitResult, setSubmitResult] = useState(null);

  useEffect(() => {
    fetchCurrentAuthorizedBlocks();
    fetchMyHistory();
  }, [department, userSection]);

  const fetchCurrentAuthorizedBlocks = async () => {
    try {
      const res = await fetch(`/api/engineer/current-blocks?department=${department}&section=${userSection}`);
      const data = await res.json();
      setCurrentBlocks(data.authorized_blocks || []);
    } catch (err) {
      console.error('Error fetching authorized blocks:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchMyHistory = async () => {
    try {
      const res = await fetch(`/api/engineer/my-history?department=${department}&division=${encodeURIComponent(user?.division || 'Asansol (ASN)')}`);
      const data = await res.json();
      setMyHistory(data.history || []);
    } catch (err) {
      console.error('Error fetching my history:', err);
    }
  };

  const handleFormChange = (e) => {
    const { name, value } = e.target;
    setLogForm(prev => ({
      ...prev,
      [name]: name.includes('duration') || name.includes('crew') || name.includes('detention') ? Number(value) : value
    }));
  };

  const handleSelectBlockToLog = (blk) => {
    setLogForm(prev => ({
      ...prev,
      block_id: blk.block_id,
      work_type: blk.work_type,
      section: blk.section,
      block_section: blk.block_section,
      line: blk.line,
      equipment: blk.equipment,
      crew_size: blk.crew_size,
      requested_duration_min: blk.duration_min,
      actual_duration_min: blk.duration_min
    }));
    setActiveTab('log_work');
  };

  const handleSubmitHistory = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setSubmitResult(null);

    try {
      const res = await fetch('/api/engineer/log-history', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...logForm,
          department: department,
          logged_by: user?.name
        })
      });
      if (!res.ok) throw new Error('Submission to Neon PostgreSQL failed');
      const data = await res.json();
      setSubmitResult(data);
      // Refresh current blocks & history
      fetchCurrentAuthorizedBlocks();
      fetchMyHistory();
    } catch (err) {
      alert('Error saving maintenance history: ' + err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="ir-page-container">
      {/* Official Hard Copy Print Header */}
      <PrintHeader 
        title={`SECTIONAL ENGINEER MAINTENANCE REPORT & LOG (${department} DEPARTMENT)`}
        subtitle={`${deptDisplay} • Section: ${userSectionDisplay}`}
        metadata={{ 
          zone: user?.zone || 'EASTERN RAILWAY', 
          division: user?.division || 'Asansol (ASN)', 
          department: deptDisplay 
        }}
      />

      {/* Hero Banner for Engineer Workspace */}
      <div className="ir-card no-print" style={{
        background: department === 'TMS' 
          ? 'linear-gradient(135deg, #0d47a1 0%, #1565c0 55%, #1e293b 100%)' 
          : department === 'SMMS'
          ? 'linear-gradient(135deg, #1b5e20 0%, #2e7d32 55%, #1e293b 100%)'
          : 'linear-gradient(135deg, #b45309 0%, #d97706 55%, #1e293b 100%)',
        color: '#ffffff',
        padding: '1.25rem 1.75rem',
        borderRadius: '8px',
        marginBottom: '1.5rem',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderLeft: '6px solid #ffffff'
      }}>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginBottom: '0.3rem' }}>
            {department === 'TMS' && <Wrench size={26} color="#93c5fd" />}
            {department === 'SMMS' && <Radio size={26} color="#86efac" />}
            {department === 'TDMS' && <Zap size={26} color="#fed7aa" />}
            <h2 style={{ fontSize: '1.35rem', fontWeight: 700 }}>
              {deptDisplay}
            </h2>
          </div>
          <p style={{ color: '#f1f5f9', fontSize: '0.88rem' }}>
            Officer: <strong>{user?.name}</strong> • Section: <strong>{userSectionDisplay}</strong> ({user?.division})
          </p>
        </div>

        <div style={{ display: 'flex', gap: '0.75rem' }}>
          <button className="ir-btn ir-btn-print" onClick={handlePrint}>
            <Printer size={16} />
            <span>Print Report</span>
          </button>
        </div>
      </div>

      {/* The 2 Primary Sections as required by User prompt */}
      <div className="central-tab-ribbon no-print" style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.25rem', borderBottom: '2px solid #e2dec9', paddingBottom: '0.5rem' }}>
        {/* Section 1 */}
        <button 
          className={`ir-btn ${activeTab === 'current_report' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('current_report')}
          style={{ fontWeight: 700 }}
        >
          <FileText size={16} />
          Section 1: Current Maintenance Report (Present Week) ({currentBlocks.length})
        </button>

        {/* Section 2 */}
        <button 
          className={`ir-btn ${activeTab === 'log_work' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('log_work')}
          style={{ fontWeight: 700 }}
        >
          <Database size={16} />
          Section 2: Log Maintenance History (Neon PostgreSQL)
        </button>

        {/* Archive */}
        <button 
          className={`ir-btn ${activeTab === 'my_logs' ? 'ir-btn-outline' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('my_logs')}
        >
          <CheckCircle size={16} />
          Completed Work Archives ({myHistory.length})
        </button>
      </div>

      {/* SECTION 1: CURRENT MAINTENANCE REPORT FOR PRESENT WEEK */}
      {(activeTab === 'current_report' || window.matchMedia('print').matches) && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div>
              <div className="ir-card-title">
                <FileText size={18} />
                SECTION 1: Current Authorized Maintenance Report for Present Week
              </div>
              <div style={{ fontSize: '0.82rem', color: '#64748b', marginTop: '2px' }}>
                Showing only track possession blocks that have been reviewed, approved, and authorized by Divisional Operations.
              </div>
            </div>

            <button className="ir-btn ir-btn-print no-print" onClick={handlePrint}>
              <Printer size={14} />
              Print Weekly Schedule
            </button>
          </div>

          <div className="ir-card-body">
            {currentBlocks.length === 0 ? (
              <div style={{
                textAlign: 'center',
                padding: '3rem 1.5rem',
                background: '#f8fafc',
                border: '1px dashed #cbd5e1',
                borderRadius: '8px',
                color: '#64748b'
              }}>
                <Clock size={36} color="#94a3b8" style={{ margin: '0 auto 0.75rem auto' }} />
                <div style={{ fontSize: '1rem', fontWeight: 600, color: '#334155' }}>
                  No Authorized Blocks Currently Assigned for Present Week
                </div>
                <p style={{ fontSize: '0.85rem', marginTop: '0.25rem' }}>
                  Maintenance windows will appear here immediately upon authorization by the Divisional Operations Manager.
                </p>
              </div>
            ) : (
              <div className="ir-table-container">
                <table className="ir-table">
                  <thead>
                    <tr>
                      <th>Block ID</th>
                      <th>Location / Section</th>
                      <th>Track Line</th>
                      <th>Scheduled Date & Time</th>
                      <th>Assigned Window</th>
                      <th>Machinery & Gang Size</th>
                      <th>Coordination & Disconnections</th>
                      <th>Status / Audit</th>
                      <th className="no-print">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {currentBlocks.map((blk, idx) => (
                      <tr key={idx}>
                        <td style={{ fontFamily: 'monospace', fontWeight: 700 }}>{blk.block_id}</td>
                        <td>
                          <strong>{blk.section_display || blk.section}</strong>
                          <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{blk.block_section_name || blk.block_section}</div>
                        </td>
                        <td>
                          <span style={{ fontWeight: 600 }}>{blk.line}</span>
                        </td>
                        <td>
                          <div><strong>{blk.scheduled_date}</strong></div>
                          <div style={{ fontSize: '0.82rem', color: '#0d47a1', fontWeight: 600 }}>
                            {blk.preferred_start} - {blk.preferred_end}
                          </div>
                        </td>
                        <td>{blk.duration_min} Minutes</td>
                        <td>
                          <div>{blk.equipment}</div>
                          <div style={{ fontSize: '0.75rem', color: '#64748b' }}>Crew: {blk.crew_size} Staff</div>
                        </td>
                        <td>
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '2px', fontSize: '0.75rem' }}>
                            {blk.power_block_required && (
                              <span style={{ color: '#b91c1c', fontWeight: 600 }}>⚡ 25kV OHE Isolation Required</span>
                            )}
                            {blk.st_disconnection_required && (
                              <span style={{ color: '#b45309', fontWeight: 600 }}>🚦 S&T Interlocking Permit Required</span>
                            )}
                            {!blk.power_block_required && !blk.st_disconnection_required && (
                              <span style={{ color: '#64748b' }}>Standard Traffic Block</span>
                            )}
                          </div>
                        </td>
                        <td>
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
                            <span className="badge-authorized">
                              <CheckCircle2 size={12} />
                              AUTHORIZED
                            </span>
                            {blk.is_edited && (
                              <span className="badge-edited" style={{ fontSize: '0.68rem', padding: '1px 4px' }}>
                                EDITED BY DIVISION
                              </span>
                            )}
                          </div>
                        </td>
                        <td className="no-print">
                          <button
                            className="ir-btn ir-btn-primary"
                            style={{ padding: '0.35rem 0.65rem', fontSize: '0.75rem' }}
                            onClick={() => handleSelectBlockToLog(blk)}
                            title="Log completion for this block"
                          >
                            Log Work
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </div>
      )}

      {/* SECTION 2: LOG MAINTENANCE HISTORY FORM (STORED IN NEON POSTGRESQL) */}
      {activeTab === 'log_work' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div>
              <div className="ir-card-title">
                <Database size={18} />
                SECTION 2: Log Completed Maintenance Work (Neon PostgreSQL Storage)
              </div>
              <div style={{ fontSize: '0.82rem', color: '#64748b', marginTop: '2px' }}>
                Executed maintenance works completed in previous weeks are written directly to 
                Neon Cloud database (<code>{department.toLowerCase()}_maintenance_history</code>).
              </div>
            </div>
            <div style={{ background: '#f0fdf4', color: '#166534', padding: '0.25rem 0.75rem', borderRadius: '4px', fontSize: '0.78rem', fontWeight: 700 }}>
              Direct Cloud SQL Pipeline
            </div>
          </div>

          <div className="ir-card-body">
            {submitResult && (
              <div style={{
                background: '#f0fdf4',
                border: '1.5px solid #86efac',
                borderRadius: '8px',
                padding: '1rem',
                marginBottom: '1.5rem',
                color: '#166534',
                display: 'flex',
                alignItems: 'center',
                gap: '0.75rem'
              }}>
                <CheckCircle2 size={24} color="#16a34a" flexShrink={0} />
                <div>
                  <div style={{ fontWeight: 700, fontSize: '0.95rem' }}>
                    SUCCESS: Maintenance Record Successfully Committed!
                  </div>
                  <div style={{ fontSize: '0.85rem' }}>
                    Job ID: <strong>{submitResult.job_id}</strong> • Neon PostgreSQL Synced: <strong>{submitResult.neon_synced ? 'YES (Cloud Table Live)' : 'Local Mirror'}</strong>
                  </div>
                  <div style={{ fontSize: '0.8rem', color: '#15803d', marginTop: '2px' }}>
                    {submitResult.message}
                  </div>
                </div>
              </div>
            )}

            <form onSubmit={handleSubmitHistory}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem' }}>
                <div className="ir-form-group">
                  <label className="ir-form-label">Associated Block ID (Optional)</label>
                  <input
                    type="text"
                    name="block_id"
                    className="ir-form-input"
                    value={logForm.block_id}
                    onChange={handleFormChange}
                    placeholder="e.g. BLK-2026-W37-001"
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Engineering Department</label>
                  <input
                    type="text"
                    className="ir-form-input"
                    value={`${department} (${deptDisplay})`}
                    disabled
                    style={{ background: '#f8fafc', color: '#475569' }}
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Division</label>
                  <input
                    type="text"
                    className="ir-form-input"
                    value={logForm.division}
                    disabled
                    style={{ background: '#f8fafc', color: '#475569' }}
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr 1fr', gap: '1rem' }}>
                <div className="ir-form-group">
                  <label className="ir-form-label">Work Description / Nature of Maintenance *</label>
                  <input
                    type="text"
                    name="work_type"
                    className="ir-form-input"
                    value={logForm.work_type}
                    onChange={handleFormChange}
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Track Section *</label>
                  <input
                    type="text"
                    name="section"
                    className="ir-form-input"
                    value={logForm.section}
                    onChange={handleFormChange}
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Block Section / Yard *</label>
                  <input
                    type="text"
                    name="block_section"
                    className="ir-form-input"
                    value={logForm.block_section}
                    onChange={handleFormChange}
                    required
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '1rem' }}>
                <div className="ir-form-group">
                  <label className="ir-form-label">Track Line Possession *</label>
                  <select
                    name="line"
                    className="ir-form-select"
                    value={logForm.line}
                    onChange={handleFormChange}
                  >
                    <option value="UP_MAIN">UP MAIN Line</option>
                    <option value="DN_MAIN">DOWN MAIN Line</option>
                    <option value="BOTH_MAIN">BOTH MAIN Lines</option>
                    <option value="LOOP_LINE">Loop Line / Siding</option>
                  </select>
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Actual Gangmen Crew *</label>
                  <input
                    type="number"
                    name="crew_size"
                    className="ir-form-input"
                    value={logForm.crew_size}
                    onChange={handleFormChange}
                    min="1"
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Machinery / Equipment Used</label>
                  <input
                    type="text"
                    name="equipment"
                    className="ir-form-input"
                    value={logForm.equipment}
                    onChange={handleFormChange}
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Completion Status *</label>
                  <select
                    name="completion_status"
                    className="ir-form-select"
                    value={logForm.completion_status}
                    onChange={handleFormChange}
                  >
                    <option value="Completed">Completed Successfully</option>
                    <option value="Partially Completed">Partially Completed</option>
                    <option value="Cancelled at Site">Cancelled at Site</option>
                  </select>
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '1rem' }}>
                <div className="ir-form-group">
                  <label className="ir-form-label">Actual Start Timestamp *</label>
                  <input
                    type="datetime-local"
                    name="actual_start"
                    className="ir-form-input"
                    value={logForm.actual_start}
                    onChange={handleFormChange}
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Actual End Timestamp *</label>
                  <input
                    type="datetime-local"
                    name="actual_end"
                    className="ir-form-input"
                    value={logForm.actual_end}
                    onChange={handleFormChange}
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Actual Duration (Minutes) *</label>
                  <input
                    type="number"
                    name="actual_duration_min"
                    className="ir-form-input"
                    value={logForm.actual_duration_min}
                    onChange={handleFormChange}
                    required
                  />
                </div>

                <div className="ir-form-group">
                  <label className="ir-form-label">Train Detention (Minutes)</label>
                  <input
                    type="number"
                    name="train_detention_minutes"
                    className="ir-form-input"
                    value={logForm.train_detention_minutes}
                    onChange={handleFormChange}
                    min="0"
                  />
                </div>
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Operational Remarks & Post-Work Speed Restoration</label>
                <textarea
                  name="work_remarks"
                  className="ir-form-textarea"
                  rows="3"
                  value={logForm.work_remarks}
                  onChange={handleFormChange}
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem', marginTop: '1.5rem' }}>
                <button
                  type="submit"
                  className="ir-btn ir-btn-primary"
                  disabled={isSubmitting}
                  style={{ padding: '0.75rem 1.75rem' }}
                >
                  <Send size={18} />
                  {isSubmitting ? 'Writing to Neon Cloud...' : 'Commit Maintenance Log to Neon PostgreSQL'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ARCHIVE: COMPLETED WORK ARCHIVES */}
      {activeTab === 'my_logs' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <CheckCircle size={18} />
              Executed Maintenance History Archives for {deptDisplay} ({myHistory.length} Records)
            </div>
            <button className="ir-btn ir-btn-print" onClick={handlePrint}>
              <Printer size={14} />
              Print Historical Log
            </button>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Job ID</th>
                    <th>Section & Block Section</th>
                    <th>Work Type Executed</th>
                    <th>Execution Start & End</th>
                    <th>Actual Duration</th>
                    <th>Crew & Machinery</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {myHistory.map((h, idx) => (
                    <tr key={idx}>
                      <td style={{ fontFamily: 'monospace', fontWeight: 600 }}>{h.job_id}</td>
                      <td>
                        <strong>{h.section || userSection}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{h.block_section || 'UDL-UKA'}</div>
                      </td>
                      <td>{h.work_type}</td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>{h.actual_start ? h.actual_start.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                        <div>to {h.actual_end ? h.actual_end.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                      </td>
                      <td><strong>{h.actual_duration_min} Mins</strong></td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>{h.equipment}</div>
                        <div style={{ color: '#64748b' }}>{h.crew_size} Staff</div>
                      </td>
                      <td>
                        <span className="badge-authorized">{h.completion_status || 'Completed'}</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Signature block for hard copy printout */}
      <div className="print-signature-block print-only">
        <div className="print-sig-box">
          Section Engineer In-Charge<br/>{user?.name}
        </div>
        <div className="print-sig-box">
          Assistant Divisional Engineer (ADEN)<br/>{userSectionDisplay}
        </div>
        <div className="print-sig-box">
          Divisional Operations Manager (DOM)<br/>{user?.division}
        </div>
      </div>
    </div>
  );
};
