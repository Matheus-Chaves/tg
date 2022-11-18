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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDhaonyt4KfoefFe0l2bzpqauUoTzdyOHM',
    appId: '1:209528779607:web:101becbbdc4bf644a24412',
    messagingSenderId: '209528779607',
    projectId: 'trabalho-graduacao-2022',
    authDomain: 'trabalho-graduacao-2022.firebaseapp.com',
    storageBucket: 'trabalho-graduacao-2022.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSlCcrkWi6nXnIXL3U9Db1PEyYym5_IV4',
    appId: '1:209528779607:android:43a2e15d12b25459a24412',
    messagingSenderId: '209528779607',
    projectId: 'trabalho-graduacao-2022',
    storageBucket: 'trabalho-graduacao-2022.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTemZiT26KyddjKhx5KY5bLQHlDcUVrLo',
    appId: '1:209528779607:ios:90def6da04685cdea24412',
    messagingSenderId: '209528779607',
    projectId: 'trabalho-graduacao-2022',
    storageBucket: 'trabalho-graduacao-2022.appspot.com',
    iosClientId: '209528779607-rqv6vldokrls8ltrnufnak3sis8f1ko6.apps.googleusercontent.com',
    iosBundleId: 'com.example.tg',
  );
}