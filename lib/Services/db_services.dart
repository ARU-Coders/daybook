import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Future<Map<String, String>> getUserInfo() async {
  //birthdate. dateJoined, email, gender,name, photo
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
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
  String email = AuthService.getUserEmail();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  // final userInfo = await getUserInfo();
  DocumentSnapshot doc = await userDoc.get();
  return doc;
}
