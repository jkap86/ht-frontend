import 'package:flutter/material.dart';

/// Timer-related draft settings section
class EditDraftTimerSettingsSection extends StatelessWidget {
  final String timerMode;
  final int pickTimeSeconds;
  final bool isCommissioner;
  final Function(String) onTimerModeChanged;
  final Function(int) onPickTimeSecondsChanged;

  const EditDraftTimerSettingsSection({
    super.key,
    required this.timerMode,
    required this.pickTimeSeconds,
    required this.isCommissioner,
    required this.onTimerModeChanged,
    required this.onPickTimeSecondsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Timer Mode
        DropdownButtonFormField<String>(
          value: timerMode,
          decoration: const InputDecoration(
              labelText: 'Timer Mode', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'per_pick', child: Text('Per Pick')),
            DropdownMenuItem(value: 'per_manager', child: Text('Per Manager')),
          ],
          onChanged: isCommissioner
              ? (value) {
                  if (value != null) onTimerModeChanged(value);
                }
              : null,
        ),
        const SizedBox(height: 16),

        // Pick Time
        TextFormField(
          initialValue: pickTimeSeconds.toString(),
          decoration: const InputDecoration(
            labelText: 'Pick Time (seconds)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          enabled: isCommissioner,
          onChanged: (value) {
            final seconds = int.tryParse(value);
            if (seconds != null) onPickTimeSecondsChanged(seconds);
          },
        ),
      ],
    );
  }
}
