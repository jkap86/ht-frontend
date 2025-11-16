import 'package:flutter/material.dart';
import '../../domain/league.dart';

/// Displays the main league information in a card
/// Extracted component for better composition and reusability
class LeagueHeaderCard extends StatelessWidget {
  final League league;

  const LeagueHeaderCard({
    super.key,
    required this.league,
  });

  @override
  Widget build(BuildContext context) {
    final dues = (league.settings?['dues'] as num?)?.toDouble() ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              league.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _LeagueStatusBadge(status: league.status),
                _LeagueInfoChip(
                  icon: Icons.calendar_today,
                  label: '${league.settings?['season'] ?? 'N/A'} Season',
                ),
                _LeagueInfoChip(
                  icon: Icons.people,
                  label: '${league.totalRosters} Teams',
                ),
                if (dues > 0)
                  _LeagueInfoChip(
                    icon: Icons.attach_money,
                    label: '\$${dues.toStringAsFixed(0)} Entry',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge showing league status with color coding
class _LeagueStatusBadge extends StatelessWidget {
  final String status;

  const _LeagueStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Chip(
      avatar: Icon(
        statusInfo.icon,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        statusInfo.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: statusInfo.color,
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pre_draft':
        return _StatusInfo(
          color: Colors.blue,
          label: 'Pre-Draft',
          icon: Icons.schedule,
        );
      case 'drafting':
        return _StatusInfo(
          color: Colors.orange,
          label: 'Drafting',
          icon: Icons.dynamic_feed,
        );
      case 'in_season':
        return _StatusInfo(
          color: Colors.green,
          label: 'In Season',
          icon: Icons.play_circle,
        );
      case 'complete':
        return _StatusInfo(
          color: Colors.grey,
          label: 'Complete',
          icon: Icons.emoji_events,
        );
      default:
        return _StatusInfo(
          color: Colors.grey,
          label: status,
          icon: Icons.info,
        );
    }
  }
}

class _StatusInfo {
  final Color color;
  final String label;
  final IconData icon;

  _StatusInfo({
    required this.color,
    required this.label,
    required this.icon,
  });
}

/// Info chip for displaying league metadata
class _LeagueInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LeagueInfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
