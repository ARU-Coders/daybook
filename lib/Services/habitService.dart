import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'db_services.dart';
import 'notification_service.dart' as Notif;

Future<DocumentSnapshot> getHabit(String habitId) async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.collection('habits').doc(habitId).get();
  return doc;
}

Stream<QuerySnapshot> getHabits() {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  Stream<QuerySnapshot> query = userDoc.collection('habits').orderBy("dateCreated", descending: true).snapshots();
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
    String title, TimeOfDay reminder, String frequency, String habitColor,
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
      'notifId': notifId,
      'color': habitColor
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
      'notifId': notifId,
      'color': habitColor
    });
  }

  return query;
}

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
