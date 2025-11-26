import 'package:flutter/material.dart';
import '../../models/settings_mode.dart';
import '../forms/form_field_builder.dart' as fields;

/// Unified schedule settings section that works in view, edit, or create mode
class SharedScheduleSection extends StatelessWidget {
  final SettingsMode mode;
  final Map<String, dynamic> settings;
  final Function(String, dynamic)? onChanged;
  final bool? initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const SharedScheduleSection({
    super.key,
    required this.mode,
    required this.settings,
    this.onChanged,
    this.initiallyExpanded,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final startWeek = (settings['start_week'] as num?)?.toInt() ?? 1;
    final endWeek = (settings['end_week'] as num?)?.toInt() ?? 17;
    final playoffsEnabled = settings['playoffs_enabled'] as bool? ?? false;
    final playoffWeekStart = (settings['playoff_week_start'] as num?)?.toInt() ?? 15;
    final playoffTeams = (settings['playoff_teams'] as num?)?.toInt() ?? 6;
    final matchupsType = settings['matchups_type']?.toString() ?? 'randomize';
    final matchupDraftOrder = settings['matchup_draft_order']?.toString() ?? 'randomize';

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? mode.isEditable,
        onExpansionChanged: onExpansionChanged,
        title: const Text(
          'Schedule',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Regular Season
                fields.SettingsFormFields.buildSectionHeader('Regular Season'),
                const SizedBox(height: 8),

                // Start Week and End Week
                if (mode.isEditable)
                  Row(
                    children: [
                      Expanded(
                        child: fields.SettingsFormFields.buildNumberField(
                          label: 'Start Week',
                          value: startWeek,
                          mode: mode,
                          onChanged: (value) => onChanged?.call('start_week', value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: fields.SettingsFormFields.buildNumberField(
                          label: 'End Week',
                          value: endWeek,
                          mode: mode,
                          onChanged: (value) => onChanged?.call('end_week', value),
                        ),
                      ),
                    ],
                  )
                else ...[
                  fields.SettingsFormFields.buildNumberField(
                    label: 'Start Week',
                    value: startWeek,
                    mode: mode,
                    onChanged: (value) => onChanged?.call('start_week', value),
                  ),
                  const SizedBox(height: 16),
                  fields.SettingsFormFields.buildNumberField(
                    label: 'End Week',
                    value: endWeek,
                    mode: mode,
                    onChanged: (value) => onChanged?.call('end_week', value),
                  ),
                ],

                const SizedBox(height: 16),

                // Matchup Generation
                fields.SettingsFormFields.buildDropdownField<String>(
                  label: 'Matchup Generation',
                  value: matchupsType,
                  mode: mode,
                  items: const ['randomize', 'draft'],
                  displayText: _formatMatchupsType,
                  onChanged: (value) => onChanged?.call('matchups_type', value),
                ),

                // Draft Order (only shown when matchups type is draft)
                if (matchupsType == 'draft') ...[
                  const SizedBox(height: 16),
                  fields.SettingsFormFields.buildDropdownField<String>(
                    label: 'Draft Order',
                    value: matchupDraftOrder,
                    mode: mode,
                    items: const ['randomize', 'player_draft_order', 'reversed_player_draft_order'],
                    displayText: _formatDraftOrder,
                    onChanged: (value) => onChanged?.call('matchup_draft_order', value),
                  ),
                ],

                const SizedBox(height: 16),
                fields.SettingsFormFields.buildDivider(),

                // Playoffs
                fields.SettingsFormFields.buildSectionHeader('Playoffs'),
                const SizedBox(height: 8),

                fields.SettingsFormFields.buildSwitchField(
                  label: 'Enable Playoffs',
                  value: playoffsEnabled,
                  mode: mode,
                  subtitle: mode.isEditable
                      ? 'Enable playoff competition at end of season'
                      : null,
                  onChanged: (value) => onChanged?.call('playoffs_enabled', value),
                ),

                // Playoff-specific settings (only shown when playoffs are enabled)
                if (playoffsEnabled) ...[
                  const SizedBox(height: 16),

                  // Playoff Start Week and Playoff Teams
                  if (mode.isEditable)
                    Row(
                      children: [
                        Expanded(
                          child: fields.SettingsFormFields.buildNumberField(
                            label: 'Playoff Start Week',
                            value: playoffWeekStart,
                            mode: mode,
                            onChanged: (value) => onChanged?.call('playoff_week_start', value),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: fields.SettingsFormFields.buildNumberField(
                            label: 'Playoff Teams',
                            value: playoffTeams,
                            mode: mode,
                            onChanged: (value) => onChanged?.call('playoff_teams', value),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    fields.SettingsFormFields.buildNumberField(
                      label: 'Playoff Start',
                      value: playoffWeekStart,
                      mode: mode,
                      suffix: playoffWeekStart == 1 ? 'week' : 'weeks',
                      onChanged: (value) => onChanged?.call('playoff_week_start', value),
                    ),
                    const SizedBox(height: 16),
                    fields.SettingsFormFields.buildNumberField(
                      label: 'Playoff Teams',
                      value: playoffTeams,
                      mode: mode,
                      suffix: playoffTeams == 1 ? 'team' : 'teams',
                      onChanged: (value) => onChanged?.call('playoff_teams', value),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMatchupsType(String matchupsType) {
    switch (matchupsType.toLowerCase()) {
      case 'draft':
        return 'Draft';
      case 'randomize':
      default:
        return 'Randomize';
    }
  }

  String _formatDraftOrder(String draftOrder) {
    switch (draftOrder.toLowerCase()) {
      case 'player_draft_order':
        return 'Player Draft Order';
      case 'reversed_player_draft_order':
        return 'Reversed Player Draft Order';
      case 'randomize':
      default:
        return 'Randomize';
    }
  }
}
