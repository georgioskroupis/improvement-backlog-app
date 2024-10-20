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
    apiKey: 'AIzaSyAITXaCkZPlmPmz697opP6xiK9N7UGz_fE',
    appId: '1:281294955643:web:8d8f62386e608d95822ede',
    messagingSenderId: '281294955643',
    projectId: 'improvement-backlog-database',
    authDomain: 'improvement-backlog-database.firebaseapp.com',
    storageBucket: 'improvement-backlog-database.appspot.com',
    measurementId: 'G-EVQN4V233V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTvqB74C0AQlkbVG_kteQqizXcwPFhf0E',
    appId: '1:281294955643:android:1ee4ab18a986687d822ede',
    messagingSenderId: '281294955643',
    projectId: 'improvement-backlog-database',
    storageBucket: 'improvement-backlog-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2-pxI1vk8FTs5n1ky6-Dt_EZVlpv9Bfw',
    appId: '1:281294955643:ios:f97c17545637db4a822ede',
    messagingSenderId: '281294955643',
    projectId: 'improvement-backlog-database',
    storageBucket: 'improvement-backlog-database.appspot.com',
    iosBundleId: 'com.example.improvementBacklogAppMvc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2-pxI1vk8FTs5n1ky6-Dt_EZVlpv9Bfw',
    appId: '1:281294955643:ios:f97c17545637db4a822ede',
    messagingSenderId: '281294955643',
    projectId: 'improvement-backlog-database',
    storageBucket: 'improvement-backlog-database.appspot.com',
    iosBundleId: 'com.example.improvementBacklogAppMvc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAITXaCkZPlmPmz697opP6xiK9N7UGz_fE',
    appId: '1:281294955643:web:b6f401866969ea2c822ede',
    messagingSenderId: '281294955643',
    projectId: 'improvement-backlog-database',
    authDomain: 'improvement-backlog-database.firebaseapp.com',
    storageBucket: 'improvement-backlog-database.appspot.com',
    measurementId: 'G-F8B1KBS9G7',
  );
}
