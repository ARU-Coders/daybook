import 'package:flutter/material.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Habits",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 15),
          RaisedButton(
            color: Color(0xfffdefcc),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              Navigator.popAndPushNamed(
                context,
                '/start',
              );
            },
            child: Text('Logout'),
          )
        ],
      )),
    );
  }
}
