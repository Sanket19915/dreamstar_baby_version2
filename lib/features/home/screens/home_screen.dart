import 'package:auto_size_text/auto_size_text.dart';
import 'package:dream_baby/features/home/screens/card_details.dart';
import 'package:dream_baby/features/home/screens/four_quotients.dart';
import 'package:dream_baby/features/rough.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:dream_baby/shared/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
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
                    'Visit FlutterCampus at https://www.fluttercampus.com');
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
      body: SingleChildScrollView(
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
              const BabyCard(),
              SizedBox(
                height: height * 0.02,
              ),
              AutoSizeText(
                'Daily Activities for Baby’s Development ',
                style: GoogleFonts.poppins(
                    color: AppColors.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                minFontSize: 13,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              const FourQuotients(),
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
      bottomNavigationBar: const BottoNavbarScreen(),
    );
  }
}
