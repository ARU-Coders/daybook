import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'package:intl/intl.dart';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

void createJourney(String title, String description, DateTime startDate,
    DateTime endDate) async {
  DateTime now = new DateTime.now();
  bool isActive = false;
  if (endDate.isAfter(now)) {
    isActive = true;
  }
  userDoc.collection('journeys').add({
    'title': title,
    'description': description,
    'dateCreated': DateTime(now.year, now.month, now.day).toString(),
    'startDate': startDate,
    'endDate': endDate,
    'isActive': isActive,
    'isFavourite': false,
    'entries': []
  });
}

void onCheckFavourite(String journeyId, bool checkedValue) {
  userDoc.collection('journeys').doc(journeyId).update({
    'isFavourite': checkedValue,
  });
}

Stream<QuerySnapshot> getJourneys() {
  Stream<QuerySnapshot> query = userDoc.collection('journeys').snapshots();
  return query;
}

Future<DocumentSnapshot> getJourney(String journeyId) async {
  DocumentSnapshot doc =
      await userDoc.collection('journeys').doc(journeyId).get();
  return doc;
}

void editJourney(
    String journeyId,
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    bool isActive,
    bool isFavourite) async {
  DateTime now = new DateTime.now();
  bool isActive = false;
  if (endDate.isAfter(now)) {
    isActive = true;
  }
  Future<DocumentReference> query =
      userDoc.collection('journeys').doc(journeyId).update({
    'title': title,
    'description': description,
    'dateCreated': DateTime(now.year, now.month, now.day).toString(),
    'startDate': startDate,
    'endDate': endDate,
    'isActive': isActive,
    'isFavourite': isFavourite,
  });
  print(query);
}

void deleteJourney(DocumentSnapshot documentSnapshot) async {
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}
