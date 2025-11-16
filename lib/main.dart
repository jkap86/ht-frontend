import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/application/auth_notifier.dart';
import 'features/auth/application/auth_state.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/home/presentation/home_screen.dart';

late final AppConfig appConfig;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  appConfig = loadAppConfig();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Router provider so we can plug in auth state and guards.
final routerProvider = Provider<GoRouter>((ref) {
  print('🔍 [routerProvider] Router provider rebuild triggered');
  // Watch auth state so the router rebuilds when login/logout happens
  final authState = ref.watch(authProvider);
  print('🔍 [routerProvider] Auth state watched: ${authState.status}, user: ${authState.user?.username}');

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authStatus = authState.status;
      final String path = state.matchedLocation;
      print('🔍 [Router redirect] Path: $path, AuthStatus: $authStatus');

      final bool goingToLogin = path == '/login';
      final bool goingToRegister = path == '/register';

      // If auth is still unknown, allow navigation to login/register
      if (authStatus == AuthStatus.unknown) {
        if (goingToLogin || goingToRegister) {
          return null;
        }
        return '/login';
      }

      final bool isLoggedIn = authStatus == AuthStatus.authenticated;

      // If the user is NOT logged in and is trying to go anywhere
      // except /login or /register, send them to /login
      if (!isLoggedIn && !(goingToLogin || goingToRegister)) {
        return '/login';
      }

      // If the user IS logged in and they try to go to /login or /register,
      // send them to /home instead
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      // No redirect
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _restored = false;

  @override
  void initState() {
    super.initState();
    print('🔍 [_MyAppState] initState called');

    // Kick off session restore once, when the app starts.
    // Skip if already authenticated (e.g., after hot reload with cached state)
    // Use Future.microtask to avoid calling ref.read during build
    Future.microtask(() {
      print('🔍 [_MyAppState] Future.microtask executing');
      final currentAuthStatus = ref.read(authProvider).status;
      print('🔍 [_MyAppState] Current auth status: $currentAuthStatus');

      // Skip restoration if already authenticated (hot reload preserved state)
      if (currentAuthStatus == AuthStatus.authenticated) {
        print('🔍 [_MyAppState] Already authenticated (from cache), skipping restore');
        setState(() {
          _restored = true;
        });
        return;
      }

      // Only restore session if status is unknown (fresh start)
      if (currentAuthStatus == AuthStatus.unknown) {
        print('🔍 [_MyAppState] Status unknown, calling restoreSession');
        ref.read(authProvider.notifier).restoreSession().whenComplete(() {
          print('🔍 [_MyAppState] restoreSession completed');
          if (mounted) {
            setState(() {
              _restored = true;
            });
          }
        });
      } else {
        // If unauthenticated, just mark as restored
        print('🔍 [_MyAppState] Already unauthenticated, skipping restore');
        setState(() {
          _restored = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // Optional: simple splash / loading screen while we restore session
    if (!_restored) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Fantasy Football App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
