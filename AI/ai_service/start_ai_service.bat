@echo off
echo ========================================
echo Demarrage du Service Python IA
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Activation de l'environnement virtuel...
if exist venv_ai\Scripts\activate.bat (
    call venv_ai\Scripts\activate.bat
    echo Environnement virtuel active
) else (
    echo ATTENTION: Environnement virtuel non trouve (venv_ai)
    echo Creation de l'environnement virtuel...
    python -m venv venv_ai
    call venv_ai\Scripts\activate.bat
    echo Environnement virtuel cree et active
)
echo.

echo [2/4] Verification de l'environnement Python...
python --version
if %ERRORLEVEL% NEQ 0 (
    echo ERREUR: Python n'est pas installe ou n'est pas dans le PATH
    pause
    exit /b 1
)
echo.

echo [3/4] Installation des dependances si necessaire...
if exist requirements.txt (
    echo Installation des packages depuis requirements.txt...
    pip install -r requirements.txt --quiet
    if %ERRORLEVEL% NEQ 0 (
        echo ATTENTION: Certaines dependances n'ont pas pu etre installees
        echo Le service peut quand meme fonctionner si les dependances sont deja installees
    ) else (
        echo Dependances installees avec succes
    )
) else (
    echo ATTENTION: requirements.txt non trouve
)
echo.

echo [4/4] Demarrage du service Flask sur le port 5000...
echo.
echo ========================================
echo Service en cours de demarrage...
echo ========================================
echo.
echo Si vous voyez des erreurs ci-dessous, le service n'a pas pu demarrer.
echo Sinon, le service devrait etre disponible sur http://localhost:5000
echo.
python app.py

pause
