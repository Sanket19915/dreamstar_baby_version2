import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/features/auth/model/notification_model.dart';
import 'package:dream_baby/services/auth_services.dart';

class NotificationServices {
  static Future<void> _ensureAuthenticated() async {
    if (!await AuthService.hasSession()) {
      throw ApiException(message: 'Not authenticated', statusCode: 401);
    }
  }

  static Future<Map<String, dynamic>> singleNotificationRead({
    required int notificationId,
  }) async {
    await _ensureAuthenticated();
    return ApiClient.postForm(
      ApiConfig.notificationRead(notificationId),
      {},
      authenticated: true,
    );
  }

  static Future<NotificationData> getAllNotification({
    required int page,
  }) async {
    await _ensureAuthenticated();
    final body = await ApiClient.get(
      ApiConfig.notifications(page: page),
      authenticated: true,
    );
    return NotificationData.fromJson(body);
  }

  static Future<Map<String, dynamic>> readAllnotification() async {
    await _ensureAuthenticated();
    return ApiClient.postForm(
      ApiConfig.notificationsReadAll,
      {},
      authenticated: true,
    );
  }

  static Future<Map<String, dynamic>> unreadNotificationCount() async {
    await _ensureAuthenticated();
    return ApiClient.get(
      ApiConfig.notificationsUnreadCount,
      authenticated: true,
    );
  }
}
