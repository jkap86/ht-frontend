import 'dart:async';
import 'package:flutter/foundation.dart';

/// Controller for managing countdown timer logic
class CountdownController extends ChangeNotifier {
  final int durationSeconds;
  final VoidCallback? onComplete;
  final Function(int remainingSeconds)? onTick;

  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;
  bool _isPaused = false;

  CountdownController({
    required this.durationSeconds,
    this.onComplete,
    this.onTick,
  }) : _remainingSeconds = durationSeconds;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isComplete => _remainingSeconds <= 0;
  double get progress => _remainingSeconds / durationSeconds;

  /// Start the timer
  void start() {
    if (_isRunning || _isPaused) return;

    _isRunning = true;
    _remainingSeconds = durationSeconds;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick?.call(_remainingSeconds);
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        onComplete?.call();
        notifyListeners();
      }
    });
  }

  /// Pause the timer
  void pause() {
    if (!_isRunning) return;
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  /// Resume the timer
  void resume() {
    if (!_isPaused) return;

    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick?.call(_remainingSeconds);
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        onComplete?.call();
        notifyListeners();
      }
    });
  }

  /// Reset the timer to initial duration
  void reset() {
    _timer?.cancel();
    _remainingSeconds = durationSeconds;
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  /// Stop the timer
  void stop() {
    _timer?.cancel();
    _remainingSeconds = 0;
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  /// Add time to the timer
  void addTime(int seconds) {
    _remainingSeconds += seconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
