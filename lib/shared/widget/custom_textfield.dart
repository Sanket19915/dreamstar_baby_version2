import 'package:dream_baby/features/auth/bloc/pwd_eye.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CustomTextInputType { text, email, number, password, alphanumeric }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextInputAction? textInputAction;
  final CustomTextInputType inputType;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final String? Function(String?, BuildContext?)? validator;
  final ScrollPhysics? scrollPhysics;
  final Color? cursorColor;
  final EdgeInsets scrollPadding;
  final bool enabled;
  final bool autoFocus;
  final TextAlign textAlign;
  final double? width;
  final double? borderRadius;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backGroundColor;
  final AutovalidateMode autoValidate;
  final bool readOnly;
  final Widget? suffix;
  final Widget? prefix;
  final String? prefixText;
  final ValueChanged<bool>? onValidChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
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
    this.prefix,
    this.prefixText,
    this.autoFocus = false,
    this.readOnly = false,
    this.autoValidate = AutovalidateMode.disabled,
    this.textAlign = TextAlign.start,
    this.width,
    this.borderRadius = 10,
    this.borderColor,
    this.backGroundColor = AppColors.whiteColor,
    this.inputFormatters,
    this.onValidChanged,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  String? _validationError;
  bool _hasInteracted = false;

  static const double _fieldHeight = 48;

  bool get hasError => _validationError != null;

  bool validate() {
    _hasInteracted = true;
    _runValidation(widget.controller.text);
    return _validationError == null;
  }

  void _runValidation(String value) {
    final error = widget.validator?.call(value, context);
    if (_validationError != error) {
      setState(() => _validationError = error);
    }
    widget.onValidChanged?.call(error == null);
  }

  void _handleChanged(String value) {
    _hasInteracted = true;
    if (widget.autoValidate != AutovalidateMode.disabled || _hasInteracted) {
      _runValidation(value);
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordEyeBloc(),
      child: BlocBuilder<PasswordEyeBloc, bool>(
        builder: (context, eyeVisible) {
          final field = Theme.of(context).platform == TargetPlatform.iOS
              ? _buildCupertinoTextField(context, eyeVisible)
              : _buildMaterialTextField(context, eyeVisible);

          return SizedBox(
            width: widget.width ?? double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: CustomLabels.body3BlackTextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                ],
                field,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCupertinoTextField(BuildContext context, bool eyeVisible) {
    final borderColor = hasError
        ? AppColors.errorColor
        : (widget.borderColor ?? const Color(0xffDFDCDC));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _fieldHeight,
          child: CupertinoTextField(
            onTap: widget.onTap,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            placeholder: widget.hintText,
            readOnly: widget.readOnly,
            keyboardType: _getCupertinoKeyboardType(),
            obscureText: widget.inputType == CustomTextInputType.password
                ? !eyeVisible
                : widget.obscureText,
            obscuringCharacter: '•',
            onChanged: _handleChanged,
            onSubmitted: widget.onSubmitted,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              border: Border.all(color: borderColor, width: 1),
              color: widget.backGroundColor,
            ),
            scrollPhysics: widget.scrollPhysics,
            cursorColor: widget.cursorColor,
            scrollPadding: widget.scrollPadding,
            enabled: widget.enabled,
            autofocus: widget.autoFocus,
            textAlign: widget.textAlign,
            inputFormatters: widget.inputFormatters,
            prefix: widget.prefix ?? (widget.prefixText != null 
                ? Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(widget.prefixText!, style: TextStyle(color: AppColors.blackColor, fontSize: 15)),
                  )
                : null),
            suffix: _buildPasswordSuffix(context, eyeVisible),
          ),
        ),
        if (_validationError != null) _errorText(),
      ],
    );
  }

  Widget _buildMaterialTextField(BuildContext context, bool eyeVisible) {
    final border = widget.borderColor ?? const Color(0xffDFDCDC);
    const errorBorder = AppColors.errorColor;
    final radius = BorderRadius.circular(widget.borderRadius!);

    return TextFormField(
      onTap: widget.onTap,
      autovalidateMode: widget.autoValidate,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscuringCharacter: '•',
      style: const TextStyle(fontSize: 15, height: 1.2),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.backGroundColor,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColors.secondaryTextColor.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        errorText: _validationError,
        errorMaxLines: 2,
        errorStyle: const TextStyle(color: AppColors.errorColor, fontSize: 11),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        isDense: true,
        constraints: const BoxConstraints(minHeight: _fieldHeight),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: hasError ? errorBorder : border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: hasError ? errorBorder : border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: hasError ? errorBorder : AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: errorBorder),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: errorBorder, width: 1.5),
        ),
        prefixIcon: widget.prefix,
        prefixText: widget.prefixText,
        prefixStyle: const TextStyle(color: Colors.black87, fontSize: 15),
        suffixIcon: _buildPasswordSuffix(context, eyeVisible),
      ),
      keyboardType: _getMaterialKeyboardType(),
      obscureText: widget.inputType == CustomTextInputType.password
          ? !eyeVisible
          : widget.obscureText,
      onChanged: _handleChanged,
      onFieldSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      scrollPhysics: widget.scrollPhysics,
      cursorColor: widget.cursorColor,
      scrollPadding: widget.scrollPadding,
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      textAlign: widget.textAlign,
    );
  }

  Widget? _buildPasswordSuffix(BuildContext context, bool eyeVisible) {
    if (widget.inputType != CustomTextInputType.password && !widget.obscureText) {
      return widget.suffix;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        onPressed: () => context.read<PasswordEyeBloc>().togglePasswordEye(),
        icon: Icon(
          eyeVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.secondaryTextColor,
          size: 22,
        ),
        splashRadius: 20,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Widget _errorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 2),
      child: Text(
        _validationError!,
        style: const TextStyle(color: AppColors.errorColor, fontSize: 11),
      ),
    );
  }

  TextInputType _getCupertinoKeyboardType() {
    switch (widget.inputType) {
      case CustomTextInputType.email:
        return TextInputType.emailAddress;
      case CustomTextInputType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  TextInputType _getMaterialKeyboardType() {
    switch (widget.inputType) {
      case CustomTextInputType.email:
        return TextInputType.emailAddress;
      case CustomTextInputType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
