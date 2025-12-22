import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from './ui/dialog';
import { 
  Filter, 
  CheckCircle, 
  UserPlus, 
  Eye, 
  Clock, 
  Search, 
  AlertTriangle, 
  TrendingUp,
  Activity,
  Heart,
  Thermometer,
  Droplets,
  ArrowUp,
  ArrowDown,
  Calendar,
  User,
  FileText,
  Bell,
  BellOff,
  Download
} from 'lucide-react';
import { useLanguage } from '../contexts/LanguageContext';
import { toast } from 'sonner';
import { Avatar, AvatarFallback } from './ui/avatar';
import { Progress } from './ui/progress';
import { Separator } from './ui/separator';
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

interface Alert {
  id: number;
  patient: string;
  patientId: string;
  type: string;
  severity: 'critical' | 'high' | 'medium' | 'low';
  status: 'pending' | 'inProgress' | 'resolved';
  time: string;
  timestamp: string;
  description: string;
  vitals?: {
    heartRate?: number;
    bloodPressure?: string;
    temperature?: number;
    oxygen?: number;
  };
  notes?: string;
  assignedTo?: string;
}

const mockAlerts: Alert[] = [
  {
    id: 1,
    patient: 'Sophie Martin',
    patientId: 'P-2847',
    type: 'Pression artérielle critique',
    severity: 'critical',
    status: 'pending',
    time: '15 min',
    timestamp: '2024-11-13 14:45',
    description: 'Pression artérielle détectée à 180/110 mmHg',
    vitals: {
      bloodPressure: '180/110',
      heartRate: 92,
    },
  },
  {
    id: 2,
    patient: 'Ahmed Benali',
    patientId: 'P-1923',
    type: 'Fréquence cardiaque irrégulière',
    severity: 'high',
    status: 'inProgress',
    time: '1h',
    timestamp: '2024-11-13 13:00',
    description: 'Variation anormale du rythme cardiaque détectée',
    vitals: {
      heartRate: 145,
    },
    assignedTo: 'Dr. Hasna Ait Ben Brahim',
  },
  {
    id: 3,
    patient: 'Jean Lefebvre',
    patientId: 'P-5612',
    type: 'Médication non prise',
    severity: 'medium',
    status: 'pending',
    time: '3h',
    timestamp: '2024-11-13 11:00',
    description: 'Dose du matin non confirmée',
  },
  {
    id: 4,
    patient: 'Fatima Alaoui',
    patientId: 'P-3401',
    type: 'Anomalie de rythme',
    severity: 'high',
    status: 'pending',
    time: '4h',
    timestamp: '2024-11-13 10:00',
    description: 'Rythme cardiaque irrégulier persistant',
    vitals: {
      heartRate: 152,
    },
  },
  {
    id: 5,
    patient: 'Pierre Durand',
    patientId: 'P-7829',
    type: 'Glycémie élevée',
    severity: 'medium',
    status: 'resolved',
    time: '6h',
    timestamp: '2024-11-13 08:00',
    description: 'Taux de glucose à 220 mg/dL',
    assignedTo: 'Dr. Martin',
  },
  {
    id: 6,
    patient: 'Leila Hassan',
    patientId: 'P-4156',
    type: 'Saturation oxygène basse',
    severity: 'critical',
    status: 'inProgress',
    time: '30 min',
    timestamp: '2024-11-13 14:30',
    description: 'SpO2 à 88% détecté',
    vitals: {
      oxygen: 88,
      heartRate: 98,
    },
    assignedTo: 'Dr. Hasna Ait Ben Brahim',
  },
  {
    id: 7,
    patient: 'Marc Bernard',
    patientId: 'P-9234',
    type: 'Température corporelle élevée',
    severity: 'low',
    status: 'pending',
    time: '2h',
    timestamp: '2024-11-13 12:00',
    description: 'Température à 38.2°C',
    vitals: {
      temperature: 38.2,
    },
  },
  {
    id: 8,
    patient: 'Amina Kaddour',
    patientId: 'P-6543',
    type: 'Activité physique insuffisante',
    severity: 'low',
    status: 'resolved',
    time: '1j',
    timestamp: '2024-11-12 14:00',
    description: 'Aucune activité enregistrée depuis 48h',
    assignedTo: 'Dr. Bernard',
  },
  {
    id: 9,
    patient: 'Sophie Martin',
    patientId: 'P-2847',
    type: 'Rendez-vous manqué',
    severity: 'medium',
    status: 'pending',
    time: '5h',
    timestamp: '2024-11-13 09:00',
    description: 'Consultation de suivi non honorée',
  },
  {
    id: 10,
    patient: 'Ahmed Benali',
    patientId: 'P-1923',
    type: 'Rappel médication',
    severity: 'low',
    status: 'resolved',
    time: '8h',
    timestamp: '2024-11-13 06:00',
    description: 'Rappel de prise de médicament du soir',
  },
];

