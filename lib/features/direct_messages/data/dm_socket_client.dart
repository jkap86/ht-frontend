import '../../../core/services/socket/socket_service.dart';
import 'dtos/direct_message_dto.dart';

/// Direct message-specific WebSocket client
/// Handles DM conversation room management and message events
class DmSocketClient {
  final SocketService _socketService;
  final Map<String, void Function()> _messageListenerUnsubscribers = {};

  DmSocketClient(this._socketService);

  /// Join a DM conversation room
  void joinConversation(String conversationId) {
    if (!_socketService.isConnected) {
      throw Exception('Socket not connected');
    }
    print('[DmSocketClient] Joining DM conversation: $conversationId');
    _socketService.emit('join_dm', {'conversationId': conversationId});
  }

  /// Leave a DM conversation room
  void leaveConversation(String conversationId) {
    if (!_socketService.isConnected) {
      throw Exception('Socket not connected');
    }
    print('[DmSocketClient] Leaving DM conversation: $conversationId');

    // Unsubscribe from message listener if exists
    _messageListenerUnsubscribers[conversationId]?.call();
    _messageListenerUnsubscribers.remove(conversationId);

    _socketService.emit('leave_dm', {'conversationId': conversationId});
  }

  /// Listen for new direct messages
  /// Returns a function to stop listening
  void Function() onNewDirectMessage(void Function(DirectMessageDto) callback) {
    print('[DmSocketClient] Registering new_dm listener');

    return _socketService.on('new_dm', (data) {
      print('[DmSocketClient] Received new_dm event: $data');
      try {
        final messageDto = DirectMessageDto.fromJson(data as Map<String, dynamic>);
        print('[DmSocketClient] Parsed DM successfully, calling callback');
        callback(messageDto);
      } catch (e) {
        print('[DmSocketClient] Error parsing direct message: $e');
      }
    });
  }

  /// Remove listener for direct messages
  void offNewDirectMessage() {
    print('[DmSocketClient] Removing new_dm listener');
    _socketService.off('new_dm');
  }

  /// Clean up all listeners for a specific conversation
  void cleanup(String conversationId) {
    _messageListenerUnsubscribers[conversationId]?.call();
    _messageListenerUnsubscribers.remove(conversationId);
  }

  /// Clean up all listeners
  void cleanupAll() {
    for (final unsubscribe in _messageListenerUnsubscribers.values) {
      unsubscribe();
    }
    _messageListenerUnsubscribers.clear();
  }
}
