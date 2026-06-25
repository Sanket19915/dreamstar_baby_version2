import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/services/auth_services.dart';

class HomeService {
  static Future<Map<String, dynamic>> fetchActiveUser({
    String? deviceId,
    String? fcmToken,
  }) async {
    if (!await AuthService.hasSession()) {
      throw Exception('Not authenticated');
    }

    return ApiClient.postForm(
      ApiConfig.activeUser,
      {
        if (deviceId != null) 'device_id': deviceId,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
      authenticated: true,
    );
  }
}
