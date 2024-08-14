// ignore_for_file: file_names
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// 
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
      apiKey: "AIzaSyBevn7kkdLhblWAVvG6lhLYoDk7C12LPKA",
      authDomain: "myapiprojects-425308.firebaseapp.com",
      projectId: "myapiprojects-425308",
      storageBucket: "myapiprojects-425308.appspot.com",
      messagingSenderId: "1028914323103",
      appId: "1:1028914323103:web:760480d896f0aeb937ccaa",
  );

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: "AIzaSyBevn7kkdLhblWAVvG6lhLYoDk7C12LPKA",
      authDomain: "myapiprojects-425308.firebaseapp.com",
      projectId: "myapiprojects-425308",
      storageBucket: "myapiprojects-425308.appspot.com",
      messagingSenderId: "1028914323103",
      appId: "1:1028914323103:web:760480d896f0aeb937ccaa",

  );

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: "AIzaSyBevn7kkdLhblWAVvG6lhLYoDk7C12LPKA",
      authDomain: "myapiprojects-425308.firebaseapp.com",
      projectId: "myapiprojects-425308",
      storageBucket: "myapiprojects-425308.appspot.com",
      messagingSenderId: "1028914323103",
      appId: "1:1028914323103:web:760480d896f0aeb937ccaa",
  );

  
}