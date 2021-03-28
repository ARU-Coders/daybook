import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Notification() {
    initializeNotification();
  }
  Future onSelectNotification(String notifId) async {
    await cancelNotification(int.parse(notifId));
    print("Notif canceled");
    return "Notif canceled";
  }

  void initializeNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> cancelNotification(int notifId) async {
    await flutterLocalNotificationsPlugin.cancel(notifId);
  }

  Future<int> scheduleNotificationForHabit(TimeOfDay scheduledNotificationTime,
      String notifTitle, String notifSubtitle) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '2', 'Habit', 'Reminders of Habit',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    int notifId = DateTime.now().millisecondsSinceEpoch % 10000;
    Time scheduleTime = Time(
      scheduledNotificationTime.hour,
      scheduledNotificationTime.minute,
    );
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      notifId,
      notifTitle,
      notifSubtitle,
      scheduleTime,
      platformChannelSpecifics,
      payload: notifId.toString(),
    );
    print("Notif scheduled");
    return notifId;
  }
}
