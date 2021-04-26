import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowAllImages extends StatelessWidget {
  @required
  final Stream<QuerySnapshot> query;
  @required
  final DateTime date;
  ShowAllImages({this.query, this.date});

  bool checkIfSameDates(docs, index) {
    final currDate = DateTime.parse(docs[index]["dateCreated"].toString());
    final prevDate = DateTime.parse(docs[index - 1]["dateCreated"].toString());

    return currDate.year == prevDate.year &&
        currDate.month == prevDate.month &&
        currDate.day == prevDate.day;
  }

  List<String> imagesToshow = [];
  String dateToShow = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Photos'),
        ),
        body: SafeArea(
          child: Container(
            child: StreamBuilder(
                stream: query,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                            child:
                                Container(child: CircularProgressIndicator())));
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/No-Entry.png',
                            height: 250.0,
                          ),
                          Text(
                            "No images Added",
                            style: GoogleFonts.getFont(
                              'Lato',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      itemCount: snapshot.data.docs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.docs.length) {
                          return _imageGrid(context, imagesToshow, dateToShow);
                        }
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        bool flag = false;
                        List<String> imagesToPass = [];
                        String dateToPass = '';
                        if (index == 0) {
                          imagesToshow =
                              imagesToshow + List<String>.from(ds['images']);
                          dateToShow = DateFormat.yMMMMd()
                              .format(DateTime.parse(ds['dateCreated']));
                        } else {
                          if (checkIfSameDates(snapshot.data.docs, index)) {
                            imagesToshow =
                                imagesToshow + List<String>.from(ds['images']);
                          } else {
                            flag = true;
                            imagesToPass = imagesToshow;
                            dateToPass = dateToShow;
                            imagesToshow = List<String>.from(ds['images']);
                            dateToShow = DateFormat.yMMMMd()
                                .format(DateTime.parse(ds['dateCreated']));
                          }
                        }
                        return imagesToPass.length > 0
                            ? _imageGrid(context, imagesToPass, dateToPass)
                            : SizedBox();
                      });
                }),
          ),
        ));
  }
}

Widget _imageGrid(BuildContext context, List<String> imageURLs, String date) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 2,
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(
              date,
              style: GoogleFonts.getFont('Oxygen',
                  fontSize: 15, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 2,
          )),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Container(
          child: Wrap(
        spacing: 6.0,
        runSpacing: 7.0,
        alignment: WrapAlignment.start,
        children: List.generate(imageURLs.length, (index) {
          return
              // Column(
              // children: [
              GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return EnlargedImage(imageURLs[index], true);
              }));
            },
            child: Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                // borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: imageURLs[index],
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
          // ,            // ],
          // );
        }),
      )),
    ],
  );
}
