import 'package:dream_baby/core/utils/app_messenger.dart';
import 'package:dream_baby/router/route_args.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/widget/auth_back_button.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../shared/helper/app_color.dart';
import '../../../shared/helper/app_images.dart';
import '../../../shared/helper/app_label.dart';
import '../../../shared/utils/validator.dart';
import '../../../shared/widget/custom_button.dart';
import '../../../shared/widget/custom_textfield.dart';
import '../../../viewmodels/login_viewmodel.dart';
import '../bloc/form_validate.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController txtPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return LoadingOverlay(
      isLoading: viewModel.loading,
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                              ),
                              Hero(
                                tag: 'Logo',
                                child: Image.asset(
                                  AppImages.logoNew,
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Forgot Password',
                                textAlign: TextAlign.center,
                                style: CustomLabels.pbody1TextStyle(
                                  fontSize: 23,
                                  fontWeight: CustomLabels.largeFontWeight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter your phone number to receive an OTP',
                                textAlign: TextAlign.center,
                                style: CustomLabels.body3BlackTextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              CustomTextField(
                                label: 'Phone Number',
                                autoValidate: AutovalidateMode.onUserInteraction,
                                hintText: 'Enter Phone Number',
                                controller: txtPhone,
                                textInputAction: TextInputAction.done,
                                autoFocus: true,
                                borderColor: AppColors.secondaryTextColor,
                                inputType: CustomTextInputType.number,
                                scrollPhysics:
                                    const AlwaysScrollableScrollPhysics(),
                                onChanged: (value) {
                                  context
                                      .read<IsFormValidBloc>()
                                      .setFormValid(value.isNotEmpty);
                                },
                                validator: (value, cont) {
                                  if (value!.isEmpty) {
                                    return 'Enter phone number';
                                  } else if (!ValidationsAll.isValidPhoneNumber(
                                      value)) {
                                    return 'Provide valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.04,
                              ),
                              CustomButton(
                                text: 'Send OTP',
                                isEnabled: isValid && !viewModel.loading,
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
                                onPressed: isValid && !viewModel.loading
                                    ? () async {
                                        final result = await viewModel
                                            .forgotPassWord(txtPhone.text);
                                        if (!context.mounted) return;
                                        if (result.isSuccess) {
                                          context.push(
                                            Routes.forgotOtpReset,
                                            extra: ForgotOtpRouteArgs(
                                              phoneNumber: txtPhone.text,
                                              userId: result.data,
                                            ),
                                          );
                                        } else {
                                          AppMessenger.showSnackBar(
                                            context,
                                            result.errorMessage ??
                                                'Failed to send OTP',
                                          );
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
              const AuthBackButton(fallbackRoute: Routes.login),
            ],
          ),
        ),
      ),
    );
  }
}
