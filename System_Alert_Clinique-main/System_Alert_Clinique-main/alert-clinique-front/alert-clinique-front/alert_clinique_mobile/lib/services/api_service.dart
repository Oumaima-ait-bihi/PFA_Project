import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../models/medecin.dart';
import '../models/ai_prediction.dart';
import '../models/alert.dart';

class ApiService {
  // URL de base dynamique selon la plateforme
  // NOTE: Le port du backend Spring Boot est configuré sur 8082 dans application.properties
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8082/api';
    } else {
      return 'http://localhost:8082/api'; // Utiliser localhost pour tous les cas non-web
    }
  }

  // URL du service IA
  static String get aiServiceUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    } else {
      return 'http://localhost:5000';
    }
  }

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ============================================
  // PATIENTS - CRUD complet
  // ============================================

  static Future<List<Patient>> getPatients() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(
            'Timeout: Le serveur ne répond pas. Vérifiez que le backend Spring Boot est démarré sur le port 8082.'
          );
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des patients: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception(
        'Erreur de connexion: Impossible de se connecter à $baseUrl.\n'
        'Vérifiez que:\n'
        '1. Le backend Spring Boot est démarré sur le port 8082\n'
        '2. Vous utilisez un émulateur Android (10.0.2.2) ou iOS (localhost)\n'
        '3. Pour un appareil physique, utilisez l\'IP de votre machine\n'
        'Erreur: $e'
      );
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  static Future<Patient> getPatientById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Patient.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur lors du chargement du patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Patient> createPatient(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patients'),
        headers: headers,
        body: json.encode(patient.toJsonForCreate()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Patient.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur lors de la création du patient');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Patient> updatePatient(int id, Patient patient) async {
    try {
      // Pour la mise à jour, on envoie tous les champs sauf l'id qui est dans l'URL
      final patientData = patient.toJson();
      patientData.remove('id'); // Retirer l'id du body car il est dans l'URL
      
      final response = await http.put(
        Uri.parse('$baseUrl/patients/$id'),
        headers: headers,
        body: json.encode(patientData),
      );

      if (response.statusCode == 200) {
        return Patient.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur lors de la mise à jour du patient');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<void> deletePatient(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/patients/$id'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression du patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // ============================================
  // MEDECINS - CRUD complet
  // ============================================

  static Future<List<Medecin>> getMedecins() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medecins'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Medecin.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des médecins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Medecin> getMedecinById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medecins/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Medecin.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur lors du chargement du médecin: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Medecin> createMedecin(Medecin medecin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medecins'),
        headers: headers,
        body: json.encode(medecin.toJsonForCreate()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Medecin.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur lors de la création du médecin');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Medecin> updateMedecin(int id, Medecin medecin) async {
    try {
      // Pour la mise à jour, on envoie tous les champs sauf l'id qui est dans l'URL
      final medecinData = medecin.toJson();
      medecinData.remove('id'); // Retirer l'id du body car il est dans l'URL
      
      final response = await http.put(
        Uri.parse('$baseUrl/medecins/$id'),
        headers: headers,
        body: json.encode(medecinData),
      );

      if (response.statusCode == 200) {
        return Medecin.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur lors de la mise à jour du médecin');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<void> deleteMedecin(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/medecins/$id'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression du médecin: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // ============================================
  // SERVICE IA - Prédictions
  // ============================================

  static Future<bool> checkAIServiceHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$aiServiceUrl/health'),
        headers: headers,
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['model_loaded'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<AIPrediction> predictAISimple({
    required int patientId,
    required double heartRate,
    required double hrVariability,
    required int steps,
    required double moodScore,
    required double sleepDurationHours,
    required double sleepEfficiency,
    required int numAwakenings,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/predict/simple'),
        headers: headers,
        body: json.encode({
          'patientId': patientId,
          'heartRate': heartRate,
          'hrVariability': hrVariability,
          'steps': steps,
          'moodScore': moodScore,
          'sleepDurationHours': sleepDurationHours,
          'sleepEfficiency': sleepEfficiency,
          'numAwakenings': numAwakenings,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Le backend retourne {success: true, prediction: {...}, error: null}
        // Il faut extraire les données de 'prediction'
        if (data['prediction'] != null) {
          final predictionData = data['prediction'];
          return AIPrediction.fromJson({
            'anomaly_score': predictionData['anomaly_score'],
            'alert_flag': predictionData['alert_flag'],
            'threshold_used': predictionData['threshold_used'],
            'confidence': predictionData['confidence'],
          });
        } else {
          // Fallback: essayer de parser directement
          return AIPrediction.fromJson(data);
        }
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['error'] ?? errorBody['message'] ?? 'Erreur lors de la prédiction IA');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au service IA: $e');
    }
  }

  // ============================================
  // ALERTES - CRUD
  // ============================================

  static Future<List<Alert>> getAlertes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alertes'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Alert.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des alertes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<Alert> createAlerte({
    required int patientId,
    required String patientName,
    required String type,
    required String description,
    required AlertSeverity severity,
    bool isAIGenerated = false,
    double? confidenceScore,
    double? anomalyScore,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alertes'),
        headers: headers,
        body: json.encode({
          'patientId': patientId,
          'patientName': patientName,
          'type': type,
          'description': description,
          'severity': severity.toString().split('.').last,
          'status': 'pending',
          'isAIGenerated': isAIGenerated,
          'confidenceScore': confidenceScore,
          'anomalyScore': anomalyScore,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Alert.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur lors de la création de l\'alerte');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<void> deleteAlerte(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/alertes/$id'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de l\'alerte: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}

