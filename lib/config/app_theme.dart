import 'package:flutter/material.dart';

/// Application theme configuration
/// Centralized theme definitions for light and dark modes
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Brand color - change this to update the entire app's color scheme
  static const Color seedColor = Colors.cyanAccent;

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
