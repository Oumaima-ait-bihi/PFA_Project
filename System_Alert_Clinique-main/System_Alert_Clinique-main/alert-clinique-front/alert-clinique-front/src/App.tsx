import { useState } from 'react';
import { Header } from './components/Header';
import { Sidebar } from './components/Sidebar';
import { AdminSidebar } from './components/AdminSidebar';
import { PatientDashboard } from './components/PatientDashboard';
import { PatientProfile } from './components/PatientProfile';
import { PatientSettings } from './components/PatientSettings';
import { DoctorDashboard } from './components/DoctorDashboard';
import { DoctorProfile } from './components/DoctorProfile';
import { PatientsList } from './components/PatientsList';
import { AlertCenter } from './components/AlertCenter';
import { AdminDashboard } from './components/AdminDashboard';
import { AdminDoctors } from './components/AdminDoctors';
import { AdminPatients } from './components/AdminPatients';
import { AdminAlerts } from './components/AdminAlerts';
import { Login } from './components/Login';
import { LoginMC } from './components/LoginMC';
import { Signup } from './components/Signup';
import { LanguageProvider, useLanguage } from './contexts/LanguageContext';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { Toaster } from './components/ui/sonner';

function AppContent() {
  const { user, isAuthenticated, logout } = useAuth();
  const [userRole, setUserRole] = useState<'patient' | 'doctor' | 'admin'>('admin');
  const [activeView, setActiveView] = useState('dashboard');
  const [showSignup, setShowSignup] = useState(false);
  const { language } = useLanguage();

  // Afficher la page de login si l'utilisateur n'est pas authentifié
  if (!isAuthenticated) {
    return (
      <>
        <Login />
        <Toaster position="top-right" />
      </>
    );
  }

  // Admin interface
  if (user?.role === 'admin' || userRole === 'admin') {
    const renderAdminContent = () => {
      switch (activeView) {
        case 'dashboard':
          return <AdminDashboard />;
        case 'doctors':
          return <AdminDoctors />;
        case 'patients':
          return <AdminPatients />;
        case 'alerts':
          return <AdminAlerts />;
        default:
          return <AdminDashboard />;
      }
    };

    return (
      <div className="min-h-screen bg-slate-100">
        <div className="flex">
          <AdminSidebar
            activeView={activeView}
            onViewChange={setActiveView}
          />
          <main className="flex-1 p-6">
            <div className="mx-auto max-w-7xl">
              <div className="mb-6 flex items-center justify-between">
                <div>
                  <h1 className="text-2xl font-bold">MediCure Clinic - Administration</h1>
                  <p className="text-slate-600">Gestion de la clinique</p>
                </div>
                <div className="flex items-center gap-4">
                  <span className="text-sm text-slate-600">
                    {user?.name || 'Administrateur'}
                  </span>
                  <button
                    onClick={() => {
                      logout();
                    }}
                    className="text-sm text-red-600 hover:text-red-700"
                  >
                    Déconnexion
                  </button>
                </div>
              </div>
              {renderAdminContent()}
            </div>
          </main>
        </div>
        <Toaster position="top-right" />
      </div>
    );
  }

  // Patient and Doctor views
  const renderContent = () => {
    // Patient views
    if (user?.role === 'patient' || userRole === 'patient') {
      switch (activeView) {
        case 'dashboard':
          return <PatientDashboard />;
        case 'profile':
          return <PatientProfile />;
        case 'settings':
          return <PatientSettings />;
        default:
          return <PatientDashboard />;
      }
    }

    // Doctor views
    switch (activeView) {
      case 'dashboard':
        return <DoctorDashboard />;
      case 'alerts':
        return <AlertCenter />;
      case 'patients':
        return <PatientsList />;
      case 'profile':
        return <DoctorProfile />;
      case 'settings':
        return (
          <div className="flex h-64 items-center justify-center rounded-lg border-2 border-dashed">
            <p className="text-slate-500">Paramètres - À implémenter</p>
          </div>
        );
      default:
        return <DoctorDashboard />;
    }
  };

  const currentRole = user?.role || userRole;

  return (
    <div className="min-h-screen bg-slate-100" dir={language === 'ar' ? 'rtl' : 'ltr'}>
      <Header
        userRole={currentRole}
        userName={user?.name || (currentRole === 'patient' ? 'Jean Dupont' : 'Dr. Hasna Ait Ben Brahim')}
        notifications={currentRole === 'doctor' ? 8 : 2}
      />

      <div className="flex">
        <Sidebar
          userRole={currentRole}
          activeView={activeView}
          onViewChange={setActiveView}
        />

        <main className="flex-1 p-6">
          <div className="mx-auto max-w-7xl">
            {/* Role Switcher (for demo purposes) */}
            <div className="mb-6 flex gap-2 rounded-lg bg-white p-2 shadow-sm w-fit">
              <button
                onClick={() => {
                  setUserRole('patient');
                  setActiveView('dashboard');
                }}
                className={`rounded-md px-4 py-2 transition-colors ${currentRole === 'patient'
                  ? 'bg-blue-600 text-white'
                  : 'text-slate-600 hover:bg-slate-100'
                  }`}
              >
                👤 Mode Patient
              </button>
              <button
                onClick={() => {
                  setUserRole('doctor');
                  setActiveView('dashboard');
                }}
                className={`rounded-md px-4 py-2 transition-colors ${currentRole === 'doctor'
                  ? 'bg-blue-600 text-white'
                  : 'text-slate-600 hover:bg-slate-100'
                  }`}
              >
                ⚕️ Mode Médecin
              </button>
              <button
                onClick={() => {
                  setUserRole('admin');
                  setActiveView('dashboard');
                }}
                className={`rounded-md px-4 py-2 transition-colors ${currentRole === 'admin'
                  ? 'bg-blue-600 text-white'
                  : 'text-slate-600 hover:bg-slate-100'
                  }`}
              >
                🏥 Mode Admin
              </button>
            </div>

            {renderContent()}
          </div>
        </main>
      </div>

      <Toaster position="top-right" />
    </div>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <LanguageProvider>
        <AppContent />
      </LanguageProvider>
    </AuthProvider>
  );
}