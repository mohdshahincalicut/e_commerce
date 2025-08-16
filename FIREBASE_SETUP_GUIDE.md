# 🔥 Firebase Setup Guide - Fix Permission Errors

## 🚨 Current Issues to Fix:
1. **Firebase permission denied errors**
2. **Database connection issues** 
3. **Authentication problems**

## 📋 Step-by-Step Setup:

### 1. **Firebase Console Setup**

#### A. Go to Firebase Console
- Visit: https://console.firebase.google.com/
- Sign in with your Google account

#### B. Create/Select Project
- Click "Create a project" or select existing project
- Project name: `graphite-flare-418314` (or your preferred name)
- Enable Google Analytics (optional)
- Click "Create project"

### 2. **Enable Firebase Services**

#### A. Authentication
- Go to "Authentication" in left sidebar
- Click "Get started"
- Enable these sign-in methods:
  - ✅ Email/Password
  - ✅ Google
- Click "Save"

#### B. Firestore Database
- Go to "Firestore Database" in left sidebar
- Click "Create database"
- Choose "Start in test mode" (for development)
- Select location closest to your users
- Click "Done"

#### C. Realtime Database
- Go to "Realtime Database" in left sidebar
- Click "Create database"
- Choose "Start in test mode" (for development)
- Select location closest to your users
- Click "Done"

#### D. Storage (Optional)
- Go to "Storage" in left sidebar
- Click "Get started"
- Choose "Start in test mode"
- Select location
- Click "Done"

### 3. **Configure Security Rules**

#### A. Firestore Rules
- Go to "Firestore Database" → "Rules"
- Replace existing rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow public read access to products and categories
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Allow authenticated users to manage their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /users/{userId}/wishlist/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /users/{userId}/orders/{orderId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to create reviews
    match /products/{productId}/reviews/{reviewId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Allow authenticated users to manage orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
    
    // Allow authenticated users to manage analytics
    match /analytics/{analyticsId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### B. Realtime Database Rules
- Go to "Realtime Database" → "Rules"
- Replace existing rules with:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "carts": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    },
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

### 4. **Get Firebase Configuration**

#### A. Project Settings
- Click the gear icon ⚙️ next to "Project Overview"
- Select "Project settings"

#### B. Add Android App
- In "Your apps" section, click "Add app" → Android
- Android package name: `com.yourdomain.e_commerce`
- App nickname: "E-Commerce App"
- Click "Register app"
- Download `google-services.json`
- Place it in `android/app/` folder

#### C. Add Web App (Optional)
- Click "Add app" → Web
- App nickname: "E-Commerce Web"
- Click "Register app"
- Copy the config object

### 5. **Update App Configuration**

#### A. Update `lib/firebase_options.dart`
- Replace the configuration with your actual Firebase project values
- Make sure `projectId` matches your Firebase project ID

#### B. Update `android/app/google-services.json`
- Replace with the downloaded file from Firebase Console

### 6. **Test the Setup**

#### A. Run the App
```bash
flutter clean
flutter pub get
flutter run
```

#### B. Check for Errors
- Look for "Firebase initialized successfully" message
- Check for permission errors in console
- Test authentication flow

### 7. **Troubleshooting**

#### A. Permission Denied Errors
- Make sure security rules are properly set
- Check if user is authenticated
- Verify project ID matches

#### B. Database Connection Issues
- Check internet connection
- Verify database URL is correct
- Ensure database is created in Firebase Console

#### C. Authentication Issues
- Enable authentication methods in Firebase Console
- Check if Google Sign-In is properly configured
- Verify API keys are correct

### 8. **Production Setup**

#### A. Update Security Rules
- Change from "test mode" to production rules
- Implement proper authentication checks
- Add rate limiting if needed

#### B. Enable App Check (Optional)
- Go to "App Check" in Firebase Console
- Enable for your platforms
- Add App Check to your app

#### C. Monitor Usage
- Set up billing alerts
- Monitor database usage
- Check authentication logs

## ✅ Success Indicators:
- ✅ No permission denied errors in console
- ✅ "Firebase initialized successfully" message
- ✅ Products load from database
- ✅ Authentication works (login/signup)
- ✅ Cart functionality works
- ✅ Wishlist functionality works

## 🆘 If Still Having Issues:
1. **Check Firebase Console** - Ensure all services are enabled
2. **Verify Project ID** - Make sure it matches in all config files
3. **Test Authentication** - Try creating a new user account
4. **Check Network** - Ensure stable internet connection
5. **Review Logs** - Look for specific error messages

## 📞 Support:
If you continue to have issues, please:
1. Share the specific error messages from console
2. Confirm Firebase Console setup is complete
3. Check if all services are enabled
4. Verify project ID matches throughout

**Your app should work perfectly after following this guide!** 🎉
