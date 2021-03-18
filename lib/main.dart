import 'package:daybook/Pages/create_entry.dart';
import 'package:daybook/Pages/create_journey.dart';
import 'package:daybook/Pages/display_entry.dart';
import 'package:daybook/Pages/display_journey.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: StartPage(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => StartPage(),
        '/signup': (BuildContext context) => Signup(),
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/createEntry': (BuildContext context) => CreateEntryScreen(),
        '/createJourney': (BuildContext context) => CreateJourneyScreen(),
        '/displayEntry': (BuildContext context) => DisplayEntryScreen(),
        '/displayJourney': (BuildContext context) => DisplayJourneyScreen(),
      },
    );
    // ,);
  }
}
