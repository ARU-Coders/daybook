// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class FormPage extends StatefulWidget {
  // final String selectedDoc;
  // FormPage();

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  String dropdownValue = 'Male';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Builder(
            builder: (buildContext) => SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sign Up Form",
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        labelText: "Name",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Enter your name'),
                                    autofocus: false,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name cannot be empty !';
                                      }
                                      return null;
                                    },
                                  ), // name
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        labelText: "Email ID",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Enter your Email ID'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Email ID cannot be empty !';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: birthdayController,
                                    decoration: InputDecoration(
                                        labelText: "DOB",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Enter your Date of Birth'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Date of Birth cannot be empty !';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),

                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Gender",
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1)),
                                      hintText: 'Select your Gender',
                                    ),
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.deepPurple),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['Male', 'Female', 'Other']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    // dropdownColor: Colors.amber,
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    // keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Enter your Password'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Password cannot be empty !';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    // keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Confirm your Password'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Password cannot be empty !';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  RaisedButton(
                                      child: Text('Submit Form'),
                                      color: Colors.orange[300],
                                      onPressed: () {
                                        final snackBar = SnackBar(
                                            content: Text('Thanks !' +
                                                'Thanks !' +
                                                nameController.text));

                                        Scaffold.of(buildContext)
                                            .showSnackBar(snackBar);
                                      }) // dob
                                ],
                              ))),
                    ),
                  ),
                )));
  }
}
