import 'package:cached_network_image/cached_network_image.dart';
// import 'package:daybook/Services/db_services.dart';
import 'package:daybook/Services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  void showSnackBar(String message, {int duration = 3}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      key: _scaffoldKey,
      body: SafeArea(
        child: FutureBuilder(
            future: getUserProfileStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Aw Snap ! There's some error."),
                );
              }

              if (snapshot.hasData) {
                return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, newSnapshot) {
                      // if (snapshot.data.docs.length == 0) {
                      //  return Container();
                      //  }

                      if (newSnapshot.hasData) {
                        final data = newSnapshot.data;
                        String name = data['name'].toString();
                        String email = data['email'].toString();
                        String gender = data['gender'].toString();
                        String dateJoined = DateFormat.yMMMMd()
                            .format(DateTime.parse(data['dateJoined']));
                        String birthdate = DateFormat.yMMMMd()
                            .format(DateTime.parse(data['birthdate']));
                        String userType = data['type'];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Color(0xffd68598),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 20, 0),
                                    child: Row(
                                      children: [ 
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "My Profile",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  child: CachedNetworkImage(
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.cover,
                                                    imageUrl: data['photo'],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // AnimatedTextKit(
                                                      //   animatedTexts: [
                                                      //     TypewriterAnimatedText(
                                                      //       name
                                                      //           .split(" ")
                                                      //           .map((str) =>
                                                      //               str[0]
                                                      //                   .toUpperCase() +
                                                      //               str.substring(
                                                      //                   1))
                                                      //           .join(" "),
                                                      //       textStyle:
                                                      //           const TextStyle(
                                                      //         fontSize: 20.0,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .bold,
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      //   totalRepeatCount: 1,
                                                      //   pause: const Duration(
                                                      //       milliseconds: 1000),
                                                      //   displayFullTextOnTap:
                                                      //       true,
                                                      //   stopPauseOnTap: true,
                                                      // ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        child: Text(
                                                          name
                                                              .split(" ")
                                                              .map((str) =>
                                                                  str[0]
                                                                      .toUpperCase() +
                                                                  str.substring(
                                                                      1))
                                                              .join(" "),
                                                          style: GoogleFonts.getFont(
                                                            "Oxygen",
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600),
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(
                                                        "User since $dateJoined",
                                                        style: GoogleFonts.getFont(
                                                          "Lato",
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400),
                                                      ),
                                                    ]),
                                              ]),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0) 
                                                ),
                                              ),
                                              child: FloatingActionButton(
                                                backgroundColor:
                                                    Color(0xffd68598),
                                                child: Icon(
                                                  Icons.edit_outlined,
                                                  size: 15,
                                                ),
                                                onPressed: () => {
                                                  Navigator.pushNamed(
                                                      context, '/editProfile',
                                                      arguments: [data, showSnackBar])
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          name
                                              .split(" ")
                                              .map((str) =>
                                                  str[0].toUpperCase() +
                                                  str.substring(1))
                                              .join(" "),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "E-mail",
                                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          email,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Gender",
                                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          gender,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Birthdate",
                                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          birthdate,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500],
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                    SizedBox(height: 20),
                                    userType == "email"
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: RaisedButton(
                                              child: Text("Change password",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Color(0xff5685bf),
                                                  )),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 10),
                                              shape: StadiumBorder(),
                                              color: Color(0xff8ebbf2),
                                              onPressed: () => {
                                                print(
                                                    "Navigate to change password screen...")
                                                // Navigator.popAndPushNamed(context, '/selectEntries',
                                                //     arguments: [documentSnapshot])
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    });
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

BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.grey.shade200,
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        offset: Offset(10, 10),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-10, -10),
        blurRadius: 10,
      ),
    ]);

class AvatarImage extends StatelessWidget {
  String url;
  AvatarImage(String url) {
    this.url = url;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: avatarDecoration,
      child: Container(
        decoration: avatarDecoration,
        padding: EdgeInsets.all(3),
        child: Container(
          // child: CachedNetworkImage(
          //                   fit: BoxFit.cover,
          //                   imageUrl: url,
          //                 ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/All-Done.png'),
            ),
          ),
        ),
      ),
    );
  }
}
