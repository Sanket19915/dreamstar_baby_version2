import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/network/api_result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PendingRegistration {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final String? profileImagePath;
  final String? dob;

  const PendingRegistration({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.profileImagePath,
    this.dob,
  });
}

class SignUpViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  PendingRegistration? _pending;

  void setPendingRegistration(PendingRegistration pending) {
    _pending = pending;
  }

  void clearPendingRegistration() {
    _pending = null;
  }

  Future<ApiResult<Map<String, dynamic>>> completePendingRegistration(
    Map<String, dynamic>? otpData,
  ) async {
    final pending = _pending;
    if (pending == null) {
      return ApiResult.failure('Registration data missing. Please try again.');
    }

    final userId = otpData?['user_id']?.toString() ?? '';
    final hasProfile = pending.profileImagePath != null &&
        pending.profileImagePath!.isNotEmpty;

    final result = hasProfile
        ? await signUpWithProfile(
            firstName: pending.firstName,
            lastName: pending.lastName,
            phone: pending.phone,
            email: pending.email,
            password: pending.password,
            confirmPassword: pending.confirmPassword,
            profileImage: pending.profileImagePath!,
            userId: userId,
            dob: pending.dob,
          )
        : await signUpWithoutProfile(
            firstName: pending.firstName,
            lastName: pending.lastName,
            phone: pending.phone,
            email: pending.email,
            password: pending.password,
            confirmPassword: pending.confirmPassword,
            userId: userId,
            dob: pending.dob,
          );

    if (result.isSuccess) {
      clearPendingRegistration();
    }
    return result;
  }

  Future<ApiResult<Map<String, dynamic>>> signUpWithProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String profileImage,
    required String userId,
    String? dob,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final body = await ApiClient.postMultipart(
        ApiConfig.registerInitial,
        {
          'first_name': firstName,
          'last_name': lastName,
          'phone_no': phone,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'user_id': userId,
          if (dob != null) 'dob': dob,
        },
        files: [
          await http.MultipartFile.fromPath('profile_pic', profileImage),
        ],
      );
      return ApiResult.success(body);
    } on ApiException catch (e) {
      return ApiResult.failure(
        e.message,
        statusCode: e.statusCode,
        fieldErrors: e.body != null
            ? ApiException.parseFieldErrors(e.body!)
            : null,
      );
    } catch (_) {
      return ApiResult.failure('Registration failed. Please try again.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<ApiResult<Map<String, dynamic>>> signUpWithoutProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String userId,
    String? dob,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final body = await ApiClient.postForm(
        ApiConfig.registerInitial,
        {
          'first_name': firstName,
          'last_name': lastName,
          'phone_no': phone,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'user_id': userId,
          if (dob != null) 'dob': dob,
        },
      );
      return ApiResult.success(body);
    } on ApiException catch (e) {
      return ApiResult.failure(
        e.message,
        statusCode: e.statusCode,
        fieldErrors: e.body != null
            ? ApiException.parseFieldErrors(e.body!)
            : null,
      );
    } catch (_) {
      return ApiResult.failure('Registration failed. Please try again.');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
