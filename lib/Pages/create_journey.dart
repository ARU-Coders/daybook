import 'package:flutter/material.dart';
import 'package:daybook/Services/journeyService.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  _CreateJourneyScreenState createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends State<CreateJourneyScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Journey",
        ),
        leading: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              createJourney(
                  titleController.text,
                  descriptionController.text,
                  DateTime.parse(startDateController.text),
                  DateTime.parse(endDateController.text));
              Navigator.pop(context);
            }
          },
        ),
        // actions: <Widget>[
        //   PopupMenuButton<String>(
        //     onSelected: handleMenuClick,
        //     itemBuilder: (BuildContext context) {
        //       return menuItems.map((String choice) {
        //         return PopupMenuItem<String>(
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                child: Form(
                    key: _formKey,
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
                            TextFormField(
                              // style: TextStyle(
                              //     color: Colors.black87,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: "Times New Roman"),
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: "Title",
                                // hintText: 'Enter Journey Title Here!!'/
                              ),
                              autofocus: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title cannot be empty !';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: startDateController,
                              decoration: InputDecoration(
                                labelText: "start date",
                              ),
                              onTap: () async {
                                DateTime date = DateTime(1900);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                startDateController.text =
                                    date.toIso8601String();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Start Date cannot be empty !';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                            TextFormField(
                              controller: endDateController,
                              decoration: InputDecoration(
                                labelText: "end date",
                              ),
                              onTap: () async {
                                DateTime date = DateTime(1900);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                endDateController.text = date.toIso8601String();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'End Date cannot be empty !';
                                } else if (DateTime.parse(
                                        startDateController.text)
                                    .isAfter(DateTime.parse(value))) {
                                  return "End Date can't be before start date";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                            TextFormField(
                              // style: TextStyle(
                              //     color: Colors.black87,
                              //     fontSize: 16,
                              //     fontFamily: "Times New Roman"),
                              controller: descriptionController,
                              minLines: 5,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelText: "Description",
                                // hintText: 'Write Something Here!!'
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Content cannot be empty !';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                          ]),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
}
