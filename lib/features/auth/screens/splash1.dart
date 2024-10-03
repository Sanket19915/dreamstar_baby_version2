import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:phone_state/phone_state.dart';
import 'package:video_player/video_player.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  // PhoneState phoneState = PhoneState.nothing();
  late VideoPlayerController _videoController;
  bool _isCallOngoing = false; // Flag to determine if a call is ongoing
  bool _isVideoInitialized =
      false; // Flag to determine if the video is initialized
  bool isGranted = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkCallStatus(); // Check call status as soon as possible
      // Initialize the video player controller only if no call is ongoing
      if (!_isCallOngoing) {
        _videoController =
            VideoPlayerController.asset('assets/images/splash.mp4')
              ..initialize().then((_) {
                setState(() {
                  _isVideoInitialized = true;
                });
                _videoController.play();
              });

        _videoController.addListener(() {
          if (!_isCallOngoing &&
              _videoController.value.position ==
                  _videoController.value.duration) {
            navigateAfterDelay();
          }
        });
      }
    });
  }

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void dispose() {
    if (_isVideoInitialized) {
      _videoController.dispose();
    }
    super.dispose();
  }

  void checkCallStatus() async {
    // Implement your logic to check if a call is ongoing
    // For example, check from a call manager or a service
    await isCallInProgress(); // Replace with your method

    if (_isCallOngoing) {
      // Navigate after a delay or handle as needed
      navigateAfterDelay();
    }
  }

  Future<void> isCallInProgress() async {
    if (!isGranted) {
      isGranted = await requestPermission();
      if (mounted) {
        setState(() {});
      }
    }

    // if (isGranted) {
    //   PhoneState.stream.listen((event) {
    //     setState(() {
    //       phoneState = event;
    //       print("phoneState = ${phoneState.status.name}");
    //       _isCallOngoing =
    //           phoneState.status == PhoneStateStatus.CALL_INCOMING ||
    //               phoneState.status == PhoneStateStatus.CALL_ENDED;
    //     });
    //   });
    // }
    // Replace this with actual implementation
    // Example: return await CallService.isCallActive();
    // return false; // Default to no call ongoing
  }

  void navigateAfterDelay() async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Delay to ensure proper navigation
      var box = Hive.box('userBox');
      bool isLoggedIn = SessionManager().isLoggedIn();
      if (isLoggedIn) {
        context.go(Routes.home);
      } else {
        context.go(Routes.login); // Navigate to login if not logged in
      }
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      body: Stack(
        children: [
          if (_isCallOngoing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  'Welcome to DreamStar Baby',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            )
          else if (_isVideoInitialized)
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
