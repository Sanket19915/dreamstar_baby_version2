import 'dart:io';

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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'shared/helper/app_color.dart';

export 'router/navigator_key.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await ProfileCache.init();
  await ActivityProgressCache.init();
  await connectivityService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (value) {
      if (!kDebugMode) {
        FlutterError.onError = (FlutterErrorDetails details) {
          print("Firebase initializeApp error = ${details.exceptionAsString()}");
        };
      }
    },
  );

  final session = await AuthService.validateSession();
  if (session.isSuccess) {
    authNotifier.markAuthenticated();
  }
  final initialRoute =
      session.isSuccess ? Routes.home : Routes.splash;

  initAppRouter(initialLocation: initialRoute);

  await pushNotificationService.initialize();
  if (session.isSuccess) {
    await pushNotificationService.requestPermissions();
    await pushNotificationService.scheduleDailyReminder();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      await AppTrackingTransparency.requestTrackingAuthorization();
    });
  }

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
            GoogleFonts.notoSansDevanagari().fontFamily ?? 'Noto Sans Devanagari',
          ],
          radioTheme: const RadioThemeData(fillColor: WidgetStatePropertyAll(AppColors.mainColor)),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
