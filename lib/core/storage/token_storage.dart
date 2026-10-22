import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  TokenStorage._();

  static const String _tokenKey = 'token';
  static const String _legacyTokenKey = 'userToken';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> save(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_legacyTokenKey);
  }

  static Future<String?> read() async {
    final secureToken = await _secureStorage.read(key: _tokenKey);
    if (secureToken != null && secureToken.isNotEmpty) {
      return secureToken;
    }

    final prefs = await SharedPreferences.getInstance();
    final legacyToken = prefs.getString(_tokenKey) ??
        prefs.getString(_legacyTokenKey);
    if (legacyToken == null || legacyToken.isEmpty) {
      return null;
    }

    await _secureStorage.write(key: _tokenKey, value: legacyToken);
    await prefs.remove(_tokenKey);
    await prefs.remove(_legacyTokenKey);
    return legacyToken;
  }

  static Future<void> delete() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_legacyTokenKey);
    }
  }
}
