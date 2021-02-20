import 'package:flutter/material.dart';
import 'package:daybook/Pages/start.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Page !"),
            SizedBox(height: 15),
            RaisedButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
