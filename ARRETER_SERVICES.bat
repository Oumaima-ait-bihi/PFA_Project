@echo off
echo ========================================
echo   Arret des Services System Alert Clinique
echo ========================================
echo.

echo [1/3] Arret des processus Java (Backend Spring Boot)...
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do (
    echo Arret du processus PID %%a
    taskkill /F /PID %%a 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo Processus %%a arrete avec succes
    ) else (
        echo Impossible d'arreter le processus %%a (peut-etre deja arrete ou necessite des droits admin)
    )
)
echo.

echo [2/3] Arret des processus Python (Service IA)...
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    echo Arret du processus PID %%a
    taskkill /F /PID %%a 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo Processus %%a arrete avec succes
    ) else (
        echo Impossible d'arreter le processus %%a (peut-etre deja arrete ou necessite des droits admin)
    )
)
echo.

echo [3/3] Arret des processus Node (Frontend Web)...
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    echo Arret du processus PID %%a
    taskkill /F /PID %%a 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo Processus %%a arrete avec succes
    ) else (
        echo Impossible d'arreter le processus %%a (peut-etre deja arrete ou necessite des droits admin)
    )
)
echo.

echo ========================================
echo   Services arretes !
echo ========================================
echo.
echo Si certains processus n'ont pas pu etre arretes, fermez manuellement les fenetres de terminal
echo ou utilisez le Gestionnaire des taches (Ctrl+Shift+Esc) pour les terminer.
echo.
pause

