import 'package:flutter/material.dart';

class SignupDetails extends StatefulWidget {

  @override
  _SignupDetailsState createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  bool _obscurePassText = true;
  bool _obscureCnfPassText = true;

  void _togglePassText() => setState(() =>  _obscurePassText = !_obscurePassText);
  void _toggleCnfPassText() => setState(() =>  _obscureCnfPassText = !_obscureCnfPassText);

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
                                        icon: const Icon(Icons.account_circle),
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
                                        icon: const Icon(Icons.email),
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
                                      icon: const Icon(Icons.calendar_today),
                                      labelText: "Birthdate",
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
                                      icon: const Icon(Icons.supervisor_account),
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
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: _obscurePassText,
                                    
                                    // keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        
                                        icon: Icon(Icons.lock_outline),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Enter your Password',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _obscurePassText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                            ),
                                          onPressed: () {
                                            _togglePassText();}),
                                        
                                        ),

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
                                    obscureText: _obscureCnfPassText,
                                    decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                        icon: Icon(Icons.lock_rounded),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1)),
                                        hintText: 'Confirm your Password',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _obscureCnfPassText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                            ),
                                          onPressed: () {
                                            _toggleCnfPassText();}),),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Password cannot be empty !';
                                      }
                                      if(value != passwordController.text){
                                        return 'Passwords do not match !';
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
                                        // final snackBar = SnackBar(
                                        //     content: Text('Thanks !' +
                                        //         'Thanks !' +
                                        //         nameController.text));

                                        // Scaffold.of(buildContext)
                                        //     .showSnackBar(snackBar);
                                      }) // dob
                                ],
                              ))),
                    ),
                  ),
                )));
  }
}
