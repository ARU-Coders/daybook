import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'db_services.dart';

Stream<QuerySnapshot> getTasks() {
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  Stream<QuerySnapshot> query = userDoc
      .collection('tasks')
      .orderBy('isChecked')
      .orderBy('dueDate')
      .snapshots();
  return query;
}

Future<DocumentSnapshot> getTask(String taskId) async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.collection('tasks').doc(taskId).get();
  return doc;
}

Future<DocumentReference> createTask(String title, DateTime dueDate) async {
  DocumentReference userDoc = await getUserDocRef();

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
  DocumentReference userDoc = await getUserDocRef();

  DateTime now = new DateTime.now();
  Future<void> _ = userDoc.collection('tasks').doc(taskId).update({
    'title': title,
    'dateLastModified': now.toString(),
    'dueDate': dueDate.toString()
  });
}

Future<void> onCheckTask(String taskId, bool checkedValue) async {
  DocumentReference userDoc = await getUserDocRef();
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
