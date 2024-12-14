import 'package:bhumii/Screens/onboardingScreens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _tokenKey = 'user_token';

  // Save the token
  static Future<bool> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  // Get the saved token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear the token (for logout)
  static Future<bool> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_tokenKey);
  }
}

class AuthService {
  static Future<void> handleLogout(BuildContext context) async {
    // Clear the token from shared preferences
    await UserPreferences.clearToken();

    // Clear the global token in ApiService
    // ApiService.clearGlobalToken();

    // Navigate to the splash screen (or login screen) and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
