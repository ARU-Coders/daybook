import 'package:daybook/Pages/create_entry.dart';
import 'package:daybook/Pages/create_journey.dart';
import 'package:daybook/Pages/display_entry.dart';
import 'package:daybook/Pages/display_journey.dart';
import 'package:daybook/Pages/select_entries.dart';
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
      theme: ThemeData(
          primarySwatch: MaterialColor(0xff8ebbf2, {
            50: Color.fromRGBO(4, 131, 184, .1),
            100: Color.fromRGBO(4, 131, 184, .2),
            200: Color.fromRGBO(4, 131, 184, .3),
            300: Color.fromRGBO(4, 131, 184, .4),
            400: Color.fromRGBO(4, 131, 184, .5),
            500: Color.fromRGBO(4, 131, 184, .6),
            600: Color.fromRGBO(4, 131, 184, .7),
            700: Color.fromRGBO(4, 131, 184, .8),
            800: Color.fromRGBO(4, 131, 184, .9),
            900: Color.fromRGBO(4, 131, 184, 1),
          }),
          backgroundColor: Color(0xffFFD1DC) // pink
          // Color(0xffd9dde9) --> grey
          // Color(0xff8ebbf2)--> blue
          ),
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
        '/selectEntries': (BuildContext context) => SelectEntriesScreen(),
      },
    );
    // ,);
  }
}
