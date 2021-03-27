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

Future<DocumentReference> createHabit(String title, TimeOfDay reminder,
    {bool setReminder = true}) async {
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  DocumentReference randomDoc = userDoc.collection('habits').doc();

  String docId = randomDoc.id;
  String reminderTimString =
      reminder.hour.toString() + ":" + reminder.minute.toString();

  DateTime now = new DateTime.now();
  final _ = await userDoc.collection('habits').doc(docId).set({
    'title': title,
    'dateCreated': now.toString(),
    'dateLastModified': now.toString(),
    'frequency': 'daily',
    'reminder': reminderTimString,
    'habitId': docId,
    'daysComleted': []
  });

  DocumentReference query = userDoc.collection('habits').doc(docId);
  if (setReminder) {
    final notification = Notif.Notification();
    notification.scheduleNotificationForHabit(
        reminder, title, "This is your daily reminder");
  }
  return query;
}

Future<DocumentReference> markADone(String habitId) async {
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  DateTime now = new DateTime.now();
  final _ = await userDoc.collection('habits').doc(habitId).set({
    'dateLastModified': now.toString(),
    'daysComleted': FieldValue.arrayUnion([now.toString])
  });

  DocumentReference query = userDoc.collection('habits').doc(habitId);
  return query;
}

void deleteHabit(DocumentSnapshot documentSnapshot) async {
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}
