import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeService {
  static Future<Map<String, dynamic>> fetchActiveUser({
    String? deviceId,
    String? fcmToken,
  }) async {
    var body = {'device_Id': deviceId, 'fcm_Token': fcmToken};
    var uri = Uri.parse('https://dreambaby.pro/api/active_user');
    var response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
