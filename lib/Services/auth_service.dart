import 'package:daybook/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'db_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service to get and update `email` and `type` of logged in user
class AuthService {
  static String email;
  static String getUserEmail() {
    User user = FirebaseAuth.instance.currentUser;
    return (email == null) ? user.email : email;
  }

  static Future<String> getUserType() async {
    // String email = getUserEmail();
    DocumentReference userDoc = await getUserDocRef();
    DocumentSnapshot ds = await userDoc.get(); //query
    String type = ds['type'].toString();
    return type;
  }

  static void updateEmail() {
    email = FirebaseAuth.instance.currentUser.email;
  }
}

  bool isValidEmail(email) => RegExp(EMAIL_REGEX).hasMatch(email);
