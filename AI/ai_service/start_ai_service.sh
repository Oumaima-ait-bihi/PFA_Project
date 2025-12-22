#!/bin/bash
echo "========================================"
echo "Démarrage du service IA"
echo "========================================"
cd "$(dirname "$0")/.."
python3 -m venv venv
source venv/bin/activate
pip install -r ai_service/requirements.txt
python ai_service/app.py

