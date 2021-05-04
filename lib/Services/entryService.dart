import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_service.dart';
import 'db_services.dart';
import 'dart:io';

Future<void> deleteImages(List<String> deleteImages) async {
  //Delete every file in List from Firebase Storage
  deleteImages.forEach((url) async {
    //Get filename (with extension) from download url
    String fileName = url
        .replaceAll("/o/", "*")
        .replaceAll("?", "*")
        .split("*")[1]
        .split("%2F")[1];
    //Replace %20 with whitespace and %3A with :
    fileName = fileName.replaceAll("%20", " ").replaceAll("%3A", ":");
    
    Reference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(AuthService.getUserEmail())
        .child(fileName)
        .delete()
        .then((_) => print('Successfully deleted $fileName storage item'))
        .catchError((e) => print("Delete nai hua because: " + e.toString()));
  });
}

Future<DocumentReference> createEntry(
    {String title,
    String content,
    String mood,
    List<String> images,
    DateTime dateCreated,
    List<String> tags = const [],
    GeoPoint position,
    String address
    // String location,
    }) async {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc = await getUserDocRef();

  DocumentReference randomDoc = userDoc.collection('entries').doc();

  String docId = randomDoc.id;

  List<String> imagesURLs = [];

  if (images.length > 0) {
    String id = email;

    await Future.wait(
        images.map((String _image) async {
          String imageName = _image.split('/').last.split('.').first;
          String imageExtention = _image.split('/').last.split('.').last;
          
          //Store image with the name format = <filename>_<CurrentDateTime>.<extension>
          String imageRef =
              id + '/' + imageName + "_" + DateTime.now().toString() + "." + imageExtention;
          Reference ref = FirebaseStorage.instance.ref(imageRef);
          UploadTask uploadTask = ref.putFile(File(_image));

          TaskSnapshot _ = await uploadTask.whenComplete(() async {
            String downloadUrl = await ref.getDownloadURL();
            imagesURLs.add(downloadUrl);
          });
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
  } else {
    imagesURLs = [];
  }

  DateTime now = new DateTime.now();
  final _ = await userDoc.collection('entries').doc(docId).set({
    'title': title,
    'content': content,
    'dateCreated': dateCreated.toString(),
    'dateLastModified': now.toString(),
    'mood': mood,
    'images': imagesURLs,
    'docId': docId,
    'tags': tags,
    'address': address,
    'position': position
  });
  DocumentReference query = userDoc.collection('entries').doc(docId);
  return query;
}

Stream<QuerySnapshot> getEntries(
    {bool descending = true, String searchVal = ''}) {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(email);

  Stream<QuerySnapshot> query = userDoc
      .collection('entries')
      // .where('title', isGreaterThanOrEqualTo: searchVal)
      // .orderBy('title', descending: descending)
      .orderBy('dateCreated', descending: descending)
      .snapshots();
  return query;
}

Future<DocumentSnapshot> getEntry(String entryId) async {
  DocumentReference userDoc = await getUserDocRef();
  DocumentSnapshot doc = await userDoc.collection('entries').doc(entryId).get();
  return doc;
}

Future<void> editEntry(
    {String entryId,
    String title,
    String content,
    String mood,
    List<String> selectedImages,
    List<String> previousImagesURLs,
    List<String> deletedImages,
    DateTime dateCreated,
    List<String> tags,
    GeoPoint position,
    String address}) async {
  String email = AuthService.getUserEmail();
  DocumentReference userDoc = await getUserDocRef();
  List<String> selectedImagesURLs = [];
  if (selectedImages.length > 0) {
    String id = email;

    await Future.wait(
        selectedImages.map((String _image) async {
          String imageRef =
              id + '/' + _image.split('/').last + DateTime.now().toString();
          Reference ref = FirebaseStorage.instance.ref(imageRef);
          UploadTask uploadTask = ref.putFile(File(_image));

          TaskSnapshot _ = await uploadTask.whenComplete(() async {
            String downloadUrl = await ref.getDownloadURL();
            selectedImagesURLs.add(downloadUrl);
          });
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
  } else {
    selectedImagesURLs = [];
  }
  List<String> imagesURLs = selectedImagesURLs + previousImagesURLs;

  DateTime now = new DateTime.now();

  Future<void> _ = userDoc.collection('entries').doc(entryId).update({
    'title': title,
    'content': content,
    'dateCreated': dateCreated.toString(),
    'dateLastModified': now.toString(),
    'mood': mood,
    'images': imagesURLs,
    'tags': tags,
    'address': address,
    'position': position
  });
  // ignore: unnecessary_statements
  deletedImages.length > 0 ? deleteImages(deletedImages) : null;
}

void deleteEntry(DocumentSnapshot documentSnapshot) async {
  await deleteImages(List<String>.from(documentSnapshot['images']));

  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}
