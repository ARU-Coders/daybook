import 'package:flutter/material.dart';
import 'package:daybook/Widgets/google_signup_button_widget.dart';
import 'signup_details.dart';
// import 'package:daybook/provider/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'Services/authentication.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign Up",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupDetails()),
                );
              },
              color: Colors.orange[300],
              child: Text('Register with email'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Row(children: <Widget>[
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
            ),
            SizedBox(height: 15),
            GoogleSignupButtonWidget(),
          ],
        ),
      ),
    );
  }
}
