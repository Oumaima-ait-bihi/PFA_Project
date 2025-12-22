# Configuration de la Base de Données PostgreSQL

## 📋 Étapes pour créer les tables

### 1. Se connecter à PostgreSQL

Ouvre **pgAdmin** ou un terminal `psql` et connecte-toi à ta base de données `alert_system`.

### 2. Exécuter le script SQL

**Option A : Via pgAdmin**
1. Clique droit sur ta base `alert_system` → **Query Tool**
2. Ouvre le fichier `src/main/resources/create_tables.sql`
3. Copie-colle tout le contenu dans l'éditeur
4. Clique sur **Execute** (F5)

**Option B : Via psql**
```bash
psql -U postgres -d alert_system -f src/main/resources/create_tables.sql
```

### 3. Vérifier que les tables sont créées

Dans pgAdmin, tu devrais voir ces tables :
- ✅ `patient`
- ✅ `medecin`
- ✅ `alerte`
- ✅ `historique_alerte`
- ✅ `rythme_cardiaque`
- ✅ `qualite_sommeil`
- ✅ `humeur`
- ✅ `users`
- ✅ `admin`

## 🔍 Structure des tables principales

### Table `patient`
- `id` (BIGSERIAL PRIMARY KEY)
- `name` (VARCHAR) - **Nom complet**
- `email` (VARCHAR UNIQUE) - **Email**
- `phone` (VARCHAR) - **Téléphone**
- `age` (INTEGER) - **Âge**
- `gender` (VARCHAR) - **'M' ou 'F'**
- `condition` (VARCHAR) - **Ex: "Hypertension sévère"**
- `status` (VARCHAR) - **'critical', 'high', ou 'stable'**
- `last_visit` (DATE) - **Dernière visite**
- `assigned_doctor` (VARCHAR) - **Nom du médecin assigné**
- `adresse` (VARCHAR) - **Adresse**

### Table `medecin`
- `id` (BIGSERIAL PRIMARY KEY)
- `nom` (VARCHAR) - **Nom du médecin**
- `specialite` (VARCHAR) - **Spécialité**
- `email` (VARCHAR UNIQUE) - **Email**
- `phone` (VARCHAR) - **Téléphone**

## ⚠️ Important

- Le script **supprime toutes les tables existantes** avant de les recréer (ligne `DROP TABLE IF EXISTS ...`)
- Si tu as déjà des données importantes, **fais une sauvegarde** avant d'exécuter le script !
- Pour garder tes données existantes, commente les lignes `DROP TABLE` dans le script SQL.

## 🧪 Données de test (optionnel)

À la fin du fichier `create_tables.sql`, il y a des `INSERT` commentés pour créer des données de test. Tu peux les décommenter si tu veux tester avec des données d'exemple.

