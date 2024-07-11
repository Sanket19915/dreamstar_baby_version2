// lib/otp_screen.dart
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final VoidCallback onVerified;

  const OTPScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.onVerified,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  void signInWithOTP() async {
    try {
      setState(() {
        isLoading = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text,
      );

      await _auth
          .signInWithCredential(credential)
          .then((value) => print('User Login In Successful'));
   
      widget.onVerified();
     setState(() {
        isLoading = false;
      });    // Call the callback to sign up
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
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Enter OTP',
                            controller: otpController,
                            textInputAction: TextInputAction.done,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.number,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035),
                          CustomButton(
                            text: 'Verify',
                            isEnabled: true,
                            borderColor: AppColors.primaryColor,
                            backgroundColor: AppColors.primaryColor,
                            textStyle: CustomLabels.body3GreyTextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                            ),
                            onPressed: () async {
                              signInWithOTP();
                            },
                          ),
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
}
