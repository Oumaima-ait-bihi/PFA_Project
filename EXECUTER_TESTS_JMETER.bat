@echo off
echo ========================================
echo Execution des Tests JMeter
echo ========================================
echo.

REM Verifier que JMeter est installe
where jmeter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] JMeter n'est pas trouve dans le PATH
    echo.
    echo Veuillez:
    echo 1. Installer JMeter depuis https://jmeter.apache.org/download_jmeter.cgi
    echo 2. Ajouter le dossier bin de JMeter au PATH
    echo    OU
    echo 3. Modifier ce script pour pointer vers votre installation JMeter
    echo.
    pause
    exit /b 1
)

REM Creer le dossier results s'il n'existe pas
if not exist "jmeter\results" mkdir "jmeter\results"

echo [1/3] Verification des services...
echo.
echo Verifiant le backend Spring Boot (port 8082)...
curl -s http://localhost:8082/api/ai/health >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENTION] Le backend Spring Boot ne semble pas etre demarre sur le port 8082
    echo Veuillez demarrer le backend avant de continuer
    echo.
    pause
)

echo Verifiant le service IA Python (port 5000)...
curl -s http://localhost:5000/health >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENTION] Le service IA Python ne semble pas etre demarre sur le port 5000
    echo Veuillez demarrer le service IA avant de continuer
    echo.
    pause
)

echo.
echo [2/3] Execution des tests JMeter...
echo.
echo Les resultats seront sauvegardes dans: jmeter\results\
echo.

REM Executer les tests en mode non-GUI
jmeter -n -t jmeter\test-plan-alert-system.jmx ^
    -l jmeter\results\test-results-%date:~-4,4%%date:~-7,2%%date:~-10,2%-%time:~0,2%%time:~3,2%%time:~6,2%.jtl ^
    -e -o jmeter\results\html-report

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [3/3] Tests termines avec succes!
    echo.
    echo Resultats:
    echo   - Fichier JTL: jmeter\results\test-results-*.jtl
    echo   - Rapport HTML: jmeter\results\html-report\index.html
    echo.
    echo Ouvrir le rapport HTML? (O/N)
    set /p openReport=
    if /i "%openReport%"=="O" (
        start jmeter\results\html-report\index.html
    )
) else (
    echo.
    echo [ERREUR] Les tests ont echoue. Verifiez les logs ci-dessus.
)

echo.
pause

