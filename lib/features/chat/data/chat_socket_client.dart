import '../../../core/services/socket/socket_service.dart';
import '../domain/chat_message.dart';
import '../domain/chat_room.dart';

/// Shared socket client for both league and DM chat
class ChatSocketClient {
  final SocketService _socketService;

  ChatSocketClient(this._socketService);

  /// Join a chat room (league or DM)
  void joinRoom(String roomId, ChatRoomType type) {
    bool success;
    if (type == ChatRoomType.league) {
      print('[ChatSocketClient] Joining league chat: $roomId');
      success = _socketService.tryJoinRoom(
        'join_league',
        {'leagueId': int.parse(roomId)},
        'league_$roomId',
      );
    } else {
      print('[ChatSocketClient] Joining DM conversation: $roomId');
      success = _socketService.tryJoinRoom(
        'join_dm',
        {'conversationId': roomId},
        'dm_$roomId',
      );
    }

    if (!success) {
      print('[ChatSocketClient] Failed to join room $roomId (socket not connected)');
    }
  }

  /// Leave a chat room
  void leaveRoom(String roomId, ChatRoomType type) {
    bool success;
    if (type == ChatRoomType.league) {
      print('[ChatSocketClient] Leaving league chat: $roomId');
      success = _socketService.tryLeaveRoom(
        'leave_league',
        {'leagueId': int.parse(roomId)},
        'league_$roomId',
      );
    } else {
      print('[ChatSocketClient] Leaving DM conversation: $roomId');
      success = _socketService.tryLeaveRoom(
        'leave_dm',
        {'conversationId': roomId},
        'dm_$roomId',
      );
    }

    if (!success) {
      print('[ChatSocketClient] Failed to leave room $roomId (socket not connected)');
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
