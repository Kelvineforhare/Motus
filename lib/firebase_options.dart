// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDqRsYfZOwMCAqjATOb8AXN0WDqOVFVb-w',
    appId: '1:649595393292:web:04460ee6211efb178d6529',
    messagingSenderId: '649595393292',
    projectId: 'motus-39608',
    authDomain: 'motus-39608.firebaseapp.com',
    storageBucket: 'motus-39608.appspot.com',
    measurementId: 'G-3K0D9228LM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6Vv7BrTYUaB_eqalHq96gE8N9Nip4Q-w',
    appId: '1:649595393292:android:7eb1c39ff0a704a48d6529',
    messagingSenderId: '649595393292',
    projectId: 'motus-39608',
    storageBucket: 'motus-39608.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3gQescHtsFqA_qP8o6YTw_bDb-GrKJYI',
    appId: '1:649595393292:ios:20e96670e886c1da8d6529',
    messagingSenderId: '649595393292',
    projectId: 'motus-39608',
    storageBucket: 'motus-39608.appspot.com',
    iosClientId: '649595393292-6vcuasg9c923hb54g7jg744afibgtjf9.apps.googleusercontent.com',
    iosBundleId: 'com.example.gameDemo',
  );
}
