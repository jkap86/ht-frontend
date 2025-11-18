import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../features/auth/data/auth_storage.dart';

/// Base WebSocket service for managing Socket.IO connection.
/// Provides low-level connection management and room operations.
/// Feature-specific clients should wrap this service.
class SocketService {
  IO.Socket? _socket;
  final AuthStorage _storage;
  final String _baseUrl;
  final Set<String> _joinedRooms = {};

  SocketService({
    required AuthStorage storage,
    required String baseUrl,
  })  : _storage = storage,
        _baseUrl = baseUrl;

  /// Connect to the WebSocket server with authentication.
  Future<bool> connect() async {
    // Already connected
    if (_socket != null && _socket!.connected) {
      return true;
    }

    final token = await _storage.readToken();
    if (token == null) {
      print('[SocketService] No auth token found, skipping socket connect');
      return false;
    }

    // Clean up previous socket instance (if any)
    _socket?.dispose();

    _socket = IO.io(
      _baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.onConnect((_) {
      print('[SocketService] Connected to $_baseUrl');

      // Rejoin all previously joined rooms
      for (final room in _joinedRooms) {
        print('[SocketService] Rejoining room: $room');
        _emitJoinRoom(room);
      }
    });

    _socket!.onDisconnect((_) {
      print('[SocketService] Disconnected from $_baseUrl');
    });

    _socket!.onConnectError((error) {
      print('[SocketService] Connect error: $error');
    });

    _socket!.onError((error) {
      print('[SocketService] Socket error: $error');
    });

    return true;
  }

  /// Internal low-level join-room emit (does NOT track or guard).
  void _emitJoinRoom(String roomName, [Map<String, dynamic>? data]) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('join_room', {
      'room': roomName,
      if (data != null) ...data,
    });
  }

  /// Join a room safely and remember it.
  Future<bool> joinRoom(
    String roomName, {
    Map<String, dynamic>? data,
  }) async {
    final connected = await connect();
    if (!connected || _socket == null || !_socket!.connected) {
      print('[SocketService] joinRoom failed, socket not connected');
      _joinedRooms.add(roomName); // still track it
      return false;
    }

    _joinedRooms.add(roomName);
    _emitJoinRoom(roomName, data);
    return true;
  }

  /// Leave a room safely and forget it.
  bool leaveRoom(
    String roomName, {
    Map<String, dynamic>? data,
  }) {
    if (_socket == null || !_socket!.connected) {
      print('[SocketService] leaveRoom called when socket not connected');
      _joinedRooms.remove(roomName);
      return false;
    }

    _joinedRooms.remove(roomName);
    _socket!.emit('leave_room', {
      'room': roomName,
      if (data != null) ...data,
    });

    return true;
  }

  /// Safe emit: returns false instead of throwing.
  bool tryEmit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      print('[SocketService] tryEmit($event) dropped, socket not connected');
      return false;
    }
    _socket!.emit(event, data);
    return true;
  }

  /// Attach a listener for a socket event.
  /// Returns a void-callback to remove the listener.
  VoidCallback? on(
    String event,
    void Function(dynamic) callback,
  ) {
    if (_socket == null) {
      print('[SocketService] on($event) called before connect');
      return null;
    }

    // Prevent duplicate handlers
    _socket!.off(event);
    _socket!.on(event, callback);

    return () => _socket?.off(event);
  }

  /// Remove a specific listener for an event.
  void off(String event) {
    _socket?.off(event);
  }

  /// Disconnect entirely and clear state.
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _joinedRooms.clear();
  }

  /// Whether currently connected.
  bool get isConnected => _socket?.connected ?? false;

  /// Raw Socket.IO instance (advanced use only).
  IO.Socket? get rawSocket => _socket;
}

typedef VoidCallback = void Function();
