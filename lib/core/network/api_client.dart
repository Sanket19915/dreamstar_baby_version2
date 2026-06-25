import 'dart:convert';

import 'package:dream_baby/core/errors/api_exception.dart';
import 'package:dream_baby/core/storage/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._();

  static const _defaultHeaders = {
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStorage.read();
    return {
      ..._defaultHeaders,
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _decodeBody(String body) {
    if (body.isEmpty) return {};
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {'data': decoded};
  }

  static bool _isSuccessStatus(int statusCode) =>
      statusCode >= 200 && statusCode < 300;

  static bool _isSuccessBody(Map<String, dynamic> body) {
    if (body.containsKey('success')) {
      return body['success'] == true;
    }
    return true;
  }

  static void _throwIfFailed(int statusCode, Map<String, dynamic> body) {
    if (!_isSuccessStatus(statusCode) || !_isSuccessBody(body)) {
      throw ApiException.fromResponse(statusCode: statusCode, body: body);
    }
  }

  static Future<Map<String, dynamic>> get(
    String url, {
    bool authenticated = true,
  }) async {
    final headers =
        authenticated ? await _authHeaders() : Map<String, String>.from(_defaultHeaders);
    final response = await http.get(Uri.parse(url), headers: headers);
    final body = _decodeBody(response.body);
    _throwIfFailed(response.statusCode, body);
    return body;
  }

  static Future<Map<String, dynamic>> postForm(
    String url,
    Map<String, String> fields, {
    bool authenticated = false,
  }) async {
    final headers =
        authenticated ? await _authHeaders() : Map<String, String>.from(_defaultHeaders);
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: fields,
    );
    final body = _decodeBody(response.body);
    _throwIfFailed(response.statusCode, body);
    return body;
  }

  static Future<Map<String, dynamic>> postMultipart(
    String url,
    Map<String, String> fields, {
    List<http.MultipartFile> files = const [],
    bool authenticated = false,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(fields)
      ..files.addAll(files);

    final headers =
        authenticated ? await _authHeaders() : Map<String, String>.from(_defaultHeaders);
    request.headers.addAll(headers);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final body = _decodeBody(response.body);
    _throwIfFailed(response.statusCode, body);
    return body;
  }

  static Future<Map<String, dynamic>> delete(
    String url, {
    bool authenticated = true,
  }) async {
    final headers = authenticated
        ? await _authHeaders()
        : Map<String, String>.from(_defaultHeaders);
    final response = await http.delete(Uri.parse(url), headers: headers);
    final body = _decodeBody(response.body);
    _throwIfFailed(response.statusCode, body);
    return body;
  }

  /// Parses response without throwing — useful when caller needs raw body on failure.
  static Future<({int statusCode, Map<String, dynamic> body})> postFormRaw(
    String url,
    Map<String, String> fields, {
    bool authenticated = false,
  }) async {
    final headers =
        authenticated ? await _authHeaders() : Map<String, String>.from(_defaultHeaders);
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: fields,
    );
    return (statusCode: response.statusCode, body: _decodeBody(response.body));
  }
}
