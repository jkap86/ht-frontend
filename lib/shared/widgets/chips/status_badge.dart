import 'package:flutter/material.dart';

/// A colored badge for displaying status information.
///
/// This component provides a consistent way to show status indicators
/// with color coding, icons, and labels across the application.
///
/// Example:
/// ```dart
/// StatusBadge(
///   label: 'In Season',
///   color: Colors.green,
///   icon: Icons.play_circle,
/// )
/// ```
class StatusBadge extends StatelessWidget {
  /// The text to display in the badge
  final String label;

  /// The background color of the badge
  final Color color;

  /// Optional icon to show before the label
  final IconData? icon;

  /// Optional text color (defaults to white)
  final Color textColor;

  /// Optional icon color (defaults to white)
  final Color? iconColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.textColor = Colors.white,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null
          ? Icon(
              icon,
              size: 18,
              color: iconColor ?? textColor,
            )
          : null,
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color,
    );
  }
}

/// Helper class for status information
class StatusInfo {
  final Color color;
  final String label;
  final IconData icon;

  const StatusInfo({
    required this.color,
    required this.label,
    required this.icon,
  });
}

/// Pre-configured status badges for common league statuses
class LeagueStatusBadge extends StatelessWidget {
  final String status;

  const LeagueStatusBadge({
    super.key,
    required this.status,
  });

  StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pre_draft':
        return const StatusInfo(
          color: Colors.blue,
          label: 'Pre-Draft',
          icon: Icons.schedule,
        );
      case 'drafting':
        return const StatusInfo(
          color: Colors.orange,
          label: 'Drafting',
          icon: Icons.dynamic_feed,
        );
      case 'in_season':
        return const StatusInfo(
          color: Colors.green,
          label: 'In Season',
          icon: Icons.play_circle,
        );
      case 'complete':
        return const StatusInfo(
          color: Colors.grey,
          label: 'Complete',
          icon: Icons.emoji_events,
        );
      default:
        return StatusInfo(
          color: Colors.grey,
          label: status,
          icon: Icons.info,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return StatusBadge(
      label: statusInfo.label,
      color: statusInfo.color,
      icon: statusInfo.icon,
    );
  }
}

/// Pre-configured status badge for payment status
class PaymentStatusBadge extends StatelessWidget {
  final bool isPaid;

  const PaymentStatusBadge({
    super.key,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPaid ? 'Paid' : 'Unpaid',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
