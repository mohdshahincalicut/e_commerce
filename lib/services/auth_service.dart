import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    try {
      return auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      if (userCredential.user != null) {
        await firestore
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set(
          {
            "uid": userCredential.user!.uid,
            "email": email,
            "lastLogin": FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      if (userCredential.user != null) {
        await firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            "uid": userCredential.user!.uid,
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
            "lastLogin": FieldValue.serverTimestamp(),
          },
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    } catch (e) {
      print('Unexpected error during sign up: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // For now, return null as Google Sign-In requires additional setup
      // You can implement Google Sign-In later
      throw Exception('Google Sign-In not implemented yet');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  // Load user from local storage (fallback)
  Future<Map<String, dynamic>?> loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final email = prefs.getString('email');
      final name = prefs.getString('name');

      if (userId != null && email != null) {
        return {
          'user_id': userId,
          'email': email,
          'name': name ?? 'User',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Save user to local storage (fallback)
  Future<void> saveUserToPrefs(Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user['user_id']);
      await prefs.setString('email', user['email']);
      await prefs.setString('name', user['name'] ?? 'User');
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  // Get user-friendly error messages
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
