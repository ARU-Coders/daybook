import 'package:flutter/material.dart';
import 'package:daybook/Services/taskService.dart';
import 'package:daybook/Widgets/LoadingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController titleController = TextEditingController();
  DateTime pickedDate;
  TimeOfDay time;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            StreamBuilder(
                stream: getTasks(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingPage();
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No tasks created !! \n Click on + to get started",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: ds['isChecked']
                              ? Color(0xffc3cade)
                              : Color(0xffadd2ff),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(children: [
                            GestureDetector(
                              child: CheckboxListTile(
                                // checkColor: Colors.blue,
                                // activeColor: Colors.red,
                                title: Text(
                                  ds['title'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: ds['isChecked']? TextDecoration.lineThrough: null),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    DateFormat.yMMMMd()
                                        .format(DateTime.parse(ds['dueDate'])),
                                  style: TextStyle(decoration: ds['isChecked']? TextDecoration.lineThrough: null),
                                  ),
                                ),
                                value: ds['isChecked'],
                                onChanged: (newValue) {
                                  onCheckTask(ds['taskId'], !ds['isChecked']);
                                },
                                secondary: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.black87,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text("Detele Task ?"),
                                        content: Text(
                                            "This will delete the Task permanently."),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              FlatButton(
                                                onPressed: () {
                                                  deleteTask(ds);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Delete", style: TextStyle(color: Colors.red,fontSize: 14),),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel", style: TextStyle(color: Colors.green,fontSize: 16),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  );
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
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (_) {
                        return MyDialog();
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  int flag = 0;
  DateTime pickedDate;
  TimeOfDay time;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (flag == 0) {
        pickedDate = DateTime.now();
        time = TimeOfDay.now();
        flag = 1;
      }
    });

    return AlertDialog(
      title: Text("Add new Task"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Times New Roman"),
              controller: titleController,
              decoration: InputDecoration(hintText: 'Title'),
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title cannot be empty !';
                }
                return null;
              },
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 30, 35, 5),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reminder:",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Times New Roman"),
                      textAlign: TextAlign.start,
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Chip(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "${DateFormat.yMMMMd().format(pickedDate)}  ${time.format(context)}",
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    avatar: Icon(Icons.alarm),
                    backgroundColor: Color(0xffffe9b3),
                  ),
                  onTap: _pickDate,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  //Todo : Get due date (& time) from user
                  DateTime dueDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, time.hour, time.minute);

                  print("New Date " + dueDate.toString());
                  //Save task
                  Navigator.of(context).pop();
                  await createTask(titleController.text, dueDate);
                  titleController.clear();

                  //Clear text controller values after saving the task.
                }
              },
              child: Text("Add Task"),
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
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );

    if (date != null) {
      TimeOfDay t = await showTimePicker(context: context, initialTime: time);

      if (t != null) {
        pickedDate = date;
        time = t;
        print(date);
        print(t);
        setState(() {
          pickedDate = date;
          time = t;
        });
      }
    }
  }
}
