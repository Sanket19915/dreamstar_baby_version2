// lib/sign_up_screen.dart

import 'dart:convert';
import 'dart:io';

import 'package:dream_baby/features/auth/screens/new_otp_screen.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/login_viewmodel.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  LoginViewModel get viewModel =>
      Provider.of<LoginViewModel>(context, listen: false);
  File? _profileImage;

  bool isLoading = false;
  bool isFirstNameValid = false;
  bool isLastNameValid = false;
  bool isPhoneValid = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;

  bool get isFormValid {
    return isFirstNameValid &&
        isLastNameValid &&
        isPhoneValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid;
  }

  void validateFirstName(String value) {
    setState(() {
      isFirstNameValid = value.isNotEmpty;
    });
  }

  void validateLastName(String value) {
    setState(() {
      isLastNameValid = value.isNotEmpty;
    });
  }

  void validatePhone(String value) {
    setState(() {
      isPhoneValid = RegExp(r'^\d{10}$').hasMatch(value);
    });
  }

  void validateEmail(String value) {
    setState(() {
      isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
    });
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

  String? firstNameValidator(String? value, BuildContext? context) {
    validateFirstName(value ?? '');
    return isFirstNameValid ? null : 'First name is required';
  }

  String? lastNameValidator(String? value, BuildContext? context) {
    validateLastName(value ?? '');
    return isLastNameValid ? null : 'Last name is required';
  }

  String? phoneValidator(String? value, BuildContext? context) {
    validatePhone(value ?? '');
    return isPhoneValid ? null : 'Enter a valid phone number';
  }

  String? emailValidator(String? value, BuildContext? context) {
    validateEmail(value ?? '');
    return isEmailValid ? null : 'Enter a valid email address';
  }

  String? passwordValidator(String? value, BuildContext? context) {
    validatePassword(value ?? '');
    return isPasswordValid ? null : 'Password must be at least 6 characters';
  }

  String? confirmPasswordValidator(String? value, BuildContext? context) {
    validateConfirmPassword(value ?? '');
    return isConfirmPasswordValid ? null : 'Passwords do not match';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  void _sendOTP() async {
    try {
      // final FirebaseAuth auth = FirebaseAuth.instance;
      String phoneNumber = phoneController.text.trim();

      // Ensure the phone number is in the correct format
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber'; // Replace '+1' with your country code
      }

      setState(() {
        isLoading = true;
      });

      Map<String, dynamic>? response = await viewModel.sendOtp(phoneNumber);

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => NewOTPScreen(
              phoneNumber: phoneNumber,
              userModel: response,
              verifyComplete: (value) async {
                (_profileImage?.path.isEmpty ?? true)
                    ? await _signUpWithoutImage(value)
                    : await _signUp(
                        value); // Callback to sign up after verification
              },
            ),
          ),
        );
      }
      // await auth.verifyPhoneNumber(
      //   phoneNumber: phoneNumber,
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     await auth.signInWithCredential(credential).then(
      //           (value) => print('Logged In Successfully'),
      //         );
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     Fluttertoast.showToast(msg: e.code);
      //     if (e.code == 'invalid-phone-number') {
      //       print('The provided phone number is not valid.');
      //     } else {
      //       print(
      //           'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
      //     }
      //   },
      //   codeSent: (String verificationId, int? resendToken) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     print('Verification ID: $verificationId'); // Log the verification ID
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => OTPScreen(
      //           resendToken: resendToken,
      //           phoneNumber: phoneNumber,
      //           verificationId: verificationId,
      //           onVerified: () async {
      //             (_profileImage?.path.isEmpty ?? true)
      //                 ? await _signUpWithoutImage()
      //                 : await _signUp(); // Callback to sign up after verification
      //           },
      //         ),
      //       ),
      //     );
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {
      //     print('Code auto-retrieval timeout');
      //   },
      // );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to Verify Phone Number: $e');
    }
  }

  Future<void> _signUpWithoutImage(Map<String, dynamic>? userModel) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Provider.of<SignUpViewModel>(context, listen: false)
          .signUpWithotProfile(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              phone: phoneController.text,
              email: emailController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              userId: userModel?["user_id"]??"")
          .then(
        (value) {
          if (!value.containsKey("errors")) {
            print(value["user_id"]);
            AuthService.saveToken(value["access_token"]);
            context.go(Routes.moreDetails, extra: value["user_id"].toString());
          } else {
            print(value["message"]);
            Fluttertoast.showToast(msg: value["message"]);
          }
        },
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _signUp(Map<String, dynamic>? userModel) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Provider.of<SignUpViewModel>(context, listen: false)
          .signUpWithProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        profileImage: _profileImage?.path ?? "",
        userId: userModel?["user_id"] ?? "",
      )
          .then(
        (value) {
          if (!value.containsKey("errors")) {
            print("error");
            AuthService.saveToken(value["access_token"]);
            context.go(Routes.moreDetails, extra: value["user_id"].toString());
          } else {
            print("success");
            Fluttertoast.showToast(msg: value["message"]);
          }
        },
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Please upload profile picture");
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create your account',
                                style: CustomLabels.pbody1TextStyle(
                                  fontSize: 23,
                                  fontWeight: CustomLabels.largeFontWeight,
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.secondaryTextColor,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(Icons.add_a_photo,
                                      color: Colors.white, size: 50)
                                  : null,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'First Name',
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.text,
                            validator: firstNameValidator,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Last Name',
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.text,
                            validator: lastNameValidator,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Phone Number',
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.number,
                            validator: phoneValidator,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          CustomTextField(
                            autoValidate: AutovalidateMode.onUserInteraction,
                            hintText: 'Email',
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            borderColor: AppColors.secondaryTextColor,
                            inputType: CustomTextInputType.email,
                            validator: emailValidator,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035),
                          CustomButton(
                            text: 'Continue',
                            isEnabled: isFormValid,
                            borderColor: isFormValid
                                ? AppColors.primaryColor
                                : AppColors.secondaryTextColor.withOpacity(.5),
                            backgroundColor: isFormValid
                                ? AppColors.primaryColor
                                : AppColors.secondaryTextColor.withOpacity(.5),
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

class SignUpViewModel with ChangeNotifier {
  Future<Map<String, dynamic>> signUpWithProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String profileImage,
    required String userId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://dreambaby.pro/api/auth/register-initial'),
    )
      ..fields.addAll({
        'first_name': firstName,
        'last_name': lastName,
        'phone_no': phone,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        "user_id": userId
      })
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      })
      ..files
          .add(await http.MultipartFile.fromPath('profile_pic', profileImage));
    var response = await request.send();
    var jsonData = await http.Response.fromStream(response);
    Map<String, dynamic>? finalResponse;
    // if (response.statusCode == 200) {
    finalResponse = jsonDecode(jsonData.body) as Map<String, dynamic>;

    Fluttertoast.showToast(msg: finalResponse["message"]);
    // String userId =  finalResponse["user_id"];
    // return finalResponse.containsKey("errors");
    return finalResponse;
    // Handle successful response
    // } else {
    //   Fluttertoast.showToast(msg: response.reasonPhrase ?? "");
    //   return true;
    // }
  }

  Future<Map<String, dynamic>> signUpWithotProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required String userId,
  }) async {
    final response = await http.post(
        Uri.parse('http://dreambaby.pro/api/auth/register-initial'),
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'phone_no': phone,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          "user_id": userId
        });

    Map<String, dynamic>? finalResponse;
    // if (response.statusCode == 200) {
    print("body===${response.body}");
    finalResponse = jsonDecode(response.body) as Map<String, dynamic>;
    print(finalResponse);
    Fluttertoast.showToast(msg: finalResponse["message"]);
    // String userId =  finalResponse["user_id"];
    // return finalResponse.containsKey("errors");
    print(finalResponse);
    return finalResponse;
    // Handle successful response
    // } else {
    //   Fluttertoast.showToast(msg: response.reasonPhrase ?? "");
    //   return true;
    // }
  }
}
