import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dream_baby/core/widgets/offline_banner.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/features/about_us/about_us_screen.dart';
import 'package:dream_baby/features/conception/screens/conception_dashboard_screen.dart';
import 'package:dream_baby/features/contact_us/contact_us_screen.dart';
import 'package:dream_baby/features/home/screens/home_screen_content.dart';
import 'package:dream_baby/features/setting/screens/faq_screen.dart';
import 'package:dream_baby/features/testimonials_screen/testimonials_screen.dart';
import 'package:dream_baby/services/push_notification_service.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/home_viewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  bool isLoading = false;
  HomeViewmodel get homeViewModel => Provider.of<HomeViewmodel>(context, listen: false);
  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 2,
      length: 5,
      vsync: this,
    );
    getNotificationPermission();
    getActiveUser();
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ProfileCache.read() ?? {};
    final journeyType = profile['journey_type']?.toString();
    final isConception = journeyType == 'conception';

    return Scaffold(
      body: OfflineBanner(
        child: TabBarView(
          controller: _motionTabBarController,
          children: <Widget>[
            const TestimonialScreen(),
            const AboutUsScreen(),
            isConception ? const ConceptionDashboardScreen(isEmbedded: true) : const HomeContentScreen(),
            const FAQScreen(),
            const ContactUsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: MotionTabBar(
        images: const [],
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Testimonials", "About Us", "Home", "FAQ", "Contact Us"],
        icons: const [Icons.reviews, Icons.info, Icons.home, Icons.question_answer, Icons.follow_the_signs],
        badges: const [
          null,
          null,
          null,
          null,
          null,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: AppColors.mainColor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: AppColors.mainColor,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
        // images: [
        //   AppImages.testi,
        //   AppImages.about,
        //   AppImages.homenew,
        //   AppImages.people,
        //   AppImages.follow
        // ],
      ),
    );
  }

  // Get Device Info... (Device Unique Id(UUID))
  Future<String> _fetchDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching device info");
      }
      return "";
    }
  }

  Future<void> getActiveUser() async {
    try {
      String? deviceId = await _fetchDeviceInfo();
      pushNotificationService.setDeviceId(deviceId);
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();

      await homeViewModel.activeUser(
        deviceId: deviceId,
        fcmToken: token,
      );
      if (token != null) {
        await pushNotificationService.scheduleDailyReminder();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getNotificationPermission() async {
    try {
      await pushNotificationService.requestPermissions();
      await pushNotificationService.scheduleDailyReminder();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Testimonials"));
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FAQScreen();
  }
}

class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Follow Us"));
  }
}
