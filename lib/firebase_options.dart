// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZltBfJPEA8zJkDxVo6zxkFV0IWhHapv0',
    appId: '1:861316918961:web:0a8376f11aff4500e8bc90',
    messagingSenderId: '861316918961',
    projectId: 'billshare-d6935',
    authDomain: 'billshare-d6935.firebaseapp.com',
    storageBucket: 'billshare-d6935.appspot.com',
    measurementId: 'G-2JB032RJXC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAP1Nz8p8OaG7h7-4PCnCssC1II1lpJICA',
    appId: '1:861316918961:android:100ae70a6b6fa43be8bc90',
    messagingSenderId: '861316918961',
    projectId: 'billshare-d6935',
    storageBucket: 'billshare-d6935.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0Kq6U69eTlwgHXM6YLcIadQ2bld17K0k',
    appId: '1:861316918961:ios:ba779aa3b78b35d0e8bc90',
    messagingSenderId: '861316918961',
    projectId: 'billshare-d6935',
    storageBucket: 'billshare-d6935.appspot.com',
    iosClientId:
        '861316918961-q0olmj6ctg2ufavf3od5j62n63moe8dr.apps.googleusercontent.com',
    iosBundleId: 'com.example.billshare',
  );
}
