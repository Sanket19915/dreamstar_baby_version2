class AuthToken {
  AuthToken._();

  static String? extract(Map<String, dynamic> json) {
    for (final key in ['access_token', 'token', 'auth_token']) {
      final value = json[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }

    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return extract(data);
    }

    return null;
  }
}
