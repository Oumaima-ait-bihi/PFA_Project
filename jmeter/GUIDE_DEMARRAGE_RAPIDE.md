# 🚀 Guide de Démarrage Rapide - Tests JMeter

Guide étape par étape pour tester vos APIs avec JMeter.

## ✅ Étape 1 : Vérifier les Prérequis

### 1.1 Vérifier que Java est installé
```bash
java -version
```
Vous devez voir une version Java 8 ou supérieure. Si ce n'est pas le cas, installez Java.

### 1.2 Vérifier que JMeter est installé
```bash
# Windows
jmeter.bat -v

# Linux/Mac
jmeter -v
```

Si JMeter n'est pas installé :
1. Télécharger `apache-jmeter-5.6.3.zip` depuis https://jmeter.apache.org/download_jmeter.cgi
2. Extraire l'archive
3. Ajouter le dossier `bin` au PATH, ou utiliser le chemin complet

### 1.3 Démarrer le Backend Spring Boot
Assurez-vous que votre backend est en cours d'exécution sur `http://localhost:8080`

```bash
# Depuis le dossier du backend
cd System_Alert_Clinique-main/System_Alert_Clinique-main/alert_clinique_back_end/alert-system
mvn spring-boot:run
```

Vérifier que le serveur répond :
- Ouvrir un navigateur : http://localhost:8080/api/patients
- Ou utiliser curl : `curl http://localhost:8080/api/patients`

---

## 🎯 Étape 2 : Premier Test (Mode GUI - Recommandé pour débuter)

### 2.1 Ouvrir JMeter en mode GUI

**Windows** :
```bash
# Si JMeter est dans le PATH
jmeter.bat

# Sinon, utiliser le chemin complet
C:\apache-jmeter-5.6.3\bin\jmeter.bat
```

**Linux/Mac** :
```bash
jmeter
```

### 2.2 Ouvrir le plan de test

1. Dans JMeter : **File** → **Open**
2. Naviguer vers le dossier `jmeter` de votre projet
3. Sélectionner `plan_test_alert_clinique.jmx`
4. Cliquer sur **Open**

### 2.3 Vérifier la configuration

