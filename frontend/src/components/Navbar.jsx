import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Printer, LogOut, User, Train } from 'lucide-react';
import railwayLogo from '../assets/Railway_logo.png';

export const Navbar = ({ activeTab, onTabChange, onPrint }) => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handlePrint = () => {
    if (onPrint) {
      onPrint();
    } else {
      window.print();
    }
  };

  const handleLogout = () => {
    logout();
    navigate('/login', { replace: true });
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
      <div 
        className="ir-top-util-bar" 
        style={{ 
          display: 'flex', 
          justifyContent: 'center', 
          alignItems: 'center', 
          width: '100%' 
        }}
        >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '1.25rem', textAlign: 'center' }}>
          <span><strong>भारत सरकार / Government of India</strong></span>
          <span>|</span>
          <span>रेल मंत्रालय / Ministry of Railways</span>
          <span>|</span>
          <span>{currentDateStr}</span>
        </div>        
      </div>

      {/* Main Indian Railways & CRIS Branding Header */}
      <div className="ir-main-header">
        <div className="ir-brand-group">
          {/* Official Emblem Circle */}
          <div className="ir-logo-circle">
            <img src={railwayLogo} alt="Indian Railways Logo" style={{ width: '100%', height: '100%', objectFit: 'contain' }} />
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
              className="ir-btn ir-btn-logout"
              onClick={handleLogout}
              title="Sign out of railway portal"
            >
              <LogOut size={14} />
              <span>Logout</span>
            </button>
          </div>
        )}
      </div>

      {/* Navigation Ribbon */}
      <nav 
        className="ir-nav-ribbon" 
        style={{ 
          display: 'flex', 
          justifyContent: 'center', 
          alignItems: 'center', 
          width: '100%' 
        }}
        >
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem' }}>
          <Train size={16} color="#fed7aa" />
          <span style={{ fontWeight: 700, color: '#fed7aa', letterSpacing: '0.5px' }}>
            {user?.role === 'central_admin' && 'CENTRAL RAILWAY BOARD CONTROL PANEL'}
            {user?.role === 'zonal_admin' && `ZONAL HEADQUARTERS PORTAL (${user?.zone || 'ER'})`}
            {user?.role === 'divisional_admin' && `DIVISIONAL OPERATIONS CONSOLE (${user?.division || 'ASN'})`}
            {user?.role === 'section_engineer' && `SECTION ENGINEER WORKSPACE (${user?.department_display})`}
          </span>
        </div>
      </nav>
    </header>
  );
};