import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

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

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Simulate authentication check
      // In a real app, this would be an API call
      if (email == 'patient@demo.com' && password == 'demo123') {
        _user = User(
          id: '1',
          name: 'Jean Dupont',
          email: email,
          role: UserRole.patient,
        );
      } else if (email == 'doctor@demo.com' && password == 'demo123') {
        _user = User(
          id: '2',
          name: 'Dr. Hasna Ait Ben Brahim',
          email: email,
          role: UserRole.doctor,
        );
      } else {
        // For demo: create user based on role
        _user = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: role == UserRole.patient ? 'Jean Dupont' : 'Dr. Hasna Ait Ben Brahim',
          email: email,
          role: role,
        );
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

