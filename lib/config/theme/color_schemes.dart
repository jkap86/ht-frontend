import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'color_utils.dart';

/// Manual ColorScheme definitions for light and dark themes
/// Color variants are auto-generated from base colors using ColorUtils
/// To customize: Just change the 3 main colors in app_colors.dart (primaryBlue, secondaryTeal, tertiaryOrange)
class AppColorSchemes {
  /// Light theme color scheme
  static ColorScheme get light => ColorScheme(
    brightness: Brightness.light,

    // Primary colors (auto-generated variants from primaryBlue)
    primary: AppColors.primaryBlue,
    onPrimary: ColorUtils.getTextColor(AppColors.primaryBlue),
    primaryContainer: ColorUtils.lighten(AppColors.primaryBlue, 0.4),
    onPrimaryContainer: ColorUtils.darken(AppColors.primaryBlue, 0.4),

    // Secondary colors (auto-generated variants from secondaryTeal)
    secondary: AppColors.secondaryTeal,
    onSecondary: ColorUtils.getTextColor(AppColors.secondaryTeal),
    secondaryContainer: ColorUtils.lighten(AppColors.secondaryTeal, 0.4),
    onSecondaryContainer: ColorUtils.darken(AppColors.secondaryTeal, 0.4),

    // Tertiary colors (auto-generated variants from tertiaryOrange)
    tertiary: AppColors.tertiaryOrange,
    onTertiary: ColorUtils.getTextColor(AppColors.tertiaryOrange),
    tertiaryContainer: ColorUtils.lighten(AppColors.tertiaryOrange, 0.4),
    onTertiaryContainer: ColorUtils.darken(AppColors.tertiaryOrange, 0.4),

    // Error colors (auto-generated variants)
    error: AppColors.error,
    onError: ColorUtils.getTextColor(AppColors.error),
    errorContainer: ColorUtils.lighten(AppColors.error, 0.4),
    onErrorContainer: ColorUtils.darken(AppColors.error, 0.4),

    // Background and surface colors
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    onSurfaceVariant: Color(0xFF616161),

    // Outline colors
    outline: AppColors.lightOutline,
    outlineVariant: Color(0xFFE0E0E0),

    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // Inverse colors
    inverseSurface: Color(0xFF303030),
    onInverseSurface: Color(0xFFF5F5F5),
    inversePrimary: AppColors.primaryBlueLight,
  );

  /// Dark theme color scheme
  static ColorScheme get dark => ColorScheme(
    brightness: Brightness.dark,

    // Primary colors (auto-generated for dark mode)
    primary: ColorUtils.lightenForDark(AppColors.primaryBlue),
    onPrimary: ColorUtils.getTextColor(ColorUtils.lightenForDark(AppColors.primaryBlue)),
    primaryContainer: ColorUtils.darken(AppColors.primaryBlue, 0.4),
    onPrimaryContainer: ColorUtils.lighten(AppColors.primaryBlue, 0.4),

    // Secondary colors (auto-generated for dark mode)
    secondary: ColorUtils.lightenForDark(AppColors.secondaryTeal),
    onSecondary: ColorUtils.getTextColor(ColorUtils.lightenForDark(AppColors.secondaryTeal)),
    secondaryContainer: ColorUtils.darken(AppColors.secondaryTeal, 0.4),
    onSecondaryContainer: ColorUtils.lighten(AppColors.secondaryTeal, 0.4),

    // Tertiary colors (auto-generated for dark mode)
    tertiary: ColorUtils.lightenForDark(AppColors.tertiaryOrange),
    onTertiary: ColorUtils.getTextColor(ColorUtils.lightenForDark(AppColors.tertiaryOrange)),
    tertiaryContainer: ColorUtils.darken(AppColors.tertiaryOrange, 0.3),
    onTertiaryContainer: ColorUtils.lighten(AppColors.tertiaryOrange, 0.4),

    // Error colors (auto-generated for dark mode)
    error: ColorUtils.lightenForDark(AppColors.error),
    onError: ColorUtils.getTextColor(ColorUtils.lightenForDark(AppColors.error)),
    errorContainer: ColorUtils.darken(AppColors.error, 0.3),
    onErrorContainer: ColorUtils.lighten(AppColors.error, 0.4),

    // Background and surface colors
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: Color(0xFFBDBDBD),

    // Outline colors
    outline: AppColors.darkOutline,
    outlineVariant: Color(0xFF424242),

    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    // Inverse colors
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF303030),
    inversePrimary: AppColors.primaryBlue,
  );

  // Private constructor to prevent instantiation
  AppColorSchemes._();
}
