@echo off
echo ========================================
echo Verification des Services
echo ========================================
echo.

echo [1/3] Verification du Service IA Python (port 5000)...
curl -s http://localhost:5000/health >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Service IA Python est accessible sur http://localhost:5000
    curl -s http://localhost:5000/health
    echo.
) else (
    echo [ERREUR] Service IA Python n'est pas accessible sur http://localhost:5000
    echo          Assurez-vous que le service IA est demarre avec: start_ai_service.bat
    echo.
)

echo [2/3] Verification du Backend Spring Boot (port 8082)...
curl -s http://localhost:8082/api/ai/health >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Backend Spring Boot est accessible sur http://localhost:8082
    curl -s http://localhost:8082/api/ai/health
    echo.
) else (
    echo [ERREUR] Backend Spring Boot n'est pas accessible sur http://localhost:8082
    echo          Assurez-vous que le backend est demarre avec: mvn spring-boot:run
    echo.
)

echo [3/3] Verification de la communication Backend - Service IA...
curl -s http://localhost:8082/api/ai/health 2>nul | findstr /i "available" >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Le backend peut communiquer avec le service IA
    curl -s http://localhost:8082/api/ai/health
    echo.
) else (
    echo [ATTENTION] Le backend ne peut pas communiquer avec le service IA
    echo              Verifiez que le service IA est demarre sur le port 5000
    echo.
)

echo ========================================
echo Verification terminee
echo ========================================
pause

