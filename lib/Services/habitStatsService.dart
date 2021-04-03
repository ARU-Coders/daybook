import 'package:daybook/Models/habitSeries.dart';

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

// Future<void> getHabitYearlyCount(
//   String habitId,
// ) async {
//   DocumentReference userDoc = await getUserDocRef();
//   DocumentSnapshot doc = await userDoc.collection('habits').doc(habitId).get();
//   List<String> daysComp = List<String>.from(doc['daysCompleted']);
//   Map<String, int> yearlyCount = {};

//   for (String i in daysComp) {
//     DateTime dt = DateTime.parse(i);
//     if (yearlyCount.keys.contains(dt.year.toString())) {
//       yearlyCount[dt.year.toString()]++;
//     } else {
//       yearlyCount[dt.year.toString()] = 1;
//     }
//   }
//   print(yearlyCount);
//   // return doc;
// }

List<HabitSeries> getHabitMonthlyCount(
    List<dynamic> days, String requiredYear) {
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

  List<String> daysComp = List<String>.from(days);
  Map<String, int> monthlyCount = {
    'Jan': 0,
    'Feb': 0,
    'Mar': 0,
    'Apr': 0,
    'May': 0,
    'Jun': 0,
    'July': 0,
    'Aug': 0,
    'Sept': 0,
    'Oct': 0,
    'Nov': 0,
    'Dec': 0
  };

  for (String i in daysComp) {
    DateTime dt = DateTime.parse(i);
    if (dt.year.toString() == requiredYear) {
      if (monthlyCount.keys.contains(monthMap[dt.month.toString()])) {
        monthlyCount[monthMap[dt.month.toString()]]++;
      } else {
        monthlyCount[monthMap[dt.month.toString()]] = 1;
      }
    }
  }
  final List<HabitSeries> monthlyData = [];
  for (var i in monthlyCount.keys) {
    monthlyData.add(new HabitSeries(habitCount: monthlyCount[i], xval: i));
  }
  return monthlyData;
}
