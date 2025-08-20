import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/database_provider.dart';
import 'screens/auth_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/network_error_screen.dart';
import 'utils/database_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (optional - will fall back to sample data if fails)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    print('Continuing without Firebase - will use sample data with Firestore structure');
  }
  
  // Add error handling for platform-specific issues
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  _initializeDatabaseInBackground();
  
  runApp(const MyApp());
}

void _initializeDatabaseInBackground() {
  Future.delayed(const Duration(seconds: 2), () async {
    try {
      await DatabaseInit.initializeIfEmpty();
    } catch (e) {
      print('Database initialization error: $e');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'E-Commerce App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple[800]!,
              ),
              useMaterial3: true,
              // Performance optimizations
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) => const HomeScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/wishlist': (context) => const WishlistScreen(),
              '/cart': (context) => const CartScreen(),
              '/network-error': (context) => const NetworkErrorScreen(),
            },
          );
        },
      ),
    );
  }
}
