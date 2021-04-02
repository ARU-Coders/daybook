import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daybook/Models/habitSeries.dart';
import 'package:daybook/Widgets/daily_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daybook/Services/habitService.dart';
import 'package:daybook/Widgets/habit_chart.dart';
import 'dart:math';

class HabitStatisticsPage extends StatefulWidget {
  final DocumentSnapshot ds;
  const HabitStatisticsPage({
    Key key,
    @required this.ds,
  }) : super(key: key);
  @override
  _HabitStatisticsPageState createState() => _HabitStatisticsPageState();
}

class _HabitStatisticsPageState extends State<HabitStatisticsPage> {
  Widget statCard(
    emoji,
    value,
    title, {
    color: const Color(0xff8ebbf2),
  }) {
    return Card(
      elevation: 2,
      color: color,
      child: InkWell(
        splashColor: Colors.white30,
        onLongPress: () async {
          await HapticFeedback.mediumImpact();
        },
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 3),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont("Lora",
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(title,
                style: GoogleFonts.getFont("Merriweather", fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String getCurrentStreak(dates) {
    final now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    if (dates == null || dates.length == 0) return "0";
    if (DateTime.parse(dates[dates.length - 1]) != today) return "0";
    int streak = 0;
    for (int i = dates.length - 1; i >= 0; --i) {
      if (DateTime.parse(dates[i]) !=
          today.subtract(Duration(days: dates.length - 1 - i))) {
        break;
      }
      streak++;
      // today = today.subtract(const Duration(days: 1));
    }
    print("Current Streak : " + streak.toString());
    return streak.toString();
  }

  String getBestStreak(dates) {
    if (dates == null || dates.length == 0) return "0";
    dates = List<String>.from(dates);
    DateTime j;
    // final now = DateTime.now();
    // final today = DateTime(now.year, now.month, now.day);
    // if (DateTime.parse(dates[dates.length - 1]) != today) return "0";
    Set s = Set();
    for (dynamic i in dates) {
      s.add(DateTime.parse(i));
    }
    var ans = 0;
    for (int i = 0; i < dates.length; i++) {
      if (s.contains(DateTime.parse(dates[i]))) {
        j = DateTime.parse(dates[i]);
      }
      while (s.contains(j)) {
        DateTime dt = j;
        j = DateTime(dt.year, dt.month, dt.day + 1);
      }
      ans = max(ans, j.day - DateTime.parse(dates[i]).day);
    }
    print(ans);
    return ans.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HabitHeader(
            ds: widget.ds,
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder(
                        stream: getSingleHabitStream(widget.ds['habitId']),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading");
                          }
                          return Column(
                            children: [
                              DailyTracker(
                                ds: snapshot.data,
                              ),
                              GridView.count(
                                primary: false,
                                childAspectRatio: (7 / 8),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 15),
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 3,
                                children: <Widget>[
                                  statCard(
                                    '🔥',
                                    getCurrentStreak(
                                        snapshot.data['daysCompleted']),
                                    'Current \nStreak',
                                  ),
                                  statCard(
                                    '🔥🔥',
                                    getBestStreak(
                                        snapshot.data['daysCompleted']),
                                    'Best \nStreak',
                                  ),
                                  statCard(
                                    '⚡',
                                    snapshot.data['daysCompleted'].length
                                        .toString(),
                                    'Successful \ndays',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Habit Chart",
                              ),
                              HabitChart(
                                  daysCompleted:
                                      snapshot.data['daysCompleted']),
                            ],
                          );
                        }),
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

class HabitHeader extends StatelessWidget {
  const HabitHeader({
    Key key,
    @required this.ds,
  }) : super(key: key);

  final DocumentSnapshot ds;

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
    String timeString = formatTime(
        ds['reminder'].toString(),
        ds['frequency'].toString(),
        context,
        ds['frequency'].toString() == "Weekly" ? ds['day'].toString() : null);

    double width = MediaQuery.of(context).size.width;
    var appbarHeight = AppBar().preferredSize.height;
    return Container(
        width: width,
        decoration: new BoxDecoration(
          color: Colors.pink[200],
          // boxShadow: [new BoxShadow(blurRadius: 3.0)],
          borderRadius:
              new BorderRadius.vertical(bottom: new Radius.circular(40.0)),
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
                            content:
                                Text("This will delete the Habit permanently."),
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
                                          color: Colors.red, fontSize: 15),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
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
                  style: GoogleFonts.getFont(
                    'Oxygen',
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
