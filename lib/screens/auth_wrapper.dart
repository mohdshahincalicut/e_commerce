import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/database_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check auth status when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          // Load user-specific data when authenticated
          final userId = authProvider.currentUser?['user_id'];
          if (userId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final databaseProvider = context.read<DatabaseProvider>();
              databaseProvider.loadUserCart(userId);
              databaseProvider.loadUserOrders(userId);
              databaseProvider.loadUserWishlist(userId);
            });
          }
          
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}


