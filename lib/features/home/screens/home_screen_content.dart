import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/features/home/screens/card_details.dart';
import 'package:dream_baby/features/home/screens/four_quotients.dart';
import 'package:dream_baby/features/rough.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/auth_services.dart';
import '../../questions/sq/existential.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  List<String> quotients = [
    "Existential",
    "Kinesthetic",
    "Logical",
    "Linguistic",
    "Spatial Visual",
    "Musical",
    "Intrapersonal",
    "Naturalistic",
    "Interpersonal",
  ];

  String todayQuestionStatus = "";
  Map<String, bool> quotientStatuses = {};
  //final ScrollController _scrollController = ScrollController();
  final bool _isAppBarTransparent = true;
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();

    fetchQuotientStatuses();
    getTodaysQuestionStatus();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels > 0) {
    //     setState(() {
    //       _isAppBarTransparent = false;
    //     });
    //   } else {
    //     setState(() {
    //       _isAppBarTransparent = true;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    fetchQuotientStatuses();
    getTodaysQuestionStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffF0F1FC),
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
          //controller: _scrollController,
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
                            onExit: () {
                              fetchQuotientStatuses();
                              getTodaysQuestionStatus();
                            },
                          ),
                        ),
                      )
                          .then((shouldRefresh) async {
                        if (shouldRefresh == true) {
                          await fetchQuotientStatuses();
                          await getTodaysQuestionStatus();
                          setState(() {});
                        }
                      });
                    }
                  },
                  child: AutoSizeText(
                    'Daily Activities for Baby’s Development ',
                    style: GoogleFonts.poppins(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
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
                              onExit: () {
                                fetchQuotientStatuses();
                                getTodaysQuestionStatus();
                                setState(() {});
                              },
                            ),
                          ),
                        )
                            .then((shouldRefresh) async {
                          if (shouldRefresh == true) {
                            await fetchQuotientStatuses();
                            await getTodaysQuestionStatus();
                            setState(() {});
                          }
                        });
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        todayQuestionStatus,
                        style: GoogleFonts.poppins(
                            color: AppColors.blackColor,
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        minFontSize: 13,
                      ),
                    ),
                  ),
                SizedBox(
                  height: height * 0.01,
                ),
                FutureBuilder<void>(
                  future: fetchQuotientStatuses1(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 420,
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 190.0,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 190.0,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    height: 190.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    height: 190.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return FourQuotients(
                        quotientStatuses: quotientStatuses,
                        notifyWidget: () {
                          fetchQuotientStatuses();
                          getTodaysQuestionStatus();
                          print("refresh screen");
                        },
                      );
                    }
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
                const SizedBox(
                  height: 20,
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
    try {
      await Future.wait([
        fetchQuotientStatuses(),
        getTodaysQuestionStatus(),
      ]);
    } catch (e) {
      print('Error refreshing data: $e');
    } finally {
      setState(() {
        isRefresh = false;
      });
    }
  }

  Future<void> fetchQuotientStatuses() async {
    try {
      var token = await AuthService.getToken();
      var response = await http.get(
        Uri.parse('http://dreambaby.pro/api/user-question-status'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final statuses = data['statuses'] as Map<String, dynamic>;

        quotientStatuses =
            statuses.map((key, value) => MapEntry(key, value as bool));

        if (mounted) {
          setState(() {});
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchQuotientStatuses1() async {
    try {
      var token = await AuthService.getToken();
      var response = await http.get(
        Uri.parse('http://dreambaby.pro/api/user-question-status'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Response status: ${response.statusCode}");
      //print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // if (mounted) {
        //   setState(() {});
        // }
        // Process the data
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching data: $e");
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
        //print(responseData);
        await Future.delayed(const Duration(seconds: 2));
        // await Future.delayed(const Duration(milliseconds: 2500));
        int? flagged = jsonDecode(responseData)['flagged'];

        todayQuestionStatus = "Today's $flagged Flagged Activities";

        if (mounted) {
          setState(() {});
        }

        //print(todayQuestionStatus);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
    }
  }
}
