import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0D47A1);
  static const Color secondaryColor = Color(0xFF00D4FF);
  static const Color accentColor = Color(0xFF6200EA);
  
  static const Color darkBg1 = Color(0xFF0D47A1);
  static const Color darkBg2 = Color(0xFF1A237E);
  
  static const Color successGreen = Color(0xFF1B5E20);
  static const Color errorRed = Color(0xFFB71C1C);
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBg1,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorRed,
    ),
  );
}
