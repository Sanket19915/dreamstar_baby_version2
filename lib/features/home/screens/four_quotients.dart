// ignore_for_file: dead_code

import 'dart:convert';

import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FourQuotients extends StatefulWidget {
  const FourQuotients({super.key});

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

  void initState() {
    super.initState();
    fetchQuotientStatuses();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 388,
      child: Column(
        children: [
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
                      child: Text(
                        'SPIRITUAL QUOTIENT',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: 11),
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
                      child: Text(
                        'PHYSICAL QUOTIENT',
                        style: GoogleFonts.poppins(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ExistentialScreen(
                              index: 0,
                              from: quotients[0],
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              //color: Colors.green,
                              image: DecorationImage(
                                  image: AssetImage(AppImages.exist),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8, right: 8),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ExistentialScreen(
                              from: quotients[1],
                              index: 1,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              // color: Colors.green,
                              image: DecorationImage(
                                  image: AssetImage(AppImages.kine),
                                  fit: BoxFit.cover),
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[2],
                                                index: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.inter),
                                                      fit: BoxFit.cover)),
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[3],
                                                index: 3,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.intra),
                                                      fit: BoxFit.cover)),
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
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => ExistentialScreen(
                                            from: quotients[4],
                                            index: 4,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      AppImages.natu),
                                                  fit: BoxFit.cover)),
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[5],
                                                index: 5,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.ling),
                                                      fit: BoxFit.cover)),
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[6],
                                                index: 6,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.spat),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Linguistic'] ==
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[7],
                                                index: 7,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.logi),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: quotientStatuses[
                                                            'Spatial Visual'] ==
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ExistentialScreen(
                                                from: quotients[8],
                                                index: 8,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages.musi),
                                                      fit: BoxFit.cover)),
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
                      child: Text(
                        'EMOTIONAL QUOTIENT',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: 11),
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
                      child: Text(
                        'INTELLECTUAL QUOTIENT',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: 11),
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
