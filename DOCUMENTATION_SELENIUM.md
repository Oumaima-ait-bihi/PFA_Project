# Documentation : Tests d'Interface avec Selenium

## 📋 Vue d'ensemble

**Selenium** est un outil open-source utilisé pour automatiser les tests des interfaces web. Il permet de simuler les actions d'un utilisateur réel (cliquer, saisir du texte, naviguer) et de vérifier que l'application fonctionne correctement.

## 🎯 Objectif des tests

L'objectif est de vérifier automatiquement que toutes les fonctionnalités de l'interface web fonctionnent correctement, sans avoir à les tester manuellement à chaque modification du code.

## 🔧 Comment fonctionne Selenium

### Principe de base

Selenium contrôle un navigateur web (Chrome, Firefox, Edge) et :
1. **Ouvre** l'application web
2. **Simule** les actions de l'utilisateur (clics, saisie de texte)
3. **Vérifie** que les résultats attendus apparaissent
4. **Génère** un rapport avec les résultats

### Exemple simple

```java
// Ouvrir le navigateur
WebDriver driver = new ChromeDriver();

// Aller sur la page de login
driver.get("http://localhost:3000/login");

// Trouver le champ email et saisir l'email
WebElement emailField = driver.findElement(By.id("email"));
emailField.sendKeys("patient@example.com");

// Trouver le champ mot de passe et saisir le mot de passe
WebElement passwordField = driver.findElement(By.id("password"));
passwordField.sendKeys("password123");

// Cliquer sur le bouton de connexion
WebElement loginButton = driver.findElement(By.id("login-button"));
loginButton.click();

// Vérifier que la page de dashboard s'affiche
String currentUrl = driver.getCurrentUrl();
assert currentUrl.contains("dashboard");

// Fermer le navigateur
driver.quit();
```

## 📁 Structure des tests Selenium

### Fichiers nécessaires

1. **Configuration Selenium** (`pom.xml` pour Maven)
   - Dépendances Selenium
   - Driver du navigateur (ChromeDriver, GeckoDriver)

2. **Tests** (fichiers `.java` ou `.js`)
   - Tests de login
   - Tests de navigation
   - Tests de fonctionnalités

3. **Configuration du navigateur**
   - Chemin vers le driver
   - Options du navigateur (mode headless, taille de fenêtre)

## 🧪 Types de tests possibles

### 1. Tests de navigation
- Vérifier que les liens fonctionnent
- Vérifier que les menus s'ouvrent correctement
- Vérifier que la navigation entre pages fonctionne

### 2. Tests de formulaire
- Vérifier que les champs acceptent les données
- Vérifier les messages d'erreur
- Vérifier la soumission des formulaires

### 3. Tests de fonctionnalités
- Test de connexion (login)
- Test d'affichage des données
- Test de création/modification/suppression
- Test des prédictions IA

### 4. Tests de responsive design
- Vérifier que l'interface s'adapte aux différentes tailles d'écran

## 🚀 Exemple de test pour notre application

### Test de login patient

```java
@Test
public void testLoginPatient() {
    // 1. Ouvrir le navigateur
    WebDriver driver = new ChromeDriver();
    driver.manage().window().maximize();
    
    // 2. Aller sur la page de login
    driver.get("http://localhost:3000/login");
    
    // 3. Sélectionner le rôle "Patient"
    WebElement roleSelect = driver.findElement(By.id("role"));
    Select select = new Select(roleSelect);
    select.selectByValue("patient");
    
    // 4. Saisir l'email
    WebElement email = driver.findElement(By.id("email"));
    email.sendKeys("patient@example.com");
    
    // 5. Saisir le mot de passe
    WebElement password = driver.findElement(By.id("password"));
    password.sendKeys("password123");
    
    // 6. Cliquer sur "Se connecter"
    WebElement loginButton = driver.findElement(By.id("login-button"));
    loginButton.click();
    
    // 7. Attendre que la page se charge
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    wait.until(ExpectedConditions.urlContains("dashboard"));
    
    // 8. Vérifier que le dashboard s'affiche
    WebElement dashboardTitle = driver.findElement(By.tagName("h1"));
    assert dashboardTitle.getText().contains("Tableau de bord");
    
    // 9. Fermer le navigateur
    driver.quit();
}
```

### Test d'affichage des alertes

```java
@Test
public void testDisplayAlerts() {
    WebDriver driver = new ChromeDriver();
    
    // Se connecter d'abord
    loginAsDoctor(driver);
    
    // Aller sur la page des alertes
    driver.get("http://localhost:3000/doctor/alerts");
    
    // Vérifier que les alertes s'affichent
    List<WebElement> alerts = driver.findElements(By.className("alert-card"));
    assert alerts.size() > 0;
    
    // Vérifier que le nom du patient est affiché (pas "Patient inconnu")
    WebElement firstAlert = alerts.get(0);
    WebElement patientName = firstAlert.findElement(By.className("patient-name"));
    assert !patientName.getText().equals("Patient inconnu");
    
    driver.quit();
}
```

## 📊 Résultats des tests

### Rapport de test

Après l'exécution, Selenium génère un rapport qui indique :
- ✅ **Tests réussis** : Fonctionnalité fonctionne correctement
- ❌ **Tests échoués** : Problème détecté, à corriger
- ⏱️ **Temps d'exécution** : Temps pris par chaque test

### Exemple de rapport

```
Tests exécutés: 10
Tests réussis: 8
Tests échoués: 2
Temps total: 45 secondes

✅ testLoginPatient - 3.2s
✅ testDisplayAlerts - 2.8s
❌ testCreatePatient - 5.1s (Échec: élément non trouvé)
✅ testAIPrediction - 4.5s
...
```

## 🔧 Configuration dans notre projet

### Pour Java (Spring Boot)

1. **Ajouter les dépendances** dans `pom.xml` :

```xml
<dependencies>
    <!-- Selenium WebDriver -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.15.0</version>
    </dependency>
    
    <!-- JUnit pour les tests -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

2. **Créer un dossier de tests** : `src/test/java/com/example/alertsystem/selenium/`

3. **Télécharger ChromeDriver** : Compatible avec votre version de Chrome

### Pour JavaScript (React)

1. **Installer les dépendances** :

```bash
npm install --save-dev selenium-webdriver @selenium/webdriver
```

2. **Créer un dossier de tests** : `tests/selenium/`

## 🎯 Avantages de Selenium

1. **Automatisation** : Plus besoin de tester manuellement
2. **Rapidité** : Tests exécutés rapidement
3. **Fiabilité** : Tests reproductibles à chaque fois
4. **Détection précoce** : Problèmes détectés avant la mise en production
5. **Documentation** : Les tests servent de documentation vivante

## ⚠️ Limitations

1. **Fragilité** : Les tests peuvent casser si l'interface change
2. **Maintenance** : Nécessite de mettre à jour les tests quand l'interface change
3. **Temps d'exécution** : Plus lent que les tests unitaires
4. **Dépendances** : Nécessite que l'application soit démarrée

## 📝 Conclusion

Selenium permet de :
- ✅ Automatiser les tests de l'interface utilisateur
- ✅ Vérifier que toutes les fonctionnalités fonctionnent
- ✅ Détecter les régressions (fonctionnalités qui ne marchent plus)
- ✅ Gagner du temps en évitant les tests manuels répétitifs

Les tests Selenium sont essentiels pour garantir la qualité de l'interface utilisateur et éviter les bugs en production.

