import React, { useState, useEffect } from 'react';
import { RefreshCw, Volume2 } from 'lucide-react';

export const Captcha = ({ onChange, value }) => {
  const [captchaCode, setCaptchaCode] = useState('');

  const generateCode = () => {
    const chars = 'abcdefghkmnpqrstuvwxyz23456789';
    let code = '';
    for (let i = 0; i < 5; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    setCaptchaCode(code);
  };

  useEffect(() => {
    generateCode();
  }, []);

  const speakCaptcha = () => {
    if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(captchaCode.split('').join(' '));
      utterance.rate = 0.8;
      window.speechSynthesis.speak(utterance);
    }
  };

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '0.6rem', marginTop: '0.4rem' }}>
      {/* Visual distorted CAPTCHA block */}
      <div style={{
        background: '#f1f5f9',
        border: '1px solid #cbd5e1',
        borderRadius: '6px',
        padding: '0.35rem 0.75rem',
        letterSpacing: '5px',
        fontFamily: 'monospace',
        fontWeight: 'bold',
        fontSize: '1.25rem',
        color: '#1e293b',
        userSelect: 'none',
        textDecoration: 'line-through',
        fontStyle: 'italic',
        backgroundBlendMode: 'difference',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        minWidth: '110px',
        boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.1)'
      }}>
        {captchaCode}
      </div>

      <button
        type="button"
        onClick={speakCaptcha}
        title="Listen to Captcha"
        style={{
          background: 'none',
          border: 'none',
          cursor: 'pointer',
          color: '#d97706',
          padding: '4px',
          display: 'flex',
          alignItems: 'center'
        }}
      >
        <Volume2 size={18} />
      </button>

      <button
        type="button"
        onClick={generateCode}
        title="Refresh Captcha"
        style={{
          background: 'none',
          border: 'none',
          cursor: 'pointer',
          color: '#0d9488',
          padding: '4px',
          display: 'flex',
          alignItems: 'center'
        }}
      >
        <RefreshCw size={17} />
      </button>

      <input
        type="text"
        placeholder="Enter captcha text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required
        style={{
          flex: 1,
          padding: '0.45rem 0.65rem',
          border: '1px solid #cbd5e1',
          borderRadius: '4px',
          fontSize: '0.85rem'
        }}
      />
    </div>
  );
};
