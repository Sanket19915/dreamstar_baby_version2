import 'package:dream_baby/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:dream_baby/models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<UserModel?> login(String phone, String password) async {
    _loading = true;
    notifyListeners();

    final user = await AuthService.login(phone, password);

    _loading = false;
    notifyListeners();

    return user;
  }
}
