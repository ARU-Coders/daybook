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
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot documentSnapshot = arguments[0];
    print("checking :" + documentSnapshot['title']);
    return Scaffold(
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          documentSnapshot['title'],
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Times New Roman"),
                        ),
                        Text(
                          documentSnapshot['description'],
                          // '',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "Times New Roman"),
                        ),
                        Text(
                          DateFormat.yMMMMd().format(
                              DateTime.parse(documentSnapshot['startDate'])),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "Times New Roman"),
                        ),
                        Text(
                          DateFormat.yMMMMd().format(
                              DateTime.parse(documentSnapshot['endDate'])),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "Times New Roman"),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        GestureDetector(
                          child: Container(
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/selectEntries',
                                arguments: [documentSnapshot]);
                          },
                        ),
                        FutureBuilder<Stream<QuerySnapshot>>(
                            future: getEntriesOfJourney(documentSnapshot.id),
                            builder: (context, snapshot) {
                              return StreamBuilder(
                                  stream: snapshot.data,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Text("No data retrieved .... yet");
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
                                          child: Center(
                                        child: Text(
                                          "No entries added in this journey yet !! \n Click on + to get started",
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
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
                            })
                      ],
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
