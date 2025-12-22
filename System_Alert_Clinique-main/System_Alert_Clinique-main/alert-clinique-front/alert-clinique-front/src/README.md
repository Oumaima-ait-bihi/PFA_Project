# Portail Médical - Application Complète

## 🎯 Vue d'ensemble

Application web de portail médical avec des dashboards séparés pour les **patients** et les **médecins**, incluant des graphiques de suivi, un système d'alertes interactif, et une gestion complète des profils et paramètres.

## ✨ Fonctionnalités Principales

### 🔐 Authentification
- **Login** : Connexion avec tabs Patient/Médecin
- **Signup** : Inscription avec validation
- **Logout** : Déconnexion avec confirmation
- Identifiants de démo fournis

### 👤 Mode Patient

#### Dashboard Patient
- 📊 Graphiques de suivi (Humeur, Sommeil, Rythme cardiaque)
- 📈 Visualisations avec Recharts
- 💡 Recommandations personnalisées
- 🎨 Design responsive et moderne

#### Profil Patient
- 👨‍⚕️ Informations personnelles éditables
- 🩺 Informations médicales (groupe sanguin, taille, poids, IMC)
- 🏥 Allergies et contacts d'urgence
- 💊 Liste des médicaments actuels
- 📋 Historique médical

#### Paramètres Patient
- 🔔 Notifications (Email, Push, SMS)
- 🌍 Langue et affichage (FR/AR avec RTL)
- 🔒 Sécurité (2FA, changement de mot de passe)
- 📥 Gestion des données (Export/Suppression)

### ⚕️ Mode Médecin

#### Dashboard Médecin
- 📊 Statistiques générales (Patients, Cas critiques)
- ⚠️ Patients à risque élevé
- 🚨 Alertes récentes
- 📈 Visualisations médicales

#### Centre d'Alertes
- 🎨 **Statistiques en temps réel** : Critiques, Risque élevé, En attente, Résolues
- 🔍 **Recherche** : Par nom de patient
- 🔽 **Filtres avancés** : Par gravité (critique, élevé, moyen, faible) et statut
- 🎯 **Système de couleurs codées** :
  - 🔴 Rouge = Critique
  - 🟠 Orange = Élevé
  - 🟡 Jaune = Moyen
  - 🟢 Vert = Faible
- ⚡ **Actions interactives** :
  - 👁️ Accuser réception
  - ✅ Résoudre
  - 👥 Assigner

#### Liste des Patients
- 🔍 **Recherche** : Par nom ou ID patient
- 🔽 **Filtres** : Par statut (critique, risque élevé, stable)
- 📊 **Vue en grille** : Cartes détaillées avec avatar
- 📱 **Actions rapides** :
  - 📞 Contacter
  - 👁️ Voir détails
- 📈 **Statistiques** : Nombre de patients par statut
- 📥 Export de la liste

#### Profil Médecin
- 👨‍⚕️ Informations personnelles et professionnelles
- 🏥 Spécialité, licence, établissement
- 📊 Statistiques (Patients suivis, Expérience, Consultations)
- 🎓 Formation et diplômes
- 🏆 Certifications professionnelles
- 🌍 Langues parlées

#### Notifications
- 📬 **Panel coulissant** avec toutes les notifications
- 🔔 **Types** : Alertes, Rendez-vous, Messages, Nouveaux patients
- ✅ Marquer tout comme lu
- 🗑️ Supprimer individuellement
- 🔢 Badge avec compte des notifications non lues

## 🌍 Internationalisation

### Langues Supportées
- 🇫🇷 **Français** (par défaut)
- 🇸🇦 **Arabe** avec support RTL complet

### Traductions Complètes
- ✅ Interface utilisateur
- ✅ Tous les composants
- ✅ Messages et notifications
- ✅ Formulaires et validations

## 🎨 Design System

### Couleurs de Gravité
- 🔴 **Critique** : Rouge (bg-red-100, text-red-800)
- 🟠 **Élevé** : Orange (bg-orange-100, text-orange-800)
- 🟡 **Moyen** : Jaune (bg-yellow-100, text-yellow-800)
- 🟢 **Faible** : Vert (bg-green-100, text-green-800)

### Composants
- 🎨 **shadcn/ui** : Components UI modernes
- 📊 **Recharts** : Graphiques interactifs
- 🔔 **Sonner** : Toast notifications
- 🎭 **Lucide React** : Icônes

## 📱 Responsive Design

- ✅ Mobile-first
- ✅ Tablette optimisé
- ✅ Desktop complet
- ✅ Grilles adaptatives

## 🔧 Structure du Projet

```
/
├── App.tsx                          # Point d'entrée principal
├── components/
│   ├── AlertCenter.tsx              # Centre d'alertes médecin
│   ├── DoctorDashboard.tsx          # Dashboard médecin
│   ├── DoctorProfile.tsx            # Profil médecin
│   ├── Header.tsx                   # En-tête avec langue & notifs
│   ├── Login.tsx                    # Page de connexion
│   ├── NotificationsPanel.tsx       # Panel de notifications
│   ├── PatientDashboard.tsx         # Dashboard patient
│   ├── PatientProfile.tsx           # Profil patient
│   ├── PatientSettings.tsx          # Paramètres patient
│   ├── PatientsList.tsx             # Liste des patients
│   ├── Sidebar.tsx                  # Navigation latérale
│   └── Signup.tsx                   # Page d'inscription
├── contexts/
│   ├── AuthContext.tsx              # Gestion authentification
│   └── LanguageContext.tsx          # Gestion i18n
└── styles/
    └── globals.css                  # Styles globaux

```

## 🚀 Démarrage Rapide

### Identifiants de Démo

**Patient:**
- 📧 Email: `patient@demo.com`
- 🔒 Mot de passe: `demo123`

**Médecin:**
- 📧 Email: `doctor@demo.com`
- 🔒 Mot de passe: `demo123`

### Navigation

1. **Se connecter** avec les identifiants de démo
2. **Basculer** entre Mode Patient et Mode Médecin (boutons en haut)
3. **Changer la langue** via le sélecteur dans le header
4. **Explorer** toutes les fonctionnalités via la sidebar

## 📊 Données de Démonstration

L'application utilise des données simulées pour :
- ✅ 8 patients avec différents statuts
- ✅ 8 alertes avec différentes gravités
- ✅ 6 notifications de différents types
- ✅ Graphiques de santé avec données hebdomadaires

## 🎯 Fonctionnalités Clés Implémentées

### Mode Patient ✅
- [x] Dashboard avec graphiques
- [x] Profil complet et éditable
- [x] Paramètres avec notifications
- [x] Informations médicales
- [x] Historique et médicaments

### Mode Médecin ✅
- [x] Dashboard avec statistiques
- [x] Centre d'alertes complet
- [x] Liste des patients
- [x] Profil professionnel
- [x] Panel de notifications

### Système Global ✅
- [x] Authentification complète
- [x] Internationalisation FR/AR
- [x] Support RTL pour l'arabe
- [x] Design responsive
- [x] Toast notifications
- [x] Système de couleurs codées

## 🔮 Prochaines Étapes Suggérées

1. **Backend Integration** : Connecter à une vraie API
2. **Messagerie** : Chat entre médecins et patients
3. **Calendrier** : Gestion des rendez-vous
4. **Rapports** : Génération de rapports PDF
5. **Télémédecine** : Visioconférence intégrée

---

**Développé avec ❤️ pour un portail médical moderne et accessible**
