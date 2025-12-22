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
    try {
      // Pour l'admin, on peut utiliser une vérification simple ou créer un endpoint admin
      if (role === 'admin') {
        // Vérification simple pour admin (peut être améliorée avec un endpoint dédié)
        if (email === 'admin@signature.com' && password === 'password123') {
          setUser({
            id: 'admin-1',
            name: 'Administrateur',
            email,
            role: 'admin',
          });
          return;
        } else {
          throw new Error('Identifiants administrateur invalides');
        }
      }

      // Pour patient et doctor, utiliser l'API backend
      const response = await fetch('http://localhost:8082/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email,
          password,
          userType: role === 'doctor' ? 'medecin' : 'patient',
        }),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({ message: 'Erreur de connexion' }));
        throw new Error(errorData.message || 'Erreur de connexion');
      }

      const data = await response.json();
      
      if (data.success) {
        setUser({
          id: data.userId?.toString() || '1',
          name: data.userName || email,
          email: data.email || email,
          role: role,
        });
      } else {
        throw new Error(data.message || 'Erreur de connexion');
      }
    } catch (error) {
      console.error('Login error:', error);
      throw error;
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
