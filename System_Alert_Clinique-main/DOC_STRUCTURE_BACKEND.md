# Backend – Structure du projet et API REST

## 1. Contexte général

- **Technologie** : Spring Boot 4 (Java 17, Maven)
- **Architecture** : couche MVC classique avec `controller` → `service` → `repository` → `entities`
- **Base de données** : PostgreSQL (scripts SQL dans `src/main/resources`)
- **Sécurité** : Spring Security + JWT (JSON Web Token)
- **Tests** : 
  - Tests unitaires / d’intégration Spring Boot
  - Tests Selenium (Web) et Appium (Mobile) pour l’interface

---

## 2. Structure du backend

Dossier racine du backend : `alert_clinique_back_end/alert-system`

- **`pom.xml`**
  - Déclare les dépendances principales :
    - `spring-boot-starter-data-jpa` (accès BD)
    - `spring-boot-starter-webmvc` (API REST)
    - `spring-boot-starter-security` + JWT (`io.jsonwebtoken`) pour l’authentification
    - `postgresql` (driver BD)
    - `lombok` (réduction du code boilerplate)
    - Dépendances de tests : Spring Boot Test, Selenium, WebDriverManager, Appium, JaCoCo (couverture)

- **`src/main/java/com/example/alertsystem`**
  - **`AlertsystemApplication.java`**  
    Point d’entrée Spring Boot (classe `main` qui démarre l’application).

  - **`config`**
    - `CorsConfig.java` : configuration CORS (autorisations de domaine pour le frontend).
    - `SecurityConfig.java` : configuration Spring Security (filtres, autorisations, usage de JWT).

  - **`entities`**
    - `User`, `Admin`, `Medecin`, `Patient` : entités de base pour les utilisateurs du système.
    - `Alerte`, `HistoriqueAlerte`, `Humeur`, `QualiteSommeil`, `RythmeCardiaque` : entités métier pour le suivi clinique et la génération des alertes.

  - **`repository`**
    - Interfaces JPA pour chaque entité :  
      `MedecinRepository`, `PatientRepository`, `AlerteRepository`,  
      `HistoriqueAlerteRepository`, `HumeurRepository`,  
      `QualiteSommeilRepository`, `RythmeCardiaqueRepository`, `UserRepository`.
    - Permettent les opérations CRUD sur la BD (héritent de `JpaRepository`).

  - **`service`**
    - Logique métier : 
      - `MedecinService`, `PatientService`
      - `AlerteService`, `HistoriqueAlerteService`
      - `HumeurService`, `QualiteSommeilService`, `RythmeCardiaqueService`
    - C’est ici qu’on applique les règles métier (création d’alertes, filtrage, validations, etc.).

  - **`controller`**
    - Expose les API REST consommées par le frontend web (React) et le mobile (Flutter).

  - **`exception`**
    - `GlobalExceptionHandler.java` : gestion centralisée des erreurs (retour d’erreurs HTTP propres et lisibles au frontend).

- **`src/main/resources`**
  - `application.properties` : configuration (BD PostgreSQL, port de l’application, paramètres JWT, etc.).
  - Scripts SQL :
    - `create_tables.sql`, `check_and_migrate_data.sql`, `migrate_old_to_new_structure.sql` : automatisent la création/migration de la base.

---

## 3. API REST exposées (principales)

Toutes les routes retournent/consomment du **JSON** et sont préfixées par `/api/...`.  
Les opérations utilisent les verbes HTTP classiques : `GET`, `POST`, `PUT`, `DELETE`.

### 3.1. Gestion des médecins – `MedecinController`

- **Base URL** : `/api/medecins`

- **GET** `/api/medecins`  
  - **Description** : récupérer la liste de tous les médecins.  
  - **Réponse** : `List<Medecin>`.

- **GET** `/api/medecins/{id}`  
  - **Description** : récupérer un médecin par son **id**.  
  - **Réponse** : `Medecin` (ou 404 si non trouvé).

