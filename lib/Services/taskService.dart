import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
// import 'dart:io';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

Stream<QuerySnapshot> getTasks() {
  Stream<QuerySnapshot> query = userDoc
      .collection('tasks')
      .orderBy('isChecked')
      .orderBy('dueDate')
      .snapshots();
  return query;
}

Future<DocumentSnapshot> getTask(String taskId) async {
  DocumentSnapshot doc = await userDoc.collection('tasks').doc(taskId).get();
  return doc;
}

Future<DocumentReference> createTask(String title, DateTime dueDate) async {
  DocumentReference randomDoc = userDoc.collection('tasks').doc();
  String docId = randomDoc.id;

  DateTime now = new DateTime.now();
  final _ = await userDoc.collection('tasks').doc(docId).set({
    'title': title,
    'dateCreated': now.toString(),
    'dateLastModified': now.toString(),
    'dueDate': dueDate.toString(),
    'isChecked': false,
    'taskId': docId
  });

  DocumentReference query = userDoc.collection('tasks').doc(docId);
  return query;
}

Future<void> editTask(String taskId, String title, DateTime dueDate) async {
  DateTime now = new DateTime.now();
  Future<void> _ = userDoc.collection('tasks').doc(taskId).update({
    'title': title,
    'dateLastModified': now.toString(),
    'dueDate': dueDate.toString()
  });
}

void onCheckTask(String taskId, bool checkedValue) {
  userDoc.collection('tasks').doc(taskId).update({
    'isChecked': checkedValue,
  });
}

void deleteTask(DocumentSnapshot documentSnapshot) async {
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}
