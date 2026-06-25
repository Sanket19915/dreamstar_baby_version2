import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Full-screen loading barrier used across auth and form screens.
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.45),
                child: const Center(
                  child: SpinKitCircle(
                    color: AppColors.primaryColor,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
