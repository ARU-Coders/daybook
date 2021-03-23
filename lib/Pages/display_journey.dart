import 'package:flutter/material.dart';
import 'package:daybook/Services/journeyService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 200.0,
                    width: width,
                    decoration: new BoxDecoration(
                      color: Color(0xff8ebbf2),
                      // boxShadow: [new BoxShadow(blurRadius: 10.0)],
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
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            Container(
                              height: appbarHeight,
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
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
                                                  deleteJourney(
                                                      documentSnapshot);
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
                                    Navigator.popAndPushNamed(
                                        context, '/createJourney',
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
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Times New Roman"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat.yMMMMd().format(DateTime.parse(
                                      documentSnapshot['startDate'])) +
                                  " - " +
                                  DateFormat.yMMMMd().format(DateTime.parse(
                                      documentSnapshot['endDate'])),
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
                    )),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  // flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Container(
                            // color: Color(0xfff0f0f0),
                            child: Text(
                              documentSnapshot['description'],
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  letterSpacing: 0.2,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
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
                                      return Container(
                                          child: Center(
                                              child: Container(
                                                  child:
                                                      CircularProgressIndicator())));
                                    }
                                    if (snapshot.data.docs.length == 0) {
                                      return Container();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 50.0, left: 30, right: 30),
                                      child: Container(
                                        // color: Color(0xfff0f0f0),
                                        height: 300,
                                        child: new ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.fromLTRB(
                                                5, 0, 5, 25),
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot ds =
                                                  snapshot.data.docs[index];
                                              return ShortEntryCard(ds: ds);
                                            }),
                                      ),
                                    );
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
            // SizedBox(
            //   height: 20,
            // )
          ],
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
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey[100])],
      ),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          // tileColor: Colors.cyan,
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 2.0, color: Colors.black))),
            child: Icon(
              Icons.sticky_note_2_outlined,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: Text(
            ds['title'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(ds['mood'], style: TextStyle(color: Colors.black)),
          trailing: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/displayEntry', arguments: [ds]);
              },
              child: Icon(Icons.keyboard_arrow_right,
                  color: Colors.black, size: 30.0))),
    );
  }
}
