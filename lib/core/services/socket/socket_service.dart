import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../features/auth/data/auth_storage.dart';

/// Base WebSocket service for managing Socket.IO connection
/// Provides low-level connection management and room operations
/// Feature-specific clients should wrap this service
class SocketService {
  IO.Socket? _socket;
  final AuthStorage _storage;
  final String _baseUrl;
  final Map<String, _RoomJoinInfo> _joinedRooms = {};

  SocketService({required AuthStorage storage, required String baseUrl})
      : _storage = storage,
        _baseUrl = baseUrl;

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
      // Rejoin all previously joined rooms
      for (final entry in _joinedRooms.entries) {
        print('[SocketService] Rejoining room: ${entry.key}');
        _socket!.emit(entry.value.event, entry.value.data);
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
    _joinedRooms.clear();
  }

  /// Join a room (generic room joining)
  void joinRoom(String roomName, Map<String, dynamic> data) {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }
    print('[SocketService] Joining room: $roomName');
    _joinedRooms[roomName] = _RoomJoinInfo(event: roomName, data: data);
    _socket!.emit(roomName, data);
  }

  /// Safe join room - returns true if successful, false otherwise
  bool tryJoinRoom(String event, Map<String, dynamic> data, String roomKey) {
    if (_socket == null || !_socket!.connected) {
      print('[SocketService] Cannot join room $roomKey: socket not connected');
      return false;
    }
    print('[SocketService] Joining room: $roomKey');
    _joinedRooms[roomKey] = _RoomJoinInfo(event: event, data: data);
    _socket!.emit(event, data);
    return true;
  }

  /// Leave a room
  void leaveRoom(String eventName, Map<String, dynamic> data) {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }
    _socket!.emit(eventName, data);
  }

  /// Safe leave room - returns true if successful, false otherwise
  bool tryLeaveRoom(String event, Map<String, dynamic> data, String roomKey) {
    if (_socket == null || !_socket!.connected) {
      print('[SocketService] Cannot leave room $roomKey: socket not connected');
      return false;
    }
    print('[SocketService] Leaving room: $roomKey');
    _joinedRooms.remove(roomKey);
    _socket!.emit(event, data);
    return true;
  }

  /// Register an event listener
  /// Returns a function to unregister the listener
  void Function() on(String event, void Function(dynamic) callback) {
    if (_socket == null) {
      throw Exception('Socket not initialized');
    }

    // Remove any existing listeners first to prevent duplicates
    _socket!.off(event);

    // Add the new listener
    _socket!.on(event, callback);

    // Return a function to remove this listener
    return () => _socket?.off(event);
  }

  /// Remove listener for an event
  void off(String event) {
    _socket?.off(event);
  }

  /// Emit an event to the server
  void emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      throw Exception('Socket not connected');
    }
    _socket!.emit(event, data);
  }

  /// Safe emit - returns true if successful, false otherwise
  bool tryEmit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      print('[SocketService] Cannot emit $event: socket not connected');
      return false;
    }
    _socket!.emit(event, data);
    return true;
  }

  /// Check if the socket is connected
  bool get isConnected => _socket?.connected ?? false;

  /// Get the underlying socket instance (for advanced use cases)
  IO.Socket? get socket => _socket;
}

/// Internal class to track room join information for reconnection
class _RoomJoinInfo {
  final String event;
  final Map<String, dynamic> data;

  _RoomJoinInfo({required this.event, required this.data});
}
