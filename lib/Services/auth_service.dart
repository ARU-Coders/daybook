import 'package:firebase_auth/firebase_auth.dart';
// import 'package:daybook/provider/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'db_services.dart';

String getUserEmail() {
  User user = FirebaseAuth.instance.currentUser;

  if (user.email != null) {
    return user.email;
  }
  return null;
}
