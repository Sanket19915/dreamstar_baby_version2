import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppMessenger {
  AppMessenger._();

  static void showError(String message) {
    if (message.isEmpty) return;
    Fluttertoast.showToast(msg: message);
  }

  static void showSuccess(String message) {
    if (message.isEmpty) return;
    Fluttertoast.showToast(msg: message);
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = true}) {
    if (message.isEmpty || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }
}
