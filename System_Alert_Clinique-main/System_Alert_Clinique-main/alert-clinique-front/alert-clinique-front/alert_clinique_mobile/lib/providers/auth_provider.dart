import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  // URL de base de l'API
  static const String baseUrl = 'http://localhost:8082/api';

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password, UserRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Veuillez remplir tous les champs');
      }

      if (!email.contains('@')) {
        throw Exception('Email invalide');
      }

      if (password.length < 6) {
        throw Exception('Le mot de passe doit contenir au moins 6 caractères');
      }

      // Appel API réel au backend
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'userType': role == UserRole.doctor ? 'medecin' : 'patient',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Utiliser le nom du patient/médecin depuis la réponse API
          final userName = data['userName'] ?? email.split('@')[0];
          final userId = data['userId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
          final userEmail = data['email'] ?? email;
          
          _user = User(
            id: userId,
            name: userName, // Nom réel du patient/médecin depuis la base de données
            email: userEmail,
            role: role,
          );
        } else {
          throw Exception(data['message'] ?? 'Erreur d\'authentification');
        }
      } else if (response.statusCode == 401) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Email ou mot de passe incorrect');
      } else {
        throw Exception('Erreur de connexion au serveur (${response.statusCode})');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    UserRole role,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate inputs
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Veuillez remplir tous les champs');
      }

      if (!email.contains('@')) {
        throw Exception('Email invalide');
      }

      if (password.length < 6) {
        throw Exception('Le mot de passe doit contenir au moins 6 caractères');
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would create the user via API
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

