import 'package:flutter/material.dart';

/// Utility class for generating color variants
/// Automatically creates lighter/darker shades for Material 3 color roles
class ColorUtils {
  ColorUtils._();

  /// Generate a lighter shade of a color (for containers in light mode)
  /// [amount] controls how much lighter (0.0 = no change, 1.0 = white)
  static Color lighten(Color color, [double amount = 0.3]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Generate a darker shade of a color (for containers in dark mode)
  /// [amount] controls how much darker (0.0 = no change, 1.0 = black)
  static Color darken(Color color, [double amount = 0.3]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Generate a lighter, more vibrant version for dark mode
  /// Increases both lightness and saturation
  static Color lightenForDark(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.1).clamp(0.0, 1.0))
        .toColor();
  }

  /// Generate appropriate text color (black or white) based on background
  /// Ensures proper contrast for readability
  static Color getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Calculate relative luminance for a color
  /// Used for WCAG contrast calculations
  static double getLuminance(Color color) {
    return color.computeLuminance();
  }

  /// Check if two colors have sufficient contrast (WCAG AA standard)
  /// Minimum contrast ratio of 4.5:1 for normal text
  static bool hasSufficientContrast(Color foreground, Color background) {
    final ratio = getContrastRatio(foreground, background);
    return ratio >= 4.5;
  }

  /// Calculate contrast ratio between two colors
  /// Returns value between 1 (no contrast) and 21 (maximum contrast)
  static double getContrastRatio(Color color1, Color color2) {
    final lum1 = color1.computeLuminance();
    final lum2 = color2.computeLuminance();
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Generate a complete set of color variants for Material 3
  /// Returns a map with all necessary color roles
  static Map<String, Color> generateColorSet({
    required Color baseColor,
    required bool isDark,
  }) {
    if (isDark) {
      // Dark mode: use lighter, more vibrant colors
      final primary = lightenForDark(baseColor);
      return {
        'main': primary,
        'container': darken(baseColor, 0.4),
        'onMain': Colors.black,
        'onContainer': lighten(baseColor, 0.4),
      };
    } else {
      // Light mode: use base color with lighter container
      return {
        'main': baseColor,
        'container': lighten(baseColor, 0.4),
        'onMain': Colors.white,
        'onContainer': darken(baseColor, 0.4),
      };
    }
  }
}
