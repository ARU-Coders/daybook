import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:daybook/Provider/email_sign_in.dart';
import 'package:daybook/Provider/theme_change.dart';
import 'package:daybook/Widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Entries/entries.dart';
import 'Habits/habits.dart';
import 'Journeys/journeys.dart';
import 'Tasks/tasks.dart';
import 'Stats/stats.dart';
import 'package:daybook/Services/db_services.dart';
import 'package:daybook/Services/auth_service.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _bottomNavigationKey = GlobalKey();
  final _url = 'https://trcr.tk/Kf6uY';

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

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : print('Could not launch $_url');

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    bool status = _themeProvider.getTheme == lightTheme;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(create: (context) {
            return GoogleSignInProvider();
          }),
          ChangeNotifierProvider<EmailSignInProvider>(create: (context) {
            return EmailSignInProvider();
          }),
          ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
        ],
        child: Builder(builder: (newContext) {
          void handleMenuClick(String value) async {
            switch (value) {
              case 'Profile':
                {
                  Navigator.pushNamed(context, '/profile');
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
                  String type = await AuthService.getUserType();
                  // Builder(builder: (BuildContext context) {
                  if (type == "google") {
                    Provider.of<GoogleSignInProvider>(newContext, listen: false)
                        .logout();
                  } else {
                    Provider.of<EmailSignInProvider>(newContext, listen: false)
                        .logout();
                  }
                  // return SizedBpx();
                  Navigator.popAndPushNamed(
                    context,
                    '/splashScreen',
                  );
                  // });

                  break;
                }
            }
          }

          return SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(
                  _title[_currentTab],
                  style: GoogleFonts.getFont('Lato'),
                ),
                leading: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  splashColor: Colors.white70,
                  onDoubleTap: _launchURL,
                  onLongPress: () async {
                    await HapticFeedback.vibrate();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 10,
                      width: 10,
                    ),
                  ),
                ),
                backgroundColor: Color(0xDAFFD1DC),
                actions: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 3),
                    child: CustomSwitch(
                      activeColor: Colors.grey[100],
                      activeText: 'Light',
                      activeTextColor: Colors.black,
                      inactiveText: 'Dark',
                      inactiveColor: Colors.grey[800],
                      inactiveTextColor: Colors.white,
                      value: status,
                      onChanged: (value) {
                        _themeProvider.setTheme(
                            _themeProvider.getTheme == lightTheme
                                ? darkTheme
                                : lightTheme);
                        setState(() {
                          status = value;
                        });
                      },
                    ),
                  ),
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
        }));
  }
}
