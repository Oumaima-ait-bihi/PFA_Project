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
  DialogTrigger,
} from './ui/dialog';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from './ui/table';
import { Search, Plus, Edit, Trash2, UserCheck, Mail, Phone, Building2 } from 'lucide-react';
import { toast } from 'sonner';
import { getMedecins, createMedecin, updateMedecin, deleteMedecin, MedecinDto } from '../lib/api';

interface Doctor {
  id: number;
  name: string;
  email: string;
  phone: string;
  specialty: string;
  license?: string;
  hospital?: string;
  status?: 'active' | 'inactive';
  patientsCount?: number;
}

export function AdminDoctors() {
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingDoctor, setEditingDoctor] = useState<Doctor | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    specialty: '',
    license: '',
    hospital: '',
    password: '',
  });

  // Charger les médecins depuis l'API au démarrage
  useEffect(() => {
    loadDoctors();
  }, []);

  const loadDoctors = async () => {
    try {
      setLoading(true);
      const medecins = await getMedecins();
      // Convertir les MedecinDto en Doctor pour l'affichage
      const doctorsData: Doctor[] = medecins.map((m) => ({
        id: m.id,
        name: m.nom,
        email: m.email,
        phone: m.phone,
        specialty: m.specialite,
        status: 'active' as const,
        patientsCount: 0,
      }));
      setDoctors(doctorsData);
    } catch (error) {
      console.error('Erreur lors du chargement des médecins:', error);
      toast.error('Erreur lors du chargement des médecins');
    } finally {
      setLoading(false);
    }
  };

  const filteredDoctors = doctors.filter((doctor) =>
    doctor.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    doctor.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
    doctor.specialty.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleAddDoctor = () => {
    setEditingDoctor(null);
    setFormData({
      name: '',
      email: '',
      phone: '',
      specialty: '',
      license: '',
      hospital: '',
    });
    setIsDialogOpen(true);
  };

  const handleEditDoctor = (doctor: Doctor) => {
    setEditingDoctor(doctor);
    setFormData({
      name: doctor.name,
      email: doctor.email,
      phone: doctor.phone,
      specialty: doctor.specialty,
      license: doctor.license,
      hospital: doctor.hospital,
      password: '',
    });
    setIsDialogOpen(true);
  };

  const handleSaveDoctor = async () => {
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
    if (!formData.specialty.trim()) {
      toast.error('La spécialité est requise');
      return;
    }

    try {
      if (editingDoctor) {
        // Mise à jour
        const updatePayload: any = {
          nom: formData.name.trim(),
          email: formData.email.trim(),
          phone: formData.phone.trim(),
          specialite: formData.specialty.trim(),
        };
        if (formData.password && formData.password.trim() !== '') {
          updatePayload.password = formData.password;
        }

        const updatedMedecin = await updateMedecin(editingDoctor.id, updatePayload);
        // Mettre à jour la liste locale
        setDoctors(
          doctors.map((d) =>
            d.id === editingDoctor.id
              ? {
                  ...d,
                  name: updatedMedecin.nom,
                  email: updatedMedecin.email,
                  phone: updatedMedecin.phone,
                  specialty: updatedMedecin.specialite,
                }
              : d
          )
        );
        toast.success('Médecin mis à jour avec succès');
      } else {
        // Création
        const createPayload: any = {
          nom: formData.name.trim(),
          email: formData.email.trim(),
          phone: formData.phone.trim(),
          specialite: formData.specialty.trim(),
        };
        if (formData.password && formData.password.trim() !== '') {
          createPayload.password = formData.password;
        }

        const newMedecin = await createMedecin(createPayload);
        // Ajouter à la liste locale
        const newDoctor: Doctor = {
          id: newMedecin.id,
          name: newMedecin.nom,
          email: newMedecin.email,
          phone: newMedecin.phone,
          specialty: newMedecin.specialite,
          status: 'active',
          patientsCount: 0,
        };
        setDoctors([...doctors, newDoctor]);
        toast.success('Médecin ajouté avec succès');
      }
      setIsDialogOpen(false);
    } catch (error) {
      console.error('Erreur lors de la sauvegarde:', error);
      const errorMessage = error instanceof Error ? error.message : 'Erreur lors de la sauvegarde du médecin';
      toast.error(errorMessage);
    }
  };

  const handleDeleteDoctor = async (id: number) => {
    if (confirm('Êtes-vous sûr de vouloir supprimer ce médecin ?')) {
      try {
        await deleteMedecin(id);
        setDoctors(doctors.filter((d) => d.id !== id));
        toast.success('Médecin supprimé avec succès');
      } catch (error) {
        console.error('Erreur lors de la suppression:', error);
        toast.error('Erreur lors de la suppression du médecin');
      }
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-3xl font-bold mb-2">Gestion des Médecins</h2>
          <p className="text-slate-600">{filteredDoctors.length} médecin(s) enregistré(s)</p>
        </div>
        <Button onClick={handleAddDoctor} className="gap-2">
          <Plus className="h-4 w-4" />
          Ajouter un médecin
        </Button>
      </div>

      {/* Search */}
      <Card>
        <CardContent className="pt-6">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
            <Input
              placeholder="Rechercher un médecin..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10"
            />
          </div>
        </CardContent>
      </Card>

      {/* Doctors Table */}
      <Card>
        <CardHeader>
          <CardTitle>Liste des médecins</CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="text-center py-8">Chargement...</div>
          ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Médecin</TableHead>
                <TableHead>Spécialité</TableHead>
                <TableHead>Contact</TableHead>
                <TableHead>Établissement</TableHead>
                <TableHead>Patients</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredDoctors.map((doctor) => (
                <TableRow key={doctor.id}>
                  <TableCell>
                    <div className="flex items-center gap-3">
                      <Avatar>
                        <AvatarFallback className="bg-blue-600 text-white">
                          {doctor.name
                            .split(' ')
                            .map((n) => n[0])
                            .join('')}
                        </AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium">{doctor.name}</p>
                        <p className="text-sm text-slate-500">ID: {doctor.id}</p>
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{doctor.specialty}</Badge>
                  </TableCell>
                  <TableCell>
                    <div className="space-y-1">
                      <div className="flex items-center gap-2 text-sm">
                        <Mail className="h-3 w-3" />
                        {doctor.email}
                      </div>
                      <div className="flex items-center gap-2 text-sm">
                        <Phone className="h-3 w-3" />
                        {doctor.phone}
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <Building2 className="h-4 w-4 text-slate-400" />
                      {doctor.hospital}
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <UserCheck className="h-4 w-4 text-blue-600" />
                      {doctor.patientsCount}
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge
                      className={
                        doctor.status === 'active'
                          ? 'bg-green-100 text-green-800'
                          : 'bg-red-100 text-red-800'
                      }
                    >
                      {doctor.status === 'active' ? 'Actif' : 'Inactif'}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex justify-end gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleEditDoctor(doctor)}
                      >
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleDeleteDoctor(doctor.id as number)}
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
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {editingDoctor ? 'Modifier le médecin' : 'Ajouter un médecin'}
            </DialogTitle>
            <DialogDescription>
              {editingDoctor
                ? 'Modifiez les informations du médecin'
                : 'Remplissez les informations pour ajouter un nouveau médecin'}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium">Nom complet</label>
                <Input
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Dr. Hasna Ait Ben Brahim"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Email</label>
                <Input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="hasna.aitbenbrahim@xyz-clinic.com"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Mot de passe</label>
                <Input
                  type="password"
                  value={formData.password}
                  onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  placeholder={editingDoctor ? 'Laisser vide pour ne pas changer' : 'Mot de passe'}
                />
              </div>
              <div>
                <label className="text-sm font-medium">Téléphone</label>
                <Input
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="+33 1 23 45 67 89"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Spécialité</label>
                <Input
                  value={formData.specialty}
                  onChange={(e) => setFormData({ ...formData, specialty: e.target.value })}
                  placeholder="Cardiologie"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Numéro de licence</label>
                <Input
                  value={formData.license}
                  onChange={(e) => setFormData({ ...formData, license: e.target.value })}
                  placeholder="FR-MED-123456"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Établissement</label>
                <Input
                  value={formData.hospital}
                  onChange={(e) => setFormData({ ...formData, hospital: e.target.value })}
                  placeholder="Hôpital Universitaire"
                />
              </div>
            </div>
            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
                Annuler
              </Button>
              <Button onClick={handleSaveDoctor}>
                {editingDoctor ? 'Enregistrer' : 'Ajouter'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

