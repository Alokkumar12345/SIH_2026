import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';

const AuthContext = createContext(null);

// Helper to check if a JWT token is expired without third-party libraries
const isTokenExpired = (token) => {
  if (!token) return true;
  try {
    const payloadBase64 = token.split('.')[1];
    if (!payloadBase64) return false;
    const decodedJson = JSON.parse(atob(payloadBase64));
    if (!decodedJson.exp) return false;
    return Date.now() >= decodedJson.exp * 1000;
  } catch {
    return false;
  }
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    try {
      const savedUser = localStorage.getItem('imbps_user');
      const savedToken = localStorage.getItem('imbps_token');
      if (savedToken && isTokenExpired(savedToken)) {
        localStorage.removeItem('imbps_user');
        localStorage.removeItem('imbps_token');
        return null;
      }
      return savedUser ? JSON.parse(savedUser) : null;
    } catch {
      return null;
    }
  });

  const [token, setToken] = useState(() => {
    const savedToken = localStorage.getItem('imbps_token');
    return savedToken && !isTokenExpired(savedToken) ? savedToken : null;
  });

  const logout = useCallback(() => {
    setUser(null);
    setToken(null);
    localStorage.removeItem('imbps_user');
    localStorage.removeItem('imbps_token');
  }, []);

  const login = async (username, password) => {
    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password })
      });
      if (!res.ok) {
        const err = await res.json();
        throw new Error(err.detail || 'Authentication failed');
      }
      const data = await res.json();
      setUser(data.user);
      setToken(data.token);
      localStorage.setItem('imbps_user', JSON.stringify(data.user));
      localStorage.setItem('imbps_token', data.token);
      return { success: true, user: data.user };
    } catch (err) {
      return { success: false, error: err.message };
    }
  };

  // Intercept 401 API responses and sync multi-tab logouts
  useEffect(() => {
    const originalFetch = window.fetch;
    window.fetch = async (...args) => {
      const response = await originalFetch(...args);
      if (response.status === 401) {
        logout();
      }
      return response;
    };

    const handleStorageEvent = (e) => {
      if (e.key === 'imbps_token' && !e.newValue) {
        logout();
      }
    };

    window.addEventListener('storage', handleStorageEvent);

    return () => {
      window.fetch = originalFetch;
      window.removeEventListener('storage', handleStorageEvent);
    };
  }, [logout]);

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
