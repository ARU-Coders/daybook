import 'package:daybook/Pages/Authentication/signup_details.dart';
import 'package:daybook/Provider/google_sign_in.dart';
import 'package:daybook/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:daybook/provider/email_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassText = true;
  
  bool isEmailLoading = false;
  bool isGoogleLoading = false;

  startEmailLoading() => setState(()=>isEmailLoading=true);
  stopEmailLoading() => setState(()=>isEmailLoading=false);  
  
  startGoogleLoading() => setState(()=>isGoogleLoading=true);
  stopGoogleLoading() => setState(()=>isGoogleLoading=false);
  
  void showSnackBar(String message, {int duration = 3}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> loginWithEmail(con, email, password) async{
    await 
    Provider.of<EmailSignInProvider>(con, listen: false)
    .login( 
      email: email, 
      password: password,
      errorCallback:(errorMessage){
        stopEmailLoading();
        print("Failure");
        print(errorMessage);

        showSnackBar(errorMessage);
      },
      successCallback:(){
        stopEmailLoading();
        print("Success");

        Navigator.popAndPushNamed(context, '/home');
      }
    );
  }

  Future<void> loginWithGoogle(con) async{
    await Provider.of<GoogleSignInProvider>(con, listen: false)
      .login( 
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

  void _togglePassText() =>
      setState(() => _obscurePassText = !_obscurePassText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
            child: Column(
              children: [
                Spacer(),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                              style: GoogleFonts.getFont(
                                "Lato",
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    )),
                SizedBox(
                  height: 60,
                ),
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
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                                color: Colors.blueGrey,
                                ),
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
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Password",
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
                                ),
                                onPressed: () {
                                  _togglePassText();
                                }),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty !';
                            }
                            else if(value.length<6){
                              return 'Password must contain atleast 6 characters!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                isEmailLoading
                ?
                Container(padding: EdgeInsets.symmetric(vertical:10),child: CircularProgressIndicator())
                :
                buildLoginWithEmailButton(context),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Text(" OR "),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 25),
                isGoogleLoading
                ?
                Container(padding: EdgeInsets.symmetric(vertical:10),child: CircularProgressIndicator())
                :
                buildLoginWithGoogleButton(context),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyText1.color),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign up',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15,
                          fontFamily: "Times New Roman",
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupDetails()),
                          );
                        }
                      )
                    ]
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Builder buildLoginWithEmailButton(BuildContext context){
    return 
    Builder(
      builder: (BuildContext _) {
        return ChangeNotifierProvider<EmailSignInProvider>(
          create: (_) => EmailSignInProvider(),
          builder: (cntxt, _) {
            return Container(
              padding: EdgeInsets.all(4),
              child: RaisedButton(
                child: Text("Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xffd68598),
                  ),
                ),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                highlightElevation: 1.5,
                highlightColor: Color(0xDAFFD1DC),
                color: Color(0xffFFD1DC),
                textColor: Colors.black,
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    
                    FocusScope.of(context).unfocus();
                    startEmailLoading();

                    await loginWithEmail(cntxt, email, password);
                  }
                }
              ),
            );
          }
        );
      },
    );
  }

  Builder buildLoginWithGoogleButton(BuildContext context){
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
                  "Login with Google",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color(0xffd68598)),
                ),
                highlightElevation: 1.5,
                highlightColor: Color(0xDAFFD1DC),
                color: Color(0xffFFD1DC ),
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textColor: Colors.black,
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  size: 18,
                ),
                onPressed: () async{
                  FocusScope.of(context).unfocus();
                  startGoogleLoading();
                  await loginWithGoogle(cntxt);
                }
              ),
            );
          }
        );
      },
    );
  }
}
