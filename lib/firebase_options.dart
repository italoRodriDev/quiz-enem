// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD94ChWTQU67SYr6vSSgVg_Ao-KoKrBl_E',
    appId: '1:157146722057:android:fb1fbe816c46f0e9c4add8',
    messagingSenderId: '157146722057',
    projectId: 'app-estudos-ffae8',
    storageBucket: 'app-estudos-ffae8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5_GGAVPeQdKeBZcNOc9vvZXX97Ab-GI8',
    appId: '1:157146722057:ios:1949811e102bc1a4c4add8',
    messagingSenderId: '157146722057',
    projectId: 'app-estudos-ffae8',
    storageBucket: 'app-estudos-ffae8.appspot.com',
    iosBundleId: 'com.example.quizEnem',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBvkFPko8Z7p5WnnphyO7gUPgUFgqMzEik',
    appId: '1:157146722057:web:01c16bcabd229965c4add8',
    messagingSenderId: '157146722057',
    projectId: 'app-estudos-ffae8',
    authDomain: 'app-estudos-ffae8.firebaseapp.com',
    storageBucket: 'app-estudos-ffae8.appspot.com',
    measurementId: 'G-CQY34HQTQP',
  );

}