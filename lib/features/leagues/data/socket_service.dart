import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../main.dart';
import '../../auth/data/auth_token_storage.dart';
import 'dtos/chat_message_dto.dart';

/// WebSocket service for real-time league chat updates
class SocketService {
  IO.Socket? _socket;
  final AuthTokenStorage _storage;
  final String _baseUrl = appConfig.apiBaseUrl;
  final Set<int> _joinedLeagues = {};

  SocketService({AuthTokenStorage? storage})
      : _storage = storage ?? AuthTokenStorage();

  /// Connect to the WebSocket server with authentication
  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      return; // Already connected
    }

    final token = await _storage.readToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    _socket = IO.io(
      _baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      print('[SocketService] WebSocket connected successfully');
      // Rejoin all previously joined leagues
      for (final leagueId in _joinedLeagues) {
        print('[SocketService] Rejoining league room: $leagueId');
        _socket!.emit('join_league', {'leagueId': leagueId});
      }
    });

    _socket!.onDisconnect((_) {
      print('[SocketService] WebSocket disconnected');
    });

    _socket!.onConnectError((error) {
      print('[SocketService] WebSocket connection error: $error');
    });

    _socket!.onError((error) {
      print('[SocketService] WebSocket error: $error');
    });
  }

  /// Disconnect from the WebSocket server
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  /// Join a league chat room
  void joinLeague(int leagueId) {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }
    print('[SocketService] Joining league room: $leagueId');
    _joinedLeagues.add(leagueId);
    _socket!.emit('join_league', {'leagueId': leagueId});
  }

  /// Leave a league chat room
  void leaveLeague(int leagueId) {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }
    _socket!.emit('leave_league', {'leagueId': leagueId});
  }

  /// Listen for new chat messages
  /// Clears any existing listeners first to prevent duplicates
  void onNewMessage(void Function(ChatMessageDto) callback) {
    if (_socket == null) {
      throw Exception('Socket not initialized');
    }
    // Remove any existing listeners first
    _socket!.off('new_message');
    // Add the new listener
    _socket!.on('new_message', (data) {
      print('[SocketService] Received new_message event: $data');
      try {
        final messageDto = ChatMessageDto.fromJson(data as Map<String, dynamic>);
        print('[SocketService] Parsed message successfully, calling callback');
        callback(messageDto);
      } catch (e) {
        print('[SocketService] Error parsing chat message: $e');
      }
    });
  }

  /// Remove listener for new messages
  void offNewMessage() {
    _socket?.off('new_message');
  }

  /// Check if the socket is connected
  bool get isConnected => _socket?.connected ?? false;
}
