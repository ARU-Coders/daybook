import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:daybook/Pages/Entries/ocr_entry.dart';
import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class PickImageScreen extends StatefulWidget {
  @override
  _PickImageScreenState createState() => _PickImageScreenState();
}

enum Source { GALLERY, CAMERA }

class _PickImageScreenState extends State<PickImageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ImagePicker imagePicker;
  PickedFile pickedImage;
  FirebaseVisionImage visionImage;

  bool imageLoaded = false;
  bool recognizingText = false;
  bool textRecognized = false;

  String title = "";
  String content = "";
  var text = '';

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future pickImage(Source source) async {
    try {
      var awaitImage = source == Source.CAMERA
          ? await imagePicker.getImage(source: ImageSource.camera)
          : await imagePicker.getImage(source: ImageSource.gallery);

      if (awaitImage == null) return;

      setState(() {
        pickedImage = awaitImage;
        textRecognized = false;
        imageLoaded = true;
      });

      visionImage = FirebaseVisionImage.fromFile(File(pickedImage.path));

      TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      VisionText visionText = await textRecognizer.processImage(visionImage);

      setState(() {
        recognizingText = true;
      });

      if (visionText.blocks.length == 0) {
        setState(() {
          text = "No text found in the image!";
          recognizingText = false;
          textRecognized = true;
          title = "";
          content = "";
        });
        return;
      } else {
        bool readingTitle = true;
        for (TextBlock block in visionText.blocks) {
          for (TextLine line in block.lines) {
            if (readingTitle) {
              for (TextElement word in line.elements)
                title = title + word.text + ' ';

              readingTitle = false;
            } else
              for (TextElement word in line.elements) {
                content = content + word.text + ' ';
              }
          }
          content = content + '\n';
        }
      }
      setState(() {
        recognizingText = false;
        textRecognized = true;
      });

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateOCREntryScreen(
                title: title,
                content: content,
                capturedEntryPath: pickedImage.path),
          ));
      textRecognizer.close();
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Select an image'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Spacer(),
          imageLoaded
              ? buildImagePreview(context)
              : buildTitle("Select an image to continue"),
          SizedBox(height: 20.0),
          imageLoaded ? SizedBox(height: 20.0) : buildButtons(),
          SizedBox(height: 20.0),
          textRecognized
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: buildTitle(
                        text,
                      ),
                    ),
                  ),
                )
              : recognizingText
                  ? CircularProgressIndicator()
                  : Container(),
          Spacer(),
        ],
      ),
    );
  }

  Center buildButtons() {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: InkWell(
              onTap: () async {
                pickImage(Source.GALLERY);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      height: 130,
                      child: Image.asset(
                        'assets/images/Open-Gallery.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Open\nGallery",
                        style: GoogleFonts.getFont("Oxygen", fontSize: 15),
                        softWrap: true,
                        textAlign: TextAlign.center),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            child: InkWell(
              onTap: () async {
                pickImage(Source.CAMERA);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      height: 130,
                      child: Image.asset(
                        'assets/images/Open-Camera.jpg',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Open\nCamera",
                      style: GoogleFonts.getFont("Oxygen", fontSize: 15),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTitle(String str) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 35, 8, 15),
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2), // color: Colors.grey[100]
          ),
          child: Text(
            str,
            style: GoogleFonts.getFont("Lato", fontSize: 20),
          )),
    );
  }

  GestureDetector buildImagePreview(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnlargedImage(pickedImage.path, false),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 35, 8, 15),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(blurRadius: 10),
              ],
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            height: 250,
            child: Image.file(
              File(pickedImage.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
