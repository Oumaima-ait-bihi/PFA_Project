"""
Service Flask pour exposer les prédictions IA via API REST
"""
import sys
import os
from pathlib import Path

# Ajouter le répertoire AI au path pour importer les modules
# app.py est dans AI/ai_service/, donc parent.parent = AI/
ai_dir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ai_dir))

# root_dir pour les artifacts (modèles) - remonter jusqu'à la racine du projet
root_dir = Path(__file__).resolve().parent.parent.parent

from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import numpy as np
import json
from joblib import load
from src.preprocessing_supervised import build_features_patient_centric, load_supervised_model, predict_with_supervised_model

app = Flask(__name__)
CORS(app)  # Permettre les requêtes CORS depuis le frontend

# Charger le modèle au démarrage
MODEL_PATH = root_dir / "artifacts" / "supervised_pipeline.joblib"
THRESHOLD_PATH = root_dir / "artifacts" / "supervised_threshold.json"

print("="*70)
print("CHARGEMENT DU MODÈLE IA...")
print("="*70)
print(f"[DEBUG] root_dir: {root_dir}")
print(f"[DEBUG] MODEL_PATH: {MODEL_PATH}")
print(f"[DEBUG] MODEL_PATH existe: {MODEL_PATH.exists()}")
print(f"[DEBUG] THRESHOLD_PATH: {THRESHOLD_PATH}")
print(f"[DEBUG] THRESHOLD_PATH existe: {THRESHOLD_PATH.exists()}")

pipeline = None
threshold = 0.5

try:
    if not MODEL_PATH.exists():
        raise FileNotFoundError(f"Le fichier modèle n'existe pas: {MODEL_PATH}")
    
    if not THRESHOLD_PATH.exists():
        raise FileNotFoundError(f"Le fichier seuil n'existe pas: {THRESHOLD_PATH}")
    
    print(f"[INFO] Chargement du modèle depuis: {MODEL_PATH}")
    pipeline = load_supervised_model(str(MODEL_PATH))
    print(f"[OK] Modèle chargé avec succès!")
    
    with open(THRESHOLD_PATH, "r") as f:
        threshold_data = json.load(f)
    threshold = threshold_data.get('tau', 0.5)
    print(f"[OK] Seuil chargé: {threshold:.4f}")
    
    print("[OK] Service IA prêt!")
    print("="*70)
except FileNotFoundError as e:
    print(f"[ERREUR] Fichier non trouvé: {e}")
    print(f"[INFO] Vérifiez que les fichiers existent dans le répertoire artifacts/")
    pipeline = None
    threshold = 0.5
except Exception as e:
    print(f"[ERREUR] Erreur lors du chargement du modèle: {e}")
    print(f"[ERREUR] Type d'erreur: {type(e).__name__}")
    import traceback
    print(f"[ERREUR] Traceback complet:")
    traceback.print_exc()
    pipeline = None
    threshold = 0.5


@app.route('/', methods=['GET'])
def index():
    """Endpoint racine qui affiche les informations du service"""
    return jsonify({
        'service': 'AI Prediction Service',
        'version': '1.0.0',
        'status': 'running',
        'model_loaded': pipeline is not None,
        'endpoints': {
            'health': '/health',
            'predict': '/predict (POST)',
            'predict_batch': '/predict/batch (POST)'
        },
        'usage': {
            'health_check': 'GET /health',
            'single_prediction': 'POST /predict',
            'batch_prediction': 'POST /predict/batch'
        }
    })


@app.route('/health', methods=['GET'])
def health():
    """Endpoint de santé pour vérifier que le service est actif"""
    return jsonify({
        'status': 'healthy',
        'model_loaded': pipeline is not None
    })


