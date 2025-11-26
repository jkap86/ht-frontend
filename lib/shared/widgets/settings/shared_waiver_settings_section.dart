import 'package:flutter/material.dart';
import '../../models/settings_mode.dart';
import '../forms/form_field_builder.dart' as fields;

/// Unified waiver settings section that works in view, edit, or create mode
class SharedWaiverSettingsSection extends StatelessWidget {
  final SettingsMode mode;
  final Map<String, dynamic> settings;
  final Function(String, dynamic)? onChanged;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const SharedWaiverSettingsSection({
    super.key,
    required this.mode,
    required this.settings,
    this.onChanged,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final waiverType = settings['waiver_type']?.toString() ?? 'rolling';
    final faabBudget = (settings['faab_budget'] as num?)?.toInt() ?? 100;
    final waiverPeriodDays = (settings['waiver_period_days'] as num?)?.toInt() ?? 2;
    final processSchedule = settings['process_schedule']?.toString() ?? 'daily';

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? mode.isEditable,
        onExpansionChanged: onExpansionChanged,
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
                fields.SettingsFormFields.buildDropdownField<String>(
                  label: 'Waiver Type',
                  value: waiverType,
                  items: const ['faab', 'rolling', 'continual'],
                  mode: mode,
                  displayText: _formatWaiverType,
                  onChanged: (value) => onChanged?.call('waiver_type', value),
                ),
                const SizedBox(height: 16),

                // FAAB Budget (only if FAAB selected)
                if (waiverType == 'faab') ...[
                  fields.SettingsFormFields.buildNumberField(
                    label: 'FAAB Budget',
                    value: faabBudget,
                    mode: mode,
                    helperText: 'Total budget for free agent bidding',
                    suffix: mode.isReadOnly ? null : '\$',
                    onChanged: (value) => onChanged?.call('faab_budget', value),
                  ),
                  const SizedBox(height: 16),
                ],

                // Waiver Period
                fields.SettingsFormFields.buildNumberField(
                  label: 'Waiver Period',
                  value: waiverPeriodDays,
                  mode: mode,
                  helperText: mode.isEditable ? 'How many days players are on waivers' : null,
                  suffix: 'days',
                  onChanged: (value) => onChanged?.call('waiver_period_days', value),
                ),
                const SizedBox(height: 16),

                // Process Schedule
                fields.SettingsFormFields.buildDropdownField<String>(
                  label: 'Process Schedule',
                  value: processSchedule,
                  items: const ['daily', 'weekly'],
                  mode: mode,
                  displayText: _formatProcessSchedule,
                  onChanged: (value) => onChanged?.call('process_schedule', value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatWaiverType(String waiverType) {
    switch (waiverType.toLowerCase()) {
      case 'faab':
        return 'FAAB (Free Agent Auction Bidding)';
      case 'rolling':
        return 'Rolling Waivers';
      case 'continual':
        return 'Continual Rolling List';
      default:
        return waiverType;
    }
  }

  static String _formatProcessSchedule(String schedule) {
    switch (schedule.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return schedule;
    }
  }
}
