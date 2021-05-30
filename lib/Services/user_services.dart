import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Future<DocumentReference> getUserDocRef() async {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  return userDoc;
}

Future<Map<String, String>> getUserInfo() async {
  //birthdate. dateJoined, email, gender,name, photo, type
  DocumentReference userDoc = await getUserDocRef();

  Map<String, String> user = Map();
  if (AuthService.getUserEmail() != null) {
    DocumentSnapshot doc = await userDoc.get();
    user['name'] = doc['name'];
    user['email'] = doc['email'];
    user['gender'] = doc['gender'];
    user['photo'] = doc['photo'];
    user['dateJoined'] = doc['dateJoined'];
    user['birthdate'] = doc['birthdate'];
  }
  print("Services ka user:");
  print(user);
  return user;
}

Future<DocumentSnapshot> getUserProfile() async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.get();
  return doc;
}

Future<Stream<DocumentSnapshot>> getUserProfileStream() async {
  DocumentReference userDoc = await getUserDocRef();
  Stream<DocumentSnapshot> stream = userDoc.snapshots();
  return stream;
}

Future<void> editProfile(
    String name,
    String birthdate,
    String gender)async{
  DocumentReference userDoc = await getUserDocRef();
  
  Future<void> _ = userDoc.update({
    'name': name,
    'gender': gender,
    'birthdate': birthdate
  });
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
