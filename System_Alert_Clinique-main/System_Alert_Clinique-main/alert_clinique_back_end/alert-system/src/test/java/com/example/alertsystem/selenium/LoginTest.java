package com.example.alertsystem.selenium;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * Scénario Selenium : test de la page de connexion (login)
 * Pré-requis :
 *  - Backend démarré sur http://localhost:8080
 *  - Frontend démarré sur http://localhost:3000
 *  - Les identifiants de démo (patient@demo.com / demo123) sont disponibles
 */
class LoginTest {

    private WebDriver driver;
    private WebDriverWait wait;
    private int holdSeconds;

    @BeforeAll
    static void setupClass() {
        WebDriverManager.chromedriver().setup();
    }

    @BeforeEach
    void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--window-size=1400,900");
        // Pour CI sans affichage, décommentez la ligne suivante
        // options.addArguments("--headless=new", "--disable-gpu");
        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        holdSeconds = Integer.parseInt(System.getProperty("holdSeconds", "0"));
    }

    @AfterEach
    void tearDown() {
        holdIfRequested();
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    void shouldLoginWithDemoPatientCredentials() {
        driver.get("http://localhost:3000/");

        // Attendre le champ email patient
        By emailLocator = By.id("email");
        wait.until(ExpectedConditions.presenceOfElementLocated(emailLocator));
        WebElement emailInput = driver.findElement(emailLocator);

        // Renseigner les identifiants de démo
        emailInput.sendKeys("patient@demo.com");
        WebElement passwordInput = driver.findElement(By.id("password"));
        passwordInput.sendKeys("demo123");

        // Soumettre le formulaire
        WebElement submit = driver.findElement(By.cssSelector("button[type='submit']"));
        submit.click();

        // Après connexion, vérifier que l'en-tête patient est affiché (traduction française par défaut)
        boolean loggedIn = wait.until(d -> d.findElements(By.xpath("//*[contains(text(),'Portail Patient')]")).size() > 0);

        Assertions.assertTrue(loggedIn, "Après connexion, l'en-tête 'Portail Patient' devrait être visible");
    }

    private void holdIfRequested() {
        if (holdSeconds > 0) {
            try {
                Thread.sleep(holdSeconds * 1000L);
            } catch (InterruptedException ignored) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
