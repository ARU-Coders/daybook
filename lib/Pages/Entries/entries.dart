import 'package:daybook/Utils/constants.dart';
import 'package:daybook/Widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
// import '../customSearch.dart';

class EntriesScreen extends StatefulWidget {
  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool descending = true;
  static const List<IconData> icons = const [
    Icons.center_focus_strong_sharp,
    Icons.text_snippet_outlined
  ];

  String searchVal = '';

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool checkIfSameDates(docs, index) {
    final currDate = DateTime.parse(docs[index]["dateCreated"].toString());
    final prevDate = DateTime.parse(docs[index - 1]["dateCreated"].toString());

    return currDate.year == prevDate.year &&
        currDate.month == prevDate.month &&
        currDate.day == prevDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            StreamBuilder(
                stream:
                    getEntries(descending: descending, searchVal: searchVal),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                            child:
                                Container(child: CircularProgressIndicator())));
                  }
                  if (snapshot.data.docs.length == 0) {
                    return noDataFound(
                      screen: Screens.ENTRIES,
                    );
                  }
                  return Padding(
                      padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // //Search Field
                                // Expanded(
                                //   child: Container(
                                //     height: 35,
                                //     child: TextField(
                                //       onChanged: (val) {
                                //         setState(() {
                                //           searchVal = val;
                                //         });
                                //         // initiateSearch(val);
                                //       },
                                //       decoration: InputDecoration(
                                //           prefixIcon: IconButton(
                                //             onPressed: () {
                                //               print("Search!");
                                //             },
                                //             color: Colors.black,
                                //             icon: Icon(Icons.search),
                                //           ),
                                //           contentPadding:
                                //               EdgeInsets.only(left: 25.0),
                                //           hintText: 'Search by title',
                                //           border: OutlineInputBorder(
                                //               borderRadius:
                                //                   BorderRadius.circular(10.0))),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(width: searchVal == "" ? 95 : 10),
                                Text("Date"),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    descending = !descending;
                                  }),
                                  child: Icon(descending
                                      ? Icons.arrow_downward_outlined
                                      : Icons.arrow_upward_outlined),
                                )
                              ]),
                          Expanded(
                            child: ListView.builder(
                                // padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];
                                  return index == 0
                                      ? entryCardWithDate(
                                          colorMoodMap, index, ds)
                                      : checkIfSameDates(
                                              snapshot.data.docs, index)
                                          ? EntryCard(
                                              colorCodes: colorMoodMap,
                                              index: index,
                                              documentSnapshot: ds)
                                          : entryCardWithDate(
                                              colorMoodMap, index, ds);
                                }),
                          ),
                        ],
                      ));
                }),
            Positioned(
              bottom: 15,
              right: 15,
              child: speedDialFAB(),
            ),
          ],
        ),
      ),
    );
  }

  Widget speedDialFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              tooltip: index == 1 ? "Text Entry" :"OCR Entry" ,
              backgroundColor: Color(0xffd68598),
              child: new Icon(
                icons[index],
                // Color: Colors.white
              ),
              onPressed: () {
                index == 1
                    ? Navigator.pushNamed(context, '/createEntry',
                        arguments: [])
                    : Navigator.pushNamed(context, '/captureEntry');
                _controller.reverse();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            backgroundColor: Color(0xffd68598),
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.75 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                    Icons.add,
                    size: 35,
                  ),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }

  Widget entryCardWithDate(colorMoodMap, index, ds) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 2,
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Text(
                DateFormat.yMMMMd().format(DateTime.parse(ds['dateCreated'])),
                style: GoogleFonts.getFont(
                  'Oxygen',
                  fontSize: 13,
                  // color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(
                child: Divider(
              thickness: 2,
            )),
          ],
        ),
        EntryCard(colorCodes: colorMoodMap, index: index, documentSnapshot: ds),
      ],
    );
  }
}

class EntryCard extends StatelessWidget {
  const EntryCard({
    Key key,
    @required this.colorCodes,
    @required this.index,
    @required this.documentSnapshot,
  }) : super(key: key);

  final Map<String, Color> colorCodes;
  final int index;
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      color: colorCodes[documentSnapshot['mood']],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/displayEntry',
              arguments: [documentSnapshot]);
          print("Tapped on an entry");
        },
        onLongPress: () async {
          await HapticFeedback.vibrate();
          buildDeleteDialog(context, documentSnapshot);
        },
        splashColor: Colors.white54,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/displayEntry',
                        arguments: [documentSnapshot]);
                  },
                  onLongPress: () async {
                    await HapticFeedback.vibrate();
                    buildDeleteDialog(context, documentSnapshot);
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              documentSnapshot['title'],
                              style: GoogleFonts.getFont(
                                'Merriweather',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                documentSnapshot['content'],
                                style: GoogleFonts.getFont('Nunito',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)),
                                overflow: TextOverflow.fade,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: (documentSnapshot['images'].length == 0 ||
                                  documentSnapshot['images'][0] == "")
                              ? Image.asset(
                                  ENTRY_PLACEHOLDER,
                                  height: 80.0,
                                  width: 80.0,
                                )
                              : CachedNetworkImage(
                                  imageUrl: documentSnapshot['images'][0],
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 75.0,
                                  width: 75.0,
                                ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: 60,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            buildDeleteDialog(context, documentSnapshot);
                          },
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/createEntry',
                                arguments: [documentSnapshot]);
                          },
                        ),
                      ]),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  DateFormat.jm()
                      .format(DateTime.parse(documentSnapshot['dateCreated'])),
                  style: GoogleFonts.getFont('Oxygen',
                      fontSize: 13, color: Colors.black.withOpacity(0.6)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Future buildDeleteDialog(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Detele Entry ?"),
        content: Text("This will delete the Entry permanently."),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  deleteEntry(documentSnapshot);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
