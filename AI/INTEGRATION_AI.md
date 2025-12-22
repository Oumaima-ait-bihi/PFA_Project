# Intégration IA - Frontend, Backend et Service Python

Ce document explique comment l'IA est intégrée avec le frontend et le backend.

## Architecture

```
Frontend Web (React/TypeScript) ──┐
                                   ├──→ Backend Java (Spring Boot) - Port 8080
Application Mobile (Flutter) ──────┘         ↓
                                    Service Python IA (Flask) - Port 5000
                                              ↓
                                    Modèle ML (supervised_pipeline.joblib)
```

## Composants

### 1. Service Python IA (`ai_service/app.py`)

Service Flask qui expose les prédictions IA via API REST.

**Endpoints:**
- `GET /health` - Vérifie que le service est actif
- `POST /predict` - Fait une prédiction avec données complètes
- `POST /predict/batch` - Fait des prédictions en batch

**Dépendances:**
- Flask
- Flask-CORS
- pandas, numpy, scikit-learn, joblib

### 2. Backend Java

**Service:** `AIService.java`
- Appelle le service Python IA
- Gère les erreurs de connexion
- Construit les requêtes de prédiction

**Contrôleur:** `AIController.java`
- `GET /api/ai/health` - Vérifie la disponibilité du service IA
- `POST /api/ai/predict` - Prédiction avec données complètes
- `POST /api/ai/predict/simple` - Prédiction simplifiée avec paramètres de base

**Configuration:** `application.properties`
```properties
ai.service.url=http://localhost:5000
```

### 3. Frontend

**Service API:** `src/lib/api.ts`

Fonctions disponibles:
- `checkAIServiceHealth()` - Vérifie si le service IA est disponible
- `predictAI(request)` - Prédiction avec données complètes
- `predictAISimple(...)` - Prédiction simplifiée

## Démarrage

### 1. Démarrer le service Python IA

**Windows:**
```bash
ai_service\start_ai_service.bat
```

**Linux/Mac:**
```bash
chmod +x ai_service/start_ai_service.sh
./ai_service/start_ai_service.sh
```

**Manuel:**
```bash
cd ai_service
pip install -r requirements.txt
python app.py
```

Le service sera disponible sur `http://localhost:5000`

### 2. Démarrer le backend Java

```bash
cd System_Alert_Clinique/System_Alert_Clinique/alert_clinique_back_end/alert-system
mvn spring-boot:run
```

Le backend sera disponible sur `http://localhost:8080`

### 3. Démarrer le frontend

```bash
cd System_Alert_Clinique/System_Alert_Clinique/alert-clinique-front/alert-clinique-front
npm install
npm run dev
```

## Utilisation dans le Frontend

### Exemple 1: Prédiction simple

```typescript
import { predictAISimple } from '@/lib/api';

const result = await predictAISimple(
  patientId: 1,
  age: 45,
  gender: 'M',
  heartRate: 85,
  {
    hrVariability: 50,
    steps: 5000,
    moodScore: 7.5,
    sleepDurationHours: 7.5,
    sleepEfficiency: 85,
    numAwakenings: 1,
    medicationTaken: false
  }
);

if (result.success && result.prediction) {
  console.log('Alerte:', result.prediction.alert_flag);
  console.log('Score d\'anomalie:', result.prediction.anomaly_score);
  console.log('Confiance:', result.prediction.confidence);
}
```

### Exemple 2: Prédiction complète

```typescript
import { predictAI, AIPredictionRequest } from '@/lib/api';

const request: AIPredictionRequest = {
  patient_id: 1,
  heart_rate: 85,
  hr_variability: 50,
  steps: 5000,
  mood_score: 7.5,
  sleep_duration_hours: 7.5,
  sleep_efficiency: 85,
  num_awakenings: 1,
  age: 45,
  day_of_week: 2, // Mercredi (0 = lundi)
  weekend: false,
  medication_taken: false,
  is_female: false,
  date: '2024-01-15'
};

const result = await predictAI(request);
```

