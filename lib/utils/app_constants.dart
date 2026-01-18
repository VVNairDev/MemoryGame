import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setupSystemUI() {
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF0D47A1),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D47A1),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

// Constants for easier theming
class AppConstants {
  static const String appName = 'Number Memory';
  static const int maxLevels = 100;
  
  // Colors
  static const Color primaryColor = Color(0xFF0D47A1);
  static const Color secondaryColor = Color(0xFF1A237E);
  static const Color accentColor = Color(0xFF00D4FF);
  static const Color successColor = Color(0xFF1B5E20);
  static const Color errorColor = Color(0xFFB71C1C);
  
  // Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(milliseconds: 1000);
}
