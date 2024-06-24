import 'package:dream_baby/features/auth/bloc/form_validate.dart';
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
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      appBar: AppBar(
        backgroundColor: AppColors.appPinkLight,
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'DreamStar',
                style: TextStyle(
                  color: Colors.black45, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Baby',
                style: TextStyle(
                  color: Colors.pink, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: BlocProvider(
            create: (_) => IsFormValidBloc(),
            child:
                BlocBuilder<IsFormValidBloc, bool>(builder: (context, isValid) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'Logo',
                      child: Image.asset(
                        AppImages.logoN,
                        height: MediaQuery.of(context).size.height * .18,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, Welcome back!',
                          style: CustomLabels.pbody1TextStyle(
                              fontSize: 23,
                              fontWeight: CustomLabels.largeFontWeight),
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
                        height: MediaQuery.of(context).size.height * 0.025),
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
                      scrollPhysics: const AlwaysScrollableScrollPhysics(),
                      onChanged: (value) {
                        bool valid =
                            value.isNotEmpty && txtPassword.text.length >= 6;
                        context.read<IsFormValidBloc>().setFormValid(valid);
                      },
                      validator: (value, cont) {
                        if (value!.isEmpty) {
                          return 'Enter phone number';
                        } else if (!ValidationsAll.isValidPhoneNumber(value)) {
                          return "Provide valid phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                            ValidationsAll.isValidPhoneNumber(txtPhone.text);
                        context.read<IsFormValidBloc>().setFormValid(valid);
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    const SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Text(
                        'Forgot Your Password?',
                        style: TextStyle(
                            color: Colors.transparent,
                            decorationColor: AppColors.secondaryTextColor,
                            fontSize: 13,
                            fontWeight: CustomLabels.largeFontWeight,
                            fontFamily: CustomLabels.secondaryFont,
                            shadows: [
                              Shadow(
                                  color: AppColors.secondaryTextColor,
                                  offset: Offset(0, -1.8))
                            ],
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.51),
                      ),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.height * 0.0355450237),
                    CustomButton(
                      text: 'Log In',
                      isEnabled: isValid,
                      borderColor: isValid
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor.withOpacity(.5),
                      backgroundColor: isValid
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor.withOpacity(.5),
                      textStyle: CustomLabels.body3GreyTextStyle(
                          fontSize: 16,
                          color: isValid
                              ? AppColors.whiteColor
                              : AppColors.blackColor),
                      onPressed: isValid
                          ? () async {
                              final user = await viewModel.login(
                                txtPhone.text,
                                txtPassword.text,
                              );
                              if (user != null) {
                                context
                                    .go(Routes.home); // Use the correct route
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Incorrect Credentials')),
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
            }),
          ),
        ),
      ),
    );
  }
}
