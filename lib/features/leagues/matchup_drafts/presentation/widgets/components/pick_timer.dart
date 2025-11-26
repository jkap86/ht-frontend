import 'package:flutter/material.dart';

/// Timer widget for draft picks
class PickTimer extends StatefulWidget {
  final DateTime deadline;
  final bool isPaused;

  const PickTimer({
    super.key,
    required this.deadline,
    required this.isPaused,
  });

  @override
  State<PickTimer> createState() => _PickTimerState();
}

class _PickTimerState extends State<PickTimer> {
  late Stream<Duration> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();
        final diff = widget.deadline.difference(now);
        return diff.isNegative ? Duration.zero : diff;
      },
    ).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    // If paused, show frozen time
    if (widget.isPaused) {
      final now = DateTime.now();
      final duration = widget.deadline.difference(now);
      final frozenDuration = duration.isNegative ? Duration.zero : duration;
      final minutes = frozenDuration.inMinutes;
      final seconds = frozenDuration.inSeconds % 60;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.pause,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} (Paused)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    }

    // If active, show live countdown
    return StreamBuilder<Duration>(
      stream: _timerStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final duration = snapshot.data!;
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;

        return Text(
          'Time Remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: duration.inSeconds < 30 ? Colors.red : null,
                fontWeight:
                    duration.inSeconds < 30 ? FontWeight.bold : null,
              ),
        );
      },
    );
  }
}
