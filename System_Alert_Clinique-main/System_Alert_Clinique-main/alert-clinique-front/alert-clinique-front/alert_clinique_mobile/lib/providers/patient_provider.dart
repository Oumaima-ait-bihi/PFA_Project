import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Charger tous les patients
  Future<void> loadPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _patients = await ApiService.getPatients();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _patients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtenir un patient par ID
  Future<Patient?> getPatientById(int id) async {
    try {
      return await ApiService.getPatientById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Créer un nouveau patient
  Future<bool> createPatient(Patient patient) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPatient = await ApiService.createPatient(patient);
      _patients.add(newPatient);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mettre à jour un patient
  Future<bool> updatePatient(int id, Patient patient) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedPatient = await ApiService.updatePatient(id, patient);
      final index = _patients.indexWhere((p) => p.id == id);
      if (index != -1) {
        _patients[index] = updatedPatient;
      }
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Supprimer un patient
  Future<bool> deletePatient(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.deletePatient(id);
      _patients.removeWhere((p) => p.id == id);
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Filtrer les patients par statut
  List<Patient> getPatientsByStatus(String status) {
    if (status == 'all') return _patients;
    return _patients.where((p) => p.status == status).toList();
  }

  // Rechercher des patients
  List<Patient> searchPatients(String query) {
    if (query.isEmpty) return _patients;
    final lowerQuery = query.toLowerCase();
    return _patients.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.id.toString().contains(lowerQuery) ||
          p.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Obtenir les statistiques
  Map<String, int> getStats() {
    return {
      'critical': _patients.where((p) => p.status == 'critical').length,
      'high': _patients.where((p) => p.status == 'high').length,
      'stable': _patients.where((p) => p.status == 'stable').length,
      'total': _patients.length,
    };
  }
}

