import 'dart:async';
import 'package:flutter/material.dart';

/// Reusable countdown timer widget
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
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    if (widget.autoStart && !widget.isPaused) {
      start();
    }
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle pause/resume
    if (widget.isPaused && !oldWidget.isPaused) {
      pause();
    } else if (!widget.isPaused && oldWidget.isPaused && _isRunning) {
      resume();
    }

    // Handle duration changes
    if (widget.durationSeconds != oldWidget.durationSeconds && !_isRunning) {
      setState(() {
        _remainingSeconds = widget.durationSeconds;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Start the timer
  void start() {
    if (_isRunning || widget.isPaused) return;

    setState(() {
      _isRunning = true;
      _remainingSeconds = widget.durationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onTick?.call(_remainingSeconds);
        } else {
          _timer?.cancel();
          _isRunning = false;
          widget.onComplete?.call();
        }
      });
    });
  }

  /// Pause the timer
  void pause() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  /// Resume the timer
  void resume() {
    if (_isRunning || widget.isPaused) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onTick?.call(_remainingSeconds);
        } else {
          _timer?.cancel();
          _isRunning = false;
          widget.onComplete?.call();
        }
      });
    });
  }

  /// Reset the timer to initial duration
  void reset() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.durationSeconds;
      _isRunning = false;
    });
  }

  /// Stop the timer
  void stop() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _isRunning = false;
    });
  }

  /// Add time to the timer
  void addTime(int seconds) {
    setState(() {
      _remainingSeconds += seconds;
    });
  }

  /// Get remaining seconds
  int get remainingSeconds => _remainingSeconds;

  /// Check if timer is running
  bool get isRunning => _isRunning;

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    if (widget.compact) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      if (minutes > 0) {
        return '$minutes min ${seconds}s';
      } else {
        return '${seconds}s';
      }
    }
  }

  Color _getTimerColor() {
    if (widget.textColor != null) return widget.textColor!;

    // Change color based on urgency
    if (_remainingSeconds <= 10) {
      return Colors.red;
    } else if (_remainingSeconds <= 30) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingSeconds / widget.durationSeconds;
    final timerColor = _getTimerColor();

    if (widget.showProgress) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(),
            style: TextStyle(
              fontSize: widget.fontSize ?? 24,
              fontWeight: FontWeight.bold,
              color: timerColor,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? timerColor,
              ),
              minHeight: 8,
            ),
          ),
        ],
      );
    }

    return Text(
      _formatTime(),
      style: TextStyle(
        fontSize: widget.fontSize ?? 24,
        fontWeight: FontWeight.bold,
        color: timerColor,
      ),
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
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    if (widget.autoStart && !widget.isPaused) {
      start();
    }
  }

  @override
  void didUpdateWidget(CircularCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPaused && !oldWidget.isPaused) {
      pause();
    } else if (!widget.isPaused && oldWidget.isPaused && _isRunning) {
      resume();
    }

    if (widget.durationSeconds != oldWidget.durationSeconds && !_isRunning) {
      setState(() {
        _remainingSeconds = widget.durationSeconds;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (_isRunning || widget.isPaused) return;

    setState(() {
      _isRunning = true;
      _remainingSeconds = widget.durationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onTick?.call(_remainingSeconds);
        } else {
          _timer?.cancel();
          _isRunning = false;
          widget.onComplete?.call();
        }
      });
    });
  }

  void pause() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void resume() {
    if (_isRunning || widget.isPaused) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.isPaused) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onTick?.call(_remainingSeconds);
        } else {
          _timer?.cancel();
          _isRunning = false;
          widget.onComplete?.call();
        }
      });
    });
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.durationSeconds;
      _isRunning = false;
    });
  }

  void stop() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _isRunning = false;
    });
  }

  void addTime(int seconds) {
    setState(() {
      _remainingSeconds += seconds;
    });
  }

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  String _formatTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getRingColor() {
    if (widget.ringColor != null) return widget.ringColor!;

    if (_remainingSeconds <= 10) {
      return Colors.red;
    } else if (_remainingSeconds <= 30) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingSeconds / widget.durationSeconds;
    final ringColor = _getRingColor();

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: widget.strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.backgroundColor ?? Colors.grey.shade300,
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: widget.strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            ),
          ),
          // Timer text
          Text(
            _formatTime(),
            style: TextStyle(
              fontSize: widget.size * 0.25,
              fontWeight: FontWeight.bold,
              color: widget.textColor ?? ringColor,
            ),
          ),
        ],
      ),
    );
  }
}
