import 'package:dream_baby/shared/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../../../shared/helper/app_color.dart';
import '../../../shared/helper/app_images.dart';
import '../../../shared/helper/app_label.dart';
import '../../../shared/widget/custom_button.dart';

enum DetailType { EDD, LMP }

class MoreDetailsScreen extends StatefulWidget {
  const MoreDetailsScreen({super.key});

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  final TextEditingController dobController = TextEditingController();

  final TextEditingController eddController = TextEditingController();
  DetailType selectType = DetailType.EDD;
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
        child: Container(
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
                    Text(
                      'Additional details',
                      style: CustomLabels.pbody1TextStyle(
                        fontSize: 23,
                        fontWeight: CustomLabels.largeFontWeight,
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
                    SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Date of Delivery  (EDD)',
                            style: CustomLabels.pbody1TextStyle(
                              fontSize: 14,
                              color: AppColors.blackColor,
                              fontWeight: CustomLabels.verySmallFontWeight,
                            ),
                          ),
                          Radio(
                            value: DetailType.EDD,
                            groupValue: selectType,
                            onChanged: (value) {},
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date of last Menstruation  (LMP)',
                          style: CustomLabels.pbody1TextStyle(
                            fontSize: 14,
                            color: AppColors.blackColor,
                            fontWeight: CustomLabels.verySmallFontWeight,
                          ),
                        ),
                        Radio(
                          value: DetailType.LMP,
                          groupValue: selectType,
                          onChanged: (value) {},
                        )
                      ],
                    ),
                    CustomTextField(
                      controller: dobController,
                      borderColor: AppColors.secondaryTextColor,
                      hintText: 'Enter date',
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
                      onPressed: () {},
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     children: [

        //       TextField(
        //         controller: eddController,
        //         decoration: const InputDecoration(labelText: 'EDD or LMP Date'),

        //       ),
        //       const SizedBox(height: 20),
        //       ElevatedButton(
        //         onPressed: () {
        //           // Submit details to backend or skip
        //           Navigator.pop(context);
        //         },
        //         child: const Text('Submit'),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: const Text('Skip'),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
