import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthBackButton extends StatelessWidget {
  final String? fallbackRoute;

  const AuthBackButton({super.key, this.fallbackRoute});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(fallbackRoute ?? Routes.login);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryTextColor,
              size: 22,
            ),
            tooltip: 'Back',
          ),
        ),
      ),
    );
  }
}
