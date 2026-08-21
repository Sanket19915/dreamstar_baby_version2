import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/models/popup_model.dart';
import 'package:dream_baby/services/auth_services.dart';

class PopupService {
  /// Fetch today's popup question. Returns null if already responded or no popup available.
  static Future<PopupQuestion?> fetchTodayPopup() async {
    try {
      if (!await AuthService.hasSession()) return null;

      final response = await ApiClient.get(
        ApiConfig.popupToday,
        authenticated: true,
      );

      final already = response['already_responded'] == true;
      if (already) return null;

      final popupData = response['popup'];
      if (popupData == null) return null;

      return PopupQuestion.fromJson(popupData as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Submit a response to today's popup. Returns streak/badge data.
  static Future<PopupRespondResult?> submitResponse({
    required int popupId,
    required String response,
  }) async {
    try {
      if (!await AuthService.hasSession()) return null;

      final result = await ApiClient.postForm(
        ApiConfig.popupRespond,
        {
          'popup_id': popupId.toString(),
          'response': response,
        },
        authenticated: true,
      );

      return PopupRespondResult.fromJson(result);
    } catch (_) {
      return null;
    }
  }

  /// Fetch the user's current streak and badge data.
  static Future<StreakData?> fetchStreak() async {
    try {
      if (!await AuthService.hasSession()) return null;

      final response = await ApiClient.get(
        ApiConfig.popupStreak,
        authenticated: true,
      );

      return StreakData.fromJson(response);
    } catch (_) {
      return null;
    }
  }
}
