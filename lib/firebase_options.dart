import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] .
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web Configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyB1_lTKcJleByS089PmvtnYeSXyQY-muEA",
    authDomain: "graphite-flare-418314.firebaseapp.com",
    databaseURL: "https://graphite-flare-418314-default-rtdb.firebaseio.com",
    projectId: "graphite-flare-418314",
    storageBucket: "graphite-flare-418314.firebasestorage.app",
    messagingSenderId: "448926488667",
    appId: "1:448926488667:web:2d41a5b57ac5fae588c77e",
    measurementId: "G-BDDLY8152M"
  );

  // Android Configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSJDqalTHk1hSes276Z_ez6niabvA5Wgk',
    appId: '1:448926488667:android:68ce620fc764be6388c77e',
    messagingSenderId: '448926488667',
    projectId: 'graphite-flare-418314',
    storageBucket: 'graphite-flare-418314.firebasestorage.app',
    databaseURL: 'https://graphite-flare-418314-default-rtdb.firebaseio.com',
  );

  // iOS Configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAN77W2v2jfssmYRUTjLzfr4XypiBlajo0',
    appId: '1:448926488667:ios:68ce620fc764be6388c77e',
    messagingSenderId: '448926488667',
    projectId: 'graphite-flare-418314',
    storageBucket: 'graphite-flare-418314.firebasestorage.app',
    iosClientId: '448926488667-kj0uqq5j6tctoajgcc5hifcrre99hbma.apps.googleusercontent.com',
    iosBundleId: 'com.yourdomain.e_commerce',
    databaseURL: 'https://graphite-flare-418314-default-rtdb.firebaseio.com',
  );

  // macOS Configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSJDqalTHk1hSes276Z_ez6niabvA5Wgk',
    appId: '1:448926488667:ios:68ce620fc764be6388c77e',
    messagingSenderId: '448926488667',
    projectId: 'graphite-flare-418314',
    storageBucket: 'graphite-flare-418314.firebasestorage.app',
    iosClientId: '448926488667-kj0uqq5j6tctoajgcc5hifcrre99hbma.apps.googleusercontent.com',
    iosBundleId: 'com.yourdomain.e_commerce',
    databaseURL: 'https://graphite-flare-418314-default-rtdb.firebaseio.com',
  );

  // Windows Configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDSJDqalTHk1hSes276Z_ez6niabvA5Wgk',
    appId: '1:448926488667:web:abcdef1234567890',
    messagingSenderId: '448926488667',
    projectId: 'graphite-flare-418314',
    storageBucket: 'graphite-flare-418314.firebasestorage.app',
    databaseURL: 'https://graphite-flare-418314-default-rtdb.firebaseio.com',
  );
}
