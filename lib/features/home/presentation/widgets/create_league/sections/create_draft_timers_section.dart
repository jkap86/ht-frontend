import 'package:flutter/material.dart';

/// Timer settings section for create league flow
class CreateDraftTimersSection extends StatelessWidget {
  final String timerMode;
  final int pickTimeSeconds;
  final Function(String) onTimerModeChanged;
  final Function(int) onPickTimeSecondsChanged;

  const CreateDraftTimersSection({
    super.key,
    required this.timerMode,
    required this.pickTimeSeconds,
    required this.onTimerModeChanged,
    required this.onPickTimeSecondsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pick Time
        TextFormField(
          initialValue: pickTimeSeconds.toString(),
          decoration: const InputDecoration(
            labelText: 'Pick Time (seconds)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final seconds = int.tryParse(value);
            if (seconds != null) onPickTimeSecondsChanged(seconds);
          },
        ),
        const SizedBox(height: 16),

        // Timer Mode
        DropdownButtonFormField<String>(
          value: timerMode,
          decoration: const InputDecoration(
              labelText: 'Timer Mode', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'per_pick', child: Text('Per Pick')),
            DropdownMenuItem(value: 'per_manager', child: Text('Per Manager')),
          ],
          onChanged: (value) {
            if (value != null) onTimerModeChanged(value);
          },
        ),
      ],
    );
  }
}
