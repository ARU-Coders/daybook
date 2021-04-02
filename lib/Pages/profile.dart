import 'package:cached_network_image/cached_network_image.dart';
import 'package:daybook/Services/db_services.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {}
              if (snapshot.hasData) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: snapshot.data['photo'],
                  ),
                );
              }
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }),
      ),
    );
  }
}
