import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  bool _isCallOngoing = false; // Flag to determine if a call is ongoing

  @override
  void initState() {
    super.initState();
    // checkCallStatus(); // Check call status as soon as possible

    // Delay navigation after showing the GIF
    Future.delayed(const Duration(seconds: 6), () {
      navigateAfterDelay(); // Navigate after 6 seconds
    });
    initPlugin();
  }

  // void checkCallStatus() async {
  //   bool callInProgress = await isCallInProgress(); // Replace with your method
  //   setState(() {
  //     _isCallOngoing = callInProgress;
  //   });
  //   if (_isCallOngoing) {
  //     // Navigate immediately if a call is ongoing
  //     navigateAfterDelay();
  //   }
  // }

  // Future<bool> isCallInProgress() async {
  //   // Replace this with actual implementation
  //   return false; // Default to no call ongoing
  // }

  void navigateAfterDelay() async {
    var box = Hive.box('userBox');
    bool isLoggedIn = SessionManager().isLoggedIn();

    if (isLoggedIn) {
      context.go(Routes.home);
    } else {
      context.go(Routes.login); // Navigate to login if not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      body: Stack(
        children: [
          if (_isCallOngoing)
            const Center(
              child: Text(
                'Welcome to DreamStart Baby',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
            )
          else
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.asset(
                  'assets/images/splash.GIF', // Load your GIF here
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _authStatus = 'Unknown';
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Wait for dialog popping animation

      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}
