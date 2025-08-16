# Firebase Setup Steps - Manual Configuration

## Step 1: Create Firebase Project

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Click "Create a project"**
3. **Enter project name**: `ecommerce-app-12345` (or your preferred name)
4. **Enable Google Analytics**: Yes (recommended)
5. **Click "Create project"**
6. **Wait for project creation to complete**

## Step 2: Enable Authentication

1. **In Firebase Console**, click "Authentication" in the left sidebar
2. **Click "Get started"**
3. **Go to "Sign-in method" tab**
4. **Enable these providers**:
   - **Email/Password**: Click "Enable" and save
   - **Google**: Click "Enable", select project support email, and save

## Step 3: Add Your App

### For Web (if testing on web):
1. **Click the gear icon** → "Project settings"
2. **Scroll down to "Your apps"**
3. **Click "Add app"** → Select "Web" (</>) icon
4. **Register app**: Enter app nickname (e.g., "ecommerce-web")
5. **Copy the config object** that looks like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC...",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef"
};
```

### For Android:
1. **Click "Add app"** → Select Android icon
2. **Enter Android package name**: `com.example.e_commerce`
3. **Enter app nickname**: "ecommerce-android"
4. **Download `google-services.json`**
5. **Place it in**: `android/app/google-services.json`

### For iOS:
1. **Click "Add app"** → Select iOS icon
2. **Enter iOS bundle ID**: `com.example.eCommerce`
3. **Enter app nickname**: "ecommerce-ios"
4. **Download `GoogleService-Info.plist`**
5. **Place it in**: `ios/Runner/GoogleService-Info.plist`

## Step 4: Update Firebase Options

Replace the placeholder values in `lib/firebase_options.dart` with your real credentials:

```dart
// Web Configuration
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR-REAL-API-KEY', // Replace with real API key
  appId: 'YOUR-REAL-APP-ID', // Replace with real App ID
  messagingSenderId: 'YOUR-REAL-SENDER-ID', // Replace with real Sender ID
  projectId: 'YOUR-REAL-PROJECT-ID', // Replace with real Project ID
  authDomain: 'YOUR-REAL-AUTH-DOMAIN', // Replace with real Auth Domain
  storageBucket: 'YOUR-REAL-STORAGE-BUCKET', // Replace with real Storage Bucket
  measurementId: 'YOUR-REAL-MEASUREMENT-ID', // Replace with real Measurement ID
);
```

## Step 5: Test Firebase Connection

1. **Run the app**: `flutter run`
2. **Try to sign up** with a real email and password
3. **Check Firebase Console** → Authentication → Users to see if user was created

## Step 6: Configure Google Sign-In (Optional)

If you want Google Sign-In to work:

### For Android:
1. **Get SHA-1 fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   ```
2. **Copy SHA-1** from the output
3. **In Firebase Console** → Project Settings → Your Apps → Android app
4. **Add fingerprint**: Paste the SHA-1

### For iOS:
1. **Get Bundle ID** from your iOS app
2. **In Firebase Console** → Project Settings → Your Apps → iOS app
3. **Verify Bundle ID** matches your app

## Step 7: Test Authentication

1. **Email/Password Sign Up**: Create a new account
2. **Email/Password Sign In**: Sign in with existing account
3. **Google Sign In**: Test Google authentication
4. **Password Reset**: Test password reset functionality

## Troubleshooting

### Common Issues:

1. **"API key not valid"**: Make sure you copied the correct API key
2. **"Project not found"**: Check your project ID
3. **"Authentication failed"**: Verify authentication is enabled in Firebase Console
4. **Google Sign-In not working**: Check SHA-1 fingerprint (Android) or Bundle ID (iOS)

### Error Solutions:

1. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Firebase Console** for any error messages

3. **Verify configuration** in `firebase_options.dart`

## Current Status

✅ **Mock Authentication Disabled**: Real Firebase will be used  
✅ **Firebase Dependencies**: Already installed  
✅ **AuthService**: Ready for real Firebase  
✅ **App Structure**: Ready for production  

## Next Steps

1. Follow the steps above to create Firebase project
2. Update `firebase_options.dart` with real credentials
3. Test authentication functionality
4. Deploy your app with real Firebase authentication

## Support

If you encounter issues:
1. Check Firebase Console for error messages
2. Verify all configuration values are correct
3. Ensure authentication providers are enabled
4. Test with a simple email/password combination first



