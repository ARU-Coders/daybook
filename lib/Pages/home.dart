import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Pages/start.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:curved'
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tab $_currentTab !"),
            SizedBox(height: 15),
            RaisedButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );
              },
              child: Text('Logout'),
            )
          ],
        ),
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
