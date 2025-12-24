import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_notifier.dart';
import '../features/auth/application/auth_state.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/add_league_screen.dart';
import '../features/leagues/presentation/league_details_screen.dart';
import '../features/leagues/drafts/presentation/draft_room_screen.dart';
import '../features/leagues/matchup_drafts/presentation/matchup_draft_room_screen.dart';
import '../features/direct_messages/presentation/dm_screen.dart';

/// Safely parse an integer from path parameters, returning null if invalid
int? _parseIntParam(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

/// Router provider with auth state and guards
final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state so the router rebuilds when login/logout happens
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authStatus = authState.status;
      final String path = state.matchedLocation;

      final bool goingToLogin = path == '/login';
      final bool goingToRegister = path == '/register';

      // While auth is still resolving (unknown state), don't redirect anywhere.
      // This prevents hot reload from forcing users back to login while
      // we're still checking their authentication status.
      if (authStatus == AuthStatus.unknown) {
        return null; // Stay on current route while loading
      }

      final bool isLoggedIn = authStatus == AuthStatus.authenticated;

      // If NOT logged in and trying to access anything except login/register,
      // send to /login.
      if (!isLoggedIn && !(goingToLogin || goingToRegister)) {
        return '/login';
      }

      // If logged in and trying to go to login/register, send to /home instead.
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      // No redirect needed.
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final authStatus = ref.read(authProvider).status;
          if (authStatus == AuthStatus.authenticated) {
            return '/home';
          }
          return '/login';
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/add-league',
        name: 'add-league',
        builder: (context, state) => const AddLeagueScreen(),
      ),
      GoRoute(
        path: '/league/:leagueId',
        name: 'league',
        redirect: (context, state) {
          final leagueId = _parseIntParam(state.pathParameters['leagueId']);
          if (leagueId == null) return '/home';
          return null;
        },
        builder: (context, state) {
          final leagueId = _parseIntParam(state.pathParameters['leagueId']) ?? 0;
          return LeagueDetailsScreen(leagueId: leagueId);
        },
        routes: [
          GoRoute(
            path: 'draft/:draftId/room',
            name: 'draft-room',
            redirect: (context, state) {
              final leagueId = _parseIntParam(state.pathParameters['leagueId']);
              final draftId = _parseIntParam(state.pathParameters['draftId']);
              if (leagueId == null || draftId == null) return '/home';
              return null;
            },
            builder: (context, state) {
              final leagueId = _parseIntParam(state.pathParameters['leagueId']) ?? 0;
              final draftId = _parseIntParam(state.pathParameters['draftId']) ?? 0;
              return DraftRoomScreen(
                leagueId: leagueId,
                draftId: draftId,
              );
            },
          ),
          GoRoute(
            path: 'matchup-draft/:draftId/room',
            name: 'matchup-draft-room',
            redirect: (context, state) {
              final leagueId = _parseIntParam(state.pathParameters['leagueId']);
              final draftId = _parseIntParam(state.pathParameters['draftId']);
              if (leagueId == null || draftId == null) return '/home';
              return null;
            },
            builder: (context, state) {
              final leagueId = _parseIntParam(state.pathParameters['leagueId']) ?? 0;
              final draftId = _parseIntParam(state.pathParameters['draftId']) ?? 0;
              return MatchupDraftRoomScreen(
                leagueId: leagueId,
                draftId: draftId,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const DmScreen(),
      ),
    ],
  );
});