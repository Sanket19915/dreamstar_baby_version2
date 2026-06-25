// ignore_for_file: dead_code

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FourQuotients extends StatefulWidget {
  final Map<String, bool> quotientStatuses;
  final void Function() notifyWidget;
  const FourQuotients(
      {super.key, required this.notifyWidget, required this.quotientStatuses});

  @override
  State<FourQuotients> createState() => _FourQuotientsState();
}

class _FourQuotientsState extends State<FourQuotients> {
  List<String> quotients = [
    "Existential",
    "Kinesthetic",
    "Interpersonal",
    "Intrapersonal",
    "Naturalistic",
    "Linguistic",
    "Spatial Visual",
    "Logical",
    "Musical"
  ];

  Map<String, bool> quotientStatuses = {};
  bool allQuotientStatuses = false;

  @override
  void initState() {
    super.initState();
    // // fetchQuotientStatuses();
    quotientStatuses = widget.quotientStatuses;
    List<bool> quotientStatusesList =
        quotientStatuses.entries.map((e) => e.value).toList();

    if (quotientStatusesList.isNotEmpty) {
      allQuotientStatuses =
          quotientStatusesList.every((element) => element == true);
    }
  }

  // Future<void> fetchQuotientStatuses() async {
  //   var token = await AuthService.getToken();
  //   var response = await http.get(
  //     Uri.parse('http://dreambaby.pro/api/user-question-status'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //   print("Response status: ${response.statusCode}");

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final statuses = data['statuses'] as Map<String, dynamic>;

  //     // setState(() {
  //     quotientStatuses =
  //         statuses.map((key, value) => MapEntry(key, value as bool));
  //     // });
  //     print(quotientStatuses);

  //     List<bool> quotientStatusesList =
  //         quotientStatuses.entries.map((e) => e.value).toList();

  //     if (quotientStatusesList.isNotEmpty) {
  //       allQuotientStatuses =
  //           quotientStatusesList.every((element) => element == true);

