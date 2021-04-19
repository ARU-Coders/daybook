import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

Map<String, int> getTimelineCounts(String tab, DateTime date) {
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
  print("Waiting for the end to come....");
  int entryCount = 0;

  userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .snapshots()
      .forEach((element) {
    entryCount++;
  });

  int journeyCount = 0;
  userDoc
      .collection('journeys')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .snapshots()
      .forEach((element) {
    journeyCount += 1;
  });

  int habitCount = 0;
  userDoc
      .collection('habits')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .snapshots()
      .forEach((element) {
    habitCount += 1;
  });

  Map<String, int> timelineMap = {
    'entries': entryCount,
    'journeys': journeyCount,
    'habits': habitCount
  };

  print(timelineMap);

  return timelineMap;
}

Map<String, double> getMoodCount(String tab, DateTime date) {
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

  Map<String, double> moodCountMap = {
    "Terrible": 0,
    "Bad": 0,
    "Neutral": 0,
    "Good": 0,
    "Wonderful": 0
  };

  userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .snapshots()
      .forEach((element) {
    print(element.docs.length.toString());
    moodCountMap[element.docs[0]['mood'].toString()] += 1;
    // habitCount += 1;
    print("Count++ ");
  });
  // print("TC:$terribleCount");
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
// urn imageURLs;
