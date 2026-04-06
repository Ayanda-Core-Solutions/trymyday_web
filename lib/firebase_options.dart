import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRdRzzrH_yVfIrh-76m4Qax0be4OmrwVA',
    appId: '1:87113022489:web:abb441a9e2a5bafe06fe88',
    messagingSenderId: '87113022489',
    projectId: 'trymyday-1d798',
    authDomain: 'trymyday-1d798.firebaseapp.com',
    storageBucket: 'trymyday-1d798.firebasestorage.app',
    measurementId: 'G-H4YPHCC5J6',
  );
}
