@echo off
echo ========================================
echo Arrêt du processus sur le port 8080
echo ========================================
echo.

REM Trouver le PID du processus qui utilise le port 8080
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do (
    set PID=%%a
    echo Processus trouve avec PID: %%a
    
    REM Essayer d'arrêter le processus
    echo Tentative d'arret du processus...
    taskkill /F /PID %%a
    
    if %ERRORLEVEL% EQU 0 (
        echo Processus arrete avec succes!
    ) else (
        echo ERREUR: Impossible d'arreter le processus.
        echo Vous devez peut-etre executer ce script en tant qu'administrateur.
        echo.
        echo Alternative: Fermez manuellement la fenetre du terminal qui execute le backend.
    )
)

echo.
echo Verification du port 8080...
timeout /t 2 /nobreak >nul
netstat -ano | findstr :8080
if %ERRORLEVEL% EQU 0 (
    echo Le port 8080 est toujours utilise.
) else (
    echo Le port 8080 est maintenant libre!
)

pause

