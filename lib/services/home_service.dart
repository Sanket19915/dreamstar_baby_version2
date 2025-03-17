import 'dart:convert';

import 'package:dream_baby/services/auth_services.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static Future<Map<String, dynamic>> fetchActiveUser({
    String? deviceId,
    String? fcmToken,
  }) async {
    var body = {'device_id': deviceId, 'fcm_token': fcmToken};
   String? token = await AuthService.getToken();
    var uri = Uri.parse('https://dreambaby.pro/api/active_user');
    var response = await http.post(uri, body: body, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
