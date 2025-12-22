import { AlertCenter } from './AlertCenter';

export function AlertCenterDemo() {
  return (
    <div className="min-h-screen bg-slate-100 p-6">
      <div className="mx-auto max-w-7xl">
        <div className="mb-6 rounded-lg bg-blue-600 p-4 text-white">
          <h1 className="mb-2">🚀 Démonstration Centre d'Alertes</h1>
          <p>Cette page affiche directement le centre d'alertes pour faciliter les tests</p>
          <p className="mt-2 text-sm opacity-90">
            💡 Pour l'utiliser normalement : Connectez-vous en tant que médecin → Mode Médecin → Centre d'alertes dans la sidebar
          </p>
        </div>
        <AlertCenter />
      </div>
    </div>
  );
}
