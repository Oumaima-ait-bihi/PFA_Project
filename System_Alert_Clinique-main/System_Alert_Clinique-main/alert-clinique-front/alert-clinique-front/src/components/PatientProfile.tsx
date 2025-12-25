import { useState, useRef } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Avatar, AvatarFallback, AvatarImage } from './ui/avatar';
import { Badge } from './ui/badge';
import { useLanguage } from '../contexts/LanguageContext';
import { useAuth } from '../contexts/AuthContext';
import { toast } from 'sonner';
import { 
  User, 
  Mail, 
  Phone, 
  Calendar, 
  MapPin, 
  Heart, 
  Activity,
  Pill,
  FileText,
  Edit,
  Save,
  Camera,
  X
} from 'lucide-react';

export function PatientProfile() {
  const { t } = useLanguage();
  const { user } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [profileData, setProfileData] = useState({
    name: user?.name || 'Jean Dupont',
    email: user?.email || 'jean.dupont@email.com',
    phone: '+33 6 12 34 56 78',
    dateOfBirth: '15/05/1978',
    address: '123 Rue de la Santé, 75013 Paris',
    bloodType: 'A+',
    height: '175 cm',
    weight: '72 kg',
    emergencyContact: 'Marie Dupont - +33 6 98 76 54 32',
  });
  const [profileImage, setProfileImage] = useState<string | null>(null);
  const [isCameraOpen, setIsCameraOpen] = useState(false);
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const streamRef = useRef<MediaStream | null>(null);

  const handleSave = () => {
    setIsEditing(false);
    toast.success('Profil mis à jour avec succès');
  };

  const openCamera = async () => {
    try {
      // Vérifier si getUserMedia est disponible
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        toast.error('Votre navigateur ne supporte pas l\'accès à la caméra. Utilisez Chrome, Firefox ou Edge.');
        return;
      }

      // Demander l'accès à la caméra
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { 
          facingMode: 'user', // Caméra frontale
          width: { ideal: 1280 },
          height: { ideal: 720 }
        }
      });
      
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        streamRef.current = stream;
        setIsCameraOpen(true);
      }
    } catch (error: any) {
      console.error('Erreur caméra:', error);
      
      let errorMessage = 'Impossible d\'accéder à la caméra.';
      
      if (error.name === 'NotAllowedError' || error.name === 'PermissionDeniedError') {
        errorMessage = 'Permission refusée. Veuillez autoriser l\'accès à la caméra dans les paramètres de votre navigateur.';
      } else if (error.name === 'NotFoundError' || error.name === 'DevicesNotFoundError') {
        errorMessage = 'Aucune caméra trouvée. Vérifiez que votre caméra est connectée.';
      } else if (error.name === 'NotReadableError' || error.name === 'TrackStartError') {
        errorMessage = 'La caméra est déjà utilisée par une autre application.';
      } else if (error.name === 'OverconstrainedError' || error.name === 'ConstraintNotSatisfiedError') {
        errorMessage = 'Les paramètres de la caméra ne sont pas supportés.';
      }
      
      toast.error(errorMessage);
    }
  };

  const capturePhoto = () => {
    if (videoRef.current && canvasRef.current) {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      const context = canvas.getContext('2d');

      if (context) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0);

        const imageData = canvas.toDataURL('image/png');
        setProfileImage(imageData);
        closeCamera();
        toast.success('Photo capturée avec succès !');
      }
    }
  };

  const closeCamera = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    setIsCameraOpen(false);
  };

  const removePhoto = () => {
    setProfileImage(null);
    toast.success('Photo supprimée');
  };

  const medicalHistory = [
    { date: '2024-01', condition: 'Consultation générale', doctor: 'Dr. Hasna Ait Ben Brahim' },
    { date: '2023-09', condition: 'Vaccination grippe', doctor: 'Dr. Martin' },
    { date: '2023-03', condition: 'Bilan sanguin', doctor: 'Dr. Hasna Ait Ben Brahim' },
  ];

  const medications = [
    { name: 'Lisinopril', dosage: '10mg', frequency: '1x par jour', startDate: 'Jan 2023' },
    { name: 'Metformine', dosage: '500mg', frequency: '2x par jour', startDate: 'Mar 2023' },
  ];

  const allergies = ['Pénicilline', 'Pollen'];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-white mb-2">{t('sidebar.profile')}</h2>
          <p className="text-slate-600">Gérez vos informations personnelles et médicales</p>
        </div>
        <Button
          onClick={() => isEditing ? handleSave() : setIsEditing(true)}
          className="gap-2"
        >
          {isEditing ? (
            <>
              <Save className="h-4 w-4" />
              Enregistrer
            </>
          ) : (
            <>
              <Edit className="h-4 w-4" />
              Modifier
            </>
          )}
        </Button>
      </div>

      {/* Profile Header */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex flex-col items-center gap-4 md:flex-row md:items-start">
            <div className="relative">
              <Avatar className="h-24 w-24">
                {profileImage ? (
                  <AvatarImage src={profileImage} alt="Photo de profil" />
                ) : null}
                <AvatarFallback className="bg-blue-600 text-white text-2xl">
                  {profileData.name.split(' ').map(n => n[0]).join('')}
                </AvatarFallback>
              </Avatar>
              <Button
                size="sm"
                className="absolute -bottom-2 -right-2 h-8 w-8 rounded-full p-0"
                onClick={isCameraOpen ? closeCamera : openCamera}
              >
                {isCameraOpen ? (
                  <X className="h-4 w-4" />
                ) : (
                  <Camera className="h-4 w-4" />
                )}
              </Button>
              {profileImage && !isCameraOpen && (
                <Button
                  size="sm"
                  variant="destructive"
                  className="absolute -top-2 -right-2 h-6 w-6 rounded-full p-0"
                  onClick={removePhoto}
                >
                  <X className="h-3 w-3" />
                </Button>
              )}
            </div>
            <div className="flex-1 text-center md:text-left">
              <h3 className="text-white mb-2">{profileData.name}</h3>
              <div className="flex flex-wrap gap-2 justify-center md:justify-start">
                <Badge className="bg-blue-100 text-blue-800">Patient</Badge>
                <Badge className="bg-green-100 text-green-800">Actif</Badge>
              </div>
              <p className="text-slate-600 mt-2">Membre depuis Janvier 2023</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Camera Modal */}
      {isCameraOpen && (
        <div 
          className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-75"
          onClick={(e) => {
            // Fermer si on clique en dehors du modal
            if (e.target === e.currentTarget) {
              closeCamera();
            }
          }}
        >
          <div className="bg-white rounded-lg p-6 max-w-2xl w-full mx-4" onClick={(e) => e.stopPropagation()}>
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold">Capturez une photo de votre visage</h3>
              <Button variant="ghost" size="sm" onClick={closeCamera}>
                <X className="h-5 w-5" />
              </Button>
            </div>
            <div className="relative bg-black rounded-lg overflow-hidden" style={{ minHeight: '400px' }}>
              <video
                ref={videoRef}
                autoPlay
                playsInline
                muted
                className="w-full h-auto max-h-[500px]"
                style={{ transform: 'scaleX(-1)' }} // Miroir pour la caméra frontale
              />
              <canvas ref={canvasRef} className="hidden" />
            </div>
            <div className="flex gap-4 mt-4 justify-end">
              <Button variant="outline" onClick={closeCamera}>
                Annuler
              </Button>
              <Button onClick={capturePhoto} className="gap-2">
                <Camera className="h-4 w-4" />
                Capturer
              </Button>
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Personal Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-5 w-5 text-blue-600" />
              Informations personnelles
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
              <Label htmlFor="dob">Date de naissance</Label>
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-slate-400" />
                <Input
                  id="dob"
                  value={profileData.dateOfBirth}
                  onChange={(e) => setProfileData({...profileData, dateOfBirth: e.target.value})}
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
          </CardContent>
        </Card>

        {/* Medical Information */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Heart className="h-5 w-5 text-red-600" />
              Informations médicales
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Groupe sanguin</Label>
                <div className="flex items-center gap-2 p-3 bg-slate-50 rounded-lg">
                  <Activity className="h-4 w-4 text-red-600" />
                  <span className="text-slate-900">{profileData.bloodType}</span>
                </div>
              </div>

              <div className="space-y-2">
                <Label>Taille</Label>
                <div className="flex items-center gap-2 p-3 bg-slate-50 rounded-lg">
                  <span className="text-slate-900">{profileData.height}</span>
                </div>
              </div>

              <div className="space-y-2">
                <Label>Poids</Label>
                <div className="flex items-center gap-2 p-3 bg-slate-50 rounded-lg">
                  <span className="text-slate-900">{profileData.weight}</span>
                </div>
              </div>

              <div className="space-y-2">
                <Label>IMC</Label>
                <div className="flex items-center gap-2 p-3 bg-green-50 rounded-lg">
                  <span className="text-green-800">23.5</span>
                </div>
              </div>
            </div>

            <div className="space-y-2">
              <Label>Allergies</Label>
              <div className="flex flex-wrap gap-2">
                {allergies.map((allergy, index) => (
                  <Badge key={index} variant="outline" className="bg-red-50 text-red-800 border-red-200">
                    {allergy}
                  </Badge>
                ))}
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="emergency">Contact d'urgence</Label>
              <div className="flex items-center gap-2">
                <Phone className="h-4 w-4 text-slate-400" />
                <Input
                  id="emergency"
                  value={profileData.emergencyContact}
                  onChange={(e) => setProfileData({...profileData, emergencyContact: e.target.value})}
                  disabled={!isEditing}
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Medications */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Pill className="h-5 w-5 text-purple-600" />
              Médicaments actuels
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {medications.map((med, index) => (
                <div key={index} className="flex items-start gap-3 p-3 bg-slate-50 rounded-lg">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-purple-100">
                    <Pill className="h-5 w-5 text-purple-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-slate-900 mb-1">{med.name}</p>
                    <p className="text-slate-600">{med.dosage} - {med.frequency}</p>
                    <p className="text-slate-500">Depuis {med.startDate}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Medical History */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileText className="h-5 w-5 text-blue-600" />
              Historique médical
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {medicalHistory.map((record, index) => (
                <div key={index} className="flex items-start gap-3 p-3 bg-slate-50 rounded-lg">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-100">
                    <FileText className="h-5 w-5 text-blue-600" />
                  </div>
                  <div className="flex-1">
                    <p className="text-slate-900 mb-1">{record.condition}</p>
                    <p className="text-slate-600">{record.doctor}</p>
                    <p className="text-slate-500">{record.date}</p>
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
