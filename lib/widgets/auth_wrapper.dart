import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isCheckingAuth = true;
  bool _isMockUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      setState(() {
        _isMockUserLoggedIn = userId != null && userId.startsWith('mock_user_');
        _isCheckingAuth = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading || _isCheckingAuth) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check for real Firebase user or mock user
        if (authProvider.isAuthenticated || _isMockUserLoggedIn) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
