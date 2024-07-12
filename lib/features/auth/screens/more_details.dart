import 'dart:convert';

import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../router/routes.dart';
import '../../../shared/helper/app_color.dart';
import '../../../shared/helper/app_images.dart';
import '../../../shared/helper/app_label.dart';
import '../../../shared/widget/custom_button.dart';

enum DetailType { EDD, LMP }

class MoreDetailsScreen extends StatefulWidget {
 final String ?userId;
  const MoreDetailsScreen({super.key ,this.userId});

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  final TextEditingController dobController = TextEditingController();

  final TextEditingController eddController = TextEditingController();
  DetailType selectType = DetailType.EDD;
  bool isSelected = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Additional details',
                              style: CustomLabels.pbody1TextStyle(
                                fontSize: 23,
                                fontWeight: CustomLabels.largeFontWeight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            controller: dobController,
                            borderColor: AppColors.secondaryTextColor,
                            hintText: 'Date of Birth',
                            readOnly: true,
                            suffix: InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  dobController.text =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                }
                              },
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Which of these do you know ?',
                            style: CustomLabels.pbody1TextStyle(
                              fontSize: 14,
                              color: AppColors.greyTextColor,
                              fontWeight: CustomLabels.verySmallFontWeight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Date of Delivery  (EDD)',
                                    style: CustomLabels.pbody1TextStyle(
                                      fontSize: 14,
                                      color: AppColors.blackColor,
                                      fontWeight:
                                          CustomLabels.verySmallFontWeight,
                                    ),
                                  ),
                                  Radio(
                                    value: DetailType.EDD,
                                    groupValue: selectType,
                                    onChanged: (value) {
                                      eddController.text = "";
                                      setState(() {
                                        selectType = value!;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date of last Menstruation  (LMP)',
                                  style: CustomLabels.pbody1TextStyle(
                                    fontSize: 14,
                                    color: AppColors.blackColor,
                                    fontWeight:
                                        CustomLabels.verySmallFontWeight,
                                  ),
                                ),
                                Radio(
                                  value: DetailType.LMP,
                                  groupValue: selectType,
                                  onChanged: (value) {
                                    eddController.text = "";
                                    setState(() {
                                      selectType = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          CustomTextField(
                            controller: eddController,
                            borderColor: AppColors.secondaryTextColor,
                            hintText: 'Enter date',
                            readOnly: true,
                            suffix: InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: selectType == DetailType.EDD
                                      ? DateTime.now()
                                      : DateTime(1900),
                                  lastDate: selectType == DetailType.LMP
                                      ? DateTime.now()
                                      : DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  eddController.text =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                }
                              },
                              child: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    isSelected = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "I agree to the ",
                                    style:
                                        const TextStyle(color: Colors.black45),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Terms and Conditions',
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // context.go(Routes.login);
                                          },
                                      ),
                                      const TextSpan(
                                        text: " and ",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // context.go(Routes.login);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Submit',
                            // isEnabled: isFormValid,
                            borderColor:
                                // isFormValid
                                // ?
                                AppColors.primaryColor,
                            // : AppColors.secondaryTextColor.withOpacity(.5),
                            backgroundColor:
                                //  isFormValid
                                // ?

                                AppColors.primaryColor,
                            // :
                            //  AppColors.secondaryTextColor.withOpacity(.5),
                            textStyle: CustomLabels.body3GreyTextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                            ),
                            onPressed: () {
                              submitAdditionalDetails(
                                  dob: dobController.text,
                                  userId: widget.userId??"",
                                  eed: selectType == DetailType.EDD
                                      ? eddController.text
                                      : "",
                                  lmp: selectType == DetailType.LMP
                                      ? eddController.text
                                      : "");
                            },
                          ),
                          CustomButton(
                            text: 'Skip',
                            isEnabled: false,
                            borderColor: AppColors.whiteColor,
                            backgroundColor: AppColors.whiteColor,
                            textStyle: CustomLabels.body3GreyTextStyle(
                              fontSize: 14,
                              color: AppColors.greyTextColor,
                            ),
                            onPressed: () => skipInformation(widget.userId ?? ""),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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

  Future<void> skipInformation(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://dreambaby.pro/api/auth/register/skip'),
        body: {
          'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        Fluttertoast.showToast(msg: data["message"]);
        context.go(Routes.home);
      } else {
        Fluttertoast.showToast(msg: "skip faild");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "something went wrong");
    }
  }

  Future<void> submitAdditionalDetails({
    required String dob,
    required String userId,
    required String lmp,
    required String eed,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse('http://dreambaby.pro/api/auth/complete-registration'),
        body: {
          'dob': dob,
          'user_id': userId,
          'lmp': lmp,
          'eed': eed,
        },
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Registration completed successfully");
        context.go(Routes.home);
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
    }
  }
}
