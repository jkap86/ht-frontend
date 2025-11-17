import 'package:flutter/material.dart';

import 'widgets/dm_conversations_list.dart';
import 'widgets/dm_conversation_view.dart';

/// Main Direct Messages screen
/// Shows list of conversations and allows navigating to individual conversations
class DmScreen extends StatefulWidget {
  const DmScreen({super.key});

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  String? _selectedUserId;
  String? _selectedUsername;

  void _selectConversation(String userId, String username) {
    setState(() {
      _selectedUserId = userId;
      _selectedUsername = username;
    });
  }

  void _backToList() {
    setState(() {
      _selectedUserId = null;
      _selectedUsername = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedUsername != null
              ? 'Chat with $_selectedUsername'
              : 'Direct Messages',
        ),
      ),
      body: _selectedUserId != null && _selectedUsername != null
          ? DmConversationView(
              otherUserId: _selectedUserId!,
              otherUsername: _selectedUsername!,
              onBack: _backToList,
            )
          : DmConversationsList(
              onConversationSelected: _selectConversation,
            ),
    );
  }
}
