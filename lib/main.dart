import 'package:daybook/Pages/Entries/create_entry.dart';
import 'package:daybook/Pages/Habits/create_habit.dart';
import 'package:daybook/Pages/Journeys/create_journey.dart';
import 'package:daybook/Pages/Entries/display_entry.dart';
import 'package:daybook/Pages/Journeys/display_journey.dart';
import 'package:daybook/Pages/Journeys/select_entries.dart';
import 'package:daybook/Pages/edit_profile.dart';
import 'package:daybook/Provider/theme_change.dart';
// import 'package:daybook/Pages/habit_stats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Pages/Entries/pick_image_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  static final String title = 'Daybook';
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme,
      debugShowCheckedModeBanner: false,
      title: title,
      home: StartPage(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => StartPage(),
        '/signup': (BuildContext context) => Signup(),
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/createEntry': (BuildContext context) => CreateEntryScreen(),
        '/createOCREntry': (BuildContext context) => CreateOCREntryScreen(),
        '/captureEntry': (BuildContext context) => PickImageScreen(),
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
  }
}
