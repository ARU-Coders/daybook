import 'package:daybook/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


String getImage(Screens screen) => noDataImageMap[screen];
String getMessage(Screens screen) => noDataMessagesMap[screen];

/// Displays a placeholder image and message
/// according to the Screen specified
/// by `screen`.
/// 
Widget noDataFound({
    @required Screens screen,
  }){
  String message = getMessage(screen);
  String image = getImage(screen);

  return 
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 250.0,
          ),
          Text(
            message,
            style: GoogleFonts.getFont(
              'Lato',
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
} 