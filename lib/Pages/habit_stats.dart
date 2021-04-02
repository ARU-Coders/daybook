import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Widgets/daily_tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daybook/Services/habitService.dart';

class HabitStatisticsPage extends StatefulWidget {
  @override
  _HabitStatisticsPageState createState() => _HabitStatisticsPageState();
}

class _HabitStatisticsPageState extends State<HabitStatisticsPage> {
  String formatTime(time, frequency, context, [day]) {
    int h = int.parse(time.split(":")[0]);
    int m = int.parse(time.split(":")[1]);
    String formattedTime = TimeOfDay(hour: h, minute: m).format(context);
    String timeString = frequency == "Daily"
        ? "Everyday at $formattedTime"
        : "Every $day at $formattedTime";
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var appbarHeight = AppBar().preferredSize.height;

    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot ds = arguments[0];

    String timeString = formatTime(
        ds['reminder'].toString(),
        ds['frequency'].toString(),
        context,
        ds['frequency'].toString() == "Weekly" ? ds['day'].toString() : null);

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 135.0,
              width: width,
              decoration: new BoxDecoration(
                color: Colors.pink[200],
                // boxShadow: [new BoxShadow(blurRadius: 3.0)],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.circular(40.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      Container(
                        height: appbarHeight,
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: Text("Detele Habit ?"),
                                  content: Text(
                                      "This will delete the Habit permanently."),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        FlatButton(
                                          onPressed: () {
                                            deleteHabit(ds);
                                            Navigator.of(context).pop();
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
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 25,
                          ),
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        ds['title'],
                        style: GoogleFonts.getFont(
                          'Merriweather',
                          color: Colors.grey[900],
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$timeString",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Times New Roman"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Calendar View',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DailyTracker(
                      ds: ds,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
