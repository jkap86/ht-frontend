import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'token_provider.dart';

/// Base WebSocket service for managing Socket.IO connection.
/// Provides low-level connection management and room operations.
/// Feature-specific clients should wrap this service.
class SocketService {
  IO.Socket? _socket;
  final TokenProvider _tokenProvider;
  final String _baseUrl;
  final Set<String> _joinedRooms = {};

  SocketService({
    required TokenProvider tokenProvider,
    required String baseUrl,
  })  : _tokenProvider = tokenProvider,
        _baseUrl = baseUrl;

  /// Connect to the WebSocket server with authentication.
  Future<bool> connect() async {
    // Already connected
    if (_socket != null && _socket!.connected) {
      return true;
    }

    final token = await _tokenProvider.readToken();
    if (token == null) {
      return false;
    }

    // We'll resolve this when the socket actually connects or fails.
    final completer = Completer<bool>();

    // Clean up previous socket instance (if any)
    _socket?.dispose();

    _socket = IO.io(
      _baseUrl,
      IO.OptionBuilder().enableAutoConnect().setAuth({'token': token}).build(),
    );

    _socket!.onConnect((_) {
      // Rejoin all previously joined rooms
      for (final room in _joinedRooms) {
        _emitJoinRoom(room);
      }

      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });

    _socket!.onDisconnect((_) {});

    _socket!.onConnectError((error) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    _socket!.onError((error) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    // Wait until we actually connect or fail.
    return completer.future;
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
  ///
  /// This will:
  /// - ensure a socket instance exists (via [connect])
  /// - track the room in [_joinedRooms]
  /// - attempt to emit the join immediately if a socket is present
  ///
  /// Even if the socket is still handshaking, the emit may be buffered,
  /// and the onConnect callback will also re-emit joins for all
  /// rooms in [_joinedRooms].
  Future<bool> joinRoom(
    String roomName, {
    Map<String, dynamic>? data,
  }) async {
    // Ensure a socket exists and is configured
    final connected = await connect();

    if (!connected || _socket == null) {
      // Still track desired room so onConnect can re-join it later
      _joinedRooms.add(roomName);
      return false;
    }

    // Track the room and emit join. If the underlying socket_io_client
    // isn't fully connected yet, the emit will be buffered, and your
    // onConnect handler will re-emit based on _joinedRooms.
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
