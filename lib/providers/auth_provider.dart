import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get error => _error;

  AuthProvider() {
    checkAuthStatus();
  }

  // Check authentication status on app start
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check Firebase Auth first
      final firebaseUser = _authService.getCurrentUser();
      if (firebaseUser != null) {
        _currentUser = {
          'user_id': firebaseUser.uid,
          'email': firebaseUser.email ?? '',
          'name': firebaseUser.displayName ?? 'User',
        };
        _isAuthenticated = true;
      } else {
        // Fall back to local storage
        final user = await _authService.loadUserFromPrefs();
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
        } else {
          _currentUser = null;
          _isAuthenticated = false;
        }
      }
    } catch (e) {
      print('Error checking auth status: $e');
      _error = 'Authentication check failed. Please try again.';
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailAndPassword(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signUpWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        _currentUser = {
          'user_id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': name,
        };
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        _currentUser = {
          'user_id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName ?? 'User',
        };
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        _currentUser = {
          'user_id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName ?? 'User',
        };
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
