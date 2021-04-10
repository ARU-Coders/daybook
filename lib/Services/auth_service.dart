import 'package:firebase_auth/firebase_auth.dart';

/// A service to get email of logged in user
///
class AuthService {
  static String email;
  static String getUserEmail() {
    User user = FirebaseAuth.instance.currentUser;
    return (email == null) ? user.email : email;
  }

  static void updateEmail() {
    email = FirebaseAuth.instance.currentUser.email;
  }
}
