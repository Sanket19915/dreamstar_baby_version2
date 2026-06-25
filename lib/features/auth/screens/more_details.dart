import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/widget/auth_back_button.dart';
import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:dream_baby/shared/widget/loading_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../router/routes.dart';
import '../../../shared/helper/app_color.dart';
import '../../../shared/helper/app_images.dart';
import '../../../shared/helper/app_label.dart';
import '../../../shared/widget/custom_button.dart';

enum DetailType { EDD, LMP }

class MoreDetailsScreen extends StatefulWidget {
  final String? userId;
  const MoreDetailsScreen({super.key, this.userId});

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  final TextEditingController dobController = TextEditingController();

  final TextEditingController eddController = TextEditingController();
  ValueNotifier<String> buttonNotifier = ValueNotifier('');
  DetailType selectType = DetailType.EDD;
  bool isSelected = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
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
                  fit: BoxFit.cover,
                  opacity: 1,
                ),
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Additional details',
                              textAlign: TextAlign.center,
                              style: CustomLabels.pbody1TextStyle(
                                fontSize: 23,
                                fontWeight: CustomLabels.largeFontWeight,
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              label: 'Date of Birth',
                              controller: dobController,
                              borderColor: AppColors.secondaryTextColor,
                              hintText: 'Select date of birth',
                              readOnly: true,
                              onChanged: (_) =>
                                  buttonNotifier.value = dobController.text,
                              suffix: InkWell(
                                onTap: () => _pickDob(context),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Which of these do you know?',
                              style: CustomLabels.pbody1TextStyle(
                                fontSize: 14,
                                color: AppColors.greyTextColor,
                                fontWeight: CustomLabels.verySmallFontWeight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildRadioOption(
                              title: 'Estimated Date of Delivery (EDD)',
                              value: DetailType.EDD,
                            ),
                            _buildRadioOption(
                              title: 'Date of last Menstruation (LMP)',
                              value: DetailType.LMP,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: selectType == DetailType.EDD
                                  ? 'Estimated Due Date'
                                  : 'Last Menstrual Period',
                              onChanged: (_) =>
                                  buttonNotifier.value = eddController.text,
                              controller: eddController,
                              borderColor: AppColors.secondaryTextColor,
                              hintText: 'Select date',
                              readOnly: true,
                              suffix: InkWell(
                                onTap: () => _pickEddOrLmp(context),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) {
                                    setState(() => isSelected = value ?? false);
                                  },
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I agree to the ',
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: const TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                          const TextSpan(
                                            text: ' and ',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: const TextStyle(
                                              color: AppColors.primaryColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ValueListenableBuilder(
                              valueListenable: buttonNotifier,
                              builder: (context, value, child) {
                                final canSubmit = dobController.text.isNotEmpty &&
                                    eddController.text.isNotEmpty &&
                                    isSelected;
                                return CustomButton(
                                  text: 'Submit',
                                  borderColor: canSubmit
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  backgroundColor: canSubmit
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  textStyle: CustomLabels.body3GreyTextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                  isEnabled: canSubmit,
                                  onPressed: canSubmit
                                      ? () {
                                          submitAdditionalDetails(
                                            dob: dobController.text,
                                            userId: widget.userId ?? '',
                                            eed: selectType == DetailType.EDD
                                                ? eddController.text
                                                : '',
                                            lmp: selectType == DetailType.LMP
                                                ? eddController.text
                                                : '',
                                          );
                                        }
                                      : null,
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            ValueListenableBuilder(
                              valueListenable: buttonNotifier,
                              builder: (context, value, child) {
                                final canSkip = dobController.text.isEmpty &&
                                    eddController.text.isEmpty;
                                return CustomButton(
                                  text: 'Skip',
                                  isEnabled: canSkip,
                                  borderColor: canSkip
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  backgroundColor: canSkip
                                      ? AppColors.primaryColor
                                      : AppColors.secondaryTextColor
                                          .withValues(alpha: .5),
                                  textStyle: CustomLabels.body3GreyTextStyle(
                                    fontSize: 16,
                                    color: AppColors.whiteColor,
                                  ),
                                  onPressed: canSkip
                                      ? () => skipInformation(widget.userId ?? '')
                                      : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildRadioOption({
    required String title,
    required DetailType value,
  }) {
    return RadioListTile<DetailType>(
      value: value,
      groupValue: selectType,
      onChanged: (selected) {
        if (selected == null) return;
        setState(() {
          selectType = selected;
          eddController.clear();
          buttonNotifier.value = '';
        });
      },
      activeColor: AppColors.primaryColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        title,
        style: CustomLabels.pbody1TextStyle(
          fontSize: 14,
          color: AppColors.blackColor,
          fontWeight: CustomLabels.verySmallFontWeight,
        ),
      ),
    );
  }

  Future<void> _pickDob(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = _formatDate(pickedDate);
      buttonNotifier.value = dobController.text;
    }
  }

  Future<void> _pickEddOrLmp(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: selectType == DetailType.EDD
          ? DateTime.now()
          : DateTime.now().subtract(const Duration(days: 280)),
      lastDate: selectType == DetailType.LMP
          ? DateTime.now()
          : DateTime.now().add(const Duration(days: 280)),
    );
    if (pickedDate != null) {
      eddController.text = _formatDate(pickedDate);
      buttonNotifier.value = eddController.text;
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> skipInformation(String userId) async {
    try {
      final data = await ApiClient.postForm(
        ApiConfig.registerSkip,
        {'user_id': userId},
        authenticated: true,
      );
      Fluttertoast.showToast(msg: data['message']?.toString() ?? 'Skipped');
      if (mounted) context.go(Routes.acknowledgement);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Future<void> submitAdditionalDetails({
    required String dob,
    required String userId,
    required String lmp,
    required String eed,
  }) async {
    if (!await AuthService.hasSession()) return;

    try {
      setState(() => isLoading = true);
      await ApiClient.postForm(
        ApiConfig.completeRegistration,
        {
          'dob': dob,
          'user_id': userId,
          'lmp': lmp,
          'eed': eed,
        },
        authenticated: true,
      );
      await ProfileCache.save({
        'user_id': userId,
        'dob': dob,
        'lmp': lmp,
        'eed': eed,
      });
      if (mounted) {
        Fluttertoast.showToast(msg: 'Registration completed successfully');
        context.go(Routes.acknowledgement);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
