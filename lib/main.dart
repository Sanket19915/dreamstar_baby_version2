import 'dart:io';

import 'package:dream_baby/features/auth/screens/sign_up1.dart';
import 'package:dream_baby/firebase_options.dart';
import 'package:dream_baby/router/app_router.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/services/token_services.dart';
import 'package:dream_baby/viewmodels/home_viewModel.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'shared/helper/app_color.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get getContext => navigatorKey.currentState!.context;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
HttpOverrides.global = MyHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (value) {
      // Set up your error logging here
      FlutterError.onError = (FlutterErrorDetails details) {
        // Log to console
        print("Firebase initializeApp error = ${details.exceptionAsString()}");
        // Send to a remote logging service
      };
    },
  );
  final token = await TokenService.getToken();
  if (token != null) {
    // Attempt to login using the token
    final user = await AuthService.loginWithToken(token);
    if (user != null) {
      // If login succeeds, navigate to the home screen
      runApp(const MyApp(initialRoute: Routes.home));
      return;
    } else {
      // If login fails, continue with the regular login flow
      print(
          'Failed to login with saved token. Proceeding with regular login flow.');
    }
  }

  // If no token or login with token fails, start the app normally
  runApp(const MyApp(initialRoute: Routes.splash));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        key: navigatorKey,
        routerConfig: GoRouter(
          routes: appRoutes,
          initialLocation: initialRoute,
        ),
        title: 'DreamStar Baby Garbha Sanskar',
        theme: ThemeData(
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
