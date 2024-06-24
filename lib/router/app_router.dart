import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/features/auth/screens/onboarding.dart';
import 'package:dream_baby/features/auth/screens/registration.dart';
import 'package:dream_baby/features/auth/screens/splash.dart';
import 'package:dream_baby/features/home/screens/home_screen.dart';
import 'package:dream_baby/features/konwledge_hub/know_entry.dart';
import 'package:dream_baby/features/notifications/screen/notification_screen.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/transition.dart';
import 'package:go_router/go_router.dart';

final appRoutes = <RouteBase>[
  GoRoute(
    path: Routes.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: Routes.onboard,
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: Routes.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: Routes.registration,
    builder: (context, state) => RegistrationScreen(),
  ),
  GoRoute(
    path: Routes.home,
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: Routes.knowEntry,
    builder: (context, state) => KnowEntry(),
  ),
  GoRoute(
    path: Routes.notification,
    pageBuilder: (context, state) {
      return CustomSlideTransitionPage(
        child: NotificationScreen(),
      );
    },
  ),
];
