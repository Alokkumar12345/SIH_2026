import React, { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import { Navbar } from './components/Navbar';
import { LoginPage } from './pages/LoginPage';
import { CentralDashboard } from './pages/CentralDashboard';
import { ZonalDashboard } from './pages/ZonalDashboard';
import { DivisionalDashboard } from './pages/DivisionalDashboard';
import { UserPortal } from './pages/UserPortal';
import './styles/railway-theme.css';
import './styles/print.css';

// Guard component to enforce authentication and role authorization
function ProtectedRoute({ children, allowedRoles }) {
  const { user } = useAuth();

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (allowedRoles && !allowedRoles.includes(user.role)) {
    return <Navigate to="/" replace />;
  }

  return children;
}

// Redirects root '/' to the appropriate role route
function RoleRedirect() {
  const { user } = useAuth();
  if (!user) return <Navigate to="/login" replace />;
  if (user.role === 'central_admin') return <Navigate to="/admin" replace />;
  if (user.role === 'zonal_admin') return <Navigate to="/zonal" replace />;
  if (user.role === 'divisional_admin') return <Navigate to="/divisional" replace />;
  if (user.role === 'section_engineer') return <Navigate to="/portal" replace />;
  return <Navigate to="/login" replace />;
}

export function App() {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState(() => {
    if (user?.role === 'central_admin') return 'zonal_summary';
    if (user?.role === 'zonal_admin') return 'div_summary';
    if (user?.role === 'divisional_admin') return 'optimization';
    if (user?.role === 'section_engineer') return 'current_report';
    return '';
  });

  return (
    <BrowserRouter>
      <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
        {user && <Navbar activeTab={activeTab} onTabChange={setActiveTab} />}

        <main style={{ flex: 1 }}>
          <Routes>
            <Route 
              path="/login" 
              element={user ? <RoleRedirect /> : <LoginPage />} 
            />

            <Route 
              path="/admin" 
              element={
                <ProtectedRoute allowedRoles={['central_admin']}>
                  <CentralDashboard />
                </ProtectedRoute>
              } 
            />

            <Route 
              path="/zonal" 
              element={
                <ProtectedRoute allowedRoles={['zonal_admin']}>
                  <ZonalDashboard />
                </ProtectedRoute>
              } 
            />

            <Route 
              path="/divisional" 
              element={
                <ProtectedRoute allowedRoles={['divisional_admin']}>
                  <DivisionalDashboard />
                </ProtectedRoute>
              } 
            />

            <Route 
              path="/portal" 
              element={
                <ProtectedRoute allowedRoles={['section_engineer']}>
                  <UserPortal />
                </ProtectedRoute>
              } 
            />

            <Route path="*" element={<RoleRedirect />} />
          </Routes>
        </main>

        {user && (
          <footer className="ir-footer no-print">
            <div className="ir-footer-left">
              <span>Centre for Railway Information Systems (CRIS)</span>
            </div>
            <div className="ir-footer-right">
              © 2026, Ministry of Railways, Government of India. All rights reserved.
            </div>
          </footer>
        )}
      </div>
    </BrowserRouter>
  );
}

export default App;