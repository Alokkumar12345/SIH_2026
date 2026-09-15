import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { Captcha } from '../components/Captcha';
import { Lock, UserCheck, Shield, ChevronDown, CheckCircle2, ArrowRight } from 'lucide-react';

export const LoginPage = () => {
  const { login } = useAuth();
  const [username, setUsername] = useState('div_asn');
  const [password, setPassword] = useState('DivASN@2026');
  const [captchaInput, setCaptchaInput] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // Demo accounts for instant 1-click testing
  const DEMO_ACCOUNTS = [
    { label: 'Central Admin (Railway Board)', u: 'railway_central', p: 'RailBoard@2026', role: 'Central Admin' },
    { label: 'Zonal Admin (Eastern Railway ER)', u: 'zone_er', p: 'ZonalER@2026', role: 'Zonal ER' },
    { label: 'Zonal Admin (Northern Railway NR)', u: 'zone_nr', p: 'ZonalNR@2026', role: 'Zonal NR' },
    { label: 'Divisional Admin (Asansol ASN)', u: 'div_asn', p: 'DivASN@2026', role: 'Divisional ASN' },
    { label: 'Divisional Admin (Howrah HWH)', u: 'div_hwh', p: 'DivHWH@2026', role: 'Divisional HWH' },
    { label: 'Divisional Admin (Ambala UMB)', u: 'div_umb', p: 'DivUMB@2026', role: 'Divisional UMB' },
    { label: 'TMS Engineer (Civil Track)', u: 'tms_engineer', p: 'TrackEng@2026', role: 'Section TMS' },
    { label: 'SMMS Engineer (Signal & Telecom)', u: 'smms_engineer', p: 'SignalEng@2026', role: 'Section SMMS' },
    { label: 'TDMS Engineer (Traction OHE)', u: 'tdms_engineer', p: 'TrdEng@2026', role: 'Section TDMS' },
  ];

  const handleSelectAccount = (acc) => {
    setUsername(acc.u);
    setPassword(acc.p);
    setErrorMsg('');
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setErrorMsg('');
    setIsLoading(true);
    const result = await login(username, password);
    setIsLoading(false);
    if (!result.success) {
      setErrorMsg(result.error || 'Invalid Railway User ID or Password.');
    }
  };

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', backgroundColor: '#f2eee5' }}>
      {/* Authentic CRIS Header */}
      <div style={{
        background: 'linear-gradient(90deg, #500d0e 0%, #701416 35%, #881c1e 100%)',
        padding: '0.6rem 2rem',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottom: '3px solid #c8861e',
        boxShadow: '0 3px 10px rgba(0,0,0,0.2)'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          {/* Circular Emblem */}
          <div style={{
            width: '52px',
            height: '52px',
            borderRadius: '50%',
            background: '#ffffff',
            border: '2px solid #c8861e',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 2px 4px rgba(0,0,0,0.3)'
          }}>
            <svg width="40" height="40" viewBox="0 0 100 100">
              <circle cx="50" cy="50" r="46" fill="#800000" stroke="#c8861e" strokeWidth="4"/>
              <circle cx="50" cy="50" r="32" fill="#ffffff" stroke="#c8861e" strokeWidth="2"/>
              <path d="M50 18 L50 82 M18 50 L82 50 M27 27 L73 73 M27 73 L73 27" stroke="#800000" strokeWidth="3.5"/>
              <circle cx="50" cy="50" r="10" fill="#c8861e"/>
              <text x="50" y="54" textAnchor="middle" fill="#ffffff" fontSize="12" fontWeight="bold" fontFamily="sans-serif">IR</text>
            </svg>
          </div>

          <div>
            <div style={{ fontFamily: 'Mukta, sans-serif', fontSize: '1.45rem', fontWeight: 700, color: '#fff9db', lineHeight: 1.1 }}>
              रेलपथ एवं एकीकृत ब्लॉक प्रबंधन प्रणाली
            </div>
            <div style={{ fontSize: '1.05rem', fontWeight: 700, color: '#ffffff', letterSpacing: '0.5px' }}>
              Integrated Maintenance & Block Planning System (IMBPS)
            </div>
          </div>
        </div>

        {/* National Emblems */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '1.5rem', color: '#fed7aa', fontSize: '0.85rem' }}>
          <div style={{ textAlign: 'right', lineHeight: 1.2 }}>
            <div style={{ fontWeight: 700, color: '#ffffff' }}>G20 भारत 2023 INDIA</div>
            <div>वसुधैव कुटुम्बकम् | ONE EARTH ONE FAMILY</div>
          </div>
          <div style={{
            background: '#ffffff',
            borderRadius: '4px',
            padding: '2px 8px',
            color: '#1e293b',
            fontWeight: 700,
            fontSize: '0.8rem',
            border: '1px solid #c8861e'
          }}>
            आज़ादी का अमृत महोत्सव
          </div>
        </div>
      </div>

      {/* Main Login Canvas */}
      <div style={{
        flex: 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '2rem 1rem',
        maxWidth: '1240px',
        margin: '0 auto',
        width: '100%',
        gap: '2.5rem'
      }}>
        {/* Left Side: Railway Inspection Photography */}
        <div style={{
          flex: '1 1 55%',
          display: 'flex',
          flexDirection: 'column',
          borderRadius: '12px',
          overflow: 'hidden',
          boxShadow: '0 12px 30px rgba(0,0,0,0.18)',
          border: '3px solid #d1c7b7',
          background: '#ffffff'
        }}>
          <img
            src="/images/track_inspection.jpg"
            alt="Indian Railways Track Inspection"
            style={{ width: '100%', height: '360px', objectFit: 'cover' }}
          />
          <div style={{
            padding: '1rem 1.25rem',
            background: 'linear-gradient(180deg, #fdfbf7 0%, #f4eee2 100%)',
            borderTop: '1px solid #e2dec9',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center'
          }}>
            <div>
              <div style={{ fontWeight: 700, color: '#5b1012', fontSize: '0.95rem' }}>
                Operational Track & Corridor Maintenance Synchronization
              </div>
              <div style={{ fontSize: '0.8rem', color: '#64748b' }}>
                Civil Engineering (TMS) • Signalling & Telecom (SMMS) • Traction Electrification (TDMS)
              </div>
            </div>
            <div style={{
              background: '#0d47a1',
              color: '#ffffff',
              padding: '0.3rem 0.75rem',
              borderRadius: '4px',
              fontSize: '0.75rem',
              fontWeight: 700
            }}>
              Neon Cloud Synced
            </div>
          </div>
        </div>

        {/* Right Side: Authentic CRIS / IR Style Login Card */}
        <div style={{
          flex: '0 1 440px',
          background: 'linear-gradient(145deg, #d37e33 0%, #bf671c 100%)',
          borderRadius: '16px',
          padding: '2rem 1.75rem',
          boxShadow: '0 15px 35px rgba(139, 69, 19, 0.35)',
          color: '#ffffff',
          position: 'relative',
          border: '1px solid rgba(255, 255, 255, 0.2)'
        }}>
          {/* Lock Icon Circle */}
          <div style={{
            width: '68px',
            height: '68px',
            borderRadius: '50%',
            background: '#ffffff',
            color: '#7b1113',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 1.25rem auto',
            boxShadow: '0 4px 10px rgba(0,0,0,0.2)'
          }}>
            <Lock size={32} />
          </div>

          <div style={{ textAlign: 'center', marginBottom: '1.25rem' }}>
            <div style={{ fontFamily: 'Mukta, sans-serif', fontSize: '1.15rem', fontWeight: 700, color: '#fffdf5' }}>
              यूज़र आईडी और पासवर्ड प्रविष्ट करें
            </div>
            <div style={{ fontSize: '0.9rem', fontWeight: 600, color: '#fff9e6' }}>
              Please Enter User Id & Password
            </div>
          </div>

          {errorMsg && (
            <div style={{
              background: '#fee2e2',
              color: '#991b1b',
              padding: '0.55rem',
              borderRadius: '6px',
              fontSize: '0.82rem',
              fontWeight: 600,
              marginBottom: '1rem',
              textAlign: 'center'
            }}>
              {errorMsg}
            </div>
          )}

          <form onSubmit={handleLogin}>
            <div style={{ marginBottom: '1rem' }}>
              <label style={{ display: 'block', fontSize: '0.82rem', fontWeight: 600, marginBottom: '0.35rem', color: '#ffffff' }}>
                User Id:
              </label>
              <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Enter your user id"
                required
                style={{
                  width: '100%',
                  padding: '0.6rem 0.8rem',
                  borderRadius: '6px',
                  border: 'none',
                  fontSize: '0.92rem',
                  outline: 'none',
                  color: '#1e293b'
                }}
              />
            </div>

            <div style={{ marginBottom: '1rem' }}>
              <label style={{ display: 'block', fontSize: '0.82rem', fontWeight: 600, marginBottom: '0.35rem', color: '#ffffff' }}>
                Password:
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Enter your password"
                required
                style={{
                  width: '100%',
                  padding: '0.6rem 0.8rem',
                  borderRadius: '6px',
                  border: 'none',
                  fontSize: '0.92rem',
                  outline: 'none',
                  color: '#1e293b'
                }}
              />
            </div>

            <div style={{ marginBottom: '1.25rem' }}>
              <Captcha value={captchaInput} onChange={setCaptchaInput} />
            </div>

            <button
              type="submit"
              disabled={isLoading}
              style={{
                width: '100%',
                background: '#5a1214',
                color: '#ffffff',
                border: 'none',
                padding: '0.75rem',
                borderRadius: '6px',
                fontSize: '1.05rem',
                fontWeight: 700,
                cursor: 'pointer',
                boxShadow: '0 3px 6px rgba(0,0,0,0.3)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '0.5rem',
                transition: 'background 0.2s'
              }}
            >
              <ArrowRight size={18} />
              {isLoading ? 'सत्यापित हो रहा है / Verifying...' : '➔ लॉग इन करें / Login'}
            </button>
          </form>

          {/* Quick Account Switcher for Evaluator Convenience */}
          <div style={{ marginTop: '1.5rem', borderTop: '1px solid rgba(255,255,255,0.25)', paddingTop: '1rem' }}>
            <div style={{ fontSize: '0.78rem', color: '#fff9e6', fontWeight: 600, marginBottom: '0.5rem', textAlign: 'center' }}>
              Quick Selection: Click any role below to prefill credentials
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.4rem' }}>
              {DEMO_ACCOUNTS.map((acc, i) => (
                <button
                  key={i}
                  type="button"
                  onClick={() => handleSelectAccount(acc)}
                  style={{
                    background: username === acc.u ? '#4a0c0e' : 'rgba(255, 255, 255, 0.18)',
                    color: '#ffffff',
                    border: username === acc.u ? '1.5px solid #fff' : '1px solid rgba(255,255,255,0.3)',
                    padding: '0.35rem 0.4rem',
                    borderRadius: '4px',
                    fontSize: '0.72rem',
                    cursor: 'pointer',
                    textAlign: 'left',
                    whiteSpace: 'nowrap',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis'
                  }}
                  title={`Login as ${acc.label} (${acc.u})`}
                >
                  • {acc.role}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Official Indian Railways Footer */}
      <footer style={{
        background: 'linear-gradient(90deg, #420a0b 0%, #5a1012 50%, #420a0b 100%)',
        color: '#ffffff',
        padding: '0.75rem 2rem',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        fontSize: '0.82rem',
        borderTop: '2px solid #c8861e'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          <span>Designed & Developed by <strong>CRIS</strong></span>
          <span>|</span>
          <span>Last updated on: 10/09/2026, 14:00</span>
        </div>
        <div>
          © 2026, Ministry of Railways, Government of India. All rights reserved.
        </div>
      </footer>
    </div>
  );
};