1. Dans l'arborescence à gauche, cliquer sur **Test Plan**
2. Vérifier les variables dans **User Defined Variables** :
   - `BASE_URL` : `http://localhost:8080`
   - `THREADS` : `10` (nombre d'utilisateurs virtuels)
   - `RAMP_UP` : `10` (secondes pour démarrer tous les threads)
   - `LOOP_COUNT` : `1` (nombre d'itérations)

### 2.4 Lancer le test

1. Cliquer sur le bouton **▶** (Run) dans la barre d'outils
   - Ou utiliser le raccourci : **Ctrl+R** (Windows) / **Cmd+R** (Mac)
2. Observer les résultats en temps réel dans les listeners :
   - **View Results Tree** : Détails de chaque requête
   - **Summary Report** : Statistiques globales
   - **Aggregate Report** : Rapport agrégé

### 2.5 Arrêter le test

- Cliquer sur le bouton **⏹** (Stop) pour arrêter immédiatement
- Ou attendre la fin naturelle du test

---

## ⚡ Étape 3 : Test en Mode Non-GUI (Pour tests de charge)

### 3.1 Utiliser le script automatique (Recommandé)

**Windows** :
```bash
cd jmeter
run_tests.bat
```

**Linux/Mac** :
```bash
cd jmeter
chmod +x run_tests.sh
./run_tests.sh
```

### 3.2 Personnaliser les paramètres

```bash
# Syntaxe : run_tests.bat [threads] [ramp_up] [loop_count]

# Exemple : 10 utilisateurs, montée en 10 secondes, 1 itération
run_tests.bat 10 10 1

# Exemple : 50 utilisateurs, montée en 30 secondes, 5 itérations
run_tests.bat 50 30 5
```

### 3.3 Lancer manuellement (sans script)

**Windows** :
```bash
cd jmeter
jmeter.bat -n -t plan_test_alert_clinique.jmx -l results/results.jtl -e -o results/html-report
```

**Linux/Mac** :
```bash
cd jmeter
jmeter -n -t plan_test_alert_clinique.jmx -l results/results.jtl -e -o results/html-report
```

Options :
- `-n` : Mode non-GUI
- `-t` : Fichier de test
- `-l` : Fichier de résultats (.jtl)
- `-e` : Générer un rapport HTML
- `-o` : Dossier de sortie du rapport

---

## 📊 Étape 4 : Consulter les Résultats

### 4.1 Dans JMeter GUI

Pendant l'exécution, vous pouvez voir :
- **View Results Tree** : Détails de chaque requête (réponse, temps, code HTTP)
- **Summary Report** : Tableau avec statistiques par endpoint
- **Aggregate Report** : Statistiques détaillées (min, max, moyenne, médiane)

### 4.2 Rapport HTML (Mode non-GUI)

Après l'exécution en mode non-GUI :
1. Naviguer vers `jmeter/results/html-report/`
2. Ouvrir `index.html` dans un navigateur
3. Consulter :
   - **Dashboard** : Vue d'ensemble avec graphiques
   - **Statistics** : Statistiques par endpoint
   - **Errors** : Liste des erreurs
   - **Charts** : Graphiques de performance

---

## 🔍 Étape 5 : Interpréter les Résultats

### Métriques importantes

1. **Response Time (Temps de réponse)**
   - Acceptable : < 500ms pour les GET
   - Acceptable : < 1s pour les POST
   - Critique : > 2s

2. **Throughput (Débit)**
   - Nombre de requêtes par seconde
   - Plus élevé = meilleur

3. **Error Rate (Taux d'erreur)**
   - Acceptable : < 1%
   - Critique : > 5%

4. **Codes HTTP**
   - **200** : Succès ✅
   - **201** : Créé avec succès ✅
   - **400** : Requête invalide ⚠️
   - **404** : Non trouvé ⚠️
   - **500** : Erreur serveur ❌

### Exemple de résultats attendus

```
Label                          # Samples  Average  Min    Max    Error %  Throughput
1. Auth - Login Patient         10        45ms     32ms   78ms   0%       22.2/sec
2. GET - Liste Patients          10        120ms    89ms   234ms  0%       8.3/sec
3. GET - Patient par ID          10        95ms     67ms   156ms  0%       10.5/sec
4. POST - Créer Patient          10        180ms    134ms  289ms  0%       5.6/sec
```

---

## 🐛 Dépannage

### Problème : "Connection refused"
**Solution** : Vérifier que le backend Spring Boot est démarré
```bash
curl http://localhost:8080/api/patients
```

### Problème : "JMeter not found"
**Solution** : Utiliser le chemin complet vers jmeter.bat
```bash
C:\apache-jmeter-5.6.3\bin\jmeter.bat -t plan_test_alert_clinique.jmx
```

### Problème : Erreurs 404
**Solution** : Vérifier que l'URL dans BASE_URL est correcte
- Ouvrir le plan de test dans JMeter
- Vérifier la variable BASE_URL dans Test Plan → User Defined Variables

### Problème : Erreurs 500
**Solution** : 
1. Vérifier les logs du backend Spring Boot
2. Vérifier que la base de données est accessible
3. Vérifier le format JSON des requêtes POST

### Problème : Tests trop lents
**Solution** :
- Réduire le nombre de threads
- Réduire le loop count
- Vérifier les performances du serveur backend

---

## 📝 Exemples de Tests

### Test rapide (1 utilisateur, 1 itération)
```bash
# Dans JMeter GUI :
# - THREADS = 1
# - RAMP_UP = 1
# - LOOP_COUNT = 1
# Cliquer sur Run
```

### Test de charge léger (10 utilisateurs)
```bash
# Windows
run_tests.bat 10 10 1

# Linux/Mac
./run_tests.sh 10 10 1
```

### Test de charge moyen (50 utilisateurs)
```bash
run_tests.bat 50 30 5
```

---

## 🎓 Prochaines Étapes

1. **Modifier les données de test** : Éditer les fichiers CSV dans `data/`
2. **Ajouter des assertions** : Vérifier automatiquement les réponses
3. **Ajouter des timers** : Simuler un comportement utilisateur plus réaliste
4. **Créer des scénarios personnalisés** : Tester des workflows spécifiques

Consultez `EXEMPLES_SCENARIOS.md` pour plus d'exemples de scénarios de test.

---

## 💡 Astuces

- **Commencez toujours par un test léger** avant de faire des tests de charge
- **Surveillez les ressources serveur** (CPU, mémoire) pendant les tests
- **Sauvegardez vos résultats** pour comparer les performances
- **Testez régulièrement** après chaque modification importante

Bon test ! 🚀

