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
                    child: Column(children: [
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
                    ]),
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