# Configuration API pour l'application mobile

## 📱 Configuration de l'URL de l'API

L'application mobile Flutter doit se connecter au backend Spring Boot. L'URL dépend de votre environnement :

### Pour Android Emulator
Utilisez `10.0.2.2` qui est l'alias spécial pour `localhost` de la machine hôte :
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

### Pour iOS Simulator
Utilisez `localhost` directement :
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### Pour un appareil physique (Android/iOS)
Vous devez utiliser l'IP locale de votre machine sur le réseau WiFi :
1. Trouvez l'IP de votre machine :
   - Windows : `ipconfig` dans CMD
   - Mac/Linux : `ifconfig` ou `ip addr`
2. Remplacez dans `api_service.dart` :
```dart
static const String baseUrl = 'http://192.168.1.XXX:8080/api'; // Remplacez XXX par votre IP
```

## 🔧 Fichier à modifier

Le fichier à modifier se trouve dans :
```
lib/services/api_service.dart
```

Ligne 6-8, décommentez la ligne appropriée selon votre environnement.

## ✅ Vérification

1. Assurez-vous que le backend Spring Boot est démarré sur le port 8080
2. Vérifiez que PostgreSQL est accessible
3. Testez la connexion depuis l'application mobile

## 🚨 Dépannage

### Erreur "Failed to fetch" ou "Erreur de connexion"

#### 1. Vérifier que le backend est démarré
```bash
# Dans le dossier du backend
cd alert_clinique_back_end/alert-system
mvnw spring-boot:run
# ou
./mvnw spring-boot:run
```

Le backend doit afficher quelque chose comme :
```
Started AlertsystemApplication in X.XXX seconds
```

#### 2. Tester l'API depuis votre navigateur
Ouvrez votre navigateur et allez à :
- **Pour Android emulator** : `http://localhost:8080/api/patients` (depuis votre machine)
- Vous devriez voir une réponse JSON (même vide `[]`)

#### 3. Vérifier l'URL dans api_service.dart
Ouvrez `lib/services/api_service.dart` et vérifiez la ligne 10 :
- **Android emulator** : `http://10.0.2.2:8080/api` ✅ (déjà configuré)
- **iOS simulator** : `http://localhost:8080/api` (décommentez cette ligne)
- **Appareil physique** : `http://VOTRE_IP:8080/api` (remplacez VOTRE_IP)

#### 4. Vérifier le port du backend
Le backend doit tourner sur le port **8080**. Vérifiez dans `application.properties` :
```properties
server.port=8080
```

#### 5. Vérifier le firewall
Assurez-vous que le port 8080 n'est pas bloqué par le firewall Windows.

#### 6. Redémarrer l'application Flutter
```bash
# Arrêtez l'app (Ctrl+C)
# Puis relancez
flutter run
```

### Erreur CORS
- Le backend a été configuré pour autoriser les requêtes depuis les emulators
- Si vous utilisez un appareil physique, vous devrez peut-être ajouter votre IP dans `CorsConfig.java`

### Erreur "Timeout"
- Le backend met trop de temps à répondre
- Vérifiez que PostgreSQL est démarré et accessible
- Vérifiez les logs du backend pour voir s'il y a des erreurs

