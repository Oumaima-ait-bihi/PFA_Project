# Guide : Résolution des Tests JMeter Vides

## 🔍 Diagnostic

Si vous avez lancé les tests mais les listeners sont vides, voici les causes possibles :

### 1. Services non démarrés

**Vérification rapide :**
```bash
DIAGNOSTIC_TESTS_VIDES.bat
```

**Ou manuellement :**
- Service IA Python : http://localhost:5000/health
- Backend Spring Boot : http://localhost:8082/api/ai/health

### 2. Variables non résolues

Le Thread Group utilise des variables `${THREADS}`, `${RAMP_UP}`, `${LOOP_COUNT}`.

**Vérification dans JMeter :**
1. Cliquez sur "Plan de Test - Alert Clinique" (racine)
2. Dans le panneau de droite, vérifiez "Variables utilisateur"
3. Les valeurs doivent être :
   - `THREADS = 10`
   - `RAMP_UP = 10`
   - `LOOP_COUNT = 1`

**Si les variables sont vides :**
- Les tests ne s'exécuteront pas
- Solution : Rechargez le plan de test ou définissez les valeurs manuellement

### 3. Thread Group désactivé

**Vérification :**
1. Cliquez sur "Thread Group - Tests API"
2. Vérifiez que la case "enabled" est cochée en bas du panneau
3. Si elle n'est pas cochée, cochez-la

### 4. Requêtes en erreur

**Vérification :**
1. Cliquez sur "View Results Tree"
2. Lancez les tests
3. Si les requêtes sont en **rouge**, il y a une erreur
4. Cliquez sur une requête rouge pour voir l'erreur

**Erreurs courantes :**
- `Connection refused` → Backend non démarré
- `404 Not Found` → Endpoint incorrect
- `500 Internal Server Error` → Erreur backend

### 5. Tests trop rapides

Si les tests se terminent instantanément :
- Les threads peuvent se terminer avant d'exécuter les requêtes
- Vérifiez les logs JMeter (en bas de la fenêtre)

## ✅ Solution étape par étape

### Étape 1 : Vérifier les services

```bash
DIAGNOSTIC_TESTS_VIDES.bat
```

Si un service n'est pas démarré :
- **Service IA** : `cd AI\ai_service && start_ai_service.bat`
- **Backend** : `cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system && mvn spring-boot:run`

### Étape 2 : Vérifier les variables dans JMeter

1. Ouvrez JMeter
2. Cliquez sur "Plan de Test - Alert Clinique"
3. Vérifiez que les variables sont définies
4. Si elles sont vides, rechargez le plan de test

### Étape 3 : Vérifier le Thread Group

1. Cliquez sur "Thread Group - Tests API"
2. Vérifiez :
   - **Number of Threads** : `${THREADS}` (doit être résolu à 10)
   - **Ramp-up period** : `${RAMP_UP}` (doit être résolu à 10)
   - **Loop Count** : `${LOOP_COUNT}` (doit être résolu à 1)
3. Si les valeurs affichent `${...}` au lieu de nombres, les variables ne sont pas résolues

### Étape 4 : Lancer les tests avec View Results Tree

1. Cliquez sur "View Results Tree"
2. Cliquez sur le bouton **RUN** (vert)
3. Observez les requêtes apparaître en temps réel
4. Si elles sont **vertes** → Succès
5. Si elles sont **rouges** → Erreur (cliquez pour voir le détail)

### Étape 5 : Vérifier les logs JMeter

En bas de la fenêtre JMeter, regardez les logs :
- **Erreurs** : en rouge
- **Avertissements** : en jaune
- **Info** : en blanc

## 🐛 Problèmes courants

### Problème 1 : "No threads to run"

**Cause :** Le Thread Group a 0 threads ou est désactivé

**Solution :**
1. Cliquez sur "Thread Group - Tests API"
2. Vérifiez "Number of Threads" = 10 (pas 0)
3. Vérifiez que "enabled" est cochée

### Problème 2 : Tests se terminent instantanément

**Cause :** Variables non résolues ou Loop Count = 0

**Solution :**
1. Vérifiez les variables dans le TestPlan
2. Vérifiez "Loop Count" = 1 (pas 0)

### Problème 3 : Toutes les requêtes en rouge

**Cause :** Services non démarrés ou erreur de connexion

**Solution :**
1. Vérifiez que les services sont démarrés
2. Testez manuellement : `curl http://localhost:8082/api/patients`
3. Vérifiez les logs du backend pour les erreurs

### Problème 4 : View Results Tree vide après exécution

**Cause :** Les résultats ont été effacés ou le listener n'est pas activé

**Solution :**
1. Vérifiez que "View Results Tree" est activé (case cochée)
2. Ne cliquez pas sur "Clear" avant de voir les résultats
3. Relancez les tests

## 📊 Vérification finale

Après avoir lancé les tests, vous devriez voir :

1. **View Results Tree** :
   - Liste de 15 requêtes (ou plus selon le nombre de threads)
   - Requêtes vertes = succès
   - Requêtes rouges = erreur

2. **Summary Report** :
   - Tableau avec statistiques
   - Colonnes : Label, # Samples, Average, Min, Max, etc.
   - Valeurs non nulles

3. **Aggregate Report** :
   - Statistiques détaillées par endpoint
   - Graphiques si disponibles

## 🚀 Test rapide

Pour tester rapidement si tout fonctionne :

1. **Démarrer les services** (si pas déjà fait)
2. **Ouvrir JMeter** avec `LANCER_TEST_JMETER_GUI.bat`
3. **Cliquer sur "View Results Tree"**
4. **Cliquer sur RUN** (bouton vert)
5. **Attendre 5-10 secondes**
6. **Vérifier** : Des requêtes devraient apparaître dans "View Results Tree"

Si rien n'apparaît après 10 secondes, suivez le diagnostic ci-dessus.

