import 'package:flutter/material.dart';
import 'package:daybook/Widgets/background_painter.dart';
import 'package:daybook/Widgets/google_signup_button_widget.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          buildSignUp(),
        ],
      );

  Widget buildSignUp() => Padding(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 5),
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: 175,
                child: Text(
                  'Welcome To Daybook',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacer(),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email ID",
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
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
              controller: passwordController,
              obscureText: true,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1)),
                  hintText: 'Enter your Password'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty !';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            RaisedButton(
                child: Text('Login'),
                color: Colors.orange[300],
                onPressed: () {}),
            SizedBox(height: 15),
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
            SizedBox(height: 10),
            Text(
              'Please Login to continue',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
          ],
        ),
      );
}