  //       // setState(() {});
  //     }
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: (width > 450) ? 550 : 390,
      child: Column(
        children: [
          if (allQuotientStatuses)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: AutoSizeText(
                  'All activities are completed for the day',
                  style: GoogleFonts.poppins(
                      color: AppColors.whiteColor,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  minFontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'SPIRITUAL QUOTIENT',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'PHYSICAL QUOTIENT',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (ctx) => ExistentialScreen(
                              index: 0,
                              from: quotients[0],
                              quotientStatuses: quotientStatuses,
                              onExit: () {
                                // Add the logic you want to execute when exiting the ExistentialScreen
                                // For example, you might want to refresh the quotient statuses
                                // fetchQuotientStatuses();
                                widget.notifyWidget();
                              },
                            ),
                          ),
                        )
                            .then((e) {
                          // fetchQuotientStatuses();
                          widget.notifyWidget();
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.greenCBE0CF,
                              image: DecorationImage(
                                  image: AssetImage(
                                      AppImages.eexistentialWithoutBg),
                                  fit: BoxFit.contain),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: quotientStatuses['Existential'] == true
                                  ? Image.asset(
                                      AppImages.check,
                                      height: 15,
                                      width: 15,
                                    )
                                  : Image.asset(
                                      AppImages.uncheck,
                                      height: 15,
                                      width: 15,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (ctx) => ExistentialScreen(
                              from: quotients[1],
                              quotientStatuses: quotientStatuses,
                              index: 1,
                              onExit: () {
                                // Add the logic you want to execute when exiting the ExistentialScreen
                                // For example, you might want to refresh the quotient statuses
                                // fetchQuotientStatuses();
                                widget.notifyWidget();
                              },
                            ),
                          ),
                        )
                            .then((e) {
                          // fetchQuotientStatuses();
                          widget.notifyWidget();
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  AppColors.orangeCF6747.withValues(alpha: .30),
                              image: DecorationImage(
                                  image: AssetImage(AppImages.kineImg),
                                  fit: BoxFit.contain),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: quotientStatuses['Kinesthetic'] == true
                                  ? Image.asset(
                                      AppImages.check,
                                      height: 15,
                                      width: 15,
                                    )
                                  : Image.asset(
                                      AppImages.uncheck,
                                      height: 15,
                                      width: 15,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[2],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 2,
                                                onExit: () {
                                                  // Add the logic you want to execute when exiting the ExistentialScreen
                                                  // For example, you might want to refresh the quotient statuses
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: AppColors.yellowEFD892,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .interpersonalWithoutBg),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Interpersonal'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[3],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 3,
                                                onExit: () {
                                                  // Add the logic you want to execute when exiting the ExistentialScreen
                                                  // For example, you might want to refresh the quotient statuses
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.yellowF6DA7E
                                                      .withValues(alpha: 0.80),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .intrapersonalWithoutBg),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Intrapersonal'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (ctx) => ExistentialScreen(
                                            from: quotients[4],
                                            quotientStatuses: quotientStatuses,
                                            index: 4,
                                            onExit: () {
                                              // Add the logic you want to execute when exiting the ExistentialScreen
                                              // For example, you might want to refresh the quotient statuses
                                              // fetchQuotientStatuses();
                                              widget.notifyWidget();
                                            },
                                          ),
                                        ),
                                      )
                                          .then((e) {
                                        // fetchQuotientStatuses();
                                        widget.notifyWidget();
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: AppColors.yellowEFE8B2,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                  image: AssetImage(AppImages
                                                      .naturalisticWithoutBg),
                                                  fit: BoxFit.contain)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: quotientStatuses[
                                                        'Naturalistic'] ==
                                                    true
                                                ? Image.asset(
                                                    AppImages.check,
                                                    height: 15,
                                                    width: 15,
                                                  )
                                                : Image.asset(
                                                    AppImages.uncheck,
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Positioned(
                              child: Center(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.whiteColor,
                              child: Text(
                                'EQ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mainColor),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[5],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 5,
                                                onExit: () {
                                                  // Add the logic you want to execute when exiting the ExistentialScreen
                                                  // For example, you might want to refresh the quotient statuses
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: AppColors.pinkFFB2C5,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .linguisticWithoutbg),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Linguistic'] ==
                                                        // 'Logical'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[6],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 6,
                                                onExit: () {
                                                  // Add the logic you want to execute when exiting the ExistentialScreen
                                                  // For example, you might want to refresh the quotient statuses
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: AppColors.pinkFFC2D1,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages
                                                              .spatialVisual),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Spatial Visual'] ==
                                                        //  'Linguistic'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[7],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 7,
                                                onExit: () {
                                                  // Add the logic you want to execute when exiting the ExistentialScreen
                                                  // For example, you might want to refresh the quotient statuses
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: AppColors.pinkFDD5DF,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .logicalWithoutBg),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Logical'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[8],
                                                quotientStatuses:
                                                    quotientStatuses,
                                                index: 8,
                                                onExit: () {
                                                  // fetchQuotientStatuses();
                                                  widget.notifyWidget();
                                                },
                                              ),
                                            ),
                                          )
                                              .then((e) {
                                            // fetchQuotientStatuses();
                                            widget.notifyWidget();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.pinkFFC2D1
                                                      .withValues(alpha: 0.80),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(AppImages
                                                          .musicalWithoutBg),
                                                      fit: BoxFit.contain)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Musical'] ==
                                                        true
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              child: Center(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.whiteColor,
                              child: Text(
                                'IQ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mainColor),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 3,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        )),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'EMOTIONAL QUOTIENT',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'INTELLECTUAL QUOTIENT',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// String abc() {
//   switch (totalBlockAssists) {
//     case "Total Block Assists":
//       break;
//     default:
//   }
// }
