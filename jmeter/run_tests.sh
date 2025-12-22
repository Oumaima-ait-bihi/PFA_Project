#!/bin/bash
# Script pour lancer les tests JMeter en mode non-GUI
# Usage: ./run_tests.sh [nombre_threads] [ramp_up] [loop_count]

# Configuration par défaut
BASE_URL="http://localhost:8080"
THREADS=${1:-10}
RAMP_UP=${2:-10}
LOOP_COUNT=${3:-1}

# Vérifier que JMeter est installé
if ! command -v jmeter &> /dev/null; then
    echo "ERREUR: JMeter n'est pas dans le PATH"
    echo "Veuillez installer JMeter et l'ajouter au PATH"
    echo "Ou modifier ce script pour pointer vers votre installation JMeter"
    exit 1
fi

# Créer le dossier results s'il n'existe pas
mkdir -p results

# Générer un nom de fichier de résultats avec timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="results/results_${TIMESTAMP}.jtl"
HTML_REPORT="results/html-report_${TIMESTAMP}"

echo "========================================"
echo "Lancement des tests JMeter"
echo "========================================"
echo "URL Base: $BASE_URL"
echo "Threads: $THREADS"
echo "Ramp-up: $RAMP_UP secondes"
echo "Loop Count: $LOOP_COUNT"
echo "Fichier de résultats: $RESULTS_FILE"
echo "Rapport HTML: $HTML_REPORT"
echo "========================================"
echo ""

# Lancer JMeter en mode non-GUI
jmeter -n \
    -t plan_test_alert_clinique.jmx \
    -J BASE_URL="$BASE_URL" \
    -J THREADS="$THREADS" \
    -J RAMP_UP="$RAMP_UP" \
    -J LOOP_COUNT="$LOOP_COUNT" \
    -l "$RESULTS_FILE" \
    -e \
    -o "$HTML_REPORT"

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "Tests terminés avec succès!"
    echo "========================================"
    echo "Fichier de résultats: $RESULTS_FILE"
    echo "Rapport HTML: $HTML_REPORT/index.html"
    echo ""
    
    # Demander si on veut ouvrir le rapport (Linux/Mac)
    if command -v xdg-open &> /dev/null; then
        read -p "Ouvrir le rapport HTML? (O/N): " OPEN_REPORT
        if [[ "$OPEN_REPORT" == "O" || "$OPEN_REPORT" == "o" ]]; then
            xdg-open "$HTML_REPORT/index.html"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        read -p "Ouvrir le rapport HTML? (O/N): " OPEN_REPORT
        if [[ "$OPEN_REPORT" == "O" || "$OPEN_REPORT" == "o" ]]; then
            open "$HTML_REPORT/index.html"
        fi
    fi
else
    echo ""
    echo "========================================"
    echo "ERREUR lors de l'exécution des tests"
    echo "========================================"
    exit 1
fi

