import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    height: double.infinity,
    width: double.infinity,
    child: Center(
        child:
            Container(child: CircularProgressIndicator())));

  }
}