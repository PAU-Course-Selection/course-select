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
    apiKey: 'AIzaSyDWpxrg1_ROA3nCQ1ODjzT6uJc9LfxY5_Y',
    appId: '1:617046418437:web:db8ff1a6974bcccbe9686c',
    messagingSenderId: '617046418437',
    projectId: 'agileproject-76bf9',
    authDomain: 'agileproject-76bf9.firebaseapp.com',
    storageBucket: 'agileproject-76bf9.appspot.com',
    measurementId: 'G-PXH3YPY9M2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABB2f_W5Ks-mjwLTHFZABX3jnYFJj6PXU',
    appId: '1:617046418437:android:a02bc54153882e58e9686c',
    messagingSenderId: '617046418437',
    projectId: 'agileproject-76bf9',
    storageBucket: 'agileproject-76bf9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhdgoC7cvo8jjbWxOByXWHz8_yd3QglAg',
    appId: '1:617046418437:ios:3566d58cde50de64e9686c',
    messagingSenderId: '617046418437',
    projectId: 'agileproject-76bf9',
    storageBucket: 'agileproject-76bf9.appspot.com',
    iosClientId: '617046418437-pb1cqmterip66ld7d3vp2fqfggq0ufou.apps.googleusercontent.com',
    iosBundleId: 'pau.agile.aber.courseSelect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAhdgoC7cvo8jjbWxOByXWHz8_yd3QglAg',
    appId: '1:617046418437:ios:810fb21e0b9ced03e9686c',
    messagingSenderId: '617046418437',
    projectId: 'agileproject-76bf9',
    storageBucket: 'agileproject-76bf9.appspot.com',
    iosClientId: '617046418437-dpemtmofvco26mt61ifc82pu023b8csj.apps.googleusercontent.com',
    iosBundleId: 'pau.agile.app',
  );
}
