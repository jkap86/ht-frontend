import 'package:flutter/material.dart';
import 'settings/edit_draft_basic_settings_section.dart';
import 'settings/edit_draft_timer_settings_section.dart';
import 'settings/edit_draft_order_settings_section.dart';
import 'settings/edit_derby_settings_section.dart';

/// Draft configuration form widget
class EditDraftSettingsForm extends StatelessWidget {
  final String draftType;
  final bool thirdRoundReversal;
  final int draftRounds;
  final int pickTimeSeconds;
  final String playerPool;
  final String draftOrder;
  final String timerMode;
  final bool useRosterPositions;
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final int derbyTimerHours;
  final int derbyTimerMinutes;
  final int derbyTimerSeconds;
  final String derbyOnTimeout;
  final Map<String, dynamic>? rosterPositions;
  final bool isCommissioner;
  final Function(String) onDraftTypeChanged;
  final Function(bool) onThirdRoundReversalChanged;
  final Function(int) onDraftRoundsChanged;
  final Function(int) onPickTimeSecondsChanged;
  final Function(String) onPlayerPoolChanged;
  final Function(String) onDraftOrderChanged;
  final Function(String) onTimerModeChanged;
  final Function(bool) onUseRosterPositionsChanged;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;
  final Function(int) onDerbyTimerHoursChanged;
  final Function(int) onDerbyTimerMinutesChanged;
  final Function(int) onDerbyTimerSecondsChanged;
  final Function(String) onDerbyOnTimeoutChanged;
  final VoidCallback onSaveDraft;
  final VoidCallback onCancelDraft;

  const EditDraftSettingsForm({
    super.key,
    required this.draftType,
    required this.thirdRoundReversal,
    required this.draftRounds,
    required this.pickTimeSeconds,
    required this.playerPool,
    required this.draftOrder,
    required this.timerMode,
    required this.useRosterPositions,
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.derbyTimerHours,
    required this.derbyTimerMinutes,
    required this.derbyTimerSeconds,
    required this.derbyOnTimeout,
    this.rosterPositions,
    required this.isCommissioner,
    required this.onDraftTypeChanged,
    required this.onThirdRoundReversalChanged,
    required this.onDraftRoundsChanged,
    required this.onPickTimeSecondsChanged,
    required this.onPlayerPoolChanged,
    required this.onDraftOrderChanged,
    required this.onTimerModeChanged,
    required this.onUseRosterPositionsChanged,
    required this.onDerbyStartTimeChanged,
    required this.onAutoStartDerbyChanged,
    required this.onDerbyTimerHoursChanged,
    required this.onDerbyTimerMinutesChanged,
    required this.onDerbyTimerSecondsChanged,
    required this.onDerbyOnTimeoutChanged,
    required this.onSaveDraft,
    required this.onCancelDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Draft mode indicator
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, size: 16, color: Colors.orange.shade900),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Editing draft settings - click Save to apply changes',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Basic Settings
          EditDraftBasicSettingsSection(
            draftType: draftType,
            thirdRoundReversal: thirdRoundReversal,
            draftRounds: draftRounds,
            playerPool: playerPool,
            useRosterPositions: useRosterPositions,
            isCommissioner: isCommissioner,
            onDraftTypeChanged: onDraftTypeChanged,
            onThirdRoundReversalChanged: onThirdRoundReversalChanged,
            onDraftRoundsChanged: onDraftRoundsChanged,
            onPlayerPoolChanged: onPlayerPoolChanged,
          ),
          const SizedBox(height: 16),

          // Timer Settings
          EditDraftTimerSettingsSection(
            timerMode: timerMode,
            pickTimeSeconds: pickTimeSeconds,
            isCommissioner: isCommissioner,
            onTimerModeChanged: onTimerModeChanged,
            onPickTimeSecondsChanged: onPickTimeSecondsChanged,
          ),
          const SizedBox(height: 16),

          // Draft Order
          EditDraftOrderSettingsSection(
            draftOrder: draftOrder,
            isCommissioner: isCommissioner,
            onDraftOrderChanged: onDraftOrderChanged,
          ),

          // Derby Settings (shown when derby order is selected)
          if (draftOrder == 'derby')
            EditDerbySettingsSection(
              derbyTimerHours: derbyTimerHours,
              derbyTimerMinutes: derbyTimerMinutes,
              derbyTimerSeconds: derbyTimerSeconds,
              derbyOnTimeout: derbyOnTimeout,
              derbyStartTime: derbyStartTime,
              autoStartDerby: autoStartDerby,
              isCommissioner: isCommissioner,
              onDerbyTimerHoursChanged: onDerbyTimerHoursChanged,
              onDerbyTimerMinutesChanged: onDerbyTimerMinutesChanged,
              onDerbyTimerSecondsChanged: onDerbyTimerSecondsChanged,
              onDerbyOnTimeoutChanged: onDerbyOnTimeoutChanged,
              onDerbyStartTimeChanged: onDerbyStartTimeChanged,
              onAutoStartDerbyChanged: onAutoStartDerbyChanged,
            ),

          // Action buttons
          if (isCommissioner) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancelDraft,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onSaveDraft,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Draft'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
