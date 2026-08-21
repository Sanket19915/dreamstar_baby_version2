import 'dart:convert';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/core/config/api_config.dart';
import 'package:dream_baby/core/network/api_client.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (!await AuthService.hasSession()) return;

    try {
      final data = await ApiClient.get(ApiConfig.profile, authenticated: true);
      if (mounted) {
        setState(() {
          firstName = data['first_name']?.toString() ?? '';
          profilePicture = data['profile_pic']?.toString() ?? '';
        });
        await ProfileCache.save(data);
      }
    } catch (e) {
      final cached = ProfileCache.read();
      if (cached != null && mounted) {
        setState(() {
          firstName = cached['first_name']?.toString() ?? '';
          profilePicture = cached['profile_pic']?.toString() ?? '';
        });
      } else {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> fetchBabyData(int week, int day) async {
    if (!await AuthService.hasSession()) return;

    try {
      final data = await ApiClient.get(ApiConfig.babyData, authenticated: true);

      if (data.containsKey('message')) {
        return;
      }

      final dataList = data['data'];
      if (dataList is! List || dataList.isEmpty) return;

      final item = dataList[0];
      if (item is! Map<String, dynamic>) return;

      if (mounted) {
        setState(() {
          total_day = data['total_days']?.toString() ?? '0';
          babyData = item;
          weight = item['weight']?.toString() ?? '0.0 KG';
          height = item['height']?.toString() ?? '0 CM';
          weeks = item['week']?.toString() ?? '0';
          days = item['day']?.toString() ?? '0';
          sizes = item['size']?.toString() ?? '';
          images = item['image']?.toString() ?? '';
        });
      }
    } catch (e) {
      _applyCachedPregnancyProgress();
      print('Error fetching baby data: $e');
    }
  }

  void _applyCachedPregnancyProgress() {
    final pregnancyDays = ProfileCache.pregnancyDayCount();
    if (pregnancyDays == null || !mounted) return;

    setState(() {
      total_day = pregnancyDays.toString();
      weeks = '${pregnancyDays ~/ 7}';
      days = '${pregnancyDays % 7}';
    });
  }

  String _greetingText() {
    final name = firstName.trim();
    if (name.isEmpty) return 'Hi there,';
    if (name.length == 1) return 'Hi ${name.toUpperCase()},';
    return 'Hi ${name[0].toUpperCase()}${name.substring(1).toLowerCase()},';
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    print(total_day);
    double percent =
        (double.tryParse(total_day) ?? 0) / 281; // Compute the percentage here
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
                onTap: () => context.push(Routes.settingsScreen),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.secondaryTextColor,
                      backgroundImage: profilePicture.isNotEmpty
                          ? NetworkImage(ApiConfig.storageUrl(profilePicture))
                          : null,
                      child: profilePicture.isEmpty
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greetingText(),
                          style: GoogleFonts.lobsterTwo(
                              color: AppColors.blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Pregnancy Journey',
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                      constraints: BoxConstraints(
                          maxHeight: math.max(deviceHeight * .059, 170),
                          minHeight: 170),
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
                          fit: StackFit.expand,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 20, right: 5, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .greyTextColor)),
                                              TextSpan(
                                                text: '  $weight',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.blackColor),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .greyTextColor),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .greyTextColor)),
                                              TextSpan(
                                                text: '       $sizes',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.blackColor),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .greyTextColor),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .greyTextColor)),
                                              TextSpan(
                                                text:
                                                    '      $weeks Weeks \n               $days Days',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.blackColor),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    height: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .greyTextColor),
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
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: images.isEmpty
                                              ? Image.asset(
                                                  AppImages.bellPepper,
                                                  height: 40,
                                                )
                                              : Image.network(
                                                  ApiConfig.storageUrl(images),
                                                  height: 40,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      AppImages.bellPepper,
                                                      height: 40,
                                                    );
                                                  },
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.center,
                                          child: AutoSizeText(
                                            height,
                                            textAlign: TextAlign.start,
                                            minFontSize: 13,
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
                              height: deviceHeight * 0.201,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 25),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final containerWidth = constraints.maxWidth;

                                  // Limit max size for tablet
                                  final double radius =
                                      (containerWidth * 0.18).clamp(70.0, 85.0);
                                  final double imageWidth =
                                      (containerWidth * 0.18).clamp(120, 340);
                                  return CircularPercentIndicator(
                                    center: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: deviceWidth / 3,
                                        height: deviceWidth / 3,
                                        child: const Image(
                                          image: AssetImage(AppImages.baby),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    radius: radius,
                                    lineWidth: 8,
                                    animation: true,
                                    percent: percent.clamp(0.0, 1.0),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: AppColors.whiteColor
                                        .withValues(alpha: .85),
                                    progressColor: AppColors.mainColor,
                                  );
                                },
                              ),
                            ),
                            // Container(
                            //   height: deviceHeight * 0.201,
                            //   padding: const EdgeInsets.only(left: 25),
                            //   alignment: Alignment.center,
                            //   child: CircularPercentIndicator(
                            //     center: SizedBox(
                            //       width: deviceWidth / 3,
                            //       child: const Image(
                            //         image: AssetImage(AppImages.baby),
                            //         fit: BoxFit.fill,
                            //       ),
                            //     ),
                            //     radius: deviceWidth / 5.5,
                            //     lineWidth: 8.0,
                            //     animation: true,
                            //     percent: percent,
                            //     circularStrokeCap: CircularStrokeCap.round,
                            //     backgroundColor:
                            //         AppColors.whiteColor.withValues(alpha: .85),
                            //     progressColor: AppColors.mainColor,
                            //     rotateLinearGradient: true,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
            ],
          );
  }
}
