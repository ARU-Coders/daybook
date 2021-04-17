import 'package:daybook/Pages/Entries/create_entry.dart';
import 'package:daybook/Pages/Habits/create_habit.dart';
import 'package:daybook/Pages/Journeys/create_journey.dart';
import 'package:daybook/Pages/Entries/display_entry.dart';
import 'package:daybook/Pages/Journeys/display_journey.dart';
import 'package:daybook/Pages/Journeys/select_entries.dart';
import 'package:daybook/Pages/edit_profile.dart';
// import 'package:daybook/Pages/habit_stats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/Entries/ocr_entry.dart';
import 'Pages/profile.dart';
import 'Pages/start.dart';
import 'Pages/Authentication/signup.dart';
import 'Pages/Authentication/login.dart';
import 'Pages/home.dart';
import 'dart:async';

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
        '/createOCREntry': (BuildContext context) => CreateOCREntryScreen(),
        '/createJourney': (BuildContext context) => CreateJourneyScreen(),
        '/createHabit': (BuildContext context) => CreateHabitScreen(),
        '/displayEntry': (BuildContext context) => DisplayEntryScreen(),
        '/displayJourney': (BuildContext context) => DisplayJourneyScreen(),
        '/selectEntries': (BuildContext context) => SelectEntriesScreen(),
        // '/habitStatistics': (BuildContext context) => HabitStatisticsPage(),
        '/profile': (BuildContext context) => ProfileScreen(),
        '/editProfile': (BuildContext context) => EditProfile(),
      },
    );
    // ,);
  }
}
