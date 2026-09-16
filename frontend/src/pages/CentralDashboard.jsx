import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { PrintHeader } from '../components/PrintHeader';
import { 
  Building2, Train, Wrench, Radio, Zap, AlertCircle, 
  Cpu, Play, CheckCircle2, Printer, Calendar, Clock, BarChart3, Database
} from 'lucide-react';

export const CentralDashboard = () => {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState('zonal_summary'); // 'zonal_summary', 'pending_works', 'history', 'ml_training'
  const [zonalData, setZonalData] = useState(null);
  const [pendingWorks, setPendingWorks] = useState([]);
  const [historyData, setHistoryData] = useState([]);
  const [historyTimeframe, setHistoryTimeframe] = useState('all');
  const [isLoading, setIsLoading] = useState(true);

  // ML Retraining States
  const [isTraining, setIsTraining] = useState(false);
  const [trainingResult, setTrainingResult] = useState(null);
  const [modelStatus, setModelStatus] = useState(null);

  useEffect(() => {
    fetchZonalSummary();
    fetchPendingWorks();
    fetchHistory('all');
    fetchModelStatus();
  }, []);

  const fetchZonalSummary = async () => {
    try {
      const res = await fetch('/api/central/zonal-summary');
      const data = await res.json();
      setZonalData(data);
    } catch (err) {
      console.error('Error loading zonal summary:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchPendingWorks = async () => {
    try {
      const res = await fetch('/api/central/pending-works');
      const data = await res.json();
      setPendingWorks(data.requisitions || []);
    } catch (err) {
      console.error('Error loading pending works:', err);
    }
  };

  const fetchHistory = async (timeframe) => {
    try {
      const res = await fetch(`/api/central/maintenance-history?timeframe=${timeframe}`);
      const data = await res.json();
      setHistoryData(data.history || []);
      setHistoryTimeframe(timeframe);
    } catch (err) {
      console.error('Error loading history:', err);
    }
  };

  const fetchModelStatus = async () => {
    try {
      const res = await fetch('/api/central/model-status');
      const data = await res.json();
      setModelStatus(data);
    } catch (err) {
      console.error('Error fetching model status:', err);
    }
  };

  const handleTriggerTraining = async () => {
    setIsTraining(true);
    setTrainingResult(null);
    try {
      const res = await fetch('/api/central/train-model', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ trigger_reason: 'CENTRAL_BOARD_MANUAL_DISPATCH' })
      });
      const data = await res.json();
      setTrainingResult(data);
      fetchModelStatus();
    } catch (err) {
      alert('Training trigger failed: ' + err.message);
    } finally {
      setIsTraining(false);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="ir-page-container">
      {/* Official Print Header */}
      <PrintHeader 
        title="PAN-INDIA ZONAL MAINTENANCE & BLOCK PLANNING SUMMARY REPORT"
        subtitle="Railway Board Infrastructure Directorate • High-Level Governance"
        metadata={{ zone: 'All Indian Railway Zones', division: 'All Divisions', department: 'TMS, SMMS, TDMS' }}
      />

      {/* Hero Welcome Banner */}
      <div className="central-hero-banner no-print">
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem', marginBottom: '0.3rem' }}>
            <Building2 size={24} color="#fed7aa" />
            <h2 style={{ fontSize: '1.35rem', fontWeight: 700 }}>
              Centralized Railway Board Control Panel
            </h2>
          </div>
          <p style={{ color: '#fed7aa', fontSize: '0.88rem', lineHeight: 1.4 }}>
            Pan-India Zonal Coordination, Pending Requisitions Audit & ML Optimization Governance
          </p>
        </div>

        <div className="central-hero-actions">
          <button className="ir-btn ir-btn-gold" onClick={() => setActiveTab('ml_training')}>
            <Cpu size={16} />
            <span>Train ML Model</span>
          </button>
          <button className="ir-btn ir-btn-print" onClick={handlePrint}>
            <Printer size={16} />
            <span>Print Hard Copy</span>
          </button>
        </div>
      </div>

      {/* KPI Stats Grid */}
      {zonalData?.national_totals && (
        <div className="ir-stats-grid">
          <div className="ir-stat-card stat-gold">
            <div className="ir-stat-icon"><BarChart3 size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{zonalData.national_totals.total_pending_blocks}</span>
              <span className="ir-stat-label">Total Pending Works (All Zones)</span>
            </div>
          </div>

          <div className="ir-stat-card stat-tms">
            <div className="ir-stat-icon"><Wrench size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{zonalData.national_totals.tms_civil_pending}</span>
              <span className="ir-stat-label">TMS Track Civil Pending</span>
            </div>
          </div>

          <div className="ir-stat-card stat-smms">
            <div className="ir-stat-icon"><Radio size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{zonalData.national_totals.smms_signal_pending}</span>
              <span className="ir-stat-label">SMMS Signal & Telecom Pending</span>
            </div>
          </div>

          <div className="ir-stat-card stat-tdms">
            <div className="ir-stat-icon"><Zap size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{zonalData.national_totals.tdms_trd_pending}</span>
              <span className="ir-stat-label">TDMS Traction OHE Pending</span>
            </div>
          </div>
        </div>
      )}

      {/* Tab Navigation Controls */}
      <div className="central-tab-ribbon no-print">
        <button 
          className={`ir-btn ${activeTab === 'zonal_summary' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('zonal_summary')}
        >
          <Building2 size={16} />
          <span>Pan-India Zonal Summary</span>
        </button>
        <button 
          className={`ir-btn ${activeTab === 'pending_works' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('pending_works')}
        >
          <AlertCircle size={16} />
          <span>Detailed Pending Requisitions ({pendingWorks.length})</span>
        </button>
        <button 
          className={`ir-btn ${activeTab === 'history' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('history')}
        >
          <Calendar size={16} />
          <span>Maintenance History Archive ({historyData.length})</span>
        </button>
        <button 
          className={`ir-btn ${activeTab === 'ml_training' ? 'ir-btn-gold' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('ml_training')}
        >
          <Cpu size={16} />
          <span>ML Model Training Hub</span>
        </button>
      </div>

      {/* TAB 1: ZONAL DATA SUMMARY */}
      {(activeTab === 'zonal_summary' || window.matchMedia('print').matches) && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Building2 size={18} />
              <span>Zonal Level Pending Works Breakdown for September 2026</span>
            </div>
            <div style={{ fontSize: '0.82rem', color: '#64748b' }}>
              Reporting Month: <strong>September 2026</strong> • Integrated TMS / SMMS / TDMS
            </div>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Zone Code</th>
                    <th>Zone Name & Headquarters</th>
                    <th>Divisions Covered</th>
                    <th style={{ textAlign: 'center' }}>TMS Pending (Track)</th>
                    <th style={{ textAlign: 'center' }}>SMMS Pending (S&T)</th>
                    <th style={{ textAlign: 'center' }}>TDMS Pending (OHE)</th>
                    <th style={{ textAlign: 'center' }}>Total Pending Works</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {zonalData?.zonal_data?.map((zone, idx) => (
                    <tr key={idx}>
                      <td style={{ fontWeight: 700, color: '#681214' }}>{zone.zone_code}</td>
                      <td>
                        <strong>{zone.zone_name}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>HQ: {zone.headquarters}</div>
                      </td>
                      <td>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.3rem' }}>
                          {zone.divisions.map((d, di) => (
                            <span key={di} style={{ background: '#f1f5f9', padding: '0.15rem 0.45rem', borderRadius: '4px', fontSize: '0.75rem' }}>
                              {d}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-tms">{zone.tms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-smms">{zone.smms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-tdms">{zone.tdms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center', fontWeight: 800, fontSize: '1rem', color: '#4a0c0e' }}>
                        {zone.total_pending}
                      </td>
                      <td>
                        <span className="badge-pending">Active Scheduling</span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* TAB 2: DETAILED PENDING REQUISITIONS */}
      {activeTab === 'pending_works' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <AlertCircle size={18} />
              <span>National Pending Maintenance Requisitions ({pendingWorks.length})</span>
            </div>
            <button className="ir-btn ir-btn-print" onClick={handlePrint}>
              <Printer size={14} />
              <span>Print Requisitions</span>
            </button>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Ref ID</th>
                    <th>Department</th>
                    <th>Zone / Division</th>
                    <th>Track Section & Block</th>
                    <th>Maintenance Work Description</th>
                    <th>Preferred Date</th>
                    <th>Duration</th>
                    <th>Inter-Dept Dependencies</th>
                  </tr>
                </thead>
                <tbody>
                  {pendingWorks.map((item, idx) => (
                    <tr key={idx}>
                      <td style={{ fontFamily: 'monospace', fontWeight: 600 }}>{item.ref_id}</td>
                      <td>
                        <span className={`dept-pill dept-pill-${item.department.toLowerCase()}`}>
                          {item.department}
                        </span>
                      </td>
                      <td>
                        <strong>{item.division}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{item.zone}</div>
                      </td>
                      <td>
                        <div>{item.section}</div>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{item.block_section}</div>
                      </td>
                      <td style={{ maxWidth: '280px' }}>{item.work_type}</td>
                      <td>{item.preferred_date}</td>
                      <td>{item.duration_minutes} Mins</td>
                      <td>
                        <div style={{ display: 'flex', gap: '0.3rem', flexWrap: 'wrap' }}>
                          {item.power_block_required && (
                            <span style={{ background: '#fee2e2', color: '#991b1b', padding: '2px 6px', borderRadius: '4px', fontSize: '0.7rem', fontWeight: 600 }}>
                              OHE Power Block
                            </span>
                          )}
                          {item.st_disconnection_required && (
                            <span style={{ background: '#fef3c7', color: '#92400e', padding: '2px 6px', borderRadius: '4px', fontSize: '0.7rem', fontWeight: 600 }}>
                              S&T Disconnect
                            </span>
                          )}
                          {!item.power_block_required && !item.st_disconnection_required && (
                            <span style={{ color: '#94a3b8', fontSize: '0.75rem' }}>Nil</span>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* TAB 3: MAINTENANCE HISTORY */}
      {activeTab === 'history' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Calendar size={18} />
              <span>Pan-India Maintenance History Archive ({historyData.length} Records)</span>
            </div>
            <div className="card-header-actions">
              <select
                className="ir-form-select"
                value={historyTimeframe}
                onChange={(e) => fetchHistory(e.target.value)}
                style={{ width: 'auto', padding: '0.35rem 0.75rem', fontSize: '0.85rem' }}
              >
                <option value="all">All Available History</option>
                <option value="previous_week">Previous Week Only</option>
                <option value="previous_month">Previous Month Only</option>
              </select>
              <button className="ir-btn ir-btn-print" onClick={handlePrint}>
                <Printer size={14} />
                <span>Print History</span>
              </button>
            </div>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Job ID</th>
                    <th>Department</th>
                    <th>Division / Section</th>
                    <th>Work Type</th>
                    <th>Execution Start & End</th>
                    <th>Duration (Req / Act)</th>
                    <th>Crew & Machinery</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {historyData.slice(0, 50).map((h, idx) => (
                    <tr key={idx}>
                      <td style={{ fontFamily: 'monospace', fontWeight: 600 }}>{h.job_id}</td>
                      <td>
                        <span className={`dept-pill dept-pill-${h.department ? h.department.toLowerCase() : 'tms'}`}>
                          {h.department || 'TMS'}
                        </span>
                      </td>
                      <td>
                        <strong>{h.division || 'ASN'}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{h.section || 'UDL-SNT'}</div>
                      </td>
                      <td>{h.work_type}</td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>Start: {h.actual_start ? h.actual_start.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                        <div>End: {h.actual_end ? h.actual_end.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                      </td>
                      <td>
                        <strong>{h.actual_duration_min || h.requested_duration_min}m</strong>
                        <span style={{ color: '#64748b', fontSize: '0.75rem' }}> / {h.requested_duration_min}m</span>
                      </td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>{h.equipment || 'Standard Tooling'}</div>
                        <div style={{ color: '#64748b' }}>{h.crew_size || 8} Staff</div>
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

      {/* TAB 4: ML MODEL TRAINING HUB */}
      {activeTab === 'ml_training' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Cpu size={18} />
              <span>Machine Learning Continuous Retraining Hub & Governance</span>
            </div>
            <div style={{ background: '#f0fdf4', color: '#166534', padding: '0.25rem 0.75rem', borderRadius: '4px', fontSize: '0.78rem', fontWeight: 700 }}>
              Production Engine Active
            </div>
          </div>
          <div className="ir-card-body">
            <div className="ml-training-grid">
              <div>
                <h4 style={{ color: '#4a0c0e', marginBottom: '0.5rem', fontSize: '0.98rem' }}>
                  Model Governance & Automated Pipeline Architecture
                </h4>
                <p style={{ fontSize: '0.86rem', color: '#475569', lineHeight: 1.5, marginBottom: '1rem' }}>
                  The IMBPS ML core trains predictive duration regression and risk estimation models 
                  directly on unified operational data synced across Neon PostgreSQL tables 
                  (<code>tms_maintenance_history</code>, <code>smms_maintenance_history</code>, <code>tdms_maintenance_history</code>).
                </p>

                <div style={{ background: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: '6px', padding: '1rem', marginBottom: '1.25rem' }}>
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(130px, 1fr))', gap: '0.75rem' }}>
                    <div>
                      <div style={{ fontSize: '0.72rem', color: '#64748b', fontWeight: 600 }}>ACTIVE MODEL VERSION</div>
                      <div style={{ fontSize: '0.95rem', fontWeight: 700, color: '#0d47a1' }}>{modelStatus?.active_version || 'duration_v1'}</div>
                    </div>
                    <div>
                      <div style={{ fontSize: '0.72rem', color: '#64748b', fontWeight: 600 }}>VALIDATION MAE</div>
                      <div style={{ fontSize: '0.95rem', fontWeight: 700, color: '#15803d' }}>{modelStatus?.val_mae || '12.8'} Minutes</div>
                    </div>
                    <div>
                      <div style={{ fontSize: '0.72rem', color: '#64748b', fontWeight: 600 }}>R² ACCURACY SCORE</div>
                      <div style={{ fontSize: '0.95rem', fontWeight: 700, color: '#1e293b' }}>{modelStatus?.r2_score || '0.884'}</div>
                    </div>
                    <div>
                      <div style={{ fontSize: '0.72rem', color: '#64748b', fontWeight: 600 }}>TRAINING FEED</div>
                      <div style={{ fontSize: '0.85rem', fontWeight: 600, color: '#c8861e' }}>Neon Cloud Mirror</div>
                    </div>
                  </div>
                </div>

                <button 
                  className="ir-btn ir-btn-primary"
                  onClick={handleTriggerTraining}
                  disabled={isTraining}
                  style={{ width: '100%', padding: '0.85rem' }}
                >
                  <Play size={18} />
                  <span>{isTraining ? 'Retraining ML Models on Neon Data...' : 'Trigger ML Model Retraining Pipeline'}</span>
                </button>
              </div>

              <div>
                <h4 style={{ color: '#4a0c0e', marginBottom: '0.5rem', fontSize: '0.98rem' }}>
                  Live Retraining Pipeline Output
                </h4>
                <div style={{
                  background: '#0f172a',
                  color: '#38bdf8',
                  fontFamily: 'monospace',
                  padding: '1rem',
                  borderRadius: '6px',
                  height: '240px',
                  overflowY: 'auto',
                  fontSize: '0.8rem',
                  lineHeight: 1.4
                }}>
                  {isTraining && (
                    <div style={{ color: '#facc15' }}>
                      [*] Connecting to Neon PostgreSQL tables...<br/>
                      [*] Ingesting unified maintenance history records...<br/>
                      [*] Running DataValidator schema checks (26 columns)...<br/>
                      [*] Performing time-based train/val split (80/20)...<br/>
                      [*] Training Ridge & RandomForest candidate models...<br/>
                      [*] Evaluating candidate validation MAE vs production threshold...
                    </div>
                  )}

                  {!isTraining && !trainingResult && (
                    <div style={{ color: '#94a3b8' }}>
                      [INFO] Standby for administrative model retraining.<br/>
                      [INFO] Click 'Trigger ML Model Retraining Pipeline' to initiate automated training cycle.<br/>
                      [INFO] Candidate models beating production MAE threshold are automatically promoted to registry.
                    </div>
                  )}

                  {trainingResult && (
                    <div style={{ color: '#4ade80' }}>
                      [+] RETRAINING COMPLETE<br/>
                      [+] Status: {trainingResult.status}<br/>
                      [+] Retrained At: {trainingResult.retrained_at}<br/>
                      [+] Message: {trainingResult.message}<br/>
                      {trainingResult.metrics && (
                        <>
                          [+] Training Records: {trainingResult.metrics.training_records}<br/>
                          [+] Validation MAE: {trainingResult.metrics.validation_mae} min<br/>
                          [+] R2 Score: {trainingResult.metrics.r2_score}<br/>
                          [+] Decision: {trainingResult.metrics.production_comparison}
                        </>
                      )}
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Signature block for hard copy printout */}
      <div className="print-signature-block print-only">
        <div className="print-sig-box">
          Director (Civil / Track)<br/>Railway Board
        </div>
        <div className="print-sig-box">
          Director (Signalling)<br/>Railway Board
        </div>
        <div className="print-sig-box">
          Member (Infrastructure)<br/>Ministry of Railways
        </div>
      </div>
    </div>
  );
};