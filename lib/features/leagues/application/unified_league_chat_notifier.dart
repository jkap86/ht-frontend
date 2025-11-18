import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/socket/socket_providers.dart';
import '../../chat/application/chat_providers.dart';

/// Adapter provider that wraps the unified ChatNotifier for league chat
/// This maintains backward compatibility with the LeagueChatState interface
/// while using the unified chat system underneath.
///
/// Usage: ref.watch(unifiedLeagueChatProvider(leagueId))
final unifiedLeagueChatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, int>(
  (ref, leagueId) {
    final socketService = ref.read(socketServiceProvider);

    final notifier = ChatNotifier(
      socketService: socketService,
      roomName: 'league_$leagueId',
      incomingEvent: 'league_chat_message',
      outgoingEvent: 'send_league_chat',
    );

    ref.onDispose(() {
      notifier.dispose();
    });

    return notifier;
  },
);
