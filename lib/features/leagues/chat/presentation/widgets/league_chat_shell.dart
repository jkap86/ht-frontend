import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'league_chat_header.dart';
import 'league_chat_panel.dart';
import 'league_dm_panel.dart';
import 'league_user_search_panel.dart';

/// Shell widget that manages the overall chat view state.
/// Decides between:
/// - Pure league chat view
/// - DMs list + conversation view
/// - User search for starting new DMs
class LeagueChatShell extends ConsumerStatefulWidget {
  final int leagueId;
  final String? leagueName;

  const LeagueChatShell({
    super.key,
    required this.leagueId,
    this.leagueName,
  });

  @override
  ConsumerState<LeagueChatShell> createState() => _LeagueChatShellState();
}

enum ChatTab { league, dms }

class _LeagueChatShellState extends ConsumerState<LeagueChatShell> {
  ChatTab _selectedTab = ChatTab.league;
  bool _showUserSearch = false;

  // For DM conversation state
  String? _selectedConversationId;
  String? _selectedOtherUserId;
  String? _selectedOtherUsername;

  void _onStartNewDm() {
    setState(() {
      _showUserSearch = true;
    });
  }

  void _onUserSelected({
    required String conversationId,
    required String otherUserId,
    required String? otherUsername,
  }) {
    setState(() {
      _selectedConversationId = conversationId;
      _selectedOtherUserId = otherUserId;
      _selectedOtherUsername = otherUsername;
      _showUserSearch = false;
    });
  }

  void _onBackFromUserSearch() {
    setState(() {
      _showUserSearch = false;
    });
  }

  void _onBackFromConversation() {
    setState(() {
      _selectedConversationId = null;
      _selectedOtherUserId = null;
      _selectedOtherUsername = null;
    });
  }

  void _onConversationSelected({
    required String conversationId,
    required String otherUserId,
    String? otherUsername,
  }) {
    setState(() {
      _selectedConversationId = conversationId;
      _selectedOtherUserId = otherUserId;
      _selectedOtherUsername = otherUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabHeader(),
        Expanded(
          child: _buildContent(),
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
        _showUserSearch = false;
      }),
      onDmsSelected: () => setState(() => _selectedTab = ChatTab.dms),
    );
  }

  Widget _buildContent() {
    if (_selectedTab == ChatTab.league) {
      // Pure league chat view
      return LeagueChatPanel(
        leagueId: widget.leagueId,
      );
    }

    // DMs tab selected
    if (_showUserSearch) {
      // User search view
      return LeagueUserSearchPanel(
        onUserSelected: _onUserSelected,
        onBack: _onBackFromUserSearch,
      );
    }

    // DM panel (list or conversation)
    return LeagueDmPanel(
      selectedConversationId: _selectedConversationId,
      selectedOtherUserId: _selectedOtherUserId,
      selectedOtherUsername: _selectedOtherUsername,
      onStartNewDm: _onStartNewDm,
      onConversationSelected: _onConversationSelected,
      onBackFromConversation: _onBackFromConversation,
    );
  }
}