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
    apiKey: 'AIzaSyCsctjfr625qh_ysVkubWAFMaSVUQnU3yA',
    appId: '1:874488696906:web:455a11dbf42566b4bcd6b3',
    messagingSenderId: '874488696906',
    projectId: 'geotask-8889d',
    authDomain: 'geotask-8889d.firebaseapp.com',
    storageBucket: 'geotask-8889d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAassxHc56xDY0dtDE4WvbhahWPBwE8UI4',
    appId: '1:874488696906:android:b63cb33c0f68268ebcd6b3',
    messagingSenderId: '874488696906',
    projectId: 'geotask-8889d',
    storageBucket: 'geotask-8889d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTtjnjyIJeiJEvDNHuGmws8qbw3LxgeBc',
    appId: '1:874488696906:ios:a709329e04cc41e0bcd6b3',
    messagingSenderId: '874488696906',
    projectId: 'geotask-8889d',
    storageBucket: 'geotask-8889d.appspot.com',
    iosBundleId: 'com.example.geotask',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTtjnjyIJeiJEvDNHuGmws8qbw3LxgeBc',
    appId: '1:874488696906:ios:4e2cb4b969904ccbbcd6b3',
    messagingSenderId: '874488696906',
    projectId: 'geotask-8889d',
    storageBucket: 'geotask-8889d.appspot.com',
    iosBundleId: 'com.example.geotask.RunnerTests',
  );
}