@app.route('/predict', methods=['POST'])
def predict():
    """
    Endpoint pour faire des prédictions IA.
    
    Body attendu (JSON):
    {
        "patient_id": int,
        "heart_rate": float,
        "hr_variability": float,
        "steps": int,
        "mood_score": float,
        "sleep_duration_hours": float,
        "sleep_efficiency": float,
        "num_awakenings": int,
        "age": int,
        "day_of_week": int (0-6),
        "weekend": bool,
        "medication_taken": bool,
        "is_female": bool,
        "date": string (format: "YYYY-MM-DD")
    }
    """
    if pipeline is None:
        return jsonify({
            'error': 'Modèle non chargé'
        }), 500
    
    try:
        data = request.json
        
        # Valider les données requises
        required_fields = [
            'patient_id', 'heart_rate', 'hr_variability', 'steps',
            'mood_score', 'sleep_duration_hours', 'sleep_efficiency',
            'num_awakenings', 'age', 'day_of_week', 'weekend',
            'medication_taken', 'is_female', 'date'
        ]
        
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({
                'error': f'Champs manquants: {", ".join(missing_fields)}'
            }), 400
        
        # Créer un DataFrame avec les données
        df = pd.DataFrame([{
            'patient_id': data['patient_id'],
            'date': data['date'],
            'heart_rate': float(data['heart_rate']),
            'hr_variability': float(data['hr_variability']),
            'steps': int(data['steps']),
            'mood_score': float(data['mood_score']),
            'sleep_duration_hours': float(data['sleep_duration_hours']),
            'sleep_efficiency': float(data['sleep_efficiency']),
            'num_awakenings': int(data['num_awakenings']),
            'age': int(data['age']),
            'day_of_week': int(data['day_of_week']),
            'weekend': bool(data['weekend']),
            'medication_taken': bool(data['medication_taken']),
            'is_female': bool(data['is_female'])
        }])
        
        # Feature engineering
        try:
            df_feat, num_cols, cat_cols = build_features_patient_centric(df, window=7)
            print(f"[INFO] Feature engineering réussi: {len(df_feat)} lignes, {len(num_cols)} num, {len(cat_cols)} cat")
        except Exception as e:
            print(f"[WARNING] Erreur lors du feature engineering: {e}")
            df_feat = None
        
        # Si le DataFrame est vide (première prédiction sans historique), utiliser le fallback
        if df_feat is None or len(df_feat) == 0:
            print(f"[WARNING] DataFrame vide après feature engineering")
            print(f"[INFO] Cela arrive car c'est la première prédiction (pas assez de données historiques)")
            print(f"[INFO] Le modèle nécessite au moins 3 données historiques pour calculer les rolling statistics")
            print(f"[INFO] Solution: Utiliser des valeurs par défaut pour les features manquantes")
            
            # Créer des features manuelles avec des valeurs par défaut pour la première prédiction
            # Les rolling statistics seront à 0 (pas de variation)
            df_feat = df.copy()
            
            # Ajouter les features de base sans rolling statistics
            continuous_vars = ['heart_rate', 'hr_variability', 'steps', 'mood_score',
                             'sleep_duration_hours', 'sleep_efficiency', 'num_awakenings']
            
            # Pour la première prédiction, les deltas et z-scores sont à 0 (pas de variation)
            for col in continuous_vars:
                if col in df_feat.columns:
                    df_feat[f"{col}_delta"] = 0.0
                    df_feat[f"{col}_z"] = 0.0
            
            # Ajouter les features dérivées
            if "steps" in df_feat.columns:
                df_feat["steps_log1p"] = np.log1p(df_feat["steps"])
            
            if "num_awakenings" in df_feat.columns and "sleep_duration_hours" in df_feat.columns:
                df_feat["awakenings_per_hour"] = df_feat["num_awakenings"] / df_feat["sleep_duration_hours"].clip(lower=0.5)
            
            if "day_of_week" in df_feat.columns:
                df_feat["dow_sin"] = np.sin(2 * np.pi * df_feat["day_of_week"] / 7)
                df_feat["dow_cos"] = np.cos(2 * np.pi * df_feat["day_of_week"] / 7)
            
            if "heart_rate" in df_feat.columns and "hr_variability" in df_feat.columns:
                hrv_clipped = df_feat["hr_variability"].clip(lower=1e-3)
                df_feat["hr_hrv_ratio"] = df_feat["heart_rate"] / hrv_clipped
            
            if "sleep_duration_hours" in df_feat.columns:
                df_feat["sleep_debt"] = np.maximum(0, 7.5 - df_feat["sleep_duration_hours"])
            
            # Définir num_cols et cat_cols pour le cas manuel (identique à preprocessing_supervised.py)
            num_cols = []
            for col in continuous_vars:
                if f"{col}_delta" in df_feat.columns:
                    num_cols.append(f"{col}_delta")
                if f"{col}_z" in df_feat.columns:
                    num_cols.append(f"{col}_z")
            
            if "steps_log1p" in df_feat.columns:
                num_cols.append("steps_log1p")
            if "awakenings_per_hour" in df_feat.columns:
                num_cols.append("awakenings_per_hour")
            if "hr_hrv_ratio" in df_feat.columns:
                num_cols.append("hr_hrv_ratio")
            if "sleep_debt" in df_feat.columns:
                num_cols.append("sleep_debt")
            if "age" in df_feat.columns:
                num_cols.append("age")
            if "dow_sin" in df_feat.columns:
                num_cols.append("dow_sin")
            if "dow_cos" in df_feat.columns:
                num_cols.append("dow_cos")
            
            cat_cols = []
            for col in ["weekend", "medication_taken", "is_female"]:
                if col in df_feat.columns:
                    cat_cols.append(col)
            
            # Filtrer pour ne garder que les colonnes qui existent
            num_cols = [col for col in num_cols if col in df_feat.columns]
            cat_cols = [col for col in cat_cols if col in df_feat.columns]
            
            print(f"[INFO] Features créées manuellement: {len(num_cols)} num, {len(cat_cols)} cat")
        
        # Sélectionner les features nécessaires
        X = df_feat[num_cols + cat_cols]
        
        # Faire la prédiction
        results = predict_with_supervised_model(
            pipeline,
            X,
            threshold=threshold,
            threshold_path=str(THRESHOLD_PATH)
        )
        
        # Extraire les résultats
        score = float(results['scores'][0])
        prediction = int(results['predictions'][0])
        threshold_used = float(results['threshold_used'])
        
        return jsonify({
            'success': True,
            'prediction': {
                'alert_flag': bool(prediction),
                'anomaly_score': score,
                'threshold_used': threshold_used,
                'confidence': abs(score - threshold_used)
            }
        })
        
    except Exception as e:
        import traceback
        return jsonify({
            'error': f'Erreur lors de la prédiction: {str(e)}',
            'traceback': traceback.format_exc()
        }), 500


