import 'package:daybook/Provider/theme_change.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Services/habitService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateHabitScreen extends StatefulWidget {
  @override
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  // int flag = 0;
  bool isWeekly = false;
  String _chosenValue = 'Daily';
  bool isExpanded = false;
  String _chosenDay = 'Monday';
  Color selectedColor = habitsColorPalette[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Create Habit",
          style: GoogleFonts.getFont('Lato'),
        ),
        backgroundColor: selectedColor,
        leading: Builder(
          //Using builder here to provide required context to display the Snackbar.
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  if (_chosenValue == 'Daily') {
                    createHabit(titleController.text, time, _chosenValue, habitsColorToStringMap[selectedColor]);
                  } else {
                    createHabit(titleController.text, time, _chosenValue, habitsColorToStringMap[selectedColor],
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Habit Name",
                          style: TextStyle(
                            // color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                        SizedBox(height:10),
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
                      ],
                    ),

                    SizedBox(
                      height: 30.0,
                    ),
                    divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                        padding: const EdgeInsets.only(bottom: 14, right: 3, left: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text("Frequency",
                              style: TextStyle(
                                // color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Daily"),
                                Switch(
                                  value: isWeekly,
                                  inactiveTrackColor: selectedColor,
                                  activeColor: selectedColor,
                                  onChanged: (value) {
                                    setState(() {
                                      isWeekly = value;
                                      _chosenValue = isWeekly? "Weekly" : "Daily";
                                    });
                                  },
                                ),
                                Text("Weekly"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_chosenValue == 'Weekly') _weeklyFormFields(),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "Reminder",
                            style: TextStyle(
                                // color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                            SizedBox(height: 10,),
                            reminderTimeChip(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25,),
                    divider(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "Habit Color",
                            style: TextStyle(
                                // color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: 50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  itemCount: habitsColorPalette.length,
                                  itemBuilder: (context, index) {
                                    final color = habitsColorPalette[index];
                                    return colorButton(color);
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  divider(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical:5),
      child: Divider(),
    );
  }
  colorButton(Color color){
    var _themeProvider = Provider.of<ThemeChanger>(context);
    return
      Padding(
        padding: EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () => setState(() => selectedColor = color),
          child: Container(
            width: 35,
            height: 35,
            decoration: new BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: _themeProvider.getTheme == lightTheme ? Colors.black45: Colors.white70,
                width: 2.0
              ),
            ),
          ),
        ),
      );
  }

  InputDecoration textFormFieldDecoration(String lbl) {
    return InputDecoration(
        labelText: lbl,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.blueGrey)));
  }

  Widget _weeklyFormFields() {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width*0.4,
        child: DropdownButtonFormField(
          decoration: textFormFieldDecoration("Day"),
          dropdownColor: Theme.of(context).cardColor,
          value: _chosenDay,
          elevation: 1,
          isExpanded: true,
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
                style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
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

    ]);
  }

  reminderTimeChip(){
    return 
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
        backgroundColor: selectedColor,
      ),
      onTap: _pickTime,
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
