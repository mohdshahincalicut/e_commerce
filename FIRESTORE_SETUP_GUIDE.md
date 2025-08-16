# Firestore Setup Guide for ProductGrid

This guide explains how to set up Firebase Firestore to work with the ProductGrid component.

## Prerequisites

1. A Firebase project
2. Firestore database enabled
3. Firebase configuration files

## Firebase Configuration

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Firestore Database

### 2. Add Firebase to Your App

#### For Android:
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory
3. Add the following to `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```
4. Add the following to `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### For iOS:
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/` directory
3. Add it to your Xcode project

#### For Web:
1. Add Firebase configuration to `web/index.html`:
   ```html
   <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
   <script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-firestore.js"></script>
   ```

## Firestore Data Structure

The ProductGrid expects products to be stored in a `products` collection with the following structure:

```json
{
  "categoryId": "electronics",
  "color": "pink",
  "createdAt": "2025-08-15T18:02:27.000Z",
  "description": "Powerful tablet with M1 chip, all-day battery, and Apple Pencil support",
  "discount": "14%",
  "icon": "keyboard",
  "images": [
    "https://i5.walmartimages.com/seo/Apple-10-5-inch-iPad-Air-Wi-Fi-64GB-Gold_e2056aea-1604-4640-96dd-f982e10322e2_1.02df42f3e9fd3cf109b311bda0b9c63e.jpeg",
    "https://i5.walmartimages.com/seo/Apple-10-5-inch-iPad-Air-Wi-Fi-64GB-Gold_e2056aea-1604-4640-96dd-f982e10322e2_1.02df42f3e9fd3cf109b311bda0b9c63e.jpeg"
  ],
  "name": "iPad Air 5th Gen",
  "originalPrice": "AED 2,899",
  "price": 2499,
  "rating": 4.5,
  "reviews": 234,
  "specifications": {
    "brand": "Apple",
    "connectivity": "Wi-Fi + Cellular",
    "display": "10.9\" Liquid Retina",
    "features": "Apple Pencil 2 support, Magic Keyboard",
    "processor": "M1 chip",
    "storage": "256GB"
  },
  "stock": 28,
  "updatedAt": "2025-08-15T18:02:27.000Z"
}
```

## Firestore Security Rules

Set up appropriate security rules for your `products` collection:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;  // Anyone can read products
      allow write: if request.auth != null;  // Only authenticated users can write
    }
  }
}
```

## Features

### Automatic Data Conversion
The ProductGrid automatically handles:
- Converting price strings to numbers (removes currency symbols)
- Converting ratings and reviews to appropriate data types
- Adding document IDs as product IDs
- Handling both network images and asset images

### Fallback Support
If Firebase is not configured or fails to load:
- The app falls back to sample data
- No crashes or errors for users
- Graceful degradation

### Image Support
- Supports both network images (from URLs) and asset images
- Loading indicators for network images
- Error handling with fallback icons
- Automatic image type detection

## Testing

To test the Firestore integration:

1. Add some sample products to your Firestore database
2. Run the app
3. Check that products load from Firestore
4. Verify images display correctly
5. Test search and filtering functionality

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**: Check that Firebase is properly configured
2. **Permission denied**: Verify Firestore security rules
3. **Images not loading**: Check image URLs and network connectivity
4. **Data not loading**: Verify collection name is "products"

### Debug Mode:
The app includes error handling and will show appropriate error messages if Firestore fails to load data.

