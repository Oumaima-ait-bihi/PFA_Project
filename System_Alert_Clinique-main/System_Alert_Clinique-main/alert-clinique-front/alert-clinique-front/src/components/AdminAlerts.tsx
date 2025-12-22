import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from './ui/table';
import { Search, Filter, AlertTriangle, CheckCircle, Clock, Eye } from 'lucide-react';
import { toast } from 'sonner';

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
  },
];

export function AdminAlerts() {
  const [alerts, setAlerts] = useState<Alert[]>(mockAlerts);
  const [searchQuery, setSearchQuery] = useState('');
  const [severityFilter, setSeverityFilter] = useState<string>('all');
  const [statusFilter, setStatusFilter] = useState<string>('all');

  const filteredAlerts = alerts.filter((alert) => {
    const matchesSearch =
      alert.patient.toLowerCase().includes(searchQuery.toLowerCase()) ||
      alert.patientId.toLowerCase().includes(searchQuery.toLowerCase()) ||
      alert.type.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesSeverity = severityFilter === 'all' || alert.severity === severityFilter;
    const matchesStatus = statusFilter === 'all' || alert.status === statusFilter;
    return matchesSearch && matchesSeverity && matchesStatus;
  });

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

  const getSeverityLabel = (severity: string) => {
    switch (severity) {
      case 'critical':
        return 'Critique';
      case 'high':
        return 'Élevé';
      case 'medium':
        return 'Moyen';
      case 'low':
        return 'Faible';
      default:
        return severity;
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

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'inProgress':
        return 'En cours';
      case 'resolved':
        return 'Résolue';
      default:
        return status;
    }
  };

  const handleResolve = (id: number) => {
    setAlerts(
      alerts.map((alert) =>
        alert.id === id ? { ...alert, status: 'resolved' as const } : alert
      )
    );
    toast.success('Alerte marquée comme résolue');
  };

  const stats = {
    total: alerts.length,
    critical: alerts.filter((a) => a.severity === 'critical').length,
    high: alerts.filter((a) => a.severity === 'high').length,
    pending: alerts.filter((a) => a.status === 'pending').length,
    resolved: alerts.filter((a) => a.status === 'resolved').length,
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold mb-2">Gestion des Alertes</h2>
        <p className="text-slate-600">{filteredAlerts.length} alerte(s) active(s)</p>
      </div>

      {/* Statistics */}
      <div className="grid grid-cols-2 gap-4">
        <Card className="border-l-4 border-l-red-500">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-slate-600 text-sm">Critiques</p>
                <p className="text-2xl font-bold">{stats.critical}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-red-600" />
            </div>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-orange-500">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-slate-600 text-sm">Risque élevé</p>
                <p className="text-2xl font-bold">{stats.high}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-orange-600" />
            </div>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-blue-500">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-slate-600 text-sm">En attente</p>
                <p className="text-2xl font-bold">{stats.pending}</p>
              </div>
              <Clock className="h-8 w-8 text-blue-600" />
            </div>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-green-500">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-slate-600 text-sm">Résolues</p>
                <p className="text-2xl font-bold">{stats.resolved}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-green-600" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <Input
                placeholder="Rechercher une alerte..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10"
              />
            </div>
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-slate-400" />
              <select
                value={severityFilter}
                onChange={(e) => setSeverityFilter(e.target.value)}
                className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="all">Toutes les gravités</option>
                <option value="critical">Critique</option>
                <option value="high">Élevé</option>
                <option value="medium">Moyen</option>
                <option value="low">Faible</option>
              </select>
            </div>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
            >
              <option value="all">Tous les statuts</option>
              <option value="pending">En attente</option>
              <option value="inProgress">En cours</option>
              <option value="resolved">Résolues</option>
            </select>
          </div>
        </CardContent>
      </Card>

      {/* Alerts Table */}
      <Card>
        <CardHeader>
          <CardTitle>Liste des alertes</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Type d'alerte</TableHead>
                <TableHead>Description</TableHead>
                <TableHead>Gravité</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead>Assigné à</TableHead>
                <TableHead>Détectée</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredAlerts.map((alert) => (
                <TableRow key={alert.id}>
                  <TableCell>
                    <div className="flex items-center gap-3">
                      <Avatar>
                        <AvatarFallback className="bg-blue-600 text-white">
                          {alert.patient
                            .split(' ')
                            .map((n) => n[0])
                            .join('')}
                        </AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium">{alert.patient}</p>
                        <p className="text-sm text-slate-500">{alert.patientId}</p>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <AlertTriangle className="h-4 w-4 text-orange-600" />
                      {alert.type}
                    </div>
                  </TableCell>
                  <TableCell>
                    <p className="text-sm text-slate-600">{alert.description}</p>
                  </TableCell>
                  <TableCell>
                    <Badge className={getSeverityColor(alert.severity)}>
                      {getSeverityLabel(alert.severity)}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Badge className={getStatusColor(alert.status)}>
                      {getStatusLabel(alert.status)}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {alert.assignedTo ? (
                      <span className="text-sm">{alert.assignedTo}</span>
                    ) : (
                      <span className="text-sm text-slate-400">Non assigné</span>
                    )}
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2 text-sm text-slate-600">
                      <Clock className="h-3 w-3" />
                      Il y a {alert.time}
                    </div>
                  </TableCell>
                  <TableCell className="text-right">
                    {alert.status !== 'resolved' && (
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleResolve(alert.id)}
                        className="gap-2"
                      >
                        <CheckCircle className="h-4 w-4" />
                        Résoudre
                      </Button>
                    )}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}

