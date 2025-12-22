@echo off
echo ========================================
echo Correction de la version de scikit-learn
echo ========================================
echo.
echo ATTENTION: Le service Flask doit etre arrete avant d'executer ce script!
echo.
pause

cd /d "%~dp0"

echo [1/3] Activation de l'environnement virtuel...
call venv_ai\Scripts\activate.bat
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Impossible d'activer l'environnement virtuel
    pause
    exit /b 1
)

echo.
echo [2/3] Desinstallation de scikit-learn 1.8.0...
pip uninstall scikit-learn -y
if %ERRORLEVEL% NEQ 0 (
    echo ATTENTION: Erreur lors de la desinstallation
    echo Cela peut etre normal si le service Flask est en cours d'execution
    echo Fermez le service Flask et reessayez
)

echo.
echo [3/3] Installation de scikit-learn 1.3.2...
pip install scikit-learn==1.3.2
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Impossible d'installer scikit-learn 1.3.2
    pause
    exit /b 1
)

echo.
echo ========================================
echo Verification de l'installation...
echo ========================================
pip show scikit-learn

echo.
echo ========================================
echo Installation terminee!
echo ========================================
echo.
echo Vous pouvez maintenant redemarrer le service IA avec:
echo   start_ai_service.bat
echo.
pause

