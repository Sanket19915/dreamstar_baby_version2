// lib/otp_screen.dart
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/login_viewmodel.dart';

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
  bool isLoading = false;

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
      isPasswordValid = value.length >= 6;
    });
  }

  void validateConfirmPassword(String value) {
    setState(() {
      isConfirmPasswordValid = value == passwordController.text;
    });
  }

  String? passwordValidator(String? value, BuildContext? context) {
    validatePassword(value ?? '');
    return isPasswordValid ? null : 'Password must be at least 6 characters';
  }

  String? confirmPasswordValidator(String? value, BuildContext? context) {
    validateConfirmPassword(value ?? '');
    return isConfirmPasswordValid ? null : 'Passwords do not match';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    const SizedBox(height: 30),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Verify Phone Number',
                                style: CustomLabels.pbody1TextStyle(
                                  fontSize: 23,
                                  fontWeight: CustomLabels.largeFontWeight,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          CustomTextField(
                            onChanged: (p0) {
                              buttonNotifier.notifyListeners();
                            },
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Enter OTP',
                            controller: otpController,
                            textInputAction: TextInputAction.done,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.number,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                // Get language using key
                                const TextSpan(
                                  text: "Did't receive the OTP? ",
                                  style: TextStyle(color: Colors.black45),
                                ),

                                TextSpan(
                                  text: "Resend ",
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      resendCode();
                                    },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Password',
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.password,
                            validator: passwordValidator,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Confirm Password',
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.password,
                            validator: confirmPasswordValidator,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                          ValueListenableBuilder(
                              valueListenable: buttonNotifier,
                              builder: (context, value, child) {
                                return CustomButton(
                                  text: 'Verify',
                                  isEnabled: otpController.text.length == 6 ? true : false,
                                  borderColor: otpController.text.length == 6
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor.withOpacity(.5),
                                  backgroundColor: otpController.text.length == 6
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor.withOpacity(.5),
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
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: SpinKitThreeInOut(
                        color: AppColors.primaryColor,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resendCode() async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = await viewModel.forgotPassWord(widget.phoneNumber);

      setState(() {
        isLoading = false;
      });

      if (user != null) {
        widget.userId = user;
      }

      // final FirebaseAuth auth = FirebaseAuth.instance;
      // await auth.verifyPhoneNumber(
      //   phoneNumber: widget.phoneNumber,
      //   forceResendingToken: widget.resendToken,
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     await auth.signInWithCredential(credential).then(
      //       (value) async {
      //         print('Logged In Successfully');
      //         // Call the callback
      //       },
      //     );
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     Fluttertoast.showToast(msg: e.code);
      //   },
      //   codeSent: (String verificationId, int? resendToken) async {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     setState(() {
      //       verificationId = verificationId;
      //     });
      //     // Log the verification ID
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {
      //     print('Code auto-retrieval timeout');
      //   },
      // );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signInWithOTP() async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = await viewModel.forgotPassWordVerifyOTPAndPassword(
          passwordController.text, confirmPasswordController.text, widget.userId, otpController.text);
      Navigator.of(context).popUntil((route) => route.isFirst);

            Fluttertoast.showToast(msg: "Password has been reset successfully!!");

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
