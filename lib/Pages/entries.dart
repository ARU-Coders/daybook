import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/entryService.dart';

class EntriesScreen extends StatefulWidget {
  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final List<int> colorCodes = <int>[400, 300, 200];
  final String image = 'https://picsum.photos/250?image=9';

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
                    return Text("Loading...");
                  }
                  return new ListView.builder(
                      padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return EntryCard(
                            colorCodes: colorCodes,
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

  final List<int> colorCodes;
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
      color: Colors.amber[colorCodes[index % 3]],
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
                onTap: () {
                  print("Tapped on entry $entryId");
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
                  // return AlertDialog(
                  //   title: Text("Detele Entry ?"),
                  //   content: Text("This will delete the Entry permanently."),
                  //   actions: <Widget>[
                  //     Row(
                  //       children: [
                  //         TextButton(
                  //           child: Text('Delete'),
                  //           onPressed: () {
                  //             deleteEntry(documentSnapshot);
                  //           },
                  //         ),
                  //         TextButton(
                  //           child: Text('Cancel'),
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // );
                  // deleteEntry(documentSnapshot);
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
                        onTap: () {},
                        child: Icon(
                          Icons.star,
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
