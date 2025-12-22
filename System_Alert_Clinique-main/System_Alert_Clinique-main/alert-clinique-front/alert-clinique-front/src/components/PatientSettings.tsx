import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from './ui/card';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Switch } from './ui/switch';
import { Separator } from './ui/separator';
import { useLanguage } from '../contexts/LanguageContext';
import { toast } from 'sonner';
import { 
  Bell, 
  Lock, 
  Globe, 
  Eye, 
  Shield,
  Smartphone,
  Mail,
  Volume2,
  Moon,
  Palette,
  Download,
  Trash2
} from 'lucide-react';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select';

export function PatientSettings() {
  const { t, language, setLanguage } = useLanguage();
  const [settings, setSettings] = useState({
    emailNotifications: true,
    pushNotifications: true,
    smsNotifications: false,
    appointmentReminders: true,
    medicationReminders: true,
    healthTips: true,
    soundEnabled: true,
    darkMode: false,
    dataSharing: false,
    twoFactorAuth: false,
  });

  const handleToggle = (key: keyof typeof settings) => {
    setSettings(prev => ({ ...prev, [key]: !prev[key] }));
    toast.success('Paramètre mis à jour');
  };

  const handlePasswordChange = () => {
    toast.info('Fonction de changement de mot de passe - À implémenter');
  };

  const handleExportData = () => {
    toast.success('Export des données en cours...');
  };

  const handleDeleteAccount = () => {
    toast.error('Fonction de suppression de compte - À implémenter');
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-white mb-2">{t('sidebar.settings')}</h2>
        <p className="text-slate-600">Gérez vos préférences et paramètres de confidentialité</p>
      </div>

      {/* Notifications */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Bell className="h-5 w-5 text-blue-600" />
            Notifications
          </CardTitle>
          <CardDescription>
            Configurez comment vous souhaitez recevoir les notifications
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Mail className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Notifications par email</Label>
                <p className="text-slate-600">Recevoir les notifications importantes par email</p>
              </div>
            </div>
            <Switch
              checked={settings.emailNotifications}
              onCheckedChange={() => handleToggle('emailNotifications')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Smartphone className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Notifications push</Label>
                <p className="text-slate-600">Recevoir les notifications sur votre appareil</p>
              </div>
            </div>
            <Switch
              checked={settings.pushNotifications}
              onCheckedChange={() => handleToggle('pushNotifications')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Smartphone className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Notifications SMS</Label>
                <p className="text-slate-600">Recevoir les alertes urgentes par SMS</p>
              </div>
            </div>
            <Switch
              checked={settings.smsNotifications}
              onCheckedChange={() => handleToggle('smsNotifications')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Bell className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Rappels de rendez-vous</Label>
                <p className="text-slate-600">Être notifié avant vos rendez-vous</p>
              </div>
            </div>
            <Switch
              checked={settings.appointmentReminders}
              onCheckedChange={() => handleToggle('appointmentReminders')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Bell className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Rappels de médicaments</Label>
                <p className="text-slate-600">Rappels pour prendre vos médicaments</p>
              </div>
            </div>
            <Switch
              checked={settings.medicationReminders}
              onCheckedChange={() => handleToggle('medicationReminders')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Bell className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Conseils santé</Label>
                <p className="text-slate-600">Recevoir des conseils de santé personnalisés</p>
              </div>
            </div>
            <Switch
              checked={settings.healthTips}
              onCheckedChange={() => handleToggle('healthTips')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Language & Display */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Globe className="h-5 w-5 text-blue-600" />
            Langue et affichage
          </CardTitle>
          <CardDescription>
            Personnalisez l'apparence de votre interface
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="language">Langue</Label>
            <Select value={language} onValueChange={(v: 'fr' | 'ar') => setLanguage(v)}>
              <SelectTrigger id="language">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="fr">🇫🇷 Français</SelectItem>
                <SelectItem value="ar">🇸🇦 العربية</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Moon className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Mode sombre</Label>
                <p className="text-slate-600">Activer le thème sombre</p>
              </div>
            </div>
            <Switch
              checked={settings.darkMode}
              onCheckedChange={() => handleToggle('darkMode')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Volume2 className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Son activé</Label>
                <p className="text-slate-600">Activer les sons de notification</p>
              </div>
            </div>
            <Switch
              checked={settings.soundEnabled}
              onCheckedChange={() => handleToggle('soundEnabled')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Security & Privacy */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Shield className="h-5 w-5 text-blue-600" />
            Sécurité et confidentialité
          </CardTitle>
          <CardDescription>
            Gérez vos paramètres de sécurité et de confidentialité
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-2">
            <Label>Changer le mot de passe</Label>
            <div className="flex gap-2">
              <Input type="password" placeholder="Nouveau mot de passe" />
              <Button onClick={handlePasswordChange}>
                <Lock className="mr-2 h-4 w-4" />
                Changer
              </Button>
            </div>
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Shield className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Authentification à deux facteurs</Label>
                <p className="text-slate-600">Sécurisez votre compte avec 2FA</p>
              </div>
            </div>
            <Switch
              checked={settings.twoFactorAuth}
              onCheckedChange={() => handleToggle('twoFactorAuth')}
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Eye className="h-5 w-5 text-slate-400" />
              <div>
                <Label>Partage de données</Label>
                <p className="text-slate-600">Partager vos données pour la recherche médicale</p>
              </div>
            </div>
            <Switch
              checked={settings.dataSharing}
              onCheckedChange={() => handleToggle('dataSharing')}
            />
          </div>
        </CardContent>
      </Card>

      {/* Data Management */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Download className="h-5 w-5 text-blue-600" />
            Gestion des données
          </CardTitle>
          <CardDescription>
            Exportez ou supprimez vos données personnelles
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-blue-50 rounded-lg">
            <div>
              <Label>Exporter mes données</Label>
              <p className="text-slate-600">Téléchargez une copie de vos données médicales</p>
            </div>
            <Button variant="outline" onClick={handleExportData}>
              <Download className="mr-2 h-4 w-4" />
              Exporter
            </Button>
          </div>

          <div className="flex items-center justify-between p-4 bg-red-50 rounded-lg border border-red-200">
            <div>
              <Label className="text-red-800">Supprimer mon compte</Label>
              <p className="text-red-600">Cette action est irréversible</p>
            </div>
            <Button variant="destructive" onClick={handleDeleteAccount}>
              <Trash2 className="mr-2 h-4 w-4" />
              Supprimer
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
