import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_service.dart';
import 'dart:io';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

// Future<String> uploadImage(Reference ref, File _image) async {
//   String url;
//   UploadTask uploadTask = ref.putFile(_image);
//   uploadTask.whenComplete(() async {
//     url = await ref.getDownloadURL();
//     print("Function wala url :" + url.toString());
//     return url;
//   });
//   return '';
// }

Future<List<String>> uploadFiles(List<String> _images) async {

  List<File> _imageFiles = _images.map((path) => File(path)).toList();
  List<String> imagesUrls = [];
  String url;
  // print("Starting the upload...\n");
  // print("imagefiles" + _imageFiles.toString());

  String id = email;
  _imageFiles.forEach((_image) async {
    String imageRef = id + '/' + _image.path.split('/').last;
    // print(imageRef);
    Reference ref = FirebaseStorage.instance.ref(imageRef);
    // print("reference" + ref.toString());

    // url = await uploadImage(ref, _image);
    // print("Returned url : " + url.toString());
    // imagesUrls.add(url);

      UploadTask uploadTask = ref.putFile(_image);
      // uploadTask.whenComplete(() async{
      uploadTask.then((res) async{
        // String url = await ref.getDownloadURL();
        String url = await res.ref.getDownloadURL();
    //     print(url);
        imagesUrls.add(url);
    }).catchError((onError) {
    print(onError);
    });
  });
  return imagesUrls;
}

Future<DocumentReference> createEntry(
    String title, String content, String mood, List<String> images) async {
    var randomDoc = await userDoc.collection('entries').doc();
    String docId  = randomDoc.id;

  print("Ye rahe $images");
  List<String> imagesURLs = [];
  
  if(images.length > 0){
    String id = email;

    await Future.wait(images.map((String _image) async {
      String imageRef = id + '/' + _image.split('/').last;
      Reference ref = FirebaseStorage.instance.ref(imageRef);
      UploadTask uploadTask = ref.putFile(File(_image));


      TaskSnapshot snapshot = await uploadTask.whenComplete(() async{
        String downloadUrl = await ref.getDownloadURL();
        imagesURLs.add(downloadUrl);
      });

    }), eagerError: true, cleanUp: (_) {
      print('eager cleaned up');
    });
  }

  else{
    imagesURLs = [];
  }

  DateTime now = new DateTime.now();
  final task = await userDoc.collection('entries').doc(docId).set({
    'title': title,
    'content': content,
    'dateCreated': DateTime(now.year, now.month, now.day).toString(),
    'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
    'mood': mood,
    'images': imagesURLs,
    'docId': docId
  });
  DocumentReference query =  userDoc.collection('entries').doc(docId);
  return query;
}

Stream<QuerySnapshot> getEntries() {
  Stream<QuerySnapshot> query = userDoc.collection('entries').snapshots();
  return query;
}

Future<DocumentSnapshot> getEntry(String entryId) async {
  DocumentSnapshot doc = await userDoc.collection('entries').doc(entryId).get();
  return doc;
}

Future<void> editEntry(String entryId, String title,
    String content, String mood, List<String> images) async {
  List<String> imagesURLs;
  imagesURLs = images.length > 0 ? await uploadFiles(images) : [];
  DateTime now = new DateTime.now();
  Future<void> _ = userDoc.collection('entries').doc(entryId).update({
    'title': title,
    'content': content,
    'dateLastModified': DateTime(now.year, now.month, now.day).toString(),
    'mood': mood,
    'images': imagesURLs,
  });
}

void deleteEntry(DocumentSnapshot documentSnapshot) async {
  await FirebaseFirestore.instance
      .runTransaction((Transaction myTransaction) async {
    myTransaction.delete(documentSnapshot.reference);
  });
}
