import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Future<DocumentReference> getUserDocRef() async {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  return userDoc;
}

Future<Map<String, String>> getUserInfo() async {
  //birthdate. dateJoined, email, gender,name, photo
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
