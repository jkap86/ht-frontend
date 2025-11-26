import 'package:flutter/material.dart';
import 'create_draft_order_settings_section.dart';
import 'create_derby_settings_section.dart';

/// Advanced draft settings section that combines draft order and derby settings
class CreateDraftAdvancedSettingsSection extends StatelessWidget {
  final String draftOrder;
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final int derbyTimerHours;
  final int derbyTimerMinutes;
  final int derbyTimerSeconds;
  final Function(String) onDraftOrderChanged;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;
  final Function(int) onDerbyTimerHoursChanged;
  final Function(int) onDerbyTimerMinutesChanged;
  final Function(int) onDerbyTimerSecondsChanged;

  const CreateDraftAdvancedSettingsSection({
    super.key,
    required this.draftOrder,
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.derbyTimerHours,
    required this.derbyTimerMinutes,
    required this.derbyTimerSeconds,
    required this.onDraftOrderChanged,
    required this.onDerbyStartTimeChanged,
    required this.onAutoStartDerbyChanged,
    required this.onDerbyTimerHoursChanged,
    required this.onDerbyTimerMinutesChanged,
    required this.onDerbyTimerSecondsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Draft Order Settings
        CreateDraftOrderSettingsSection(
          draftOrder: draftOrder,
          onDraftOrderChanged: onDraftOrderChanged,
        ),

        // Derby Settings (shown when derby order is selected)
        if (draftOrder == 'derby') ...[
          const SizedBox(height: 16),
          CreateDerbySettingsSection(
            derbyStartTime: derbyStartTime,
            autoStartDerby: autoStartDerby,
            derbyTimerHours: derbyTimerHours,
            derbyTimerMinutes: derbyTimerMinutes,
            derbyTimerSeconds: derbyTimerSeconds,
            onDerbyStartTimeChanged: onDerbyStartTimeChanged,
            onAutoStartDerbyChanged: onAutoStartDerbyChanged,
            onDerbyTimerHoursChanged: onDerbyTimerHoursChanged,
            onDerbyTimerMinutesChanged: onDerbyTimerMinutesChanged,
            onDerbyTimerSecondsChanged: onDerbyTimerSecondsChanged,
          ),
        ],
      ],
    );
  }
}