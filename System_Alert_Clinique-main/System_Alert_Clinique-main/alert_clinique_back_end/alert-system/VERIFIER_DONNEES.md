# 🔍 Comment vérifier et afficher les données dans PostgreSQL

## Problème : Aucune donnée n'apparaît dans l'interface

### Solution 1 : Vérifier la structure actuelle de tes tables

Dans **pgAdmin** ou **psql**, exécute cette requête pour voir la structure de ta table `patient` :

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'patient' AND table_schema = 'public'
ORDER BY ordinal_position;
```

Cela te montrera **toutes les colonnes** de ta table actuelle.

### Solution 2 : Voir les données existantes

```sql
SELECT * FROM patient;
```

Si cette requête retourne des lignes, tu as des données mais elles ne s'affichent peut-être pas à cause d'un problème de mapping.

### Solution 3 : Insérer des données de test

Exécute le fichier **`check_and_migrate_data.sql`** qui contient des `INSERT` pour créer des données de test :

1. Ouvre **pgAdmin**
2. Clique droit sur ta base `alert_system` → **Query Tool**
3. Ouvre le fichier `src/main/resources/check_and_migrate_data.sql`
4. Copie-colle et exécute la partie **"OPTION B"** (les INSERT)
5. Vérifie avec : `SELECT * FROM patient;`

### Solution 4 : Si tes colonnes ont des noms différents

Si ta table PostgreSQL a des colonnes comme `nom` au lieu de `name`, tu as deux options :

#### Option A : Adapter les entités Java (recommandé si tu as beaucoup de données)

Modifie `Patient.java` pour mapper les colonnes existantes :

```java
@Column(name = "nom")  // Si ta colonne s'appelle "nom"
private String name;
```

#### Option B : Migrer les données vers la nouvelle structure

Exécute le fichier **`migrate_old_to_new_structure.sql`** qui :
- Sauvegarde tes données
- Ajoute les nouvelles colonnes
- Copie les données de l'ancienne vers la nouvelle structure

### Solution 5 : Vérifier que le backend lit bien les données

1. Assure-toi que ton backend Spring Boot est démarré
2. Teste l'API directement dans ton navigateur :
   ```
   http://localhost:8080/api/patients
   ```
3. Tu devrais voir un JSON avec tes patients

Si tu vois des données dans cette URL mais pas dans le front, c'est un problème de CORS ou de chargement côté React.

### Solution 6 : Vérifier les logs du backend

Dans la console où tourne `mvnw spring-boot:run`, regarde s'il y a des erreurs comme :
- `Column 'name' not found` → problème de mapping
- `Table 'patient' doesn't exist` → table non créée

## 🎯 Checklist rapide

- [ ] Les tables existent dans PostgreSQL ? (`\dt` dans psql)
- [ ] Les colonnes ont les bons noms ? (voir Solution 1)
- [ ] Il y a des données dans les tables ? (`SELECT * FROM patient;`)
- [ ] Le backend démarre sans erreur ?
- [ ] L'API `/api/patients` retourne du JSON ?
- [ ] Le front charge bien les données ? (console du navigateur F12)

## 📝 Exemple de requête pour voir toutes les données

```sql
-- Voir tous les patients (note: "condition" est un mot réservé SQL, donc entre guillemets)
SELECT id, name, email, phone, age, gender, "condition", status, last_visit, assigned_doctor 
FROM patient 
ORDER BY id;

-- Voir tous les médecins
SELECT id, nom, specialite, email, phone 
FROM medecin 
ORDER BY id;

-- Compter les enregistrements
SELECT 
    (SELECT COUNT(*) FROM patient) as nb_patients,
    (SELECT COUNT(*) FROM medecin) as nb_medecins,
    (SELECT COUNT(*) FROM alerte) as nb_alertes;
```

