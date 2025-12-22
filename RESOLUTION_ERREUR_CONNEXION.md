# Résolution de l'Erreur de Connexion au Service IA

## Erreur Observée
```
Erreur de prédiction IA: Exception: Erreur de connexion au service IA: 
ClientException: Failed to fetch, uri=http://localhost:8082/api/ai/predict/simple
```

## Causes Possibles

### 1. Backend Spring Boot non démarré
Le backend Spring Boot doit être démarré sur le port **8082** pour que l'application Flutter puisse s'y connecter.

**Solution** :
```bash
cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
mvn spring-boot:run
```

**Vérification** : Ouvrir http://localhost:8082/api/ai/health dans le navigateur
- Devrait retourner : `{"available":true,"message":"Service IA disponible"}`

### 2. Service IA Python non démarré
Le service IA Python doit être démarré sur le port **5000** pour que le backend Spring Boot puisse communiquer avec lui.

**Solution** :
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

### 3. Backend ne peut pas communiquer avec le service IA
Même si les deux services sont démarrés, le backend Spring Boot doit pouvoir communiquer avec le service IA Python.

**Vérification** :
1. Vérifier que le service IA est accessible : http://localhost:5000/health
2. Vérifier que le backend peut y accéder : http://localhost:8082/api/ai/health
   - Si `"available": false`, le backend ne peut pas communiquer avec le service IA

**Solution** :
- Vérifier que le service IA Python est bien démarré
- Vérifier qu'aucun firewall ne bloque les connexions locales
- Vérifier la configuration dans `application.properties` : `ai.service.url=http://localhost:5000`

## Script de Vérification Automatique

Utilisez le script `VERIFIER_SERVICES.bat` pour vérifier automatiquement l'état de tous les services :

```bash
VERIFIER_SERVICES.bat
```

Ce script vérifie :
1. ✅ Service IA Python (port 5000)
2. ✅ Backend Spring Boot (port 8082)
3. ✅ Communication entre les deux services

## Ordre de Démarrage Correct

1. **Démarrer le Service IA Python** (port 5000)
   ```bash
   cd AI\ai_service
   start_ai_service.bat
   ```

2. **Démarrer le Backend Spring Boot** (port 8082)
   ```bash
   cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
   mvn spring-boot:run
   ```

3. **Démarrer l'Application Flutter**
   ```bash
   cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert-clinique-front\alert-clinique-front\alert_clinique_mobile
   flutter run -d chrome
   ```

## Vérifications Manuelles

### Vérifier le Service IA
```bash
curl http://localhost:5000/health
```
Résultat attendu : `{"status": "ok"}`

### Vérifier le Backend Spring Boot
```bash
curl http://localhost:8082/api/ai/health
```
Résultat attendu : `{"available":true,"message":"Service IA disponible"}`

### Vérifier l'Endpoint de Prédiction
```bash
curl -X POST http://localhost:8082/api/ai/predict/simple ^
  -H "Content-Type: application/json" ^
  -d "{\"patientId\":1,\"heartRate\":72.0,\"sleepDurationHours\":7.0,\"moodScore\":5.0,\"age\":45}"
```

## Configuration des Ports

- **Service IA Python** : Port **5000** (configuré dans `app.py`)
- **Backend Spring Boot** : Port **8082** (configuré dans `application.properties`, ligne 6)
- **Frontend Flutter** : Utilise `http://localhost:8082/api` (configuré dans `api_service.dart`)

## Notes Importantes

1. **Ordre de démarrage** : Toujours démarrer le service IA **avant** le backend Spring Boot
2. **Ports** : Assurez-vous qu'aucun autre service n'utilise les ports 5000 ou 8082
3. **Base de données** : PostgreSQL doit être démarré et accessible sur le port 5433
4. **Environnement virtuel** : Le service IA doit utiliser l'environnement virtuel `venv_ai`

## Si le Problème Persiste

1. Vérifier les logs du backend Spring Boot pour voir les erreurs de connexion
2. Vérifier les logs du service IA Python pour voir les requêtes reçues
3. Vérifier que tous les services sont démarrés avec `VERIFIER_SERVICES.bat`
4. Redémarrer tous les services dans l'ordre correct

