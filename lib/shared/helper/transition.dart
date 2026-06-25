import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCustomRouteTransition extends PageRouteBuilder {
  final Widget route;
  MyCustomRouteTransition({required this.route})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return route;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              alwaysIncludeSemantics: true,
              child: child,
            );
          },
        );
}

class CustomSlideTransitionPage extends CustomTransitionPage<void> {
  CustomSlideTransitionPage({
    required super.key,
    required Widget child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset(0.0, 0.0);
            const curve = Curves.easeInOut;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: child,
        );
}
