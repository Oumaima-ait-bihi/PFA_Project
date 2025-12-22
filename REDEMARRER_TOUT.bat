@echo off
echo ========================================
echo Redemarrage Rapide de Tous les Services
echo ========================================
echo.
echo Ce script va:
echo 1. Redemarrer le Service IA Python (port 5000)
echo 2. Redemarrer le Backend Spring Boot (port 8082)
echo.
echo ATTENTION: Fermez manuellement les services en cours d'execution avant de continuer
echo.
pause

echo.
echo [1/2] Redemarrage du Service IA Python...
start "Service IA Python" cmd /k "cd /d AI\ai_service && call venv_ai\Scripts\activate.bat && python app.py"

timeout /t 3 /nobreak >nul

echo.
echo [2/2] Redemarrage du Backend Spring Boot...
start "Backend Spring Boot" cmd /k "cd /d System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system && mvn spring-boot:run"

echo.
echo ========================================
echo Services en cours de demarrage...
echo ========================================
echo.
echo Vérifiez les fenetres qui se sont ouvertes pour voir les logs.
echo.
echo Apres quelques secondes, testez:
echo   - Service IA: http://localhost:5000/health
echo   - Backend: http://localhost:8082/api/ai/health
echo.
pause

