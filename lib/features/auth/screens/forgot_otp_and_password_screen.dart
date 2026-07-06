// lib/otp_screen.dart
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/widget/auth_back_button.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotOtpAndPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  int? userId;

  ForgotOtpAndPasswordScreen({
    super.key,
    required this.phoneNumber,
    required this.userId,
  });

  @override
  _ForgotOtpAndPasswordScreenState createState() => _ForgotOtpAndPasswordScreenState();
}

class _ForgotOtpAndPasswordScreenState extends State<ForgotOtpAndPasswordScreen> {
  LoginViewModel get viewModel => Provider.of<LoginViewModel>(context, listen: false);

  final TextEditingController otpController = TextEditingController();
  ValueNotifier buttonNotifier = ValueNotifier(true);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isOtpValid = false;

  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;

  bool get isFormValid {
    return isOtpValid && isPasswordValid && isConfirmPasswordValid;
  }

  void validatePassword(String value) {
    setState(() {
      isPasswordValid = value.length >= 8;
    });
  }

  void validateConfirmPassword(String value) {
    setState(() {
      isConfirmPasswordValid = value == passwordController.text;
    });
  }

  String? passwordValidator(String? value, BuildContext? context) {
    validatePassword(value ?? '');
    return isPasswordValid ? null : 'Password must be at least 8 characters';
  }

  String? confirmPasswordValidator(String? value, BuildContext? context) {
    validateConfirmPassword(value ?? '');
    return isConfirmPasswordValid ? null : 'Passwords do not match';
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = Provider.of<LoginViewModel>(context);

    return LoadingOverlay(
      isLoading: loginVm.loading,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
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
                    SizedBox(height: MediaQuery.of(context).padding.top + 48),
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
                          color: AppColors.whiteColor, borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: CustomLabels.pbody1TextStyle(
                              fontSize: 23,
                              fontWeight: CustomLabels.largeFontWeight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'OTP',
                            onChanged: (p0) {
                              buttonNotifier.value = p0;
                            },
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Enter 6-digit OTP',
                            controller: otpController,
                            textInputAction: TextInputAction.next,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.number,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Didn't receive the OTP? ",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = resendCode,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'New Password',
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Minimum 8 characters',
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.password,
                            validator: passwordValidator,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            label: 'Confirm Password',
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Re-enter password',
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.password,
                            validator: confirmPasswordValidator,
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder(
                              valueListenable: buttonNotifier,
                              builder: (context, value, child) {
                                return CustomButton(
                                  text: 'Verify',
                                  isEnabled: otpController.text.length == 6 ? true : false,
                                  borderColor: otpController.text.length == 6
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor.withValues(alpha: .5),
                                  backgroundColor: otpController.text.length == 6
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor.withValues(alpha: .5),
                                  textStyle: CustomLabels.body3GreyTextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                  onPressed: () async {
                                    signInWithOTP();
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
            const AuthBackButton(fallbackRoute: Routes.forgotPassword),
          ],
        ),
      ),
    );
  }

  Future<void> resendCode() async {
    final result = await viewModel.forgotPassWord(widget.phoneNumber);
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() => widget.userId = result.data);
      AppMessenger.showSuccess('OTP resent successfully');
    } else {
      AppMessenger.showError(result.errorMessage ?? 'Failed to resend OTP');
    }
  }

  Future<void> signInWithOTP() async {
    final result = await viewModel.forgotPassWordVerifyOTPAndPassword(
      passwordController.text,
      confirmPasswordController.text,
      widget.userId,
      otpController.text,
    );
    if (!mounted) return;
    if (result.isSuccess) {
      context.go(Routes.login);
      AppMessenger.showSuccess('Password has been reset successfully');
    } else {
      AppMessenger.showError(result.errorMessage ?? 'Password reset failed');
    }
  }
}
