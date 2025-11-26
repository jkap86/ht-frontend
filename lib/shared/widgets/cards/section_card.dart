import 'package:flutter/material.dart';
import 'app_card.dart';

/// Card with a title header and content section.
///
/// This component provides a standardized card layout with a bold
/// title at the top and content below, commonly used for overview
/// sections and grouped information.
///
/// Example:
/// ```dart
/// SectionCard(
///   title: 'Draft',
///   child: Text('Draft information goes here'),
/// )
/// ```
class SectionCard extends StatelessWidget {
  /// The title displayed at the top of the card
  final String title;

  /// The content to display below the title
  final Widget child;

  /// Optional custom padding (defaults to 20px all around)
  final EdgeInsetsGeometry? padding;

  /// Optional title style
  final TextStyle? titleStyle;

  /// Optional spacing between title and content (defaults to 16px)
  final double spacing;

  /// Optional elevation
  final double? elevation;

  /// Optional background color
  final Color? color;

  /// Optional action widget to display in the title row
  final Widget? action;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.titleStyle,
    this.spacing = 16,
    this.elevation,
    this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      elevation: elevation,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          SizedBox(height: spacing),
          child,
        ],
      ),
    );
  }
}
