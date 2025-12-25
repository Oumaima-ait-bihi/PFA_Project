# Où Voir les Résultats des Tests JMeter

## 📍 Emplacements des Résultats

### 1. Dans JMeter (Interface Graphique)

Quand vous exécutez les tests dans JMeter, les résultats s'affichent dans les **Listeners** :

#### a) View Results Tree
- **Emplacement** : Panneau de droite dans JMeter
- **Contenu** : 
  - Détails de chaque requête
  - Réponse complète
  - Temps de réponse
  - Codes de statut
- **Utilisation** : Développement et débogage

#### b) Summary Report
- **Emplacement** : En bas de la liste des listeners
- **Contenu** :
  - Statistiques globales
  - Temps de réponse moyen/min/max
  - Throughput (requêtes/seconde)
  - Taux d'erreur
- **Utilisation** : Vue d'ensemble rapide

#### c) Aggregate Report
- **Emplacement** : En bas de la liste des listeners
- **Contenu** :
  - Statistiques par endpoint
  - Temps de réponse par requête
  - Pourcentiles (50%, 90%, 95%, 99%)
- **Utilisation** : Analyse détaillée

### 2. Fichiers de Résultats Sauvegardés

#### a) Fichier JTL (CSV)
- **Emplacement** : `jmeter/results/results_*.jtl`
- **Format** : CSV avec toutes les métriques
- **Exemple** : `jmeter/results/results_20251222_150923.jtl`
- **Contenu** :
  - Timestamp
  - Label (nom de la requête)
  - Response Code
  - Response Message
  - Thread Name
  - Data Type
  - Success (true/false)
  - Bytes
  - Latency
  - Connect Time
  - etc.

#### b) Rapport HTML
- **Emplacement** : `jmeter/results/html-report/` ou `jmeter/results/html-report_*/`
- **Fichier principal** : `index.html`
- **Contenu** :
  - Graphiques interactifs
  - Statistiques détaillées
  - Répartition des erreurs
  - Temps de réponse par endpoint
  - Métriques de performance

## 🔍 Comment Voir les Résultats

### Option 1 : Dans JMeter (Temps Réel)

1. **Ouvrir JMeter** avec votre plan de test
2. **Exécuter les tests** (bouton ▶ ou Ctrl+R)
3. **Observer les résultats** dans les listeners :
   - **View Results Tree** : Voir chaque requête individuellement
   - **Summary Report** : Vue d'ensemble
   - **Aggregate Report** : Statistiques détaillées

### Option 2 : Fichier JTL (CSV)

1. **Localiser le fichier** :
   ```
   jmeter/results/results_YYYYMMDD_HHMMSS.jtl
   ```

2. **Ouvrir avec** :
   - Excel / LibreOffice Calc
   - Éditeur de texte
   - Outils d'analyse de données

3. **Colonnes importantes** :
   - `timeStamp` : Date et heure
   - `label` : Nom de la requête
   - `responseCode` : Code HTTP (200, 400, 500, etc.)
   - `responseMessage` : Message de réponse
   - `success` : true/false
   - `elapsed` : Temps de réponse (ms)
   - `latency` : Latence (ms)
   - `bytes` : Taille de la réponse

### Option 3 : Rapport HTML (Recommandé)

1. **Générer le rapport** (si pas déjà fait) :
   ```bash
   cd jmeter
   jmeter -g results/results_*.jtl -o results/html-report
   ```

2. **Ouvrir le rapport** :
   - Naviguer vers : `jmeter/results/html-report/index.html`
   - Double-cliquer sur `index.html` pour ouvrir dans le navigateur

3. **Sections du rapport** :
   - **Dashboard** : Vue d'ensemble avec graphiques
   - **Statistics** : Statistiques par requête
   - **Charts** : Graphiques de performance
   - **Errors** : Détails des erreurs

## 📊 Métriques Importantes

### Temps de Réponse
- **Moyen** : Temps moyen de toutes les requêtes
- **Min** : Temps le plus rapide
- **Max** : Temps le plus lent
- **Médian (50%)** : 50% des requêtes sont plus rapides
- **90ème percentile** : 90% des requêtes sont plus rapides

### Throughput
- **Requêtes/seconde** : Nombre de requêtes traitées par seconde
- **Plus élevé = mieux** : Indique la capacité du serveur

### Taux d'Erreur
- **Pourcentage** : % de requêtes échouées
- **Objectif** : < 1%

### Codes de Statut
- **200** : Succès
- **400** : Erreur client (Bad Request)
- **401** : Non autorisé
- **403** : Interdit
- **404** : Non trouvé
- **500** : Erreur serveur

## 🚀 Commandes Utiles

### Générer un rapport HTML depuis un fichier JTL existant
```bash
cd jmeter
jmeter -g results/results_20251222_150923.jtl -o results/html-report
```

### Voir les résultats dans la console
```bash
cd jmeter
type results\results_*.jtl | findstr /C:"POST" /C:"GET"
```

### Filtrer les erreurs
```bash
cd jmeter
type results\results_*.jtl | findstr /C:"false"
```

## 📝 Exemple de Lecture des Résultats

### Dans Summary Report (JMeter)
```
Label              | Samples | Average | Min | Max | Error % | Throughput
-------------------|---------|---------|-----|-----|---------|------------
GET /api/patients  | 100     | 45ms    | 20  | 120 | 0%      | 22.5/sec
POST /api/patients| 50      | 120ms   | 80  | 250 | 2%      | 10.2/sec
```

### Dans le Fichier JTL
```csv
timeStamp,elapsed,label,responseCode,responseMessage,success,bytes,latency
1703256000000,45,GET /api/patients,200,OK,true,1234,30
1703256000050,120,POST /api/patients,201,Created,true,567,100
```

## 🎯 Prochaines Étapes

1. **Analyser les temps de réponse** : Identifier les endpoints lents
2. **Vérifier les erreurs** : Corriger les problèmes identifiés
3. **Optimiser** : Améliorer les performances des endpoints lents
4. **Comparer** : Exécuter plusieurs tests et comparer les résultats

