# Exemples de Scénarios de Test JMeter

Ce document présente différents scénarios de test que vous pouvez exécuter avec le plan de test JMeter.

## 🎯 Scénario 1 : Test de Fonctionnalité (Smoke Test)

**Objectif** : Vérifier que tous les endpoints répondent correctement avec une charge minimale.

**Configuration** :
- Threads : 1
- Ramp-up : 1 seconde
- Loop Count : 1

**Commande** :
```bash
# Windows
run_tests.bat 1 1 1

# Linux/Mac
./run_tests.sh 1 1 1
```

**Résultat attendu** : Tous les tests doivent passer avec succès (100% de taux de succès).

---

## 🎯 Scénario 2 : Test de Charge Léger

**Objectif** : Tester le système avec une charge légère pour identifier les problèmes de performance basiques.

**Configuration** :
- Threads : 10
- Ramp-up : 10 secondes
- Loop Count : 1

**Commande** :
```bash
# Windows
run_tests.bat 10 10 1

# Linux/Mac
./run_tests.sh 10 10 1
```

**Métriques à surveiller** :
- Temps de réponse moyen < 500ms
- Taux de succès > 95%
- Pas d'erreurs 500 (erreurs serveur)

---

## 🎯 Scénario 3 : Test de Charge Moyen

**Objectif** : Simuler une utilisation normale du système avec plusieurs utilisateurs simultanés.

**Configuration** :
- Threads : 50
- Ramp-up : 30 secondes
- Loop Count : 5

**Commande** :
```bash
# Windows
run_tests.bat 50 30 5

# Linux/Mac
./run_tests.sh 50 30 5
```

**Métriques à surveiller** :
- Temps de réponse moyen < 1 seconde
- Taux de succès > 90%
- Débit (throughput) > 10 requêtes/seconde
- Pas d'erreurs de timeout

---

## 🎯 Scénario 4 : Test de Charge Intensif (Stress Test)

**Objectif** : Identifier les limites du système et les points de rupture.

**Configuration** :
- Threads : 100
- Ramp-up : 60 secondes
- Loop Count : 10

**Commande** :
```bash
# Windows
run_tests.bat 100 60 10

# Linux/Mac
./run_tests.sh 100 60 10
```

**Métriques à surveiller** :
- Point de saturation (où les temps de réponse augmentent significativement)
- Taux d'erreur acceptable (< 10%)
- Comportement de la base de données sous charge
- Utilisation des ressources serveur (CPU, mémoire)

---

## 🎯 Scénario 5 : Test d'Endurance (Soak Test)

**Objectif** : Vérifier la stabilité du système sur une période prolongée.

**Configuration** :
- Threads : 20
- Ramp-up : 10 secondes
- Loop Count : 100 (ou utiliser un scheduler JMeter pour une durée fixe)

**Commande** :
```bash
# Windows
run_tests.bat 20 10 100

# Linux/Mac
./run_tests.sh 20 10 100
```

**Métriques à surveiller** :
- Pas de fuites mémoire
- Stabilité des temps de réponse sur la durée
- Pas d'augmentation progressive des erreurs
- Performance de la base de données stable

---

## 🎯 Scénario 6 : Test de Pic (Spike Test)

**Objectif** : Tester la réaction du système à une augmentation soudaine de charge.

**Configuration** :
- Threads : 200
- Ramp-up : 5 secondes (montée rapide)
- Loop Count : 2

**Commande** :
```bash
# Windows
run_tests.bat 200 5 2

# Linux/Mac
./run_tests.sh 200 5 2
```

**Métriques à surveiller** :
- Capacité du système à gérer les pics
- Temps de récupération après le pic
- Gestion des erreurs pendant le pic

---

## 📊 Interprétation des Résultats

### Temps de Réponse Acceptables

| Endpoint | Temps Acceptable | Temps Critique |
|----------|------------------|----------------|
| GET /api/patients | < 200ms | > 1s |
| POST /api/patients | < 300ms | > 2s |
| GET /api/alertes | < 150ms | > 1s |
| POST /api/ai/predict | < 2s | > 5s |

### Codes de Statut HTTP

- **200 OK** : Succès
- **201 Created** : Ressource créée avec succès
- **400 Bad Request** : Données invalides
- **401 Unauthorized** : Authentification requise
- **404 Not Found** : Ressource non trouvée
- **500 Internal Server Error** : Erreur serveur (critique)

### Métriques Clés

1. **Response Time (Temps de réponse)** : Temps total de la requête
2. **Latency** : Temps avant la première réponse
3. **Throughput** : Nombre de requêtes par seconde
4. **Error Rate** : Pourcentage de requêtes en erreur
5. **Min/Max/Avg** : Statistiques sur les temps de réponse

---

## 🔧 Personnalisation des Scénarios

### Modifier le plan de test dans JMeter GUI

1. Ouvrir `plan_test_alert_clinique.jmx` dans JMeter
2. Sélectionner le **Thread Group**
3. Modifier :
   - Number of Threads (users)
   - Ramp-up period (seconds)
   - Loop Count

### Ajouter des timers

Pour simuler un comportement utilisateur plus réaliste, ajouter des timers :
- **Constant Timer** : Pause fixe entre les requêtes
- **Random Timer** : Pause aléatoire
- **Gaussian Random Timer** : Pause suivant une distribution normale

### Filtrer les endpoints testés

Pour tester seulement certains endpoints :
1. Désactiver les requêtes HTTP non désirées (clic droit → Disable)
2. Ou créer un nouveau Thread Group avec seulement les endpoints souhaités

---

## ⚠️ Recommandations

1. **Toujours commencer par un test léger** avant de passer à des tests plus intensifs
2. **Surveiller les ressources serveur** (CPU, mémoire, disque) pendant les tests
3. **Utiliser une base de données de test** séparée pour éviter d'affecter les données de production
4. **Documenter les résultats** pour comparer les performances au fil du temps
5. **Tester régulièrement** après chaque modification importante du code

---

## 📝 Exemple de Rapport

Après l'exécution, un rapport HTML est généré avec :
- Graphiques de temps de réponse
- Statistiques par endpoint
- Tableau des erreurs
- Graphiques de débit
- Distribution des temps de réponse

Ouvrir `results/html-report_YYYYMMDD_HHMMSS/index.html` dans un navigateur pour visualiser les résultats.

