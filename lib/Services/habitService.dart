import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'notification_service.dart' as Notif;

Stream<QuerySnapshot> getHabits() {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  Stream<QuerySnapshot> query = userDoc.collection('habits').snapshots();
  return query;
}

Future<DocumentReference> createHabit(
    String title, TimeOfDay reminder, String frequency,
    {bool setReminder = true, String day}) async {
  int notifId = 0;
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

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

Future<DocumentReference> onCheckHabit(
    String habitId, List<dynamic> daysCompleted) async {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int idx = daysCompleted.indexOf(today.toString());

  if (idx == -1) {
    //append the date
    daysCompleted.add(today.toString());
  } else {
    //remove the date
    daysCompleted.removeAt(idx);
  }

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

// void onCheckHabit(String habitId) {}
// void onCheckTask(String habitId, bool checkedValue) {
//   String email = AuthService.getUserEmail();

//   DocumentReference userDoc =
//       FirebaseFirestore.instance.collection('users').doc(email);
//   userDoc.collection('habits').doc(taskId).update({
//     'isChecked': checkedValue,
//   });
// }
