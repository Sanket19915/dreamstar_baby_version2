import 'package:flutter/cupertino.dart';

class LoginFormState extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      // Additional validation logic if needed
      return true;
    }
    return false;
  }
}
