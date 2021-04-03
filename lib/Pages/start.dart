import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Pages/home.dart';
import 'Authentication/login.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(create: (context) {
              return GoogleSignInProvider();
            }),
            ChangeNotifierProvider<EmailSignInProvider>(create: (context) {
              return EmailSignInProvider();
            }),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xfff9f9f9),
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final googleProvider =
                    Provider.of<GoogleSignInProvider>(context);
                final emailProvider = Provider.of<EmailSignInProvider>(context);
                bool isSigningIn =
                    googleProvider.isSigningIn || emailProvider.isSigningIn;
                if (isSigningIn) {
                  return buildLoading();
                } else if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return LoginPage();
                }
              },
            ),
          ));
  // );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );
}
