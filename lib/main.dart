import 'package:dream_baby/features/auth/screens/sign_up1.dart';
import 'package:dream_baby/firebase_options.dart';
import 'package:dream_baby/router/app_router.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/services/token_services.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'shared/helper/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GoRouter(
          routes: appRoutes,
          initialLocation: initialRoute,
        ),
        title: 'Dream Baby',
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
