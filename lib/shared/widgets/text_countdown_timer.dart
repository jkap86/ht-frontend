import 'package:flutter/material.dart';
import 'countdown_controller.dart';

/// Text-based countdown timer widget
class TextCountdownTimer extends StatelessWidget {
  final CountdownController controller;
  final bool compact;
  final Color? textColor;
  final double? fontSize;
  final bool showProgress;
  final Color? progressColor;

  const TextCountdownTimer({
    super.key,
    required this.controller,
    this.compact = false,
    this.textColor,
    this.fontSize,
    this.showProgress = false,
    this.progressColor,
  });

  String _formatTime(int remainingSeconds) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    if (compact) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      if (minutes > 0) {
        return '$minutes min ${seconds}s';
      } else {
        return '${seconds}s';
      }
    }
  }

  Color _getTimerColor(int remainingSeconds) {
    if (textColor != null) return textColor!;

    // Change color based on urgency
    if (remainingSeconds <= 10) {
      return Colors.red;
    } else if (remainingSeconds <= 30) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final timerColor = _getTimerColor(controller.remainingSeconds);

        if (showProgress) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(controller.remainingSeconds),
                style: TextStyle(
                  fontSize: fontSize ?? 24,
                  fontWeight: FontWeight.bold,
                  color: timerColor,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: controller.progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? timerColor,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          );
        }

        return Text(
          _formatTime(controller.remainingSeconds),
          style: TextStyle(
            fontSize: fontSize ?? 24,
            fontWeight: FontWeight.bold,
            color: timerColor,
          ),
        );
      },
    );
  }
}
