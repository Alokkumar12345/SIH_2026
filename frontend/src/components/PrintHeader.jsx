import React from 'react';
import railwayLogo from '../assets/Railway_logo.png';

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
          <img src={railwayLogo} alt="Indian Railways Logo" style={{ width: '70px', height: '70px', objectFit: 'contain' }} />
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
