import 'package:flutter/material.dart';
import 'package:daybook/Services/habitService.dart';

class CreateHabitScreen extends StatefulWidget {
  @override
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TimeOfDay time;
  int flag = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (flag == 0) {
        time = TimeOfDay.now();
        flag = 1;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Habit",
        ),
        leading: Builder(
          //Using builder here to provide required context to display the Snackbar.

          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  createHabit(titleController.text, time);
                  Navigator.pop(context);
                  print("Habit form validated");
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
                    GestureDetector(
                      child: Chip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${time.format(context)}",
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        avatar: Icon(Icons.alarm),
                        backgroundColor: Color(0xffffe9b3),
                      ),
                      onTap: _pickTime,
                    )
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null) {
      setState(() {
        time = t;
      });
    }
  }
}
