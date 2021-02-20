import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
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

  Future<UserCredential> login(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<UserCredential> register(String name, String email, String password,
      String gender, String dob) async {
    final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (newUser!=null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Future<DocumentReference> query = firestore.collection('users').add({
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
    return newUser;
  }

  // void addUserToFirestore(user) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   //Check if document with id=user.email exists in the users collection
  //   final snapShot = await firestore.collection('users').doc(user.email).get();

  //   //If not, create a new document with id=email, and store user data (name, email and profileUrl) in it
  //   if (!snapShot.exists || snapShot == null) {
  //     CollectionReference users = firestore.collection('users');
  //     users
  //         .doc(user.email)
  //         .set({
  //           'name': user.displayName,
  //           'email': user.email,
  //           'photo': user.photoUrl,
  //           'dateJoined': DateTime.now().toString()
  //         })
  //         .then((value) => print("User Added"))
  //         .catchError((error) => print("Failed to add user: $error"));
  //     // Document with id == docId doesn't exist.
  //   }
  // }

  // Future login() async {
  //   isSigningIn = true;

  //   // final user = await googleSignIn.signIn();
  //   if (user == null) {
  //     isSigningIn = false;
  //     return;
  //   } else {
  //     final googleAuth = await user.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     addUserToFirestore(user);
  //     isSigningIn = false;
  //   }
  // }

  // void logout() async {
  //   await googleSignIn.disconnect();
  //   FirebaseAuth.instance.signOut();
  // }
}
