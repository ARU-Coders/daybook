import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:daybook/Services/pdf_service.dart';
import 'package:open_file/open_file.dart';

class DisplayEntryScreen extends StatefulWidget {
  @override
  _DisplayEntryScreenState createState() => _DisplayEntryScreenState();
}

class _DisplayEntryScreenState extends State<DisplayEntryScreen> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as List<dynamic>;

    var appbarHeight = AppBar().preferredSize.height;
    double width = MediaQuery.of(context).size.width;

    DocumentSnapshot documentSnapshot = arguments[0];
    List<dynamic> imageUrls = documentSnapshot["images"];
    List<String> tags = List<String>.from(documentSnapshot["tags"]);

    Widget _tagsGrid() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            spacing: 3,
            runSpacing: 1,
            children: List.generate(tags.length, (index) {
              return Column(
                children: <Widget>[
                  Chip(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    label: Text(
                      "${tags[index]}",
                      style: GoogleFonts.getFont(
                        'Oxygen',
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: Color(0xffffe9b3),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: width,
                    decoration: new BoxDecoration(
                      color: colorMoodMap[documentSnapshot['mood']],
                      borderRadius: new BorderRadius.vertical(
                          bottom: new Radius.elliptical(width, 40.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              height: appbarHeight,
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () async {
                                    await HapticFeedback.vibrate();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text("Detele Entry ?"),
                                        content: Text(
                                          "This will delete the Entry permanently.",
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              FlatButton(
                                                onPressed: () {
                                                  deleteEntry(documentSnapshot);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Delete"),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 25),
                                isLoading
                                ?
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                                :
                                Builder(builder: (BuildContext context) {
                                  return 
                                    GestureDetector(
                                      child: Icon(
                                        Icons.download_outlined,
                                        size: 20,
                                        color: Colors.black87,
                                      ),
                                      onTap: () async {
                                        setState(() => isLoading = true);
                                        File newfile =
                                            await generatePDF(documentSnapshot);
                                        bool val = await newfile.exists();
                                        setState(() => isLoading = false);
                                        print(val);
                                        if (val == true) {
                                          final snackBar = SnackBar(
                                            content: Text('Entry Downloaded !'),
                                            action: SnackBarAction(
                                              label: 'Open PDF',
                                              onPressed: () async {
                                                final _ = await OpenFile.open(newfile.path);
                                              },
                                            ),
                                          );
                                          _scaffoldKey.currentState.showSnackBar(snackBar);
                                        }
                                      });
                                }),
                                SizedBox(
                                  width: 25,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.share_outlined,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                  onTap: () {
                                    String subject =
                                        documentSnapshot['title'].toString();
                                    String text = '*' +
                                        subject +
                                        '*' +
                                        "\n\nFeeling " +
                                        documentSnapshot['mood'].toString() +
                                        "\n\n" +
                                        documentSnapshot['content'].toString();
                                    Share.share(text);
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                documentSnapshot['title'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont(
                                  'Merriweather',
                                  color: Colors.grey[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Feeling " + moodText[documentSnapshot['mood']],
                              style: GoogleFonts.getFont(
                                'Lora',
                                color: Colors.grey[700],
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            documentSnapshot['address'] != ""
                                ? Chip(
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        documentSnapshot['address'],
                                        style: GoogleFonts.getFont(
                                          'Oxygen',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    avatar: Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black87,
                                    ),
                                    backgroundColor: Color(0xffffe9b3),
                                  )
                                : SizedBox(),
                            Chip(
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "${DateFormat.yMMMMd().format(DateTime.parse(documentSnapshot['dateCreated']))}  ${DateFormat.jm().format(DateTime.parse(documentSnapshot['dateCreated']))}",
                                  style: GoogleFonts.getFont(
                                    'Oxygen',
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              backgroundColor: Color(0xffffe9b3),
                              avatar: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onLongPress: () {
                                Clipboard.setData(new ClipboardData(
                                    text: documentSnapshot['content']
                                        .toString()
                                        .trim()));
                                final snackBar = SnackBar(
                                  content: Text(
                                      "Entry content copied to clipboard!"),
                                  duration: Duration(seconds: 3),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0),
                                child: Text(
                                  documentSnapshot['content'],
                                  softWrap: true,
                                  style: GoogleFonts.getFont(
                                    'Nunito',
                                    // color: Colors.black87,
                                    fontSize: 17,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            imageUrls.length != 0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                child: ImageGrid(
                                  imageUrls: imageUrls,
                                ),
                              )
                            : SizedBox(),
                            tags.length != 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: _tagsGrid(),
                                  )
                                : SizedBox(
                                    height: 1,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  backgroundColor: Color(0xffd68598),
                  child: Icon(
                    Icons.edit_outlined,
                  ),
                  onPressed: () => {
                    Navigator.popAndPushNamed(context, '/createEntry',
                        arguments: [documentSnapshot])
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGrid extends StatefulWidget {
  final List<dynamic> imageUrls;
  const ImageGrid({Key key, this.imageUrls}) : super(key: key);

  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  PageController pageController;
  double pageOffset = 0;
  List<dynamic> imageUrls;

  @override
  void initState() {
    super.initState();
    imageUrls = widget.imageUrls;
    pageController = PageController(viewportFraction: 0.5);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: PageView.builder(
          itemCount: imageUrls.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Transform.scale(
              scale: 1.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return EnlargedImage(imageUrls[index], true);
                  }));
                },
                child: Container(
                  height: 110,
                  width: 110,
                  padding: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: imageUrls[index] == ""
                          ? 'https://picsum.photos/250?image=9'
                          : imageUrls[index],
                      fit: BoxFit.cover,
                      alignment: Alignment(-pageOffset.abs() + index, 0),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Container(
                        child: Center(
                          child: Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
