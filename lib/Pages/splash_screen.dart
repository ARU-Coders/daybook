import 'package:daybook/Provider/theme_change.dart';
import 'package:provider/provider.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:daybook/Utils/constantStrings.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigate);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    bool _seen = (prefs.getBool(SHAREDPREFNAME) ?? false);
    if(_seen){
      /// If logged in redirect to home screen
      if(FirebaseAuth.instance.currentUser != null){
        print("Splash screen, user found!");
        Navigator.popAndPushNamed(context, '/home');
      }
      /// Else redirect to Login screen
      else{
        Navigator.popAndPushNamed(context, '/login');
      }
      bool isDarkTheme = (prefs.getBool(DARKTHEMESHAREDPREF) ?? false);
      var _themeProvider = Provider.of<ThemeChanger>(context,listen: false);
      _themeProvider.setTheme(isDarkTheme ? darkTheme : lightTheme);

    }
    else{
      // Show Intro Screens
      Navigator.popAndPushNamed(context, '/intro');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft, end: Alignment.topRight, colors: colorPalette,
              ),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts:[
                    TyperAnimatedText("Daybook", 
                      textStyle: GoogleFonts.getFont("Allura", fontSize: 40, color: Colors.blueGrey[800], letterSpacing: 1.5
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
