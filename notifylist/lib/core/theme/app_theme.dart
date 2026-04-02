import 'package:flutter/material.dart';

class AppTheme {

  //Colores principales
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color cardColor = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color completed = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFCF6679);

  static ThemeData get darkTheme {
    return ThemeData (
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: danger,
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: textPrimary,
      ),
    );
  }
}