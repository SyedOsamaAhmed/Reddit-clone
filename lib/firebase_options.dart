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
        return macos;
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
    apiKey: 'AIzaSyCvTzm2CspHMUP1BqQYIg1ykIdUpoIPCas',
    appId: '1:916547961165:web:195ab4eae945379e94b704',
    messagingSenderId: '916547961165',
    projectId: 'reddit-clone-a9b86',
    authDomain: 'reddit-clone-a9b86.firebaseapp.com',
    storageBucket: 'reddit-clone-a9b86.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPR1zSgOdEmd61ipRBSjWxciRF42gRCUw',
    appId: '1:916547961165:android:86cb1c93911a038a94b704',
    messagingSenderId: '916547961165',
    projectId: 'reddit-clone-a9b86',
    storageBucket: 'reddit-clone-a9b86.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVNVKsJu6V8YKAJF8NLAMSGhe7AmeABxo',
    appId: '1:916547961165:ios:74fc3e351338239b94b704',
    messagingSenderId: '916547961165',
    projectId: 'reddit-clone-a9b86',
    storageBucket: 'reddit-clone-a9b86.appspot.com',
    iosClientId: '916547961165-rql0h23l95si4tlu1f3u0o70uot4kc2c.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVNVKsJu6V8YKAJF8NLAMSGhe7AmeABxo',
    appId: '1:916547961165:ios:d233533922caa8c094b704',
    messagingSenderId: '916547961165',
    projectId: 'reddit-clone-a9b86',
    storageBucket: 'reddit-clone-a9b86.appspot.com',
    iosClientId: '916547961165-khuhg42q6e23f7gu7emfl607qcpbavqt.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone.RunnerTests',
  );
}
