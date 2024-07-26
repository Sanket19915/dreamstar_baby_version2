// ignore_for_file: dead_code

import 'package:dream_baby/features/questions/sq/existential.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                              from: quotients[0],
                              index: 0,
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
                     true
                              ? Container()
                              :     Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                AppImages.check,
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
                  true
                              ? Container()
                              :        Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                AppImages.check,
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
                                        true
                                                ? Container()
                                                :    Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
                                    true
                                                ? Container()
                                                :        Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
                                   true? Container()  :  Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Image.asset(
                                              AppImages.check,
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
                                         true
                                                ? Container()
                                                :   Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
                                      true
                                                ? Container()
                                                :      Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
                                         true
                                                ? Container()
                                                :   Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
                                       true
                                                ? Container()
                                                :     Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, right: 8),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Image.asset(
                                                  AppImages.check,
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
