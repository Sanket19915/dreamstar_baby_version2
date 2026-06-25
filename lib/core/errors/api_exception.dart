class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? body;

  const ApiException({
    required this.message,
    this.statusCode,
    this.body,
  });

  @override
  String toString() => message;

  /// Extracts a user-friendly message from Laravel-style API error responses.
  ///
  /// Handles shapes like:
  /// `{"success":false,"message":"Validation error","errors":{"mobile_number":["Already registered."]}}`
  static String parseMessage(Map<String, dynamic> json) {
    final errors = json['errors'];
    if (errors is Map) {
      final messages = <String>[];
      for (final value in errors.values) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value != null) {
          messages.add(value.toString());
        }
      }
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    final message = json['message'] ?? json['error'];
    if (message != null && message.toString().isNotEmpty) {
      return message.toString();
    }

    return 'Something went wrong. Please try again.';
  }

  static ApiException fromResponse({
    required int statusCode,
    required Map<String, dynamic> body,
  }) {
    return ApiException(
      message: parseMessage(body),
      statusCode: statusCode,
      body: body,
    );
  }

  /// Maps Laravel field keys to app field names with first error per field.
  static Map<String, String> parseFieldErrors(Map<String, dynamic> json) {
    const aliases = {
      'mobile_number': 'phone',
      'phone_no': 'phone',
      'first_name': 'firstName',
      'last_name': 'lastName',
      'confirm_password': 'confirmPassword',
    };

    final errors = json['errors'];
    if (errors is! Map) return {};

    final result = <String, String>{};
    errors.forEach((key, value) {
      final fieldKey = aliases[key.toString()] ?? key.toString();
      if (value is List && value.isNotEmpty) {
        result[fieldKey] = value.first.toString();
      } else if (value != null) {
        result[fieldKey] = value.toString();
      }
    });
    return result;
  }
}
