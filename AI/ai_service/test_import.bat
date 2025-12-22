@echo off
cd /d "%~dp0"
call venv_ai\Scripts\activate.bat
python -c "import sys; from pathlib import Path; ai_dir = Path('.').resolve().parent; sys.path.insert(0, str(ai_dir)); print('AI dir:', ai_dir); from src.preprocessing_supervised import build_features_patient_centric; print('Import reussi!')"
pause

