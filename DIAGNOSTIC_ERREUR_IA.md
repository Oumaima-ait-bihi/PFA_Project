# Diagnostic de l'Erreur "Erreur lors de la prédiction IA"

## Erreur Observée
```
Erreur de prédiction IA: Exception: Erreur de connexion au service IA: 
Exception: Erreur lors de la prédiction IA
```

## Étapes de Diagnostic

### 1. Vérifier que le Service IA Python est démarré

**Test direct du service IA** :
```bash
curl http://localhost:5000/health
```

**Résultat attendu** :
```json
{"status": "ok"}
```

**Si le service n'est pas accessible** :
```bash
cd AI\ai_service
start_ai_service.bat
```

### 2. Vérifier que le Backend Spring Boot peut communiquer avec le Service IA

**Test via le backend** :
```bash
curl http://localhost:8082/api/ai/health
```

**Résultat attendu** :
```json
{"available":true,"message":"Service IA disponible"}
```

**Si `"available": false`** :
- Le backend ne peut pas communiquer avec le service IA
- Vérifier que le service IA est démarré sur le port 5000
- Vérifier la configuration dans `application.properties` : `ai.service.url=http://localhost:5000`

### 3. Tester une Prédiction Directe

**Test direct du service IA Python** :
```bash
curl -X POST http://localhost:5000/predict ^
  -H "Content-Type: application/json" ^
  -d "{\"patient_id\":1,\"heart_rate\":72.0,\"hr_variability\":50.0,\"steps\":5000,\"mood_score\":5.0,\"sleep_duration_hours\":7.0,\"sleep_efficiency\":85.0,\"num_awakenings\":1,\"age\":45,\"day_of_week\":0,\"weekend\":false,\"medication_taken\":false,\"is_female\":false,\"date\":\"2025-12-22\"}"
```

**Test via le backend Spring Boot** :
```bash
curl -X POST http://localhost:8082/api/ai/predict/simple ^
  -H "Content-Type: application/json" ^
  -d "{\"patientId\":1,\"heartRate\":72.0,\"sleepDurationHours\":7.0,\"moodScore\":5.0,\"age\":45}"
```

### 4. Vérifier les Logs

**Logs du Service IA Python** :
- Regarder la console où `python app.py` est exécuté
- Vérifier les erreurs Python (ModuleNotFoundError, AttributeError, etc.)

**Logs du Backend Spring Boot** :
- Regarder la console où `mvn spring-boot:run` est exécuté
- Vérifier les erreurs de connexion ou de parsing JSON

## Causes Courantes

### 1. Service IA Python non démarré
**Symptôme** : `curl http://localhost:5000/health` échoue
**Solution** : Démarrer le service IA avec `start_ai_service.bat`

### 2. Module Python manquant
**Symptôme** : Erreur `ModuleNotFoundError` dans les logs du service IA
**Solution** : 
```bash
cd AI\ai_service
venv_ai\Scripts\activate
pip install -r requirements.txt
```

### 3. Modèle IA non chargé
**Symptôme** : Erreur lors du chargement du modèle dans les logs
**Solution** : Vérifier que le fichier `artifacts/supervised_pipeline.joblib` existe

### 4. Format de données incorrect
**Symptôme** : Erreur 400 (Bad Request) du service IA
**Solution** : Vérifier que tous les champs requis sont présents dans la requête

### 5. Version scikit-learn incompatible
**Symptôme** : Erreur `AttributeError` lors du chargement du modèle
**Solution** : Utiliser Python 3.12 avec scikit-learn 1.3.2 (voir `SETUP_PYTHON312.bat`)

## Script de Diagnostic Complet

Utilisez le script `VERIFIER_SERVICES.bat` pour un diagnostic automatique :

```bash
VERIFIER_SERVICES.bat
```

## Solutions par Ordre de Priorité

1. **Démarrer le Service IA Python**
   ```bash
   cd AI\ai_service
   start_ai_service.bat
   ```

2. **Vérifier la santé du service IA**
   ```bash
   curl http://localhost:5000/health
   ```

3. **Vérifier la communication Backend → Service IA**
   ```bash
   curl http://localhost:8082/api/ai/health
   ```

4. **Redémarrer le Backend Spring Boot** (si nécessaire)
   ```bash
   cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
   mvn spring-boot:run
   ```

5. **Redémarrer l'Application Flutter** (si nécessaire)
   ```bash
   # Arrêter (Ctrl+C) puis relancer
   flutter run -d chrome
   ```

## Vérification Finale

Une fois tous les services démarrés, testez dans l'ordre :

1. ✅ Service IA : http://localhost:5000/health
2. ✅ Backend Health : http://localhost:8082/api/ai/health
3. ✅ Prédiction Simple : http://localhost:8082/api/ai/predict/simple (via l'application Flutter)

Si toutes ces vérifications passent, l'erreur devrait être résolue.