### Exemple 3: Vérifier la disponibilité

```typescript
import { checkAIServiceHealth } from '@/lib/api';

const health = await checkAIServiceHealth();
if (health.available) {
  console.log('Service IA disponible');
} else {
  console.error('Service IA indisponible:', health.message);
}
```

## Format des données

### Requête de prédiction

```typescript
interface AIPredictionRequest {
  patient_id: number;
  heart_rate: number;              // BPM
  hr_variability: number;           // Variabilité du rythme cardiaque
  steps: number;                    // Nombre de pas
  mood_score: number;              // Score d'humeur (0-10)
  sleep_duration_hours: number;    // Durée du sommeil en heures
  sleep_efficiency: number;        // Efficacité du sommeil (%)
  num_awakenings: number;          // Nombre de réveils
  age: number;                     // Âge du patient
  day_of_week: number;             // 0-6 (0 = lundi, 6 = dimanche)
  weekend: boolean;                // Est-ce un weekend?
  medication_taken: boolean;        // Médication prise?
  is_female: boolean;              // Genre féminin?
  date: string;                     // Format: "YYYY-MM-DD"
}
```

### Réponse de prédiction

```typescript
interface AIPredictionResponse {
  success: boolean;
  prediction?: {
    alert_flag: boolean;           // Alerte détectée?
    anomaly_score: number;         // Score d'anomalie (0-1)
    threshold_used: number;        // Seuil utilisé
    confidence: number;            // Confiance de la prédiction
  };
  error?: string;                 // Message d'erreur si échec
}
```

## Dépannage

### Le service Python ne démarre pas

1. Vérifiez que Python 3.8+ est installé
2. Vérifiez que les dépendances sont installées: `pip install -r ai_service/requirements.txt`
3. Vérifiez que le modèle existe: `artifacts/supervised_pipeline.joblib`
4. Vérifiez que le fichier de seuil existe: `artifacts/supervised_threshold.json`

### Le backend ne peut pas se connecter au service Python

1. Vérifiez que le service Python est démarré sur le port 5000
2. Vérifiez la configuration dans `application.properties`: `ai.service.url=http://localhost:5000`
3. Testez manuellement: `curl http://localhost:5000/health`

### Le frontend ne peut pas appeler l'API IA

1. Vérifiez que le backend Java est démarré sur le port 8080
2. Vérifiez que CORS est configuré dans le backend
3. Vérifiez la console du navigateur pour les erreurs

## Application Mobile Flutter

L'application mobile Flutter est également intégrée avec l'IA. Voir la documentation complète dans:
- `alert_clinique_mobile/INTEGRATION_AI_MOBILE.md`

### Utilisation rapide dans Flutter

```dart
import 'package:alert_clinique_mobile/services/api_service.dart';

// Prédiction simplifiée
final response = await ApiService.predictAISimple(
  patientId: 1,
  age: 45,
  gender: 'M',
  heartRate: 85.0,
);

if (response.success && response.prediction != null) {
  print('Alerte: ${response.prediction!.alertFlag}');
}
```

### Configuration Mobile

L'URL de base est configurée dans `lib/services/api_service.dart`:
- **Android Emulator**: `http://10.0.2.2:8080/api`
- **iOS Simulator**: `http://localhost:8080/api`
- **Appareil physique**: `http://VOTRE_IP:8080/api`

## Notes importantes

- Le modèle IA nécessite des données historiques pour calculer les rolling statistics. Pour une première prédiction, il peut y avoir des valeurs manquantes.
- Le service Python doit être démarré avant le backend Java.
- Le port 5000 doit être libre pour le service Python.
- Le port 8080 doit être libre pour le backend Java.
- **Mobile**: Pour un appareil physique, utilisez l'IP locale de votre machine sur le réseau WiFi.

