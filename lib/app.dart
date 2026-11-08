import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'utils/theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

class ESGApp extends StatelessWidget {
  final bool demoMode;
  const ESGApp({super.key, this.demoMode = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(demoMode: demoMode)),
        Provider(create: (_) => FirestoreService(demoMode: demoMode)),
      ],
      child: MaterialApp(
        title: 'ESG Campus Passport',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (!authService.isLoggedIn) {
      return const LoginScreen();
    }

    if (authService.isAdmin || authService.isModerator) {
      return const AdminDashboardScreen();
    }

    return const HomeScreen();
  }
}
