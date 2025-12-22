import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Users, UserCheck, AlertTriangle, Activity, TrendingUp, Calendar } from 'lucide-react';

export function AdminDashboard() {
  const stats = {
    totalPatients: 247,
    totalDoctors: 18,
    activeAlerts: 12,
    criticalAlerts: 3,
    totalAppointments: 156,
    monthlyGrowth: 12.5,
  };

  const recentActivity = [
    { type: 'patient', action: 'Nouveau patient enregistré', name: 'Sophie Martin', time: 'Il y a 5 min' },
    { type: 'alert', action: 'Alerte critique', name: 'Ahmed Benali', time: 'Il y a 15 min' },
    { type: 'doctor', action: 'Médecin assigné', name: 'Dr. Hasna Ait Ben Brahim', time: 'Il y a 1h' },
    { type: 'patient', action: 'Profil mis à jour', name: 'Jean Lefebvre', time: 'Il y a 2h' },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold mb-2">Tableau de bord - MediCure Clinic</h2>
        <p className="text-slate-600">Vue d'ensemble de la clinique</p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
              <Users className="h-6 w-6 text-blue-600" />
            </div>
            <div>
              <p className="text-slate-600">Patients totaux</p>
              <p className="text-2xl font-bold">{stats.totalPatients}</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-green-100">
              <UserCheck className="h-6 w-6 text-green-600" />
            </div>
            <div>
              <p className="text-slate-600">Médecins actifs</p>
              <p className="text-2xl font-bold">{stats.totalDoctors}</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-red-100">
              <AlertTriangle className="h-6 w-6 text-red-600" />
            </div>
            <div>
              <p className="text-slate-600">Alertes actives</p>
              <p className="text-2xl font-bold">{stats.activeAlerts}</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-orange-100">
              <AlertTriangle className="h-6 w-6 text-orange-600" />
            </div>
            <div>
              <p className="text-slate-600">Alertes critiques</p>
              <p className="text-2xl font-bold">{stats.criticalAlerts}</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-purple-100">
              <Calendar className="h-6 w-6 text-purple-600" />
            </div>
            <div>
              <p className="text-slate-600">Rendez-vous ce mois</p>
              <p className="text-2xl font-bold">{stats.totalAppointments}</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-emerald-100">
              <TrendingUp className="h-6 w-6 text-emerald-600" />
            </div>
            <div>
              <p className="text-slate-600">Croissance mensuelle</p>
              <p className="text-2xl font-bold">+{stats.monthlyGrowth}%</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Recent Activity */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Activity className="h-5 w-5" />
            Activité récente
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {recentActivity.map((activity, index) => (
              <div
                key={index}
                className="flex items-center gap-4 p-4 border rounded-lg hover:bg-slate-50"
              >
                <div
                  className={`flex h-10 w-10 items-center justify-center rounded-lg ${
                    activity.type === 'patient'
                      ? 'bg-blue-100 text-blue-600'
                      : activity.type === 'alert'
                      ? 'bg-red-100 text-red-600'
                      : 'bg-green-100 text-green-600'
                  }`}
                >
                  {activity.type === 'patient' ? (
                    <Users className="h-5 w-5" />
                  ) : activity.type === 'alert' ? (
                    <AlertTriangle className="h-5 w-5" />
                  ) : (
                    <UserCheck className="h-5 w-5" />
                  )}
                </div>
                <div className="flex-1">
                  <p className="font-medium">{activity.action}</p>
                  <p className="text-slate-600">{activity.name}</p>
                </div>
                <p className="text-slate-500 text-sm">{activity.time}</p>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

