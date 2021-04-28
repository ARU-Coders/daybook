import 'package:daybook/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:daybook/Services/auth_service.dart';
/*
GET https://people.googleapis.com/v1/people/me?personFields=genders%2Cbirthdays&key=[YOUR_API_KEY] HTTP/1.1

Authorization: Bearer [YOUR_ACCESS_TOKEN]
Accept: application/json
*/

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final apiKey = "";
  final googleSignIn = GoogleSignIn(scopes: [
    'email',
    "https://www.googleapis.com/auth/userinfo.profile",
    "https://www.googleapis.com/auth/user.birthday.read",
    "https://www.googleapis.com/auth/user.gender.read"
  ]);
  final googleSignInForLogin = GoogleSignIn();
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

    final user = await googleSignInForLogin.signIn();

    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      print(user);

      final googleAuth = await user.authentication;

      // String accTok = googleAuth.accessToken.toString();
      // await getGenderAndDOB(accTok);

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final doc = firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (doc != null) {
        await FirebaseAuth.instance.signInWithCredential(credential);
        final _ = AuthService.updateEmail();
      }
      isSigningIn = false;
    }
  }

  Future<List<String>> getGenderAndDOB(String accessToken) async {
    final headers = await googleSignIn.currentUser.authHeaders;
    String dd = "01", mm = "01", yyyy = "2000", gender = "Not Set";
    final r = await http.get(
        "https://people.googleapis.com/v1/people/me?personFields=genders,birthdays&key=$apiKey&access_token=$accessToken",
        headers: {"Authorization": headers["Authorization"]});
    final response = jsonDecode(r.body);
    print(response);

    if (response.containsKey("genders")) {
      gender = response["genders"][0]["formattedValue"].toString();
    }

    if (response.containsKey("birthdays")) {
      dd = response["birthdays"][0]["date"].containsKey("day")
          ? response["birthdays"][0]["date"]["day"].toString()
          : '01';
      mm = response["birthdays"][0]["date"].containsKey("month")
          ? response["birthdays"][0]["date"]["month"].toString()
          : '01';
      yyyy = response["birthdays"][0]["date"].containsKey("year")
          ? response["birthdays"][0]["date"]["year"].toString()
          : '2000';
    }

    String dob = yyyy + "-" + mm + "-" + dd;

    print("DOB\t$dob\tGENDER\t$gender");
    return [gender, dob];
  }

  Future<bool> registerWithGoogle() async {
    //Returns true if the sign up process is completed and all user details are stored in respective collection
    //Else, returns false
    isSigningIn = true;

    final user = await googleSignIn.signIn();

    if (user == null) {
      //No user returned by the googleSignIn method, returning false
      isSigningIn = false;
      return false;
    } else {
      final googleAuth = await user.authentication;

      String accessToken = googleAuth.accessToken.toString();

      //Gets gender and Date of birth from user's Google profile
      //Eg: genderAndDOB = ["Male", "15/08/1947"];
      List<String> genderAndDOB = await getGenderAndDOB(accessToken);

      final gender = genderAndDOB[0];
      final dob = genderAndDOB[1];

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //Check if the user details are already stored in the firestore.
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot doc =
          await firestore.collection('users').doc(user.email).get();

      if (doc == null || !doc.exists) {
        //No details are returned which indicates that the account was not used for registration previously.

        //Add user
        await FirebaseAuth.instance.signInWithCredential(credential);

        //Save user details
        addUserToFirestore(user, gender, dob);
        final _ = AuthService.updateEmail();
      } else {
        //Todo:
        //Handle registering with existing email address
        print(doc["email"].toString());
        print("User Already Exists !");
      }
      isSigningIn = false;
    }
  }

  void addUserToFirestore(user, gender, dob) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    users
        .doc(user.email)
        .set({
          'name': user.displayName,
          'email': user.email,
          'photo': user.photoUrl,
          'gender': gender,
          'birthdate': dob,
          'dateJoined': DateTime.now().toString(),
          'type': 'google'
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void logout() async {
    //Handle email logout separately
    // setUserEmail("");
    await googleSignInForLogin.disconnect();
    await _firebaseAuth.signOut();
  }
}
