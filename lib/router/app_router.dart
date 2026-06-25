import 'package:dream_baby/core/auth/auth_notifier.dart';
import 'package:dream_baby/features/auth/screens/acknowledgement_screen.dart';
import 'package:dream_baby/features/auth/screens/forgot_otp_and_password_screen.dart';
import 'package:dream_baby/features/auth/screens/forgot_password_screen.dart';
import 'package:dream_baby/features/auth/screens/login.dart';
import 'package:dream_baby/features/auth/screens/more_details.dart';
import 'package:dream_baby/features/auth/screens/new_otp_screen.dart';
import 'package:dream_baby/features/auth/screens/onboarding.dart';
import 'package:dream_baby/features/auth/screens/sign_up1.dart';
import 'package:dream_baby/features/auth/screens/splash1.dart';
import 'package:dream_baby/features/home/screens/home_screen.dart';
import 'package:dream_baby/features/konwledge_hub/know_entry.dart';
import 'package:dream_baby/features/notifications/screen/notification_screen.dart';
import 'package:dream_baby/features/setting/edit_profile_screen.dart';
import 'package:dream_baby/features/setting/setting_screen.dart';
import 'package:dream_baby/router/navigator_key.dart';
import 'package:dream_baby/router/page_transitions.dart';
import 'package:dream_baby/router/route_args.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/shared/helper/transition.dart';
import 'package:dream_baby/shared/widget/bottom_navbar.dart';
import 'package:go_router/go_router.dart';

late final GoRouter appRouter;

const _publicRoutes = {
  Routes.splash,
  Routes.onboard,
  Routes.login,
  Routes.registration,
  Routes.forgotPassword,
  Routes.verifyOtp,
  Routes.forgotOtpReset,
};

String? _authRedirect(GoRouterState state) {
  final location = state.matchedLocation;
  final isAuthenticated = authNotifier.isAuthenticated;
  final isPublic = _publicRoutes.contains(location);

  if (!isAuthenticated && !isPublic) {
    return Routes.login;
  }

  if (isAuthenticated &&
      (location == Routes.login || location == Routes.splash)) {
    return Routes.home;
  }

  return null;
}

void initAppRouter({required String initialLocation}) {
  appRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    refreshListenable: authNotifier,
    redirect: (context, state) => _authRedirect(state),
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const SplashScreen1(),
        ),
      ),
      GoRoute(
        path: Routes.onboard,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.registration,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.verifyOtp,
        pageBuilder: (context, state) {
          final args = state.extra as OtpRouteArgs;
          return adaptivePage(
            state: state,
            child: NewOTPScreen(
              phoneNumber: args.phoneNumber,
              userModel: args.userModel,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.forgotOtpReset,
        pageBuilder: (context, state) {
          final args = state.extra as ForgotOtpRouteArgs;
          return adaptivePage(
            state: state,
            child: ForgotOtpAndPasswordScreen(
              phoneNumber: args.phoneNumber,
              userId: args.userId,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.knowEntry,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const KnowEntry(),
        ),
      ),
      GoRoute(
        path: Routes.settingsScreen,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.BottoNavbarScreen,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const BottoNavbarScreen(),
        ),
      ),
      GoRoute(
        path: Routes.notification,
        pageBuilder: (context, state) => CustomSlideTransitionPage(
          key: state.pageKey,
          child: const NotificationScreen(),
        ),
      ),
      GoRoute(
        path: Routes.moreDetails,
        pageBuilder: (context, state) {
          final userId = state.extra as String;
          return adaptivePage(
            state: state,
            child: MoreDetailsScreen(userId: userId),
          );
        },
      ),
      GoRoute(
        path: Routes.acknowledgement,
        pageBuilder: (context, state) => adaptivePage(
          state: state,
          child: const AcknowledgementScreen(),
        ),
      ),
      GoRoute(
        path: Routes.EditProfileScreen,
        pageBuilder: (context, state) {
          final userProfile = state.extra as Map<String, dynamic>;
          return CustomSlideTransitionPage(
            key: state.pageKey,
            child: EditProfileScreen(userProfile: userProfile),
          );
        },
      ),
    ],
  );
}
