import 'package:daybook/Services/journeyService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:daybook/Widgets/LoadingPage.dart';

class JourneysScreen extends StatefulWidget {
  @override
  _JourneysScreenState createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  final List<Color> colorCodes = [
    Color(0xfff5dea4),
    Color(0xffdde1eb),
    Color(0xffbddafc),
    Color(0xfffdefcc),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            StreamBuilder(
                stream: getJourneys(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingPage();
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No journeys created !! \n Click on + to get started",
                            style: GoogleFonts.getFont(
                              'Lato',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              // color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ));
                  }
                  return new ListView.builder(
                      padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return JourneyCard(
                            colorCodes: colorCodes,
                            index: index,
                            documentSnapshot: ds);
                      });
                }),
            Positioned(
              bottom: 15,
              right: 15,
              child: FloatingActionButton(
                backgroundColor: Color(0xffd68598),
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, '/createJourney', arguments: [])
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JourneyCard extends StatelessWidget {
  JourneyCard({
    Key key,
    @required this.colorCodes,
    @required this.index,
    @required this.documentSnapshot,
  }) : super(key: key);

  final List<Color> colorCodes;
  final int index;
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      color: Color(0xfffdefcc),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
                onTap: () {
                  print("Tapped on journey " + documentSnapshot.id);
                  Navigator.pushNamed(context, '/displayJourney',
                      arguments: [documentSnapshot]);
                },
                onLongPress: () async {
                  await HapticFeedback.vibrate();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text("Detele Journey ?"),
                      content:
                          Text("This will delete the Journey permanently."),
                      actions: <Widget>[
                        Row(
                          children: [
                            FlatButton(
                              onPressed: () {
                                deleteJourney(documentSnapshot);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Delete",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
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
                child: Row(
                  children: [
                    Container(
                      // padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            documentSnapshot['title'],
                            style: GoogleFonts.getFont(
                              'Merriweather',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              documentSnapshot['description'],
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
                        onTap: () {
                          documentSnapshot['isFavourite']
                              ? onCheckFavourite(documentSnapshot.id, false)
                              : onCheckFavourite(documentSnapshot.id, true);
                        },
                        child: Icon(
                          documentSnapshot['isFavourite']
                              ? Icons.favorite
                              : Icons.favorite_outline_rounded,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/createJourney',
                              arguments: [documentSnapshot]);
                        },
                      ),
                    ]),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                DateFormat.yMMMMd()
                    .format(DateTime.parse(documentSnapshot['dateCreated'])),
                style: GoogleFonts.getFont('Oxygen',
                    fontSize: 13, color: Colors.black.withOpacity(0.6)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
