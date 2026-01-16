import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/providers/auth_provider.dart';
import 'presentation/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MuscleHustleApp()));
}

class MuscleHustleApp extends ConsumerWidget {
  const MuscleHustleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStatusProvider);

    return MaterialApp(
      title: 'Muscle Hustle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: _buildHome(authStatus),
    );
  }

  Widget _buildHome(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return const HomeScreen();
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
