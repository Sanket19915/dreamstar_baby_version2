import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/network/api_result.dart';
import 'package:dream_baby/services/auth_services.dart';

class DarpanService {
  DarpanService._();

  static ApiResult<T> _failure<T>(Object error, String fallbackMessage) {
    if (error is ApiException) {
      return ApiResult.failure(
        error.message,
        statusCode: error.statusCode,
        fieldErrors: error.body == null
            ? null
            : ApiException.parseFieldErrors(error.body!),
      );
    }
    return ApiResult.failure(fallbackMessage);
  }

  static ApiResult<T> _notAuthenticated<T>() =>
      ApiResult.failure('Please log in again to continue.');

  static Future<ApiResult<Map<String, dynamic>>> getStatus() async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      final response = await ApiClient.get(ApiConfig.darpanStatus, authenticated: true);
      return ApiResult.success(response);
    } catch (e) {
      return _failure(e, 'Unable to load Darpan status. Please try again.');
    }
  }

  static Future<ApiResult<bool>> applyPromoCode(String promoCode) async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      await ApiClient.postForm(
        ApiConfig.darpanApplyPromo,
        {'promo_code': promoCode},
        authenticated: true,
      );
      return ApiResult.success(true);
    } catch (e) {
      return _failure(e, 'Unable to apply the promo code. Please try again.');
    }
  }

  static Future<ApiResult<List<dynamic>>> getQuestions() async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      final response = await ApiClient.get(ApiConfig.darpanQuestions, authenticated: true);
      // If the response is a list, Laravel returns it directly as a JSON array. 
      // _decodeBody wraps it in {'data': decoded} if it's not a map.
      if (response.containsKey('data') && response['data'] is List) {
        return ApiResult.success(response['data'] as List<dynamic>);
      }
      return ApiResult.failure('The Darpan questions response was invalid.');
    } catch (e) {
      return _failure(e, 'Unable to load Darpan questions. Please try again.');
    }
  }

  static Future<ApiResult<Map<String, dynamic>>> submitAssessment({
    required int cycleNumber,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      final response = await ApiClient.postJson(
        ApiConfig.darpanAssessments,
        {
          'cycle_number': cycleNumber,
          'answers': answers,
        },
        authenticated: true,
      );
      return ApiResult.success(response);
    } catch (e) {
      return _failure(e, 'Unable to submit the assessment. Please try again.');
    }
  }

  static Future<ApiResult<bool>> restartJourney() async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      await ApiClient.postJson(
        ApiConfig.darpanRestart,
        {},
        authenticated: true,
      );
      return ApiResult.success(true);
    } catch (e) {
      return _failure(e, 'Unable to restart the journey. Please try again.');
    }
  }

  /// Fetches the calculated Passive Lifestyle Score for a completed cycle.
  static Future<ApiResult<Map<String, dynamic>>> getScore(int cycleNumber) async {
    try {
      if (!await AuthService.hasSession()) return _notAuthenticated();
      final response = await ApiClient.get(
        ApiConfig.darpanScore(cycleNumber),
        authenticated: true,
      );
      return ApiResult.success(response);
    } catch (e) {
      return _failure(e, 'Unable to load your Darpan score. Please try again.');
    }
  }
}
