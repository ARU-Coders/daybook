import 'package:firebase_auth/firebase_auth.dart';

// import 'package:daybook/provider/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'db_services.dart';
class AuthService {
  static String email;
  static String getUserEmail() {
    User user = FirebaseAuth.instance.currentUser;

    // if (user.email != null) {
    return (email == null) ? user.email : email;
    // }
    // return null;
  }

  static void updateEmail() {
    email = FirebaseAuth.instance.currentUser.email;
  }
}
