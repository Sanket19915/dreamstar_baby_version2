import 'dart:convert';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/features/setting/setting_screen.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class BabyCard extends StatefulWidget {
  final bool? isrefresh;
  const BabyCard({super.key, this.isrefresh = false});

  @override
  State<BabyCard> createState() => _BabyCardState();
}

class _BabyCardState extends State<BabyCard> {
  Map<String, dynamic> userProfile = {};
  String firstName = '';
  String profilePicture = '';
  bool isLoading = false;
  var weight = ' KG';
  var height = ' CM';
  var weeks = '';
  var days = '';
  var sizes = '';
  var images = '';
  var total_day = '';
  var babyData;
  @override
  void initState() {
    super.initState();
    fetchUserDataAndBabyData();
  }

  @override
  void didUpdateWidget(BabyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isrefresh ?? false) {
      fetchUserDataAndBabyData();
    }
  }

  Future<void> fetchUserDataAndBabyData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _fetchUserProfile();
      await fetchBabyData(1, 1);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
          profilePicture = data['profile_pic'] ?? '';
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
    var url = Uri.parse('http://dreambaby.pro/api/baby_data');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(url, headers: headers);

      var contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        var data = json.decode(response.body);
        if (response.body.contains("message")) {
          Fluttertoast.showToast(msg: data["message"]);
        } else {
          setState(() {
            total_day = data['total_days']?.toString() ?? '0';
            babyData = data["data"][0];
            weight = babyData['weight']?.toString() ?? '0.0 KG';
            height = babyData['height']?.toString() ?? '0 CM';
            weeks = babyData['week']?.toString() ?? '0';
            days = babyData['day']?.toString() ?? '0';
            sizes = babyData['size']?.toString() ?? '';
            images = babyData['image']?.toString() ?? '';
          });
        }

        print('total_days: $total_day, Weight: $weight, Height: $height, Weeks: $weeks, Days: $days, Size: $sizes');
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching baby data: $e');
      throw Exception('Error fetching baby data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    print(total_day);
    double percent = (double.tryParse(total_day) ?? 0) / 281; // Compute the percentage here
    // print('Percent: $percent'); // Debug print to check the value of percent
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 100,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: deviceHeight * 0.201,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },

                //=> GoRouter.of(context).push(Routes.settingsScreen),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 20, backgroundImage: NetworkImage("http://dreambaby.pro/storage/$profilePicture")),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Hi ${firstName.toString()[0].toUpperCase()}${firstName.toString().substring(1).toLowerCase()},',
                      style: GoogleFonts.lobsterTwo(
                          color: AppColors.blackColor, fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              babyData == null
                  ? SvgPicture.asset(AppImages.noEddImg)
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: math.max(deviceHeight * .059, 170), minHeight: 170),
                      child: Container(
                        height: deviceHeight * 0.201,
                        decoration: BoxDecoration(
                          color: AppColors.cardColor.withValues(alpha: .3),
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
                                    padding: const EdgeInsets.only(left: 10, top: 20, right: 5, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                          textAlign: TextAlign.start,
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
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Size:',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      height: 1,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.greyTextColor)),
                                              TextSpan(
                                                text: '       $sizes',
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
                                          textAlign: TextAlign.start,
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
                                                text: '      $weeks Weeks \n               $days Days',
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
                                          child: images.isEmpty
                                              ? Image.asset(
                                                  AppImages.bellPepper,
                                                  height: 40,
                                                )
                                              : Image.network(
                                                  "http://dreambaby.pro/storage/$images",
                                                  height: 40,
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          child: AutoSizeText(
                                            height,
                                            textAlign: TextAlign.start,
                                            minFontSize: 13,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lobsterTwo(
                                                color: AppColors.babySizeColor, fontWeight: FontWeight.w700),
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
                                center: SizedBox(
                                  width: deviceWidth / 3,
                                  child: const Image(
                                    image: AssetImage(AppImages.baby),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                radius: deviceWidth / 5.5,
                                lineWidth: 8.0,
                                animation: true,
                                percent: percent,
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: AppColors.whiteColor.withValues(alpha: .85),
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
