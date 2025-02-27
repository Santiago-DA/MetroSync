import 'package:flutter/material.dart';
import '../User/User.dart';

class VM extends ChangeNotifier {
  User _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  VM() : _currentUser = User();

  // Getters para acceder al estado desde la UI
  User get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> logIn(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final success = await _currentUser.loginUser(username, password);

      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Credenciales inválidas';
      }
    } catch (e) {
      _errorMessage = 'Error en el login: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String password,String email,String name, String lastname) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final success = await _currentUser.registerUser(username, password,email,name,lastname);
      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Credenciales inválidas';
      }
    } catch (e) {
      _errorMessage = 'Error en el login: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logOut() {
    _currentUser = User();
    notifyListeners();
  }
}