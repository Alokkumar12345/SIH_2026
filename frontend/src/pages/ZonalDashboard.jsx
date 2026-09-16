import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { PrintHeader } from '../components/PrintHeader';
import { 
  Building2, Train, Wrench, Radio, Zap, AlertCircle, 
  Printer, Calendar, Clock, BarChart3, MapPin
} from 'lucide-react';

export const ZonalDashboard = () => {
  const { user } = useAuth();
  const zoneCode = user?.zone_code || 'ER';
  const zoneName = user?.zone || 'EASTERN RAILWAY';

  const [activeTab, setActiveTab] = useState('div_summary'); // 'div_summary', 'pending_requisitions', 'history'
  const [summaryData, setSummaryData] = useState(null);
  const [pendingRequisitions, setPendingRequisitions] = useState([]);
  const [historyData, setHistoryData] = useState([]);
  const [historyTimeframe, setHistoryTimeframe] = useState('all');
  const [selectedDivision, setSelectedDivision] = useState('ALL');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchDivisionsSummary();
    fetchPendingRequisitions();
    fetchZonalHistory('all');
  }, [zoneCode]);

  const fetchDivisionsSummary = async () => {
    try {
      const res = await fetch(`/api/zonal/divisions-summary?zone_code=${zoneCode}`);
      const data = await res.json();
      setSummaryData(data);
    } catch (err) {
      console.error('Error fetching divisions summary:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchPendingRequisitions = async () => {
    try {
      const res = await fetch(`/api/zonal/pending-works?zone_code=${zoneCode}`);
      const data = await res.json();
      setPendingRequisitions(data.requisitions || []);
    } catch (err) {
      console.error('Error fetching zonal pending works:', err);
    }
  };

  const fetchZonalHistory = async (timeframe) => {
    try {
      const res = await fetch(`/api/zonal/maintenance-history?zone_code=${zoneCode}&timeframe=${timeframe}`);
      const data = await res.json();
      setHistoryData(data.history || []);
      setHistoryTimeframe(timeframe);
    } catch (err) {
      console.error('Error fetching zonal history:', err);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="ir-page-container">
      {/* Official Hard Copy Print Header */}
      <PrintHeader 
        title={`ZONAL LEVEL MAINTENANCE & BLOCK PLANNING REPORT (${zoneName})`}
        subtitle="Zonal Headquarters Operations & Infrastructure Directorate"
        metadata={{ zone: zoneName, division: selectedDivision === 'ALL' ? 'All Divisions in Zone' : selectedDivision, department: 'TMS / SMMS / TDMS' }}
      />

      {/* Hero Zonal Banner */}
      <div className="ir-card no-print" style={{
        background: 'linear-gradient(135deg, #0d3b66 0%, #1565c0 60%, #4a0c0e 100%)',
        color: '#ffffff',
        padding: '1.25rem 1.75rem',
        borderRadius: '8px',
        marginBottom: '1.5rem',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderLeft: '6px solid #c8861e'
      }}>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem', marginBottom: '0.3rem' }}>
            <Building2 size={24} color="#fed7aa" />
            <h2 style={{ fontSize: '1.4rem', fontWeight: 700 }}>
              {zoneName} Headquarters Portal ({zoneCode})
            </h2>
          </div>
          <p style={{ color: '#fed7aa', fontSize: '0.9rem' }}>
            Divisional Coordination & Maintenance Monitoring for TMS (Civil), SMMS (S&T), TDMS (TRD)
          </p>
        </div>

        <div style={{ display: 'flex', gap: '0.75rem' }}>
          <button className="ir-btn ir-btn-print" onClick={handlePrint}>
            <Printer size={16} />
            <span>Print Hard Copy Report</span>
          </button>
        </div>
      </div>

      {/* Zonal KPI Stats */}
      {summaryData?.zonal_totals && (
        <div className="ir-stats-grid">
          <div className="ir-stat-card stat-gold">
            <div className="ir-stat-icon"><BarChart3 size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{summaryData.zonal_totals.total_pending_blocks}</span>
              <span className="ir-stat-label">Total Zonal Pending Works</span>
            </div>
          </div>

          <div className="ir-stat-card stat-tms">
            <div className="ir-stat-icon"><Wrench size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{summaryData.zonal_totals.tms_civil_pending}</span>
              <span className="ir-stat-label">TMS Track Works Pending</span>
            </div>
          </div>

          <div className="ir-stat-card stat-smms">
            <div className="ir-stat-icon"><Radio size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{summaryData.zonal_totals.smms_signal_pending}</span>
              <span className="ir-stat-label">SMMS Signal Works Pending</span>
            </div>
          </div>

          <div className="ir-stat-card stat-tdms">
            <div className="ir-stat-icon"><Zap size={24} /></div>
            <div className="ir-stat-data">
              <span className="ir-stat-value">{summaryData.zonal_totals.tdms_trd_pending}</span>
              <span className="ir-stat-label">TDMS OHE Works Pending</span>
            </div>
          </div>
        </div>
      )}

      {/* Tabs */}
      <div className="central-tab-ribbon no-print" style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.25rem', borderBottom: '2px solid #e2dec9', paddingBottom: '0.5rem' }}>
        <button 
          className={`ir-btn ${activeTab === 'div_summary' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('div_summary')}
        >
          <Building2 size={16} />
          Divisional Pending Breakdown
        </button>
        <button 
          className={`ir-btn ${activeTab === 'pending_requisitions' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('pending_requisitions')}
        >
          <AlertCircle size={16} />
          Pending Requisitions ({pendingRequisitions.length})
        </button>
        <button 
          className={`ir-btn ${activeTab === 'history' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('history')}
        >
          <Calendar size={16} />
          Zonal Maintenance History ({historyData.length})
        </button>
      </div>

      {/* TAB 1: DIVISIONAL PENDING SUMMARY */}
      {(activeTab === 'div_summary' || window.matchMedia('print').matches) && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Building2 size={18} />
              Division-wise Pending Works Summary ({zoneName}) - September 2026
            </div>
            <button className="ir-btn ir-btn-print no-print" onClick={handlePrint}>
              <Printer size={14} />
              Print Divisional Breakdown
            </button>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Division Code</th>
                    <th>Division Name & Headquarters</th>
                    <th>Key Railway Sections</th>
                    <th style={{ textAlign: 'center' }}>TMS (Track) Pending</th>
                    <th style={{ textAlign: 'center' }}>SMMS (S&T) Pending</th>
                    <th style={{ textAlign: 'center' }}>TDMS (OHE) Pending</th>
                    <th style={{ textAlign: 'center' }}>Total Pending</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {summaryData?.divisions_data?.map((div, idx) => (
                    <tr key={idx}>
                      <td style={{ fontWeight: 700, color: '#0d47a1', fontSize: '0.95rem' }}>{div.division_code}</td>
                      <td>
                        <strong>{div.division_name}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>HQ: {div.headquarters}</div>
                      </td>
                      <td>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.3rem' }}>
                          {div.key_sections.map((s, si) => (
                            <span key={si} style={{ background: '#f1f5f9', padding: '0.15rem 0.45rem', borderRadius: '4px', fontSize: '0.72rem' }}>
                              {s}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-tms">{div.tms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-smms">{div.smms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center' }}>
                        <span className="dept-pill dept-pill-tdms">{div.tdms_pending} Works</span>
                      </td>
                      <td style={{ textAlign: 'center', fontWeight: 800, fontSize: '1rem', color: '#0d3b66' }}>
                        {div.total_pending}
                      </td>
                      <td>
                        <button 
                          className="ir-btn ir-btn-outline" 
                          style={{ padding: '0.3rem 0.6rem', fontSize: '0.75rem' }}
                          onClick={() => {
                            setSelectedDivision(div.division_name);
                            setActiveTab('pending_requisitions');
                          }}
                        >
                          View Division
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* TAB 2: PENDING REQUISITIONS */}
      {activeTab === 'pending_requisitions' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <AlertCircle size={18} />
              Pending Requisitions for {zoneName}
            </div>
            <div style={{ display: 'flex', gap: '0.5rem' }}>
              <button className="ir-btn ir-btn-print" onClick={handlePrint}>
                <Printer size={14} />
                Print Pending List
              </button>
            </div>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Ref ID</th>
                    <th>Department</th>
                    <th>Division</th>
                    <th>Section & Block Section</th>
                    <th>Maintenance Specifications</th>
                    <th>Preferred Date</th>
                    <th>Duration</th>
                    <th>Inter-Departmental Permitting</th>
                  </tr>
                </thead>
                <tbody>
                  {pendingRequisitions.map((item, idx) => (
                    <tr key={idx}>
                      <td style={{ fontFamily: 'monospace', fontWeight: 600 }}>{item.ref_id}</td>
                      <td>
                        <span className={`dept-pill dept-pill-${item.department.toLowerCase()}`}>
                          {item.department}
                        </span>
                      </td>
                      <td><strong>{item.division}</strong></td>
                      <td>
                        <div>{item.section}</div>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{item.block_section}</div>
                      </td>
                      <td style={{ maxWidth: '260px' }}>{item.work_type}</td>
                      <td>{item.preferred_date}</td>
                      <td>{item.duration_minutes} Mins</td>
                      <td>
                        <div style={{ display: 'flex', gap: '0.3rem' }}>
                          {item.power_block_required && (
                            <span style={{ background: '#fee2e2', color: '#991b1b', padding: '2px 6px', borderRadius: '4px', fontSize: '0.7rem', fontWeight: 600 }}>
                              OHE Isolation
                            </span>
                          )}
                          {item.st_disconnection_required && (
                            <span style={{ background: '#fef3c7', color: '#92400e', padding: '2px 6px', borderRadius: '4px', fontSize: '0.7rem', fontWeight: 600 }}>
                              S&T Permit
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

      {/* TAB 3: ZONAL MAINTENANCE HISTORY */}
      {activeTab === 'history' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Calendar size={18} />
              Maintenance History Archive for {zoneName} ({historyData.length} Records)
            </div>
            <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
              <select
                className="ir-form-select"
                value={historyTimeframe}
                onChange={(e) => fetchZonalHistory(e.target.value)}
                style={{ width: 'auto', padding: '0.35rem 0.75rem', fontSize: '0.85rem' }}
              >
                <option value="all">All Available History</option>
                <option value="previous_week">Previous Week</option>
                <option value="previous_month">Previous Month</option>
              </select>
              <button className="ir-btn ir-btn-print" onClick={handlePrint}>
                <Printer size={14} />
                Print History
              </button>
            </div>
          </div>
          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Job ID</th>
                    <th>Dept</th>
                    <th>Division</th>
                    <th>Section</th>
                    <th>Work Type</th>
                    <th>Actual Execution Window</th>
                    <th>Duration</th>
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
                      <td><strong>{h.division || 'ASN'}</strong></td>
                      <td>{h.section || 'UDL-SNT'}</td>
                      <td>{h.work_type}</td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>Start: {h.actual_start ? h.actual_start.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                        <div>End: {h.actual_end ? h.actual_end.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                      </td>
                      <td><strong>{h.actual_duration_min || h.requested_duration_min}m</strong></td>
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
          Chief Track Engineer (CTE)<br/>{zoneName}
        </div>
        <div className="print-sig-box">
          Chief Signal & Telecom Engr (CSTE)<br/>{zoneName}
        </div>
        <div className="print-sig-box">
          Principal Chief Operations Mgr (PCOM)<br/>{zoneName}
        </div>
      </div>
    </div>
  );
};
