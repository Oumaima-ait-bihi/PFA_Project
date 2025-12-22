"""
Script de test pour diagnostiquer le chargement du modèle
"""
import sys
from pathlib import Path

# Ajouter le répertoire AI au path
ai_dir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ai_dir))

# root_dir pour les artifacts
root_dir = Path(__file__).resolve().parent.parent.parent

MODEL_PATH = root_dir / "artifacts" / "supervised_pipeline.joblib"
THRESHOLD_PATH = root_dir / "artifacts" / "supervised_threshold.json"

print("="*70)
print("TEST DE CHARGEMENT DU MODÈLE")
print("="*70)
print(f"Root dir: {root_dir}")
print(f"Model path: {MODEL_PATH}")
print(f"Model exists: {MODEL_PATH.exists()}")
print(f"Threshold path: {THRESHOLD_PATH}")
print(f"Threshold exists: {THRESHOLD_PATH.exists()}")
print()

if not MODEL_PATH.exists():
    print("ERREUR: Le fichier modèle n'existe pas!")
    sys.exit(1)

if not THRESHOLD_PATH.exists():
    print("ERREUR: Le fichier seuil n'existe pas!")
    sys.exit(1)

try:
    print("Importation de load_supervised_model...")
    from src.preprocessing_supervised import load_supervised_model
    print("OK: Import réussi")
    
    print(f"\nChargement du modèle depuis: {MODEL_PATH}")
    pipeline = load_supervised_model(str(MODEL_PATH))
    print("OK: Modèle chargé avec succès!")
    
    print(f"\nChargement du seuil depuis: {THRESHOLD_PATH}")
    import json
    with open(THRESHOLD_PATH, "r") as f:
        threshold_data = json.load(f)
    threshold = threshold_data.get('tau', 0.5)
    print(f"OK: Seuil chargé: {threshold:.4f}")
    
    print("\n" + "="*70)
    print("SUCCÈS: Le modèle peut être chargé correctement!")
    print("="*70)
    
except Exception as e:
    print(f"\nERREUR lors du chargement: {e}")
    print(f"Type d'erreur: {type(e).__name__}")
    import traceback
    print("\nTraceback complet:")
    traceback.print_exc()
    sys.exit(1)

