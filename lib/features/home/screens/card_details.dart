import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math' as math;

class BabyCard extends StatefulWidget {
  const BabyCard({super.key});

  @override
  State<BabyCard> createState() => _BabyCardState();
}

class _BabyCardState extends State<BabyCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://picsum.photos/200/300'),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Hi, Samiksha',
              style: GoogleFonts.lobsterTwo(
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: math.max(height * .059, 170), minHeight: 170),
          child: Container(
            height: height * 0.201,
            decoration: BoxDecoration(
              color: AppColors.cardColor.withOpacity(.3),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, top: 20, right: 5, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'Baby’s milestone today',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyTextColor),
                              minFontSize: 9,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Weight:',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyTextColor)),
                                  TextSpan(
                                    text: '  0.5 KG',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Height:',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyTextColor)),
                                  TextSpan(
                                    text: '   22 CM',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Age:',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyTextColor)),
                                  TextSpan(
                                    text:
                                        '        20 Weeks \n               13 Days',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        height: 1,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyTextColor),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            AutoSizeText(
                              '*Std. Est.',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyTextColor),
                              minFontSize: 7,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(top: 20, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'Your baby is the size of a',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyTextColor),
                              minFontSize: 9,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20),
                              child: Image.asset(
                                AppImages.bellPepper,
                                height: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 25),
                              child: AutoSizeText(
                                'Bell Pepper',
                                textAlign: TextAlign.end,
                                minFontSize: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lobsterTwo(
                                    color: AppColors.babySizeColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 25),
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    center: const SizedBox(
                      height: 134,
                      child: Image(
                        image: AssetImage(AppImages.baby),
                        fit: BoxFit.cover,
                      ),
                    ),
                    radius: 74.0,
                    lineWidth: 8.0,
                    animation: true,
                    percent: 0.65,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: AppColors.whiteColor.withOpacity(.85),
                    progressColor: AppColors.mainColor,
                    rotateLinearGradient: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
