import 'package:flutter/material.dart';
import '../../../domain/league_creation_data.dart';

/// Dumb widget for trade notification settings
/// Pure presentation - receives data and callbacks only
class TradeSettingsSection extends StatelessWidget {
  final LeagueCreationData data;
  final Function(String) onTradeNotificationChanged;
  final Function(String) onTradeDetailsChanged;

  const TradeSettingsSection({
    super.key,
    required this.data,
    required this.onTradeNotificationChanged,
    required this.onTradeDetailsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Trade Notification Settings'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: data.tradeNotificationSetting,
                  decoration: const InputDecoration(
                    labelText: 'Trade Notifications',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'proposer_choice',
                      child: Text('Proposer Choice'),
                    ),
                    DropdownMenuItem(
                      value: 'always_notify',
                      child: Text('Always Notify'),
                    ),
                    DropdownMenuItem(
                      value: 'never_notify',
                      child: Text('Never Notify'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onTradeNotificationChanged(value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: data.tradeDetailsSetting,
                  decoration: const InputDecoration(
                    labelText: 'Trade Details Visibility',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'proposer_choice',
                      child: Text('Proposer Choice'),
                    ),
                    DropdownMenuItem(
                      value: 'always_show',
                      child: Text('Always Show'),
                    ),
                    DropdownMenuItem(
                      value: 'never_show',
                      child: Text('Never Show'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onTradeDetailsChanged(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
