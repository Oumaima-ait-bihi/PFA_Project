# Documentation : Analyse de Code avec SonarQube

## 📋 Vue d'ensemble

**SonarQube** est une plateforme open-source d'analyse de code qui détecte automatiquement les bugs, les vulnérabilités de sécurité, et les problèmes de qualité de code. Il aide à maintenir un code propre, sécurisé et maintenable.

## 🎯 Objectif de SonarQube

L'objectif est d'améliorer la qualité du code en détectant :
- **Bugs** : Erreurs dans le code qui peuvent causer des problèmes
- **Vulnérabilités** : Failles de sécurité potentielles
- **Code smells** : Code qui fonctionne mais qui n'est pas optimal
- **Duplication** : Code répété qui devrait être factorisé
- **Couverture de tests** : Pourcentage du code testé

## 🔧 Comment fonctionne SonarQube

### Principe de base

1. **Analyse** : SonarQube analyse le code source
2. **Détection** : Il identifie les problèmes selon des règles prédéfinies
3. **Rapport** : Il génère un rapport avec les problèmes trouvés
4. **Score** : Il attribue une note de qualité (A, B, C, D, E, F)

### Exemple de problèmes détectés

#### 1. Bugs
```java
// ❌ Problème : Division par zéro possible
public double calculateAverage(List<Integer> numbers) {
    int sum = numbers.stream().mapToInt(Integer::intValue).sum();
    return sum / numbers.size(); // Erreur si numbers est vide
}

// ✅ Solution : Vérifier que la liste n'est pas vide
public double calculateAverage(List<Integer> numbers) {
    if (numbers.isEmpty()) {
        return 0.0;
    }
    int sum = numbers.stream().mapToInt(Integer::intValue).sum();
    return (double) sum / numbers.size();
}
```

#### 2. Vulnérabilités de sécurité
```java
// ❌ Problème : Mot de passe en clair dans le code
String password = "admin123";

// ✅ Solution : Utiliser des variables d'environnement
String password = System.getenv("ADMIN_PASSWORD");
```

#### 3. Code smells
```java
// ❌ Problème : Méthode trop longue (plus de 50 lignes)
public void processData() {
    // 100 lignes de code...
}

// ✅ Solution : Diviser en plusieurs méthodes plus petites
public void processData() {
    validateInput();
    transformData();
    saveData();
}
```

## 📊 Métriques de qualité

### 1. Reliability (Fiabilité)
- **Bugs** : Nombre d'erreurs détectées
- **Reliability Rating** : A (0 bugs) à E (plus de 50 bugs)

### 2. Security (Sécurité)
- **Vulnerabilities** : Nombre de failles de sécurité
- **Security Rating** : A (0 vulnérabilités) à E (plus de 20 vulnérabilités)

### 3. Maintainability (Maintenabilité)
- **Code Smells** : Nombre de problèmes de qualité
- **Technical Debt** : Temps estimé pour corriger tous les problèmes

### 4. Coverage (Couverture de tests)
- **Line Coverage** : Pourcentage de lignes testées
- **Branch Coverage** : Pourcentage de branches (if/else) testées

### 5. Duplications
- **Duplicated Lines** : Nombre de lignes dupliquées
- **Duplicated Blocks** : Nombre de blocs de code dupliqués

## 🚀 Configuration dans notre projet

### 1. Installation de SonarQube

#### Option A : Docker (recommandé)
```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:latest
```

#### Option B : Téléchargement
1. Télécharger depuis https://www.sonarqube.org/downloads/
2. Extraire l'archive
3. Lancer : `bin/windows-x86-64/StartSonar.bat` (Windows)

### 2. Configuration Maven (Backend Java)

Ajouter dans `pom.xml` :

```xml
<properties>
    <sonar.projectKey=alert-system</sonar.projectKey>
    <sonar.sources=src/main/java</sonar.sources>
    <sonar.tests=src/test/java</sonar.tests>
    <sonar.java.binaries=target/classes</sonar.java.binaries>
</properties>

<build>
    <plugins>
        <plugin>
            <groupId>org.sonarsource.scanner.maven</groupId>
            <artifactId>sonar-maven-plugin</artifactId>
            <version>3.10.0.2594</version>
        </plugin>
    </plugins>
</build>
```

### 3. Exécution de l'analyse

```bash
# Dans le dossier du backend
cd alert_clinique_back_end/alert-system

# Lancer l'analyse
mvn sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=your-token
```

### 4. Configuration pour le frontend (React/TypeScript)

Installer SonarQube Scanner :

```bash
npm install --save-dev sonarqube-scanner
```

Créer `sonar-project.properties` :

```properties
sonar.projectKey=alert-clinique-frontend
sonar.sources=src
sonar.tests=src
sonar.language=ts
sonar.sourceEncoding=UTF-8
```

## 📈 Exemple de rapport SonarQube

### Dashboard principal

