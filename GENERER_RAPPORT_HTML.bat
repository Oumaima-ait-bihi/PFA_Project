@echo off
echo ========================================
echo Generation du Rapport HTML JMeter
echo ========================================
echo.

REM Verifier que JMeter est installe
where jmeter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] JMeter n'est pas trouve dans le PATH
    echo.
    echo Veuillez installer JMeter ou modifier ce script pour pointer vers votre installation
    echo.
    pause
    exit /b 1
)

REM Chercher le dernier fichier JTL
set LAST_JTL=
for /f "delims=" %%F in ('dir /b /o-d jmeter\results\*.jtl 2^>nul') do (
    set LAST_JTL=jmeter\results\%%F
    goto :found
)

:found
if "%LAST_JTL%"=="" (
    echo [ERREUR] Aucun fichier de resultats (.jtl) trouve dans jmeter\results\
    echo.
    echo Veuillez d'abord executer les tests JMeter
    echo.
    pause
    exit /b 1
)

echo Fichier de resultats trouve: %LAST_JTL%
echo.

REM Creer le dossier pour le rapport HTML
if not exist "jmeter\results\html-report" mkdir "jmeter\results\html-report"

echo Generation du rapport HTML...
echo.

REM Generer le rapport HTML
jmeter -g "%LAST_JTL%" -o jmeter\results\html-report

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Rapport HTML genere avec succes!
    echo ========================================
    echo.
    echo Emplacement: jmeter\results\html-report\index.html
    echo.
    echo Ouvrir le rapport maintenant? (O/N)
    set /p openReport=
    if /i "%openReport%"=="O" (
        start jmeter\results\html-report\index.html
    )
) else (
    echo.
    echo [ERREUR] La generation du rapport a echoue
)

echo.
pause

