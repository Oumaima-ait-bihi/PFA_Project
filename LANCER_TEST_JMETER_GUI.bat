@echo off
echo ========================================
echo Lancement des Tests JMeter (Mode GUI)
echo ========================================
echo.
echo [INFO] Ouverture de JMeter en mode interface graphique...
echo [INFO] Une fois JMeter ouvert, cliquez sur le bouton "Run" (vert) pour lancer les tests
echo [INFO] Les resultats s'afficheront dans les listeners en bas de l'arbre
echo.

REM Verifier que JMeter est installe
where jmeter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] JMeter n'est pas trouve dans le PATH
    echo.
    echo Veuillez installer JMeter depuis https://jmeter.apache.org/download_jmeter.cgi
    echo OU modifier ce script pour pointer vers votre installation JMeter
    echo.
    pause
    exit /b 1
)

REM Ouvrir JMeter avec le plan de test
cd jmeter
jmeter -t plan_test_alert_clinique.jmx -J BASE_URL=http://localhost:8082

cd ..
echo.
echo [INFO] JMeter a ete ferme.
pause

