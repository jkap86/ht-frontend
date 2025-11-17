import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_notifier.dart';
import '../../../auth/domain/user.dart';
import '../../../chat/application/chat_room_notifier.dart';
import '../../../chat/domain/chat_room.dart';
import '../../../chat/presentation/widgets/chat_message_tile.dart';
import '../../../direct_messages/application/dm_provider.dart';

/// View states for the DM chat widget
enum _DmViewState {
  userSelection,
  conversationList,
  conversation,
}

/// Widget displaying DM conversations and messages
class DmChatContent extends ConsumerStatefulWidget {
  final double opacity;
  final VoidCallback onClose;

  const DmChatContent({
    super.key,
    required this.opacity,
    required this.onClose,
  });

  @override
  ConsumerState<DmChatContent> createState() => _DmChatContentState();
}

class _DmChatContentState extends ConsumerState<DmChatContent> {
  // DM view state
  _DmViewState _viewState = _DmViewState.userSelection;
  String? _selectedUserId;
  String? _selectedUsername;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<User> _searchResults = [];
  bool _isSearching = false;
  String _searchError = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous debounce timer
    _debounce?.cancel();

    final query = _searchController.text.trim();

    // If query is empty, clear search results immediately
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _searchError = '';
      });
      return;
    }

    // Set searching state
    setState(() {
      _isSearching = true;
      _searchError = '';
    });

    // Debounce the search by 300ms
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final results = await authRepo.searchUsers(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
          _searchError = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
          _searchError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // When viewing a conversation, show it full screen without our wrapper header
    if (_viewState == _DmViewState.conversation) {
      return Opacity(
        opacity: widget.opacity,
        child: Column(
          children: [
            // Minimal header with drag handle and close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.drag_handle),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            _viewState = _DmViewState.userSelection;
                            _selectedUserId = null;
                            _selectedUsername = null;
                          });
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        child: Text(
                          _selectedUsername!.isNotEmpty
                              ? _selectedUsername![0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedUsername!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Show only messages and input (skip DmConversationView's header)
            Expanded(
              child: _buildConversationMessages(),
            ),
          ],
        ),
      );
    }

    // When viewing conversation list or user selection
    return Opacity(
      opacity: widget.opacity,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.drag_handle),
                    const SizedBox(width: 8),
                    Text(
                      _viewState == _DmViewState.userSelection
                          ? 'New Message'
                          : 'Direct Messages',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_viewState == _DmViewState.conversationList)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'New Message',
                        onPressed: () {
                          setState(() {
                            _viewState = _DmViewState.userSelection;
                          });
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    if (_viewState == _DmViewState.userSelection)
                      IconButton(
                        icon: const Icon(Icons.chat),
                        tooltip: 'Conversations',
                        onPressed: () {
                          setState(() {
                            _viewState = _DmViewState.conversationList;
                          });
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _viewState == _DmViewState.userSelection
                ? _buildUserSelection()
                : _buildConversationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationMessages() {
    final chatRoom = ChatRoom(
      id: _selectedUserId!,
      type: ChatRoomType.directMessage,
      displayName: _selectedUsername!,
    );
    final messagesState = ref.watch(chatRoomProvider(chatRoom));
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    void scrollToBottom() {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }

    Future<void> sendMessage() async {
      final message = messageController.text.trim();
      if (message.isEmpty) return;

      try {
        await ref
            .read(chatRoomProvider(chatRoom).notifier)
            .sendMessage(message);
        messageController.clear();
        scrollToBottom();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send message: $e')),
          );
        }
      }
    }

    return Column(
      children: [
        // Messages
        Expanded(
          child: messagesState.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(
                  child: Text(
                    'No messages yet.\nStart the conversation!',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              WidgetsBinding.instance
                  .addPostFrameCallback((_) => scrollToBottom());

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageTile(message: messages[index]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading messages',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(chatRoomProvider(chatRoom));
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Message input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserSelection() {
    final leagueMembersAsync = ref.watch(allLeagueMembersProvider);

    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
        // User list
        Expanded(
          child: leagueMembersAsync.when(
            data: (leagueMembers) {
              return _UserListWithSearch(
                leagueMembers: leagueMembers,
                searchResults: _searchResults,
                isSearching: _isSearching,
                searchError: _searchError,
                hasSearchQuery: _searchController.text.trim().isNotEmpty,
                onUserSelected: (userId, username) {
                  setState(() {
                    _viewState = _DmViewState.conversation;
                    _selectedUserId = userId;
                    _selectedUsername = username;
                  });
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading users: $error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConversationsList() {
    final conversationsAsync = ref.watch(conversationsProvider);

    return conversationsAsync.when(
      data: (conversations) {
        if (conversations.isEmpty) {
          return const Center(
            child: Text(
              'No conversations yet.\nStart a new conversation!',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            final otherUserId = conversation.otherUserId;
            final otherUsername = conversation.otherUsername;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    otherUsername.isNotEmpty
                        ? otherUsername[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(
                  otherUsername,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  conversation.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conversation.unreadCount > 0
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.grey,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(conversation.lastMessageTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (conversation.unreadCount > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  setState(() {
                    _viewState = _DmViewState.conversation;
                    _selectedUserId = otherUserId;
                    _selectedUsername = otherUsername;
                  });
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Error loading conversations',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.refresh(conversationsProvider),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Widget to display list of users with search and league member sections
class _UserListWithSearch extends StatelessWidget {
  final Map<String, String> leagueMembers;
  final List<User> searchResults;
  final bool isSearching;
  final String searchError;
  final bool hasSearchQuery;
  final Function(String userId, String username) onUserSelected;

  const _UserListWithSearch({
    required this.leagueMembers,
    required this.searchResults,
    required this.isSearching,
    required this.searchError,
    required this.hasSearchQuery,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {

    // If searching, show loading indicator
    if (isSearching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If search error, show error message
    if (searchError.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                'Search error: $searchError',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Build the list
    final items = <Widget>[];

    // If has search query, show search results section
    if (hasSearchQuery) {
      if (searchResults.isEmpty) {
        items.add(
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No users found matching your search',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      } else {
        // Search results header
        items.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Search Results',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        );

        // Search results
        for (final user in searchResults) {
          final isLeagueMember = leagueMembers.containsKey(user.userId);
          items.add(
            _buildUserTile(
              context,
              userId: user.userId,
              username: user.username,
              isLeagueMember: isLeagueMember,
            ),
          );
        }
      }

      // Add divider if we have league members to show
      if (leagueMembers.isNotEmpty) {
        items.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
        );
      }
    }

    // Show league members section
    if (leagueMembers.isEmpty) {
      if (!hasSearchQuery) {
        items.add(
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Join a league to see members here',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    } else {
      // League members header
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            'Your League Members',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      );

      // Sort league members alphabetically
      final sortedLeagueMembers = leagueMembers.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      // League members
      for (final member in sortedLeagueMembers) {
        items.add(
          _buildUserTile(
            context,
            userId: member.key,
            username: member.value,
            isLeagueMember: true,
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: items,
    );
  }

  Widget _buildUserTile(
    BuildContext context, {
    required String userId,
    required String username,
    required bool isLeagueMember,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            username.isNotEmpty ? username[0].toUpperCase() : '?',
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isLeagueMember)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'League',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        onTap: () => onUserSelected(userId, username),
      ),
    );
  }
}
