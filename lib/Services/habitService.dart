import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'db_services.dart';
import 'notification_service.dart' as Notif;
import 'package:daybook/Models/habitSeries.dart';

Future<DocumentSnapshot> getHabit(String habitId) async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.collection('habits').doc(habitId).get();
  return doc;
}

Stream<QuerySnapshot> getHabits() {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  Stream<QuerySnapshot> query = userDoc.collection('habits').snapshots();
  return query;
}

Stream<DocumentSnapshot> getSingleHabitStream(String habitId) {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  Stream<DocumentSnapshot> query =
      userDoc.collection('habits').doc(habitId).snapshots();
  return query;
}

Future<DocumentReference> createHabit(
    String title, TimeOfDay reminder, String frequency,
    {bool setReminder = true, String day}) async {
  int notifId = 0;

  DocumentReference userDoc = await getUserDocRef();

  DocumentReference randomDoc = userDoc.collection('habits').doc();
  String docId = randomDoc.id;
  String reminderTimString =
      reminder.hour.toString() + ":" + reminder.minute.toString();

  DateTime now = new DateTime.now();

  DocumentReference query = userDoc.collection('habits').doc(docId);
  if (setReminder) {
    final notification = Notif.Notification();
    notifId = await notification.scheduleNotificationForHabit(
        frequency, reminder, title, "This is your $frequency reminder",
        day: day);
  }

  if (frequency == 'Daily') {
    final _ = await userDoc.collection('habits').doc(docId).set({
      'title': title,
      'dateCreated': now.toString(),
      'dateLastModified': now.toString(),
      'frequency': frequency,
      'reminder': reminderTimString,
      'habitId': docId,
      'daysCompleted': [],
      'notifId': notifId
    });
  } else {
    final _ = await userDoc.collection('habits').doc(docId).set({
      'title': title,
      'dateCreated': now.toString(),
      'dateLastModified': now.toString(),
      'frequency': frequency,
      'day': day,
      'reminder': reminderTimString,
      'habitId': docId,
      'daysCompleted': [],
      'notifId': notifId
    });
  }

  return query;
}

// Future<DocumentReference> onCheckHabit(
//     String habitId, List<dynamic> daysCompleted) async {
//   DocumentReference userDoc = await getUserDocRef();

//   DateTime today =
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

//   int idx = daysCompleted.indexOf(today.toString());

//   if (idx == -1) {
//     daysCompleted.add(today.toString());
//   } else {
//     daysCompleted.removeAt(idx);
//   }

//   final _ = await userDoc
//       .collection('habits')
//       .doc(habitId)
//       .update({'daysCompleted': daysCompleted});

//   DocumentReference query = userDoc.collection('habits').doc(habitId);
//   return query;
// }

Future<DocumentReference> markAsDone(
    String habitId, List<dynamic> daysCompleted, DateTime date) async {
  DocumentReference userDoc = await getUserDocRef();

  DateTime dateToAdd = DateTime(date.year, date.month, date.day);

  int idx = daysCompleted.indexOf(dateToAdd.toString());

  if (idx == -1) {
    daysCompleted.add(dateToAdd.toString());
  } else {
    daysCompleted.removeAt(idx);
  }
  daysCompleted.sort();
  final _ = await userDoc
      .collection('habits')
      .doc(habitId)
      .update({'daysCompleted': daysCompleted});

  DocumentReference query = userDoc.collection('habits').doc(habitId);
  return query;
}

void deleteHabit(DocumentSnapshot documentSnapshot) async {
  final notification = Notif.Notification();
  notification.cancelNotification(documentSnapshot['notifId']);
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}

Future<void> getHabitYearlyCount(String habitId) async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.collection('habits').doc(habitId).get();
  List<String> daysComp = List<String>.from(doc['daysCompleted']);
  Map<String, int> yearlyCount = {};

  for (String i in daysComp) {
    DateTime dt = DateTime.parse(i);
    if (yearlyCount.keys.contains(dt.year.toString())) {
      yearlyCount[dt.year.toString()]++;
    } else {
      yearlyCount[dt.year.toString()] = 1;
    }
  }
  print(yearlyCount);
  // return doc;
}

List<HabitSeries> getHabitMonthlyCount(days) {
  print("getHabitMonthlyCount called !");
  Map<String, String> monthMap = {
    '1': 'Jan',
    '2': 'Feb',
    '3': 'Mar',
    '4': 'Apr',
    '5': 'May',
    '6': 'Jun',
    '7': 'July',
    '8': 'Aug',
    '9': 'Sept',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec'
  };
  // DocumentReference userDoc = await getUserDocRef();
  // DocumentSnapshot doc = await userDoc.collection('habits').doc(habitId).get();
  List<String> daysComp = List<String>.from(days);
  Map<String, int> monthlyCount = {};

  for (String i in daysComp) {
    DateTime dt = DateTime.parse(i);
    if (monthlyCount.keys.contains(monthMap[dt.month.toString()])) {
      monthlyCount[monthMap[dt.month.toString()]]++;
    } else {
      monthlyCount[monthMap[dt.month.toString()]] = 1;
    }
  }
  final List<HabitSeries> monthlyData = [];
  for (var i in monthlyCount.keys) {
    monthlyData.add(new HabitSeries(habitCount: monthlyCount[i], xval: i));
  }
  print("Monthly Data:   " + monthlyData.toString());

  return monthlyData;
  // return doc;
}
