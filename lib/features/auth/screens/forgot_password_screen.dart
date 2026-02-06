import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../shared/helper/app_color.dart';
import '../../../shared/helper/app_images.dart';
import '../../../shared/helper/app_label.dart';
import '../../../shared/utils/validator.dart';
import '../../../shared/widget/custom_button.dart';
import '../../../shared/widget/custom_textfield.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../bloc/form_validate.dart';
import 'forgot_otp_and_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController txtPhone = TextEditingController();
  bool isLoading = false;
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
                                bool valid = value.isNotEmpty;
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
                                height: MediaQuery.of(context).size.height *
                                    0.0355450237),
                            CustomButton(
                              text: 'Forgot Your Password',
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
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        final user = await viewModel
                                            .forgotPassWord(txtPhone.text);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                ForgotOtpAndPasswordScreen(
                                              phoneNumber: txtPhone.text,
                                              userId: user,
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: e.toString());
                                      } finally {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 40),
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
