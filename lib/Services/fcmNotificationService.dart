import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  //TODO: Fix local notifications

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print("onBackgroundMessage: $message");
  }

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
      // _fcm.requestNotificationPermissions(IosNotificationSettings())
    }

    

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    // );
  }
}