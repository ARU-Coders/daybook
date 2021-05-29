import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignupButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (BuildContext context) => GoogleSignInProvider(),
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // final provider = Provider.of<GoogleSignInProvider>(context);
            return Container(
              padding: EdgeInsets.all(4),
              child: RaisedButton.icon(
                label: Text(
                  "Register with Google",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color(0xffd68598)),
                ),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                highlightElevation: 1.5,
                highlightColor: Color(0xDAFFD1DC),
                color: Color(0xffFFD1DC ),
                // textColor: Colors.black,
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.black87,size: 18,),
                onPressed: () {
                  // provider.registerWithGoogle();
                },
              ),
            );
          }));
}
