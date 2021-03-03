import 'package:flutter/material.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Pages/start.dart';
import 'package:daybook/Services/db_services.dart';
import 'package:daybook/Pages/entries.dart';

class CreateEntryScreen extends StatefulWidget {
  @override
  _CreateEntryScreenState createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Text("Create Entry",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 25.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Column(children: [
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  // labelText: "Title",
                                  border: InputBorder.none,
                                  // focusedBorder: InputBorder.none,
                                  // enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  hintText: 'Title'),
                              autofocus: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title cannot be empty !';
                                }
                                return null;
                              },
                            ), // name
                            SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              controller: contentController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  // labelText: "Content",
                                  labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  hintText: 'Write something here !'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Content cannot be empty !';
                                }
                                return null;
                              },
                            ),
                            RaisedButton(
                                child: Text('Create'),
                                color: Colors.orange[300],
                                onPressed: () {
                                  createEntry(
                                    titleController.text,
                                    contentController.text,
                                  );
                                  Navigator.pop(context);
                                })
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
