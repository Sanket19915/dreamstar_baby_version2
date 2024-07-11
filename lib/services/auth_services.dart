import 'package:dream_baby/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loginUrl = 'http://dreambaby.pro/api/auth/login';

  static Future<UserModel?> login(String phone, String password) async {
    var headers = {
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6Ik5qTzE3bmxiUys1WXFIcEduNnlaSXc9PSIsInZhbHVlIjoiR3lHT2g1UkFkbURGNmNmS3JIZTZVUGJGZi8wdTBTL2VkNmx2Tks4Vjg1T2VmdUIxZ0dmQU5HOTZhNUFkK1VmZDBMUlRTU2F4eVFlUWlPS1BBQ2tWbUl6L1J0Y3FmSzRwcnZUdU53eDBjNzBNaUZYbHl6QklQRHlWaGlyOEdaN3UiLCJtYWMiOiJkMGYzMzFmZTdhZWIyMDdiMGVjMTE2NWYzZTJhNzljYjYwNWYwY2Q5YjliMDYwNjI2N2YwZWNiZGNmMTY0OTg3IiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6IkNNbGV4U1NZZldrbFo3c09jaE9lZkE9PSIsInZhbHVlIjoiVk5SQjRpQ090QUloWWNmeHFPdloxNWJoQk4wcVExWWpkY0I3NmxrUThEbXo3ZVFBdERHQWRkcEFyazczK0tERXFBZUlJc1ZNYmhBcmVHUmpRbVEyamVpT29WS09tQllvWEdnMFErSENFN25FVDZJclhSNGJVd0NrSWxTQXZVSk4iLCJtYWMiOiJiMmQwNTAzZmUyNGMzNmQ1YWZkNTAxZWJjNTg3MjE4NzE3OTEyZWY4NmMzMmQ3NmY4MjlmYzUxMWNhMTMxYTllIiwidGFnIjoiIn0%3D'
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
      var userModel = UserModel.fromJson(json.decode(responseData));
      // Save token to SharedPreferences
      await saveToken(userModel.token);
      print('Token saved: ${userModel.token}');
      return userModel;
    } else {
      print('Login failed: ${response.reasonPhrase}');
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Retrieved token: $token'); // Add this line for debugging
    return token;
  }

  static Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<UserModel?> loginWithToken(String token) async {
    var headers = {
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('GET', Uri.parse(_loginUrl));
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
