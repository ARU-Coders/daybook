import 'package:daybook/Widgets/google_signup_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Pages/start.dart';
import 'package:intl/intl.dart';

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
  TextEditingController birthdayController;
  String dropdownValue = 'Male';
  String birthdate = "Not Set";
  void initState() {
    super.initState();
    birthdayController = new TextEditingController(text: 'Not Set');
  }

  final _formKey = GlobalKey<FormState>();
  bool isValidEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
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
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(25.0),
                          //   child: Image.asset(
                          //     "assets/images/noImage.jpg",
                          //     fit: BoxFit.cover,
                          //     height: 150.0,
                          //     width: 150.0,
                          //   ),
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ]),

                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: nameController,
                              decoration: textFormFieldDecoration(
                                  "Name", Icons.person_outline),
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
                              decoration: textFormFieldDecoration(
                                  "Email", Icons.email_outlined),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email ID cannot be empty !';
                                }
                                if (!isValidEmail(value)) {
                                  return 'Invalid email !';
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
                            // child: GestureDetector(
                            //   onTap: _pickDate,
                            child: TextFormField(
                              onTap: _pickDate,
                              readOnly: true,
                              // controller: birthdateController:,
                              controller: (birthdayController),
                              decoration: textFormFieldDecoration(
                                  "BirthDate", Icons.calendar_today_outlined),
                              validator: (value) {
                                if (DateTime.parse(birthdate)
                                    .isAfter(DateTime.now())) {
                                  return 'Birthdate cannot be a future date !';
                                }
                                if (value.isEmpty) {
                                  return 'Date of Birth cannot be empty !';
                                }
                                return null;
                              },
                            ),
                          ),
                          // ),
                          SizedBox(
                            height: 25.0,
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: DropdownButtonFormField(
                              decoration: textFormFieldDecoration(
                                  "Gender", Icons.arrow_downward),
                              value: dropdownValue,
                              // icon: Icon(Icons.arrow_downward),
                              // iconSize: 24,
                              // elevation: 16,
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
                            child: RaisedButton(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xffd68598)),
                                ),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                textColor: Colors.black,
                                highlightElevation: 1.5,
                                highlightColor: Color(0xDAFFD1DC),
                                color: Color(0xffFFD1DC),
                                // icon: FaIcon(
                                //   FontAwesomeIcons.signInAlt,
                                //   color: Colors.red
                                // ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (passwordController.text ==
                                        confirmPasswordController.text) {
                                      String result = await provider.register(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          dropdownValue,
                                          birthdate);
                                      if (result == "Success") {
                                        // print(birthdayController.text);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StartPage()),
                                        );
                                      } else {
                                        print(result);
                                      }
                                    }
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(children: <Widget>[
                            Expanded(
                                child: Divider(
                              thickness: 2,
                            )),
                            Text(" OR "),
                            Expanded(
                                child: Divider(
                              thickness: 2,
                            )),
                          ]),
                          SizedBox(height: 15),
                          GoogleSignupButtonWidget(),
                          SizedBox(
                            height: 25,
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

  InputDecoration textFormFieldDecoration(String lbl, IconData icon) {
    return new InputDecoration(
        labelText: lbl,
        suffixIcon: Icon(icon),
        fillColor: Colors.white,
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(color: Colors.blueGrey)));
  }
}
