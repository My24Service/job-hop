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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyCuHYFw3WpdN8oG6Bjmbn8I-2uNbOLQXh0',
    appId: '1:517264982158:android:46dee22c81fa059975c9df',
    messagingSenderId: '517264982158',
    projectId: 'job-hop-314508',
    storageBucket: 'job-hop-314508.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0NY3fnmcIiCqhOVv3-Y5jz1-LL-F-X9M',
    appId: '1:517264982158:ios:2a710fa901f1c69675c9df',
    messagingSenderId: '517264982158',
    projectId: 'job-hop-314508',
    storageBucket: 'job-hop-314508.appspot.com',
    androidClientId: '517264982158-8pli42ge832ap4l6iqsfs757pegg5gjk.apps.googleusercontent.com',
    iosClientId: '517264982158-f756k4c39rtsepdq7oacp8huip6vji5j.apps.googleusercontent.com',
    iosBundleId: 'com.jobhop.app.jobhop',
  );
}
