import 'package:daybook/Models/habitSeries.dart';

Map<String, String> monthMap = {
  '1': 'Jan',
  '2': 'Feb',
  '3': 'Mar',
  '4': 'Apr',
  '5': 'May',
  '6': 'Jun',
  '7': 'July',
  '8': 'Aug',
  '9': 'Sept',
  '10': 'Oct',
  '11': 'Nov',
  '12': 'Dec'
};

//Map Structure:
// yearlyCount = {
//   '2021' : {
//     'count' : 0,
//     'months': {
//        'Jan': {
//           'count': 0
//           'weeks': {
//              'Week1' : 0
//           }
//         }
//      }
//   }
// }

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
  }
  return streak.toString();
}

String getBestStreak(dates) {
  if (dates == null || dates.length == 0) return "0";
  if (dates.length == 1) return "1";
  dates = List<String>.from(dates);
  int max = 1, curr = 1, i = 0;

  for (i = 0; i < dates.length - 1; ++i) {
    curr = (DateTime.parse(dates[i]).add(Duration(days: 1)) ==
            DateTime.parse(dates[i + 1]))
        ? curr + 1
        : 1;
    if (curr > max) {
      max = curr;
    }
  }
  return max.toString();
}

List<dynamic> getHabitStats(List<dynamic> days) {
  List<String> daysComp = List<String>.from(days);
  Map yearlyCount = {};

  for (String i in daysComp) {
    DateTime dt = DateTime.parse(i);
    if (yearlyCount.keys.contains(dt.year.toString())) {
      yearlyCount[dt.year.toString()]['count'] += 1;
      yearlyCount[dt.year.toString()]['months'][monthMap[dt.month.toString()]]
          ['count'] += 1;
    } else {
      yearlyCount[dt.year.toString()] = {
        'count': 1,
        'months': {
          'Jan': {'count': 0, 'weeks': {}},
          'Feb': {'count': 0, 'weeks': {}},
          'Mar': {'count': 0, 'weeks': {}},
          'Apr': {'count': 0, 'weeks': {}},
          'May': {'count': 0, 'weeks': {}},
          'Jun': {'count': 0, 'weeks': {}},
          'July': {'count': 0, 'weeks': {}},
          'Aug': {'count': 0, 'weeks': {}},
          'Sept': {'count': 0, 'weeks': {}},
          'Oct': {'count': 0, 'weeks': {}},
          'Nov': {'count': 0, 'weeks': {}},
          'Dec': {'count': 0, 'weeks': {}}
        }
      };
      yearlyCount[dt.year.toString()]['months'][monthMap[dt.month.toString()]]
          ['count'] += 1;
    }
  }

  final List<HabitYearSeries> yearlyData = [];
  for (var i in yearlyCount.keys) {
    yearlyData
        .add(new HabitYearSeries(yearCount: yearlyCount[i]['count'], year: i));
  }

  final List<HabitMonthSeries> monthlyData = [];
  for (var i in yearlyCount.keys) {
    for (var j in yearlyCount[i]['months'].keys) {
      monthlyData.add(new HabitMonthSeries(
          monthCount: yearlyCount[i]['months'][j]['count'],
          month: j + ' ' + i));
    }
  }
  return [yearlyData, monthlyData];
}
