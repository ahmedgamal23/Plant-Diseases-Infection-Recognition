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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAbFmU461GU72U2zOBZwCTlhdcMapW6aA0',
    appId: '1:353714448499:web:d1182107b6269e0900a206',
    messagingSenderId: '353714448499',
    projectId: 'gp-plant-detection-project',
    authDomain: 'gp-plant-detection-project.firebaseapp.com',
    storageBucket: 'gp-plant-detection-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpUVdMjo_n8WRT0WsoqEc9v9RvqrTedEo',
    appId: '1:353714448499:android:861f15ec8b9e1daf00a206',
    messagingSenderId: '353714448499',
    projectId: 'gp-plant-detection-project',
    storageBucket: 'gp-plant-detection-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzyjvVqGD2o7fnUf58A-gA5WW2HiC2AZI',
    appId: '1:353714448499:ios:3c980bcd0053336900a206',
    messagingSenderId: '353714448499',
    projectId: 'gp-plant-detection-project',
    storageBucket: 'gp-plant-detection-project.appspot.com',
    iosBundleId: 'com.example.plantInfectionRecognition',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzyjvVqGD2o7fnUf58A-gA5WW2HiC2AZI',
    appId: '1:353714448499:ios:3c980bcd0053336900a206',
    messagingSenderId: '353714448499',
    projectId: 'gp-plant-detection-project',
    storageBucket: 'gp-plant-detection-project.appspot.com',
    iosBundleId: 'com.example.plantInfectionRecognition',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbFmU461GU72U2zOBZwCTlhdcMapW6aA0',
    appId: '1:353714448499:web:37f5aae7d6283a0700a206',
    messagingSenderId: '353714448499',
    projectId: 'gp-plant-detection-project',
    authDomain: 'gp-plant-detection-project.firebaseapp.com',
    storageBucket: 'gp-plant-detection-project.appspot.com',
  );
}