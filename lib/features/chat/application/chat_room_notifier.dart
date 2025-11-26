import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_providers.dart';
import '../../../core/chat/chat_state.dart';
import '../../../core/chat/chat_provider_args.dart';

/// Simple model representing a chat room entry in the UI.
class ChatRoomEntry {
  final String roomName;
  final String displayName;
  final int unreadCount;
  final bool isJoined;

  const ChatRoomEntry({
    required this.roomName,
    required this.displayName,
    this.unreadCount = 0,
    this.isJoined = false,
  });

  ChatRoomEntry copyWith({
    String? roomName,
    String? displayName,
    int? unreadCount,
    bool? isJoined,
  }) {
    return ChatRoomEntry(
      roomName: roomName ?? this.roomName,
      displayName: displayName ?? this.displayName,
      unreadCount: unreadCount ?? this.unreadCount,
      isJoined: isJoined ?? this.isJoined,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoomEntry &&
        other.roomName == roomName &&
        other.displayName == displayName &&
        other.unreadCount == unreadCount &&
        other.isJoined == isJoined;
  }

  @override
  int get hashCode =>
      roomName.hashCode ^
      displayName.hashCode ^
      unreadCount.hashCode ^
      isJoined.hashCode;
}

/// State for chat rooms: list of rooms + which one is currently active.
class ChatRoomState {
  final List<ChatRoomEntry> rooms;
  final String? activeRoomName;

  const ChatRoomState({
    required this.rooms,
    required this.activeRoomName,
  });

  factory ChatRoomState.initial() => const ChatRoomState(
        rooms: [],
        activeRoomName: null,
      );

  ChatRoomState copyWith({
    List<ChatRoomEntry>? rooms,
    String? activeRoomName,
  }) {
    return ChatRoomState(
      rooms: rooms ?? this.rooms,
      activeRoomName: activeRoomName ?? this.activeRoomName,
    );
  }

  ChatRoomEntry? get activeRoom => rooms.cast<ChatRoomEntry?>().firstWhere(
        (r) => r?.roomName == activeRoomName,
        orElse: () => null,
      );
}

/// Notifier that manages available chat rooms and active selection.
///
/// This does NOT manage socket connections directly — that’s the job of
/// the [ChatNotifier] via [chatProvider]. This just tracks which room
/// is selected and some basic metadata like unread counts.
class ChatRoomNotifier extends StateNotifier<ChatRoomState> {
  ChatRoomNotifier() : super(ChatRoomState.initial());

  /// Initialize with a predefined list of rooms.
  ///
  /// Example:
  ///   [
  ///     ChatRoomEntry(roomName: 'global_chat', displayName: 'Global'),
  ///     ChatRoomEntry(roomName: 'announcements', displayName: 'Announcements'),
  ///   ]
  void setInitialRooms(List<ChatRoomEntry> rooms, {String? activeRoomName}) {
    state = ChatRoomState(
      rooms: rooms,
      activeRoomName:
          activeRoomName ?? (rooms.isNotEmpty ? rooms.first.roomName : null),
    );
  }

  /// Set the active/selected room by name.
  void selectRoom(String roomName) {
    if (!state.rooms.any((r) => r.roomName == roomName)) {
      return;
    }
    state = state.copyWith(activeRoomName: roomName);
  }

  /// Add a new room to the list (or replace if it already exists).
  void upsertRoom(ChatRoomEntry room) {
    final existingIndex =
        state.rooms.indexWhere((r) => r.roomName == room.roomName);

    final updatedRooms = List<ChatRoomEntry>.from(state.rooms);
    if (existingIndex == -1) {
      updatedRooms.add(room);
    } else {
      updatedRooms[existingIndex] = room;
    }

    state = state.copyWith(rooms: updatedRooms);
  }

  /// Update unread count for a room.
  void setUnreadCount(String roomName, int unreadCount) {
    final updatedRooms = state.rooms
        .map(
          (r) =>
              r.roomName == roomName ? r.copyWith(unreadCount: unreadCount) : r,
        )
        .toList();
    state = state.copyWith(rooms: updatedRooms);
  }

  /// Increment unread count for a room (e.g., when a new message arrives
  /// and that room is not active).
  void incrementUnread(String roomName) {
    final updatedRooms = state.rooms
        .map((r) => r.roomName == roomName
            ? r.copyWith(unreadCount: r.unreadCount + 1)
            : r)
        .toList();
    state = state.copyWith(rooms: updatedRooms);
  }

  /// Clear unread count for a room (e.g., when user visits the room).
  void clearUnread(String roomName) {
    setUnreadCount(roomName, 0);
  }
}

/// Provider for managing chat rooms and the currently active room.
final chatRoomProvider =
    StateNotifierProvider<ChatRoomNotifier, ChatRoomState>((ref) {
  return ChatRoomNotifier();
});

/// Convenience provider: the active ChatState for the selected room.
/// Returns null if there is no active room.
final activeRoomChatStateProvider = Provider<ChatState?>((ref) {
  final roomsState = ref.watch(chatRoomProvider);
  final activeRoomName = roomsState.activeRoomName;

  if (activeRoomName == null || activeRoomName.isEmpty) {
    return null;
  }

  // Use default event names for generic chat.
  final args = ChatProviderArgs(roomName: activeRoomName);
  return ref.watch(chatProvider(args));
});
