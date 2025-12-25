# Comment Voir les Résultats dans JMeter (Interface Graphique)

## Méthode 1 : Lancer les Tests depuis l'Interface JMeter

### Étape 1 : Ouvrir JMeter avec le Plan de Test

Double-cliquez sur :
```
LANCER_TEST_JMETER_GUI.bat
```

Cela ouvrira JMeter avec votre plan de test chargé.

### Étape 2 : Voir les Listeners (Affichage des Résultats)

Dans l'arbre à gauche, vous verrez **3 listeners** en bas :

1. **"View Results Tree"** - Affiche chaque requête en détail
   - Cliquez dessus pour voir les résultats
   - Vous verrez chaque requête avec :
     - ✅ Succès/Échec (vert/rouge)
     - Temps de réponse
     - Code de statut HTTP
     - Réponse complète

2. **"Summary Report"** - Tableau récapitulatif
   - Statistiques par requête
   - Temps moyen, min, max
   - Taux d'erreur

3. **"Aggregate Report"** - Rapport agrégé
   - Statistiques détaillées
   - Graphiques de performance

### Étape 3 : Lancer les Tests

1. Cliquez sur le bouton **"Run"** (▶️ vert) dans la barre d'outils
2. OU allez dans le menu **Run → Start**

### Étape 4 : Observer les Résultats en Temps Réel

- Les résultats apparaissent **en temps réel** dans les listeners
- Cliquez sur **"View Results Tree"** pour voir chaque requête
- Cliquez sur chaque requête dans la liste pour voir les détails :
  - **Sampler result** : Résumé de la requête
  - **Request** : Données envoyées
  - **Response data** : Réponse reçue
  - **Response headers** : En-têtes HTTP

### Étape 5 : Arrêter les Tests

- Cliquez sur le bouton **"Stop"** (⏹️ rouge) pour arrêter

---

## Méthode 2 : Ajouter un Nouveau Listener

Si vous ne voyez pas les listeners :

1. Clic droit sur **"Thread Group - Tests API"**
2. Allez dans **Add → Listener**
3. Choisissez un des listeners :
   - **View Results Tree** (le plus détaillé)
   - **Summary Report** (tableau récapitulatif)
   - **Aggregate Report** (statistiques)
   - **Graph Results** (graphique de performance)

---

## Conseils

- **View Results Tree** consomme beaucoup de mémoire → Désactivez-le pour les tests de charge importants
- **Summary Report** est idéal pour voir rapidement les statistiques
- Pour les tests de performance, utilisez **Aggregate Report** ou **Graph Results**

---

## Résolution de Problèmes

### Les résultats ne s'affichent pas

1. Vérifiez que les listeners sont **activés** (coche verte)
2. Cliquez sur le listener pour le sélectionner
3. Assurez-vous que les tests sont bien lancés (bouton Run vert)

### JMeter est lent

- Désactivez "View Results Tree" pendant les tests de charge
- Réduisez le nombre de threads
- Fermez les autres applications

