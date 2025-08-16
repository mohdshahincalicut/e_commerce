# Get Real Firebase Credentials - Quick Guide

## Current Issue
Your app has placeholder Firebase credentials, which is why you're getting "API key not valid" error.

## Quick Solution (5 minutes)

### Step 1: Create Firebase Project
1. Go to: https://console.firebase.google.com/
2. Click "Create a project"
3. Name: `ecommerce-app-12345`
4. Enable Google Analytics: Yes
5. Click "Create project"

### Step 2: Get Web Configuration
1. In Firebase Console, click the gear icon → "Project settings"
2. Scroll down to "Your apps"
3. Click "Add app" → Select Web (</>) icon
4. App nickname: `ecommerce-web`
5. Click "Register app"
6. **Copy the config object** that looks like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz",
  authDomain: "ecommerce-app-12345.firebaseapp.com",
  projectId: "ecommerce-app-12345",
  storageBucket: "ecommerce-app-12345.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

### Step 3: Enable Authentication
1. In Firebase Console, click "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Enable "Google"
6. Click "Save"

### Step 4: Update Your App
Replace the placeholder values in `lib/firebase_options.dart`:

```dart
// Web Configuration
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyC1234567890abcdefghijklmnopqrstuvwxyz', // Your real API key
  appId: '1:123456789012:web:abcdef1234567890', // Your real App ID
  messagingSenderId: '123456789012', // Your real Sender ID
  projectId: 'ecommerce-app-12345', // Your real Project ID
  authDomain: 'ecommerce-app-12345.firebaseapp.com', // Your real Auth Domain
  storageBucket: 'ecommerce-app-12345.appspot.com', // Your real Storage Bucket
  measurementId: 'G-XXXXXXXXXX', // Your real Measurement ID
);
```

### Step 5: Enable Real Firebase
In `lib/services/auth_service.dart`, change:
```dart
static const bool _isDevelopmentMode = true;
```
to:
```dart
static const bool _isDevelopmentMode = false;
```

### Step 6: Test
1. Run: `flutter clean && flutter pub get && flutter run`
2. Try to sign up with a real email
3. Check Firebase Console → Authentication → Users

## What You Need to Copy

From your Firebase config, copy these values:
- `apiKey`: Starts with "AIzaSy..."
- `appId`: Starts with "1:..."
- `messagingSenderId`: Numbers only
- `projectId`: Your project name
- `authDomain`: Your project + ".firebaseapp.com"
- `storageBucket`: Your project + ".appspot.com"

## Current Status
✅ **Mock Authentication**: Re-enabled (app works now)  
✅ **Ready for Real Firebase**: Just need real credentials  
✅ **All Features**: Working with mock authentication  

## Next Steps
1. Follow the steps above to get real credentials
2. Update `firebase_options.dart`
3. Set `_isDevelopmentMode = false`
4. Test real authentication

Your app is working perfectly with mock authentication while you set up real Firebase!



