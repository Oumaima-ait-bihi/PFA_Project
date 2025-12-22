"""
Script de vérification complète de tous les liens dans le projet
"""
from pathlib import Path
import sys

# Définir le répertoire racine
ROOT = Path(__file__).parent

def verifier_fichier(chemin_relatif, description=""):
    """Vérifie si un fichier existe"""
    chemin = ROOT / chemin_relatif
    existe = chemin.exists()
    status = "[OK]" if existe else "[MANQUANT]"
    print(f"{status} {chemin_relatif} {description}")
    return existe

def verifier_import(module_name):
    """Vérifie si un module peut être importé"""
    try:
        __import__(module_name)
        print(f"[OK] Import {module_name}: OK")
        return True
    except ImportError as e:
        print(f"[ERREUR] Import {module_name}: ERREUR - {e}")
        return False
    except Exception as e:
        print(f"[WARNING] Import {module_name}: WARNING - {e}")
        return False

print("="*70)
print("VÉRIFICATION COMPLÈTE DES LIENS")
print("="*70)

# Ajouter le répertoire racine au path
sys.path.insert(0, str(ROOT))

print("\n[1] Vérification des fichiers Python...")
fichiers_py = [
    ("ai_service/app.py", "Service Flask principal"),
    ("src/preprocessing_supervised.py", "Module de preprocessing"),
    ("src/inference_utils.py", "Utilitaires d'inférence"),
    ("src/train_supervised.py", "Script d'entraînement"),
]

resultats_py = []
for fichier, desc in fichiers_py:
    resultats_py.append(verifier_fichier(fichier, desc))

print("\n[2] Vérification des fichiers de configuration...")
fichiers_config = [
    ("ai_service/requirements.txt", "Dépendances Python"),
    ("ai_service/start_ai_service.bat", "Script démarrage Windows"),
    ("ai_service/start_ai_service.sh", "Script démarrage Linux/Mac"),
]

resultats_config = []
for fichier, desc in fichiers_config:
    resultats_config.append(verifier_fichier(fichier, desc))

print("\n[3] Vérification des fichiers d'artefacts...")
fichiers_artifacts = [
    ("artifacts/supervised_pipeline.joblib", "Modèle ML entraîné"),
    ("artifacts/supervised_threshold.json", "Fichier de seuil"),
    ("artifacts/supervised_test_metrics.json", "Métriques de test"),
    ("artifacts/supervised_test_pr.png", "Courbe Precision-Recall"),
    ("artifacts/supervised_test_roc.png", "Courbe ROC"),
]

resultats_artifacts = []
for fichier, desc in fichiers_artifacts:
    resultats_artifacts.append(verifier_fichier(fichier, desc))

print("\n[4] Vérification des fichiers de données...")
fichiers_data = [
    ("data/clinical_alerts.csv", "Données d'entraînement"),
]

resultats_data = []
for fichier, desc in fichiers_data:
    resultats_data.append(verifier_fichier(fichier, desc))

print("\n[5] Vérification des imports Python...")
imports = [
    "src.preprocessing_supervised",
    "src.inference_utils",
    "src.train_supervised",
]

resultats_imports = []
for module in imports:
    resultats_imports.append(verifier_import(module))

print("\n[6] Vérification des fonctions utilisées dans app.py...")
try:
    from src.preprocessing_supervised import (
        build_features_patient_centric,
        load_supervised_model,
        predict_with_supervised_model
    )
    print("[OK] build_features_patient_centric: OK")
    print("[OK] load_supervised_model: OK")
    print("[OK] predict_with_supervised_model: OK")
    resultats_fonctions = True
except ImportError as e:
    print(f"[ERREUR] Erreur import fonctions: {e}")
    resultats_fonctions = False

print("\n" + "="*70)
print("RÉSUMÉ")
print("="*70)

total_fichiers = len(resultats_py) + len(resultats_config) + len(resultats_artifacts) + len(resultats_data)
fichiers_ok = sum(resultats_py) + sum(resultats_config) + sum(resultats_artifacts) + sum(resultats_data)
imports_ok = sum(resultats_imports)

print(f"\nFichiers: {fichiers_ok}/{total_fichiers} présents")
print(f"Imports: {imports_ok}/{len(imports)} fonctionnels")
print(f"Fonctions: {'[OK] OK' if resultats_fonctions else '[ERREUR] ERREUR'}")

if fichiers_ok == total_fichiers and imports_ok == len(imports) and resultats_fonctions:
    print("\n[OK] TOUS LES LIENS SONT CORRECTS!")
else:
    print("\n[WARNING] Certains liens necessitent une attention")

print("="*70)

