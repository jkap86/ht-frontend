import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/unified_league_chat_notifier.dart';
import '../../../../auth/application/auth_notifier.dart';
import '../../../../auth/application/users_search_provider.dart';
import '../../../../direct_messages/presentation/dm_screen.dart';
import '../../../../home/presentation/widgets/dm_chat_content.dart';
import 'league_chat_header.dart';
import 'league_chat_message_list.dart';
import 'league_chat_input_section.dart';

/// Embeddable league chat content widget (no AppBar / Scaffold).
///
/// Use this inside league details screens to show league chat inline.
///
/// Assumptions:
/// - `leagueId` matches what your backend expects for league chat.
/// - Backend payloads have at least:
///     { "message": "...", "username": "...", "message_type": "chat" | "system", ... }
class LeagueChatContent extends ConsumerStatefulWidget {
  final int leagueId;
  final String? leagueName;

  const LeagueChatContent({
    super.key,
    required this.leagueId,
    this.leagueName,
  });

  @override
  ConsumerState<LeagueChatContent> createState() => _LeagueChatContentState();
}

enum ChatTab { league, dms }

class _LeagueChatContentState extends ConsumerState<LeagueChatContent> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  ChatTab _selectedTab = ChatTab.league;
  bool _showUserSearch = false;

  // For DM conversation view
  String? _selectedConversationId;
  String? _selectedOtherUserId;
  String? _selectedOtherUsername;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabHeader(),
        Expanded(
          child: _selectedTab == ChatTab.league
              ? _buildLeagueChat()
              : _buildDmsList(),
        ),
      ],
    );
  }

  Widget _buildTabHeader() {
    return LeagueChatHeader(
      leagueName: widget.leagueName ?? 'League',
      isLeagueSelected: _selectedTab == ChatTab.league,
      onLeagueSelected: () => setState(() {
        _selectedTab = ChatTab.league;
        _selectedConversationId = null;
      }),
      onDmsSelected: () => setState(() => _selectedTab = ChatTab.dms),
    );
  }

  Widget _buildLeagueChat() {
    final state = ref.watch(leagueChatNotifierProvider(widget.leagueId));
    final notifier =
        ref.read(leagueChatNotifierProvider(widget.leagueId).notifier);

    // Auto-scroll to bottom when new messages arrive.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });

    final isLoading = state.isConnecting && state.messages.isEmpty;

    return Column(
      children: [
        Expanded(
          child: LeagueChatMessageList(
            messages: state.messages,
            scrollController: _scrollController,
            isLoading: isLoading,
          ),
        ),
        LeagueChatInputSection(
          controller: _textController,
          onSend: () => _handleSend(notifier),
          enabled: state.isConnected,
          errorMessage: state.errorMessage,
        ),
      ],
    );
  }

  Widget _buildDmsList() {
    final conversationsAsync = ref.watch(dmConversationsProvider);

    if (_selectedConversationId != null) {
      // Show DM conversation view
      return Column(
        children: [
          // Back button header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() {
                    _selectedConversationId = null;
                    _selectedOtherUserId = null;
                    _selectedOtherUsername = null;
                  }),
                ),
                Text(
                  _selectedOtherUsername ?? 'Direct Message',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: DmChatContent(
              conversationId: _selectedConversationId!,
              otherUserId: _selectedOtherUserId!,
              otherUsername: _selectedOtherUsername,
            ),
          ),
        ],
      );
    }

    if (_showUserSearch) {
      // Show user search view
      return _buildUserSearch();
    }

    // Show list of conversations
    return conversationsAsync.when(
      data: (conversations) {
        return Column(
          children: [
            // Search/New Message button
            Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showUserSearch = true),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Message'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: conversations.isEmpty
                  ? const Center(
                      child: Text(
                        'No direct messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: conversations.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        final conversationId =
                            (convo['conversationId'] ?? '').toString();
                        final otherUserId =
                            (convo['otherUserId'] ?? '').toString();
                        final otherUsername =
                            (convo['otherUsername'])?.toString();
                        final lastMessage = convo['lastMessage']?.toString();
                        final unreadCount = int.tryParse(
                                convo['unreadCount']?.toString() ?? '0') ??
                            0;

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              otherUsername != null && otherUsername.isNotEmpty
                                  ? otherUsername[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(otherUsername ?? 'Unknown'),
                          subtitle: Text(
                            lastMessage?.isNotEmpty == true
                                ? lastMessage!
                                : 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: unreadCount > 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  ),
                                )
                              : null,
                          onTap: () => setState(() {
                            _selectedConversationId = conversationId;
                            _selectedOtherUserId = otherUserId;
                            _selectedOtherUsername = otherUsername;
                          }),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load conversations',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildUserSearch() {
    return Column(
      children: [
        // Back button and search header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _showUserSearch = false;
                  _searchController.clear();
                }),
              ),
              const Text(
                'New Message',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Search field
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: _buildUserSearchResults(),
        ),
      ],
    );
  }

  Widget _buildUserSearchResults() {
    final searchQuery = _searchController.text.trim();
    final currentUserId = ref.read(authProvider).user?.userId;

    // If search is empty, show placeholder
    if (searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'Type to search for users...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Fetch users matching the search query
    final usersAsync = ref.watch(usersSearchProvider(searchQuery));

    return usersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'No users found matching "$searchQuery"',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  user.username.isNotEmpty
                      ? user.username[0].toUpperCase()
                      : '?',
                ),
              ),
              title: Text(user.username),
              onTap: () {
                // Create conversation ID (sorted user IDs)
                final userIds = [currentUserId ?? '', user.userId]..sort();
                final conversationId = '${userIds[0]}_${userIds[1]}';

                setState(() {
                  _selectedConversationId = conversationId;
                  _selectedOtherUserId = user.userId;
                  _selectedOtherUsername = user.username;
                  _showUserSearch = false;
                  _searchController.clear();
                });
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Failed to search users',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  void _handleSend(LeagueChatNotifier notifier) {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    // The notifier's sendMessage already checks state.isConnected,
    // but we can add an early return here as well for clarity
    // Socket payload expected by backend for league chat:
    // {
    //   room: "league_<id>",
    //   message: string,
    //   metadata: { ... } // optional
    // }
    notifier.sendMessage({
      'room': 'league_${widget.leagueId}',
      'message': message,
      'metadata': <String, dynamic>{},
    });

    _textController.clear();
  }
}
