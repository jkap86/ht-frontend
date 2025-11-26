import 'package:flutter/material.dart';

/// Base card wrapper with consistent styling across the app.
///
/// This is the foundation card component that provides standard
/// padding and elevation for all cards in the application.
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// The widget to display inside the card
  final Widget child;

  /// Optional custom padding (defaults to 20px all around)
  final EdgeInsetsGeometry? padding;

  /// Optional elevation (defaults to card default)
  final double? elevation;

  /// Optional background color
  final Color? color;

  /// Optional margin around the card
  final EdgeInsetsGeometry? margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.elevation,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      margin: margin,
      child: padding != null
          ? Padding(
              padding: padding!,
              child: child,
            )
          : child,
    );
  }
}
