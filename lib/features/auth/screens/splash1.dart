import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  late VideoPlayerController _videoController;
  bool _isCallOngoing = false; // Flag to determine if a call is ongoing

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller
    _videoController = VideoPlayerController.asset('assets/images/splash.mp4')
      ..initialize().then((_) {
        if (!_isCallOngoing) {
          setState(() {});
          _videoController.play();
        }
      });

    _videoController.addListener(() {
      if (!_isCallOngoing &&
          _videoController.value.position == _videoController.value.duration) {
        navigateAfterDelay();
      }
    });

    // Placeholder: Update _isCallOngoing based on your call status mechanism
    checkCallStatus();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void checkCallStatus() async {
    // Implement your logic to check if a call is ongoing
    // For example, check from a call manager or a service
    bool callInProgress = await isCallInProgress(); // Replace with your method

    setState(() {
      _isCallOngoing = callInProgress;
    });
  }

  Future<bool> isCallInProgress() async {
    // Replace this with actual implementation
    // Example: return await CallService.isCallActive();
    return false; // Default to no call ongoing
  }

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
          else if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
