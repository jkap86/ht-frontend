import 'package:flutter/material.dart';
import '../../models/settings_mode.dart';
import '../forms/form_field_builder.dart' as fields;

/// Unified waiver settings section that works in view, edit, or create mode
/// Includes Sleeper-like waiver options for commissioners
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
    // Waiver settings
    final waiversEnabled = settings['waivers_enabled'] as bool? ?? true;
    final waiverType = settings['waiver_type']?.toString() ?? 'rolling';
    final faabBudget = (settings['faab_budget'] as num?)?.toInt() ?? 100;
    final waiverPeriodDays = (settings['waiver_period_days'] as num?)?.toInt() ?? 2;
    final waiverDayOfWeek = (settings['waiver_day_of_week'] as num?)?.toInt() ?? 2;
    final waiverClearTime = settings['waiver_clear_time']?.toString() ?? '00:00';
    final continuousWaivers = settings['continuous_waivers'] as bool? ?? false;
    final lockPlayersAtGameStart = settings['lock_players_at_game_start'] as bool? ?? true;
    final minFaabBid = (settings['min_faab_bid'] as num?)?.toInt() ?? 0;
    final waiverPriorityReset = settings['waiver_priority_reset']?.toString() ?? 'never';

    // Trade settings
    final tradesEnabled = settings['trades_enabled'] as bool? ?? true;
    final tradeDeadline = settings['trade_deadline']?.toString();
    final tradeReviewPeriodHours = (settings['trade_review_period_hours'] as num?)?.toInt() ?? 24;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded ?? mode.isEditable,
        onExpansionChanged: onExpansionChanged,
        title: const Text(
          'Waiver & Trade Settings',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === WAIVER SETTINGS SECTION ===
                Text(
                  'Waiver Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Waivers Enabled Toggle
                fields.SettingsFormFields.buildSwitchField(
                  label: 'Waivers Enabled',
                  value: waiversEnabled,
                  mode: mode,
                  subtitle: 'When disabled, all players become free agents',
                  onChanged: (value) => onChanged?.call('waivers_enabled', value),
                ),
                const SizedBox(height: 16),

                // Waiver Type
                if (waiversEnabled) ...[
                  fields.SettingsFormFields.buildDropdownField<String>(
                    label: 'Waiver Type',
                    value: waiverType,
                    items: const ['faab', 'rolling', 'reverse_standings'],
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

                    // Minimum FAAB Bid
                    fields.SettingsFormFields.buildNumberField(
                      label: 'Minimum Bid',
                      value: minFaabBid,
                      mode: mode,
                      helperText: 'Minimum bid amount for waiver claims',
                      suffix: mode.isReadOnly ? null : '\$',
                      onChanged: (value) => onChanged?.call('min_faab_bid', value),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Waiver Period
                  fields.SettingsFormFields.buildDropdownField<int>(
                    label: 'Waiver Period',
                    value: waiverPeriodDays,
                    items: const [0, 1, 2, 3],
                    mode: mode,
                    displayText: (days) => days == 0 ? 'No waiver period' : '$days day${days > 1 ? 's' : ''}',
                    onChanged: (value) => onChanged?.call('waiver_period_days', value),
                  ),
                  const SizedBox(height: 16),

                  // Waiver Clear Day
                  fields.SettingsFormFields.buildDropdownField<int>(
                    label: 'Waiver Clear Day',
                    value: waiverDayOfWeek,
                    items: const [0, 1, 2, 3, 4, 5, 6],
                    mode: mode,
                    displayText: _formatDayOfWeek,
                    onChanged: (value) => onChanged?.call('waiver_day_of_week', value),
                  ),
                  const SizedBox(height: 16),

                  // Waiver Clear Time
                  fields.SettingsFormFields.buildDropdownField<String>(
                    label: 'Waiver Clear Time',
                    value: waiverClearTime,
                    items: const ['00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00'],
                    mode: mode,
                    displayText: _formatTime,
                    onChanged: (value) => onChanged?.call('waiver_clear_time', value),
                  ),
                  const SizedBox(height: 16),

                  // Continuous Waivers
                  fields.SettingsFormFields.buildSwitchField(
                    label: 'Continuous Waivers',
                    value: continuousWaivers,
                    mode: mode,
                    subtitle: 'Waivers run every day instead of once per week',
                    onChanged: (value) => onChanged?.call('continuous_waivers', value),
                  ),
                  const SizedBox(height: 16),

                  // Waiver Priority Reset (for rolling/reverse standings)
                  if (waiverType != 'faab') ...[
                    fields.SettingsFormFields.buildDropdownField<String>(
                      label: 'Waiver Priority Reset',
                      value: waiverPriorityReset,
                      items: const ['never', 'weekly', 'end_of_season'],
                      mode: mode,
                      displayText: _formatPriorityReset,
                      onChanged: (value) => onChanged?.call('waiver_priority_reset', value),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                // Lock Players at Game Start
                fields.SettingsFormFields.buildSwitchField(
                  label: 'Lock Players at Game Start',
                  value: lockPlayersAtGameStart,
                  mode: mode,
                  subtitle: 'Prevent add/drop of players whose games have started',
                  onChanged: (value) => onChanged?.call('lock_players_at_game_start', value),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // === TRADE SETTINGS SECTION ===
                Text(
                  'Trade Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Trades Enabled Toggle
                fields.SettingsFormFields.buildSwitchField(
                  label: 'Trades Enabled',
                  value: tradesEnabled,
                  mode: mode,
                  subtitle: 'Allow roster-to-roster trades',
                  onChanged: (value) => onChanged?.call('trades_enabled', value),
                ),
                const SizedBox(height: 16),

                if (tradesEnabled) ...[
                  // Trade Review Period
                  fields.SettingsFormFields.buildDropdownField<int>(
                    label: 'Trade Review Period',
                    value: tradeReviewPeriodHours,
                    items: const [0, 12, 24, 48, 72],
                    mode: mode,
                    displayText: (hours) => hours == 0 ? 'Instant (no review)' : '$hours hours',
                    onChanged: (value) => onChanged?.call('trade_review_period_hours', value),
                  ),
                  const SizedBox(height: 16),

                  // Trade Deadline
                  if (mode.isEditable) ...[
                    _buildTradeDatePicker(context, tradeDeadline),
                  ] else if (tradeDeadline != null) ...[
                    fields.SettingsFormFields.buildTextField(
                      label: 'Trade Deadline',
                      value: _formatDate(tradeDeadline),
                      mode: mode,
                    ),
                  ] else ...[
                    fields.SettingsFormFields.buildTextField(
                      label: 'Trade Deadline',
                      value: 'No deadline set',
                      mode: mode,
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

  Widget _buildTradeDatePicker(BuildContext context, String? currentDeadline) {
    DateTime? selectedDate;
    if (currentDeadline != null) {
      try {
        selectedDate = DateTime.parse(currentDeadline);
      } catch (_) {}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trade Deadline'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                selectedDate != null ? _formatDate(currentDeadline!) : 'No deadline set',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Set Deadline'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  onChanged?.call('trade_deadline', picked.toIso8601String().split('T')[0]);
                }
              },
            ),
            if (selectedDate != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => onChanged?.call('trade_deadline', null),
                tooltip: 'Clear deadline',
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Trades will be disabled after this date',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  static String _formatWaiverType(String waiverType) {
    switch (waiverType.toLowerCase()) {
      case 'faab':
        return 'FAAB (Free Agent Auction Budget)';
      case 'rolling':
        return 'Rolling Waivers';
      case 'reverse_standings':
        return 'Reverse Standings Order';
      case 'continual':
        return 'Continual Rolling List';
      default:
        return waiverType;
    }
  }

  static String _formatDayOfWeek(int day) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[day];
  }

  static String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${parts[1]} $suffix';
  }

  static String _formatPriorityReset(String reset) {
    switch (reset.toLowerCase()) {
      case 'never':
        return 'Never (Rolling)';
      case 'weekly':
        return 'Reset Weekly';
      case 'end_of_season':
        return 'Reset End of Season';
      default:
        return reset;
    }
  }

  static String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.month}/${date.day}/${date.year}';
    } catch (_) {
      return isoDate;
    }
  }
}
