import 'package:cached_network_image/cached_network_image.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Services/journeyService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Provider/theme_change.dart';
import 'package:daybook/Widgets/ExpandableText.dart';
class DisplayJourneyScreen extends StatefulWidget {
  @override
  _DisplayJourneyScreenState createState() => _DisplayJourneyScreenState();
}

class _DisplayJourneyScreenState extends State<DisplayJourneyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    double width = MediaQuery.of(context).size.width;
    var appbarHeight = AppBar().preferredSize.height;
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;

    DocumentSnapshot documentSnapshot = arguments[0];

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                buildNavBar(width, context, appbarHeight, documentSnapshot),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildDescription(
                            documentSnapshot, context, _themeProvider),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          thickness:
                              _themeProvider.getTheme == lightTheme ? 1 : 2,
                        ),
                        FutureBuilder<Stream<QuerySnapshot>>(
                            future: getEntriesOfJourney(documentSnapshot.id),
                            builder: (context, snapshot) {
                              return StreamBuilder(
                                  stream: snapshot.data,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: Container(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Container(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (snapshot.data.docs.length == 0) {
                                      return Container(
                                        child: Center(
                                          child: Text("No Entries!"),
                                        ),
                                      );
                                    }
                                    final textTheme =
                                        Theme.of(context).textTheme;
                                    return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 0, 80),
                                        child:
                                            buildTimeline(snapshot, textTheme));
                                  });
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 10,
              right: width / 4.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RaisedButton(
                  child: Text("Add Entries",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff5685bf),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: StadiumBorder(),
                  color: Color(0xff8ebbf2),
                  onPressed: () => {
                    Navigator.popAndPushNamed(context, '/selectEntries',
                        arguments: [documentSnapshot])
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildDescription(DocumentSnapshot documentSnapshot,
      BuildContext context, ThemeChanger themeProvider) {
    String description = documentSnapshot['description'].toString().trim();
    var theme = themeProvider.getTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: theme == lightTheme ? Colors.grey[100] : Colors.grey[800],
            border: Border.all(
                color:
                    theme == lightTheme ? Colors.blue[400] : Colors.blue[200]),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: description.length > 100
            ? ExpandableText(description)
            : Text(
                documentSnapshot['description'].toString().trim(),
                softWrap: true,
                style: TextStyle(
                    // color: Colors.black87,
                    fontSize: 12.5,
                    letterSpacing: 0.2,
                    fontFamily: "Times New Roman"),
              ),
      ),
    );
  }

  Timeline buildTimeline(snapshot, textTheme) {
    return Timeline.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.docs.length,
        lineColor: Theme.of(context).dividerColor,
        physics: ClampingScrollPhysics(),
        position: TimelinePosition.Left,
        itemBuilder: (context, i) {
          DocumentSnapshot ds = snapshot.data.docs[i];
          String mood = ds["mood"];
          return TimelineModel(ShortEntryCard(ds: ds),
              position: i % 2 == 0
                  ? TimelineItemPosition.right
                  : TimelineItemPosition.left,
              isFirst: i == 0,
              isLast: i == snapshot.data.docs.length,
              icon: (mood == "Terrible" || mood == "Bad")
                  ? Icon(
                      Icons.mood_bad_outlined,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.mood_outlined,
                      color: Colors.black,
                    ),
              iconBackground: colorMoodMap[mood]);
        });
  }

  Container buildNavBar(double width, BuildContext context, double appbarHeight,
      DocumentSnapshot documentSnapshot) {
    return Container(
        height: 200.0,
        width: width,
        decoration: BoxDecoration(
          color: Color(0xff8ebbf2),
          borderRadius:
              BorderRadius.vertical(bottom: Radius.elliptical(width, 40.0)),
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
                    child: Icon(Icons.arrow_back),
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
                            title: Text("Detele Journey ?"),
                            content: Text(
                                "This will delete the Journey permanently."),
                            actions: <Widget>[
                              Row(
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      deleteJourney(documentSnapshot);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/createJourney',
                            arguments: [documentSnapshot]);
                      },
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ]),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Text(
                  documentSnapshot['title'],
                  style: GoogleFonts.getFont(
                    'Merriweather',
                    color: Colors.grey[900],
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat.yMMMMd().format(
                          DateTime.parse(documentSnapshot['startDate'])) +
                      " - " +
                      DateFormat.yMMMMd()
                          .format(DateTime.parse(documentSnapshot['endDate'])),
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Times New Roman"),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            )
          ],
        ));
  }
}

class ShortEntryCard extends StatelessWidget {
  const ShortEntryCard({
    Key key,
    @required this.ds,
  }) : super(key: key);

  String getTitle(String dsTitle) {
    return dsTitle.length > 18 ? dsTitle.substring(0, 18) + " ..." : dsTitle;
  }

  final DocumentSnapshot ds;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: colorMoodMap[ds["mood"]])],
      ),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          // tileColor: Colors.cyan,
          leading: Container(
            padding: EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 2.0, color: Colors.black))),
            child: (ds['images'].length == 0 || ds['images'][0] == "")
                ? Image.asset(
                    ENTRY_PLACEHOLDER,
                    height: 50.0,
                    width: 50.0,
                  )
                : CachedNetworkImage(
                    imageUrl: ds["images"][0],
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 50.0,
                    width: 50.0,
                  ),
          ),
          title: Text(
            getTitle(ds["title"]),
            style: GoogleFonts.getFont('Merriweather',
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
          ),
          subtitle: Text(
            DateFormat.yMMMMd().format(DateTime.parse(ds['dateCreated'])),
            style:
                GoogleFonts.getFont('Lora', color: Colors.black, fontSize: 11),
          ),
          trailing: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/displayEntry', arguments: [ds]);
              },
              child: Icon(Icons.keyboard_arrow_right,
                  color: Colors.black, size: 30.0))),
    );
  }
}