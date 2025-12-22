import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Avatar, AvatarFallback } from './ui/avatar';
import { Badge } from './ui/badge';
import { Textarea } from './ui/textarea';
import { useLanguage } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';
import { toast } from 'sonner';
import { 
  User, 
  Mail, 
  Phone, 
  MapPin, 
  Briefcase,
  GraduationCap,
  Award,
  Calendar,
  Globe,
  Edit,
  Save,
  Building2,
  Stethoscope
} from 'lucide-react';

export function DoctorProfile() {
  const { t } = useLanguage();
  const { user } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [profileData, setProfileData] = useState({
    name: user?.name || 'Dr. Hasna Ait Ben Brahim',
    email: user?.email || 'hasna.aitbenbrahim@hopital.com',
    phone: '+33 1 23 45 67 89',
    specialty: 'Cardiologie',
    license: 'FR-MED-123456',
    hospital: 'Hôpital Universitaire de Paris',
    experience: '15',
    address: '45 Avenue de la République, 75011 Paris',
    languages: ['Français', 'Anglais', 'Arabe'],
    about: 'Cardiologue spécialisée dans les maladies cardiovasculaires avec plus de 15 ans d\'expérience dans la prise en charge des patients.',
  });

  const education = [
    {
      degree: 'Doctorat en Médecine',
      institution: 'Université Paris Diderot',
      year: '2008',
    },
    {
      degree: 'Spécialisation en Cardiologie',
      institution: 'Hôpital Pitié-Salpêtrière',
      year: '2012',
    },
    {
      degree: 'Master en Recherche Cardiovasculaire',
      institution: 'Sorbonne Université',
      year: '2014',
    },
  ];

  const certifications = [
    {
      name: 'European Board of Cardiology',
      issuer: 'ESC',
      year: '2013',
    },
    {
      name: 'Certification en Échographie Cardiaque',
      issuer: 'SFC',
      year: '2015',
    },
    {
      name: 'Formation Avancée en Électrophysiologie',
      issuer: 'EHRA',
      year: '2018',
    },
  ];

  const statistics = [
    { label: 'Patients suivis', value: '247', icon: User },
    { label: 'Années d\'expérience', value: '15+', icon: Calendar },
    { label: 'Consultations/mois', value: '180', icon: Briefcase },
    { label: 'Taux de satisfaction', value: '98%', icon: Award },
  ];

  const handleSave = () => {
    setIsEditing(false);
    toast.success('Profil mis à jour avec succès');
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-white mb-2">{t('profile.title')}</h2>
          <p className="text-slate-600">Gérez vos informations professionnelles</p>
        </div>
        <Button
          onClick={() => isEditing ? handleSave() : setIsEditing(true)}
          className="gap-2"
        >
          {isEditing ? (
            <>
              <Save className="h-4 w-4" />
              {t('profile.save')}
            </>
          ) : (
            <>
              <Edit className="h-4 w-4" />
              {t('profile.edit')}
            </>
          )}
        </Button>
      </div>

      {/* Profile Header */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex flex-col items-center gap-4 md:flex-row md:items-start">
            <Avatar className="h-24 w-24">
              <AvatarFallback className="bg-blue-600 text-white text-2xl">
                {profileData.name.split(' ').filter(n => n !== 'Dr.').map(n => n[0]).join('')}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1 text-center md:text-left">
              <h3 className="text-white mb-2">{profileData.name}</h3>
              <p className="text-slate-600 mb-2">{profileData.specialty}</p>
              <div className="flex flex-wrap gap-2 justify-center md:justify-start">
                <Badge className="bg-blue-100 text-blue-800">
                  <Stethoscope className="mr-1 h-3 w-3" />
                  Médecin
                </Badge>
                <Badge className="bg-green-100 text-green-800">Actif</Badge>
                <Badge className="bg-purple-100 text-purple-800">Certifié</Badge>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Statistics */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {statistics.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <Card key={index}>
              <CardContent className="flex items-center gap-4 p-6">
                <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
                  <Icon className="h-6 w-6 text-blue-600" />
                </div>
                <div>
                  <p className="text-slate-600">{stat.label}</p>
                  <p className="text-white">{stat.value}</p>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Personal Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-5 w-5 text-blue-600" />
              {t('profile.personalInfo')}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Nom complet</Label>
              <div className="flex items-center gap-2">
                <User className="h-4 w-4 text-slate-400" />
                <Input
                  id="name"
                  value={profileData.name}
                  onChange={(e) => setProfileData({...profileData, name: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <div className="flex items-center gap-2">
                <Mail className="h-4 w-4 text-slate-400" />
                <Input
                  id="email"
                  type="email"
                  value={profileData.email}
                  onChange={(e) => setProfileData({...profileData, email: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="phone">Téléphone</Label>
              <div className="flex items-center gap-2">
                <Phone className="h-4 w-4 text-slate-400" />
                <Input
                  id="phone"
                  value={profileData.phone}
                  onChange={(e) => setProfileData({...profileData, phone: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="address">Adresse</Label>
              <div className="flex items-center gap-2">
                <MapPin className="h-4 w-4 text-slate-400" />
                <Input
                  id="address"
                  value={profileData.address}
                  onChange={(e) => setProfileData({...profileData, address: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="about">À propos</Label>
              <Textarea
                id="about"
                value={profileData.about}
                onChange={(e) => setProfileData({...profileData, about: e.target.value})}
                disabled={!isEditing}
                rows={4}
              />
            </div>
          </CardContent>
        </Card>

        {/* Professional Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Briefcase className="h-5 w-5 text-blue-600" />
              {t('profile.professionalInfo')}
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="specialty">{t('profile.specialty')}</Label>
              <div className="flex items-center gap-2">
                <Stethoscope className="h-4 w-4 text-slate-400" />
                <Input
                  id="specialty"
                  value={profileData.specialty}
                  onChange={(e) => setProfileData({...profileData, specialty: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="license">{t('profile.license')}</Label>
              <div className="flex items-center gap-2">
                <Award className="h-4 w-4 text-slate-400" />
                <Input
                  id="license"
                  value={profileData.license}
                  onChange={(e) => setProfileData({...profileData, license: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="hospital">{t('profile.hospital')}</Label>
              <div className="flex items-center gap-2">
                <Building2 className="h-4 w-4 text-slate-400" />
                <Input
                  id="hospital"
                  value={profileData.hospital}
                  onChange={(e) => setProfileData({...profileData, hospital: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="experience">{t('profile.experience')}</Label>
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-slate-400" />
                <Input
                  id="experience"
                  value={profileData.experience}
                  onChange={(e) => setProfileData({...profileData, experience: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label>{t('profile.languages')}</Label>
              <div className="flex flex-wrap gap-2">
                {profileData.languages.map((lang, index) => (
                  <Badge key={index} variant="outline" className="gap-1">
                    <Globe className="h-3 w-3" />
                    {lang}
                  </Badge>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Education */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <GraduationCap className="h-5 w-5 text-blue-600" />
              {t('profile.education')}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {education.map((edu, index) => (
                <div key={index} className="flex gap-3 p-3 bg-slate-50 rounded-lg">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-100">
                    <GraduationCap className="h-5 w-5 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-slate-900 mb-1">{edu.degree}</p>
                    <p className="text-slate-600">{edu.institution}</p>
                    <p className="text-slate-500">{edu.year}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Certifications */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Award className="h-5 w-5 text-blue-600" />
              {t('profile.certifications')}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {certifications.map((cert, index) => (
                <div key={index} className="flex gap-3 p-3 bg-slate-50 rounded-lg">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-green-100">
                    <Award className="h-5 w-5 text-green-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-slate-900 mb-1">{cert.name}</p>
                    <p className="text-slate-600">{cert.issuer}</p>
                    <p className="text-slate-500">{cert.year}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
