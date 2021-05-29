import 'package:daybook/Pages/home.dart';
import 'package:daybook/Provider/google_sign_in.dart';
import 'package:daybook/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SignupDetails extends StatefulWidget {
  @override
  _SignupDetailsState createState() => _SignupDetailsState();
}

class _SignupDetailsState extends State<SignupDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthdayController;
  
  bool _obscurePassText = true;
  bool _obscureCnfPassText = true;
  bool isEmailLoading = false;
  bool isGoogleLoading = false;

  String dropdownValue = 'Male';
  String birthdate = "Not Set";

  startEmailLoading() => setState(()=>isEmailLoading=true);
  stopEmailLoading() => setState(()=>isEmailLoading=false);  
  
  startGoogleLoading() => setState(()=>isGoogleLoading=true);
  stopGoogleLoading() => setState(()=>isGoogleLoading=false);

  @override
  void initState() {
    super.initState();
    birthdayController = new TextEditingController(text: 'Not Set');
  }

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);
  void _toggleCnfPassText() =>
      setState(() => _obscureCnfPassText = !_obscureCnfPassText);

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

  void showSnackBar(String message, {int duration = 3}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> registerWithEmail(con) async{
    await 
    Provider.of<EmailSignInProvider>(con, listen: false)
    .register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      gender: dropdownValue,
      dob: birthdate,
      errorCallback:(errorMessage){
        stopEmailLoading();
        print("Failure");
        print(errorMessage);

        showSnackBar(errorMessage);
      },
      successCallback:(){
        stopEmailLoading();
        print("Success");

        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('/login'),);
      }
    );
  }

  Future<void> registerWithGoogle(con) async{
    await Provider.of<GoogleSignInProvider>(con, listen: false)
      .registerWithGoogle( 
        errorCallback:(errorMessage){
          stopGoogleLoading();
          print("Failure");
          print(errorMessage);

          showSnackBar(errorMessage);
          },
        successCallback:(){
          stopGoogleLoading();
          print("Success");

          Navigator.popAndPushNamed(context, '/home');
          },
        dismissCallback:(){
          stopGoogleLoading();
          print("Dismiss");
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        body: ChangeNotifierProvider(
      create: (context) => EmailSignInProvider(),
      child: Builder(builder: (context) {
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
                        ],
                      ),
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
                            if (DateTime.parse(birthdate)
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
                        padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.arrow_downward),
                          decoration: textFormFieldDecoration(
                              "Gender", null),
                          value: dropdownValue,
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
                            } else if(value.length<6){
                              return 'Password must contain atleast 6 characters!';
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
                            }else if(value.length<6){
                              return 'Password must contain atleast 6 characters!';
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
                      isEmailLoading
                      ?
                      Container(padding: EdgeInsets.symmetric(vertical:10),child: CircularProgressIndicator())
                      :
                      buildRegisterWithEmailButton(context),

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
                      isGoogleLoading
                      ?
                      Container(padding: EdgeInsets.symmetric(vertical:10),child: CircularProgressIndicator())
                      :
                      buildRegisterWithGoogleButton(context),
                      // GoogleSignupButtonWidget(),
                      SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
    return InputDecoration(
        labelText: lbl,
        suffixIcon: icon!= null ? Icon(icon) : null,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.blueGrey)));
  }

  Builder buildRegisterWithEmailButton(BuildContext context){
    return 
    Builder(
      builder: (BuildContext _) {
        return ChangeNotifierProvider<EmailSignInProvider>(
          create: (_) => EmailSignInProvider(),
          builder: (cntxt, _) {
            return Container(
              padding: EdgeInsets.all(4),
              child: RaisedButton(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xffd68598),
                  ),
                ),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                textColor: Colors.black,
                highlightElevation: 1.5,
                highlightColor: Color(0xDAFFD1DC),
                color: Color(0xffFFD1DC),
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    if (passwordController.text == confirmPasswordController.text) {
                    FocusScope.of(context).unfocus();
                    startEmailLoading();

                    await registerWithEmail(cntxt);
                    }else{
                      showSnackBar("Passwords don\'t match!");
                    }
                  }
                }
              ),
            );
          }
        );
      },
    );
  }

  Builder buildRegisterWithGoogleButton(BuildContext context){
    return 
    Builder(
      builder: (BuildContext _) {
        return ChangeNotifierProvider<GoogleSignInProvider>(
          create: (_) => GoogleSignInProvider(),
          builder: (cntxt, _) {
            return 
            Container(
              padding: EdgeInsets.all(4),
              child: RaisedButton.icon(
                label: Text(
                  "Register with Google",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color(0xffd68598)),
                ),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                highlightElevation: 1.5,
                highlightColor: Color(0xDAFFD1DC),
                color: Color(0xffFFD1DC ),
                // textColor: Colors.black,
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.black87,size: 18,),
                onPressed: () async{
                  FocusScope.of(context).unfocus();
                  startGoogleLoading();
                  await registerWithGoogle(cntxt);
                }
              ),
            );
          }
        );
      },
    );
  }
}
