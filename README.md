# E-Commerce App with Authentication

A Flutter e-commerce application with a responsive login design and comprehensive authentication system.

## Features

- **Responsive Design**: Works seamlessly across mobile, tablet, and desktop
- **Modern UI**: Beautiful purple gradient design matching the provided mockup
- **Authentication Methods**:
  - Email/Password authentication
  - Google Sign-In
  - Facebook Sign-In
  - Password reset functionality
- **State Management**: Provider pattern for clean state management
- **Form Validation**: Comprehensive input validation
- **Error Handling**: User-friendly error messages
- **Persistent Login**: Remembers user session

## Screenshots

The app features a login screen with:
- Purple gradient background
- White rounded container for form
- Email and password input fields
- "Forgot Password?" functionality
- Social login options (Google & Facebook)
- Responsive design for all screen sizes

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### 2. Firebase Setup

1. **Create Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication
   - Enable Email/Password, Google, and Facebook sign-in methods

2. **Configure Firebase for Android**:
   - Add Android app to Firebase project
   - Download `google-services.json`
   - Place it in `android/app/`

3. **Configure Firebase for iOS**:
   - Add iOS app to Firebase project
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

4. **Configure Google Sign-In**:
   - Enable Google Sign-In in Firebase Authentication
   - Add SHA-1 fingerprint for Android
   - Configure OAuth consent screen

5. **Configure Facebook Sign-In**:
   - Create Facebook Developer account
   - Create Facebook app
   - Add Facebook app ID to Firebase
   - Configure Facebook Login settings

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Platform-Specific Configuration

#### Android Configuration

1. **Update `android/app/build.gradle`**:
   ```gradle
   android {
       compileSdkVersion 34
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

2. **Update `android/app/src/main/AndroidManifest.xml`**:
   ```xml
   <manifest ...>
       <uses-permission android:name="android.permission.INTERNET"/>
       <application ...>
           <!-- Add your Facebook app ID -->
           <meta-data
               android:name="com.facebook.sdk.ApplicationId"
               android:value="@string/facebook_app_id"/>
       </application>
   </manifest>
   ```

#### iOS Configuration

1. **Update `ios/Runner/Info.plist`**:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
       <dict>
           <key>CFBundleURLName</key>
           <string>Facebook</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>fbYOUR_FACEBOOK_APP_ID</string>
           </array>
       </dict>
   </array>
   ```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/
│   └── auth_provider.dart    # Authentication state management
├── services/
│   └── auth_service.dart     # Firebase authentication service
├── screens/
│   ├── login_screen.dart     # Login screen
│   ├── signup_screen.dart    # Sign up screen
│   └── home_screen.dart      # Home screen after login
└── widgets/
    ├── auth_wrapper.dart     # Authentication state wrapper
    ├── custom_text_field.dart # Custom input field
    └── social_login_button.dart # Social login buttons
```

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase authentication
- `google_sign_in`: Google Sign-In integration
- `flutter_facebook_auth`: Facebook Sign-In integration
- `flutter_screenutil`: Responsive design utilities
- `responsive_framework`: Responsive framework
- `shared_preferences`: Local data storage
- `provider`: State management

## Usage

1. **Login**: Users can sign in with email/password or social accounts
2. **Sign Up**: New users can create accounts
3. **Password Reset**: Users can reset forgotten passwords
4. **Home Screen**: Displays user information after successful authentication
5. **Logout**: Users can sign out from the home screen

## Customization

- **Colors**: Update the purple gradient colors in the theme
- **Typography**: Modify text styles in the theme
- **Layout**: Adjust responsive breakpoints in `main.dart`
- **Validation**: Customize form validation rules
- **UI Components**: Modify custom widgets for different styling

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Ensure `google-services.json` and `GoogleService-Info.plist` are properly placed
2. **Google Sign-In not working**: Check SHA-1 fingerprint and OAuth configuration
3. **Facebook Sign-In not working**: Verify Facebook app configuration and app ID
4. **Build errors**: Ensure all dependencies are properly installed

### Debug Mode

Run the app in debug mode to see detailed error messages:

```bash
flutter run --debug
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
# e_commerce
# e_commerce
