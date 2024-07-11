import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class BabyCard extends StatefulWidget {
  const BabyCard({super.key});

  @override
  State<BabyCard> createState() => _BabyCardState();
}

class _BabyCardState extends State<BabyCard> {
  String firstName = '';
  String profilePicture = '';
  var weight = '0.9 KG';
  var height = '22 CM';
  var weeks = '20';
  var days = '13';
  var sizes = 'Bell Pepper';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchBabyData(1, 1);
  }

  Future<void> _fetchUserProfile() async {
    try {
      var token = await AuthService.getToken();
      var url = Uri.parse('http://dreambaby.pro/api/profile');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          firstName = data['first_name'] ?? '';
          profilePicture = data['profile_picture'] ?? '';
        });
      } else {
        print('Failed to fetch user profile: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> fetchBabyData(int week, int day) async {
    var token = await AuthService.getToken();
    var url =
        Uri.parse('http://dreambaby.pro/api/baby_data?week=$week&day=$day');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Cookie': 'XSRF-TOKEN=your-token; laravel_session=your-session'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          var data = json.decode(response.body);

          setState(() {
            weight = data[0]['weight']?.toString() ?? '0.0 KG';
            height = data[0]['height']?.toString() ?? '0 CM';
            weeks = data[0]['week']?.toString() ?? '0';
            days = data[0]['day']?.toString() ?? '0';
            sizes = data[0]['size']?.toString() ?? '';
          });

          print(
              'Weight: $weight, Height: $height, Weeks: $weeks, Days: $days, Size: $sizes');
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch baby data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching baby data: $e');
      throw Exception('Error fetching baby data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        InkWell(
          onTap: () => GoRouter.of(context).push(Routes.settingsScreen),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profilePicture.isNotEmpty
                    ? profilePicture
                    : 'https://picsum.photos/200/300'),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Hi $firstName,',
                style: GoogleFonts.lobsterTwo(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: math.max(deviceHeight * .059, 170), minHeight: 170),
          child: Container(
            height: deviceHeight * 0.201,
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
                                    text: '  $weight',
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
                                    text: '   $height',
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
                                        '        $weeks Weeks \n               $days Days',
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
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                sizes,
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
