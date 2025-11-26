import 'package:flutter/material.dart';

/// A consistent header for sections throughout the app.
///
/// This component provides a standardized way to display section headers
/// with optional actions, commonly used to separate different areas of content.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'Settings',
///   action: IconButton(
///     icon: Icon(Icons.edit),
///     onPressed: () {},
///   ),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// The title text
  final String title;

  /// Optional action widget (e.g., button, icon)
  final Widget? action;

  /// Optional title style
  final TextStyle? titleStyle;

  /// Optional padding
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.titleStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// A smaller subsection header.
///
/// This is a lighter weight header for subsections within a larger section.
///
/// Example:
/// ```dart
/// SubsectionHeader(
///   title: 'Draft Order',
/// )
/// ```
class SubsectionHeader extends StatelessWidget {
  /// The title text
  final String title;

  /// Optional action widget
  final Widget? action;

  /// Optional title style
  final TextStyle? titleStyle;

  /// Optional padding
  final EdgeInsetsGeometry? padding;

  const SubsectionHeader({
    super.key,
    required this.title,
    this.action,
    this.titleStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
