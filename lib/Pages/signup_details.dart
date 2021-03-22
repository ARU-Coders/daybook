import 'package:flutter/material.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Pages/start.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupDetails extends StatefulWidget {
  @override
  _SignupDetailsState createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  bool _obscurePassText = true;
  bool _obscureCnfPassText = true;

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);
  void _toggleCnfPassText() =>
      setState(() => _obscureCnfPassText = !_obscureCnfPassText);

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
        body: ChangeNotifierProvider(
      create: (context) => EmailSignInProvider(),
      child: Builder(builder: (context) {
        final provider = Provider.of<EmailSignInProvider>(context);
        return SafeArea(
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
                            height: 15,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.asset(
                              "assets/images/noImage.jpg",
                              fit: BoxFit.cover,
                              height: 150.0,
                              width: 150.0,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: emailController,
                              decoration: textFormFieldDecoration("Email"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email ID cannot be empty !';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: DropdownButtonFormField(
                              decoration: textFormFieldDecoration("Gender"),
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
                              items: <String>[
                                'Male',
                                'Female',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassText,
                              decoration: passwordFormFieldDecoration(
                                  context, "Password", 0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password cannot be empty !';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              // keyboardType: TextInputType.number,
                              obscureText: _obscureCnfPassText,
                              decoration: passwordFormFieldDecoration(
                                  context, "Confirm Password", 1),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password cannot be empty !';
                                }
                                if (value != passwordController.text) {
                                  return 'Passwords do not match !';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: OutlineButton.icon(
                                label: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                highlightedBorderColor: Colors.black,
                                borderSide: BorderSide(color: Colors.black),
                                textColor: Colors.black,
                                icon: FaIcon(FontAwesomeIcons.signInAlt,
                                    color: Colors.red),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    if (passwordController.text ==
                                        confirmPasswordController.text) {
                                      provider.register(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          dropdownValue,
                                          birthdayController.text);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StartPage()),
                                      );
                                    }
                                  }
                                }),
                          ),
                        ],
                      ))),
            ),
          ),
        );
      }),
    ));
  }

  InputDecoration passwordFormFieldDecoration(
      BuildContext context, String lbl, int flag) {
    return InputDecoration(
      labelText: lbl,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(15.0),
          borderSide: new BorderSide(color: Colors.blueGrey)),
      suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _obscurePassText ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            if (flag == 0) {
              _togglePassText();
            } else {
              _toggleCnfPassText();
            }
          }),
    );
  }

  InputDecoration textFormFieldDecoration(lbl) {
    return new InputDecoration(
        labelText: lbl,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(color: Colors.blueGrey)));
  }
}
