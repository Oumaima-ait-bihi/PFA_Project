# Guide de Tests JMeter pour System Alert Clinique

Ce dossier contient les fichiers de test de performance et de charge pour les APIs du backend Spring Boot.

## 📋 Prérequis

1. **Apache JMeter** installé (version 5.5 ou supérieure)
   - Téléchargement : https://jmeter.apache.org/download_jmeter.cgi
   - Installation : Extraire l'archive et ajouter le dossier `bin` au PATH

2. **Backend Spring Boot** en cours d'exécution
   - URL par défaut : `http://localhost:8080`
   - Vérifier que le serveur est démarré avant de lancer les tests

3. **Base de données PostgreSQL** configurée avec des données de test

## 📁 Structure des fichiers

```
jmeter/
├── README_JMETER.md              # Ce fichier
├── plan_test_alert_clinique.jmx  # Plan de test JMeter principal
├── data/
│   ├── users.csv                 # Données utilisateurs pour authentification
│   ├── patients.csv              # Données patients pour tests CRUD
│   └── medecins.csv              # Données médecins pour tests CRUD
└── results/                      # Dossier pour les résultats (créé automatiquement)
```

## 🚀 Utilisation

### 1. Ouvrir le plan de test dans JMeter

```bash
# Windows
jmeter.bat -t plan_test_alert_clinique.jmx

# Linux/Mac
jmeter -t plan_test_alert_clinique.jmx
```

Ou ouvrir JMeter en mode GUI :
```bash
jmeter.bat  # Windows
jmeter      # Linux/Mac
```
Puis : File → Open → Sélectionner `plan_test_alert_clinique.jmx`

### 2. Configurer les variables

Dans JMeter, ouvrir le **Test Plan** et modifier les variables :
- `BASE_URL` : URL du backend (par défaut : `http://localhost:8080`)
- `THREADS` : Nombre d'utilisateurs virtuels (par défaut : 10)
- `RAMP_UP` : Temps de montée en charge en secondes (par défaut : 10)
- `LOOP_COUNT` : Nombre d'itérations par utilisateur (par défaut : 1)

### 3. Lancer les tests

#### Mode GUI (pour développement)
1. Cliquer sur le bouton **▶** (Run)
2. Observer les résultats en temps réel dans les listeners

#### Mode non-GUI (pour tests de charge)
```bash
# Windows
jmeter.bat -n -t plan_test_alert_clinique.jmx -l results/results.jtl -e -o results/html-report

# Linux/Mac
jmeter -n -t plan_test_alert_clinique.jmx -l results/results.jtl -e -o results/html-report
```

Options :
- `-n` : Mode non-GUI
- `-t` : Fichier de test
- `-l` : Fichier de résultats (.jtl)
- `-e` : Générer un rapport HTML
- `-o` : Dossier de sortie du rapport HTML

### 4. Consulter les résultats

Les résultats sont disponibles dans :
- **Fichier JTL** : `results/results.jtl` (format CSV)
- **Rapport HTML** : `results/html-report/index.html` (ouvrir dans un navigateur)

## 📊 Scénarios de test inclus

Le plan de test inclut les scénarios suivants :

### 1. **Authentification** (`/api/auth/login`)
- Test de connexion patient
- Test de connexion médecin
- Test avec identifiants invalides

### 2. **Gestion des Patients** (`/api/patients`)
- GET : Liste de tous les patients
- GET : Détails d'un patient par ID
- POST : Création d'un nouveau patient
- PUT : Mise à jour d'un patient
- DELETE : Suppression d'un patient

### 3. **Gestion des Médecins** (`/api/medecins`)
- GET : Liste de tous les médecins
- GET : Détails d'un médecin par ID
- POST : Création d'un nouveau médecin
- PUT : Mise à jour d'un médecin
- DELETE : Suppression d'un médecin

### 4. **Gestion des Alertes** (`/api/alertes`)
- GET : Liste de toutes les alertes
- GET : Détail d'une alerte par ID
- POST : Création d'une nouvelle alerte
- DELETE : Suppression d'une alerte

### 5. **Historique des Alertes** (`/api/historiqueAlertes`)
- GET : Liste de tous les historiques
- GET : Détail d'un historique par ID
- POST : Création d'un historique
- DELETE : Suppression d'un historique

### 6. **Données Cliniques**
- **Humeur** (`/api/humeurs`) : GET, POST, DELETE
- **Qualité du sommeil** (`/api/sommeils`) : GET, POST, DELETE
- **Rythme cardiaque** (`/api/rythmes`) : GET, POST, DELETE

### 7. **Service IA** (`/api/ai`)
- GET : Health check du service IA
- POST : Prédiction complète
- POST : Prédiction simplifiée

## ⚙️ Configuration des tests de charge

### Test de charge léger
- Threads : 10
- Ramp-up : 10 secondes
- Loop : 1

### Test de charge moyen
- Threads : 50
- Ramp-up : 30 secondes
- Loop : 5

### Test de charge intensif
- Threads : 100
- Ramp-up : 60 secondes
- Loop : 10

## 📈 Métriques surveillées

Les listeners JMeter collectent :
- **Temps de réponse** (Response Time)
- **Taux de succès/échec** (Success Rate)
- **Débit** (Throughput) : requêtes par seconde
- **Erreurs** : codes HTTP d'erreur
- **Latence** : temps avant la première réponse

## 🔧 Personnalisation

### Ajouter de nouveaux endpoints

1. Dans JMeter, cliquer droit sur le Thread Group
2. Ajouter → Sampler → HTTP Request
3. Configurer :
   - Server Name : `${BASE_URL}`
   - Method : GET/POST/PUT/DELETE
   - Path : `/api/votre-endpoint`
   - Body Data (si POST/PUT) : JSON

### Modifier les données de test

Éditer les fichiers CSV dans le dossier `data/` :
- `users.csv` : Identifiants pour authentification
- `patients.csv` : Données de patients
- `medecins.csv` : Données de médecins

## ⚠️ Notes importantes

1. **Base de données** : Les tests DELETE suppriment réellement des données. Utiliser une base de test dédiée.

2. **Service IA** : Le service IA doit être démarré séparément pour tester les endpoints `/api/ai/*`

3. **CORS** : Le backend autorise toutes les origines (`*`), donc pas de problème de CORS pour les tests.

4. **Sécurité** : Actuellement, tous les endpoints sont en `permitAll()`. Si l'authentification JWT est activée, il faudra :
   - Extraire le token de la réponse `/api/auth/login`
   - Ajouter un Header Manager avec `Authorization: Bearer ${token}`

## 🐛 Dépannage

### Erreur "Connection refused"
- Vérifier que le backend Spring Boot est démarré
- Vérifier l'URL dans la variable `BASE_URL`

### Erreur 404
- Vérifier que les endpoints existent dans le backend
- Vérifier le chemin dans la requête HTTP

### Erreur 500
- Vérifier les logs du backend
- Vérifier que la base de données est accessible
- Vérifier le format des données JSON envoyées

## 📚 Ressources

- Documentation JMeter : https://jmeter.apache.org/usermanual/
- Guide Spring Boot Testing : https://spring.io/guides/gs/testing-web/