const alertTrendData = [
  { day: 'Lun', critical: 2, high: 4, medium: 3, low: 2 },
  { day: 'Mar', critical: 1, high: 3, medium: 5, low: 3 },
  { day: 'Mer', critical: 3, high: 5, medium: 2, low: 1 },
  { day: 'Jeu', critical: 2, high: 2, medium: 4, low: 4 },
  { day: 'Ven', critical: 1, high: 4, medium: 3, low: 2 },
  { day: 'Sam', critical: 2, high: 3, medium: 2, low: 3 },
  { day: 'Dim', critical: 2, high: 4, medium: 4, low: 2 },
];

const responseTimeData = [
  { name: 'Critiques', temps: 8 },
  { name: 'Élevées', temps: 25 },
  { name: 'Moyennes', temps: 45 },
  { name: 'Faibles', temps: 120 },
];

const COLORS = {
  critical: '#ef4444',
  high: '#f97316',
  medium: '#eab308',
  low: '#22c55e',
};

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

const getStatusColor = (status: string) => {
  switch (status) {
    case 'pending':
      return 'bg-blue-100 text-blue-800 border-blue-200';
    case 'inProgress':
      return 'bg-purple-100 text-purple-800 border-purple-200';
    case 'resolved':
      return 'bg-green-100 text-green-800 border-green-200';
    default:
      return 'bg-slate-100 text-slate-800 border-slate-200';
  }
};

const getAlertIcon = (type: string) => {
  if (type.toLowerCase().includes('pression') || type.toLowerCase().includes('cardiaque')) {
    return <Heart className="h-5 w-5" />;
  }
  if (type.toLowerCase().includes('température')) {
    return <Thermometer className="h-5 w-5" />;
  }
  if (type.toLowerCase().includes('oxygène')) {
    return <Activity className="h-5 w-5" />;
  }
  return <AlertTriangle className="h-5 w-5" />;
};