- **POST** `/api/medecins`  
  - **Description** : créer un nouveau médecin.  
  - **Body** : objet `Medecin` en JSON.

- **PUT** `/api/medecins/{id}`  
  - **Description** : modifier un médecin existant.  
  - **Body** : objet `Medecin` en JSON.

- **DELETE** `/api/medecins/{id}`  
  - **Description** : supprimer un médecin.

---

### 3.2. Gestion des patients – `PatientController`

- **Base URL** : `/api/patients`

- **GET** `/api/patients`  
  - Liste de tous les patients.

- **GET** `/api/patients/{id}`  
  - Détails d’un patient par `id`.

- **POST** `/api/patients`  
  - Création d’un patient.

- **PUT** `/api/patients/{id}`  
  - Mise à jour d’un patient.

- **DELETE** `/api/patients/{id}`  
  - Suppression d’un patient.

---

### 3.3. Gestion des alertes – `AlerteController`

- **Base URL** : `/api/alertes`

- **GET** `/api/alertes`  
  - Liste de toutes les alertes.

- **GET** `/api/alertes/{id}`  
  - Détail d’une alerte.

- **POST** `/api/alertes`  
  - Création d’une nouvelle alerte (générée à partir des données cliniques).

- **DELETE** `/api/alertes/{id}`  
  - Suppression d’une alerte.

---

### 3.4. Historique des alertes – `HistoriqueAlerteController`

- **Base URL** : `/api/historiqueAlertes`

- **GET** `/api/historiqueAlertes`  
  - Tous les enregistrements d’historique d’alertes.

- **GET** `/api/historiqueAlertes/{id}`  
  - Un historique particulier.

- **POST** `/api/historiqueAlertes`  
  - Création d’une entrée dans l’historique.

- **DELETE** `/api/historiqueAlertes/{id}`  
  - Suppression d’un historique.

---

### 3.5. Humeur – `HumeurController`

- **Base URL** : `/api/humeurs`

- **GET** `/api/humeurs` : liste des humeurs.  
- **GET** `/api/humeurs/{id}` : humeur par id.  
- **POST** `/api/humeurs` : créer une nouvelle mesure d’humeur.  
- **DELETE** `/api/humeurs/{id}` : supprimer une mesure.

---

### 3.6. Qualité du sommeil – `QualiteSommeilController`

- **Base URL** : `/api/sommeils`

- **GET** `/api/sommeils` : liste des enregistrements de sommeil.  
- **GET** `/api/sommeils/{id}` : enregistrement par id.  
- **POST** `/api/sommeils` : créer une nouvelle mesure de qualité de sommeil.  
- **DELETE** `/api/sommeils/{id}` : supprimer une mesure.

---

### 3.7. Rythme cardiaque – `RythmeCardiaqueController`

- **Base URL** : `/api/rythmes`

- **GET** `/api/rythmes` : liste des mesures de rythme cardiaque.  
- **GET** `/api/rythmes/{id}` : détail d’une mesure.  
- **POST** `/api/rythmes` : création d’une nouvelle mesure de rythme cardiaque.  
- **DELETE** `/api/rythmes/{id}` : suppression d’une mesure.

---

## 4. Résumé pour la présentation au professeur

- **Backend Spring Boot** structuré en couches (`controller`, `service`, `repository`, `entities`) avec une **base PostgreSQL**.
- Les **API REST** exposent la gestion des **patients**, **médecins**, **alertes**, **historique d’alertes** et des données cliniques **(humeur, sommeil, rythme cardiaque)**.
- La **sécurité** est assurée par **Spring Security + JWT**, avec une configuration CORS pour autoriser le frontend React et l’appli mobile Flutter.
- Des **tests end-to-end** sont réalisés avec **Selenium** (web) et **Appium** (mobile) pour valider le bon fonctionnement de l’application complète.


