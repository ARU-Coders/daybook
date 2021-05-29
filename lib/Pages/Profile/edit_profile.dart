import 'package:daybook/Services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:daybook/Services/entryService.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  bool isChanged = false;
  final _formKey = GlobalKey<FormState>();
  String dropdownValue;
  String birthdate = "Not Set";

  Function callback;

  InputDecoration textFormFieldDecoration(String lbl, IconData icon) {
    return InputDecoration(
        labelText: lbl,
        suffixIcon: icon!= null ? Icon(icon) : null,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.blueGrey)));
  }

    _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        birthdate = date.toString();
        birthdayController.text = DateFormat.yMMMMd().format(date);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(!isChanged)
    {
      final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    nameController.text = arguments[0]['name'];
    emailController.text = arguments[0]['email'];
    dropdownValue = arguments[0]['gender'];
    birthdayController.text = arguments[0]['birthdate'];

    callback = arguments[1];
    isChanged = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset:false,
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
              width: width,
              decoration: new BoxDecoration(
                color: Color(0xfffdefcc),
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(width, 40.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.black87,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Edit Profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Merriweather',
                            color: Colors.grey[900],
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
              ),
          
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: textFormFieldDecoration("Name", Icons.person_outline),
                  autofocus: false,
                  // style: new TextStyle(color: Colors.blueGrey),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Name cannot be empty !';
                    }
                    return null;
                  },
                ),
              ), // name
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  onTap: _pickDate,
                  readOnly: true,
                  controller: (birthdayController),
                  decoration: textFormFieldDecoration(
                      "BirthDate", Icons.calendar_today_outlined),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date of Birth cannot be empty !';
                    }
                    if(value == "Not Set"){
                      return "Please select birthdate";
                    }
                    if (DateTime.parse(birthdayController.text)
                        .isAfter(DateTime.now())) {
                      return 'Birthdate cannot be a future date !';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 25.0,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButtonFormField(
                  decoration: textFormFieldDecoration("Gender",null),
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  // style: TextStyle(color: Colors.deepPurple),
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xffd68598)),
                    ),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    textColor: Colors.black,
                    highlightElevation: 1.5,
                    highlightColor: Color(0xDAFFD1DC),
                    color: Color(0xffFFD1DC),
                    onPressed: () async{
                      if (_formKey.currentState.validate()){
                        //If form is valid
                        //pop
                        //Else
                        //display snackar
                        FocusScope.of(context).unfocus();
                        await editProfile(nameController.text.trim(), birthdayController.text ,dropdownValue);
                        callback("Profile Updated!");
                        Navigator.pop(context);
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
