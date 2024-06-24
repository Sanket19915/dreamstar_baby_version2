import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldEvent {}

class TextFieldValidEvent extends TextFieldEvent {}

class TextFieldInValidEvent extends TextFieldEvent {
  String errorMessage;
  TextFieldInValidEvent(this.errorMessage);
}

class TextFieldState {}

class TextFieldValidState extends TextFieldState {}

class TextFieldInValidState extends TextFieldState {
  String errorMessage;
  TextFieldInValidState(this.errorMessage);
}

class TextFieldValidationBloc extends Bloc<TextFieldEvent, TextFieldState> {
  TextFieldValidationBloc() : super(TextFieldState()) {
    on<TextFieldValidEvent>((event, emit) {
      emit(TextFieldValidState());
    });
    on<TextFieldInValidEvent>((event, emit) {
      emit(TextFieldInValidState(event.errorMessage));
    });
  }

  void triggerCustomError(String errorMessage) {
    add(TextFieldInValidEvent(errorMessage));
  }

  void isValid(Function(String, BuildContext?)? onChange, String value,
      BuildContext? context) {
    if (onChange != null) {
      // Check if onChange is not null
      String? response = onChange(value, context);
      if (response == null) {
        add(TextFieldValidEvent());
      } else {
        add(TextFieldInValidEvent(response));
      }
    } else {
      // Handle the case where onChange is null
    }
  }
}
