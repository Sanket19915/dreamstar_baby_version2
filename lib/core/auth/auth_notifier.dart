import 'package:flutter/foundation.dart';

/// Notifies [GoRouter] when authentication state changes.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier._();

  static final AuthNotifier instance = AuthNotifier._();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void markAuthenticated() {
    if (_isAuthenticated) return;
    _isAuthenticated = true;
    notifyListeners();
  }

  void markUnauthenticated() {
    if (!_isAuthenticated) return;
    _isAuthenticated = false;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier.instance;
