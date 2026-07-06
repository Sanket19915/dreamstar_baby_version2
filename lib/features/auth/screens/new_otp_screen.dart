// lib/otp_screen.dart
import 'package:dream_baby/core/auth/auth_token.dart';
import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/auth_back_button.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:dream_baby/viewmodels/sign_up_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewOTPScreen extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic>? userModel;

  const NewOTPScreen({
    super.key,
    required this.phoneNumber,
    this.userModel,
  });

  @override
  State<NewOTPScreen> createState() => _NewOTPScreenState();
}

class _NewOTPScreenState extends State<NewOTPScreen> {
  LoginViewModel get viewModel =>
      Provider.of<LoginViewModel>(context, listen: false);
  SignUpViewModel get signUpViewModel =>
      Provider.of<SignUpViewModel>(context, listen: false);

  final TextEditingController otpController = TextEditingController();
  final ValueNotifier<String> buttonNotifier = ValueNotifier('');
  Map<String, dynamic>? _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = widget.userModel;
  }

  Future<void> signInWithOTP() async {
    final result = await viewModel.verifyOtp(
      widget.phoneNumber,
      otpController.text,
      _userModel?['user_id'].toString() ?? '',
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      AppMessenger.showError(
        result.errorMessage ?? 'OTP verification failed',
      );
      return;
    }

    final regResult =
        await signUpViewModel.completePendingRegistration(result.data);
    if (!mounted) return;

    if (regResult.isSuccess) {
      final data = regResult.data!;
      final token = AuthToken.extract(data);
      if (token != null && token.isNotEmpty) {
        await AuthService.establishSession(token);
      }
      context.go(
        Routes.journeySelection,
        extra: (data['user_id'] ?? result.data?['user_id']).toString(),
      );
    } else {
      AppMessenger.showError(
        regResult.errorMessage ?? 'Registration failed',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginVm = Provider.of<LoginViewModel>(context);
    final isLoading = loginVm.loading || signUpViewModel.loading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
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
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
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
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Verify Phone Number',
                              textAlign: TextAlign.center,
                              style: CustomLabels.pbody1TextStyle(
                                fontSize: 23,
                                fontWeight: CustomLabels.largeFontWeight,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'OTP',
                              onChanged: (value) => buttonNotifier.value = value,
                              autoValidate: AutovalidateMode.onUserInteraction,
                              hintText: 'Enter 6-digit OTP',
                              controller: otpController,
                              textInputAction: TextInputAction.done,
                              borderColor: AppColors.secondaryTextColor,
                              inputType: CustomTextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            ValueListenableBuilder<String>(
                              valueListenable: buttonNotifier,
                              builder: (context, value, child) {
                                final enabled = value.length == 6;
                                return CustomButton(
                                  text: 'Verify',
                                  isEnabled: enabled,
                                  borderColor: enabled
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  backgroundColor: enabled
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  textStyle: CustomLabels.body3GreyTextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                  onPressed: enabled ? signInWithOTP : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        textAlign: TextAlign.center,
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            const AuthBackButton(fallbackRoute: Routes.registration),
          ],
        ),
      ),
    );
  }

  Future<void> resendCode() async {
    final result = await viewModel.sendOtp(widget.phoneNumber);
    if (!mounted) return;

    if (result.isSuccess) {
      setState(() => _userModel = result.data);
      AppMessenger.showSuccess('OTP resent successfully');
    } else {
      AppMessenger.showError(result.errorMessage ?? 'Failed to resend OTP');
    }
  }
}
