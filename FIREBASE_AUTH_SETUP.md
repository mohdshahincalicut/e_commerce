# Firebase Authentication Setup Guide

This guide will help you set up Firebase Authentication for your e-commerce app.

## 🔥 **Prerequisites**

1. Firebase project created
2. Firebase configuration files added to your app
3. Authentication enabled in Firebase Console

## 📱 **Step 1: Enable Authentication in Firebase Console**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Authentication** in the left sidebar
4. Click **Get started**
5. Enable the following sign-in methods:
   - **Email/Password** (for email and password authentication)
   - **Google** (optional, for Google Sign-In)

## 🔧 **Step 2: Configure Authentication Methods**

### Email/Password Authentication
1. In Firebase Console → Authentication → Sign-in method
2. Click on **Email/Password**
3. Enable **Email/Password** and **Email link (passwordless sign-in)**
4. Click **Save**

### Google Sign-In (Optional)
1. In Firebase Console → Authentication → Sign-in method
2. Click on **Google**
3. Enable Google Sign-In
4. Add your support email
5. Click **Save**

## 📋 **Step 3: Set Up Firestore Security Rules**

Update your Firestore security rules to work with authentication:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /Users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Products can be read by anyone, but only authenticated users can write
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // User-specific collections (cart, wishlist, orders)
    match /Users/{userId}/cart/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /Users/{userId}/wishlist/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /Users/{userId}/orders/{orderId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🚀 **Step 4: Test Authentication**

### Test Email/Password Authentication

1. **Sign Up Test:**
   ```dart
   // In your app, try signing up with:
   Email: test@example.com
   Password: TestPassword123!
   ```

2. **Sign In Test:**
   ```dart
   // Try signing in with the same credentials
   ```

3. **Check Firebase Console:**
   - Go to Authentication → Users
   - You should see the new user listed

### Test Password Reset

1. Try the "Forgot Password" feature
2. Check your email for the reset link
3. Verify the password reset works

## 🔍 **Step 5: Verify User Data in Firestore**

After successful authentication, check that user data is saved to Firestore:

1. Go to Firestore Database in Firebase Console
2. Look for the **Users** collection
3. Verify user documents are created with:
   - `uid`: User's unique ID
   - `email`: User's email address
   - `createdAt`: Timestamp when account was created
   - `lastLogin`: Timestamp of last login

## 🛠️ **Step 6: Handle Authentication Errors**

The app now includes proper error handling for common authentication issues:

- **User not found**: "No user found with this email address."
- **Wrong password**: "Incorrect password."
- **Email already in use**: "An account already exists with this email address."
- **Weak password**: "Password is too weak. Please choose a stronger password."
- **Invalid email**: "Please enter a valid email address."
- **Network errors**: "Network error. Please check your internet connection."

## 🔐 **Step 7: Security Best Practices**

1. **Password Requirements:**
   - Minimum 6 characters (Firebase default)
   - Consider enforcing stronger passwords in your app

2. **Email Verification:**
   - Consider enabling email verification for new accounts
   - This adds an extra layer of security

3. **Session Management:**
   - Firebase handles session persistence automatically
   - Users stay logged in until they explicitly sign out

## 📊 **Step 8: Monitor Authentication**

1. **View Authentication Analytics:**
   - Go to Firebase Console → Authentication → Users
   - Monitor sign-up and sign-in activity

2. **Check for Suspicious Activity:**
   - Review failed authentication attempts
   - Monitor unusual login patterns

## 🎯 **Step 9: Advanced Features (Optional)**

### Google Sign-In Setup

If you want to enable Google Sign-In:

1. **For Android:**
   - Add your SHA-1 fingerprint to Firebase project
   - Download updated `google-services.json`

2. **For iOS:**
   - Add your bundle ID to Firebase project
   - Download updated `GoogleService-Info.plist`

3. **For Web:**
   - Add your domain to authorized domains in Firebase Console

### Email Verification

1. Enable email verification in Firebase Console
2. Update your app to handle email verification flow
3. Consider requiring email verification before allowing certain actions

## ✅ **Verification Checklist**

- [ ] Authentication enabled in Firebase Console
- [ ] Email/Password sign-in method enabled
- [ ] Firestore security rules updated
- [ ] User registration works
- [ ] User login works
- [ ] Password reset works
- [ ] User data saved to Firestore
- [ ] Error messages display correctly
- [ ] Sign out works
- [ ] Session persistence works

## 🆘 **Troubleshooting**

### Common Issues:

1. **"Firebase not initialized" error:**
   - Check that Firebase is properly initialized in `main.dart`
   - Verify `firebase_options.dart` is correctly configured

2. **"Permission denied" error:**
   - Check Firestore security rules
   - Ensure user is authenticated before accessing protected data

3. **"Invalid email" error:**
   - Verify email format validation
   - Check Firebase Console for email restrictions

4. **"Weak password" error:**
   - Ensure password meets Firebase requirements (minimum 6 characters)
   - Consider adding client-side password validation

### Getting Help:

1. Check Firebase Console for error logs
2. Review Firebase Authentication documentation
3. Test with Firebase Auth Emulator for development

Your Firebase Authentication is now fully configured and ready to use! 🎉

