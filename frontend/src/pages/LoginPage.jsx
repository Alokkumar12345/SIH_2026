import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { Captcha } from '../components/Captcha';
import { Lock } from 'lucide-react';
import railwayLogo from '../assets/Railway_logo.png';


const BANNER_SLIDES = [
  
  {
    image: '/images/banner1.webp',
    title: 'Leadership & Vision for Modern Indian Railways',
    subtitle: 'Shri Ashwini Vaishnaw • Hon’ble Union Minister for Railways'
  },
  {
    image: '/images/banner2.jpg',
    title: 'Track Maintenance & Permanent Way (P-Way) Operations',
    subtitle: 'Trackmen Inspection, Ballast Packing & Ultrasonic Rail Flaw Testing'
  },
  {
    image: '/images/banner3.jpg', 
    title: 'Overhead Equipment (OHE) & Traction Distribution',
    subtitle: '25kV AC Catenary-Contact Wire Maintenance & Tower Wagon Operations'
  }
];


export const LoginPage = () => {
  // 2. React Hooks MUST be placed inside the component:
  const [currentSlide, setCurrentSlide] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % BANNER_SLIDES.length);
    }, 2000);
    return () => clearInterval(timer);
  }, []);

  const { login } = useAuth();
  const [username, setUsername] = useState('div_asn');
  const [password, setPassword] = useState('DivASN@2026');
  const [captchaInput, setCaptchaInput] = useState('');
  const [expectedCaptcha, setExpectedCaptcha] = useState('');
  const [errorMsg, setErrorMsg] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  // ... rest of your code unchanged
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

    if (!captchaInput.trim() || captchaInput.trim().toLowerCase() !== expectedCaptcha.toLowerCase()) {
      setErrorMsg('अमान्य कैप्चा कोड / Invalid CAPTCHA code. Please enter the correct text.');
      return;
    }

    setIsLoading(true);
    const result = await login(username, password);
    setIsLoading(false);

    if (!result.success) {
      setErrorMsg(result.error || 'Invalid Railway User ID or Password.');
    }
  };

  return (
    <div className="login-page-root">
      {/* Header */}
      <div className="ir-main-header">
        <div className="ir-brand-group">
          <div className="ir-logo-circle">
            <img src={railwayLogo} alt="Indian Railways Logo" style={{ width: '100%', height: '100%', objectFit: 'contain' }} />
          </div>

          <div className="ir-brand-titles">
            <div className="ir-title-hindi">
              रेलपथ एवं एकीकृत ब्लॉक प्रबंधन प्रणाली
            </div>
            <div className="ir-title-english">
              Integrated Maintenance & Block Planning System (IMBPS)
            </div>
          </div>
        </div>

        <div className="login-header-emblems">
          <div style={{ textAlign: 'right', lineHeight: 1.2 }}>
            <div style={{ fontWeight: 700, color: '#ffffff' }}>विकसित भारत 2047</div>
            <div>राष्ट्राय सेवामहे | SERVICE TO THE NATION</div>
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
            आत्मनिर्भर भारत
          </div>
        </div>
      </div>

      {/* Main Login Canvas */}
      <main className="login-canvas">
        {/* Left Side: Photo Banner */}
       {/* Left Side: Dynamic Photo Banner Slider */}
<div 
  className="login-left-banner" 
  style={{ 
    position: 'relative', 
    overflow: 'hidden', 
    display: 'flex', 
    flexDirection: 'column' 
  }}
>
  {/* Image Container with Smooth Fade Transition */}
  <div style={{ position: 'relative', width: '100%', height: '340px', overflow: 'hidden' }}>
    {BANNER_SLIDES.map((slide, index) => (
      <img
        key={index}
        src={slide.image}
        alt={slide.title}
        className="login-banner-image"
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          opacity: currentSlide === index ? 1 : 0,
          transition: 'opacity 0.8s ease-in-out'
        }}
      />
    ))}
  </div>

  {/* Dynamic Meta Content */}
  <div 
    className="login-banner-meta" 
    style={{ 
      display: 'flex', 
      flexDirection: 'column', 
      alignItems: 'center', 
      justifyContent: 'center', 
      gap: '4px',
      textAlign: 'center',
      width: '100%',
      padding: '0.75rem 1rem',
      minHeight: '80px'
    }}
  >
    <div style={{ fontWeight: 700, color: '#5b1012', fontSize: '0.92rem', margin: 0, lineHeight: 1.2 }}>
      {BANNER_SLIDES[currentSlide].title}
    </div>
    <div style={{ fontSize: '0.78rem', color: '#64748b', margin: 0, lineHeight: 1.2 }}>
      {BANNER_SLIDES[currentSlide].subtitle}
    </div>

    {/* Slide Indicator Dots */}
    <div style={{ display: 'flex', gap: '6px', marginTop: '6px' }}>
      {BANNER_SLIDES.map((_, index) => (
        <button
          key={index}
          type="button"
          onClick={() => setCurrentSlide(index)}
          style={{
            width: currentSlide === index ? '6px' : '6px',
            height: '6px',
            borderRadius: '4px',
            background: currentSlide === index ? '#5b1012' : '#cbd5e1',
            border: 'none',
            padding: 0,
            cursor: 'pointer',
            transition: 'all 0.3s ease'
          }}
          aria-label={`Go to slide ${index + 1}`}
        />
      ))}
    </div>
  </div>
