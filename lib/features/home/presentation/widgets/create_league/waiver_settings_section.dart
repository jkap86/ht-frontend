import 'package:flutter/material.dart';
import '../../../domain/league_creation_data.dart';

/// Dumb widget for waiver settings
/// Pure presentation - receives data and callbacks only
class WaiverSettingsSection extends StatelessWidget {
  final LeagueCreationData data;
  final Function(String) onWaiverTypeChanged;
  final Function(int) onFaabBudgetChanged;
  final Function(int) onWaiverPeriodDaysChanged;
  final Function(String) onProcessScheduleChanged;

  const WaiverSettingsSection({
    super.key,
    required this.data,
    required this.onWaiverTypeChanged,
    required this.onFaabBudgetChanged,
    required this.onWaiverPeriodDaysChanged,
    required this.onProcessScheduleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Waiver Settings'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: data.waiverType,
                  decoration: const InputDecoration(
                    labelText: 'Waiver Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'faab',
                      child: Text('FAAB (Free Agent Budget)'),
                    ),
                    DropdownMenuItem(
                      value: 'rolling',
                      child: Text('Rolling Waivers'),
                    ),
                    DropdownMenuItem(
                      value: 'reverse_standings',
                      child: Text('Reverse Standings'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onWaiverTypeChanged(value);
                  },
                ),
                if (data.waiverType == 'faab') ...[
                  const SizedBox(height: 16),
                  _NumberSelector(
                    label: 'FAAB Budget',
                    value: data.faabBudget,
                    min: 0,
                    max: 1000,
                    onChanged: onFaabBudgetChanged,
                  ),
                ],
                const SizedBox(height: 16),
                _NumberSelector(
                  label: 'Waiver Period (Days)',
                  value: data.waiverPeriodDays,
                  min: 0,
                  max: 7,
                  onChanged: onWaiverPeriodDaysChanged,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: data.processSchedule,
                  decoration: const InputDecoration(
                    labelText: 'Processing Schedule',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'sunday', child: Text('Sunday')),
                    DropdownMenuItem(value: 'tuesday', child: Text('Tuesday/Thursday')),
                  ],
                  onChanged: (value) {
                    if (value != null) onProcessScheduleChanged(value);
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

class _NumberSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const _NumberSelector({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > min ? () => onChanged(value - 1) : null,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
