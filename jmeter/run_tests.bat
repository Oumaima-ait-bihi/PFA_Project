@echo off
REM Script pour lancer les tests JMeter en mode non-GUI
REM Usage: run_tests.bat [nombre_threads] [ramp_up] [loop_count]

setlocal enabledelayedexpansion

REM Configuration par défaut
set BASE_URL=http://localhost:8080
set THREADS=10
set RAMP_UP=10
set LOOP_COUNT=1

REM Récupérer les paramètres en ligne de commande si fournis
if not "%1"=="" set THREADS=%1
if not "%2"=="" set RAMP_UP=%2
if not "%3"=="" set LOOP_COUNT=%3

REM Vérifier que JMeter est installé
where jmeter.bat >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: JMeter n'est pas dans le PATH
    echo Veuillez installer JMeter et l'ajouter au PATH
    echo Ou modifier ce script pour pointer vers votre installation JMeter
    pause
    exit /b 1
)

REM Créer le dossier results s'il n'existe pas
if not exist "results" mkdir results

REM Générer un nom de fichier de résultats avec timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set timestamp=%datetime:~0,8%_%datetime:~8,6%

set RESULTS_FILE=results\results_%timestamp%.jtl
set HTML_REPORT=results\html-report_%timestamp%

echo ========================================
echo Lancement des tests JMeter
echo ========================================
echo URL Base: %BASE_URL%
echo Threads: %THREADS%
echo Ramp-up: %RAMP_UP% secondes
echo Loop Count: %LOOP_COUNT%
echo Fichier de résultats: %RESULTS_FILE%
echo Rapport HTML: %HTML_REPORT%
echo ========================================
echo.

REM Lancer JMeter en mode non-GUI
jmeter.bat -n ^
    -t plan_test_alert_clinique.jmx ^
    -J BASE_URL=%BASE_URL% ^
    -J THREADS=%THREADS% ^
    -J RAMP_UP=%RAMP_UP% ^
    -J LOOP_COUNT=%LOOP_COUNT% ^
    -l %RESULTS_FILE% ^
    -e ^
    -o %HTML_REPORT%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Tests terminés avec succès!
    echo ========================================
    echo Fichier de résultats: %RESULTS_FILE%
    echo Rapport HTML: %HTML_REPORT%\index.html
    echo.
    echo Ouvrir le rapport HTML? (O/N)
    set /p OPEN_REPORT=
    if /i "!OPEN_REPORT!"=="O" (
        start "" "%HTML_REPORT%\index.html"
    )
) else (
    echo.
    echo ========================================
    echo ERREUR lors de l'exécution des tests
    echo ========================================
    pause
    exit /b 1
)

endlocal

