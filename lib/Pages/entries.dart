import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/entryService.dart';

class EntriesScreen extends StatefulWidget {
  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final List<int> colorCodes = <int>[400, 300, 200];

  final Map<String, Color> colorMoodMap = {
    "Terrible": Colors.grey[300],
    "Bad": Colors.blueGrey,
    "Neutral": Colors.cyan[200],
    "Good": Colors.yellow,
    "Wonderful": Colors.green
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFF111111),
        child: Stack(
          children: [
            StreamBuilder(
                stream: getEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: CircularProgressIndicator());
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No entries created !! \n Click on + to get started",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                        return EntryCard(
                            colorCodes: colorMoodMap,
                            title: ds["title"],
                            content: ds["content"],
                            index: index,
                            dateCreated: ds["dateCreated"],
                            entryId: ds.id,
                            images: ds["images"],
                            mood: ds["mood"],
                            documentSnapshot: ds);
                      });
                }),
            Positioned(
              bottom: 15,
              right: 15,
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, '/createEntry', arguments: [])
                  // print('Button pressed!');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryCard extends StatelessWidget {
  const EntryCard({
    Key key,
    @required this.colorCodes,
    @required this.title,
    @required this.content,
    @required this.index,
    @required this.dateCreated,
    @required this.entryId,
    @required this.images,
    @required this.mood,
    @required this.documentSnapshot,
  }) : super(key: key);

  final Map<String, Color> colorCodes;
  final String title;
  final String content;
  final String dateCreated;
  final int index;
  final String entryId;
  final List<dynamic> images;
  final String mood;
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      color: colorCodes[mood],
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
                onTap: () {
                  print("Tapped on entry $documentSnapshot.id");
                },
                onLongPress: () {
                  showDialog(
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
                child: Row(
                  children: [
                    Container(
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '$title',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              '$content',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.6)),
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 0, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          images.length == 0
                              ? 'https://picsum.photos/250?image=9'
                              : 'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NXx8cmFuZG9tfGVufDB8fDB8&ixlib=rb-1.2.1&w=1000&q=80',
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
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: Text("Detele Entry ?"),
                              content: Text(
                                  "This will delete the Entry permanently."),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    FlatButton(
                                      onPressed: () {
                                        deleteEntry(documentSnapshot);
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
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/createEntry',
                              arguments: [
                                title,
                                content,
                                images,
                                entryId,
                                mood
                              ]);
                        },
                      ),
                    ]),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '$dateCreated',
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.6)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
