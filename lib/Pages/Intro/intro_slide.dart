import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroSlide extends StatelessWidget {
  final String title;
  final String lottieFile;
  final String description;
  final Color color;

  IntroSlide({@required this.title, @required this.lottieFile, @required this.description, this.color});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical:16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: height * 0.3,
          ),
          Expanded(
            child: Lottie.asset(
              lottieFile,
              repeat: true,
              reverse: true,
              animate: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical:height * 0.1, horizontal: 24),
            child: Text(title,
              style: GoogleFonts.getFont(
                "Lora",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical:8, horizontal: 24),
            child: Text(description,
              style: GoogleFonts.getFont(
                "Lora",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3,
              textAlign: TextAlign.center
            ),
          ),
        ],
      ),
    );
  }
}
