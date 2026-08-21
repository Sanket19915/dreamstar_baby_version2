import 'package:dream_baby/core/auth/auth_notifier.dart';
import 'package:dream_baby/core/auth/auth_token.dart';
import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/connectivity_service.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/network/api_result.dart';
import 'package:dream_baby/core/storage/token_storage.dart';
import 'package:dream_baby/models/user_model.dart';

class AuthService {
  AuthService._();

  static Future<bool> hasSession() async {
    final token = await TokenStorage.read();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> requireToken() async {
    final token = await TokenStorage.read();
    if (token == null || token.isEmpty) return null;
    return token;
  }

  static Future<void> establishSession(String token) async {
    await TokenStorage.save(token);
    authNotifier.markAuthenticated();
  }

  static Future<void> logout() async {
    await TokenStorage.delete();
    authNotifier.markUnauthenticated();
  }

  static Future<ApiResult<UserModel>> validateSession() async {
    try {
      final stored = await requireToken();
      if (stored == null) {
        return ApiResult.failure('Not authenticated');
      }

      final online = await connectivityService.checkOnline();
      if (!online) {
        if (ProfileCache.read() != null) {
          return ApiResult.success(UserModel(phoneNo: '', token: stored));
        }
        return ApiResult.failure('You are offline. Connect to validate session.');
      }

      final body = await ApiClient.get(
        ApiConfig.profile,
        authenticated: true,
      );
      await ProfileCache.save(body);
      return ApiResult.success(UserModel(
        phoneNo: body['phone_no']?.toString() ?? '',
        token: stored,
      ));
    } on ApiException catch (_) {
      await logout();
      return ApiResult.failure('Session expired. Please log in again.');
    } catch (_) {
      return ApiResult.failure('Unable to restore session.');
    }
  }

  static Future<ApiResult<UserModel>> login(
      String phone, String password) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.login,
        {'phone_no': phone, 'password': password},
      );
      final user = UserModel.fromJson(body);
      final token =
          user.token.isNotEmpty ? user.token : AuthToken.extract(body);
      if (token == null || token.isEmpty) {
        return ApiResult.failure('Login failed. No access token received.');
      }
      await establishSession(token);
      try {
        final profileBody = await ApiClient.get(ApiConfig.profile, authenticated: true);
        await ProfileCache.save(profileBody);
      } catch (e) {
        // Ignore profile fetch failure here, it can be retried later
      }
      return ApiResult.success(UserModel(phoneNo: user.phoneNo, token: token));
    } on ApiException catch (e) {
      return ApiResult.failure(
        e.message,
        statusCode: e.statusCode,
        fieldErrors: e.body != null
            ? ApiException.parseFieldErrors(e.body!)
            : null,
      );
    } catch (_) {
      return ApiResult.failure('Unable to connect. Please check your internet.');
    }
  }

  /// @deprecated Use [validateSession] instead.
  static Future<ApiResult<UserModel>> loginWithToken(String token) =>
      validateSession();

  static Future<ApiResult<int>> forgotPassword(String phone) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.forgotPassword,
        {'phone_no': phone},
      );
      final userId = body['user_id'];
      if (userId == null) {
        return ApiResult.failure('Could not start password reset.');
      }
      return ApiResult.success(userId is int ? userId : int.parse('$userId'));
    } on ApiException catch (e) {
      return ApiResult.failure(
        e.message,
        statusCode: e.statusCode,
        fieldErrors: e.body != null
            ? ApiException.parseFieldErrors(e.body!)
            : null,
      );
    } catch (_) {
      return ApiResult.failure('Unable to connect. Please try again.');
    }
  }

  static Future<ApiResult<int>> forgotPassWordVerifyOTPAndPassword(
    String newPassword,
    String confirmPassword,
    int? userId,
    String otp,
  ) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.resetPassword,
        {
          'user_id': userId.toString(),
          'otp': otp,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );
      // Backend returns {success: true, message: '...'} on success
      final isSuccess = body['success'] == true ||
          body['message']?.toString().contains('reset') == true;
      if (isSuccess) {
        return ApiResult.success(userId ?? 0);
      }
      return ApiResult.failure(
        body['message']?.toString() ?? 'Password reset failed.',
      );
    } on ApiException catch (e) {
      return ApiResult.failure(
        e.message,
        statusCode: e.statusCode,
        fieldErrors: e.body != null
            ? ApiException.parseFieldErrors(e.body!)
            : null,
      );
    } catch (_) {
      return ApiResult.failure('Unable to connect. Please try again.');
    }
  }

  static Future<ApiResult<Map<String, dynamic>>> sendOtp(String phone) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.sendOtp,
        {'mobile_number': phone},
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
      return ApiResult.failure('Unable to send OTP. Please try again.');
    }
  }

  static Future<ApiResult<Map<String, dynamic>>> verifyOtp(
    String phone,
    String otp,
    String userId,
  ) async {
    try {
      final body = await ApiClient.postForm(
        ApiConfig.verifyOtp,
        {
          'mobile_number': phone,
          'otp': otp,
          'user_id': userId,
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
      return ApiResult.failure('Unable to verify OTP. Please try again.');
    }
  }

  static Future<void> saveToken(String token) => establishSession(token);

  static Future<String?> getToken() => TokenStorage.read();

  static Future<void> deleteToken() => logout();
}
