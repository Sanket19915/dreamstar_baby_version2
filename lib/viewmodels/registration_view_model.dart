import 'dart:io';

import 'package:dream_baby/models/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationViewModel {
  late BuildContext context;
  late RegistrationModel user;

  RegistrationViewModel(this.context) {
    user = RegistrationModel();
  }

  Future<void> registerUser(
      {required String fullName,
      String? email,
      required String phone,
      required String password,
      required String confirmPassword,
      DateTime? dob,
      DateTime? dom,
      DateTime? edd,
      File? image}) async {
    // Perform validations
    if (!_validateInputs()) {
      return;
    }

    // Prepare data for API request
    var headers = {'Accept': 'application/json'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://dreambaby.pro/api/auth/register'));
    request.fields.addAll({
      'name': user.fullName,
      'email': user.email,
      'password': user.password,
      'dob': user.dob!.toIso8601String(),
      'dom': user.dom!.toIso8601String(),
      'lmp': user.dom!.toIso8601String(),
      'eed': user.edd!.toIso8601String(),
      'phone_no': user.phoneNumber,
      'profile_pic': '',
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed: ${response.reasonPhrase}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  bool _validateInputs() {
    if (user.fullName.isEmpty ||
        user.email.isEmpty ||
        user.phoneNumber.isEmpty ||
        user.dob == null ||
        user.dom == null ||
        user.edd == null ||
        user.password.isEmpty ||
        user.confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    if (user.password != user.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    return true;
  }
}
