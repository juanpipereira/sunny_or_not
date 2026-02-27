import 'package:flutter/material.dart';
import 'package:sunny_or_not/core/theme/gradient_theme.dart';

class AppTheme {
  // Light theme properties
  static final Color bluePrimary = Colors.blue.shade600;
  static final Color blueSecondary = Colors.blue.shade300;
  static final Color background = Colors.grey.shade50;
  static const Color mainWhite = Colors.white;
  static const Color secondaryWhite = Colors.white70;

  // Dark theme properties
  static final Color darkPrimary = Colors.blue.shade900;
  static final Color darkSecondaryBlue = Colors.blue.shade600;
  static const Color backgroundDark = Colors.black87;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: bluePrimary,
        primary: bluePrimary,
        secondary: blueSecondary,
        surface: background,
        onPrimaryContainer: mainWhite,
        onSecondaryContainer: secondaryWhite,
      ),
      scaffoldBackgroundColor: background,
      extensions: [
        GradientTheme(
          mainGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [blueSecondary, bluePrimary],
          ),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkPrimary,
        primary: darkPrimary,
        secondary: darkSecondaryBlue,
        surface: backgroundDark,
        onPrimaryContainer: mainWhite,
        onSecondaryContainer: secondaryWhite,
      ),
      scaffoldBackgroundColor: backgroundDark,
      extensions: [
        GradientTheme(
          mainGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darkSecondaryBlue, darkPrimary],
          ),
        ),
      ],
    );
  }
}
