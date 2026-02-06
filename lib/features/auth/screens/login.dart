import 'package:dream_baby/features/auth/bloc/form_validate.dart';
import 'package:dream_baby/features/auth/screens/forgot_password_screen.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/helper/app_label.dart';
import 'package:dream_baby/shared/utils/validator.dart';
import 'package:dream_baby/shared/widget/custom_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool isLoading = false;
  final SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return GestureDetector(
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                physics: const ClampingScrollPhysics(),
                child: BlocProvider(
                  create: (_) => IsFormValidBloc(),
                  child: BlocBuilder<IsFormValidBloc, bool>(
                    builder: (context, isValid) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 4,
                            ),
                            // RichText(
                            //   textAlign: TextAlign.center,
                            //   text: const TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //         text: 'DreamStar',
                            //         style: TextStyle(
                            //           color: Colors.black45,
                            //           fontSize: 22,
                            //           fontWeight: FontWeight.w700,
                            //         ),
                            //       ),
                            //       TextSpan(
                            //         text: 'Baby',
                            //         style: TextStyle(
                            //           color: Colors.pink,
                            //           fontSize: 22,
                            //           fontWeight: FontWeight.w700,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(
                              height: 0,
                            ),
                            Hero(
                              tag: 'Logo',
                              child: Image.asset(
                                AppImages.logoNew,
                                height:
                                    MediaQuery.of(context).size.height * .06,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hi, Welcome!',
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
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                'Phone Number',
                                style: CustomLabels.body3BlackTextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            CustomTextField(
                              autoValidate: AutovalidateMode.disabled,
                              hintText: 'Enter Phone Number',
                              controller: txtPhone,
                              textInputAction: TextInputAction.next,
                              autoFocus: true,
                              borderColor: AppColors.secondaryTextColor,
                              inputType: CustomTextInputType.number,
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              onChanged: (value) {
                                bool valid = value.isNotEmpty &&
                                    txtPassword.text.length >= 6;
                                context
                                    .read<IsFormValidBloc>()
                                    .setFormValid(valid);
                              },
                              validator: (value, cont) {
                                if (value!.isEmpty) {
                                  return 'Enter phone number';
                                } else if (!ValidationsAll.isValidPhoneNumber(
                                    value)) {
                                  return "Provide valid phone number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                'Password',
                                style: CustomLabels.body3BlackTextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            CustomTextField(
                              autoValidate: AutovalidateMode.onUserInteraction,
                              hintText: 'Please Enter Password',
                              textInputAction: TextInputAction.done,
                              controller: txtPassword,
                              obscureText: true,
                              borderColor: AppColors.secondaryTextColor,
                              inputType: CustomTextInputType.password,
                              onChanged: (value) {
                                bool valid = value.isNotEmpty &&
                                    value.length >= 6 &&
                                    ValidationsAll.isValidPhoneNumber(
                                        txtPhone.text);
                                context
                                    .read<IsFormValidBloc>()
                                    .setFormValid(valid);
                              },
                              validator: (value, cont) {
                                if (value!.isEmpty) {
                                  return 'Please provide a password';
                                } else if (value.length < 6) {
                                  return 'Weak password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  'Forgot Your Password?',
                                  style: TextStyle(
                                    color: Colors.transparent,
                                    decorationColor:
                                        AppColors.secondaryTextColor,
                                    fontSize: 13,
                                    fontWeight: CustomLabels.largeFontWeight,
                                    fontFamily: CustomLabels.secondaryFont,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.secondaryTextColor,
                                        offset: Offset(0, -1.8),
                                      ),
                                    ],
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.51,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.0355450237),
                            CustomButton(
                              text: 'Log In',
                              isEnabled: isValid && !isLoading,
                              borderColor: isValid
                                  ? AppColors.primaryColor
                                  : AppColors.secondaryTextColor
                                      .withValues(alpha: .5),
                              backgroundColor: isValid
                                  ? AppColors.primaryColor
                                  : AppColors.secondaryTextColor
                                      .withValues(alpha: .5),
                              textStyle: CustomLabels.body3GreyTextStyle(
                                fontSize: 16,
                                color: isValid
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                              ),
                              onPressed: isValid && !isLoading
                                  ? () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final user = await viewModel.login(
                                        txtPhone.text,
                                        txtPassword.text,
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print(user);
                                      if (user != null) {
                                        sessionManager.setLoggedIn(true);
                                        context.go(Routes.home,
                                            extra: user.token);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Incorrect Credentials'),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 40),
                            RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(color: Colors.black45),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Register here',
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.go(Routes.registration);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: SpinKitCircle(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  bool isLoggedIn() {
    // Check if the user is logged in based on your criteria
    return Hive.box('userBox').get('isLoggedIn', defaultValue: false);
  }

  void setLoggedIn(bool loggedIn) {
    Hive.box('userBox').put('isLoggedIn', loggedIn);
  }

  void clearSession() {
    Hive.box('userBox').delete('isLoggedIn');
  }
}
