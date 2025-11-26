import 'package:flutter/material.dart';

/// Application color constants
/// These colors define the brand identity and custom colors used throughout the app
class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color.fromARGB(255, 10, 55, 100);
  static const Color primaryBlueLight = Color(0xFF64B5F6);
  static const Color secondaryTeal = Color.fromARGB(255, 0, 255, 225);
  static const Color secondaryTealLight = Color(0xFF4DB6AC);
  static const Color tertiaryOrange = Color.fromARGB(255, 203, 61, 0);
  static const Color tertiaryAmber = Color(0xFFFFB300);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // Surface Colors - Light Theme
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFE0E0E0);

  // Surface Colors - Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);

  // Text Colors
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF212121);
  static const Color darkOnSurface = Color(0xFFE0E0E0);

  // Outline Colors
  static const Color lightOutline = Color(0xFFBDBDBD);
  static const Color darkOutline = Color(0xFF616161);

  // Private constructor to prevent instantiation
  AppColors._();
}
