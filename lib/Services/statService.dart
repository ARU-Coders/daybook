import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

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
  String year = date.year.toString();
  String email = AuthService.getUserEmail();

  String afterDate =
      DateTime(int.parse(year) - 1, 12, 31, 23, 23, 59).toString();
  String beforeDate = DateTime(int.parse(year) + 1, 1, 1, 0, 0, 0).toString();

  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  Stream<QuerySnapshot> query = userDoc
      .collection('entries')
      .where('dateCreated', isGreaterThan: afterDate)
      .where('dateCreated', isLessThan: beforeDate)
      .orderBy('dateCreated')
      .snapshots();
  return query;

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
