import 'package:dream_baby/features/auth/bloc/pwd_eye.dart';
import 'package:dream_baby/features/auth/bloc/textfield_validation.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CustomTextInputType { text, email, number, password, alphanumeric }

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextInputAction? textInputAction;
  final CustomTextInputType inputType;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final String? Function(String?, BuildContext?)? validator;
  final ScrollPhysics? scrollPhysics;
  final Color? cursorColor;
  final EdgeInsets scrollPadding;
  final bool enabled;
  final bool autoFocus;
  final TextAlign textAlign;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backGroundColor;
  final AutovalidateMode autoValidate;
  final bool readOnly;
  Widget? suffix;

  CustomTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.textInputAction = TextInputAction.none,
      this.inputType = CustomTextInputType.text,
      this.obscureText = false,
      this.onChanged,
      this.onSubmitted,
      this.onEditingComplete,
      this.validator,
      this.scrollPhysics,
      this.cursorColor = AppColors.primaryColor,
      this.scrollPadding = EdgeInsets.zero,
      this.enabled = true,
      this.suffix,
      this.autoFocus = false,
      this.readOnly = false,
      this.autoValidate = AutovalidateMode.disabled,
      this.textAlign = TextAlign.start,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor,
      this.backGroundColor,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PasswordEyeBloc>(create: (_) => PasswordEyeBloc()),
        BlocProvider<TextFieldValidationBloc>(
            create: (_) => TextFieldValidationBloc()),
      ],
      child: BlocBuilder<PasswordEyeBloc, bool>(
        builder: (context, flag) {
          return Theme.of(context).platform == TargetPlatform.iOS
              ? _buildCupertinoTextField(context, flag)
              : _buildMaterialTextField(context, flag);
        },
      ),
    );
  }

  Widget _buildCupertinoTextField(BuildContext context, bool eyeVisible) {
    final screenSize = MediaQuery.of(context).size;
    const double minHeight = 44.0;

    // controller.addListener(() {
    //   if (validator != null) {
    //     validator!(controller.text);
    //   }
    // });

    return BlocBuilder<TextFieldValidationBloc, TextFieldState>(
        builder: (context, state) {
      double heightMultiplier = 0.06;
      if (state is TextFieldInValidState) {
        heightMultiplier = 0.1;
      }
      return SizedBox(
        height: (screenSize.height * heightMultiplier)
            .clamp(minHeight, double.infinity),
        width: screenSize.width * 0.877,
        child: Column(
          children: [
            CupertinoTextField(
              //inputFormatters:inputFormatters,
              textInputAction: textInputAction,
              controller: controller,
              placeholder: hintText,
              readOnly: readOnly,
              keyboardType: _getCupertinoKeyboardType(),
              obscureText: inputType == CustomTextInputType.password
                  ? !eyeVisible
                  : false,
              obscuringCharacter: '*',

              onChanged: (value) {
                context
                    .read<TextFieldValidationBloc>()
                    .isValid(validator, value, context);
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
              onSubmitted: onSubmitted,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
                  border: Border.all(
                      color: borderColor ?? AppColors.placeholderColor,
                      width: 1.51),
                  color: backGroundColor),
              scrollPhysics: scrollPhysics,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              enabled: enabled,
              autofocus: autoFocus,
              textAlign: textAlign,
              // validator: validator,
              suffix: obscureText
                  ? GestureDetector(
                      onTap: () {
                        context.read<PasswordEyeBloc>().togglePasswordEye();
                        onChanged?.call('toggle');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: Icon(
                          eyeVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    )
                  : suffix,
            ),
            BlocBuilder<TextFieldValidationBloc, TextFieldState>(
                builder: (context, state) {
              if (state is TextFieldInValidState) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SizedBox(
                        width: screenSize.width,
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(
                              color: AppColors.errorColor, fontSize: 10),
                        )));
              }
              return const SizedBox(
                height: 0,
              );
            })
          ],
        ),
      );
    });
  }

  Widget _buildMaterialTextField(BuildContext context, bool eyeVisible) {
    final screenSize = MediaQuery.of(context).size;
    const double minHeight = 44.0;

    return BlocBuilder<TextFieldValidationBloc, TextFieldState>(
        builder: (context, state) {
      double heightMultiplier = 0.07;
      if (state is TextFieldInValidState) {
        heightMultiplier = 0.11;
      }
      return SizedBox(
        height: (screenSize.height * heightMultiplier)
            .clamp(minHeight, double.infinity),
        width: screenSize.width * 0.877,
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: readOnly,
              // inputFormatters: inputFormatters,
              textInputAction: textInputAction,
              controller: controller,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                // errorStyle: const TextStyle(fontSize: 10),
                fillColor: Colors.white,
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: borderColor ?? const Color(0xffDFDCDC),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: borderColor ?? const Color(0xffDFDCDC),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                suffixIcon: inputType == CustomTextInputType.password
                    ? GestureDetector(
                        onTap: () {
                          context.read<PasswordEyeBloc>().togglePasswordEye();
                          onChanged?.call('toggle');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: Icon(
                            eyeVisible
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      )
                    : suffix,
              ),
              keyboardType: _getMaterialKeyboardType(),
              obscureText: inputType == CustomTextInputType.password
                  ? !eyeVisible
                  : false,
              onChanged: (value) {
                context
                    .read<TextFieldValidationBloc>()
                    .isValid(validator, value, context);
                if (onChanged != null) {
                  onChanged!(value);
                }
              },

              onFieldSubmitted: onSubmitted,
              onEditingComplete: onEditingComplete,
              validator: (value) {
                // if(validator!=null) {
                //   if(value!.length>=1) {
                //     return validator!(value,context);
                //   }
                // }
                return null;
              },
              //   (value){
              //    if(validator!=null) {
              //      validator!(value);
              //    }
              //
              //   if(value=="")return "";
              //   return null;
              // },
              scrollPhysics: scrollPhysics,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              enabled: enabled,
              autofocus: autoFocus,
              textAlign: textAlign,
            ),
            BlocBuilder<TextFieldValidationBloc, TextFieldState>(
                builder: (context, state) {
              if (state is TextFieldInValidState) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SizedBox(
                        width: screenSize.width,
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(
                              color: AppColors.errorColor, fontSize: 10),
                        )));
              }
              return const SizedBox(
                height: 0,
              );
            })
          ],
        ),
      );
    });
  }

  TextInputType _getCupertinoKeyboardType() {
    switch (inputType) {
      case CustomTextInputType.number:
        return TextInputType.number;
      case CustomTextInputType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  TextInputType _getMaterialKeyboardType() {
    switch (inputType) {
      case CustomTextInputType.email:
        return TextInputType.emailAddress;
      case CustomTextInputType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
