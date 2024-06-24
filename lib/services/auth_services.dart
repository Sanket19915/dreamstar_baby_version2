import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dream_baby/models/user_model.dart';

class AuthService {
  static const String _loginUrl = 'http://dreambaby.pro/api/auth/login';

  static Future<UserModel?> login(String phone, String password) async {
    var headers = {
      'Authorization': 'Bearer YOUR_API_KEY',
    };
    var request = http.MultipartRequest('POST', Uri.parse(_loginUrl));
    request.fields.addAll({
      'phone_no': phone,
      'password': password,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return UserModel.fromJson(json.decode(responseData));
    } else {
      print('Login failed:');

      const SnackBar(content: Text('Incorrect Credentials'));
    }
  }

  static Future<UserModel?> loginWithToken(String token) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('GET',
        Uri.parse(_loginUrl)); // Assuming token-based login uses a GET request
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return UserModel.fromJson(json.decode(responseData));
    } else {
      print('Token-based login failed: ${response.reasonPhrase}');
      return null;
    }
  }
}
