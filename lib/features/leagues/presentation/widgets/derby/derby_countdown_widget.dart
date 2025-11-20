import 'dart:async';
import 'package:flutter/material.dart';

/// Derby countdown widget - shows time remaining until a target time
class DerbyCountdownWidget extends StatefulWidget {
  final DateTime targetTime;
  final VoidCallback? onExpired;

  const DerbyCountdownWidget({
    super.key,
    required this.targetTime,
    this.onExpired,
  });

  @override
  State<DerbyCountdownWidget> createState() => _DerbyCountdownWidgetState();
}

class _DerbyCountdownWidgetState extends State<DerbyCountdownWidget> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateRemaining();

        // Call onExpired callback if time has expired
        if (_remaining.isNegative && widget.onExpired != null) {
          widget.onExpired!();
        }
      }
    });
  }

  @override
  void didUpdateWidget(DerbyCountdownWidget oldWidget) {
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
