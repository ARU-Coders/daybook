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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Photos'),
          leading: Text(date.year.toString()),
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
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return ds['images'].length > 0
                            ? Column(
                                children: [
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ds['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(DateFormat.yMMMMd().format(
                                          DateTime.parse(ds['dateCreated'])))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  imageGrid(ds['images'])
                                ],
                              )
                            : SizedBox();
                      });
                }),
          ),
        ));
  }
}

Widget imageGrid(imageURLs) {
  return Container(
    height: 150,
    child: GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1, crossAxisCount: 1, crossAxisSpacing: 5),
      scrollDirection: Axis.horizontal,
      itemCount: imageURLs.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return EnlargedImage(imageURLs[index], true);
                }));
              },
              child: Container(
                height: 130,
                width: 130,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: imageURLs[index],
                    // height: 160,
                    // width: 250,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
