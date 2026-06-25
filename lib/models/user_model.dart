import 'package:dream_baby/core/auth/auth_token.dart';

class UserModel {
  final String phoneNo;
  final String token;

  UserModel({required this.phoneNo, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNo: json['phone_no'] as String? ?? '',
      token: AuthToken.extract(json) ?? '',
    );
  }
}
