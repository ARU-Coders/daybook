import 'package:flutter/material.dart';
import 'package:daybook/Services/taskService.dart';
import 'package:daybook/Widgets/LoadingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/No-Tasks.png',
                            height: 250.0,
                            // width: 200.0,
                          ),
                          Text(
                            "No tasks created !! \n Click on + to get started",
                            style: GoogleFonts.getFont(
                              'Lato',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
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
                                title: Text(
                                  ds['title'],
                                  style: GoogleFonts.getFont('Merriweather',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration: ds['isChecked']
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    DateFormat.yMMMMd()
                                        .format(DateTime.parse(ds['dueDate'])),
                                    style: GoogleFonts.getFont('Oxygen',
                                        fontSize: 13,
                                        decoration: ds['isChecked']
                                            ? TextDecoration.lineThrough
                                            : null),
                                  ),
                                ),
                                value: ds['isChecked'],
                                onChanged: (newValue) async{
                                  await HapticFeedback.vibrate();
                                  onCheckTask(ds['taskId'], !ds['isChecked']);
                                },
                                secondary: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.black87,
                                  onPressed: () async{
                                    await HapticFeedback.vibrate();
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
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 15),
                                                ),
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
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  int flag = 0;
  DateTime pickedDate;
  TimeOfDay time;
  bool setReminder = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> cancelNotification(int notifId) async {
    await flutterLocalNotificationsPlugin.cancel(notifId);
  }

  Future onSelectNotification(String notifId) async {
    await cancelNotification(int.parse(notifId));
    print("Notif canceled");
    return "Notif canceled";
    // return Navigator.pushNamed(context, '/start');
  }

  Future<void> scheduleNotification(
      DateTime scheduledNotificationDateTime, String notifTitle) async {
    // var scheduledNotificationDateTime =
    //     DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'Tasks',
      'Reminders of Tasks',
      // icon: 'flutter_devs',
      // largeIcon: BitmapFactory.decodeFile(Image.asset('assets/images/logo.png')),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    int notifId = DateTime.now().millisecondsSinceEpoch % 10000;
    await flutterLocalNotificationsPlugin.schedule(
      notifId,
      notifTitle,
      'Don\'t forget to complete your task on time !',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: notifId.toString(),
    );
  }

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
              padding: EdgeInsets.fromLTRB(0, 30, 50, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  title: Text(
                    "Reminder",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Times New Roman"),
                    textAlign: TextAlign.start,
                  ),
                  trailing: Switch(
                    value: setReminder,
                    inactiveTrackColor: Color(0xffc3cade),
                    activeColor: Color(0xffadd2ff),
                    onChanged: (value) {
                      setState(() {
                        setReminder = value;
                        print(setReminder);
                      });
                    },
                  ),
                ),
              ),
            ),
            setReminder
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Chip(
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "${DateFormat.yMMMMd().format(pickedDate)}  ${time.format(context)}",
                              style: GoogleFonts.getFont(
                                'Oxygen',
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
                  )
                : SizedBox(),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  DateTime dueDate = DateTime(pickedDate.year, pickedDate.month,
                      pickedDate.day, time.hour, time.minute);

                  print("New Date " + dueDate.toString());

                  //Save task
                  Navigator.of(context).pop();
                  setReminder
                      ? await scheduleNotification(
                          dueDate, titleController.text)
                      : null;
                  await createTask(titleController.text, dueDate);
                  //Clear text controller values after saving the task.
                  titleController.clear();
                }
              },
              child: Text(
                "Add Task",
                style: TextStyle(fontSize: 15),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
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