export function AlertCenter() {
  const { t } = useLanguage();
  const [alerts, setAlerts] = useState<Alert[]>(mockAlerts);
  const [severityFilter, setSeverityFilter] = useState<string>('all');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [sortBy, setSortBy] = useState<string>('time');
  const [selectedAlert, setSelectedAlert] = useState<Alert | null>(null);
  const [showResolved, setShowResolved] = useState(true);

  const filteredAlerts = alerts
    .filter((alert) => {
      const severityMatch = severityFilter === 'all' || alert.severity === severityFilter;
      const statusMatch = statusFilter === 'all' || alert.status === statusFilter;
      const searchMatch = alert.patient.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         alert.patientId.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         alert.type.toLowerCase().includes(searchTerm.toLowerCase());
      const resolvedMatch = showResolved || alert.status !== 'resolved';
      return severityMatch && statusMatch && searchMatch && resolvedMatch;
    })
    .sort((a, b) => {
      if (sortBy === 'severity') {
        const severityOrder = { critical: 0, high: 1, medium: 2, low: 3 };
        return severityOrder[a.severity] - severityOrder[b.severity];
      }
      return 0; // default time sorting
    });

  const stats = {
    total: alerts.length,
    critical: alerts.filter(a => a.severity === 'critical').length,
    high: alerts.filter(a => a.severity === 'high').length,
    medium: alerts.filter(a => a.severity === 'medium').length,
    low: alerts.filter(a => a.severity === 'low').length,
    pending: alerts.filter(a => a.status === 'pending').length,
    inProgress: alerts.filter(a => a.status === 'inProgress').length,
    resolved: alerts.filter(a => a.status === 'resolved').length,
  };

  const severityDistribution = [
    { name: 'Critiques', value: stats.critical, color: COLORS.critical },
    { name: 'Élevées', value: stats.high, color: COLORS.high },
    { name: 'Moyennes', value: stats.medium, color: COLORS.medium },
    { name: 'Faibles', value: stats.low, color: COLORS.low },
  ];

  const handleAcknowledge = (alertId: number) => {
    setAlerts(alerts.map(alert => 
      alert.id === alertId 
        ? { ...alert, status: 'inProgress' as const, assignedTo: 'Dr. Hasna Ait Ben Brahim' }
        : alert
    ));
    toast.success('Alerte prise en charge');
  };

  const handleResolve = (alertId: number) => {
    setAlerts(alerts.map(alert => 
      alert.id === alertId 
        ? { ...alert, status: 'resolved' as const }
        : alert
    ));
    toast.success('Alerte marquée comme résolue');
  };

  const handleAssign = (alertId: number) => {
    toast.info('Fonction d\'assignation - À implémenter');
  };

  const handleExport = () => {
    toast.success('Export des alertes en cours...');
  };

  const getSeverityLabel = (severity: string) => {
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

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'pending':
        return t('alerts.pending');
      case 'inProgress':
        return t('alerts.inProgress');
      case 'resolved':
        return t('alerts.resolved');
      default:
        return status;
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-white mb-2">{t('alerts.title')}</h2>
          <p className="text-slate-600">
            {filteredAlerts.length} alerte{filteredAlerts.length > 1 ? 's' : ''} active{filteredAlerts.length > 1 ? 's' : ''}
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            onClick={() => setShowResolved(!showResolved)}
            className="gap-2"
          >
            {showResolved ? <BellOff className="h-4 w-4" /> : <Bell className="h-4 w-4" />}
            {showResolved ? 'Masquer résolues' : 'Afficher résolues'}
          </Button>
          <Button onClick={handleExport} className="gap-2">
            <Download className="h-4 w-4" />
            Exporter
          </Button>
        </div>
      </div>

      <Tabs defaultValue="list" className="space-y-6">
        <TabsList className="grid w-full grid-cols-3 lg:w-[400px]">
          <TabsTrigger value="list">
            <FileText className="mr-2 h-4 w-4" />
            Alertes
          </TabsTrigger>
          <TabsTrigger value="stats">
            <TrendingUp className="mr-2 h-4 w-4" />
            Statistiques
          </TabsTrigger>
          <TabsTrigger value="analytics">
            <Activity className="mr-2 h-4 w-4" />
            Analyses
          </TabsTrigger>
        </TabsList>

        {/* Alerts List Tab */}
        <TabsContent value="list" className="space-y-6">
          {/* Statistics Cards */}
          <div className="grid grid-cols-2 gap-4">
            <Card className="border-l-4 border-l-red-500">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-slate-600">Critiques</p>
                    <p className="text-white">{stats.critical}</p>
                  </div>
                  <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-red-100">
                    <AlertTriangle className="h-6 w-6 text-red-600" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="border-l-4 border-l-orange-500">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-slate-600">Risque élevé</p>
                    <p className="text-white">{stats.high}</p>
                  </div>
                  <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-orange-100">
                    <TrendingUp className="h-6 w-6 text-orange-600" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="border-l-4 border-l-blue-500">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-slate-600">En attente</p>
                    <p className="text-white">{stats.pending}</p>
                  </div>
                  <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
                    <Clock className="h-6 w-6 text-blue-600" />
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="border-l-4 border-l-green-500">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-slate-600">Résolues</p>
                    <p className="text-white">{stats.resolved}</p>
                  </div>
                  <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-green-100">
                    <CheckCircle className="h-6 w-6 text-green-600" />
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Filters */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Filter className="h-5 w-5" />
                Filtres et recherche
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
                <div className="space-y-2">
                  <label className="text-slate-700">Rechercher</label>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                    <Input
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      placeholder="Patient, type..."
                      className="pl-10"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-slate-700">{t('alerts.severity')}</label>
                  <Select value={severityFilter} onValueChange={setSeverityFilter}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Toutes</SelectItem>
                      <SelectItem value="critical">Critiques</SelectItem>
                      <SelectItem value="high">Élevées</SelectItem>
                      <SelectItem value="medium">Moyennes</SelectItem>
                      <SelectItem value="low">Faibles</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <label className="text-slate-700">{t('alerts.status')}</label>
                  <Select value={statusFilter} onValueChange={setStatusFilter}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Tous</SelectItem>
                      <SelectItem value="pending">En attente</SelectItem>
                      <SelectItem value="inProgress">En cours</SelectItem>
                      <SelectItem value="resolved">Résolues</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <label className="text-slate-700">Trier par</label>
                  <Select value={sortBy} onValueChange={setSortBy}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="time">Plus récentes</SelectItem>
                      <SelectItem value="severity">Gravité</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Alerts List */}
          <div className="space-y-3">
            {filteredAlerts.map((alert) => (
              <Card 
                key={alert.id} 
                className={`hover:shadow-lg transition-all cursor-pointer ${
                  alert.status === 'resolved' ? 'opacity-60' : ''
                }`}
                onClick={() => setSelectedAlert(alert)}
              >
                <CardContent className="p-6">
                  <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div className="flex gap-4 flex-1">
                      {/* Icon */}
                      <div className={`flex h-12 w-12 shrink-0 items-center justify-center rounded-lg ${
                        alert.severity === 'critical' ? 'bg-red-100 text-red-600' :
                        alert.severity === 'high' ? 'bg-orange-100 text-orange-600' :
                        alert.severity === 'medium' ? 'bg-yellow-100 text-yellow-600' :
                        'bg-green-100 text-green-600'
                      }`}>
                        {getAlertIcon(alert.type)}
                      </div>

                      {/* Content */}
                      <div className="flex-1 space-y-3">
                        {/* Header */}
                        <div className="flex flex-wrap items-center gap-2">
                          <Badge className={getSeverityColor(alert.severity)}>
                            {getSeverityLabel(alert.severity)}
                          </Badge>
                          <Badge className={getStatusColor(alert.status)}>
                            {getStatusLabel(alert.status)}
                          </Badge>
                          <div className="flex items-center gap-1 text-slate-500">
                            <Clock className="h-3 w-3" />
                            <span>Il y a {alert.time}</span>
                          </div>
                        </div>

                        {/* Patient Info */}
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <Avatar className="h-6 w-6">
                              <AvatarFallback className="bg-blue-600 text-white text-xs">
                                {alert.patient.split(' ').map(n => n[0]).join('')}
                              </AvatarFallback>
                            </Avatar>
                            <p className="text-slate-900">
                              {alert.patient} <span className="text-slate-500">({alert.patientId})</span>
                            </p>
                          </div>
                          <p className="text-slate-900 mb-1">{alert.type}</p>
                          <p className="text-slate-600">{alert.description}</p>
                        </div>

                        {/* Vitals */}
                        {alert.vitals && (
                          <div className="flex flex-wrap gap-4">
                            {alert.vitals.heartRate && (
                              <div className="flex items-center gap-2 text-slate-600">
                                <Heart className="h-4 w-4" />
                                <span>{alert.vitals.heartRate} bpm</span>
                              </div>
                            )}
                            {alert.vitals.bloodPressure && (
                              <div className="flex items-center gap-2 text-slate-600">
                                <Activity className="h-4 w-4" />
                                <span>{alert.vitals.bloodPressure} mmHg</span>
                              </div>
                            )}
                            {alert.vitals.temperature && (
                              <div className="flex items-center gap-2 text-slate-600">
                                <Thermometer className="h-4 w-4" />
                                <span>{alert.vitals.temperature}°C</span>
                              </div>
                            )}
                            {alert.vitals.oxygen && (
                              <div className="flex items-center gap-2 text-slate-600">
                                <Droplets className="h-4 w-4" />
                                <span>SpO2 {alert.vitals.oxygen}%</span>
                              </div>
                            )}
                          </div>
                        )}

                        {/* Assignment */}
                        {alert.assignedTo && (
                          <div className="flex items-center gap-2 text-slate-600">
                            <User className="h-4 w-4" />
                            <span>Assignée à {alert.assignedTo}</span>
                          </div>
                        )}
                      </div>
                    </div>

                    {/* Actions */}
                    <div className="flex flex-wrap gap-2 lg:flex-col lg:w-40">
                      {alert.status === 'pending' && (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleAcknowledge(alert.id);
                          }}
                          className="flex-1 lg:flex-none"
                        >
                          <Eye className="mr-2 h-4 w-4" />
                          Prendre en charge
                        </Button>
                      )}
                      {alert.status !== 'resolved' && (
                        <>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={(e) => {
                              e.stopPropagation();
                              handleResolve(alert.id);
                            }}
                            className="flex-1 lg:flex-none"
                          >
                            <CheckCircle className="mr-2 h-4 w-4" />
                            Résoudre
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={(e) => {
                              e.stopPropagation();
                              handleAssign(alert.id);
                            }}
                            className="flex-1 lg:flex-none"
                          >
                            <UserPlus className="mr-2 h-4 w-4" />
                            Assigner
                          </Button>
                        </>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}

            {filteredAlerts.length === 0 && (
              <Card>
                <CardContent className="flex flex-col items-center justify-center py-12">
                  <CheckCircle className="h-12 w-12 text-green-600 mb-4" />
                  <p className="text-slate-600">Aucune alerte correspondant aux filtres</p>
                </CardContent>
              </Card>
            )}
          </div>
        </TabsContent>

        {/* Statistics Tab */}
        <TabsContent value="stats" className="space-y-6">
          <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
            {/* Severity Distribution */}
            <Card>
              <CardHeader>
                <CardTitle>Répartition par gravité</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width="100%" height={300}>
                  <PieChart>
                    <Pie
                      data={severityDistribution}
                      cx="50%"
                      cy="50%"
                      labelLine={false}
                      label={({ name, value }) => `${name}: ${value}`}
                      outerRadius={100}
                      fill="#8884d8"
                      dataKey="value"
                    >
                      {severityDistribution.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Response Time */}
            <Card>
              <CardHeader>
                <CardTitle>Temps de réponse moyen (min)</CardTitle>
              </CardHeader>
              <CardContent>
                <ResponsiveContainer width="100%" height={300}>
                  <BarChart data={responseTimeData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Bar dataKey="temps" fill="#3b82f6" />
                  </BarChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>
          </div>

          {/* Status Progress */}
          <Card>
            <CardHeader>
              <CardTitle>État des alertes</CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <div className="flex justify-between text-slate-700">
                  <span>En attente</span>
                  <span>{stats.pending} / {stats.total}</span>
                </div>
                <Progress value={(stats.pending / stats.total) * 100} className="h-2" />
              </div>
              <div className="space-y-2">
                <div className="flex justify-between text-slate-700">
                  <span>En cours de traitement</span>
                  <span>{stats.inProgress} / {stats.total}</span>
                </div>
                <Progress value={(stats.inProgress / stats.total) * 100} className="h-2 [&>div]:bg-purple-600" />
              </div>
              <div className="space-y-2">
                <div className="flex justify-between text-slate-700">
                  <span>Résolues</span>
                  <span>{stats.resolved} / {stats.total}</span>
                </div>
                <Progress value={(stats.resolved / stats.total) * 100} className="h-2 [&>div]:bg-green-600" />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Analytics Tab */}
        <TabsContent value="analytics" className="space-y-6">
          {/* Weekly Trend */}
          <Card>
            <CardHeader>
              <CardTitle>Tendance hebdomadaire des alertes</CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={400}>
                <LineChart data={alertTrendData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="day" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line type="monotone" dataKey="critical" stroke={COLORS.critical} strokeWidth={2} name="Critiques" />
                  <Line type="monotone" dataKey="high" stroke={COLORS.high} strokeWidth={2} name="Élevées" />
                  <Line type="monotone" dataKey="medium" stroke={COLORS.medium} strokeWidth={2} name="Moyennes" />
                  <Line type="monotone" dataKey="low" stroke={COLORS.low} strokeWidth={2} name="Faibles" />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Key Metrics */}
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between mb-2">
                  <p className="text-slate-600">Taux de résolution</p>
                  <ArrowUp className="h-4 w-4 text-green-600" />
                </div>
                <p className="text-white mb-1">
                  {Math.round((stats.resolved / stats.total) * 100)}%
                </p>
                <p className="text-green-600">+12% vs semaine dernière</p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between mb-2">
                  <p className="text-slate-600">Temps moyen de réponse</p>
                  <ArrowDown className="h-4 w-4 text-green-600" />
                </div>
                <p className="text-white mb-1">18 min</p>
                <p className="text-green-600">-5 min vs semaine dernière</p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between mb-2">
                  <p className="text-slate-600">Alertes critiques</p>
                  <ArrowDown className="h-4 w-4 text-green-600" />
                </div>
                <p className="text-white mb-1">{stats.critical}</p>
                <p className="text-green-600">-2 vs semaine dernière</p>
              </CardContent>
            </Card>
          </div>
        </TabsContent>
      </Tabs>

      {/* Alert Detail Dialog */}
      <Dialog open={!!selectedAlert} onOpenChange={() => setSelectedAlert(null)}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Détails de l'alerte #{selectedAlert?.id}</DialogTitle>
            <DialogDescription>
              Informations complètes et historique de l'alerte
            </DialogDescription>
          </DialogHeader>
          {selectedAlert && (
            <div className="space-y-4">
              <div className="flex items-start gap-4">
                <Avatar className="h-12 w-12">
                  <AvatarFallback className="bg-blue-600 text-white">
                    {selectedAlert.patient.split(' ').map(n => n[0]).join('')}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <p className="text-slate-900 mb-1">{selectedAlert.patient}</p>
                  <p className="text-slate-600">ID: {selectedAlert.patientId}</p>
                </div>
                <div className="flex gap-2">
                  <Badge className={getSeverityColor(selectedAlert.severity)}>
                    {getSeverityLabel(selectedAlert.severity)}
                  </Badge>
                  <Badge className={getStatusColor(selectedAlert.status)}>
                    {getStatusLabel(selectedAlert.status)}
                  </Badge>
                </div>
              </div>

              <Separator />

              <div className="space-y-2">
                <p className="text-slate-900">{selectedAlert.type}</p>
                <p className="text-slate-600">{selectedAlert.description}</p>
              </div>

              {selectedAlert.vitals && (
                <>
                  <Separator />
                  <div>
                    <p className="text-slate-700 mb-3">Signes vitaux</p>
                    <div className="grid grid-cols-2 gap-4">
                      {selectedAlert.vitals.heartRate && (
                        <div className="flex items-center gap-2">
                          <Heart className="h-5 w-5 text-red-600" />
                          <div>
                            <p className="text-slate-600">Fréquence cardiaque</p>
                            <p className="text-slate-900">{selectedAlert.vitals.heartRate} bpm</p>
                          </div>
                        </div>
                      )}
                      {selectedAlert.vitals.bloodPressure && (
                        <div className="flex items-center gap-2">
                          <Activity className="h-5 w-5 text-blue-600" />
                          <div>
                            <p className="text-slate-600">Pression artérielle</p>
                            <p className="text-slate-900">{selectedAlert.vitals.bloodPressure} mmHg</p>
                          </div>
                        </div>
                      )}
                      {selectedAlert.vitals.temperature && (
                        <div className="flex items-center gap-2">
                          <Thermometer className="h-5 w-5 text-orange-600" />
                          <div>
                            <p className="text-slate-600">Température</p>
                            <p className="text-slate-900">{selectedAlert.vitals.temperature}°C</p>
                          </div>
                        </div>
                      )}
                      {selectedAlert.vitals.oxygen && (
                        <div className="flex items-center gap-2">
                          <Droplets className="h-5 w-5 text-cyan-600" />
                          <div>
                            <p className="text-slate-600">Saturation O2</p>
                            <p className="text-slate-900">{selectedAlert.vitals.oxygen}%</p>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                </>
              )}

              <Separator />

              <div className="flex items-center gap-2 text-slate-600">
                <Calendar className="h-4 w-4" />
                <span>Détectée le {selectedAlert.timestamp}</span>
              </div>

              {selectedAlert.assignedTo && (
                <div className="flex items-center gap-2 text-slate-600">
                  <User className="h-4 w-4" />
                  <span>Assignée à {selectedAlert.assignedTo}</span>
                </div>
              )}

              <div className="flex gap-2 pt-4">
                {selectedAlert.status === 'pending' && (
                  <Button onClick={() => {
                    handleAcknowledge(selectedAlert.id);
                    setSelectedAlert(null);
                  }} className="flex-1">
                    <Eye className="mr-2 h-4 w-4" />
                    Prendre en charge
                  </Button>
                )}
                {selectedAlert.status !== 'resolved' && (
                  <Button onClick={() => {
                    handleResolve(selectedAlert.id);
                    setSelectedAlert(null);
                  }} className="flex-1">
                    <CheckCircle className="mr-2 h-4 w-4" />
                    Marquer comme résolue
                  </Button>
                )}
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
