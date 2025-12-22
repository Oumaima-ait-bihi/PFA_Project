@echo off
echo ========================================
echo   Demarrage du Projet System Alert Clinique
echo ========================================
echo.

REM Vérifier que nous sommes dans le bon répertoire
cd /d "%~dp0"

echo [1/3] Demarrage du Service Python IA (port 5000)...
start "Service IA Python" cmd /k "cd AI\ai_service && if exist venv_ai\Scripts\activate.bat (call venv_ai\Scripts\activate.bat && python app.py) else (python app.py)"
timeout /t 3 /nobreak >nul
echo Service IA demarre dans une nouvelle fenetre
echo.

echo [2/3] Demarrage du Backend Spring Boot (port 8080)...
start "Backend Spring Boot" cmd /k "cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system && mvn spring-boot:run"
timeout /t 3 /nobreak >nul
echo Backend Spring Boot demarre dans une nouvelle fenetre
echo.

echo [3/3] Demarrage du Frontend Web (port 5173)...
start "Frontend Web" cmd /k "cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert-clinique-front\alert-clinique-front && npm run dev"
timeout /t 3 /nobreak >nul
echo Frontend Web demarre dans une nouvelle fenetre
echo.

echo ========================================
echo   Services demarres !
echo ========================================
echo.
echo Services disponibles :
echo - Service IA Python : http://localhost:5000
echo - Backend Spring Boot : http://localhost:8080
echo - Frontend Web : http://localhost:5173
echo.
echo Pour lancer l'application mobile Flutter :
echo   cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert-clinique-front\alert-clinique-front\alert_clinique_mobile
echo   flutter run
echo.
pause

