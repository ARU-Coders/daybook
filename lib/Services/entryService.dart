import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_service.dart';
import 'dart:io';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

Future<String> uploadImage(Reference ref, File _image) async {
  String url;
  UploadTask uploadTask = ref.putFile(_image);
  uploadTask.whenComplete(() async {
    url = await ref.getDownloadURL();
    print("Function wala url :" + url.toString());
    return url;
  });
  return '';
}

Future<List<String>> uploadFiles(List<String> _images) async {
  // if()
  print("upload files wala" + _images.toString());
  List<File> _imageFiles = _images.map((path) => File(path)).toList();
  List<String> imagesUrls = [];
  String url;
  print("Starting the upload...\n");
  print("imagefiles" + _imageFiles.toString());

  String id = email;
  _imageFiles.forEach((_image) async {
    String imageRef = id + '/' + _image.path.split('/').last;
    print(imageRef);
    Reference ref = FirebaseStorage.instance.ref(imageRef);
    print("reference" + ref.toString());
    url = await uploadImage(ref, _image);
    print("Returned url : " + url.toString());
    imagesUrls.add(url);

    //   UploadTask uploadTask = ref.putFile(_image);
    //   uploadTask.whenComplete(() async{
    //     String url = await ref.getDownloadURL();
    //     print(url);
    //     imagesUrls.add(url);
    // }).catchError((onError) {
    // print(onError);
    // });
  });

  print("Upload finished ");
  print(imagesUrls);
  return imagesUrls;
}

void createEntry(
    String title, String content, String mood, List<String> images) async {
  print(images);
  List<String> imagesURLs;
  imagesURLs = images.length > 0 ? await uploadFiles(images) : [];
  print("uploadFiles() returned this  :");
  print(imagesURLs);

  DateTime now = new DateTime.now();
  Future<DocumentReference> query = userDoc.collection('entries').add({
    'title': title,
    'content': content,
    'dateCreated': DateTime(now.year, now.month, now.day).toString(),
    'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
    'mood': mood,
    'images': imagesURLs,
  });
  print(query);
}

Stream<QuerySnapshot> getEntries() {
  Stream<QuerySnapshot> query = userDoc.collection('entries').snapshots();
  return query;
}

Future<DocumentSnapshot> getEntry(String entryId) async {
  DocumentSnapshot doc = await userDoc.collection('entries').doc(entryId).get();
  return doc;
}

void editEntry(String entryId, String title, String content, String mood,
    List<String> images) async {
  List<String> imagesURLs;
  imagesURLs = images.length > 0 ? await uploadFiles(images) : [];
  // print("title :" + title);
  // print("content :" + content);
  // print("mood :" + mood);
  // print("entryId :" + entryId);
  DocumentReference entryDoc =
      FirebaseFirestore.instance.collection('entries').doc(entryId);
  print("entryDoc : " + entryDoc.toString());
  DateTime now = new DateTime.now();
  Future<void> query = userDoc.collection('entries').doc(entryId).update({
    'title': title,
    'content': content,
    'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
    'mood': mood,
    'images': imagesURLs,
  });
  print(query);
}

void deleteEntry(DocumentSnapshot documentSnapshot) async {
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}

// void editEntry(String entryId, String title, String content, String mood,
//     List<String> images) async {
//   List<String> imagesURLs;
//   imagesURLs = images.length > 0 ? await uploadFiles(images) : [];

//   DocumentReference documentReference =
//       userDoc.collection('entries').doc(entryId);
//   FirebaseFirestore.instance.runTransaction((transaction) async {
//     DocumentSnapshot snapshot = await transaction.get(documentReference);
//     print("ye wala"+ snapshot.toString());
//     print("ye wala"+ documentReference.toString());
//     if (!snapshot.exists) {
//       print("hello");
//       throw Exception("Entry does not exist! samja na");
//     }

//     DateTime now = new DateTime.now();
//     transaction.update(documentReference, {
//       'title': title,
//       'content': content,
//       'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
//       'mood': mood,
//       'images': imagesURLs,
//     });
//   });
// }
