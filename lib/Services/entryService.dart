import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_service.dart';
import 'db_services.dart';
import 'dart:io';

String email = getUserEmail();

DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(email);

Future<String> uploadImage(Reference ref, File _image) async {
  Future<String> url;
  UploadTask uploadTask = ref.putFile(_image);
      uploadTask.whenComplete((){
        url = ref.getDownloadURL();
        print("Function wala url : $url");

        return url;
    });
}

Future<List<String>> uploadFiles(List<String> _images) async {
    
    List<File> _imageFiles = _images.map((path) => File(path)).toList();
    List<String> imagesUrls = [];
    String url;
    print("Starting the upload...\n");

    String id = email;
    _imageFiles.forEach((_image) async {
      String imageRef = id + '/' + _image.path.split('/').last;
      print(imageRef);
      Reference ref = FirebaseStorage.instance.ref(imageRef);
      url = await uploadImage(ref, _image);
      print("Returned url : $url");
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
  List<String> imagesURLs ; 
  imagesURLs = images.length > 0 ? await uploadFiles(images) : [];

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
