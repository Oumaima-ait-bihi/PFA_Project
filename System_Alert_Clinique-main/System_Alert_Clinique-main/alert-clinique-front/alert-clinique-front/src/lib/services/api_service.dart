import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';
import '../models/medecin.dart';

class ApiService {
  // Pour Android emulator, utilisez 10.0.2.2 au lieu de localhost
  // Pour iOS simulator, utilisez localhost
  // Pour un appareil physique, utilisez l'IP de votre machine sur le réseau local
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8080/api'; // iOS simulator
  // static const String baseUrl = 'http://192.168.1.XXX:8080/api'; // Appareil physique (remplacez XXX par votre IP)

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
            'Timeout: Le serveur ne répond pas. Vérifiez que le backend Spring Boot est démarré sur le port 8080.'
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
        '1. Le backend Spring Boot est démarré sur le port 8080\n'
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
}

