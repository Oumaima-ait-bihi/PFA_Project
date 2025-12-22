# Guide de Test JMeter pour System Alert Clinique

## Prérequis

1. **JMeter** installé (version 5.5 ou supérieure)
   - Téléchargement : https://jmeter.apache.org/download_jmeter.cgi
   - Installation : Extraire l'archive et exécuter `bin/jmeter.bat` (Windows)

2. **Services démarrés** :
   - Backend Spring Boot (port 8082)
   - Service IA Python (port 5000)
   - Base de données PostgreSQL

## Structure des Tests JMeter

Les tests sont organisés dans le dossier `jmeter/` :

```
jmeter/
├── test-plan-alert-system.jmx    # Plan de test principal
├── scenarios/
│   ├── auth-scenario.jmx         # Tests d'authentification
│   ├── patient-scenario.jmx      # Tests CRUD patients
│   ├── ai-prediction-scenario.jmx # Tests prédictions IA
│   └── alerts-scenario.jmx       # Tests alertes
└── results/                      # Résultats des tests
```

## Endpoints à Tester

### 1. Authentification
- `POST /api/auth/login` - Connexion utilisateur

### 2. Patients
- `GET /api/patients` - Liste des patients
- `GET /api/patients/{id}` - Détails d'un patient
- `POST /api/patients` - Créer un patient
- `PUT /api/patients/{id}` - Modifier un patient
- `DELETE /api/patients/{id}` - Supprimer un patient

### 3. Médecins
- `GET /api/medecins` - Liste des médecins
- `GET /api/medecins/{id}` - Détails d'un médecin
- `POST /api/medecins` - Créer un médecin
- `PUT /api/medecins/{id}` - Modifier un médecin
- `DELETE /api/medecins/{id}` - Supprimer un médecin

### 4. Prédictions IA
- `GET /api/ai/health` - Vérifier le service IA
- `POST /api/ai/predict/simple` - Prédiction simplifiée
- `POST /api/ai/predict` - Prédiction complète

### 5. Alertes
- `GET /api/alertes` - Liste des alertes
- `GET /api/alertes/{id}` - Détails d'une alerte
- `POST /api/alertes` - Créer une alerte
- `DELETE /api/alertes/{id}` - Supprimer une alerte

## Exécution des Tests

### Option 1 : Interface Graphique JMeter

1. Ouvrir JMeter : `bin/jmeter.bat`
2. Ouvrir le fichier : `jmeter/test-plan-alert-system.jmx`
3. Configurer les variables :
   - `baseUrl` : `http://localhost:8082`
   - `aiServiceUrl` : `http://localhost:5000`
4. Exécuter le test (Ctrl+R)
5. Voir les résultats dans les listeners

### Option 2 : Ligne de Commande (Non-GUI)

```bash
cd jmeter
jmeter -n -t test-plan-alert-system.jmx -l results/test-results.jtl -e -o results/html-report
```

### Option 3 : Script Automatique

```bash
# Windows
EXECUTER_TESTS_JMETER.bat

# Linux/Mac
./executer_tests_jmeter.sh
```

## Métriques à Surveiller

- **Temps de réponse** : < 500ms pour les GET, < 1000ms pour les POST
- **Taux d'erreur** : < 1%
- **Throughput** : Nombre de requêtes par seconde
- **Latence** : Temps de réponse moyen

## Scénarios de Test

### Scénario 1 : Charge Normale
- 10 utilisateurs simultanés
- Durée : 5 minutes
- Ramp-up : 30 secondes

### Scénario 2 : Pic de Charge
- 50 utilisateurs simultanés
- Durée : 2 minutes
- Ramp-up : 10 secondes

### Scénario 3 : Stress Test
- 100 utilisateurs simultanés
- Durée : 10 minutes
- Ramp-up : 1 minute

## Analyse des Résultats

Les résultats sont générés dans `jmeter/results/` :
- `test-results.jtl` : Fichier CSV avec toutes les métriques
- `html-report/` : Rapport HTML interactif

## Dépannage

### Erreur de connexion
- Vérifier que le backend est démarré sur le port 8082
- Vérifier les paramètres de proxy dans JMeter

### Timeout
- Augmenter le timeout dans HTTP Request Defaults
- Vérifier la charge du serveur

### Erreurs 401/403
- Vérifier les tokens d'authentification
- Vérifier les permissions dans le backend

