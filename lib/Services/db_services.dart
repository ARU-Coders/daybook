import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'package:intl/intl.dart';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

Future<Map<String, String>> getUserInfo() async {
  //birthdate. dateJoined, email, gender,name, photo

  Map<String, String> user = Map();
  if (email != null) {
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

Stream<QuerySnapshot> getEntries() {
  Stream<QuerySnapshot> query = userDoc.collection('entries').snapshots();
  return query;
}

Future<DocumentSnapshot> getEntry(String entryId) async {
  DocumentSnapshot doc = await userDoc.collection('entries').doc(entryId).get();
  return doc;
}

void createEntry(String title, String content) {
  DateTime now = new DateTime.now();
  Future<DocumentReference> query = userDoc.collection('entries').add({
    'title': title,
    'content': content,
    'dateCreated': DateTime(now.year, now.month, now.day).toString(),
    'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
  });
  print(query);
}
