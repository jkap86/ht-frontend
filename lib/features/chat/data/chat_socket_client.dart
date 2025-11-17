import '../../../core/services/socket/socket_service.dart';
import '../domain/chat_message.dart';
import '../domain/chat_room.dart';

/// Shared socket client for both league and DM chat
class ChatSocketClient {
  final SocketService _socketService;

  ChatSocketClient(this._socketService);

  /// Join a chat room (league or DM)
  void joinRoom(String roomId, ChatRoomType type) {
    if (!_socketService.isConnected) {
      print('[ChatSocketClient] Socket not connected');
      return;
    }

    if (type == ChatRoomType.league) {
      print('[ChatSocketClient] Joining league chat: $roomId');
      _socketService.emit('join_league', {'leagueId': int.parse(roomId)});
    } else {
      print('[ChatSocketClient] Joining DM conversation: $roomId');
      _socketService.emit('join_dm', {'conversationId': roomId});
    }
  }

  /// Leave a chat room
  void leaveRoom(String roomId, ChatRoomType type) {
    if (!_socketService.isConnected) {
      return;
    }

    if (type == ChatRoomType.league) {
      print('[ChatSocketClient] Leaving league chat: $roomId');
      _socketService.emit('leave_league', {'leagueId': int.parse(roomId)});
    } else {
      print('[ChatSocketClient] Leaving DM conversation: $roomId');
      _socketService.emit('leave_dm', {'conversationId': roomId});
    }
  }

  /// Listen for league chat messages
  void Function() onLeagueMessage(void Function(ChatMessage) callback) {
    return _socketService.on('new_message', (data) {
      try {
        final message = ChatMessage.fromLeagueMessage(data as Map<String, dynamic>);
        callback(message);
      } catch (e) {
        print('[ChatSocketClient] Error parsing league message: $e');
      }
    });
  }

  /// Listen for direct messages
  void Function() onDirectMessage(void Function(ChatMessage) callback) {
    return _socketService.on('new_dm', (data) {
      try {
        final message = ChatMessage.fromDirectMessage(data as Map<String, dynamic>);
        callback(message);
      } catch (e) {
        print('[ChatSocketClient] Error parsing DM: $e');
      }
    });
  }

  /// Remove listeners
  void offLeagueMessage() {
    _socketService.off('new_message');
  }

  void offDirectMessage() {
    _socketService.off('new_dm');
  }
}
