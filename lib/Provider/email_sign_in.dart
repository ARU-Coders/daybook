import 'package:daybook/Services/auth_service.dart';
import 'package:daybook/Utils/constants.dart';
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

  Future<void> login({
    @required String email, 
    @required String password,
    @required Function successCallback,
    @required Function errorCallback}
    ) async {
      try{
        final user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        final _ = AuthService.updateEmail();
        successCallback();
        print(user);
      }catch(e){
        print("Error during login with email.");
        String errorMessage = "Some error occured! Please check your internet connection.";
        if(e is FirebaseAuthException){
          errorMessage = authExceptionMessageMap[e.code];
          print(e);
          print(e.code);
        }
        errorCallback(errorMessage);
      }
  }

  Future<String> register({
    @required String name, 
    @required String email, 
    @required String password,
    @required String gender, 
    @required String dob,
    @required Function successCallback,
    @required Function errorCallback}
    ) async {
    try {
      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        Future<void> _ = firestore.collection('users').doc(email).set({
          'name': name,
          'email': email,
          'birthdate': dob,
          'gender': gender,
          'dateJoined': DateTime.now().toString(),
          'photo':
              "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-image-user-vector-179390926.jpg",
          'type': 'email'
        });
        final __ = AuthService.updateEmail();
        return "Success !";
      }
      return "Cannot create account !";
    } catch (e) {
      print(e);
      return "Error!";
    }
  }

  void logout() async {
    // setUserEmail("");
    await _firebaseAuth.signOut();
  }
}