</div>
        {/* Right Side: CRIS Login Card */}
        <div className="login-card">
          <div style={{
            width: '64px',
            height: '64px',
            borderRadius: '50%',
            background: '#ffffff',
            color: '#7b1113',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 1rem auto',
            boxShadow: '0 4px 10px rgba(0,0,0,0.2)'
          }}>
            <Lock size={30} />
          </div>

          <div style={{ textAlign: 'center', marginBottom: '1.25rem' }}>
            <div style={{ fontFamily: 'Mukta, sans-serif', fontSize: '1.15rem', fontWeight: 700, color: '#fffdf5' }}>
              यूज़र आईडी और पासवर्ड प्रविष्ट करें
            </div>
            <div style={{ fontSize: '0.85rem', fontWeight: 600, color: '#fff9e6' }}>
              Please Enter User Id & Password
            </div>
          </div>

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

            <div style={{ marginBottom: errorMsg ? '0.6rem' : '1.25rem' }}>
              <Captcha
                value={captchaInput}
                onChange={setCaptchaInput}
                onCodeGenerated={setExpectedCaptcha}
              />
            </div>

            {errorMsg && (
              <div style={{
                background: '#fee2e2',
                color: '#991b1b',
                padding: '0.5rem 0.75rem',
                borderRadius: '6px',
                fontSize: '0.8rem',
                fontWeight: 600,
                marginBottom: '1rem',
                border: '1px solid #f87171',
                textAlign: 'center'
              }}>
                {errorMsg}
              </div>
            )}

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
              
              {isLoading ? 'सत्यापित हो रहा है / Verifying...' : '➔ लॉग इन करें / Login'}
            </button>
          </form>

          {/* Quick Account Switcher */}
          <div style={{ marginTop: '1.5rem', borderTop: '1px solid rgba(255,255,255,0.25)', paddingTop: '1rem' }}>
            <div style={{ fontSize: '0.78rem', color: '#fff9e6', fontWeight: 600, marginBottom: '0.5rem', textAlign: 'center' }}>
              Quick Selection: Click any role below to prefill credentials
            </div>
            <div className="login-quick-grid">
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
      </main>

      {/* Footer */}
      <footer className="ir-footer">
        <div className="ir-footer-left">
          <span>Designed & Developed by <strong>CYFSAI</strong></span>
          
        </div>
        <div className="ir-footer-right">
          © 2026, Ministry of Railways, Government of India. All rights reserved.
        </div>
      </footer>
    </div>
  );
};