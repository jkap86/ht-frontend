import 'package:flutter/material.dart';

/// A reusable error banner widget for chat screens.
///
/// Displays error messages in a consistent, non-intrusive banner.
class ChatErrorBanner extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onDismiss;

  const ChatErrorBanner({
    super.key,
    required this.errorMessage,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: Colors.red.withOpacity(0.08),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Colors.red),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              errorMessage ?? 'Unknown error',
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 16, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}
