import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      print("Null user");
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      addUserToFirestore(user);
      isSigningIn = false;
    }
  }

  void addUserToFirestore(user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //Check if document with id=user.email exists in the users collection
    final snapShot = await firestore.collection('users').doc(user.email).get();

    //If not, create a new document with id=email, and store user data (name, email and profileUrl) in it
    if (!snapShot.exists || snapShot == null) {
      CollectionReference users = firestore.collection('users');
      users
          .doc(user.email)
          .set({
            'name': user.displayName,
            'email': user.email,
            'photo': user.photoUrl,
            'dateJoined': DateTime.now().toString()
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      // Document with id == docId doesn't exist.
    }
  }

  void logout() async {
    // await googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
