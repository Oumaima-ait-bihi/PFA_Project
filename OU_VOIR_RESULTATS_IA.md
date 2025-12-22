# Où Voir les Résultats des Prédictions IA

## 📍 Emplacements des Résultats

Après avoir modifié les données (humeur, sommeil, rythme cardiaque), les résultats apparaissent dans **3 endroits** :

---

### 1. **Section "Analyse IA en temps réel"** (En haut du dashboard)

Cette section affiche :
- ✅ **Statut du service** : "Service IA disponible" ou "Service IA indisponible"
- 📊 **Score d'anomalie** : Un pourcentage (0-100%) qui indique le niveau de risque
- 🎨 **Barre de progression colorée** :
  - 🟢 **Vert** : Risque faible (< 30%)
  - 🟠 **Orange** : Risque modéré (30-60%)
  - 🔴 **Rouge** : Risque élevé (> 60%)
- ⚠️ **Alerte visuelle** : Si le risque est élevé, une alerte rouge apparaît : "⚠️ Alerte détectée ! Consultez votre médecin."

**Exemple d'affichage :**
```
Analyse IA en temps réel
Risque modéré
Score d'anomalie: 45.2%
[Barre de progression orange]
```

---

### 2. **Section "Suggestions IA"** (Apparaît après une prédiction)

Cette section apparaît **automatiquement** après qu'une prédiction soit effectuée. Elle contient des suggestions personnalisées selon votre score :

**Suggestions selon le score :**
- **Score élevé (> 70%)** :
  - ⚠️ Risque élevé détecté. Consultez votre médecin.
  - 💊 Vérifiez que vous avez pris vos médicaments.

- **Score modéré (50-70%)** :
  - 📊 Surveillez vos signes vitaux régulièrement.
  - 😴 Assurez-vous d'avoir un sommeil de qualité.

- **Score faible (< 50%)** :
  - ✅ Vos indicateurs sont dans la normale.
  - 🏃 Continuez à maintenir un mode de vie sain.

**Suggestions spécifiques :**
- Si sommeil < 6h : 😴 Vous devriez dormir au moins 7-8 heures par nuit.
- Si rythme cardiaque > 100 : ❤️ Votre rythme cardiaque est élevé. Reposez-vous.
- Si rythme cardiaque < 60 : ❤️ Votre rythme cardiaque est bas. Consultez un médecin.

---

### 3. **Graphique "Tendances des prédictions"** (Après plusieurs modifications)

Ce graphique apparaît **après avoir modifié les données plusieurs fois** (au moins 2-3 fois). Il affiche :
- 📈 Une ligne bleue avec l'historique des scores d'anomalie
- 📅 Les dates en bas (format jour/mois)
- 📊 Les pourcentages à gauche (0-100%)
- 🔴 Des points d'alerte si des risques élevés ont été détectés

**Note :** Le graphique garde l'historique des **7 derniers jours** maximum.

---

## 🔍 Si Vous Ne Voyez Pas les Résultats

### Vérification 1 : Le Backend est-il démarré ?

**Test dans le navigateur :**
```
http://localhost:8080/api/ai/health
```

**Résultat attendu :**
```json
{
  "available": true,
  "message": "Service IA disponible"
}
```

**Si vous obtenez une erreur :**
1. Démarrez le backend Spring Boot :
   ```bash
   cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
   mvn spring-boot:run
   ```

---

### Vérification 2 : Les Prédictions se Déclenchent-elles ?

Les prédictions se déclenchent **automatiquement** après avoir modifié :
- L'humeur (cliquer sur une émotion)
- Le sommeil (déplacer les sliders)
- Le rythme cardiaque (déplacer le slider)

**Attendu :** Après 0.5 seconde, une prédiction devrait se déclencher automatiquement.

**Si rien ne se passe :**
1. Ouvrez la console du navigateur (F12)
2. Allez dans l'onglet "Console"
3. Vérifiez s'il y a des erreurs (en rouge)
4. Vérifiez s'il y a des requêtes vers `/api/ai/predict/simple`

---

### Vérification 3 : Le Statut du Service IA

En haut du dashboard, vérifiez le statut :
- ✅ **"Service IA disponible"** → Tout fonctionne
- ❌ **"Service IA indisponible"** → Le backend n'est pas démarré ou ne peut pas se connecter au service Python
- ⏳ **"En attente de données"** → Aucune prédiction n'a encore été effectuée

---

## 📋 Checklist pour Voir les Résultats

- [ ] Backend Spring Boot démarré (port 8080)
- [ ] Service Python IA démarré (port 5000)
- [ ] Statut IA affiche "Service IA disponible"
- [ ] Vous avez modifié au moins une donnée (humeur, sommeil, ou rythme cardiaque)
- [ ] Attendu 0.5 seconde après la modification
- [ ] Le score d'anomalie s'affiche dans la section "Analyse IA en temps réel"
- [ ] Les suggestions apparaissent dans la section "Suggestions IA"
- [ ] Le graphique apparaît après plusieurs modifications

---

## 🎯 Scénario de Test Complet

1. **Modifiez l'humeur** : Cliquez sur 😢 (Triste)
   - **Attendu** : Score d'anomalie augmente, suggestions apparaissent

2. **Modifiez le sommeil** : Réduisez à 4 heures
   - **Attendu** : Score d'anomalie augmente encore, nouvelles suggestions

3. **Modifiez le rythme cardiaque** : Augmentez à 110 bpm
   - **Attendu** : Score d'anomalie élevé, alerte rouge apparaît

4. **Modifiez plusieurs fois** : Changez les valeurs 3-4 fois
   - **Attendu** : Le graphique "Tendances des prédictions" apparaît

---

## 💡 Conseils

- **Modifiez les données progressivement** pour voir l'évolution du score
- **Observez les suggestions** qui changent selon votre score
- **Vérifiez le graphique** pour voir les tendances sur plusieurs jours
- **Testez différents scénarios** (bonne santé, risque modéré, risque élevé)

---

## 🐛 Dépannage

### Problème : "En attente de données" ne change pas

**Solution :**
1. Vérifiez que le backend est démarré
2. Vérifiez la console du navigateur (F12) pour les erreurs
3. Redémarrez l'application mobile

### Problème : Les prédictions ne se déclenchent pas

**Solution :**
1. Vérifiez que `_aiServiceAvailable` est `true`
2. Vérifiez que `_onDataChanged()` est appelé après chaque modification
3. Vérifiez les logs du backend pour voir si les requêtes arrivent

### Problème : Le graphique n'apparaît pas

**Solution :**
1. Modifiez les données au moins 2-3 fois
2. Vérifiez que `_predictionHistory` contient des données
3. Le graphique apparaît seulement si `_predictionHistory.isNotEmpty`

---

**Les résultats sont visibles immédiatement après avoir modifié les données !** 🎉

