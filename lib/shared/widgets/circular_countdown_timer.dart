import 'package:flutter/material.dart';
import 'countdown_controller.dart';

/// Circular countdown timer widget with visual ring
class CircularCountdownTimer extends StatelessWidget {
  final CountdownController controller;
  final double size;
  final double strokeWidth;
  final Color? ringColor;
  final Color? backgroundColor;
  final Color? textColor;

  const CircularCountdownTimer({
    super.key,
    required this.controller,
    this.size = 100,
    this.strokeWidth = 8,
    this.ringColor,
    this.backgroundColor,
    this.textColor,
  });

  String _formatTime(int remainingSeconds) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getRingColor(int remainingSeconds) {
    if (ringColor != null) return ringColor!;

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
        final displayRingColor = _getRingColor(controller.remainingSeconds);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    backgroundColor ?? Colors.grey.shade300,
                  ),
                ),
              ),
              // Progress circle
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: controller.progress,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(displayRingColor),
                ),
              ),
              // Timer text
              Text(
                _formatTime(controller.remainingSeconds),
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? displayRingColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
