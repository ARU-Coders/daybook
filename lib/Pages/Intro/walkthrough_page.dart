import 'package:daybook/Pages/Intro/dots_decorator.dart';
import 'package:daybook/Pages/Intro/dots_indicator.dart';
import 'package:daybook/Pages/Intro/intro_slide.dart';
import 'package:daybook/Utils/constantStrings.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  final PageController controller = new PageController();
  var currentPage = 0;
  final List<Color> buttonColor = [RED, YELLOW, PINK, BLUE];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(children: [
              IntroSlide(
                title: ENTRY_INTRO_TITLE,
                description:ENTRY_INTRO_DESCRIPTION,
                lottieFile: ENTRY_LOTTIE_FILE,
                color: RED,//red
              ),
              IntroSlide(
                title: HABIT_INTRO_TITLE,
                description:HABIT_INTRO_DESCRIPTION,
                lottieFile: HABIT_LOTTIE_FILE,
                color: PINK,//pink
              ),
              IntroSlide(
                title: TASK_INTRO_TITLE,
                description: TASK_INTRO_DESCRIPTION,
                lottieFile: TASK_LOTTIE_FILE,
                color: BLUE,//blue
              ),
              IntroSlide(
                title: STATS_INTRO_TITLE,
                description: STATS_INTRO_DESCRIPTION,
                lottieFile: STATS_LOTTIE_FILE,
                color: YELLOW,//yellow
              )
            ], controller: controller, onPageChanged: _onPageChanged),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.07),
                child: DotsIndicator(
                  dotsCount: 4,
                  position: currentPage,
                  decorator: DotsDecorator(
                      color: Color(0xFF212121).withOpacity(0.15),
                      activeColor: Color(0xFF041887),
                      activeSize: Size.square(10.0),
                      spacing: EdgeInsets.all(3)),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(currentPage == 3 ? "Get Started" : "Continue",
                        style:GoogleFonts.getFont(
                          "Lora",
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                      color: buttonColor[currentPage],
                      onPressed: () async{
                        if (currentPage == 3)
                        {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(SHAREDPREFNAME, true);
                          await prefs.setBool(DARKTHEMESHAREDPREF, false);
                          Navigator.pushNamed(context, '/login');
                        }
                        else
                        {
                          setState(() {
                            currentPage++;
                            controller.animateToPage(currentPage,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease
                            );
                          });
                        }
                      },
                    ),
                  )
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentPage = 3;
                    controller.animateToPage(currentPage,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(currentPage != 3 ? "Skip Now" : "",
                    style:GoogleFonts.getFont(
                      "Lora",
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }
}