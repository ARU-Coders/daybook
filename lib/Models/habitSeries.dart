import 'package:flutter/foundation.dart';

class HabitMonthSeries {
  final String month;
  final int monthCount;

  HabitMonthSeries({@required this.month, @required this.monthCount});
}

class HabitYearSeries {
  final String year;
  final int yearCount;
  // final charts.Color barColor;

  HabitYearSeries({
    @required this.year,
    @required this.yearCount,
    // @required this.barColor
  });
}
