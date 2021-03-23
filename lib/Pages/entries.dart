import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EntriesScreen extends StatefulWidget {
  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final List<int> colorCodes = <int>[400, 300, 200];

  final Map<String, Color> colorMoodMap = {
    "Terrible": Colors.grey[200],
    "Bad": Colors.blue[200],
    "Neutral": Colors.red[150],
    "Good": Colors.yellow[200],
    "Wonderful": Colors.green[200]
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xffdde1eb),
        child: Stack(
          children: [
            StreamBuilder(
                stream: getEntries(),
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
                            documentSnapshot['title'],
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              documentSnapshot['content'],
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
                        borderRadius: BorderRadius.circular(15.0),
                        child: (documentSnapshot['images'].length == 0 ||
                                documentSnapshot['images'][0] == "")
                            ? Image.network(
                                'https://picsum.photos/250?image=9',
                                height: 75.0,
                                width: 75.0,
                              )
                            : CachedNetworkImage(
                                imageUrl: documentSnapshot['images'][0],

                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                // fit: BoxFit.cover,
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
                                // documentSnapshot['title'],
                                // documentSnapshot['content'],
                                // documentSnapshot['images'],
                                // documentSnapshot.id,
                                // documentSnapshot['mood'],
                                documentSnapshot
                              ]);
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
