// lib/otp_screen.dart
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final int? resendToken;
  final VoidCallback onVerified;

  const OTPScreen(
      {super.key, required this.phoneNumber, required this.verificationId, required this.onVerified, this.resendToken});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  ValueNotifier buttonNotifier = ValueNotifier(true);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String verificationId = "";
  void signInWithOTP() async {
    try {
      setState(() {
        isLoading = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.isEmpty ? widget.verificationId : verificationId,
        smsCode: otpController.text,
      );

      await _auth.signInWithCredential(credential).then((value) => print('User Login In Successful'));

      widget.onVerified();

      await Future.delayed(const Duration(seconds: 4));
      setState(() {
        isLoading = false;
      }); // Call the callback to sign up
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
      print('Failed to sign in with OTP: $e');
    }
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
                          color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Column(
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
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: otpController,
                            builder: (context, value, child) {
                              String text = value.text;
                              return Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(6, (index) {
                                      String digit = '';
                                      if (text.length > index) {
                                        digit = text[index];
                                      }
                                      bool isActive = text.length == index;
                                      return Container(
                                        width: 45,
                                        height: 55,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isActive ? AppColors.primaryColor : AppColors.secondaryTextColor.withValues(alpha: 0.5),
                                            width: isActive ? 2 : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                        ),
                                        child: Text(
                                          digit,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mainColor),
                                        ),
                                      );
                                    }),
                                  ),
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.0,
                                      child: TextField(
                                        controller: otpController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        autofocus: true,
                                        onChanged: (val) {
                                          buttonNotifier.notifyListeners();
                                        },
                                        decoration: const InputDecoration(
                                          counterText: "",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
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
                    Center(
                      child: RichText(
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
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
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

      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        forceResendingToken: widget.resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then(
            (value) async {
              print('Logged In Successfully');
              // Call the callback
            },
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: e.code);
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isLoading = false;
          });
          setState(() {
            verificationId = verificationId;
          });
          // Log the verification ID
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
