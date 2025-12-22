package com.example.alertsystem.selenium;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Smoke test Selenium pour vérifier que la page d'accueil du front React est accessible.
 * Pré-requis :
 *  - Backend démarré sur http://localhost:8080
 *  - Frontend démarré sur http://localhost:3000
 */
class HomeSmokeTest {

    private WebDriver driver;
    private int holdSeconds;

    // Prépare le driver Chrome avant tous les tests
    @BeforeAll
    static void setupClass() {
        WebDriverManager.chromedriver().setup();
    }

    // Instancie un navigateur avant chaque test
    @BeforeEach
    void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--window-size=1400,900");
        // Décommentez pour une exécution en CI sans interface graphique
        // options.addArguments("--headless=new", "--disable-gpu");
        driver = new ChromeDriver(options);
        // Permet de garder le navigateur ouvert pour observation en local :
        // mvn test -Dtest=HomeSmokeTest -DholdSeconds=300
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

    // Vérifie que la page d’accueil du front se charge et contient un texte attendu
    @Test
    void shouldLoadHomePage() {
        driver.get("http://localhost:3000/");

        // Attendre qu'au moins un titre soit présent
        new WebDriverWait(driver, Duration.ofSeconds(30))
                .until(d -> !d.findElements(By.cssSelector("h1, h2")).isEmpty());

        List<WebElement> titles = driver.findElements(By.cssSelector("h1, h2"));
        boolean hasExpectedTitle = titles.stream().anyMatch(t -> {
            String txt = t.getText().toLowerCase();
            return txt.contains("patient")
                    || txt.contains("médecin")
                    || txt.contains("gestion")
                    || txt.contains("alerte");
        });

        // En fallback, vérifier dans le body
        if (!hasExpectedTitle) {
            String bodyText = driver.findElement(By.tagName("body")).getText().toLowerCase();
            hasExpectedTitle = bodyText.contains("patient")
                    || bodyText.contains("médecin")
                    || bodyText.contains("gestion")
                    || bodyText.contains("alerte");
        }

        Assertions.assertTrue(hasExpectedTitle,
                "La page devrait afficher un titre ou du texte mentionnant patients/médecins/gestion/alertes");
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

