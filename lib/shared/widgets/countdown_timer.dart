import 'package:flutter/material.dart';
import 'countdown_controller.dart';
import 'text_countdown_timer.dart' as text;
import 'circular_countdown_timer.dart' as circular;

// Re-export for convenience
export 'countdown_controller.dart';
export 'text_countdown_timer.dart';
export 'circular_countdown_timer.dart';

/// Reusable countdown timer widget (backward compatible wrapper)
/// Can be used for draft picks, auction bids, or any timed events
class CountdownTimer extends StatefulWidget {
  /// Duration of the timer in seconds
  final int durationSeconds;

  /// Callback when timer completes
  final VoidCallback? onComplete;

  /// Callback on each tick with remaining seconds
  final Function(int remainingSeconds)? onTick;

  /// Whether to start the timer automatically
  final bool autoStart;

  /// Whether to show the timer in a compact format (MM:SS vs detailed)
  final bool compact;

  /// Custom color for the timer text
  final Color? textColor;

  /// Custom font size
  final double? fontSize;

  /// Whether to show a progress indicator
  final bool showProgress;

  /// Color for the progress indicator
  final Color? progressColor;

  /// Whether the timer should be paused
  final bool isPaused;

  const CountdownTimer({
    super.key,
    required this.durationSeconds,
    this.onComplete,
    this.onTick,
    this.autoStart = true,
    this.compact = false,
    this.textColor,
    this.fontSize,
    this.showProgress = false,
    this.progressColor,
    this.isPaused = false,
  });

  @override
  State<CountdownTimer> createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late CountdownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CountdownController(
      durationSeconds: widget.durationSeconds,
      onComplete: widget.onComplete,
      onTick: widget.onTick,
    );
    if (widget.autoStart && !widget.isPaused) {
      _controller.start();
    }
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle pause/resume
    if (widget.isPaused && !oldWidget.isPaused) {
      _controller.pause();
    } else if (!widget.isPaused && oldWidget.isPaused && _controller.isRunning) {
      _controller.resume();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Start the timer
  void start() => _controller.start();

  /// Pause the timer
  void pause() => _controller.pause();

  /// Resume the timer
  void resume() => _controller.resume();

  /// Reset the timer to initial duration
  void reset() => _controller.reset();

  /// Stop the timer
  void stop() => _controller.stop();

  /// Add time to the timer
  void addTime(int seconds) => _controller.addTime(seconds);

  /// Get remaining seconds
  int get remainingSeconds => _controller.remainingSeconds;

  /// Check if timer is running
  bool get isRunning => _controller.isRunning;

  @override
  Widget build(BuildContext context) {
    return text.TextCountdownTimer(
      controller: _controller,
      compact: widget.compact,
      textColor: widget.textColor,
      fontSize: widget.fontSize,
      showProgress: widget.showProgress,
      progressColor: widget.progressColor,
    );
  }
}

/// Circular countdown timer widget with visual ring
class CircularCountdownTimer extends StatefulWidget {
  /// Duration of the timer in seconds
  final int durationSeconds;

  /// Callback when timer completes
  final VoidCallback? onComplete;

  /// Callback on each tick
  final Function(int remainingSeconds)? onTick;

  /// Whether to start automatically
  final bool autoStart;

  /// Size of the circular timer
  final double size;

  /// Thickness of the ring
  final double strokeWidth;

  /// Color of the progress ring
  final Color? ringColor;

  /// Background color of the ring
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Whether the timer is paused
  final bool isPaused;

  const CircularCountdownTimer({
    super.key,
    required this.durationSeconds,
    this.onComplete,
    this.onTick,
    this.autoStart = true,
    this.size = 100,
    this.strokeWidth = 8,
    this.ringColor,
    this.backgroundColor,
    this.textColor,
    this.isPaused = false,
  });

  @override
  State<CircularCountdownTimer> createState() => CircularCountdownTimerState();
}

class CircularCountdownTimerState extends State<CircularCountdownTimer> {
  late CountdownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CountdownController(
      durationSeconds: widget.durationSeconds,
      onComplete: widget.onComplete,
      onTick: widget.onTick,
    );
    if (widget.autoStart && !widget.isPaused) {
      _controller.start();
    }
  }

  @override
  void didUpdateWidget(CircularCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPaused && !oldWidget.isPaused) {
      _controller.pause();
    } else if (!widget.isPaused && oldWidget.isPaused && _controller.isRunning) {
      _controller.resume();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() => _controller.start();
  void pause() => _controller.pause();
  void resume() => _controller.resume();
  void reset() => _controller.reset();
  void stop() => _controller.stop();
  void addTime(int seconds) => _controller.addTime(seconds);

  int get remainingSeconds => _controller.remainingSeconds;
  bool get isRunning => _controller.isRunning;

  @override
  Widget build(BuildContext context) {
    return circular.CircularCountdownTimer(
      controller: _controller,
      size: widget.size,
      strokeWidth: widget.strokeWidth,
      ringColor: widget.ringColor,
      backgroundColor: widget.backgroundColor,
      textColor: widget.textColor,
    );
  }
}
