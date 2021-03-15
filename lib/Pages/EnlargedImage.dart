import 'package:flutter/material.dart';
import 'dart:io';

class EnlargedImage extends StatelessWidget {
  EnlargedImage(this.imagePath);

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'ImagePreview',
            child: Image.file(File(imagePath)),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
