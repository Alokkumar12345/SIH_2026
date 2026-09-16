import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { PrintHeader } from '../components/PrintHeader';
import { EditBlockModal } from '../components/EditBlockModal';
import { 
  Building2, Train, Wrench, Radio, Zap, AlertCircle, 
  Printer, Calendar, Clock, BarChart3, Edit3, ShieldCheck, CheckCircle2, Play, Sparkles
} from 'lucide-react';

export const DivisionalDashboard = () => {
  const { user } = useAuth();
  const divisionName = user?.division || 'Asansol (ASN)';
  const divisionCode = user?.division_code || 'ASN';

  // Tabs: 'optimization', 'authorize', 'history'
  const [activeTab, setActiveTab] = useState('optimization');
  const [planType, setPlanType] = useState('WEEKLY'); // 'WEEKLY' or 'MONTHLY'
  const [optimizedPlan, setOptimizedPlan] = useState(null);
  const [isOptimizing, setIsOptimizing] = useState(false);

  // 1-Week Ahead Blocks for Authorization & Edit
  const [blocksAhead, setBlocksAhead] = useState([]);
  const [editingBlock, setEditingBlock] = useState(null);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);

  // Helper to strictly synchronize week number, date range, day name, and day index with the scheduled date
  const getWeekDetails = (scheduledDate, blk) => {
    let dateObj = null;
    if (scheduledDate) {
      const parts = String(scheduledDate).split('-');
      if (parts.length === 3) {
        dateObj = new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
      }
    }
    if (!dateObj || isNaN(dateObj.getTime())) {
      const baseDate = new Date(2026, 8, 16);
      const dayOff = (blk?.day_index || 1) - 1;
      dateObj = new Date(baseDate.getTime() + dayOff * 86400000);
    }

    const year = dateObj.getFullYear();
    const month = dateObj.getMonth();
    const day = dateObj.getDate();

    // Month-based week calculation:
    // Week 1: 1st - 7th
    // Week 2: 8th - 14th
    // Week 3: 15th - 21st
    // Week 4: 22nd - end of month (e.g. 30th/31st)
    let weekNum;
    let wStartDate;
    let wEndDate;

    const lastDayOfMonth = new Date(year, month + 1, 0).getDate();

    if (day <= 7) {
      weekNum = 1;
      wStartDate = new Date(year, month, 1);
      wEndDate = new Date(year, month, 7);
    } else if (day <= 14) {
      weekNum = 2;
      wStartDate = new Date(year, month, 8);
      wEndDate = new Date(year, month, 14);
    } else if (day <= 21) {
      weekNum = 3;
      wStartDate = new Date(year, month, 15);
      wEndDate = new Date(year, month, 21);
    } else {
      weekNum = 4;
      wStartDate = new Date(year, month, 22);
      wEndDate = new Date(year, month, lastDayOfMonth);
    }

    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    const formatShort = (d) => `${String(d.getDate()).padStart(2, '0')} ${monthNames[d.getMonth()]}`;
    const weekLabel = `Week ${weekNum} (${formatShort(wStartDate)} - ${formatShort(wEndDate)} ${wEndDate.getFullYear()})`;
    const dayName = dayNames[dateObj.getDay()];
    const dayIndex = day; // Day of the month (e.g. Day 30 on 30 Sep)
    const formattedDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

    return {
      weekNum,
      weekLabel,
      dayName,
      dayIndex,
      formattedDate
    };
  };

  // Maintenance History
  const [historyData, setHistoryData] = useState([]);
  const [historyTimeframe, setHistoryTimeframe] = useState('all');

  useEffect(() => {
    fetchBlocksAhead();
    fetchDivisionalHistory('all');
    // Pre-generate weekly plan on load for instant visualization
    handleGenerateWeeklyPlan();
  }, [divisionName]);

  const handleGenerateWeeklyPlan = async () => {
    setIsOptimizing(true);
    setPlanType('WEEKLY');
    try {
      const res = await fetch(`/api/divisional/optimize-weekly?division=${encodeURIComponent(divisionName)}`, {
        method: 'POST'
      });
      if (!res.ok) {
        throw new Error(`Server returned HTTP ${res.status}. Please ensure backend is running.`);
      }
      const data = await res.json();
      setOptimizedPlan(data);
    } catch (err) {
      alert('Error generating weekly optimization: ' + err.message);
    } finally {
      setIsOptimizing(false);
    }
  };

  const handleGenerateMonthlyPlan = async () => {
    setIsOptimizing(true);
    setPlanType('MONTHLY');
    try {
      const res = await fetch(`/api/divisional/optimize-monthly?division=${encodeURIComponent(divisionName)}`, {
        method: 'POST'
      });
      if (!res.ok) {
        throw new Error(`Server returned HTTP ${res.status}. Please ensure backend is running.`);
      }
      const data = await res.json();
      setOptimizedPlan(data);
    } catch (err) {
      alert('Error generating monthly optimization: ' + err.message);
    } finally {
      setIsOptimizing(false);
    }
  };

  const fetchBlocksAhead = async () => {
    try {
      const res = await fetch(`/api/divisional/blocks-ahead?division=${encodeURIComponent(divisionName)}`);
      if (!res.ok) return;
      const data = await res.json();
      setBlocksAhead(data.blocks || []);
    } catch (err) {
      console.error('Error fetching blocks ahead:', err);
    }
  };

  const fetchDivisionalHistory = async (timeframe) => {
    try {
      const res = await fetch(`/api/divisional/maintenance-history?division=${encodeURIComponent(divisionName)}&timeframe=${timeframe}`);
      if (!res.ok) return;
      const data = await res.json();
      setHistoryData(data.history || []);
      setHistoryTimeframe(timeframe);
    } catch (err) {
      console.error('Error fetching divisional history:', err);
    }
  };

  const handleOpenEditModal = (block) => {
    setEditingBlock(block);
    setIsEditModalOpen(true);
  };

  const handleBlockSaved = (updatedBlock) => {
    setBlocksAhead(prev => prev.map(b => b.block_id === updatedBlock.block_id ? updatedBlock : b));
  };

  const handleAuthorizeBlock = async (block) => {
    try {
      const res = await fetch('/api/divisional/authorize-block', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          block_id: block.block_id,
          notes: 'Authorized by Divisional Operations Manager'
        })
      });
      if (!res.ok) throw new Error('Authorization failed');
      const data = await res.json();
      setBlocksAhead(prev => prev.map(b => b.block_id === block.block_id ? data.block : b));
      alert(`Success: Block ${block.block_id} has been AUTHORIZED and dispatched to ${block.assigned_to || block.department + ' Section Engineer'}!`);
    } catch (err) {
      alert('Error authorizing block: ' + err.message);
    }
  };

  const handleAuthorizeAll = async () => {
    if (!confirm('Authorize all pending 1-week ahead blocks and dispatch to departmental Section Engineers?')) return;
    try {
      const res = await fetch('/api/divisional/authorize-all', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
      const data = await res.json();
      setBlocksAhead(data.blocks || []);
      alert('All blocks have been AUTHORIZED and sent to Section Engineers!');
    } catch (err) {
      alert('Error in batch authorization: ' + err.message);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="ir-page-container">
      {/* Official Hard Copy Print Header */}
      <PrintHeader 
        title={`DIVISIONAL LEVEL OPTIMIZED MAINTENANCE & BLOCK PROGRAM (${divisionName})`}
        subtitle="Divisional Operations Center (DOM / Sr. DEN / Sr. DEE / Sr. DSTE)"
        metadata={{ 
          zone: user?.zone || 'EASTERN RAILWAY', 
          division: divisionName, 
          department: 'Integrated TMS, SMMS, TDMS' 
        }}
      />

      {/* Hero Divisional Banner */}
      <div className="ir-card no-print" style={{
        background: 'linear-gradient(135deg, #4b0d0e 0%, #681214 55%, #0d3b66 100%)',
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
              {divisionName} Operations Portal
            </h2>
          </div>
          <p style={{ color: '#fed7aa', fontSize: '0.9rem' }}>
            ML-Powered Block Optimization, Improvisation (Edit), and Sectional Engineer Dispatching
          </p>
        </div>

        <div style={{ display: 'flex', gap: '0.75rem' }}>
          <button className="ir-btn ir-btn-print" onClick={handlePrint}>
            <Printer size={16} />
            <span>Print Current Report</span>
          </button>
        </div>
      </div>

      {/* Navigation Tabs */}
      <div className="no-print" style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.25rem', borderBottom: '2px solid #e2dec9', paddingBottom: '0.5rem' }}>
        <button 
          className={`ir-btn ${activeTab === 'optimization' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('optimization')}
        >
          <Sparkles size={16} />
          ML Optimization Engine (Weekly & Monthly Plans)
        </button>
        <button 
          className={`ir-btn ${activeTab === 'authorize' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('authorize')}
        >
          <ShieldCheck size={16} />
          Authorize Section (1-Week Ahead Schedule) ({blocksAhead.length})
        </button>
        <button 
          className={`ir-btn ${activeTab === 'history' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
          onClick={() => setActiveTab('history')}
        >
          <Calendar size={16} />
          Previous Maintenance History Archive ({historyData.length})
        </button>
      </div>

      {/* TAB 1: ML OPTIMIZATION (MONTHLY & WEEKLY GENERATION) */}
      {activeTab === 'optimization' && (
        <div>
          {/* Action Header Card with 2 Big Buttons */}
          <div className="ir-card no-print" style={{ background: '#ffffff', borderTop: '3px solid #c8861e' }}>
            <div className="ir-card-body">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '1rem' }}>
                <div>
                  <h3 style={{ fontSize: '1.15rem', color: '#4a0c0e', fontWeight: 700, marginBottom: '0.25rem' }}>
                    AI / ML Multi-Department Block Optimization Engine
                  </h3>
                  <p style={{ fontSize: '0.85rem', color: '#64748b' }}>
                    Solves joint track possession for Track (TMS), Signals (SMMS), and OHE (TDMS) 
                    minimizing train delay using Google OR-Tools CP-SAT.
                  </p>
                </div>

                <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                  {/* Button 1: Monthly Optimization */}
                  <button 
                    className={`ir-btn ${planType === 'MONTHLY' ? 'ir-btn-gold' : 'ir-btn-outline'}`}
                    onClick={handleGenerateMonthlyPlan}
                    disabled={isOptimizing}
                    style={{ padding: '0.65rem 1.25rem' }}
                  >
                    <Calendar size={18} />
                    <span>Generate Monthly Optimized Maintenance Data</span>
                  </button>

                  {/* Button 2: Weekly Optimization */}
                  <button 
                    className={`ir-btn ${planType === 'WEEKLY' ? 'ir-btn-primary' : 'ir-btn-outline'}`}
                    onClick={handleGenerateWeeklyPlan}
                    disabled={isOptimizing}
                    style={{ padding: '0.65rem 1.25rem' }}
                  >
                    <Clock size={18} />
                    <span>Generate Weekly Optimized Maintenance Data</span>
                  </button>

                  {/* Print Button for Optimization Plan */}
                  <button 
                    className="ir-btn ir-btn-print"
                    onClick={handlePrint}
                    style={{ padding: '0.65rem 1.1rem' }}
                  >
                    <Printer size={18} />
                    <span>Print Plan Hard Copy</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* KPIs from Optimization */}
          {optimizedPlan?.kpis && (
            <div className="ir-stats-grid">
              <div className="ir-stat-card stat-gold">
                <div className="ir-stat-icon"><BarChart3 size={24} /></div>
                <div className="ir-stat-data">
                  <span className="ir-stat-value">{optimizedPlan.kpis.scheduling_rate_percent}%</span>
                  <span className="ir-stat-label">Scheduling Feasibility Rate</span>
                </div>
              </div>

              <div className="ir-stat-card stat-tms">
                <div className="ir-stat-icon"><CheckCircle2 size={24} /></div>
                <div className="ir-stat-data">
                  <span className="ir-stat-value">{optimizedPlan.kpis.jobs_scheduled}</span>
                  <span className="ir-stat-label">Blocks Successfully Scheduled</span>
                </div>
              </div>

              <div className="ir-stat-card stat-tdms">
                <div className="ir-stat-icon"><Clock size={24} /></div>
                <div className="ir-stat-data">
                  <span className="ir-stat-value">{optimizedPlan.kpis.total_block_hours} hrs</span>
                  <span className="ir-stat-label">Total Block Hours Optimized</span>
                </div>
              </div>

              <div className="ir-stat-card stat-smms">
                <div className="ir-stat-icon"><Sparkles size={24} /></div>
                <div className="ir-stat-data">
                  <span className="ir-stat-value">{optimizedPlan.kpis.solver_wall_time_seconds}s</span>
                  <span className="ir-stat-label">CP-SAT Solver Time</span>
                </div>
              </div>
            </div>
          )}

          {/* Optimized Results Table */}
          <div className="ir-card">
            <div className="ir-card-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '0.75rem' }}>
              <div>
                <div className="ir-card-title">
                  <Train size={18} />
                  {planType === 'MONTHLY' 
                    ? 'Monthly Aggregated Optimization Schedule (4-Week Horizon)' 
                    : 'Weekly Detailed Corridor Maintenance Schedule (7-Day Working Horizon)'}
                </div>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginTop: '2px' }}>
                  Engine: <strong>Google OR-Tools CP-SAT (OPTIMAL)</strong> • Division: <strong>{divisionName}</strong> • Mode: <span style={{ fontWeight: 700, color: planType === 'MONTHLY' ? '#b45309' : '#0d47a1' }}>{planType} OPTIMIZED</span>
                </div>
              </div>
              <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
                <span style={{ 
                  background: planType === 'MONTHLY' ? '#fef3c7' : '#e0f2fe', 
                  color: planType === 'MONTHLY' ? '#92400e' : '#075985',
                  padding: '0.35rem 0.75rem',
                  borderRadius: '20px',
                  fontWeight: 700,
                  fontSize: '0.8rem',
                  border: '1px solid ' + (planType === 'MONTHLY' ? '#f59e0b' : '#38bdf8')
                }}>
                  {planType === 'MONTHLY' ? '📅 4-Week Rolling Horizon' : '⏱️ 7-Day Day-by-Day Horizon'}
                </span>
              </div>
            </div>
            <div className="ir-card-body">
              <div className="ir-table-container">
                <table className="ir-table">
                  <thead>
                    <tr>
                      <th>Job Ref ID</th>
                      <th>Dept</th>
                      <th>Section & Block Section</th>
                      <th>Line</th>
                      <th>Work Description</th>
                      <th>Execution Date & Day</th>
                      <th>Scheduled Slot Window</th>
                      <th>Designated Section Engineer</th>
                      <th>Priority & Risk</th>
                      <th>Multi-Dept Coordination</th>
                    </tr>
                  </thead>
                  <tbody>
                    {([...(optimizedPlan?.scheduled_blocks || [])].sort((a, b) => {
                      if (a.scheduled_date !== b.scheduled_date) {
                        return (a.scheduled_date || '').localeCompare(b.scheduled_date || '');
                      }
                      return (a.start_minute || 0) - (b.start_minute || 0);
                    })).map((blk, idx) => {
                      const weekInfo = getWeekDetails(blk.scheduled_date, blk);
                      return (
                        <tr key={idx} style={{ background: idx % 2 === 0 ? '#ffffff' : '#fcfbf8' }}>
                          <td style={{ fontFamily: 'monospace', fontWeight: 700, color: '#4a0c0e' }}>
                            {blk.job_id}
                          </td>
                          <td>
                            <span className={`dept-pill dept-pill-${blk.department ? (blk.department.includes('ENGINEERING') || blk.department === 'TMS' ? 'tms' : blk.department.includes('SIGNAL') || blk.department === 'SMMS' ? 'smms' : 'tdms') : 'tms'}`}>
                              {blk.department ? (blk.department.includes('ENGINEERING') || blk.department === 'TMS' ? 'TMS' : blk.department.includes('SIGNAL') || blk.department === 'SMMS' ? 'SMMS' : 'TDMS') : 'TMS'}
                            </span>
                          </td>
                          <td>
                            <strong style={{ color: '#1e293b' }}>{blk.section}</strong>
                            <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{blk.block_section}</div>
                          </td>
                          <td>
                            <span style={{ fontWeight: 600, fontSize: '0.82rem' }}>{blk.line}</span>
                          </td>
                          <td style={{ maxWidth: '220px' }}>
                            <div style={{ fontWeight: 600, fontSize: '0.85rem' }}>{blk.work_type}</div>
                            <div style={{ fontSize: '0.74rem', color: '#64748b' }}>Equip: {blk.equipment} • Gang: {blk.crew_size}</div>
                          </td>
                          <td>
                            {/* Clearly visible Date and Day of Week */}
                            {planType === 'MONTHLY' && (
                              <div style={{ marginBottom: '3px' }}>
                                <span style={{ 
                                  background: '#fef3c7', 
                                  color: '#92400e', 
                                  fontSize: '0.72rem', 
                                  padding: '1px 6px', 
                                  borderRadius: '4px', 
                                  fontWeight: 700 
                                }}>
                                  {weekInfo.weekLabel}
                                </span>
                              </div>
                            )}
                            <div style={{ fontWeight: 800, color: '#0d47a1', fontSize: '0.92rem' }}>
                              {weekInfo.formattedDate}
                            </div>
                            <div style={{ fontWeight: 700, color: '#1e293b', fontSize: '0.82rem' }}>
                              {weekInfo.dayName} (Day {weekInfo.dayIndex})
                            </div>
                          </td>
                        <td>
                          <div style={{ fontWeight: 700, color: '#15803d', fontSize: '0.88rem' }}>
                            {blk.scheduled_start_time} - {blk.scheduled_end_time}
                          </div>
                          <div style={{ fontSize: '0.75rem', color: '#64748b' }}>
                            Duration: <strong>{blk.assigned_duration_min} Mins</strong>
                          </div>
                        </td>
                        <td>
                          <div style={{ fontWeight: 600, color: '#334155', fontSize: '0.84rem' }}>
                            {blk.assigned_engineer || 'Section Engineer In-Charge'}
                          </div>
                          <div style={{ fontSize: '0.74rem', color: '#64748b' }}>
                            Slot: {blk.assigned_slot_id}
                          </div>
                        </td>
                        <td>
                          <div style={{ display: 'flex', gap: '0.4rem', alignItems: 'center' }}>
                            <span style={{ fontWeight: 700, color: '#15803d', fontSize: '0.85rem' }}>
                              Score: {typeof blk.priority_score === 'number' ? blk.priority_score.toFixed(1) : '85.0'}
                            </span>
                          </div>
                          <div style={{ fontSize: '0.74rem', color: blk.risk_probability > 0.5 ? '#b91c1c' : '#0369a1', fontWeight: 600 }}>
                            Risk: {blk.risk_probability ? (blk.risk_probability * 100).toFixed(0) + '%' : '35%'}
                          </div>
                        </td>
                        <td>
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '2px', fontSize: '0.74rem' }}>
                            {blk.coordination?.power_block_required && (
                              <span style={{ color: '#b91c1c', fontWeight: 700 }}>⚡ 25kV OHE Cut</span>
                            )}
                            {blk.coordination?.st_disconnection_required && (
                              <span style={{ color: '#c2410c', fontWeight: 700 }}>🚦 S&T Disconnect</span>
                            )}
                            <span style={{ color: '#15803d', fontWeight: 600 }}>
                              ✓ Joint Possession Synced
                            </span>
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* TAB 2: AUTHORIZE SECTION (1-WEEK AHEAD SCHEDULE WITH EDIT & AUTHORIZE) */}
      {activeTab === 'authorize' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div>
              <div className="ir-card-title">
                <ShieldCheck size={18} />
                1-Week Ahead Maintenance Schedule - Review, Improvise (Edit) & Authorize
              </div>
              <div style={{ fontSize: '0.82rem', color: '#64748b', marginTop: '0.2rem' }}>
                Divisional officers can adjust dates, times, and line possession via <strong>Edit</strong>.
                Clicking <strong>Authorize</strong> immediately transmits the maintenance schedule to that Section Engineer.
              </div>
            </div>

            <div style={{ display: 'flex', gap: '0.5rem' }}>
              <button className="ir-btn ir-btn-success no-print" onClick={handleAuthorizeAll}>
                <ShieldCheck size={16} />
                Authorize All Blocks
              </button>
              <button className="ir-btn ir-btn-print" onClick={handlePrint}>
                <Printer size={16} />
                Print Authorize Report
              </button>
            </div>
          </div>

          <div className="ir-card-body">
            <div className="ir-table-container">
              <table className="ir-table">
                <thead>
                  <tr>
                    <th>Block ID</th>
                    <th>Dept</th>
                    <th>Section & Block Section</th>
                    <th>Date & Window</th>
                    <th>Line & Equipment</th>
                    <th>Priority & Risk</th>
                    <th>Assigned Section Engineer</th>
                    <th>Improvisation Status</th>
                    <th className="no-print" style={{ textAlign: 'center' }}>Action Controls</th>
                  </tr>
                </thead>
                <tbody>
                  {blocksAhead.map((blk, idx) => (
                    <tr key={idx}>
                      <td style={{ fontFamily: 'monospace', fontWeight: 700 }}>{blk.block_id}</td>
                      <td>
                        <span className={`dept-pill dept-pill-${blk.department.toLowerCase()}`}>
                          {blk.department}
                        </span>
                      </td>
                      <td>
                        <strong>{blk.section_display || blk.section}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{blk.block_section_name || blk.block_section}</div>
                      </td>
                      <td>
                        <div><strong>{blk.scheduled_date}</strong></div>
                        <div style={{ fontSize: '0.8rem', color: '#0d47a1', fontWeight: 600 }}>
                          {blk.preferred_start} - {blk.preferred_end} ({blk.duration_min}m)
                        </div>
                      </td>
                      <td>
                        <div>{blk.line}</div>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{blk.equipment}</div>
                      </td>
                      <td>
                        <span style={{ fontWeight: 700, color: blk.priority === 'CRITICAL' ? '#b91c1c' : '#c2410c' }}>
                          {blk.priority}
                        </span>
                      </td>
                      <td>
                        <div style={{ fontWeight: 600, color: '#1e293b' }}>{blk.assigned_to}</div>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>Section: {blk.section}</div>
                      </td>
                      <td>
                        {/* Requirement: Clearly show if data has been edited */}
                        {blk.is_edited ? (
                          <div>
                            <span className="badge-edited">
                              <Edit3 size={11} />
                              EDITED BY DIVISION
                            </span>
                            <div style={{ fontSize: '0.7rem', color: '#c2410c', marginTop: '2px' }}>
                              Modified by DOM
                            </div>
                          </div>
                        ) : (
                          <span style={{ color: '#94a3b8', fontSize: '0.78rem' }}>Original Plan</span>
                        )}
                      </td>
                      <td className="no-print" style={{ textAlign: 'center' }}>
                        <div style={{ display: 'flex', gap: '0.4rem', justifyContent: 'center' }}>
                          {/* 1. Edit Button */}
                          <button
                            className="ir-btn ir-btn-outline"
                            onClick={() => handleOpenEditModal(blk)}
                            style={{ padding: '0.35rem 0.65rem', fontSize: '0.78rem' }}
                            title="Divisional Officer Improvise Date/Time/Equipment"
                          >
                            <Edit3 size={13} />
                            Edit
                          </button>

                          {/* 2. Authorize Button */}
                          {blk.authorized ? (
                            <span className="badge-authorized" title="Dispatched to Section Engineer">
                              <CheckCircle2 size={13} />
                              Authorized
                            </span>
                          ) : (
                            <button
                              className="ir-btn ir-btn-success"
                              onClick={() => handleAuthorizeBlock(blk)}
                              style={{ padding: '0.35rem 0.75rem', fontSize: '0.78rem' }}
                              title="Authorize and send to Section Engineer"
                            >
                              <ShieldCheck size={13} />
                              Authorize
                            </button>
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

      {/* TAB 3: MAINTENANCE HISTORY (PREVIOUS WEEK & MONTH) */}
      {activeTab === 'history' && (
        <div className="ir-card">
          <div className="ir-card-header">
            <div className="ir-card-title">
              <Calendar size={18} />
              Previous Maintenance History for {divisionName} ({historyData.length} Records)
            </div>
            <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
              <select
                className="ir-form-select"
                value={historyTimeframe}
                onChange={(e) => fetchDivisionalHistory(e.target.value)}
                style={{ width: 'auto', padding: '0.35rem 0.75rem', fontSize: '0.85rem' }}
              >
                <option value="all">All Available History</option>
                <option value="previous_week">Previous Week Only</option>
                <option value="previous_month">Previous Month Only</option>
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
                    <th>Section & Block</th>
                    <th>Line</th>
                    <th>Work Type</th>
                    <th>Actual Window Executed</th>
                    <th>Actual Duration</th>
                    <th>Crew / Tooling</th>
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
                        <strong>{h.section || 'UDL-SNT'}</strong>
                        <div style={{ fontSize: '0.75rem', color: '#64748b' }}>{h.block_section || 'UDL-UKA'}</div>
                      </td>
                      <td>{h.line || 'UP_MAIN'}</td>
                      <td>{h.work_type}</td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>{h.actual_start ? h.actual_start.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                        <div>to {h.actual_end ? h.actual_end.replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                      </td>
                      <td>
                        <strong>{h.actual_duration_min || h.requested_duration_min} Mins</strong>
                      </td>
                      <td style={{ fontSize: '0.8rem' }}>
                        <div>{h.equipment || 'Machinery'}</div>
                        <div style={{ color: '#64748b' }}>{h.crew_size || 8} Gangmen</div>
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

      {/* Edit Modal */}
      <EditBlockModal
        block={editingBlock}
        isOpen={isEditModalOpen}
        onClose={() => setIsEditModalOpen(false)}
        onSave={handleBlockSaved}
      />

      {/* Signature block for hard copy printout */}
      <div className="print-signature-block print-only">
        <div className="print-sig-box">
          Senior Divisional Engineer (Sr. DEN)<br/>{divisionName}
        </div>
        <div className="print-sig-box">
          Sr. Divisional Signal & Telecom Engr (Sr. DSTE)<br/>{divisionName}
        </div>
        <div className="print-sig-box">
          Senior Divisional Operations Manager (Sr. DOM)<br/>{divisionName}
        </div>
      </div>
    </div>
  );
};
