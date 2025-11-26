import 'dart:async';
import 'package:flutter/material.dart';

/// Derby settings section for create league flow
class CreateDerbySettingsSection extends StatelessWidget {
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final int derbyTimerHours;
  final int derbyTimerMinutes;
  final int derbyTimerSeconds;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;
  final Function(int) onDerbyTimerHoursChanged;
  final Function(int) onDerbyTimerMinutesChanged;
  final Function(int) onDerbyTimerSecondsChanged;

  const CreateDerbySettingsSection({
    super.key,
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.derbyTimerHours,
    required this.derbyTimerMinutes,
    required this.derbyTimerSeconds,
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
        const SizedBox(height: 12),
        if (derbyStartTime != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Derby starts in:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DerbyCountdown(targetTime: derbyStartTime!),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Derby start time not set',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Derby Start Time (optional)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Derby Start Time (Optional)'),
          subtitle: Text(
            derbyStartTime != null
                ? '${derbyStartTime!.month}/${derbyStartTime!.day}/${derbyStartTime!.year} at ${derbyStartTime!.hour.toString().padLeft(2, '0')}:${derbyStartTime!.minute.toString().padLeft(2, '0')}'
                : 'Not set',
            style: TextStyle(
              fontSize: 14,
              color: derbyStartTime != null
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (derbyStartTime != null)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => onDerbyStartTimeChanged(null),
                  tooltip: 'Clear',
                ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  final now = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: derbyStartTime ?? now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                  );

                  if (selectedDate != null && context.mounted) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: derbyStartTime != null
                          ? TimeOfDay.fromDateTime(derbyStartTime!)
                          : TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      final dateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      onDerbyStartTimeChanged(dateTime);
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('Select'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Auto Start Derby toggle
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto Start Derby'),
          subtitle: const Text(
            'Automatically start the derby at the scheduled time',
            style: TextStyle(fontSize: 12),
          ),
          value: autoStartDerby,
          onChanged: onAutoStartDerbyChanged,
        ),
        const SizedBox(height: 16),

        // Derby Timer Settings
        const Text(
          'Derby Timer',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          'Time allowed for each user to pick their draft position',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Hours
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hours', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: derbyTimerHours,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(24, (i) => i)
                        .map((h) => DropdownMenuItem(
                              value: h,
                              child: Text(h.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onDerbyTimerHoursChanged(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Minutes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Minutes', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: derbyTimerMinutes,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(60, (i) => i)
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.toString().padLeft(2, '0')),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onDerbyTimerMinutesChanged(value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Seconds
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seconds', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: derbyTimerSeconds,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: [0, 15, 30, 45]
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.toString().padLeft(2, '0')),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onDerbyTimerSecondsChanged(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Derby countdown widget - shows time remaining until derby start
class DerbyCountdown extends StatefulWidget {
  final DateTime targetTime;

  const DerbyCountdown({super.key, required this.targetTime});

  @override
  State<DerbyCountdown> createState() => _DerbyCountdownState();
}

class _DerbyCountdownState extends State<DerbyCountdown> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateRemaining();
      }
    });
  }

  @override
  void didUpdateWidget(DerbyCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetTime != oldWidget.targetTime) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    setState(() {
      // Convert target time to local timezone before comparing with DateTime.now()
      _remaining = widget.targetTime.toLocal().difference(DateTime.now());
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Started ${_formatPositiveDuration(duration.abs())} ago';
    }
    return _formatPositiveDuration(duration);
  }

  String _formatPositiveDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days day${days != 1 ? 's' : ''}, ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  Color _getTextColor() {
    if (_remaining.isNegative) {
      return Colors.red;
    } else if (_remaining.inHours < 1) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _getTextColor(),
      ),
    );
  }
}
