import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:daybook/Services/habitService.dart';

class DailyTracker extends StatefulWidget {
  final DocumentSnapshot ds;
  const DailyTracker({
    Key key,
    @required this.ds,
  }) : super(key: key);
  @override
  _DailyTrackerState createState() => _DailyTrackerState();
}

class _DailyTrackerState extends State<DailyTracker> {
  DateTime now = DateTime.now();
  CalendarController _controller = CalendarController();
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<dynamic>> _completedDays = {};
    for (var dt in List<String>.from(widget.ds['daysCompleted'])) {
      _completedDays[DateTime.parse(dt)] = [dt];
    }
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _completedDays,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  todayColor: Colors.orange,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, _) {
                setState(() {
                  _count++;
                });
              },
              onDayLongPressed: (date, events, _) async {
                await _showDialog();
                DocumentSnapshot documentSnapshot =
                    await getHabit(widget.ds.id);
                Navigator.popAndPushNamed(context, '/habitStatistics',
                    arguments: [documentSnapshot]);
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
            ListTile(
              title: _controller.selectedDay != null
                  ? List<String>.from(widget.ds['daysCompleted']).contains(
                          DateTime(
                                  _controller.selectedDay.year,
                                  _controller.selectedDay.month,
                                  _controller.selectedDay.day)
                              .toString())
                      ? Text(
                          DateFormat.yMMMMd().format(_controller.selectedDay) +
                              ": \t\tDone")
                      : Text(
                          DateFormat.yMMMMd().format(_controller.selectedDay) +
                              ": \t\tNot Done")
                  : Text(_controller.selectedDay.toString()),
            )
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          DateFormat.yMMMMd().format(_controller.selectedDay),
        ),
        content: List<String>.from(widget.ds['daysCompleted']).contains(
                DateTime(
                        _controller.selectedDay.year,
                        _controller.selectedDay.month,
                        _controller.selectedDay.day)
                    .toString())
            ? Text("Want to mark habit as not done?")
            : Text("Want to mark habit as done?"),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                onPressed: () {
                  markAsDone(widget.ds['habitId'], widget.ds['daysCompleted'],
                      _controller.selectedDay);
                  Navigator.of(context).pop();
                  setState(() {
                    _count++;
                  });
                },
                child: Text(
                  "Yes",
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
