import 'package:daybook/Provider/google_sign_in.dart';
import 'package:daybook/Provider/email_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Pages/start.dart';
import 'Pages/signup.dart';
import 'Pages/login.dart';
import 'Pages/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Daybook';

  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        // providers: [
        //   ChangeNotifierProvider<GoogleSignInProvider>(create: (context) {
        //     return GoogleSignInProvider();
        //   }),
        //   ChangeNotifierProvider<EmailSignInProvider>(create: (context) {
        //     return EmailSignInProvider();
        //   }),
        // ],
        // child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: StartPage(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => StartPage(),
        '/signup': (BuildContext context) => Signup(),
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
      },
    );
    // ,);
  }
}
