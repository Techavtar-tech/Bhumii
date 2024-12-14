import 'package:bhumii/Screens/onboardingScreens/splash_screen.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/sharedPreference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if user is logged in
  bool isLoggedIn = await UserPreferences.isLoggedIn();
  await ApiService.initializeGlobalToken();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        isLoggedIn: isLoggedIn,
      ),
    );
  }
}
