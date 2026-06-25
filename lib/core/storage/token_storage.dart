import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  TokenStorage._();

  static const String _tokenKey = 'token';

  static Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_tokenKey);
    if (token == null) {
      token = prefs.getString('userToken');
      if (token != null) {
        await prefs.setString(_tokenKey, token);
        await prefs.remove('userToken');
      }
    }
    return token;
  }

  static Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove('userToken');
  }
}
