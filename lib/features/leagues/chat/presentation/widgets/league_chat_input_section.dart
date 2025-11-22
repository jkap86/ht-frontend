import 'package:flutter/material.dart';
import '../../../../chat/presentation/widgets/chat_input_bar.dart';
import '../../../../chat/presentation/widgets/chat_error_banner.dart';

/// Input section for league chat with error banner
class LeagueChatInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  final String? errorMessage;

  const LeagueChatInputSection({
    super.key,
    required this.controller,
    required this.onSend,
    required this.enabled,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatErrorBanner(errorMessage: errorMessage),
        ChatInputBar(
          controller: controller,
          onSend: onSend,
          enabled: enabled,
        ),
      ],
    );
  }
}
