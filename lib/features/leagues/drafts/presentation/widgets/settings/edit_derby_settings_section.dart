import 'dart:async';
import 'package:flutter/material.dart';

/// Derby-specific settings section
class EditDerbySettingsSection extends StatelessWidget {
  final int derbyTimerHours;
  final int derbyTimerMinutes;
  final int derbyTimerSeconds;
  final String derbyOnTimeout;
  final DateTime? derbyStartTime;
  final bool autoStartDerby;
  final bool isCommissioner;
  final Function(int) onDerbyTimerHoursChanged;
  final Function(int) onDerbyTimerMinutesChanged;
  final Function(int) onDerbyTimerSecondsChanged;
  final Function(String) onDerbyOnTimeoutChanged;
  final Function(DateTime?) onDerbyStartTimeChanged;
  final Function(bool) onAutoStartDerbyChanged;

  const EditDerbySettingsSection({
    super.key,
    required this.derbyTimerHours,
    required this.derbyTimerMinutes,
    required this.derbyTimerSeconds,
    required this.derbyOnTimeout,
    required this.derbyStartTime,
    required this.autoStartDerby,
    required this.isCommissioner,
    required this.onDerbyTimerHoursChanged,
    required this.onDerbyTimerMinutesChanged,
    required this.onDerbyTimerSecondsChanged,
    required this.onDerbyOnTimeoutChanged,
    required this.onDerbyStartTimeChanged,
    required this.onAutoStartDerbyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),

        // Derby Timer
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Derby Timer',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: derbyTimerHours.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: isCommissioner,
                    onChanged: (value) {
                      final hours = int.tryParse(value) ?? 0;
                      onDerbyTimerHoursChanged(hours);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: derbyTimerMinutes.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: isCommissioner,
                    onChanged: (value) {
                      final minutes = int.tryParse(value) ?? 0;
                      onDerbyTimerMinutesChanged(minutes);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: derbyTimerSeconds.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: isCommissioner,
                    onChanged: (value) {
                      final seconds = int.tryParse(value) ?? 0;
                      onDerbyTimerSecondsChanged(seconds);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // On Timeout
        DropdownButtonFormField<String>(
          value: derbyOnTimeout,
          decoration: const InputDecoration(
            labelText: 'On Timeout',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'skip', child: Text('Skip')),
            DropdownMenuItem(value: 'auto', child: Text('Auto')),
          ],
          onChanged: isCommissioner
              ? (value) {
                  if (value != null) onDerbyOnTimeoutChanged(value);
                }
              : null,
        ),

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
                  onPressed:
                      isCommissioner ? () => onDerbyStartTimeChanged(null) : null,
                  tooltip: 'Clear',
                ),
              FilledButton.tonalIcon(
                onPressed: isCommissioner
                    ? () async {
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
                      }
                    : null,
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
          onChanged: isCommissioner ? onAutoStartDerbyChanged : null,
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
