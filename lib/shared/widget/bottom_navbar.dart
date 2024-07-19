import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class BottoNavbarScreen extends StatefulWidget {
  const BottoNavbarScreen({super.key});

  @override
  State<BottoNavbarScreen> createState() => _BottoNavbarScreenState();
}

class _BottoNavbarScreenState extends State<BottoNavbarScreen>
    with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      controller:
          _motionTabBarController, // ADD THIS if you need to change your tab programmatically
      initialSelectedTab: "Home",
      useSafeArea: true, // default: true, apply safe area wrapper
      labels: const [
        "Testimonials",
        "About Us",
        "Home",
        // "Community",
        "Follow Us"
      ],
      // icons: const [
      //   Icons.dashboard,
      //   Icons.home,
      //   Icons.people_alt,
      //   Icons.settings
      // ],
      icons: null,
      badges: [
        // Default Motion Badge Widget
        const MotionBadgeWidget(
          text: '',
          textColor: Colors.white, // optional, default to Colors.white
          color: Colors.red, // optional, default to Colors.red
          size: 18, // optional, default to 18
        ),
        const MotionBadgeWidget(
          text: '',
          textColor: Colors.white, // optional, default to Colors.white
          color: Colors.red, // optional, default to Colors.red
          size: 18, // optional, default to 18
        ),

        // custom badge Widget
        Container(
          color: Colors.black,
          child: const Text(
            '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),

        // allow null
        null,

        // Default Motion Badge Widget with indicator only
        const MotionBadgeWidget(
          isIndicator: true,
          color: Colors.red, // optional, default to Colors.red
          size: 0, // optional, default to 5,
          show: false, // true / false
        ),
      ],
      tabSize: 48,
      tabBarHeight: 55,

      textStyle: const TextStyle(
        fontSize: 12,
        color: AppColors.mainColor,
        fontWeight: FontWeight.w700,
      ),
      tabIconColor: AppColors.greyTextColor,
      tabIconSize: 15.0,
      tabIconSelectedSize: 15.0,
      tabSelectedColor: AppColors.mainColor,
      tabIconSelectedColor: AppColors.whiteColor,
      tabBarColor: AppColors.whiteColor,
      onTabItemSelected: (int value) {
        setState(() {
          _motionTabBarController!.index = value;
        });
      },
      // images: [
      //   AppImages.testi,
      //   AppImages.about,
      //   AppImages.homenew,
      //   AppImages.people,
      //   AppImages.follow
      // ],
    );
  }
}
