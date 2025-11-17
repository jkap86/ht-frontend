import '../../../core/services/socket/socket_service.dart';
import 'dtos/chat_message_dto.dart';

/// League-specific WebSocket client
/// Handles league chat room management and message events
class LeagueSocketClient {
  final SocketService _socketService;
  final Map<int, void Function()> _messageListenerUnsubscribers = {};

  LeagueSocketClient(this._socketService);

  /// Join a league chat room
  void joinLeague(int leagueId) {
    if (!_socketService.isConnected) {
      throw Exception('Socket not connected');
    }
    print('[LeagueSocketClient] Joining league room: $leagueId');
    _socketService.emit('join_league', {'leagueId': leagueId});
  }

  /// Leave a league chat room
  void leaveLeague(int leagueId) {
    if (!_socketService.isConnected) {
      throw Exception('Socket not connected');
    }
    print('[LeagueSocketClient] Leaving league room: $leagueId');

    // Unsubscribe from message listener if exists
    _messageListenerUnsubscribers[leagueId]?.call();
    _messageListenerUnsubscribers.remove(leagueId);

    _socketService.emit('leave_league', {'leagueId': leagueId});
  }

  /// Listen for new chat messages
  /// Returns a function to stop listening
  void Function() onNewMessage(void Function(ChatMessageDto) callback) {
    print('[LeagueSocketClient] Registering new_message listener');

    return _socketService.on('new_message', (data) {
      print('[LeagueSocketClient] Received new_message event: $data');
      try {
        final messageDto = ChatMessageDto.fromJson(data as Map<String, dynamic>);
        print('[LeagueSocketClient] Parsed message successfully, calling callback');
        callback(messageDto);
      } catch (e) {
        print('[LeagueSocketClient] Error parsing chat message: $e');
      }
    });
  }

  /// Remove listener for new messages
  void offNewMessage() {
    print('[LeagueSocketClient] Removing new_message listener');
    _socketService.off('new_message');
  }

  /// Clean up all listeners for a specific league
  void cleanup(int leagueId) {
    _messageListenerUnsubscribers[leagueId]?.call();
    _messageListenerUnsubscribers.remove(leagueId);
  }

  /// Clean up all listeners
  void cleanupAll() {
    for (final unsubscribe in _messageListenerUnsubscribers.values) {
      unsubscribe();
    }
    _messageListenerUnsubscribers.clear();
  }
}
