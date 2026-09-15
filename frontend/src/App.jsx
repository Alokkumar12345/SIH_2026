import React, { useState } from 'react';
import { useAuth } from './context/AuthContext';
import { Navbar } from './components/Navbar';
import { LoginPage } from './pages/LoginPage';
import { CentralDashboard } from './pages/CentralDashboard';
import { ZonalDashboard } from './pages/ZonalDashboard';
import { DivisionalDashboard } from './pages/DivisionalDashboard';
import { UserPortal } from './pages/UserPortal';
import './styles/railway-theme.css';
import './styles/print.css';

export function App() {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState(() => {
    if (user?.role === 'central_admin') return 'zonal_summary';
    if (user?.role === 'zonal_admin') return 'div_summary';
    if (user?.role === 'divisional_admin') return 'optimization';
    if (user?.role === 'section_engineer') return 'current_report';
    return '';
  });

  if (!user) {
    return <LoginPage />;
  }

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar activeTab={activeTab} onTabChange={setActiveTab} />
      
      <main style={{ flex: 1 }}>
        {user.role === 'central_admin' && <CentralDashboard />}
        {user.role === 'zonal_admin' && <ZonalDashboard />}
        {user.role === 'divisional_admin' && <DivisionalDashboard />}
        {user.role === 'section_engineer' && <UserPortal />}
      </main>

      <footer className="ir-footer no-print">
        <div className="ir-footer-left">
          <span>Centre for Railway Information Systems (CRIS)</span>
          <span>|</span>
          <span>Integrated Maintenance & Block Planning System (IMBPS)</span>
          <span>|</span>
          <span>Neon PostgreSQL Live Engine</span>
        </div>
        <div className="ir-footer-right">
          © 2026, Ministry of Railways, Government of India. All rights reserved.
        </div>
      </footer>
    </div>
  );
}

export default App;
