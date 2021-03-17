import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:daybook/Pages/EnlargedImage.dart';

class DisplayEntryScreen extends StatefulWidget {
  @override
  _DisplayEntryScreenState createState() => _DisplayEntryScreenState();
}

class _DisplayEntryScreenState extends State<DisplayEntryScreen> {
  // Future<void> handleEdit() async {}

  // Future<void> handleDelete() async {
  //   deleteEntry(documentSnapshot);}

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot documentSnapshot = arguments[0];
    List<dynamic> imageUrls = documentSnapshot["images"];
    print("checking :" + documentSnapshot['title']);
    print("checking :" + documentSnapshot.toString());
    Widget _imagesGrid() {
      return Container(
        height: 140,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisSpacing: 2,
          mainAxisSpacing: 4,
          crossAxisCount: 1,
          children: List.generate(imageUrls.length, (index) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    print("Long Press Registered !!!");
                    setState(() {
                      imageUrls.removeAt(index);
                    });
                  },
                  onTap: () {
                    print("Tap registered !!");
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return EnlargedImage(imageUrls[index]);
                    }));
                  },
                  child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        child: Image.file(File(imageUrls[index]),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ],
            );
          }),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Entry",
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
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
            child: Icon(
              Icons.delete,
              size: 20,
            ),
          ),
          SizedBox(width: 30,),
          GestureDetector(
            child: Icon(
              Icons.edit,
              size: 20,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/createEntry', arguments: [
                documentSnapshot["title"],
                documentSnapshot["content"],
                documentSnapshot["images"],
                documentSnapshot.id,
                documentSnapshot["mood"],
                documentSnapshot
              ]);
            },
          ),
          SizedBox(width: 25,),
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
                        documentSnapshot['content'],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontFamily: "Times New Roman"),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      imageUrls.length != 0
                          ? _imagesGrid()
                          : SizedBox(
                              height: 1,
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
