import 'package:flutter/material.dart';
import '../../models/settings_mode.dart';
import '../forms/form_field_builder.dart' as fields;

/// Unified draft settings component that works in view, edit, or create mode
///
/// Note: This component handles displaying/editing a single draft's settings.
/// For managing multiple drafts (CRUD operations), use this within a parent
/// widget that handles the list management.
class SharedDraftSettingsSection extends StatelessWidget {
  final SettingsMode mode;
  final Map<String, dynamic> draftSettings;
  final Function(String, dynamic)? onChanged;
  final bool showDerbyCountdown;

  const SharedDraftSettingsSection({
    super.key,
    required this.mode,
    required this.draftSettings,
    this.onChanged,
    this.showDerbyCountdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final draftType = draftSettings['draft_type']?.toString() ?? 'snake';
    final thirdRoundReversal = draftSettings['third_round_reversal'] as bool? ?? false;
    final rounds = (draftSettings['rounds'] as num?)?.toInt() ?? 15;
    final pickTimeSeconds = (draftSettings['pick_time_seconds'] as num?)?.toInt() ?? 90;

    final settings = draftSettings['settings'] as Map<String, dynamic>? ?? {};
    final playerPool = settings['player_pool']?.toString() ?? 'all';
    final draftOrder = settings['draft_order']?.toString() ?? 'random';
    final timerMode = settings['timer_mode']?.toString() ?? 'per_pick';
    final derbyStartTimeStr = settings['derby_start_time'] as String?;
    final autoStartDerby = settings['auto_start_derby'] as bool? ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Draft Type
            fields.SettingsFormFields.buildDropdownField<String>(
              label: 'Draft Type',
              value: draftType,
              items: const ['snake', 'linear'],
              mode: mode,
              displayText: _formatDraftType,
              onChanged: (value) => onChanged?.call('draft_type', value),
            ),
            const SizedBox(height: 16),

            // Third Round Reversal (only for snake drafts)
            if (draftType == 'snake') ...[
              fields.SettingsFormFields.buildSwitchField(
                label: 'Third Round Reversal',
                value: thirdRoundReversal,
                mode: mode,
                subtitle: mode.isEditable
                    ? 'Reverses the draft order on the 3rd round'
                    : null,
                onChanged: (value) => onChanged?.call('third_round_reversal', value),
              ),
              const SizedBox(height: 16),
            ],

            // Draft Rounds and Pick Time
            if (mode.isEditable)
              Row(
                children: [
                  Expanded(
                    child: fields.SettingsFormFields.buildNumberField(
                      label: 'Draft Rounds',
                      value: rounds,
                      mode: mode,
                      onChanged: (value) => onChanged?.call('rounds', value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: fields.SettingsFormFields.buildNumberField(
                      label: 'Pick Time',
                      value: pickTimeSeconds,
                      mode: mode,
                      suffix: 'sec',
                      onChanged: (value) => onChanged?.call('pick_time_seconds', value),
                    ),
                  ),
                ],
              )
            else ...[
              fields.SettingsFormFields.buildNumberField(
                label: 'Rounds',
                value: rounds,
                mode: mode,
                onChanged: (value) => onChanged?.call('rounds', value),
              ),
              const SizedBox(height: 16),
              fields.SettingsFormFields.buildNumberField(
                label: 'Pick Time',
                value: pickTimeSeconds,
                mode: mode,
                suffix: 'seconds',
                onChanged: (value) => onChanged?.call('pick_time_seconds', value),
              ),
            ],
            const SizedBox(height: 16),

            // Player Pool
            fields.SettingsFormFields.buildDropdownField<String>(
              label: 'Player Pool',
              value: playerPool,
              items: const ['all', 'rookie', 'vet'],
              mode: mode,
              displayText: _formatPlayerPool,
              onChanged: (value) => onChanged?.call('player_pool', value),
            ),
            const SizedBox(height: 16),

            // Draft Order
            fields.SettingsFormFields.buildDropdownField<String>(
              label: 'Draft Order',
              value: draftOrder,
              items: const ['random', 'derby'],
              mode: mode,
              displayText: _formatDraftOrder,
              onChanged: (value) {
                onChanged?.call('draft_order', value);
                // Reset derby settings when switching away from derby
                if (value != 'derby') {
                  onChanged?.call('derby_start_time', null);
                  onChanged?.call('auto_start_derby', false);
                }
              },
            ),
            const SizedBox(height: 16),

            // Timer Mode
            fields.SettingsFormFields.buildDropdownField<String>(
              label: 'Timer Mode',
              value: timerMode,
              items: const ['per_pick', 'per_manager'],
              mode: mode,
              displayText: _formatTimerMode,
              onChanged: (value) => onChanged?.call('timer_mode', value),
            ),

            // Derby-specific fields (only shown when derby order is selected)
            if (draftOrder == 'derby') ...[
              const SizedBox(height: 16),
              fields.SettingsFormFields.buildDivider(),
              fields.SettingsFormFields.buildSectionHeader('Derby Settings'),

              // Derby Start Time
              if (mode.isReadOnly) ...[
                _buildViewField(
                  context,
                  'Derby Start Time',
                  derbyStartTimeStr != null
                      ? _formatDateTime(derbyStartTimeStr)
                      : 'Not set',
                ),
                const SizedBox(height: 16),
              ] else ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Derby Start Time (Optional)'),
                  subtitle: Text(
                    derbyStartTimeStr != null
                        ? _formatDateTime(derbyStartTimeStr)
                        : 'Not set',
                    style: TextStyle(
                      fontSize: 14,
                      color: derbyStartTimeStr != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (derbyStartTimeStr != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => onChanged?.call('derby_start_time', null),
                          tooltip: 'Clear',
                        ),
                      FilledButton.tonalIcon(
                        onPressed: () => _selectDerbyStartTime(context),
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text('Select'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Auto Start Derby
              fields.SettingsFormFields.buildSwitchField(
                label: 'Auto Start Derby',
                value: autoStartDerby,
                mode: mode,
                subtitle: mode.isEditable
                    ? 'Automatically start the derby at the scheduled time'
                    : null,
                onChanged: (value) => onChanged?.call('auto_start_derby', value),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build a read-only info field (used in view mode)
  Widget _buildViewField(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDerbyStartTime(BuildContext context) async {
    final now = DateTime.now();
    final currentStartTime = draftSettings['settings']?['derby_start_time'] as String?;
    final initialDate = currentStartTime != null
        ? DateTime.tryParse(currentStartTime) ?? now
        : now;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null && context.mounted) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (selectedTime != null) {
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        onChanged?.call('derby_start_time', dateTime.toIso8601String());
      }
    }
  }

  static String _formatDraftType(String type) {
    switch (type.toLowerCase()) {
      case 'snake':
        return 'Snake Draft';
      case 'linear':
        return 'Linear Draft';
      default:
        return type;
    }
  }

  static String _formatPlayerPool(String pool) {
    switch (pool.toLowerCase()) {
      case 'all':
        return 'All Players';
      case 'rookie':
        return 'Rookies Only';
      case 'vet':
        return 'Veterans Only';
      default:
        return pool;
    }
  }

  static String _formatDraftOrder(String order) {
    switch (order.toLowerCase()) {
      case 'random':
        return 'Randomize';
      case 'derby':
        return 'Derby';
      default:
        return order;
    }
  }

  static String _formatTimerMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'per_pick':
        return 'Per Pick';
      case 'per_manager':
        return 'Per Manager';
      default:
        return mode;
    }
  }

  static String _formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}
