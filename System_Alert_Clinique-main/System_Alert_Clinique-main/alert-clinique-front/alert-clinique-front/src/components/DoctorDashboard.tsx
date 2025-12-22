import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { AlertTriangle, Users, Activity, Eye, Clock } from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';

const highRiskPatients = [
  {
    id: 1,
    name: 'Sophie Martin',
    age: 45,
    condition: 'Hypertension sévère',
    riskLevel: 'critical',
    lastUpdate: '2h',
  },
  {
    id: 2,
    name: 'Ahmed Benali',
    age: 62,
    condition: 'Insuffisance cardiaque',
    riskLevel: 'high',
    lastUpdate: '5h',
  },
  {
    id: 3,
    name: 'Marie Dubois',
    age: 38,
    condition: 'Arythmie cardiaque',
    riskLevel: 'high',
    lastUpdate: '1j',
  },
];

const recentAlerts = [
  {
    id: 1,
    patient: 'Sophie Martin',
    type: 'Pression artérielle élevée',
    severity: 'critical',
    time: '15 min',
  },
  {
    id: 2,
    patient: 'Ahmed Benali',
    type: 'Fréquence cardiaque irrégulière',
    severity: 'high',
    time: '1h',
  },
  {
    id: 3,
    patient: 'Jean Lefebvre',
    type: 'Médication non prise',
    severity: 'medium',
    time: '3h',
  },
  {
    id: 4,
    patient: 'Fatima Alaoui',
    type: 'Anomalie de rythme',
    severity: 'high',
    time: '4h',
  },
];

const getSeverityColor = (severity: string) => {
  switch (severity) {
    case 'critical':
      return 'bg-red-100 text-red-800 border-red-200';
    case 'high':
      return 'bg-orange-100 text-orange-800 border-orange-200';
    case 'medium':
      return 'bg-yellow-100 text-yellow-800 border-yellow-200';
    case 'low':
      return 'bg-green-100 text-green-800 border-green-200';
    default:
      return 'bg-slate-100 text-slate-800 border-slate-200';
  }
};

const getSeverityLabel = (severity: string, t: (key: string) => string) => {
  switch (severity) {
    case 'critical':
      return t('alerts.critical');
    case 'high':
      return t('alerts.high');
    case 'medium':
      return t('alerts.medium');
    case 'low':
      return t('alerts.low');
    default:
      return severity;
  }
};

export function DoctorDashboard() {
  const { t } = useLanguage();

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-white mb-2">{t('doctor.welcome')}</h2>
        <p className="text-slate-600">Vue d'ensemble de vos patients</p>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
              <Users className="h-6 w-6 text-blue-600" />
            </div>
            <div>
              <p className="text-slate-600">{t('doctor.stats.total')}</p>
              <p className="text-white">247</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-red-100">
              <AlertTriangle className="h-6 w-6 text-red-600" />
            </div>
            <div>
              <p className="text-slate-600">{t('doctor.stats.critical')}</p>
              <p className="text-white">12</p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-center gap-4 p-6">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-orange-100">
              <Activity className="h-6 w-6 text-orange-600" />
            </div>
            <div>
              <p className="text-slate-600">{t('doctor.stats.moderate')}</p>
              <p className="text-white">35</p>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* High Risk Patients */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <AlertTriangle className="h-5 w-5 text-red-600" />
                {t('doctor.highRisk')}
              </CardTitle>
              <Button variant="outline" size="sm">
                {t('doctor.viewAll')}
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {highRiskPatients.map((patient) => (
                <div
                  key={patient.id}
                  className="flex items-start justify-between rounded-lg border p-4"
                >
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <p className="text-slate-900">{patient.name}</p>
                      <Badge className={getSeverityColor(patient.riskLevel)}>
                        {getSeverityLabel(patient.riskLevel, t)}
                      </Badge>
                    </div>
                    <p className="text-slate-600 mb-1">{patient.condition}</p>
                    <div className="flex items-center gap-1 text-slate-500">
                      <Clock className="h-3 w-3" />
                      <span>Il y a {patient.lastUpdate}</span>
                    </div>
                  </div>
                  <Button size="sm" variant="outline">
                    <Eye className="mr-2 h-4 w-4" />
                    {t('doctor.viewPatient')}
                  </Button>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Recent Alerts */}
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Activity className="h-5 w-5 text-blue-600" />
                {t('doctor.recentAlerts')}
              </CardTitle>
              <Button variant="outline" size="sm">
                {t('doctor.viewAll')}
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {recentAlerts.map((alert) => (
                <div
                  key={alert.id}
                  className="flex items-center justify-between rounded-lg border p-4"
                >
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <Badge className={getSeverityColor(alert.severity)}>
                        {getSeverityLabel(alert.severity, t)}
                      </Badge>
                      <span className="text-slate-500">Il y a {alert.time}</span>
                    </div>
                    <p className="text-slate-900 mb-1">{alert.patient}</p>
                    <p className="text-slate-600">{alert.type}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Urgent Action Banner */}
      <Card className="border-red-200 bg-red-50">
        <CardContent className="flex items-center justify-between p-6">
          <div className="flex items-center gap-4">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-red-600 text-white">
              <AlertTriangle className="h-6 w-6" />
            </div>
            <div>
              <p className="text-red-900">{t('doctor.urgentAction')}</p>
              <p className="text-red-700">3 patients nécessitent une attention immédiate</p>
            </div>
          </div>
          <Button className="bg-red-600 hover:bg-red-700">
            <Eye className="mr-2 h-4 w-4" />
            Voir les cas
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
