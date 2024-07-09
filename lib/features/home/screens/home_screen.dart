import 'package:dream_baby/features/about_us/about_us_screen.dart';
import 'package:dream_baby/features/contact_us/contact_us_screen.dart';
import 'package:dream_baby/features/home/screens/home_screen.dart';
import 'package:dream_baby/features/home/screens/home_screen_content.dart';
import 'package:dream_baby/features/testimonials_screen/testimonials_screen.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 2,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _motionTabBarController,
        children: <Widget>[
          TestimonialScreen(),
          AboutUsScreen(),
          HomeContentScreen(),
          Center(child: Text("Community")),
          ContactUsScreen(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const [
          "Testimonials",
          "About Us",
          "Home",
          "Community",
          "Follow Us"
        ],
        icons: const [
          Icons.reviews,
          Icons.info,
          Icons.home,
          Icons.group,
          Icons.follow_the_signs
        ],
        badges: [
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
        images: [
          AppImages.testi,
          AppImages.about,
          AppImages.homenew,
          AppImages.people,
          AppImages.follow
        ],
      ),
    );
  }
}

class TestimonialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Testimonials"));
  }
}

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Community"));
  }
}

class FollowUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Follow Us"));
  }
}
