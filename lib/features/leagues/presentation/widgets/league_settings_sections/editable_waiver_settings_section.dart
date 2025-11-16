import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Editable waiver settings section
class EditableWaiverSettingsSection extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(String, dynamic) onChanged;

  const EditableWaiverSettingsSection({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final waiverType = settings['waiver_type']?.toString() ?? 'rolling';
    final faabBudget = (settings['faab_budget'] as num?)?.toInt() ?? 100;
    final waiverPeriodDays = (settings['waiver_period_days'] as num?)?.toInt() ?? 2;
    final processSchedule = settings['process_schedule']?.toString() ?? 'daily';

    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text(
          'Waiver Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waiver Type
                DropdownButtonFormField<String>(
                  value: waiverType,
                  decoration: const InputDecoration(
                    labelText: 'Waiver Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'faab',
                      child: Text('FAAB (Free Agent Auction Bidding)'),
                    ),
                    DropdownMenuItem(
                      value: 'rolling',
                      child: Text('Rolling Waivers'),
                    ),
                    DropdownMenuItem(
                      value: 'continual',
                      child: Text('Continual Rolling List'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onChanged('waiver_type', value);
                  },
                ),
                const SizedBox(height: 16),

                // FAAB Budget (only if FAAB selected)
                if (waiverType == 'faab') ...[
                  TextFormField(
                    initialValue: faabBudget.toString(),
                    decoration: const InputDecoration(
                      labelText: 'FAAB Budget',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      helperText: 'Total budget for free agent bidding',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      onChanged('faab_budget', int.tryParse(value) ?? 100);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Waiver Period
                TextFormField(
                  initialValue: waiverPeriodDays.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Waiver Period (days)',
                    border: OutlineInputBorder(),
                    helperText: 'How many days players are on waivers',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    onChanged('waiver_period_days', int.tryParse(value) ?? 2);
                  },
                ),
                const SizedBox(height: 16),

                // Process Schedule
                DropdownButtonFormField<String>(
                  value: processSchedule,
                  decoration: const InputDecoration(
                    labelText: 'Process Schedule',
                    border: OutlineInputBorder(),
                    helperText: 'How often waivers are processed',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'daily',
                      child: Text('Daily'),
                    ),
                    DropdownMenuItem(
                      value: 'weekly',
                      child: Text('Weekly'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) onChanged('process_schedule', value);
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
