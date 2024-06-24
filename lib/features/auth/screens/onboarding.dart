import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/features/auth/screens/registration.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:dream_baby/shared/helper/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnboardingScreen extends StatelessWidget {
  final Color kDarkBlueColor = const Color(0xFF053149);

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(
        finishButtonText: 'Register',
        onFinish: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const RegistrationScreen(),
            ),
          );
        },
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: kDarkBlueColor,
        ),
        skipTextButton: Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            color: kDarkBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            color: kDarkBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailingFunction: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        controllerColor: AppColors.primaryColor,
        middle: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Dream',
                style: TextStyle(
                  color: Colors.black45, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Baby',
                style: TextStyle(
                  color: Colors.pink, // Change this to your desired color
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        totalPage: 3,
        headerBackgroundColor: AppColors.appPinkLight,
        pageBackgroundColor: AppColors.appPinkLight,
        centerBackground: true,
        background: [
          Image.asset(
            AppImages.splash3,
            height: MediaQuery.of(context).size.height * .48,
          ),
          Image.asset(
            AppImages.splash2,
            height: MediaQuery.of(context).size.height * .48,
          ),
          Image.asset(
            AppImages.splash1,
            height: MediaQuery.of(context).size.height * .48,
          ),
        ],
        speed: 1,
        pageBodies: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .52,
                ),
                const Text(
                  'On your way...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'From Learning to Leading: The Sonal\'s Way.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .52,
                ),
                const Text(
                  'You’ve reached your destination.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Empowering Minds, Transforming Futures',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .52,
                ),
                const Text(
                  'Start now!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Intelligence Redefined: Sonal\'s Holistic Approach.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
