# Guide de Démarrage des Services

## Configuration des Ports

- **Backend Spring Boot** : Port **8082** (configuré dans `application.properties`)
- **Service IA Python** : Port **5000** (Flask)
- **Frontend React Web** : Port **3000** (Vite/React)
- **Frontend Flutter Mobile** : Port dynamique selon la plateforme

## Ordre de Démarrage Recommandé

### 1. Démarrer le Service IA Python

```bash
cd AI\ai_service
start_ai_service.bat
```

Ou manuellement :
```bash
cd AI\ai_service
venv_ai\Scripts\activate
python app.py
```

**Vérification** : Ouvrir http://localhost:5000/health dans le navigateur
- Devrait retourner : `{"status": "ok"}`

### 2. Démarrer le Backend Spring Boot

```bash
cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
mvn spring-boot:run
```

**Vérification** : Ouvrir http://localhost:8082/api/patients dans le navigateur
- Devrait retourner une liste JSON de patients

**Note** : Si le port 8082 est occupé, vous pouvez :
- Arrêter le processus qui utilise le port avec `ARRETER_PORT_8080.bat`
- Ou changer le port dans `application.properties` (ligne 6 : `server.port=8082`)

### 3. Démarrer le Frontend React Web

```bash
cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert-clinique-front\alert-clinique-front
npm run dev
```

**Vérification** : Ouvrir http://localhost:3000 dans le navigateur

### 4. Démarrer l'Application Flutter Mobile

**Pour Web (Chrome/Edge)** :
```bash
cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert-clinique-front\alert-clinique-front\alert_clinique_mobile
flutter run -d chrome
```

**Pour Windows Desktop** :
```bash
flutter run -d windows
```

## Script de Démarrage Automatique

Vous pouvez utiliser le script `DEMARRER_PROJET.bat` à la racine du projet pour démarrer tous les services automatiquement.

## Vérification de l'État des Services

### Service IA (Port 5000)
```bash
curl http://localhost:5000/health
```

### Backend Spring Boot (Port 8082)
```bash
curl http://localhost:8082/api/patients
```

## Résolution des Problèmes Courants

### Erreur : "Port 8082 was already in use"
- Solution : Utiliser `ARRETER_PORT_8080.bat` ou changer le port dans `application.properties`

### Erreur : "Failed to fetch, uri=http://localhost:8080/api/..."
- Cause : L'application Flutter essaie de se connecter au mauvais port
- Solution : Vérifier que `api_service.dart` utilise le port 8082 (déjà corrigé)

### Erreur : "ModuleNotFoundError: No module named 'src'"
- Cause : L'environnement virtuel Python n'est pas activé
- Solution : Utiliser `start_ai_service.bat` qui active automatiquement l'environnement virtuel

### Erreur : "Service IA indisponible" dans le dashboard
- Vérifier que le service IA Python est démarré sur le port 5000
- Vérifier que le backend Spring Boot peut communiquer avec le service IA
- Vérifier les logs du backend Spring Boot pour les erreurs de connexion

## Configuration des URLs dans le Code

### Flutter Mobile (`api_service.dart`)
- `baseUrl` : `http://localhost:8082/api` (port 8082)
- `aiServiceUrl` : `http://localhost:5000` (port 5000)

### Backend Spring Boot (`application.properties`)
- `server.port=8082`

### Service IA Python (`app.py`)
- Port par défaut : 5000 (configuré dans Flask)

## Notes Importantes

1. **Ordre de démarrage** : Toujours démarrer le service IA avant le backend Spring Boot
2. **Ports** : Assurez-vous qu'aucun autre service n'utilise les ports 5000, 8082, ou 3000
3. **Base de données** : PostgreSQL doit être démarré et accessible sur le port 5433
4. **Environnement virtuel** : Le service IA doit utiliser l'environnement virtuel `venv_ai`

