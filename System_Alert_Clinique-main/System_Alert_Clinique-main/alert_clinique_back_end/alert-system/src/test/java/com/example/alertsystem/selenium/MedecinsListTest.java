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
 * Scénario Selenium : vérifier que la page affiche la liste des médecins et qu'un champ de recherche est présent.
 * Pré-requis :
 *  - Backend démarré sur http://localhost:8080
 *  - Frontend démarré sur http://localhost:3000
 */
class MedecinsListTest {

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
        // mvn test -Dtest=MedecinsListTest -DholdSeconds=300
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

    // Scénario : présence du champ de recherche médecin et au moins un en-tête de tableau
    @Test
    void shouldDisplayDoctorsSearchAndTable() {
        driver.get("http://localhost:3000/");

        // Localisateur tolérant sur le placeholder (médecin ou medecin)
        By searchLocator = By.xpath("//input[contains(translate(@placeholder,'ÉÈÊËéèêë','eeeeeeee'),'medecin')]");
        wait.until(ExpectedConditions.presenceOfElementLocated(searchLocator));
        WebElement searchInput = driver.findElement(searchLocator);

        // Saisir "Hasna" pour filtrer sur ce médecin
        searchInput.sendKeys("Hasna");

        // Vérifier qu'un en-tête ou label mentionne les médecins/spécialités
        boolean hasHeaders = wait.until(d -> {
            List<WebElement> headers = d.findElements(By.xpath("//*[self::th or self::h1 or self::h2][contains(translate(text(),'ÉÈÊËéèêë','eeeeeeee'),'medecin') or contains(translate(text(),'ÉÈÊËéèêë','eeeeeeee'),'specialite')]"));
            return !headers.isEmpty();
        });

        // Vérifier qu'au moins un résultat contient "Hasna"
        boolean hasHasna = wait.until(d -> {
            List<WebElement> matches = d.findElements(By.xpath("//*[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZÉÈÊËÀÂÎÏÔÖÙÛÜÇéèêëàâîïôöùûüç','abcdefghijklmnopqrstuvwxyzéeêeaaîïooûüç'),'hasna')]"));
            return !matches.isEmpty();
        });

        Assertions.assertTrue(hasHeaders, "La page devrait afficher des en-têtes ou titres liés aux médecins/spécialités");
        Assertions.assertTrue(hasHasna, "La page devrait afficher un résultat contenant 'Hasna' après la recherche");
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

