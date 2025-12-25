# Documentation : Tests de Performance avec JMeter

## 📋 Vue d'ensemble

**JMeter** est un outil open-source utilisé pour tester les performances des applications web. Dans ce projet, nous avons utilisé JMeter pour tester les performances de l'API du système d'alerte clinique.

## 🎯 Objectif des tests

L'objectif est de vérifier que l'API peut gérer plusieurs requêtes simultanées sans ralentir ou planter. Cela permet de s'assurer que le système fonctionnera correctement même avec plusieurs utilisateurs connectés en même temps.

## 📁 Fichiers créés

### 1. Plan de test (`plan_test_alert_clinique.jmx`)
C'est le fichier principal qui contient tous les tests à exécuter. Il définit :
- **Quelles requêtes** tester (authentification, récupération de patients, prédictions IA, etc.)
- **Combien d'utilisateurs** simultanés simuler
- **Combien de fois** répéter chaque test
- **Comment** mesurer les performances

### 2. Scripts d'exécution
- `LANCER_TEST_JMETER.bat` : Lance les tests en mode automatique (sans interface graphique)
- `LANCER_TEST_JMETER_GUI.bat` : Ouvre JMeter avec l'interface graphique pour voir les tests en temps réel

## 🔧 Configuration des tests

### Paramètres principaux

1. **Thread Group (Groupe de threads)**
   - **Nombre d'utilisateurs** : 10 utilisateurs simultanés
   - **Temps de montée** : 10 secondes (les utilisateurs se connectent progressivement)
   - **Nombre de boucles** : 1 fois par utilisateur

2. **Requêtes testées**
   - Authentification (login)
   - Récupération de la liste des patients
   - Récupération d'un patient par ID
   - Création d'un patient
   - Récupération des alertes
   - Prédiction IA
   - Et d'autres endpoints de l'API

3. **Listeners (Écouteurs)**
   - **View Results Tree** : Affiche chaque requête en détail
   - **Summary Report** : Statistiques globales
   - **Aggregate Report** : Statistiques par endpoint

## 📊 Résultats des tests

### Métriques mesurées

1. **Temps de réponse** : Temps que prend l'API pour répondre
   - Bon : < 200ms
   - Acceptable : 200-500ms
   - Lent : > 500ms

2. **Throughput** : Nombre de requêtes traitées par seconde
   - Plus c'est élevé, mieux c'est

3. **Taux d'erreur** : Pourcentage de requêtes qui échouent
   - Idéal : 0%
   - Acceptable : < 1%

4. **Latence** : Temps entre l'envoi de la requête et le début de la réponse

### Où voir les résultats

1. **Dans JMeter (interface graphique)**
   - Ouvrez les listeners en bas de l'arbre
   - Les résultats s'affichent en temps réel pendant l'exécution

2. **Rapport HTML**
   - Généré automatiquement après les tests
   - Emplacement : `jmeter/results/html-report_*/index.html`
   - Contient des graphiques et statistiques détaillées

3. **Fichier JTL**
   - Format CSV avec toutes les métriques
   - Emplacement : `jmeter/results/results_*.jtl`
   - Peut être ouvert avec Excel pour analyse

## 🚀 Comment utiliser

### Option 1 : Mode automatique (recommandé)

```bash
# Double-cliquez sur :
LANCER_TEST_JMETER.bat
```

Le script :
1. Vérifie que JMeter est installé
2. Lance les tests automatiquement
3. Génère un rapport HTML
4. Ouvre le rapport dans le navigateur

### Option 2 : Mode interface graphique

```bash
# Double-cliquez sur :
LANCER_TEST_JMETER_GUI.bat
```

Puis dans JMeter :
1. Cliquez sur "Summary Report" ou "Aggregate Report"
2. Cliquez sur le bouton RUN (▶️ vert)
3. Observez les résultats en temps réel

## ⚙️ Configuration technique

### Ports utilisés
- **Backend Spring Boot** : `http://localhost:8082`
- **Service IA Python** : `http://localhost:5000`

### Prérequis
- Backend Spring Boot doit être démarré
- Service IA Python doit être démarré
- JMeter doit être installé

## 📈 Interprétation des résultats

### Exemple de résultats normaux

```
Summary Report:
- Samples: 150 (nombre total de requêtes)
- Average: 150ms (temps de réponse moyen)
- Min: 50ms (temps minimum)
- Max: 500ms (temps maximum)
- Error %: 0.00% (aucune erreur)
- Throughput: 15.0/sec (15 requêtes par seconde)
```

### Signification

- ✅ **Tous les tests passent** : Le système fonctionne correctement
- ✅ **Temps de réponse < 500ms** : L'API est rapide
- ✅ **Taux d'erreur = 0%** : Aucun problème détecté
- ⚠️ **Temps de réponse > 1000ms** : L'API est lente, optimisation nécessaire
- ❌ **Taux d'erreur > 5%** : Problème à corriger

## 🔍 Problèmes résolus

### 1. Erreur "java.net.URISyntaxException"
**Problème** : Les URLs étaient mal configurées dans JMeter
**Solution** : Ajout d'un "HTTP Request Defaults" avec le serveur et le port corrects

### 2. Erreur "Problem updating GUI"
**Problème** : Trop de données affichées en temps réel
**Solution** : Désactivation du "View Results Tree" par défaut, utilisation du mode non-GUI pour les tests de charge

### 3. Tests vides (0 threads)
**Problème** : Variables non résolues dans le Thread Group
**Solution** : Remplacement des variables par des valeurs directes

## 📝 Conclusion

Les tests JMeter permettent de :
- ✅ Vérifier que l'API supporte plusieurs utilisateurs simultanés
- ✅ Identifier les endpoints lents
- ✅ Détecter les erreurs potentielles
- ✅ Mesurer les performances du système

Ces tests sont essentiels pour garantir que le système fonctionnera correctement en production avec de vrais utilisateurs.

