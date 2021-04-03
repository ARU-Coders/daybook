import 'package:daybook/Pages/Authentication/signup_details.dart';
import 'package:daybook/Pages/start.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Widgets/google_login_button_widget.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassText = true;

  bool isValidEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
  }

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // CustomPaint(painter: BackgroundPainter()),
        // buildSignUp(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
          child: Column(
            children: [
              Spacer(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    // width: 175,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 90,
                            height: 90,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Welcome To \nDaybook',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  )),
              SizedBox(
                height: 60,
              ),
              // // Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(color: Colors.blueGrey),
                          ),
                        ),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(color: Colors.blueGrey),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obscurePassText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                _togglePassText();
                              }),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password cannot be empty !';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
                    child: Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xffd68598),
                        )),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    highlightElevation: 1.5,
                    highlightColor: Color(0xDAFFD1DC),
                    color: Color(0xffFFD1DC),
                    textColor: Colors.black,
                    // icon: FaIcon(
                    //   FontAwesomeIcons.signInAlt,
                    //   color: Colors.black87,
                    //   size: 18,
                    // ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final provider = Provider.of<EmailSignInProvider>(
                            context,
                            listen: false);
                        provider.login(
                            emailController.text, passwordController.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartPage()));
                      }
                    }),
                // ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    thickness: 2,
                  )),
                  Text(" OR "),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 25),
              GoogleLoginButtonWidget(),
              SizedBox(height: 20),
              // Text(
              //   'Don\'t have an account?',
              //   style: TextStyle(fontSize: 16),
              // ),
              RichText(
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign up',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontFamily: "Times New Roman"),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // navigate to desired screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupDetails()),
                              );
                            })
                    ]),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => Signup()),
              //     );
              //     // Navigator.pushNamed(context, '/signup');
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.all(10.0),
              //     child: Text("Register Now"),
              //   ),
              // ),
              Spacer(),
            ],
          ),
        )
      ],
    );
  }
}
