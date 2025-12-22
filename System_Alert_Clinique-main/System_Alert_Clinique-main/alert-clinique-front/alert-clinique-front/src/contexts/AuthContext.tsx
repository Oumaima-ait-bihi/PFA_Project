import React, { createContext, useContext, useState } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
  role: 'patient' | 'doctor' | 'admin';
  avatar?: string;
}

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string, role: 'patient' | 'doctor' | 'admin') => Promise<void>;
  signup: (name: string, email: string, password: string, role: 'patient' | 'doctor') => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  const login = async (email: string, password: string, role: 'patient' | 'doctor' | 'admin') => {
    // Simuler un appel API
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    if (role === 'admin') {
      setUser({
        id: 'admin-1',
        name: 'Administrateur XYZ',
        email,
        role: 'admin',
      });
    } else {
      setUser({
        id: '1',
        name: role === 'patient' ? 'Jean Dupont' : 'Dr. Hasna Ait Ben Brahim',
        email,
        role,
      });
    }
  };

  const signup = async (name: string, email: string, password: string, role: 'patient' | 'doctor') => {
    // Simuler un appel API
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    setUser({
      id: '1',
      name,
      email,
      role,
    });
  };

  const logout = () => {
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ 
      user, 
      isAuthenticated: !!user, 
      login, 
      signup, 
      logout 
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
