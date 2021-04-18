import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Future<Map<String, int>> getTimelineCounts(String tab, DateTime date) async {
  String beforeDate, afterDate;
  int year = date.year;
  int month = date.month;
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  if (tab == 'Year') {
    afterDate = DateTime(year - 1, 12, 31, 23, 23, 59).toString();
    beforeDate = DateTime(year + 1, 1, 1, 0, 0, 0).toString();
  } else {
    afterDate = DateTime(month == 1 ? year - 1 : year,
            month == 1 ? 12 : month - 1, 31, 23, 23, 59)
        .toString();
    beforeDate = DateTime(month == 12 ? year + 1 : year,
            month == 12 ? 1 : month + 1, 1, 0, 0, 0)
        .toString();
  }

  final int entryCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .orderBy('dateCreated')
      .snapshots()
      .length;

  final int journeyCount = await userDoc
      .collection('journeys')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .orderBy('dateCreated')
      .snapshots()
      .length;

  final int habitCount = await userDoc
      .collection('habits')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Terrible')
      .orderBy('dateCreated')
      .snapshots()
      .length;

  Map<String, int> timelineMap = {
    'entries': entryCount,
    'journeys': journeyCount,
    'habits': habitCount
  };

  print(timelineMap);

  return timelineMap;
}

Future<Map<String, double>> getMoodCount(String tab, DateTime date) async {
  print("Getmoodcount mai jaa raha hai kya?");
  String beforeDate, afterDate;
  int year = date.year;
  int month = date.month;
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);
  if (tab == 'Year') {
    afterDate = DateTime(year - 1, 12, 31, 23, 23, 59).toString();
    beforeDate = DateTime(year + 1, 1, 1, 0, 0, 0).toString();
  } else {
    afterDate = DateTime(month == 1 ? year - 1 : year,
            month == 1 ? 12 : month - 1, 31, 23, 23, 59)
        .toString();
    beforeDate = DateTime(month == 12 ? year + 1 : year,
            month == 12 ? 1 : month + 1, 1, 0, 0, 0)
        .toString();
  }

  final int terribleCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Terrible')
      .orderBy('dateCreated')
      .snapshots()
      .length;
  print("TC:$terribleCount");
  final int badCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Bad')
      .orderBy('dateCreated')
      .snapshots()
      .length;

  final int neutralCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Neutral')
      .orderBy('dateCreated')
      .snapshots()
      .length;
  final int goodCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Good')
      .orderBy('dateCreated')
      .snapshots()
      .length;
  final int wonderfulCount = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .where('mood', isEqualTo: 'Wonderful')
      .orderBy('dateCreated')
      .snapshots()
      .length;

  Map<String, double> moodCountMap = {
    "Terrible": terribleCount.toDouble(),
    "Bad": badCount.toDouble(),
    "Neutral": neutralCount.toDouble(),
    "Good": goodCount.toDouble(),
    "Wonderful": wonderfulCount.toDouble()
  };
  print(moodCountMap);
  return moodCountMap;
}

List<DateTime> getMonths() {
  List<DateTime> months = [];
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime(endDate.year - 24);
  for (int i = startDate.year; i < endDate.year; i++) {
    for (int j = 1; j <= 12; j++) {
      months.add(DateTime(i, j));
    }
  }
  for (int j = 1; j <= endDate.month; j++) {
    months.add(DateTime(endDate.year, j));
  }
  print(months[months.length - 1]);
  return months;
}

Stream<QuerySnapshot> getPhotosOfYear(DateTime date) {
  //After 31/12/(year-1)
  //Before 01/01/(year+1)
  int year = date.year;
  String email = AuthService.getUserEmail();

  String afterDate = DateTime(year - 1, 12, 31, 23, 23, 59).toString();
  String beforeDate = DateTime(year + 1, 1, 1, 0, 0, 0).toString();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  Stream<QuerySnapshot> query = userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .orderBy('dateCreated')
      .snapshots();
  return query;
}

Stream<QuerySnapshot> getPhotosOfMonth(DateTime date) {
  //After 31/12/(year-1)
  //Before 01/01/(year+1)
  int year = date.year;
  int month = date.month;

  String email = AuthService.getUserEmail();

  String afterDate = DateTime(month == 1 ? year - 1 : year,
          month == 1 ? 12 : month - 1, 31, 23, 23, 59)
      .toString();
  String beforeDate = DateTime(month == 12 ? year + 1 : year,
          month == 12 ? 1 : month + 1, 1, 0, 0, 0)
      .toString();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  Stream<QuerySnapshot> query = userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .orderBy('dateCreated')
      .snapshots();
  return query;
}

// Reference ref = FirebaseStorage.instance.ref().child(email);
// List<String> imageURLs = [];
// ref.listAll().then((result) async {
//   for (var i in result.items) {
//     String url = await i.getDownloadURL();
//     imageURLs.add(url);
//   }
//   print(imageURLs);
// });
// return imageURLs;
