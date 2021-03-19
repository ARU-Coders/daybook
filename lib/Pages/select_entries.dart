import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:daybook/Services/journeyService.dart';

class SelectEntriesScreen extends StatefulWidget {
  @override
  _SelectEntriesScreenState createState() => _SelectEntriesScreenState();
}

class _SelectEntriesScreenState extends State<SelectEntriesScreen> {
  List<dynamic> selectedEntries = [];
  int flag = 0;
  // final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot documentSnapshot = arguments[0];
    print(flag);
    // setState(() {
    if (flag == 0) {
      selectedEntries = documentSnapshot['entries'];
    }
    // });
    return Scaffold(
      appBar: AppBar(
          title: Text("Add to Journey"),
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            GestureDetector(
                child: Icon(
                  Icons.check,
                  size: 25,
                ),
                onTap: () {
                  addEntriestoJourney(documentSnapshot.id, selectedEntries);
                  Navigator.pop(context);
                }),
            SizedBox(
              width: 20,
            )
          ]),
      backgroundColor: Color(0xFF111111),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // child: Container(
          child: Expanded(
            child: StreamBuilder(
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
                        return ListTile(
                          title: Card(
                            color: selectedEntries.contains(ds.id)
                                ? Colors.grey[400]
                                : Colors.grey[100],
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
                            print("tapped on " + ds.id);
                            setState(() {
                              if (selectedEntries.contains(ds.id)) {
                                flag = 1;
                                selectedEntries.remove(ds.id);
                              } else {
                                flag = 1;
                                selectedEntries.add(ds.id);
                              }
                            });
                          },
                        );
                      });
                }),
            // ),
            // ],
            // ),
          ),
        ),
      ),
    );
  }
}
