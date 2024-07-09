import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    var headers = {
      'Authorization': '••••••',
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6ImRsdnBhb3cvemlQSC81cEc5R1hSdXc9PSIsInZhbHVlIjoic0tJdUk4cFJkTnMvZkpUd1ZoMjhkdjFCem1Fd1djZUJtMnQyU2ZLRGJITUxSanB3S2RUN1hFaUg4Y3hCVElWZXU2ZkdHZ0xrYWNFQkc1NnplZ2Z6eHN6dWM1ZW94djE0OUpXMnRsU2E0V2xHMzBZaFh5eHBLN2paUWExMDZ5dW0iLCJtYWMiOiIzNzVmMjlmNjcyMGYwZTU3YmVkMmVlODE4MmQ3Y2QzMDVlNzY5NjNmZjYxNDMyYWNlOTNhZjJhYTU3YTk5ZDBiIiwidGFnIjoiIn0%3D; laravel_session=eyJpdiI6InNzZUtnS3NyaFBpU3FhdWRieGZYT1E9PSIsInZhbHVlIjoiY0p5VitMQldUYjlnMTNLOUVBaTdOYVphSVlRQ2dqVjFhU3prYlFVbXNhd0RIbmZYWUhsU3pIUzlhOFN2ei8yTE9OVTdObVBTUWpucDZ6VGowWkhSU09wV05WTEY5WDY1OVliQzNsS01CQVJrOTZBVC9XUERCanFOSXdiL0JidmMiLCJtYWMiOiI3YTQzZGYwZjIwZGVjNGZjM2VhMjNhYTI3NTIxN2NmMzg2MTI1M2JkZDlmMTA3YjVjM2Q1MWRkM2JhMDhmMWZkIiwidGFnIjoiIn0%3D'
    };
    var uri = Uri.parse('http://dreambaby.pro/api/profile');
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
