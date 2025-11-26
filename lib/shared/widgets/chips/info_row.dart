import 'package:flutter/material.dart';

/// A row displaying a label and value pair.
///
/// This component provides a consistent way to display label-value pairs
/// throughout the app, commonly used in settings and detail views.
///
/// Example:
/// ```dart
/// InfoRow(
///   label: 'Season',
///   value: '2024',
/// )
/// ```
class InfoRow extends StatelessWidget {
  /// The label text (left side)
  final String label;

  /// The value text (right side)
  final String value;

  /// Optional padding (defaults to bottom padding of 8)
  final EdgeInsetsGeometry? padding;

  /// Optional label style
  final TextStyle? labelStyle;

  /// Optional value style
  final TextStyle? valueStyle;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.padding,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle ??
                const TextStyle(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

/// A column displaying a label above a value.
///
/// This component is useful for displaying statistics or metrics
/// where the value should be prominent below a descriptive label.
///
/// Example:
/// ```dart
/// InfoColumn(
///   label: 'Managers',
///   value: '10/12',
/// )
/// ```
class InfoColumn extends StatelessWidget {
  /// The label text (top)
  final String label;

  /// The value text (bottom)
  final String value;

  /// Optional label style
  final TextStyle? labelStyle;

  /// Optional value style
  final TextStyle? valueStyle;

  /// Optional spacing between label and value (defaults to 4)
  final double spacing;

  const InfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
        SizedBox(height: spacing),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
