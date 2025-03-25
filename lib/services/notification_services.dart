import 'dart:convert';

import '../features/auth/model/notification_model.dart';
import 'auth_services.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
 
  static Future<Map<String, dynamic>> singleNotificationRead({required int notificationId}) async {
    String? token = await AuthService.getToken();
    var uri = Uri.parse('https://dreambaby.pro/api/notifications/$notificationId/read');
    var response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get detail of notification');
    }
  }

  static Future<NotificationData> getAllNotification({required int page  }) async {
    String? token = await AuthService.getToken();
    var uri = Uri.parse('https://dreambaby.pro/api/notifications?page=${page}');
    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      NotificationData notificationData = notificationDataFromJson(response.body);
      
      return notificationData;
    } else {
      throw Exception('Failed to load notification');
    }
  }

  static Future<Map<String, dynamic>> readAllnotification() async {
    String? token = await AuthService.getToken();
    var uri = Uri.parse('https://dreambaby.pro/api/notifications/read-all');
    var response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to mark as read');
    }
  }

  static Future<Map<String, dynamic>> unreadNotificationCount() async {
    String? token = await AuthService.getToken();
    var uri = Uri.parse('https://dreambaby.pro/api/notifications/unread-count');
    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to read notification');
    }
  }
}
