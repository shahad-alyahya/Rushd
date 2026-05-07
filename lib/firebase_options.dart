import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

class DefaultFirebaseOptions {
  // Returns the correct Firebase configuration based on the current platform.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  // Firebase configuration specific to Web.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA86HDfRoy_J0fWOXgfwEohWBS61rF42q4',
    appId: '1:491211849737:web:a6550db6e7a90bc51b38d8',
    messagingSenderId: '491211849737',
    projectId: 'rushd-655a1',
    authDomain: 'rushd-655a1.firebaseapp.com',
    storageBucket: 'rushd-655a1.firebasestorage.app',
    measurementId: 'G-5CNZ1D4Q2T',
  );

  // Firebase configuration specific to Android.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2SWf06_xoNXHhj9fl-d8SJJW-2nwWIIQ',
    appId: '1:491211849737:android:23c655c826b58f6c1b38d8',
    messagingSenderId: '491211849737',
    projectId: 'rushd-655a1',
    storageBucket: 'rushd-655a1.firebasestorage.app',
  );
}
