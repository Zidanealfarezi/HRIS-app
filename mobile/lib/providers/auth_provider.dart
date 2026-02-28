import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api;
  AuthUser? _user;
  bool _isLoading = false;
  String? _error;
  bool _isDarkMode = false;

  AuthProvider(this._api);

  AuthUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.login(email, password);
      _user = AuthUser.fromJson(data['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    try {
      _user = await _api.getProfile();
      notifyListeners();
    } catch (_) {}
  }
}
