import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from './ui/dialog';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from './ui/table';
import { Search, Plus, Edit, Trash2, Mail, Phone, Calendar, Activity } from 'lucide-react';
import { toast } from 'sonner';
import { getPatients, createPatient, updatePatient, deletePatient, PatientDto } from '../lib/api';

interface Patient {
  id: number;
  name: string;
  email: string;
  phone: string;
  age: number;
  gender: string;
  condition?: string;
  status: 'critical' | 'high' | 'stable';
  lastVisit?: string;
  assignedDoctor?: string;
  adresse?: string;
}

export function AdminPatients() {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingPatient, setEditingPatient] = useState<Patient | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    password: '',
    age: '',
    gender: '',
    condition: '',
    status: 'stable' as 'critical' | 'high' | 'stable',
    assignedDoctor: '',
    adresse: '',
  });

  // Charger les patients depuis l'API au démarrage
  useEffect(() => {
    loadPatients();
  }, []);

  const loadPatients = async () => {
    try {
      setLoading(true);
      const patientsData = await getPatients();
      setPatients(patientsData);
    } catch (error) {
      console.error('Erreur lors du chargement des patients:', error);
      toast.error('Erreur lors du chargement des patients');
    } finally {
      setLoading(false);
    }
  };

  const filteredPatients = patients.filter((patient) => {
    const matchesSearch =
      patient.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      patient.id.toString().includes(searchQuery.toLowerCase()) ||
      patient.email.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus = statusFilter === 'all' || patient.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'critical':
        return 'bg-red-100 text-red-800';
      case 'high':
        return 'bg-orange-100 text-orange-800';
      case 'stable':
        return 'bg-green-100 text-green-800';
      default:
        return 'bg-slate-100 text-slate-800';
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'critical':
        return 'Critique';
      case 'high':
        return 'Risque élevé';
      case 'stable':
        return 'Stable';
      default:
        return status;
    }
  };

  const handleAddPatient = () => {
    setEditingPatient(null);
    setFormData({
      name: '',
      email: '',
      phone: '',
      password: '',
      age: '',
      gender: '',
      condition: '',
      status: 'stable',
      assignedDoctor: '',
      adresse: '',
    });
    setIsDialogOpen(true);
  };

  const handleEditPatient = (patient: Patient) => {
    setEditingPatient(patient);
    setFormData({
      name: patient.name,
      email: patient.email,
      phone: patient.phone,
      password: '',
      age: patient.age.toString(),
      gender: patient.gender,
      condition: patient.condition || '',
      status: patient.status,
      assignedDoctor: patient.assignedDoctor || '',
      adresse: patient.adresse || '',
    });
    setIsDialogOpen(true);
  };

  const handleSavePatient = async () => {
    // Validation des champs requis
    if (!formData.name.trim()) {
      toast.error('Le nom est requis');
      return;
    }
    if (!formData.email.trim()) {
      toast.error('L\'email est requis');
      return;
    }
    if (!formData.phone.trim()) {
      toast.error('Le téléphone est requis');
      return;
    }
    if (!formData.age || parseInt(formData.age) <= 0) {
      toast.error('L\'âge est requis et doit être supérieur à 0');
      return;
    }
    if (!formData.gender) {
      toast.error('Le genre est requis');
      return;
    }
    if (!formData.status) {
      toast.error('Le statut est requis');
      return;
    }

    try {
      if (editingPatient) {
        // Mise à jour
        const updatePayload: any = {
          name: formData.name.trim(),
          email: formData.email.trim(),
          phone: formData.phone.trim(),
          age: parseInt(formData.age),
          gender: formData.gender,
          condition: formData.condition?.trim() || undefined,
          status: formData.status,
          assignedDoctor: formData.assignedDoctor?.trim() || undefined,
          adresse: formData.adresse?.trim() || undefined,
        };
        if (formData.password && formData.password.trim() !== '') {
          updatePayload.password = formData.password;
        }

        const updatedPatient = await updatePatient(editingPatient.id, updatePayload);
        // Mettre à jour la liste locale
        setPatients(
          patients.map((p) =>
            p.id === editingPatient.id ? updatedPatient : p
          )
        );
        toast.success('Patient mis à jour avec succès');
      } else {
        // Création
        const createPayload: any = {
          name: formData.name.trim(),
          email: formData.email.trim(),
          phone: formData.phone.trim(),
          age: parseInt(formData.age),
          gender: formData.gender,
          condition: formData.condition?.trim() || undefined,
          status: formData.status,
          assignedDoctor: formData.assignedDoctor?.trim() || undefined,
          adresse: formData.adresse?.trim() || undefined,
        };
        if (formData.password && formData.password.trim() !== '') {
          createPayload.password = formData.password;
        }

        const newPatient = await createPatient(createPayload);
        // Ajouter à la liste locale
        setPatients([...patients, newPatient]);
        toast.success('Patient ajouté avec succès');
      }
      setIsDialogOpen(false);
    } catch (error) {
      console.error('Erreur lors de la sauvegarde:', error);
      const errorMessage = error instanceof Error ? error.message : 'Erreur lors de la sauvegarde du patient';
      toast.error(errorMessage);
    }
  };

  const handleDeletePatient = async (id: number) => {
    if (confirm('Êtes-vous sûr de vouloir supprimer ce patient ?')) {
      try {
        await deletePatient(id);
        setPatients(patients.filter((p) => p.id !== id));
        toast.success('Patient supprimé avec succès');
      } catch (error) {
        console.error('Erreur lors de la suppression:', error);
        toast.error('Erreur lors de la suppression du patient');
      }
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold mb-2">Gestion des Patients</h2>
          <p className="text-slate-600">{filteredPatients.length} patient(s) enregistré(s)</p>
        </div>
        <Button onClick={handleAddPatient} className="gap-2">
          <Plus className="h-4 w-4" />
          Ajouter un patient
        </Button>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <Input
                placeholder="Rechercher un patient..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10"
              />
            </div>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
            >
              <option value="all">Tous les statuts</option>
              <option value="critical">Critique</option>
              <option value="high">Risque élevé</option>
              <option value="stable">Stable</option>
            </select>
          </div>
        </CardContent>
      </Card>

      {/* Patients Table */}
      <Card>
        <CardHeader>
          <CardTitle>Liste des patients</CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="text-center py-8">Chargement...</div>
          ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Informations</TableHead>
                <TableHead>Condition</TableHead>
                <TableHead>Médecin assigné</TableHead>
                <TableHead>Dernière visite</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredPatients.map((patient) => (
                <TableRow key={patient.id}>
                  <TableCell>
                    <div className="flex items-center gap-3">
                      <Avatar>
                        <AvatarFallback className="bg-blue-600 text-white">
                          {patient.name
                            .split(' ')
                            .map((n) => n[0])
                            .join('')}
                        </AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium">{patient.name}</p>
                        <p className="text-sm text-slate-500">ID: {patient.id}</p>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="space-y-1">
                      <div className="flex items-center gap-2 text-sm">
                        <Mail className="h-3 w-3" />
                        {patient.email}
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <Phone className="h-3 w-3" />
                        {patient.phone}
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <Activity className="h-3 w-3" />
                        {patient.age} ans, {patient.gender === 'M' ? 'Homme' : 'Femme'}
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{patient.condition}</Badge>
                  </TableCell>
                  <TableCell>{patient.assignedDoctor || 'Non assigné'}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <Calendar className="h-4 w-4 text-slate-400" />
                      {patient.lastVisit || 'N/A'}
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge className={getStatusColor(patient.status)}>
                      {getStatusLabel(patient.status)}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleEditPatient(patient)}
                      >
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleDeletePatient(patient.id as number)}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          )}
        </CardContent>
      </Card>

      {/* Add/Edit Dialog */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {editingPatient ? 'Modifier le patient' : 'Ajouter un patient'}
            </DialogTitle>
            <DialogDescription>
              {editingPatient
                ? 'Modifiez les informations du patient'
                : 'Remplissez les informations pour ajouter un nouveau patient'}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium">Nom complet</label>
                <Input
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Sophie Martin"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Email</label>
                <Input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="sophie.martin@email.com"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Mot de passe</label>
                <Input
                  type="password"
                  value={formData.password}
                  onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  placeholder={editingPatient ? 'Laisser vide pour ne pas changer' : 'Mot de passe'}
                />
              </div>
              <div>
                <label className="text-sm font-medium">Téléphone</label>
                <Input
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="+33 6 12 34 56 78"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Âge</label>
                <Input
                  type="number"
                  value={formData.age}
                  onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                  placeholder="45"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Genre</label>
                <select
                  value={formData.gender}
                  onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                  className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                >
                  <option value="">Sélectionner</option>
                  <option value="M">Homme</option>
                  <option value="F">Femme</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">Condition</label>
                <Input
                  value={formData.condition}
                  onChange={(e) => setFormData({ ...formData, condition: e.target.value })}
                  placeholder="Hypertension sévère"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Statut</label>
                <select
                  value={formData.status}
                  onChange={(e) =>
                    setFormData({
                      ...formData,
                      status: e.target.value as 'critical' | 'high' | 'stable',
                    })
                  }
                  className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                >
                  <option value="stable">Stable</option>
                  <option value="high">Risque élevé</option>
                  <option value="critical">Critique</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">Médecin assigné</label>
                <Input
                  value={formData.assignedDoctor}
                  onChange={(e) =>
                    setFormData({ ...formData, assignedDoctor: e.target.value })
                  }
                  placeholder="Dr. Hasna Ait Ben Brahim"
                />
              </div>
              <div className="col-span-2">
                <label className="text-sm font-medium">Adresse</label>
                <Input
                  value={formData.adresse}
                  onChange={(e) =>
                    setFormData({ ...formData, adresse: e.target.value })
                  }
                  placeholder="123 Rue Example, Ville"
                />
              </div>
            </div>
            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
                Annuler
              </Button>
              <Button onClick={handleSavePatient}>
                {editingPatient ? 'Enregistrer' : 'Ajouter'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

