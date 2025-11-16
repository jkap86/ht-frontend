import 'package:flutter/material.dart';
import 'info_section.dart';
import 'info_row.dart';

/// Dumb widget displaying waiver settings
class WaiverSettingsSection extends StatelessWidget {
  final Map<String, dynamic> settings;

  const WaiverSettingsSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Waiver Settings',
      children: [
        InfoRow(
          label: 'Waiver Type',
          value: _formatWaiverType(settings['waiver_type']),
        ),
        if (settings['waiver_type'] == 'faab')
          InfoRow(
            label: 'FAAB Budget',
            value: '\$${settings['faab_budget'] ?? 100}',
          ),
        InfoRow(
          label: 'Waiver Period',
          value: '${settings['waiver_period_days'] ?? 2} days',
        ),
        InfoRow(
          label: 'Process Schedule',
          value: _formatProcessSchedule(settings['process_schedule']),
        ),
      ],
    );
  }

  String _formatWaiverType(dynamic waiverType) {
    if (waiverType == null) return 'N/A';
    switch (waiverType.toString().toLowerCase()) {
      case 'faab':
        return 'FAAB (Free Agent Auction Bidding)';
      case 'rolling':
        return 'Rolling Waivers';
      case 'continual':
        return 'Continual Rolling List';
      default:
        return waiverType.toString();
    }
  }

  String _formatProcessSchedule(dynamic schedule) {
    if (schedule == null) return 'N/A';
    switch (schedule.toString().toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return schedule.toString();
    }
  }
}
