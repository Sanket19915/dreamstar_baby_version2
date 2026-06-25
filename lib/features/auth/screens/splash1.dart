import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  bool _isCallOngoing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), navigateAfterDelay);
    initPlugin();
  }

  Future<void> navigateAfterDelay() async {
    if (!mounted) return;

    final session = await AuthService.validateSession();
    if (!mounted) return;

    if (session.isSuccess) {
      context.go(Routes.home);
    } else {
      context.go(Routes.login);
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
                  'assets/images/splash.GIF',
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

  Future<void> initPlugin() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}
