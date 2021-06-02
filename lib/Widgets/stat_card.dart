import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget statCard(
    emoji,
    value,
    title, {
    color: const Color(0xff8ebbf2),
  }) {
    return Card(
      elevation: 2,
      color: color,
      child: InkWell(
        splashColor: Colors.white30,
        onLongPress: () async {
          await HapticFeedback.mediumImpact();
        },
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 3),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont("Lora",
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(title,
                style: GoogleFonts.getFont("Merriweather", fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
