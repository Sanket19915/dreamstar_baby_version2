// lib/sign_up_screen.dart

import 'dart:io';

import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/router/route_args.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/auth_back_button.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:dream_baby/shared/widget/profile_avatar_picker.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:dream_baby/viewmodels/sign_up_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  LoginViewModel get viewModel =>
      Provider.of<LoginViewModel>(context, listen: false);
  SignUpViewModel get signUpViewModel =>
      Provider.of<SignUpViewModel>(context, listen: false);
  File? _profileImage;

  final _firstNameKey = GlobalKey<CustomTextFieldState>();
  final _lastNameKey = GlobalKey<CustomTextFieldState>();
  final _phoneKey = GlobalKey<CustomTextFieldState>();
  final _emailKey = GlobalKey<CustomTextFieldState>();
  final _passwordKey = GlobalKey<CustomTextFieldState>();
  final _confirmPasswordKey = GlobalKey<CustomTextFieldState>();
  final _dobKey = GlobalKey<CustomTextFieldState>();

  bool _firstNameValid = false;
  bool _lastNameValid = false;
  bool _phoneValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmPasswordValid = false;
  bool _dobValid = false;

  bool get isFormValid =>
      _firstNameValid &&
      _lastNameValid &&
      _phoneValid &&
      _emailValid &&
      _passwordValid &&
      _confirmPasswordValid &&
      _dobValid;

  String? firstNameValidator(String? value, BuildContext? context) {
    return (value ?? '').trim().isNotEmpty ? null : 'First name is required';
  }

  String? lastNameValidator(String? value, BuildContext? context) {
    return (value ?? '').trim().isNotEmpty ? null : 'Last name is required';
  }

  String? phoneValidator(String? value, BuildContext? context) {
    return RegExp(r'^\d{10}$').hasMatch(value ?? '')
        ? null
        : 'Enter a valid 10-digit phone number';
  }

  String? emailValidator(String? value, BuildContext? context) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value ?? '')
        ? null
        : 'Enter a valid email address';
  }

  String? passwordValidator(String? value, BuildContext? context) {
    return (value ?? '').length >= 8
        ? null
        : 'Password must be at least 8 characters';
  }

  String? confirmPasswordValidator(String? value, BuildContext? context) {
    return value == passwordController.text ? null : 'Passwords do not match';
  }

  String? dobValidator(String? value, BuildContext? context) {
    return (value ?? '').trim().isNotEmpty ? null : 'Date of Birth is required';
  }

  bool _validateAllFields() {
    return _firstNameKey.currentState!.validate() &&
        _lastNameKey.currentState!.validate() &&
        _phoneKey.currentState!.validate() &&
        _emailKey.currentState!.validate() &&
        _passwordKey.currentState!.validate() &&
        _confirmPasswordKey.currentState!.validate() &&
        _dobKey.currentState!.validate();
  }

  Future<void> _pickDob() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final y = pickedDate.year.toString().padLeft(4, '0');
      final m = pickedDate.month.toString().padLeft(2, '0');
      final d = pickedDate.day.toString().padLeft(2, '0');
      dobController.text = '$y-$m-$d';
      setState(() => _dobValid = true);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  void _sendOTP() async {
    if (!_validateAllFields()) return;

    String phoneNumber = phoneController.text.trim();
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber';
    }

    final result = await viewModel.sendOtp(phoneNumber);
    if (!mounted) return;

    if (result.isSuccess) {
      signUpViewModel.setPendingRegistration(
        PendingRegistration(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phone: phoneController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          profileImagePath: _profileImage?.path,
          dob: dobController.text,
        ),
      );
      context.push(
        Routes.verifyOtp,
        extra: OtpRouteArgs(
          phoneNumber: phoneNumber,
          userModel: result.data,
        ),
      );
    } else {
      AppMessenger.showError(
        result.errorMessage ?? 'Failed to send OTP',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = Provider.of<LoginViewModel>(context);
    final signUpVm = Provider.of<SignUpViewModel>(context);
    final isLoading = loginVm.loading || signUpVm.loading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.loginbg),
                    fit: BoxFit.fitHeight,
                    opacity: 1,
                  ),
                ),
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
                        top: 40,
                      ),
                      physics: const ClampingScrollPhysics(),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: 'Logo',
                                  child: Image.asset(
                                    AppImages.logoNew,
                                    height: MediaQuery.of(context).size.height * .06,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Create your account',
                                            style: CustomLabels.pbody1TextStyle(
                                              fontSize: 23,
                                              fontWeight:
                                                  CustomLabels.largeFontWeight,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Image.asset(
                                            AppImages.hand,
                                            gaplessPlayback: true,
                                            height: 30,
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: ProfileAvatarPicker(
                                          image: _profileImage,
                                          onTap: _pickImage,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        key: _firstNameKey,
                                        label: 'First Name',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Enter first name',
                                        controller: firstNameController,
                                        textInputAction: TextInputAction.next,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.text,
                                        validator: firstNameValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _firstNameValid = v),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _lastNameKey,
                                        label: 'Last Name',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Enter last name',
                                        controller: lastNameController,
                                        textInputAction: TextInputAction.next,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.text,
                                        validator: lastNameValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _lastNameValid = v),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _phoneKey,
                                        label: 'Phone Number',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Enter 10-digit number',
                                        controller: phoneController,
                                        textInputAction: TextInputAction.next,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.number,
                                        prefixText: '+91 ',
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        validator: phoneValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _phoneValid = v),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _emailKey,
                                        label: 'Email',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Enter email address',
                                        controller: emailController,
                                        textInputAction: TextInputAction.next,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.email,
                                        validator: emailValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _emailValid = v),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _dobKey,
                                        label: 'Date of Birth',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Select date of birth',
                                        controller: dobController,
                                        readOnly: true,
                                        borderColor: AppColors.secondaryTextColor,
                                        validator: dobValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _dobValid = v),
                                        suffix: InkWell(
                                          onTap: _pickDob,
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 12.0),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
                                              color: AppColors.mainColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _passwordKey,
                                        label: 'Password',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Minimum 8 characters',
                                        controller: passwordController,
                                        textInputAction: TextInputAction.next,
                                        obscureText: true,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.password,
                                        validator: passwordValidator,
                                        onValidChanged: (v) =>
                                            setState(() => _passwordValid = v),
                                      ),
                                      const SizedBox(height: 12),
                                      CustomTextField(
                                        key: _confirmPasswordKey,
                                        label: 'Confirm Password',
                                        autoValidate:
                                            AutovalidateMode.onUserInteraction,
                                        hintText: 'Re-enter password',
                                        controller: confirmPasswordController,
                                        textInputAction: TextInputAction.done,
                                        obscureText: true,
                                        borderColor: AppColors.secondaryTextColor,
                                        inputType: CustomTextInputType.password,
                                        validator: confirmPasswordValidator,
                                        onValidChanged: (v) => setState(
                                            () => _confirmPasswordValid = v),
                                      ),
                                      const SizedBox(height: 24),
                                      CustomButton(
                                        text: 'Continue',
                                        isEnabled: isFormValid,
                                        borderColor: isFormValid
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor
                                                .withValues(alpha: .5),
                                        backgroundColor: isFormValid
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor
                                                .withValues(alpha: .5),
                                        textStyle: CustomLabels.body3GreyTextStyle(
                                          fontSize: 16,
                                          color: AppColors.whiteColor,
                                        ),
                                        onPressed: isFormValid ? _sendOTP : null,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style: const TextStyle(color: Colors.black45),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Login here',
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.go(Routes.login);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const AuthBackButton(fallbackRoute: Routes.login),
            ],
          ),
        ),
      ),
    );
  }
}
