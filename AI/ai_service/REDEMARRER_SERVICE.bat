@echo off
echo ========================================
echo Redemarrage du Service IA
echo ========================================
echo.
echo ATTENTION: Assurez-vous d'avoir arrete le service Flask precedent (Ctrl+C)
echo.
pause

cd /d "%~dp0"

echo Activation de l'environnement virtuel...
call venv_ai\Scripts\activate.bat

echo.
echo Demarrage du service Flask...
python app.py

pause

