import React from 'react';
import { useAuth } from '../context/AuthContext';
import { Printer, LogOut, Shield, MapPin, User, Train, HardDrive, Calendar } from 'lucide-react';

export const Navbar = ({ activeTab, onTabChange, title, onPrint }) => {
  const { user, logout } = useAuth();

  const handlePrint = () => {
    if (onPrint) {
      onPrint();
    } else {
      window.print();
    }
  };

  const currentDateStr = new Date().toLocaleDateString('en-IN', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  return (
    <header className="no-print">
      {/* Top Government Utility Bar */}
      <div className="ir-top-util-bar">
        <div style={{ display: 'flex', alignItems: 'center', gap: '1.25rem' }}>
          <span><strong>भारत सरकार / Government of India</strong></span>
          <span>|</span>
          <span>रेल मंत्रालय / Ministry of Railways</span>
          <span>|</span>
          <span>{currentDateStr}</span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          <button onClick={() => window.print()} title="Print current page">
            <Printer size={13} />
            <span>Print Page</span>
          </button>
          <span>|</span>
          <span>Language: <strong>हिन्दी / English</strong></span>
          <span>|</span>
          <span>Font: <strong>A+ A A-</strong></span>
        </div>
      </div>

      {/* Main Indian Railways & CRIS Branding Header */}
      <div className="ir-main-header">
        <div className="ir-brand-group">
          {/* Official Emblem Circle */}
          <div className="ir-logo-circle">
            <svg width="42" height="42" viewBox="0 0 100 100">
              <circle cx="50" cy="50" r="46" fill="#800000" stroke="#c8861e" strokeWidth="4"/>
              <circle cx="50" cy="50" r="32" fill="#ffffff" stroke="#c8861e" strokeWidth="2"/>
              <path d="M50 18 L50 82 M18 50 L82 50 M27 27 L73 73 M27 73 L73 27" stroke="#800000" strokeWidth="3.5"/>
              <circle cx="50" cy="50" r="10" fill="#c8861e"/>
              <text x="50" y="54" textAnchor="middle" fill="#ffffff" fontSize="12" fontWeight="bold" fontFamily="sans-serif">IR</text>
            </svg>
          </div>

          <div className="ir-brand-titles">
            <span className="ir-title-hindi">रेलपथ एवं ब्लॉक नियोजन प्रणाली (IMBPS)</span>
            <span className="ir-title-english">Integrated Maintenance & Block Planning System</span>
            <span className="ir-title-sub">Centre for Railway Information Systems (CRIS) | Indian Railways Cloud</span>
          </div>
        </div>

        {/* User Info and Logout */}
        {user && (
          <div className="ir-header-right">
            <div className="ir-user-badge">
              <div style={{ background: '#c8861e', padding: '0.4rem', borderRadius: '50%', color: '#fff' }}>
                <User size={18} />
              </div>
              <div className="ir-user-info-text">
                <div className="ir-user-name">{user.name}</div>
                <div className="ir-user-role">
                  {user.role_display}
                  {user.division && ` • ${user.division}`}
                </div>
              </div>
            </div>

            <button 
              className="ir-btn ir-btn-print"
              onClick={handlePrint}
              title="Print official hard copy"
            >
              <Printer size={15} />
              <span>Print Hard Copy</span>
            </button>

            <button 
              className="ir-btn ir-btn-logout"
              onClick={logout}
              title="Sign out of railway portal"
            >
              <LogOut size={14} />
              <span>Logout</span>
            </button>
          </div>
        )}
      </div>

      {/* Navigation Ribbon */}
      <nav className="ir-nav-ribbon">
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem' }}>
          <Train size={16} color="#fed7aa" />
          <span style={{ fontWeight: 700, color: '#fed7aa', letterSpacing: '0.5px' }}>
            {user?.role === 'central_admin' && 'CENTRAL RAILWAY BOARD CONTROL PANEL'}
            {user?.role === 'zonal_admin' && `ZONAL HEADQUARTERS PORTAL (${user?.zone || 'ER'})`}
            {user?.role === 'divisional_admin' && `DIVISIONAL OPERATIONS CONSOLE (${user?.division || 'ASN'})`}
            {user?.role === 'section_engineer' && `SECTION ENGINEER WORKSPACE (${user?.department_display})`}
          </span>
        </div>

        {onTabChange && (
          <ul className="ir-nav-links">
            {user?.role === 'central_admin' && (
              <>
                <li className={`ir-nav-link ${activeTab === 'zonal_summary' ? 'active' : ''}`} onClick={() => onTabChange('zonal_summary')}>
                  Pan-India Zonal Summary
                </li>
                <li className={`ir-nav-link ${activeTab === 'pending_works' ? 'active' : ''}`} onClick={() => onTabChange('pending_works')}>
                  National Pending Works
                </li>
                <li className={`ir-nav-link ${activeTab === 'history' ? 'active' : ''}`} onClick={() => onTabChange('history')}>
                  Maintenance History
                </li>
                <li className={`ir-nav-link ${activeTab === 'ml_training' ? 'active' : ''}`} onClick={() => onTabChange('ml_training')}>
                  ML Model Training Hub
                </li>
              </>
            )}

            {user?.role === 'zonal_admin' && (
              <>
                <li className={`ir-nav-link ${activeTab === 'div_summary' ? 'active' : ''}`} onClick={() => onTabChange('div_summary')}>
                  Divisional Pending Breakdown
                </li>
                <li className={`ir-nav-link ${activeTab === 'pending_requisitions' ? 'active' : ''}`} onClick={() => onTabChange('pending_requisitions')}>
                  Pending Requisitions
                </li>
                <li className={`ir-nav-link ${activeTab === 'history' ? 'active' : ''}`} onClick={() => onTabChange('history')}>
                  Zonal Maintenance History
                </li>
              </>
            )}

            {user?.role === 'divisional_admin' && (
              <>
                <li className={`ir-nav-link ${activeTab === 'optimization' ? 'active' : ''}`} onClick={() => onTabChange('optimization')}>
                  ML Block Optimization
                </li>
                <li className={`ir-nav-link ${activeTab === 'authorize' ? 'active' : ''}`} onClick={() => onTabChange('authorize')}>
                  Authorize & Dispatch (1-Wk Ahead)
                </li>
                <li className={`ir-nav-link ${activeTab === 'history' ? 'active' : ''}`} onClick={() => onTabChange('history')}>
                  Maintenance History Archive
                </li>
              </>
            )}

            {user?.role === 'section_engineer' && (
              <>
                <li className={`ir-nav-link ${activeTab === 'current_report' ? 'active' : ''}`} onClick={() => onTabChange('current_report')}>
                  Section 1: Current Maintenance Report
                </li>
                <li className={`ir-nav-link ${activeTab === 'log_work' ? 'active' : ''}`} onClick={() => onTabChange('log_work')}>
                  Section 2: Log Maintenance History (Neon DB)
                </li>
                <li className={`ir-nav-link ${activeTab === 'my_logs' ? 'active' : ''}`} onClick={() => onTabChange('my_logs')}>
                  Completed Logs Archive
                </li>
              </>
            )}
          </ul>
        )}
      </nav>
    </header>
  );
};
