import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  Map<String, int> dayMap = {
    'Sunday': 0,
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6
  };

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

  Future<int> scheduleNotificationForHabit(
      String frequency,
      TimeOfDay scheduledNotificationTime,
      String notifTitle,
      String notifSubtitle,
      {String day}) async {
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

    if (frequency == 'Daily') {
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        notifId,
        notifTitle,
        notifSubtitle,
        scheduleTime,
        platformChannelSpecifics,
        payload: notifId.toString(),
      );
      print("Daily Notif scheduled");
    } else {
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        notifId,
        notifTitle,
        notifSubtitle,
        Day(dayMap[day]),
        scheduleTime,
        platformChannelSpecifics,
        payload: notifId.toString(),
      );
      print(Day(dayMap[day]).toString());
      print("Weekly Notif scheduled");
    }
    return notifId;
  }
}
