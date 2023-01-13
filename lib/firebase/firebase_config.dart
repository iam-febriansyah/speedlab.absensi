import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS || Platform.isMacOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyCQYh580tiHLQcpZRP76j8qQSNAQlqJLFQ',
        appId: '1:1025744356973:ios:46b4ca56bbe33e6eb56164',
        messagingSenderId: '1025744356973',
        projectId: 'speedlab-lentera',
      );
    } else {
      ///android
      return const FirebaseOptions(
        apiKey: 'AIzaSyCQYh580tiHLQcpZRP76j8qQSNAQlqJLFQ',
        appId: '1:1025744356973:android:e0c6a7ee1431d7eeb56164',
        messagingSenderId: '1025744356973',
        projectId: 'speedlab-lentera',
      );
    }
  }
}
