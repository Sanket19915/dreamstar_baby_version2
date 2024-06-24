import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordEyeBloc extends Cubit<bool> {
  bool currentStatus = false;
  PasswordEyeBloc() : super(false) {
    currentStatus = false;
  }

  void togglePasswordEye() {
    currentStatus = !currentStatus;
    emit(currentStatus);
  }
}
