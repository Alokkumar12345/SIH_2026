import React from 'react';

export const PrintHeader = ({ title, subtitle, metadata = {} }) => {
  const printDate = new Date().toLocaleString('en-IN', {
    dateStyle: 'full',
    timeStyle: 'medium',
    timeZone: 'Asia/Kolkata'
  });

  return (
    <div className="print-letterhead print-only">
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: '1.5rem', marginBottom: '8px' }}>
        {/* Ashoka Emblem SVG representation */}
        <svg width="40" height="40" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="50" cy="50" r="46" stroke="#000" strokeWidth="4"/>
          <circle cx="50" cy="50" r="16" stroke="#000" strokeWidth="3"/>
          <path d="M50 10 L50 90 M10 50 L90 50 M22 22 L78 78 M22 78 L78 22" stroke="#000" strokeWidth="2"/>
        </svg>
        <div>
          <h1>GOVERNMENT OF INDIA / MINISTRY OF RAILWAYS</h1>
          <h2>INTEGRATED MAINTENANCE & BLOCK PLANNING SYSTEM (IMBPS)</h2>
          <p style={{ fontWeight: 'bold', fontSize: '11pt' }}>{title}</p>
          {subtitle && <p style={{ fontStyle: 'italic', fontSize: '9.5pt' }}>{subtitle}</p>}
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', borderTop: '1px solid #000', paddingTop: '4pt', fontSize: '8.5pt' }}>
        <span><strong>Zone / Division:</strong> {metadata.zone || 'All Zones'} / {metadata.division || 'All Divisions'}</span>
        <span><strong>Department:</strong> {metadata.department || 'Multi-Department (TMS / SMMS / TDMS)'}</span>
        <span><strong>Printed On:</strong> {printDate} (IST)</span>
      </div>
    </div>
  );
};
