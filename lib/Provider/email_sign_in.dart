import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailSignInProvider extends ChangeNotifier {
  // final googleSignIn = GoogleSignIn();
  bool _isSigningIn;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  EmailSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print(user);
    return;
  }

  void register(String name, String email, String password, String gender,
      String dob) async {
    final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (newUser != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Future<DocumentReference> query = firestore.collection('users').doc(email)
        .set({
        'name': name,
        'email': email,
        'birthdate': dob,
        'gender': gender,
        'dateJoined': DateTime.now().toString(),
        'profileURL':
            "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-image-user-vector-179390926.jpg"
      });
      print(query);
    }
  }

  void logout() async {
    await _firebaseAuth.signOut();
  }
}
