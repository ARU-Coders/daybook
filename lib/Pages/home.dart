import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'entries.dart';
import 'journeys.dart';
import 'tasks.dart';
import 'habits.dart';
import 'stats.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  final _tabs = [
    JourneysScreen(),
    HabitsScreen(),
    EntriesScreen(),
    TasksScreen(),
    StatsScreen()
  ];

  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _tabs[_currentTab],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: Colors.blueGrey[900],
        backgroundColor: Colors.orange.shade400,
        buttonBackgroundColor: Colors.orange.shade400,
        animationCurve: Curves.linearToEaseOut,
        animationDuration: Duration(milliseconds: 200),
        items: <Widget>[
          // Journeys, Habits, Entry Feed, Tasks, Stats
          FaIcon(FontAwesomeIcons.plane, size: 20, color: Colors.white),
          FaIcon(FontAwesomeIcons.infinity, size: 20, color: Colors.white),
          FaIcon(FontAwesomeIcons.pencilAlt, size: 20, color: Colors.white),
          FaIcon(FontAwesomeIcons.tasks, size: 20, color: Colors.white),
          FaIcon(FontAwesomeIcons.chartLine, size: 20, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        height: 50,
      ),
    );
  }
}
