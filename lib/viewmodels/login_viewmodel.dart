import 'package:dream_baby/core/network/api_result.dart';
import 'package:dream_baby/models/user_model.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String? _lastError;
  String? get lastError => _lastError;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<ApiResult<UserModel>> login(String phone, String password) async {
    _setLoading(true);
    _lastError = null;
    final result = await AuthService.login(phone, password);
    _lastError = result.errorMessage;
    _setLoading(false);
    return result;
  }

  Future<ApiResult<int>> forgotPassWord(String phone) async {
    _setLoading(true);
    _lastError = null;
    final result = await AuthService.forgotPassword(phone);
    _lastError = result.errorMessage;
    _setLoading(false);
    return result;
  }

  Future<ApiResult<int>> forgotPassWordVerifyOTPAndPassword(
    String newPassword,
    String confirmPassword,
    int? userId,
    String otp,
  ) async {
    _setLoading(true);
    _lastError = null;
    final result = await AuthService.forgotPassWordVerifyOTPAndPassword(
      newPassword,
      confirmPassword,
      userId,
      otp,
    );
    _lastError = result.errorMessage;
    _setLoading(false);
    return result;
  }

  Future<ApiResult<Map<String, dynamic>>> sendOtp(String phone) async {
    _setLoading(true);
    _lastError = null;
    final result = await AuthService.sendOtp(phone);
    _lastError = result.errorMessage;
    _setLoading(false);
    return result;
  }

  Future<ApiResult<Map<String, dynamic>>> verifyOtp(
    String phone,
    String otp,
    String userId,
  ) async {
    _setLoading(true);
    _lastError = null;
    final result = await AuthService.verifyOtp(phone, otp, userId);
    _lastError = result.errorMessage;
    _setLoading(false);
    return result;
  }
}
