// Inside SIH_2026/frontend/src/context/AuthContext.jsx
import React, { createContext, useContext, useState } from 'react';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    try {
      const saved = localStorage.getItem('imbps_user');
      return saved ? JSON.parse(saved) : null;
    } catch {
      return null;
    }
  });

  const [token, setToken] = useState(() => {
    return localStorage.getItem('imbps_token') || null;
  });

  const login = async (username, password) => {
    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      });
      let data = {};
      try {
        data = await res.json();
      } catch (e) {
        if (!res.ok) {
          throw new Error(`Backend server unavailable (Status ${res.status}). Please check backend status.`);
        }
      }
      if (!res.ok) {
        throw new Error(data.detail || 'Authentication failed');
      }
      setUser(data.user);
      setToken(data.token);
      localStorage.setItem('imbps_user', JSON.stringify(data.user));
      localStorage.setItem('imbps_token', data.token);
      return { success: true, user: data.user };
    } catch (err) {
      return { success: false, error: err.message };
    }
  };

  const logout = () => {
    setUser(null);
    setToken(null);
    localStorage.removeItem('imbps_user');
    localStorage.removeItem('imbps_token');
  };

  // Helper function to call backend with JWT
  const authFetch = async (url, options = {}) => {
    const headers = {
      ...options.headers,
      'Authorization': `Bearer ${token}`
    };
    return fetch(url, { ...options, headers });
  };

  return (
    <AuthContext.Provider value={{ user, token, login, logout, authFetch }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);