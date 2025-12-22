package com.example.alertsystem.selenium;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Scénario Selenium : vérifier que la page affiche des éléments relatifs aux alertes.
 * Pré-requis :
 *  - Backend démarré sur http://localhost:8080
 *  - Frontend démarré sur http://localhost:3000
 */
class AlertesPresenceTest {

    private WebDriver driver;
    private WebDriverWait wait;
    private int holdSeconds;

    // Prépare le driver Chrome avant tous les tests
    @BeforeAll
    static void setupClass() {
        WebDriverManager.chromedriver().setup();
    }

    // Instancie un navigateur et une WebDriverWait avant chaque test
    @BeforeEach
    void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--window-size=1400,900");
        // Décommentez pour le mode headless (CI) :
        // options.addArguments("--headless=new", "--disable-gpu");
        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        // Permet de garder le navigateur ouvert pour observation en local :
        // mvn test -Dtest=AlertesPresenceTest -DholdSeconds=300
        holdSeconds = Integer.parseInt(System.getProperty("holdSeconds", "0"));
    }

    // Ferme (ou garde ouvert si demandé) le navigateur après chaque test
    @AfterEach
    void tearDown() {
        holdIfRequested();
        if (driver != null) {
            driver.quit();
        }
    }

    // Scénario : vérifier qu'un titre ou texte mentionne les alertes
    @Test
    void shouldDisplayAlertsSectionOrText() {
        driver.get("http://localhost:3000/");

        // Rechercher des titres/sections contenant "alerte" (ou variantes) dans h1/h2 ou th
        boolean hasAlertsText = wait.until(d -> {
            List<WebElement> titles = d.findElements(By.xpath("//*[self::h1 or self::h2 or self::th][contains(translate(text(),'ÉÈÊËéèêë','eeeeeeee'),'alerte')]"));
            if (!titles.isEmpty()) return true;
            // Fallback : chercher dans le body si les titres ne sont pas explicites
            String body = d.findElement(By.tagName("body")).getText().toLowerCase();
            return body.contains("alerte");
        });

        Assertions.assertTrue(hasAlertsText, "La page devrait afficher un titre ou du texte mentionnant les alertes.");
    }

    // Laisse le navigateur ouvert X secondes si holdSeconds est défini
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

