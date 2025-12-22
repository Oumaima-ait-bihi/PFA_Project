package com.example.alertsystem.selenium;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

/**
 * Scénario Selenium : recherche d'un patient sur le front React.
 * Pré-requis :
 *  - Backend démarré sur http://localhost:8080
 *  - Frontend démarré sur http://localhost:3000
 *  - Des patients présents en base (sinon adapter la valeur recherchée)
 */
class PatientsSearchTest {

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
        // mvn test -Dtest=PatientsSearchTest -DholdSeconds=300
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

    // Scénario : recherche d'un patient et vérification d'un résultat contenant la requête
    @Test
    void shouldSearchPatientByName() {
        driver.get("http://localhost:3000/");

        // Attendre la présence du champ de recherche patient
        By searchLocator = By.cssSelector("input[placeholder*='Rechercher'][placeholder*='patient']");
        wait.until(ExpectedConditions.presenceOfElementLocated(searchLocator));
        WebElement searchInput = driver.findElement(searchLocator);

        // Saisir une valeur de recherche
        String query = "OUMAIMA";
        searchInput.sendKeys(query);

        // Attendre que la page affiche un résultat contenant la valeur recherchée
        boolean found = wait.until(d -> {
            List<WebElement> matches = d.findElements(By.xpath("//*[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'), '" + query.toLowerCase() + "')]"));
            return !matches.isEmpty();
        });

        Assertions.assertTrue(found, "Un résultat contenant '" + query + "' devrait apparaître après la recherche");
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

