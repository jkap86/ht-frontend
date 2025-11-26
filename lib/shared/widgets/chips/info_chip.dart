import 'package:flutter/material.dart';

/// A chip for displaying metadata with an icon and label.
///
/// This component provides a consistent way to display informational
/// chips throughout the app, such as season, team count, entry fee, etc.
///
/// Example:
/// ```dart
/// InfoChip(
///   icon: Icons.people,
///   label: '12 Teams',
/// )
/// ```
class InfoChip extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// The label text
  final String label;

  /// Optional icon size (defaults to 18)
  final double iconSize;

  /// Optional custom background color
  final Color? backgroundColor;

  /// Optional custom text color
  final Color? textColor;

  /// Optional custom icon color
  final Color? iconColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.iconSize = 18,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      label: Text(
        label,
        style: textColor != null
            ? TextStyle(color: textColor)
            : null,
      ),
      backgroundColor: backgroundColor,
    );
  }
}

/// A compact chip for displaying summary information.
///
/// This is a smaller, more compact version of InfoChip, designed
/// for use in tight spaces or when showing multiple pieces of metadata.
///
/// Example:
/// ```dart
/// CompactInfoChip(
///   icon: Icons.calendar_today,
///   label: '2024',
/// )
/// ```
class CompactInfoChip extends StatelessWidget {
  /// The label text
  final String label;

  /// The icon to display
  final IconData icon;

  const CompactInfoChip({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
