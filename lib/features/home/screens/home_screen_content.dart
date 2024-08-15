import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/features/home/screens/card_details.dart';
import 'package:dream_baby/features/home/screens/four_quotients.dart';
import 'package:dream_baby/features/rough.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../services/auth_services.dart';
import '../../questions/sq/existential.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  List<String> quotients = [
    "Kinesthetic",
    "Logical",
    "Linguistic",
    "Spatial Visual",
    "Musical",
    "Intrapersonal",
    "Interpersonal",
    "Naturalistic",
    "Existential",
  ];
  String todayQuestionStatus = "";
  Map<String, bool> quotientStatuses = {};
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    fetchQuotientStatuses();
    getTodaysQuestionStatus();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0) {
        setState(() {
          _isAppBarTransparent = false;
        });
      } else {
        setState(() {
          _isAppBarTransparent = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            _isAppBarTransparent ? Colors.transparent : AppColors.whiteColor,
        leadingWidth: double.infinity,
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Share.share(
                    sharePositionOrigin: Rect.fromCenter(
                        center: Offset.zero, width: width, height: height),
                    'Experience the Best Online Garbhasanskar Community in India!');
              },
              child: Image.asset(
                AppImages.share,
                height: 24,
              ),
            ),
            Row(
              children: [
                Image.asset(
                  AppImages.logoN,
                  height: 45,
                ),
                Text(
                  'DreamStar Baby',
                  style: GoogleFonts.lobsterTwo(
                      color: AppColors.mainColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            InkWell(
              onTap: () => GoRouter.of(context).push(Routes.notification),
              child: Image.asset(
                AppImages.bell,
                height: 24,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => onRefresh(),
        child: SingleChildScrollView(
          controller: _scrollController,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.bg), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.140,
                ),
                BabyCard(isrefresh: isRefresh),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    int nextIndex = -1;
                    while (nextIndex < quotients.length - 1) {
                      nextIndex++;
                      if (quotientStatuses[quotients[nextIndex]] == false) {
                        break;
                      }
                    }
                    // If no incomplete quotient was found and nextIndex is at the end, check from the start
                    if (nextIndex == quotients.length - 1 &&
                        quotientStatuses[quotients[nextIndex]] == true) {
                      for (int i = 0; i < quotients.length; i++) {
                        if (quotientStatuses[quotients[i]] == false) {
                          nextIndex = i;
                          break;
                        }
                      }
                    }
                    // Ensure the index is within bounds and valid (incomplete status)
                    if (nextIndex < quotients.length &&
                        quotientStatuses[quotients[nextIndex]] == false) {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (ctx) => ExistentialScreen(
                            from: quotients[nextIndex],
                            quotientStatuses: quotientStatuses,
                            index: nextIndex,
                          ),
                        ),
                      )
                          .then((e) {
                        fetchQuotientStatuses();
                        getTodaysQuestionStatus();
                      });
                    }
                  },
                  child: AutoSizeText(
                    'Daily Activities for Baby’s Development ',
                    style: GoogleFonts.poppins(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    minFontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                if (todayQuestionStatus.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      int nextIndex = -1;
                      while (nextIndex < quotients.length - 1) {
                        nextIndex++;
                        if (quotientStatuses[quotients[nextIndex]] == false) {
                          break;
                        }
                      }
                      // If no incomplete quotient was found and nextIndex is at the end, check from the start
                      if (nextIndex == quotients.length - 1 &&
                          quotientStatuses[quotients[nextIndex]] == true) {
                        for (int i = 0; i < quotients.length; i++) {
                          if (quotientStatuses[quotients[i]] == false) {
                            nextIndex = i;
                            break;
                          }
                        }
                      }
                      // Ensure the index is within bounds and valid (incomplete status)
                      if (nextIndex < quotients.length &&
                          quotientStatuses[quotients[nextIndex]] == false) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (ctx) => ExistentialScreen(
                              from: quotients[nextIndex],
                              quotientStatuses: quotientStatuses,
                              index: nextIndex,
                            ),
                          ),
                        )
                            .then((e) {
                          fetchQuotientStatuses();
                          getTodaysQuestionStatus();
                        });
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        todayQuestionStatus,
                        style: GoogleFonts.poppins(
                            color: AppColors.blackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        minFontSize: 13,
                      ),
                    ),
                  ),
                SizedBox(
                  height: height * 0.01,
                ),
                FourQuotients(
                  notifyWidget: () {
                    getTodaysQuestionStatus();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () => GoRouter.of(context).push(Routes.knowEntry),
                  child: Container(
                    height: height * 0.11,
                    width: width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.know), fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AmazonLinkWidget(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    setState(() {
      isRefresh = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isRefresh = false;
    });
  }

  Future<void> fetchQuotientStatuses() async {
    var token = await AuthService.getToken();
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('http://dreambaby.pro/api/user-question-status'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      final statuses = data['statuses'] as Map<String, dynamic>;

      setState(() {
        quotientStatuses =
            statuses.map((key, value) => MapEntry(key, value as bool));
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getTodaysQuestionStatus() async {
    try {
      var token = await AuthService.getToken();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.Request(
          'GET', Uri.parse('http://dreambaby.pro/api/questions/status/today'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        print(responseData);

        int? flagged = jsonDecode(responseData)['flagged'];

        todayQuestionStatus = "Today's $flagged Flagged Activities";

        setState(() {});

        print(todayQuestionStatus);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
