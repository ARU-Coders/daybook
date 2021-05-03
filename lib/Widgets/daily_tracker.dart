import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool getCheckedValue() {
    return _controller.selectedDay != null
        ? List<String>.from(widget.ds['daysCompleted']).contains(DateTime(
                _controller.selectedDay.year,
                _controller.selectedDay.month,
                _controller.selectedDay.day)
            .toString())
        : List<String>.from(widget.ds['daysCompleted']).contains(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Map<DateTime, List<dynamic>> _completedDays = {};

    for (var dt in List<String>.from(widget.ds['daysCompleted'])) {
      _completedDays[DateTime.parse(dt)] = [dt];
    }

    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: width,
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: new BorderRadius.vertical(
                  top: new Radius.circular(20.0),
                  bottom: new Radius.circular(20.0),
                ),
              ),
              child: TableCalendar(
                events: _completedDays,
                onUnavailableDaySelected: () =>
                    print("Unavailable Day selected"),
                availableGestures: AvailableGestures.all,
                initialCalendarFormat: CalendarFormat.twoWeeks,
                initialSelectedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    outsideDaysVisible: false,
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
                  setState(() {});
                },
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
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
            ),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: width,
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: new BorderRadius.vertical(
                    top: new Radius.circular(20.0),
                    bottom: new Radius.circular(20.0),
                  ),
                ),
                child: Column(children: [
                  _controller.selectedDay != null
                      ? Text(
                          DateFormat.yMMMMd().format(_controller.selectedDay),
                          style: GoogleFonts.getFont('Oxygen',
                              fontWeight: FontWeight.w600, fontSize: 15))
                      : Text(DateFormat.yMMMMd().format(DateTime.now()),
                          style: GoogleFonts.getFont('Oxygen',
                              fontWeight: FontWeight.w600, fontSize: 15)),
                  _controller.selectedDay != null
                      ? _controller.selectedDay.isAfter(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              23,
                              23,
                              59))
                          ? Builder(builder: (BuildContext context) {
                              return IconButton(
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        "Can't check habit for a future date !",
                                        style: GoogleFonts.getFont(
                                          'Nunito',
                                        )),
                                    duration: Duration(seconds: 2),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                icon: Icon(Icons.check_box_outline_blank,
                                    color: Colors.grey),
                              );
                            })
                          : Checkbox(
                              value: getCheckedValue(),
                              onChanged: (value) async {
                                await HapticFeedback.vibrate();
                                markAsDone(
                                    widget.ds['habitId'],
                                    widget.ds['daysCompleted'],
                                    _controller.selectedDay);
                                setState(() {
                                  _count++;
                                  print(_count);
                                });
                              },
                            )
                      : Checkbox(
                          value: getCheckedValue(),
                          onChanged: (value) {
                            markAsDone(
                                widget.ds['habitId'],
                                widget.ds['daysCompleted'],
                                _controller.selectedDay);
                            setState(() {
                              _count++;
                            });
                          },
                        ),
                  getCheckedValue()
                      ? Text("Done",
                          style: GoogleFonts.getFont(
                            'Nunito',
                          ))
                      : Text("Not Done",
                          style: GoogleFonts.getFont(
                            'Nunito',
                          )),
                ])),
          ],
        ),
      ),
    );
  }
}
