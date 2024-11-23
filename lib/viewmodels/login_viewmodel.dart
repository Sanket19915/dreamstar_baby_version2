import 'package:dream_baby/models/user_model.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:flutter/material.dart';

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

  Future<Map<String, dynamic>?> sendOtp(String phone) async {
    _loading = true;
    notifyListeners();

    final user = await AuthService.sendOtp(phone);

    _loading = false;
    notifyListeners();

    return user;
  }

  Future<Map<String,dynamic>?> verifyOtp(String phone, String otp, String userId) async {
    _loading = true;
    notifyListeners();

    Map<String, dynamic>? userModel = await AuthService.verifyOtp(phone, otp, userId);

    _loading = false;
    notifyListeners();

    return userModel;
  }
}
