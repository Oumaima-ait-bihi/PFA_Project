import { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import { useLanguage } from '../contexts/LanguageContext';
import { toast } from 'sonner';
import {
  Search, 
  Filter, 
  Eye, 
  Phone, 
  Mail,
  Calendar,
  Activity,
  Heart,
  Download
} from 'lucide-react';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from './ui/table';
import { getPatients, type PatientDto } from "../lib/api";

const getStatusColor = (status: string) => {
  switch (status) {
    case 'critical':
      return 'bg-red-100 text-red-800 border-red-200';
    case 'high':
      return 'bg-orange-100 text-orange-800 border-orange-200';
    case 'stable':
      return 'bg-green-100 text-green-800 border-green-200';
    default:
      return 'bg-slate-100 text-slate-800 border-slate-200';
  }
};

const getStatusLabel = (status: string, t: (key: string) => string) => {
  switch (status) {
    case 'critical':
      return t('patients.critical');
    case 'high':
      return t('patients.high');
    case 'stable':
      return t('patients.stable');
    default:
      return status;
  }
};

export function PatientsList() {
  const { t } = useLanguage();
  const [patients, setPatients] = useState<PatientDto[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [viewMode, setViewMode] = useState<'grid' | 'table'>('grid');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadPatients() {
      try {
        const data = await getPatients();
        setPatients(data);
      } catch (e) {
        console.error(e);
        setError("Impossible de charger les patients");
        toast.error("Erreur lors du chargement des patients");
      } finally {
        setLoading(false);
      }
    }
    loadPatients();
  }, []);

  const filteredPatients = patients.filter((patient) => {
    const matchesSearch =
      patient.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      String(patient.id).toLowerCase().includes(searchQuery.toLowerCase()) ||
      (patient.email && patient.email.toLowerCase().includes(searchQuery.toLowerCase()));
    const matchesStatus = statusFilter === 'all' || patient.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const handleViewDetails = (patientId: number) => {
    toast.info(`Affichage des détails du patient ${patientId}`);
  };

  const handleContact = (patient: PatientDto) => {
    toast.info(`Contacter ${patient.name}`);
  };

  const handleExport = () => {
    toast.success('Export de la liste des patients...');
  };

  return (
    <div className="space-y-6">
      {loading && <p className="text-slate-600">Chargement des patients...</p>}
      {error && <p className="text-red-600">{error}</p>}
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-white mb-2">{t('patients.title')}</h2>
          <p className="text-slate-600">
            {filteredPatients.length} patient{filteredPatients.length > 1 ? 's' : ''}
          </p>
        </div>
        <Button onClick={handleExport} className="gap-2">
          <Download className="h-4 w-4" />
          {t('common.export')}
        </Button>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex flex-col gap-4 md:flex-row">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                <Input
                  placeholder={t('patients.search')}
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div className="w-full md:w-48">
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger>
                  <Filter className="mr-2 h-4 w-4" />
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">{t('patients.all')}</SelectItem>
                  <SelectItem value="critical">{t('patients.critical')}</SelectItem>
                  <SelectItem value="high">{t('patients.high')}</SelectItem>
                  <SelectItem value="stable">{t('patients.stable')}</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Grid View */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
        {filteredPatients.map((patient) => (
          <Card key={patient.id} className="hover:shadow-lg transition-shadow">
            <CardContent className="pt-6">
              <div className="flex items-start gap-4 mb-4">
                <Avatar className="h-12 w-12">
                  <AvatarFallback className="bg-blue-600 text-white">
                    {patient.name.split(' ').map(n => n[0]).join('')}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1 min-w-0">
                  <p className="text-slate-900 mb-1 truncate">{patient.name}</p>
                  <p className="text-slate-600">{patient.id}</p>
                </div>
                <Badge className={getStatusColor(patient.status)}>
                  {getStatusLabel(patient.status, t)}
                </Badge>
              </div>

              <div className="space-y-2 mb-4">
                <div className="flex items-center gap-2 text-slate-600">
                  <Activity className="h-4 w-4" />
                  <span>{patient.age} {t('patients.age')}</span>
                </div>
                <div className="flex items-center gap-2 text-slate-600">
                  <Heart className="h-4 w-4" />
                  <span className="truncate">{patient.condition}</span>
                </div>
                <div className="flex items-center gap-2 text-slate-600">
                  <Calendar className="h-4 w-4" />
                  <span>{t('patients.lastVisit')}: {patient.lastVisit}</span>
                </div>
              </div>

              <div className="flex gap-2">
                <Button 
                  variant="outline" 
                  size="sm" 
                  className="flex-1"
                  onClick={() => handleContact(patient)}
                >
                  <Phone className="mr-2 h-4 w-4" />
                  {t('patients.contact')}
                </Button>
                <Button 
                  size="sm" 
                  className="flex-1"
                  onClick={() => handleViewDetails(patient.id)}
                >
                  <Eye className="mr-2 h-4 w-4" />
                  {t('patients.viewDetails')}
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filteredPatients.length === 0 && (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-12">
            <Search className="h-12 w-12 text-slate-300 mb-4" />
            <p className="text-slate-600">Aucun patient trouvé</p>
          </CardContent>
        </Card>
      )}

      {/* Statistics Card */}
      <Card>
        <CardHeader>
          <CardTitle>Statistiques</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            <div className="flex items-center gap-4 p-4 bg-red-50 rounded-lg">
              <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-red-600 text-white">
                {patients.filter(p => p.status === 'critical').length}
              </div>
              <div>
                <p className="text-red-900">Critiques</p>
                <p className="text-red-600">Attention requise</p>
              </div>
            </div>
            <div className="flex items-center gap-4 p-4 bg-orange-50 rounded-lg">
              <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-orange-600 text-white">
                {patients.filter(p => p.status === 'high').length}
              </div>
              <div>
                <p className="text-orange-900">Risque élevé</p>
                <p className="text-orange-600">Surveillance</p>
              </div>
            </div>
            <div className="flex items-center gap-4 p-4 bg-green-50 rounded-lg">
              <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-green-600 text-white">
                {patients.filter(p => p.status === 'stable').length}
              </div>
              <div>
                <p className="text-green-900">Stables</p>
                <p className="text-green-600">État normal</p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
