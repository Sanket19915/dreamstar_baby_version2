import 'package:dream_baby/router/app_router.dart';
import 'package:dream_baby/router/routes.dart';
import 'package:dream_baby/services/auth_services.dart';
import 'package:dream_baby/services/token_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dream_baby/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('myBox');
  await Firebase.initializeApp();

  // Check if a token exists
  final token = await TokenService.getToken();
  if (token != null) {
    // Attempt to login using the token
    final user = await AuthService.loginWithToken(token);
    if (user != null) {
      // If login succeeds, navigate to the home screen
      runApp(MyApp());
      return;
    } else {
      // If login fails, continue with the regular login flow
      print(
          'Failed to login with saved token. Proceeding with regular login flow.');
    }
  }

  // If no token or login with token fails, start the app normally
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GoRouter(
          routes: appRoutes,
          initialLocation: Routes.splash,
        ),
        title: 'Dream Baby',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
      ),
    );
  }
}
