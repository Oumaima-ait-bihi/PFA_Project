# Tests JMeter - System Alert Clinique

## Structure

```
jmeter/
├── test-plan-alert-system.jmx    # Plan de test principal
└── results/                       # Dossier pour les résultats (créé automatiquement)
    ├── test-results-*.jtl        # Fichiers de résultats CSV
    └── html-report/              # Rapports HTML générés
```

## Utilisation Rapide

### 1. Préparer l'environnement

Assurez-vous que tous les services sont démarrés :
- Backend Spring Boot : `http://localhost:8082`
- Service IA Python : `http://localhost:5000`
- Base de données PostgreSQL

### 2. Exécuter les tests

**Option A : Script automatique (Windows)**
```bash
EXECUTER_TESTS_JMETER.bat
```

**Option B : Ligne de commande**
```bash
cd jmeter
jmeter -n -t test-plan-alert-system.jmx -l results/test-results.jtl -e -o results/html-report
```

**Option C : Interface graphique**
1. Ouvrir JMeter : `bin/jmeter.bat`
2. Ouvrir : `jmeter/test-plan-alert-system.jmx`
3. Exécuter (Ctrl+R)

## Scénarios de Test

### 1. Authentification
- Test de connexion patient/médecin
- 5 utilisateurs simultanés
- 1 itération par utilisateur

### 2. Patients CRUD
- GET /api/patients (liste)
- POST /api/patients (création)
- 10 utilisateurs simultanés
- 3 itérations par utilisateur

### 3. Prédictions IA
- GET /api/ai/health (vérification)
- POST /api/ai/predict/simple (prédiction)
- 20 utilisateurs simultanés
- 5 itérations par utilisateur
- Données aléatoires pour chaque requête

## Métriques Collectées

- **Temps de réponse** : Temps total de la requête
- **Latence** : Temps jusqu'à la première réponse
- **Throughput** : Requêtes par seconde
- **Taux d'erreur** : Pourcentage de requêtes échouées
- **Codes de statut** : Distribution des codes HTTP

## Analyse des Résultats

### Rapport HTML
Ouvrir `results/html-report/index.html` dans un navigateur pour voir :
- Graphiques de performance
- Statistiques détaillées
- Répartition des erreurs
- Temps de réponse par endpoint

### Fichier JTL
Le fichier `.jtl` contient toutes les métriques au format CSV :
- Ouvrir avec Excel ou un éditeur de texte
- Analyser avec des outils de visualisation

## Personnalisation

### Modifier le nombre d'utilisateurs
Dans JMeter, ouvrir le Thread Group et modifier :
- **Number of Threads** : Nombre d'utilisateurs simultanés
- **Ramp-up Period** : Temps pour démarrer tous les utilisateurs

### Ajouter de nouveaux endpoints
1. Clic droit sur le Thread Group
2. Add > Sampler > HTTP Request
3. Configurer l'URL et la méthode
4. Ajouter les paramètres nécessaires

### Variables personnalisées
Les variables suivantes sont disponibles :
- `${baseUrl}` : URL du backend (http://localhost:8082)
- `${aiServiceUrl}` : URL du service IA (http://localhost:5000)
- `${__threadNum}` : Numéro du thread (utilisateur)
- `${__Random(min,max)}` : Nombre aléatoire entre min et max

## Dépannage

### Erreur "Connection refused"
- Vérifier que le backend est démarré
- Vérifier le port (8082 par défaut)

### Timeout
- Augmenter le timeout dans "HTTP Request Defaults"
- Vérifier la charge du serveur

### Erreurs 401/403
- Vérifier l'authentification
- Vérifier les tokens dans les headers

