# Alert Clinique Mobile

Application mobile Flutter pour le portail patient et médecin.

## Fonctionnalités

- 🔐 **Authentification** : Connexion pour patients et médecins
- 📊 **Tableau de bord patient** : Suivi de l'humeur, sommeil et rythme cardiaque avec graphiques
- ⚕️ **Tableau de bord médecin** : Vue d'ensemble des patients et alertes
- 🚨 **Centre d'alertes** : Gestion des alertes médicales avec filtres et statistiques
- 🌍 **Multilingue** : Support français et arabe avec interface RTL
- 📱 **Design moderne** : Interface utilisateur adaptée aux mobiles

## Prérequis

- Flutter SDK (version 3.9.2 ou supérieure)
- Dart SDK
- Un émulateur iOS/Android ou un appareil physique

## Installation

1. Installer les dépendances :
```bash
flutter pub get
```

2. Vérifier que tout fonctionne :
```bash
flutter doctor
```

## Exécution

Pour lancer l'application :

```bash
flutter run
```

Pour une version release :
```bash
flutter build apk  # Android
flutter build ios  # iOS
```

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── user.dart
│   ├── alert.dart
│   └── patient.dart
├── providers/                # Gestion d'état (Provider)
│   ├── auth_provider.dart
│   └── language_provider.dart
├── screens/                  # Écrans de l'application
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── patient_dashboard_screen.dart
│   ├── doctor_dashboard_screen.dart
│   └── alert_center_screen.dart
└── widgets/                  # Widgets réutilisables
```

## Identifiants de démo

- Email : `patient@demo.com`
- Mot de passe : `demo123`

Vous pouvez vous connecter en tant que patient ou médecin en sélectionnant le rôle approprié sur l'écran de connexion.

## Technologies utilisées

- **Flutter** : Framework de développement mobile
- **Provider** : Gestion d'état
- **fl_chart** : Graphiques et visualisations
- **Material Design 3** : Design system

## Notes

- L'application utilise des données de démonstration (mock data)
- L'authentification est simulée pour les besoins de la démo
- Les graphiques utilisent des données statiques pour l'illustration

## Support

Pour toute question ou problème, veuillez consulter la documentation Flutter : https://docs.flutter.dev/
