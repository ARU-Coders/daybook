import 'package:flutter/material.dart';
import 'package:daybook/Services/journeyService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  _CreateJourneyScreenState createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends State<CreateJourneyScreen> {
  final _formKey = GlobalKey<FormState>();

  String documentId;
  DocumentSnapshot previousSnapshot;

  bool isEditing = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  static String initialStartDate = "Not set";
  static String initialEndDate = "Not set";

  //Default value of both Start date and End date will be curret datetime.
  //If isEditing = True, start and end dates will display values read from the database.
  String startDate = initialStartDate;
  String endDate = initialEndDate;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;

    if (arguments != null && arguments.length != 0 && !isEditing) {
      titleController.text = arguments[0]['title'];
      descriptionController.text = arguments[0]['description'];
      documentId = arguments[0].id;
      startDate = arguments[0]['startDate'];
      endDate = arguments[0]['endDate'];
      previousSnapshot = arguments[0];
      isEditing = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Journey",
        ),
        leading: Builder(
          //Using builder here to provide required context to display the Snackbar.

          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  //Validation 1 : End date >= Start Date
                  if (DateTime.parse(startDate)
                      .isAfter(DateTime.parse(endDate))) {
                    final snackBar = SnackBar(
                      content: Text('End Date can\'t be before start date !'),
                      duration: Duration(seconds: 3),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    return;
                  }

                  //Validation 2 : Start date cannot be a future date.
                  if (DateTime.parse(startDate).isAfter(DateTime.now())) {
                    final snackBar = SnackBar(
                      content: Text('Start date cannot be a future date !'),
                      duration: Duration(seconds: 3),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    return;
                  }

                  if (isEditing) {
                    //Edit the journey
                    editJourney(
                        arguments[0].id,
                        titleController.text,
                        descriptionController.text,
                        DateTime.parse(startDate),
                        DateTime.parse(endDate));

                    DocumentSnapshot updatedDocumentSnapshot =
                        await previousSnapshot.reference.get();

                    Navigator.popAndPushNamed(context, '/displayJourney',
                        arguments: [updatedDocumentSnapshot]);
                  } else {
                    //Create new journey in the database
                    DocumentReference docRef = await createJourney(
                        titleController.text,
                        descriptionController.text,
                        DateTime.parse(startDate),
                        DateTime.parse(endDate));
                    DocumentSnapshot documentSnapshot = await docRef.get();
                    Navigator.popAndPushNamed(context, '/displayJourney',
                        arguments: [documentSnapshot]);
                  }
                }
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Column(children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title cannot be empty !';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      minLines: 5,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Content cannot be empty !';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Start Date')),
                    SizedBox(height: 15),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () async {
                        DateTime date = isEditing
                            ? DateTime.parse(startDate)
                            : DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          setState(() {
                            startDate = date.toString();
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  startDate == initialStartDate
                                      ? startDate
                                      : DateFormat.yMMMMd()
                                          .format(DateTime.parse(startDate)),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 55.0,
                    ),
                    Align(
                        alignment: Alignment.topLeft, child: Text('End Date')),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () async {
                        DateTime date = isEditing
                            ? DateTime.parse(endDate)
                            : DateTime.now();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          setState(() {
                            endDate = date.toString();
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  endDate == initialEndDate
                                      ? endDate
                                      : DateFormat.yMMMMd()
                                          .format(DateTime.parse(endDate)),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                              ],
                            ),
                            Text(
                              "  Change",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
