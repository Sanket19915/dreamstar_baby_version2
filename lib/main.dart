import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dream_baby/core/auth/auth_notifier.dart';
import 'package:dream_baby/core/network/connectivity_service.dart';
import 'package:dream_baby/core/storage/activity_progress_cache.dart';
import 'package:dream_baby/core/storage/profile_cache.dart';
import 'package:dream_baby/core/theme/app_typography.dart';
import 'package:dream_baby/firebase_options.dart';
import 'package:dream_baby/router/app_router.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/services/push_notification_service.dart';
import 'package:dream_baby/viewmodels/home_viewModel.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:dream_baby/viewmodels/notification_view_model.dart';
import 'package:dream_baby/viewmodels/sign_up_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'shared/helper/app_color.dart';

export 'router/navigator_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseReady = await _initializeRequiredServices();
  final isAuthenticated = await _restoreSession();
  if (isAuthenticated) {
    authNotifier.markAuthenticated();
  }

  initAppRouter(
    initialLocation: isAuthenticated ? Routes.home : Routes.splash,
  );
  runApp(const MyApp());

  unawaited(
    _initializeAfterLaunch(
      firebaseReady: firebaseReady,
      isAuthenticated: isAuthenticated,
    ),
  );
}

Future<bool> _initializeRequiredServices() async {
  final localStorageReady = await _runStartupStep(
    'local storage',
    () async {
      await Hive.initFlutter();
      await Hive.openBox('myBox');
    },
  );

  if (localStorageReady) {
    await _runStartupStep('profile cache', ProfileCache.init);
    await _runStartupStep(
      'activity progress cache',
      ActivityProgressCache.init,
    );
  }

  await _runStartupStep('connectivity monitoring', connectivityService.init);

  return _runStartupStep(
    'Firebase',
    () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    },
  );
}

Future<bool> _restoreSession() async {
  var isAuthenticated = false;
  await _runStartupStep(
    'saved login session',
    () async {
      final session = await AuthService.validateSession();
      isAuthenticated = session.isSuccess;
    },
  );
  return isAuthenticated;
}

Future<void> _initializeAfterLaunch({
  required bool firebaseReady,
  required bool isAuthenticated,
}) async {
  await _runStartupStep(
    'tracking permission',
    AppTrackingTransparency.requestTrackingAuthorization,
  );

  if (!firebaseReady) return;

  final notificationsReady = await _runStartupStep(
    'push notifications',
    pushNotificationService.initialize,
  );
  if (!notificationsReady || !isAuthenticated) return;

  await _runStartupStep(
    'notification permission',
    pushNotificationService.requestPermissions,
  );
  await _runStartupStep(
    'daily notification reminder',
    pushNotificationService.scheduleDailyReminder,
  );
}

Future<bool> _runStartupStep(
  String name,
  Future<dynamic> Function() action,
) async {
  try {
    await action();
    return true;
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app startup',
        context: ErrorDescription('while initializing $name'),
      ),
    );
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        title: 'DreamStar Baby Garbha Sanskar',
        theme: ThemeData(
          textTheme: AppTypography.textTheme,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontFamilyFallback: [
            GoogleFonts.notoSansDevanagari().fontFamily ??
                'Noto Sans Devanagari',
          ],
          radioTheme: const RadioThemeData(
              fillColor: WidgetStatePropertyAll(AppColors.mainColor)),
          checkboxTheme: const CheckboxThemeData(
              side: BorderSide(color: AppColors.mainColor),
              checkColor: WidgetStatePropertyAll(AppColors.whiteColor),
              fillColor: WidgetStatePropertyAll(AppColors.mainColor)),
          primarySwatch: Colors.pink,
        ),
      ),
    );
  }
}
