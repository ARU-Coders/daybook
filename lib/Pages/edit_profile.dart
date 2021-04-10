import 'package:daybook/Services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  bool isChanged = false;
  final _formKey = GlobalKey<FormState>();
  String dropdownValue;
  /// Returns`true` if the email is valid
  ///
  /// Else returns `false`
 

  InputDecoration textFormFieldDecoration(lbl) {
    return new InputDecoration(
        labelText: lbl,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(color: Colors.blueGrey)));
  }

  @override
  Widget build(BuildContext context) {
    if(!isChanged)
    {
      final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    nameController.text = arguments[0]['name'];
    emailController.text = arguments[0]['email'];
    dropdownValue = arguments[0]['gender'];
    birthdayController.text = arguments[0]['birthdate'];
    isChanged = true;
    }
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: textFormFieldDecoration("Name"),
                  autofocus: false,
                  style: new TextStyle(color: Colors.blueGrey),
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
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: birthdayController,
                  decoration: textFormFieldDecoration("BirthDate"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date of Birth cannot be empty !';
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
                  decoration: textFormFieldDecoration("Gender"),
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
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
                    // icon: FaIcon(
                    //   FontAwesomeIcons.signInAlt,
                    //   color: Colors.red
                    // ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //If form is valid
                        //pop
                        //Else
                        //display snackar
                        editProfile(nameController.text, birthdayController.text ,dropdownValue );
                        Navigator.pop(
                          context);
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
