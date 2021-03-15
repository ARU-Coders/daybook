import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

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
