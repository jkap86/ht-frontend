import 'package:flutter/material.dart';
import '../../../domain/draft.dart';

/// Draft status bar showing current round, pick, and timer
class DraftStatusBar extends StatelessWidget {
  final Draft draft;
  final int currentPick;
  final int currentRound;
  final DateTime? pickDeadline;
  final DateTime? pausedAtDeadline;
  final bool isAutopickEnabled;

  const DraftStatusBar({
    super.key,
    required this.draft,
    required this.currentPick,
    required this.currentRound,
    required this.pickDeadline,
    required this.pausedAtDeadline,
    this.isAutopickEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          Text(
            'Round $currentRound • Pick $currentPick',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (draft.status == 'in_progress' && pickDeadline != null)
            PickTimer(deadline: pickDeadline!, isPaused: false),
          if (draft.status == 'paused' && pausedAtDeadline != null)
            PickTimer(deadline: pausedAtDeadline!, isPaused: true),
          if (draft.status == 'completed')
            Text(
              'Draft Complete',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          // Autopick status indicator
          if (isAutopickEnabled && (draft.status == 'in_progress' || draft.status == 'paused'))
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.smart_toy,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Autopick Enabled',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Countdown timer widget for draft pick deadline
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
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    // Active timer
    return StreamBuilder<Duration>(
      stream: _timerStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final duration = snapshot.data!;
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;

        final isLowTime = duration.inSeconds <= 30;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer,
              size: 20,
              color: isLowTime ? Colors.red : null,
            ),
            const SizedBox(width: 8),
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isLowTime ? Colors.red : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
