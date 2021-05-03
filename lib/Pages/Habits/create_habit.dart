import 'package:flutter/material.dart';
import 'package:daybook/Services/habitService.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateHabitScreen extends StatefulWidget {
  @override
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TimeOfDay time;
  int flag = 0;
  String _chosenValue = 'Daily';
  bool isExpanded = false;
  String _chosenDay = 'Monday';

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
          style: GoogleFonts.getFont('Lato'),
        ),
        leading: Builder(
          //Using builder here to provide required context to display the Snackbar.

          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (_chosenValue == 'Daily') {
                    createHabit(titleController.text, time, _chosenValue);
                  } else {
                    createHabit(titleController.text, time, _chosenValue,
                        day: _chosenDay);
                  }
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

                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        // focusColor: Colors.white,
                        value: _chosenValue,
                        elevation: 5,
                        underline: Container(
                          height: 1,
                          // color: Colors.black87,
                        ),
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        // iconEnabledColor: Colors.black,
                        items: <String>[
                          'Daily',
                          'Weekly',
                          // 'Monthly',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              // style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Please choose any one",
                          style: TextStyle(
                              // color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                    if (_chosenValue == 'Daily') _dailyFormFields(),
                    if (_chosenValue == 'Weekly') _weeklyFormFields(),
                    // if (_chosenValue == 'Monthly') _monthlyFormFields(),
                    // _chosenValue == 'Weekly' ? Text('Chose Weekly'): null;
                    // _chosenValue == 'Monthly' ? Text('Chose Monthly'): null;
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dailyFormFields() {
    return GestureDetector(
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
        avatar: Icon(Icons.alarm, color: Colors.black),
        backgroundColor: Color(0xffffe9b3),
      ),
      onTap: _pickTime,
    );
  }

  Widget _weeklyFormFields() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownButton<String>(
          // focusColor: Colors.white,
          value: _chosenDay,
          elevation: 5,
          underline: Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          isExpanded: true,
          // style: TextStyle(color: Colors.white),
          // iconEnabledColor: Colors.black,
          items: <String>[
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                // style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            "Please choose any one",
            style: TextStyle(
                // color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          onChanged: (String value) {
            setState(() {
              _chosenDay = value;
            });
          },
        ),
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
          avatar: Icon(Icons.alarm, color: Colors.black),
          backgroundColor: Color(0xffffe9b3),
        ),
        onTap: _pickTime,
      )
    ]);
  }

  // Widget _monthlyFormFields() {
  //   return Text('');
  // }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null) {
      setState(() {
        time = t;
      });
    }
  }
}
