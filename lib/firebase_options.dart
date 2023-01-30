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
    apiKey: 'AIzaSyDZA7AqaJYPpqsgU4PB-aBqs08ZEQNemBg',
    appId: '1:315759816883:web:3a869532eda2596a4800c6',
    messagingSenderId: '315759816883',
    projectId: 'mishi-flutter',
    authDomain: 'mishi-flutter.firebaseapp.com',
    storageBucket: 'mishi-flutter.appspot.com',
    measurementId: 'G-SJCKVWD85P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZih7CY9-RaIgGY2qU5R4t79zNxJ4NiV4',
    appId: '1:315759816883:android:ddd092c5038ea84f4800c6',
    messagingSenderId: '315759816883',
    projectId: 'mishi-flutter',
    storageBucket: 'mishi-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCosLLr71JNjE5gBKfikhQbO153R0gYZq8',
    appId: '1:315759816883:ios:36a369ff1da8885d4800c6',
    messagingSenderId: '315759816883',
    projectId: 'mishi-flutter',
    storageBucket: 'mishi-flutter.appspot.com',
    androidClientId: '315759816883-88minkn5s4anrgbkvi2rbmftp9fi961b.apps.googleusercontent.com',
    iosClientId: '315759816883-3u56t55ck5fqiesg7skmagdg8ivtvrma.apps.googleusercontent.com',
    iosBundleId: 'com.wolfpack.mishi.mishi',
  );
}
