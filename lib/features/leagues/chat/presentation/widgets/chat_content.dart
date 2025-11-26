import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'league_chat_shell.dart';

/// Embeddable league chat content widget (no AppBar / Scaffold).
///
/// Use this inside league details screens to show league chat inline.
///
/// This widget now serves as a backwards-compatible wrapper around LeagueChatShell,
/// maintaining the same public API while delegating to the new component architecture.
///
/// Assumptions:
/// - `leagueId` matches what your backend expects for league chat.
/// - Backend payloads have at least:
///     { "message": "...", "username": "...", "message_type": "chat" | "system", ... }
class LeagueChatContent extends ConsumerWidget {
  final int leagueId;
  final String? leagueName;

  const LeagueChatContent({
    super.key,
    required this.leagueId,
    this.leagueName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Delegate to the new shell widget which handles all the complexity
    return LeagueChatShell(
      leagueId: leagueId,
      leagueName: leagueName,
    );
  }
}