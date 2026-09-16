import React, { useState, useEffect } from 'react';
import { RefreshCw, Volume2 } from 'lucide-react';

export const Captcha = ({ onChange, value, onCodeGenerated }) => {
  const [captchaCode, setCaptchaCode] = useState('');

  const generateCode = () => {
    const chars = 'abcdefghkmnpqrstuvwxyz23456789';
    let code = '';
    for (let i = 0; i < 5; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    setCaptchaCode(code);
    if (onCodeGenerated) {
      onCodeGenerated(code);
    }
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
    <div style={{
      display: 'flex',
      alignItems: 'center',
      gap: '0.5rem',
      marginTop: '0.4rem',
      width: '100%',
      flexWrap: 'wrap'
    }}>
      {/* Visual CAPTCHA block */}
      <div style={{
        background: '#f1f5f9',
        border: '1px solid #cbd5e1',
        borderRadius: '6px',
        padding: '0.35rem 0.6rem',
        letterSpacing: '4px',
        fontFamily: 'monospace',
        fontWeight: 'bold',
        fontSize: '1.2rem',
        color: '#1e293b',
        userSelect: 'none',
        textDecoration: 'line-through',
        fontStyle: 'italic',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        minWidth: '95px',
        boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.1)',
        flexShrink: 0
      }}>
        {captchaCode}
      </div>

      {/* Audio Button */}
      <button
        type="button"
        onClick={speakCaptcha}
        title="Listen to Captcha"
        style={{
          background: 'none',
          border: 'none',
          cursor: 'pointer',
          color: '#ffd166',
          padding: '4px',
          display: 'flex',
          alignItems: 'center',
          flexShrink: 0
        }}
      >
        <Volume2 size={18} />
      </button>

      {/* Refresh Button */}
      <button
        type="button"
        onClick={generateCode}
        title="Refresh Captcha"
        style={{
          background: 'none',
          border: 'none',
          cursor: 'pointer',
          color: '#2ec4b6',
          padding: '4px',
          display: 'flex',
          alignItems: 'center',
          flexShrink: 0
        }}
      >
        <RefreshCw size={17} />
      </button>

      {/* Captcha Input */}
      <input
        type="text"
        placeholder="Enter captcha text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required
        style={{
          flex: '1 1 140px',
          minWidth: 0,
          width: '100%',
          padding: '0.5rem 0.65rem',
          border: '1px solid #cbd5e1',
          borderRadius: '4px',
          fontSize: '0.85rem',
          outline: 'none',
          boxSizing: 'border-box'
        }}
      />
    </div>
  );
};