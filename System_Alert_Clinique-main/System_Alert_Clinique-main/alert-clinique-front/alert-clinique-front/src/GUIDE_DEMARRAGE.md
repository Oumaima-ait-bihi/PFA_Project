# 🚀 Guide de Démarrage - Centre d'Alertes

## Comment accéder au nouveau Centre d'Alertes ?

### Étape 1 : Se connecter
1. Ouvrez l'application
2. Sur la page de login, choisissez l'onglet **"Médecin"**
3. Utilisez les identifiants :
   - Email : `doctor@demo.com`
   - Mot de passe : `demo123`
4. Cliquez sur **"Se connecter"**

### Étape 2 : Passer en Mode Médecin
1. Une fois connecté, en haut de la page, vous verrez deux boutons
2. Cliquez sur **"⚕️ Mode Médecin"**

### Étape 3 : Accéder au Centre d'Alertes
1. Dans la sidebar à gauche, cliquez sur **"Centre d'alertes"** (icône triangle avec point d'exclamation)
2. Vous devriez maintenant voir le nouveau centre d'alertes !

## 📋 Fonctionnalités du Nouveau Centre d'Alertes

### 3 Onglets Principaux

#### 📄 **1. Alertes** (Liste)
- **4 Statistiques en haut** :
  - 🔴 Alertes Critiques (bordure rouge)
  - 🟠 Risque Élevé (bordure orange)
  - 🔵 En Attente (bordure bleue)
  - 🟢 Résolues (bordure verte)

- **Filtres avancés** :
  - 🔍 Recherche par nom de patient, ID ou type
  - 📊 Filtre par gravité (Critiques, Élevées, Moyennes, Faibles)
  - 📋 Filtre par statut (En attente, En cours, Résolues)
  - 🔄 Tri par temps ou gravité

- **Boutons d'action** :
  - 🔔 Masquer/Afficher les alertes résolues
  - 📥 Exporter les données

- **Cartes d'alertes** :
  - Icônes contextuelles (❤️ cœur, 🌡️ thermomètre, etc.)
  - Badges de couleur pour gravité et statut
  - Avatar du patient
  - Signes vitaux (fréquence cardiaque, pression artérielle, température, SpO2)
  - Boutons d'action :
    - 👁️ **Prendre en charge** (pour les alertes en attente)
    - ✅ **Résoudre** (pour les alertes non résolues)
    - 👥 **Assigner** (assigner à un médecin)

- **Modal de détails** :
  - Cliquez sur une carte pour voir tous les détails
  - Vue complète des signes vitaux
  - Historique et timestamp
  - Actions rapides

#### 📊 **2. Statistiques**
- **Graphique en camembert** : Répartition des alertes par gravité
  - 🔴 Critiques
  - 🟠 Élevées
  - 🟡 Moyennes
  - 🟢 Faibles

- **Graphique en barres** : Temps de réponse moyen (en minutes)
  - Par type de gravité

- **Barres de progression** : État des alertes
  - % En attente
  - % En cours de traitement
  - % Résolues

#### 📈 **3. Analyses**
- **Graphique de tendance hebdomadaire** :
  - 4 lignes colorées (7 jours)
  - Une ligne par gravité
  - Visualisation claire des tendances

- **3 Métriques clés** :
  - 📊 **Taux de résolution** : % avec évolution
  - ⏱️ **Temps moyen de réponse** : en minutes avec évolution
  - 🚨 **Alertes critiques** : nombre avec évolution vs semaine dernière

## 🎨 Code Couleur (Important!)

Le système utilise un code couleur cohérent :
- 🔴 **Rouge** = Critique (urgent)
- 🟠 **Orange** = Risque élevé (important)
- 🟡 **Jaune** = Moyen (à surveiller)
- 🟢 **Vert** = Faible / Résolu (stable)

## 🧪 Tester les Fonctionnalités

### Test 1 : Prendre en charge une alerte
1. Trouvez une alerte avec le badge bleu "En attente"
2. Cliquez sur **"Prendre en charge"**
3. ✅ L'alerte passe en statut "En cours" avec badge violet
4. Un toast de confirmation apparaît

### Test 2 : Résoudre une alerte
1. Trouvez une alerte en cours (badge violet)
2. Cliquez sur **"Résoudre"**
3. ✅ L'alerte passe en statut "Résolue" avec badge vert
4. Un toast de confirmation apparaît

### Test 3 : Filtrer les alertes
1. Utilisez le filtre de gravité pour afficher uniquement les "Critiques"
2. ✅ Seules les alertes critiques (bordure rouge) sont affichées
3. Le compteur en haut se met à jour

### Test 4 : Rechercher un patient
1. Dans le champ de recherche, tapez "Sophie"
2. ✅ Seules les alertes de Sophie Martin s'affichent
3. Le compteur se met à jour

### Test 5 : Voir les détails d'une alerte
1. Cliquez n'importe où sur une carte d'alerte
2. ✅ Un modal s'ouvre avec tous les détails
3. Vous pouvez agir directement depuis le modal

### Test 6 : Masquer les alertes résolues
1. Cliquez sur **"Masquer résolues"**
2. ✅ Les alertes vertes disparaissent
3. Le bouton devient **"Afficher résolues"**

### Test 7 : Voir les statistiques
1. Cliquez sur l'onglet **"Statistiques"**
2. ✅ Vous voyez le graphique en camembert
3. ✅ Le graphique en barres des temps de réponse
4. ✅ Les barres de progression

### Test 8 : Voir les analyses
1. Cliquez sur l'onglet **"Analyses"**
2. ✅ Graphique de tendance sur 7 jours
3. ✅ 3 métriques avec évolution (flèches ↑↓)

## 📱 Responsive

Le centre d'alertes est entièrement responsive :
- **Mobile** : Actions empilées verticalement, 1 colonne
- **Tablette** : 2 colonnes pour les stats
- **Desktop** : 4 colonnes pour les stats, layout optimal

## 🌍 Internationalisation

Le centre d'alertes supporte :
- 🇫🇷 **Français** (par défaut)
- 🇸🇦 **Arabe** (avec RTL automatique)

Changez la langue via le sélecteur dans le header (icône 🌍 Languages)

## 💡 Données de Démonstration

L'application utilise 10 alertes fictives avec :
- 2 alertes critiques (🔴)
- 2 alertes risque élevé (🟠)
- 3 alertes moyennes (🟡)
- 3 alertes faibles (🟢)

Statuts variés :
- 4 en attente
- 3 en cours
- 3 résolues

## ❓ Dépannage

### Je ne vois pas le centre d'alertes
1. ✅ Vérifiez que vous êtes connecté en tant que **Médecin**
2. ✅ Vérifiez que le bouton **"⚕️ Mode Médecin"** est actif (bleu)
3. ✅ Cliquez sur **"Centre d'alertes"** dans la sidebar gauche (2e option)

### Les graphiques ne s'affichent pas
1. ✅ Vérifiez que vous avez cliqué sur les onglets "Statistiques" ou "Analyses"
2. ✅ Attendez quelques secondes pour le chargement

### Les filtres ne fonctionnent pas
1. ✅ Essayez de rafraîchir la page (F5)
2. ✅ Vérifiez que vous avez bien sélectionné une option dans les filtres

## 🎯 Prochaines Étapes

Une fois familiarisé avec le centre d'alertes, explorez :
- 👥 **Liste des Patients** (3e option sidebar)
- 👨‍⚕️ **Profil Médecin** (4e option sidebar)
- 🔔 **Panel de Notifications** (icône cloche dans le header)

---

**Besoin d'aide ?** Tous les composants sont fonctionnels et testés ! 🚀
