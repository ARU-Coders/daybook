import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Provider/theme_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  DateTime _focusedDay, _selectedDay, kToday, kFirstDay, kLastDay;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  List<String> list = [];
  HashSet<String> completedSet = HashSet<String>();
  Map<DateTime, List<dynamic>> _completedDays = {};

  String stripDate(DateTime d) => d.toString().replaceAll("Z", "");

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    kToday = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay = kToday;
    kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

    for (var dt in List<String>.from(widget.ds['daysCompleted'])) {
      _completedDays[DateTime.parse(dt)] = [dt];
      completedSet.add(dt.toString());
    }
    print(completedSet);
  }

  // CalendarController _controller = CalendarController();
  int _count = 0;
  bool getCheckedValue() {
    return _selectedDay != null
        ? List<String>.from(widget.ds['daysCompleted']).contains(
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)
                .toString())
        : List<String>.from(widget.ds['daysCompleted']).contains(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);

    double width = MediaQuery.of(context).size.width;

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
                availableGestures: AvailableGestures.all,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() => _calendarFormat = format);
                  }
                },
                calendarStyle: CalendarStyle(
                  canMarkersOverflow: true,
                  markersOffset: PositionedOffset(bottom: 30),
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(color: Colors.black),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white),
                  weekendTextStyle: TextStyle(
                      color: _themeProvider.getTheme == lightTheme
                          ? Colors.green[600]
                          : Colors.lightGreen[200]),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                    weekendStyle: TextStyle(
                        color: _themeProvider.getTheme == lightTheme
                            ? Colors.green
                            : Colors.lightGreen)),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                  formatButtonVisible: true,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    if (_selectedDay != selectedDay) _selectedDay = selectedDay;

                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, date, events) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: date.isAfter(kToday) && !isSameDay(date, kToday)
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                          border: isSameDay(date, kToday)
                                  ? Border.all(color: Colors.orange, width: 1.5)
                                  : null,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  todayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                      )),
                  markerBuilder: (context, day, events) {
                    return completedSet.contains(stripDate(day))
                        ? Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Icon(Icons.check, size: 12),
                          )
                        : SizedBox();
                  },
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
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
              child: Column(
                children: [
                  _selectedDay != null
                      ? Text(DateFormat.yMMMMd().format(_selectedDay),
                          style: GoogleFonts.getFont('Oxygen',
                              fontWeight: FontWeight.w600, fontSize: 15))
                      : Text(DateFormat.yMMMMd().format(DateTime.now()),
                          style: GoogleFonts.getFont('Oxygen',
                              fontWeight: FontWeight.w600, fontSize: 15)),
                  _selectedDay != null
                      ? _selectedDay.isAfter(DateTime(
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
                              onChanged: (markedAsDone) async {
                                await HapticFeedback.vibrate();
                                markAsDone(widget.ds['habitId'],
                                    widget.ds['daysCompleted'], _selectedDay);

                                if (markedAsDone)
                                  completedSet.add(_selectedDay
                                      .toString()
                                      .replaceAll("Z", ""));
                                else {
                                  completedSet.remove(_selectedDay
                                      .toString()
                                      .replaceAll("Z", ""));
                                }
                                // });

                                setState(() {
                                  _count++;
                                  print(_count);
                                });
                              },
                            )
                      : Checkbox(
                          value: getCheckedValue(),
                          onChanged: (markedAsDone) {
                            markAsDone(widget.ds['habitId'],
                                widget.ds['daysCompleted'], _selectedDay);
                            setState(() {
                              _count++;
                              if (markedAsDone)
                                completedSet.add(_selectedDay
                                    .toString()
                                    .replaceAll("Z", ""));
                              else {
                                completedSet.remove(_selectedDay
                                    .toString()
                                    .replaceAll("Z", ""));
                              }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
