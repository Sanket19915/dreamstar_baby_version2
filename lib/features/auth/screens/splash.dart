import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool showImage = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    changeImageAfterDelay();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeImageAfterDelay() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    _controller.stop();
    var box = Hive.box('myBox');
    bool isFirstTime = box.get('isFirstTime', defaultValue: true);

    if (isFirstTime) {
      box.put('isFirstTime', false);
      if (mounted) {
        context.go(Routes.onboard);
      }
    } else {
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPinkLight,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: AnimatedOpacity(
            opacity: showImage ? 1.0 : 0.0,
            duration: const Duration(seconds: 3),
            child: showImage
                ? Hero(
                    tag: 'Logo',
                    child: Image.asset(
                      AppImages.logoN,
                      height: MediaQuery.of(context).size.height * .45,
                    ),
                  )
                : ScaleTransition(
                    scale: _animation,
                    child: Image.asset(AppImages.logoN),
                  ),
          ),
        ),
      ),
    );
  }
}