```
┌─────────────────────────────────────────┐
│  Alert System - Qualité du Code         │
├─────────────────────────────────────────┤
│  Reliability:     A (0 bugs)            │
│  Security:        B (2 vulnérabilités)    │
│  Maintainability: C (15 code smells)     │
│  Coverage:       45% (tests)              │
│  Duplications:   3.2%                    │
└─────────────────────────────────────────┘
```

### Détails des problèmes

```
Bugs (0)
├─ Aucun bug détecté ✅

Vulnérabilités (2)
├─ [HIGH] Mot de passe en clair dans AuthService.java:45
└─ [MEDIUM] Injection SQL possible dans PatientService.java:120

Code Smells (15)
├─ [MAJOR] Méthode trop longue (80 lignes) dans AIService.java:50
├─ [MINOR] Variable non utilisée dans PatientController.java:30
└─ ...
```

## 🎯 Règles de qualité importantes

### 1. Complexité cyclomatique
- **Règle** : Une méthode ne doit pas avoir une complexité > 10
- **Pourquoi** : Code difficile à comprendre et maintenir

### 2. Nombre de paramètres
- **Règle** : Une méthode ne doit pas avoir plus de 7 paramètres
- **Pourquoi** : Utiliser des objets pour regrouper les paramètres

### 3. Taille des fichiers
- **Règle** : Un fichier ne doit pas dépasser 1000 lignes
- **Pourquoi** : Diviser en plusieurs fichiers plus petits

### 4. Commentaires
- **Règle** : Au moins 25% du code doit être commenté
- **Pourquoi** : Faciliter la compréhension du code

### 5. Tests
- **Règle** : Au moins 80% de couverture de code
- **Pourquoi** : Garantir que le code fonctionne correctement

## 🔍 Exemples de problèmes dans notre projet

### Problème 1 : Gestion d'erreur manquante

```java
// ❌ Problème détecté par SonarQube
public Patient getPatientById(Long id) {
    return patientRepository.findById(id).get(); // Peut lancer NoSuchElementException
}

// ✅ Solution
public Optional<Patient> getPatientById(Long id) {
    return patientRepository.findById(id);
}
```

### Problème 2 : Code dupliqué

```java
// ❌ Problème : Code répété dans plusieurs méthodes
public void createPatient(Patient patient) {
    if (patient.getEmail() == null || patient.getEmail().isEmpty()) {
        throw new IllegalArgumentException("Email requis");
    }
    // ...
}

public void updatePatient(Patient patient) {
    if (patient.getEmail() == null || patient.getEmail().isEmpty()) {
        throw new IllegalArgumentException("Email requis");
    }
    // ...
}

// ✅ Solution : Extraire dans une méthode
private void validatePatientEmail(Patient patient) {
    if (patient.getEmail() == null || patient.getEmail().isEmpty()) {
        throw new IllegalArgumentException("Email requis");
    }
}
```

### Problème 3 : Variable non utilisée

```java
// ❌ Problème détecté
public void processData(List<String> data) {
    String unused = "test"; // Variable jamais utilisée
    // ...
}

// ✅ Solution : Supprimer la variable
public void processData(List<String> data) {
    // ...
}
```

## 📊 Interprétation des résultats

### Score de qualité

- **A** : Excellent (0-5% de problèmes)
- **B** : Bon (6-10% de problèmes)
- **C** : Acceptable (11-20% de problèmes)
- **D** : À améliorer (21-50% de problèmes)
- **E** : Critique (>50% de problèmes)

### Technical Debt

Le "Technical Debt" (dette technique) représente le temps estimé pour corriger tous les problèmes détectés.

Exemple :
- **Technical Debt** : 2h 30min
- Signifie qu'il faudrait environ 2h30 pour corriger tous les problèmes

## 🎯 Avantages de SonarQube

1. **Détection automatique** : Trouve les problèmes sans intervention manuelle
2. **Amélioration continue** : Suit l'évolution de la qualité du code
3. **Standards** : Applique les bonnes pratiques de l'industrie
4. **Sécurité** : Détecte les vulnérabilités avant la mise en production
5. **Documentation** : Génère des rapports détaillés

## ⚠️ Limitations

1. **Faux positifs** : Peut signaler des problèmes qui n'en sont pas vraiment
2. **Configuration** : Nécessite une configuration initiale
3. **Temps d'analyse** : Peut être long pour de gros projets
4. **Ressources** : Nécessite un serveur pour fonctionner

## 📝 Conclusion

SonarQube permet de :
- ✅ Maintenir un code de qualité
- ✅ Détecter les bugs avant la mise en production
- ✅ Identifier les vulnérabilités de sécurité
- ✅ Améliorer la maintenabilité du code
- ✅ Suivre l'évolution de la qualité du code

L'utilisation de SonarQube est essentielle pour garantir un code professionnel, sécurisé et maintenable.

## 🔗 Ressources

- Site officiel : https://www.sonarqube.org/
- Documentation : https://docs.sonarqube.org/
- Règles de qualité : https://rules.sonarsource.com/

