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

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/images/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });

    _videoController.addListener(() {
      if (_videoController.value.position == _videoController.value.duration) {
        navigateAfterDelay();
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void navigateAfterDelay() async {
    var box = Hive.box('userBox');
//    bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    bool isLoggedIn = SessionManager().isLoggedIn();

    if (isLoggedIn) {
      context.go(Routes.home);
    } else {
      context.go(Routes.moreDetails); // Navigate to login if not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      body: Stack(
        children: [
          _videoController.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
