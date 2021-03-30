import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'entries.dart';
import 'journeys.dart';
import 'tasks.dart';
import 'habits.dart';
import 'stats.dart';
import 'package:daybook/Services/db_services.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _title = ["My Journeys", "My Habits", "Entries", "My Tasks", "Stats"];
  int _currentTab = 2;
  final List<String> menuItems = <String>['Profile', 'Settings', 'Logout'];
  void handleMenuClick(String value) async {
    switch (value) {
      case 'Profile':
        {
          print("Selected : $value");
          break;
        }
      case 'Settings':
        {
          print("Selected : $value");
          break;
        }
      case 'Logout':
        {
          print("Selected : $value");
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.logout();
          Navigator.popAndPushNamed(
            context,
            '/start',
          );
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _title[_currentTab],
            style: GoogleFonts.getFont('Lato'),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 10,
              width: 10,
            ),
          ),
          backgroundColor: Color(0xDAFFD1DC),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleMenuClick,
              icon: FutureBuilder(
                future: getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {}
                  if (snapshot.hasData) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: snapshot.data['photo'],
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              itemBuilder: (BuildContext context) {
                return menuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
          child: _tabs[_currentTab],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentTab,
          key: _bottomNavigationKey,
          color: Color(0xDAFFD1DC),
          backgroundColor: Color(0xffd68598),
          buttonBackgroundColor: Color(0xffd68598),
          animationCurve: Curves.linearToEaseOut,
          animationDuration: Duration(milliseconds: 200),
          items: <Widget>[
            // Journeys, Habits, Entry Feed, Tasks, Stats
            FaIcon(FontAwesomeIcons.plane,
                size: 20,
                color: _currentTab == 0 ? Colors.white : Colors.black87),
            FaIcon(FontAwesomeIcons.infinity,
                size: 20,
                color: _currentTab == 1 ? Colors.white : Colors.black87),
            FaIcon(FontAwesomeIcons.pencilAlt,
                size: 20,
                color: _currentTab == 2 ? Colors.white : Colors.black87),
            FaIcon(FontAwesomeIcons.tasks,
                size: 20,
                color: _currentTab == 3 ? Colors.white : Colors.black87),
            FaIcon(FontAwesomeIcons.chartLine,
                size: 20,
                color: _currentTab == 4 ? Colors.white : Colors.black87),
          ],
          onTap: (index) {
            setState(() {
              _currentTab = index;
            });
          },
          height: 50,
        ),
      ),
    );
  }
}
