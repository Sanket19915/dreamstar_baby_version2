import 'package:flutter_bloc/flutter_bloc.dart';

class IsFormValidBloc extends Cubit<bool> {
  IsFormValidBloc() : super(false);

  void setFormValid(bool isValid) {
    emit(isValid);
  }
}
