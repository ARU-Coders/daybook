import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:group_button/group_button.dart';
import 'package:daybook/Pages/EnlargedImage.dart';

class CreateEntryScreen extends StatefulWidget {
  @override
  _CreateEntryScreenState createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  final Map<String, String> moodMap = {
    "😭": "Terrible",
    "😥": "Bad",
    "🙂": "Neutral",
    "😃": "Good",
    "😁": "Wonderful"
  };
  final List<String> moodList = ["😭", "😥", "🙂", "😃", "😁"];
  List<String> selectedMoods = ["🙂"];

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final List<String> menuItems = <String>[
    'Add Images',
    'Add to Journey',
    'Discard'
  ];
  List<String> selectedImages = [];

  Future<bool> _onWillPop() async {
    //Display the popup if user has entered any text or add images, when back button is pressed.
    //If user selects "yes", the entry will get discarded.

    return (titleController.text.length > 0 || contentController.text.length > 0 || selectedImages.length > 0) ? (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Hold up !'),
        content: new Text('Do you want to discard this entry ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes', style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    )) ?? false : true;
  }

  _selectImages() async {
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
  }

  void handleMenuClick(String value) async {
    switch (value) {
      case 'Add Images':
        {
          print("Selected : $value");
          _selectImages();

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
          
          if(discard){
            Navigator.pop(context);
          } 
          break;
        }
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Entry",
          ),
          leading: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              print("Created !");
              createEntry(titleController.text, contentController.text,
                  moodMap[selectedMoods[0]], selectedImages);
              Navigator.pop(context);
            },
          ),
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
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: Column(children: [
                              _moodBar(),
                              SizedBox(
                                height: 25.0,
                              ),
                              TextFormField(
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Times New Roman"),
                                controller: titleController,
                                decoration: InputDecoration(hintText: 'Title'),
                                autofocus: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Title cannot be empty !';
                                  }
                                  return null;
                                },
                              ), // name

                              SizedBox(
                                height: 35.0,
                              ),
                              TextFormField(
                                style: TextStyle(
                                    color: Colors.black87,
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
                              SizedBox(
                                height: 25.0,
                              ),
                              selectedImages.length != 0
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

  Widget _imagesGrid() {
    return Container(
      height: 140,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 2,
        mainAxisSpacing: 4,
        crossAxisCount: 1,
        children: List.generate(selectedImages.length, (index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onLongPress: () {
                  print("Long Press Registered !!!");
                  setState(() {
                    selectedImages.removeAt(index);
                  });
                },
                onTap: () {
                  print("Tap registered !!");
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return EnlargedImage(selectedImages[index]);
                  }));
                },
                child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      child: Image.file(File(selectedImages[index]),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ],
          );
        }),
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
