import 'package:flutter/material.dart';
import 'package:daybook/Services/taskService.dart';
import 'package:daybook/Widgets/LoadingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFF111111),
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
                              color: Colors.white,
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
                              ? Colors.grey[400]
                              : Colors.blueGrey[200],
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            GestureDetector(
                              onLongPress: () {
                                //delete ka alert
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
                              child: CheckboxListTile(
                                title: Text(ds['title']),
                                value: ds['isChecked'],

                                onChanged: (newValue) {
                                  onCheckTask(ds['taskId'], !ds['isChecked']);
                                },
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
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
                onPressed: () async {
                  return await buildShowDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> buildShowDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              TextFormField(
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Times New Roman"),
                controller: noteController,
                decoration: InputDecoration(hintText: 'Description'),
                autofocus: false,
                minLines: 2,
                maxLines: 4,
                validator: (value) {
                  print("Note is empty");
                  // if (value.isEmpty) {
                  //   return 'Title cannot be empty !';
                  // }
                  return null;
                },
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
                    DateTime dueDate = DateTime.now();

                    //Save task
                    await createTask(
                        titleController.text, noteController.text, dueDate);

                    //Clear text controller values after saving the task.
                    titleController.clear();
                    noteController.clear();
                    Navigator.of(context).pop();
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
      ),
    );
  }
}
