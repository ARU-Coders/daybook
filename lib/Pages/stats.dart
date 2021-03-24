import 'package:flutter/material.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:daybook/Pages/start.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Stats", style: TextStyle(fontSize: 25),),
          SizedBox(height: 15),
          RaisedButton(
            color:  Color(0xfffdefcc),
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
      )),
    );
  }
}
