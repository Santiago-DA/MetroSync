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

  Future<bool> logIn(String username, String password) async {
  _isLoading = true;
  _errorMessage = null;

  
  try {
    final success = await _currentUser.loginUser(username, password);
    _isLoading = false;

    return success;
  } catch (e) {
    _isLoading = false;
    _errorMessage = 'Error en el login: ${e.toString()}';

    return false;
  }
}

  Future<bool> register(String username, String password,String email,String name, String lastname) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final success = await _currentUser.registerUser(username, password,email,name,lastname);
      _isLoading = false;
      if (success) {
        _errorMessage = null;
        return success;

      } else {
        _errorMessage = 'Credenciales inválidas';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error en el login: ${e.toString()}';
      _isLoading = false;
      return false;
    }
  }

  void logOut() {
    _currentUser = User();
    notifyListeners();
  }
}