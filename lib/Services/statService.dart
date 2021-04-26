import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Query timelineQueryGenerator(
    String collection, String beforeDate, String afterDate) {
  DocumentReference userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.getUserEmail());
  return userDoc
      .collection(collection)
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate);
}

Future<Map<String, int>> getTimelineCounts(String tab, DateTime date) async {
  String beforeDate, afterDate;
  int year = date.year;
  int month = date.month;

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

  final entryQuery = timelineQueryGenerator('entries', beforeDate, afterDate);
  QuerySnapshot entries = await entryQuery.get();
  int entryCount = entries.docs.length;

  final journeyQuery =
      timelineQueryGenerator('journeys', beforeDate, afterDate);
  QuerySnapshot journeys = await journeyQuery.get();
  int journeyCount = journeys.docs.length;

  final habitQuery = timelineQueryGenerator('habits', beforeDate, afterDate);
  QuerySnapshot habits = await habitQuery.get();
  int habitCount = habits.docs.length;

  Map<String, int> timelineMap = {
    'entries': entryCount,
    'journeys': journeyCount,
    'habits': habitCount
  };

  print(timelineMap);

  return timelineMap;
}

Future<Map<String, double>> getMoodCount(String tab, DateTime date) async {
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

  Map<String, double> moodCountMap = {
    "Terrible": 0,
    "Bad": 0,
    "Neutral": 0,
    "Good": 0,
    "Wonderful": 0
  };

  QuerySnapshot querySnapshot = await userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .get();

  Map<String, dynamic> queryDocumentSnapshotData;

  await querySnapshot.docs.forEach((element) {
    queryDocumentSnapshotData = element.data();
    print(element.data.toString());
    print(queryDocumentSnapshotData['mood'].toString());
    moodCountMap[queryDocumentSnapshotData['mood'].toString()] += 1;
    print("Count++ ");
    print(queryDocumentSnapshotData['mood'].toString());
  });

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
      .orderBy('dateCreated', descending: true)
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
      .orderBy('dateCreated', descending: true)
      .snapshots();
  return query;
}
