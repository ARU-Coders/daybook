import 'package:cached_network_image/cached_network_image.dart';
// import 'package:daybook/Utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:group_button/group_button.dart';
import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class CreateEntryScreen extends StatefulWidget {
  @override
  _CreateEntryScreenState createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> selectedImages = [];

  List<String> deletedImages = [];
  List<String> previousImages = [];
  List<String> tags = [];
  List<String> previousTags = [];

  final Map<String, String> moodMap = {
    "😭": "Terrible",
    "😥": "Bad",
    "🙂": "Neutral",
    "😃": "Good",
    "😁": "Wonderful"
  };

  final List<String> moodList = ["😭", "😥", "🙂", "😃", "😁"];
  List<String> selectedMoods = ["🙂"];
  bool isEditing = false;
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String documentId;
  DocumentSnapshot previousSnapshot;
  DateTime dateCreated = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime.now());

  Position _currentPosition;
  String currentAddress = '';
  loc.Location location = loc.Location();
  GeoPoint position = GeoPoint(0, 0);

  final List<String> menuItems = <String>[
    'Add Images',
    'Add Location',
    'Add to Journey',
    'Discard'
  ];

void showSnackBar(BuildContext buildContext, String message, {int duration = 3}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: duration),
  );
  Scaffold.of(buildContext).showSnackBar(snackBar);
}

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
  }

  getCurrentLocation() async {
    print("Arre hello");
    bool isLocEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocEnabled) {
      bool pageOpened = await Geolocator.openLocationSettings();
      return;
    }
    print("isLocEnabled $isLocEnabled");
    try {
      Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        // forceAndroidLocationManager: true
      ).then((Position position) {
        print("Got the position....");
        print(position);
        setState(() {
          _currentPosition = position;
          getAddressFromLatLng();
        });
      });
    } catch (e) {
      print("ERROR : ");
      print(e);
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        print(currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onWillPop() async {
    //Display the popup if user has entered any text or add images, when back button is pressed.
    //If user selects "yes", the entry will get discarded.

    return (titleController.text.length > 0 ||
            contentController.text.length > 0 ||
            selectedImages.length > 0)
        ? (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Hold up !'),
                content: new Text(isEditing
                    ? 'Do you want to discard the changes in this entry ?'
                    : 'Do you want to discard this entry ?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(
                      'No',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            )) ??
            false
        : true;
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: dateCreated,
    );

    if (date != null) {
      TimeOfDay t = await showTimePicker(context: context, initialTime: time);

      if (t != null) {
        dateCreated = date;
        time = t;
        setState(() {
          dateCreated = date;
          time = t;
        });
      }
    }
  }

  Container tagBuilder() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: TextFieldTags(
        initialTags: isEditing ? previousTags : [],
        textFieldStyler: TextFieldStyler(
          hintText: 'Got tags?',
          isDense: false,
          textFieldBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
        tagsStyler: TagsStyler(
          tagTextStyle: TextStyle(fontWeight: FontWeight.normal),
          tagDecoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(0.0),
          ),
          tagCancelIcon:
              Icon(Icons.cancel, size: 18.0, color: Colors.blue[900]),
          tagPadding: const EdgeInsets.all(6.0),
          tagMargin: const EdgeInsets.symmetric(horizontal: 4.0),
        ),
        onTag: (tag) {
          tags.add(tag);
        },
        onDelete: (tag) {
          tags.remove(tag);
        },
      ),
    );
  }

  Future<List<String>> _selectImages() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      for (int i = 0; i < files.length; i++) {
        if ((selectedImages.length == 0) ||
            !selectedImages.contains(files[i].path)) {
          selectedImages.add(files[i].path);
        } else {
          print(files[i].path + " already selected !");
        }
      }
      setState(() {});
    } else {
      print("User canceled the picker.");
    }
    print("inside func" + selectedImages.toString());
    return selectedImages;
  }

  void handleMenuClick(String value) async {
    switch (value) {
      case 'Add Images':
        {
          selectedImages = await _selectImages();
          break;
        }
      case 'Add Location':
        {
          print("Selected : $value");
          LocationPermission permissionStatus =
              await Geolocator.checkPermission();
          print(permissionStatus.toString());
          if (permissionStatus == LocationPermission.whileInUse ||
              permissionStatus == LocationPermission.always) {
            // await _checkGps();
            await getCurrentLocation();
            print("Got the location");
            if (_currentPosition != null)
              print(
                  "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
          } else {
            bool isGranted = await Permission.location.request().isGranted;
            String message =
                isGranted ? "Permission Granted !" : "Permission denied !";
            Builder(builder: (BuildContext context) {
              showSnackBar(context, message);
            });
          }
          break;
        }
      case 'Add to Journey':
        {
          print("Selected : $value");
          break;
        }
      case 'Discard':
        {
          bool discard = await _onWillPop();
          if (discard) {
            Navigator.pop(context);
          }
          break;
        }
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    if (arguments.length != 0 && !isEditing) {
      tags = List<String>.from(arguments[0]['tags']);
      previousTags = List<String>.from(arguments[0]['tags']);
      titleController.text = arguments[0]['title'];
      contentController.text = arguments[0]['content'];
      documentId = arguments[0].id;
      isEditing = true;
      dateCreated = DateTime.parse(arguments[0]['dateCreated']);
      time = TimeOfDay.fromDateTime(dateCreated);
      previousSnapshot = arguments[0];
      previousImages = List<String>.from(arguments[0]['images']);
      int idx = 0;
      for (var value in moodMap.values) {
        if (value == arguments[0]['mood']) {
          selectedMoods[0] = moodList[idx];
        }
        idx = idx + 1;
      }
      _currentPosition = Position(
          latitude: arguments[0]['position'].latitude,
          longitude: arguments[0]['position'].longitude);
      currentAddress = arguments[0]['address'];
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            isEditing ? "Edit Entry" : "Create Entry",
            style: GoogleFonts.getFont('Lato'),
          ),
          leading: Builder(builder: (BuildContext context) {
            return isLoading
                ? Container(
                    height: 5,
                    width: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CircularProgressIndicator(),
                    ))
                : IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (arguments.length != 0) {
                          if (selectedImages.length + previousImages.length >
                              10) {
                            showSnackBar(
                                context, "You can't add more than 10 images !");
                            return;
                          }

                          DateTime dateAndTimeCreated = DateTime(
                              dateCreated.year,
                              dateCreated.month,
                              dateCreated.day,
                              time.hour,
                              time.minute);
                          setState(() {
                            isLoading = true;
                          });
                          if (_currentPosition != null) {
                            position = GeoPoint(_currentPosition.latitude,
                                _currentPosition.longitude);
                          }
                          print('Address' + currentAddress.toString());
                          await editEntry(
                              entryId: arguments[0].id,
                              title: titleController.text,
                              content: contentController.text,
                              mood: moodMap[selectedMoods[0]],
                              selectedImages: selectedImages,
                              previousImagesURLs: previousImages,
                              deletedImages: deletedImages,
                              dateCreated: dateAndTimeCreated,
                              tags: tags,
                              position: position,
                              address: currentAddress);
                          setState(() {
                            isLoading = false;
                          });
                          DocumentSnapshot updatedDocumentSnapshot =
                              await previousSnapshot.reference.get();
                          Navigator.popAndPushNamed(context, '/displayEntry',
                              arguments: [updatedDocumentSnapshot]);
                        } else {
                          if (selectedImages.length + previousImages.length >
                              10) {
                            showSnackBar(
                                context, "You can't add more than 10 images !");
                            return;
                          }

                          DateTime dateAndTimeCreated = DateTime(
                              dateCreated.year,
                              dateCreated.month,
                              dateCreated.day,
                              time.hour,
                              time.minute);
                          setState(() {
                            isLoading = true;
                          });
                          if (_currentPosition != null) {
                            position = GeoPoint(_currentPosition.latitude,
                                _currentPosition.longitude);
                          }
                          print('Address' + currentAddress.toString());
                          DocumentReference docRef = await createEntry(
                              title: titleController.text,
                              content: contentController.text,
                              mood: moodMap[selectedMoods[0]],
                              images: selectedImages,
                              dateCreated: dateAndTimeCreated,
                              tags: tags,
                              position: position,
                              address: currentAddress);
                          DocumentSnapshot documentSnapshot =
                              await docRef.get();
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.popAndPushNamed(context, '/displayEntry',
                              arguments: [documentSnapshot]);
                        }
                      }
                    },
                  );
          }),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleMenuClick,
              itemBuilder: (BuildContext context) {
                return menuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Column(children: [
                              _moodBar(),
                              // GestureDetector(
                              //   child: Text(currentAddress),
                              //   onLongPress: () {
                              //     setState(() {
                              //       currentAddress = '';
                              //       _currentPosition =
                              //           Position(latitude: 0, longitude: 0);
                              //       position = GeoPoint(0, 0);
                              //     });
                              //   },
                              // ),
                              currentAddress != ""
                                  ? Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              child: Chip(
                                                label: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 5),
                                                  child: Text(
                                                    currentAddress,
                                                    style: GoogleFonts.getFont(
                                                      'Oxygen',
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                avatar: Icon(
                                                    Icons.location_on_outlined),
                                                backgroundColor: Color(0xffffe9b3),
                                              ),
                                              onLongPress: () {
                                                setState(() {
                                                  currentAddress = '';
                                                  _currentPosition = Position(
                                                      latitude: 0, longitude: 0);
                                                  position = GeoPoint(0, 0);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  )
                                  : SizedBox(),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Chip(
                                      label: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          "${DateFormat.yMMMMd().format(dateCreated)}  ${time.format(context)}",
                                          style: GoogleFonts.getFont(
                                            'Oxygen',
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      avatar:
                                          Icon(Icons.calendar_today_outlined),
                                      backgroundColor: Color(0xffffe9b3),
                                    ),
                                    onTap: _pickDate,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 35.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      // color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Times New Roman"),
                                  controller: titleController,
                                  decoration:
                                      InputDecoration(hintText: 'Title'),
                                  autofocus: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Title cannot be empty !';
                                    }
                                    return null;
                                  },
                                ),
                              ), // name

                              SizedBox(
                                height: 35.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      // color: Colors.black87,
                                      fontSize: 18,
                                      fontFamily: "Times New Roman"),
                                  controller: contentController,
                                  minLines: 5,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintText: 'Write something here !'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Content cannot be empty !';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              tagBuilder(),
                              (selectedImages.length != 0 ||
                                      previousImages.length != 0)
                                  ? _imagesGrid()
                                  : SizedBox(
                                      height: 1,
                                    ),
                              SizedBox(
                                height: 25.0,
                              ),
                            ]),
                          ),
                        ],
                      ))),
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> getImageIndex(String url) {
    if (selectedImages.indexOf(url) != -1) {
      return [selectedImages.indexOf(url), false];
    }
    return [previousImages.indexOf(url), true];
  }

  Widget _imagesGrid() {
    List<String> allImages = previousImages + selectedImages;

    return Container(
      height: 140,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 2,
        mainAxisSpacing: 4,
        crossAxisCount: 1,
        children: List.generate(
          allImages.length,
          (index) {
            List<dynamic> lst = getImageIndex(allImages[index]);
            final idx = lst[0];
            final isFirebaseImage = lst[1];
            return Column(
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (isFirebaseImage) {
                        deletedImages.add(previousImages[idx]);
                        previousImages.removeAt(idx);
                      } else {
                        selectedImages.removeAt(idx);
                      }
                    });
                  },
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return EnlargedImage(allImages[index], isFirebaseImage);
                    }));
                  },
                  child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        child: isFirebaseImage
                            ? CachedNetworkImage(
                                imageUrl: allImages[index],
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Image.file(File(allImages[index]),
                                fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _moodBar() {
    return GroupButton(
      spacing: 3,
      isRadio: true,
      direction: Axis.horizontal,
      onSelected: (index, isSelected) => {selectedMoods[0] = moodList[index]},
      buttons: moodList,
      selectedButtons: selectedMoods,
      selectedTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.red,
      ),
      unselectedTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.grey[600],
      ),
      selectedColor: Colors.grey[300],
      unselectedColor: Colors.white,
      selectedBorderColor: Colors.red,
      unselectedBorderColor: Colors.grey[500],
      borderRadius: BorderRadius.circular(20.0),
      selectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
      unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
    );
  }
}
