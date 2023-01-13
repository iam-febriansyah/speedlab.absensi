// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/api/api_service.dart';
import 'package:flutter_application_1/firebase/firebase_config.dart';
import 'package:flutter_application_1/pages/auth/splashscreen.dart';
import 'package:flutter_application_1/firebase/notification_helper.dart';
import 'package:flutter_application_1/provider/provider.cabang.dart';
import 'package:flutter_application_1/provider/provider.login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await onStartFcm();
  runFcm();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print('Handling a background message ${message.messageId}');
}

void onStartFcm() async {
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
          options: DefaultFirebaseConfig.platformOptions);
    } else if (Platform.isIOS) {
      await Firebase.initializeApp(
          name: 'speed-erp', options: DefaultFirebaseConfig.platformOptions);
    }
    print("Run Firebase");
  } catch (e) {
    print(e.toString());
  }
}

void runFcm() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DevService _devService = DevService();
  final firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message.toMap().toString());
    NotificationHelper _notificationHelper = NotificationHelper();
    await _notificationHelper.showNotification(
        message.notification?.title ?? "",
        message.notification?.body ?? "",
        flutterLocalNotificationsPlugin);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final NotificationHelper _notificationHelper = NotificationHelper();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  firebaseMessaging.getToken().then((tk) async {
    var token = tk;
    print("UPDATE TOKEN FCM : ${token}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN");
    if (accesToken != "" && accesToken != null) {
      _devService.updateTokenFirebase(accesToken, token).then((value) async {
        var res = json.decode(value);
        if (res['status_json'] != true) {
          Toast.show(res['remarks'], duration: 4, gravity: Toast.bottom);
        }
      }).catchError((Object obj) {
        Toast.show("Gagal Update Token!", duration: 4, gravity: Toast.bottom);
      });
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderLogin(devService: DevService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProviderCabang(devService: DevService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Speederp for Employee',
        home: SplashScreen(),
      ),
    );
  }
}