@app.route('/predict/batch', methods=['POST'])
def predict_batch():
    """
    Endpoint pour faire des prédictions en batch.
    
    Body attendu (JSON):
    {
        "samples": [
            {
                "patient_id": int,
                "heart_rate": float,
                ...
            },
            ...
        ]
    }
    """
    if pipeline is None:
        return jsonify({
            'error': 'Modèle non chargé'
        }), 500
    
    try:
        data = request.json
        samples = data.get('samples', [])
        
        if not samples:
            return jsonify({
                'error': 'Aucun échantillon fourni'
            }), 400
        
        # Créer un DataFrame avec tous les échantillons
        df = pd.DataFrame(samples)
        
        # Feature engineering
        df_feat, num_cols, cat_cols = build_features_patient_centric(df, window=7)
        
        if len(df_feat) == 0:
            return jsonify({
                'error': 'Impossible de créer les features'
            }), 400
        
        # Sélectionner les features nécessaires
        X = df_feat[num_cols + cat_cols]
        
        # Faire les prédictions
        results = predict_with_supervised_model(
            pipeline,
            X,
            threshold=threshold,
            threshold_path=str(THRESHOLD_PATH)
        )
        
        # Formater les résultats
        predictions = []
        for i in range(len(results['scores'])):
            predictions.append({
                'alert_flag': bool(results['predictions'][i]),
                'anomaly_score': float(results['scores'][i]),
                'threshold_used': float(results['threshold_used']),
                'confidence': abs(float(results['scores'][i]) - float(results['threshold_used']))
            })
        
        return jsonify({
            'success': True,
            'predictions': predictions,
            'count': len(predictions)
        })
        
    except Exception as e:
        import traceback
        return jsonify({
            'error': f'Erreur lors de la prédiction batch: {str(e)}',
            'traceback': traceback.format_exc()
        }), 500


if __name__ == '__main__':
    print("\n" + "="*70)
    print("DÉMARRAGE DU SERVICE IA")
    print("="*70)
    print("Service disponible sur: http://localhost:5000")
    print("Endpoints:")
    print("  - GET  /health")
    print("  - POST /predict")
    print("  - POST /predict/batch")
    print("="*70 + "\n")
    
    app.run(host='0.0.0.0', port=5000, debug=True)

