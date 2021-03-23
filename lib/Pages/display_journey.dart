import 'package:flutter/material.dart';
import 'package:daybook/Services/journeyService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:daybook/Widgets/LoadingPage.dart';

class DisplayJourneyScreen extends StatefulWidget {
  @override
  _DisplayJourneyScreenState createState() => _DisplayJourneyScreenState();
}

class _DisplayJourneyScreenState extends State<DisplayJourneyScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    var appbarHeight = AppBar().preferredSize.height;
    double newheight = height - padding.top - padding.bottom - appbarHeight;
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot documentSnapshot = arguments[0];
    print("checking :" + documentSnapshot['title']);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Journey",
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text("Detele Journey ?"),
                    content: Text("This will delete the Journey permanently."),
                    actions: <Widget>[
                      Row(
                        children: [
                          FlatButton(
                            onPressed: () {
                              deleteJourney(documentSnapshot);
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
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: newheight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        documentSnapshot['title'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Times New Roman"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        DateFormat.yMMMMd().format(
                                DateTime.parse(documentSnapshot['startDate'])) +
                            " - " +
                            DateFormat.yMMMMd().format(
                                DateTime.parse(documentSnapshot['endDate'])),
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Times New Roman"),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        documentSnapshot['description'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: "Times New Roman"),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      // GestureDetector(
                      //   child: Container(
                      //     child: Icon(Icons.add),
                      //   ),
                      //   onTap: () {
                      //     Navigator.popAndPushNamed(context, '/selectEntries',
                      //         arguments: [documentSnapshot]);
                      //   },
                      // ),
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
                                    return Container(
                                        child: Center(
                                            child: Container(
                                                child:
                                                    CircularProgressIndicator())));
                                  }
                                  if (snapshot.data.docs.length == 0) {
                                    return Container(
                                        //     child: Center(
                                        //   child: Text(
                                        //     "No entries added in this journey yet !! \n Click on + to get started",
                                        //     style: TextStyle(
                                        //       fontSize: 27,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.black87,
                                        //     ),
                                        //     textAlign: TextAlign.center,
                                        //   ),
                                        // )
                                        );
                                  }
                                  return new ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.fromLTRB(17, 10, 17, 25),
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot ds =
                                            snapshot.data.docs[index];
                                        return ShortEntryCard(ds: ds);
                                      });
                                });
                          }
                          //           )
                          //     ],
                          //   ),
                          // ),
                          ),
                      Spacer()
                    ],
                  ),
                  Positioned(
                    bottom: 15,
                    right: width / 4.5,
                    child: RaisedButton(
                      child: Text("Add Entries",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff5685bf),
                          )),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: StadiumBorder(),
                      color: Color(0xff8ebbf2),
                      onPressed: () => {
                        Navigator.popAndPushNamed(context, '/selectEntries',
                            arguments: [documentSnapshot])
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShortEntryCard extends StatelessWidget {
  const ShortEntryCard({
    Key key,
    @required this.ds,
  }) : super(key: key);

  final DocumentSnapshot ds;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Card(
        color: Colors.greenAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Text(
              ds['title'],
              style: TextStyle(color: Colors.black),
            )),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/displayEntry', arguments: [ds]);
      },
    );
  }
}
