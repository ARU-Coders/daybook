import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daybook/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleLoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
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
            // color: Colors.red,
            size: 18,
          ),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
        ),
      );
}
