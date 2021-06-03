import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Provider/email_sign_in.dart';
import 'package:daybook/Services/user_services.dart';
import 'package:daybook/Utils/constantStrings.dart';
import 'package:daybook/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading=true;
  
  String noOfEntries = "";
  String noOfJourneys = "";
  String noOfTasks = "";
  String noOfHabits = "";
  
  @override
  void initState(){
    super.initState();
    getStats();
  }

  Future<void> showPasswordResetDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text("Change Password?"),
        content: Text("A password reset link will be sent to your email to change the password and you will be logged out.\n\nYou can sign in again with the new psasword."),
          actions: <Widget>[
            Row(
              children: [
                FlatButton(
                  onPressed: () async{
                    try{
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser.email);
                      Navigator.of(context).pop();
                      
                      //Signout
                      Provider.of<EmailSignInProvider>(context, listen: false)
                          .logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/splashScreen',
                        (Route<dynamic> route) => false
                      );
                    }catch(e){
                      Navigator.of(context).pop();
                      print("Error during password change request ${e.toString()}");
                      String errorMessage = DEFAULT_AUTH_ERROR;
                      
                      if(e is FirebaseAuthException){
                        print(e);
                        print(e.code);
                        errorMessage = passwordChangeExceptionMessageMap[e.code] == null ? DEFAULT_AUTH_ERROR : passwordChangeExceptionMessageMap[e.code];
                      }
                      
                      showSnackBar(errorMessage);
                    }
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  /// Get total number of entries, habits, tasks and journeys created by the user.
  /// Not optimized at all, reads the data four times from the Firestore
  Future<void> getStats() async{
    DocumentReference userDoc = await getUserDocRef();

    await userDoc.collection('entries').get().then((snap) => noOfEntries=snap.docs.length.toString());

    await userDoc.collection('journeys').get().then((snap) => noOfJourneys=snap.docs.length.toString());

    await userDoc.collection('tasks').get().then((snap) => noOfTasks=snap.docs.length.toString());

    await userDoc.collection('habits').get().then((snap) => noOfHabits=snap.docs.length.toString());
    
    print("noOfEntries: $noOfEntries\nnoOfJourneys: $noOfJourneys\nnoOfTasks: $noOfTasks\nnoOfHabits: $noOfHabits");
    setState(()=>isLoading=false);
  }

  void showSnackBar(String message, {int duration = 3}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

    Widget statCard(
    emoji,
    value,
    title) {
    return Card(
      elevation: 2,
      color: YELLOW,
      child: InkWell(
        splashColor: Colors.white30,
        onLongPress: () async {
          await HapticFeedback.mediumImpact();
        },
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 8),
            Text(
              emoji,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87
              ),
            ),
            SizedBox(height: 3),
            isLoading
            ?
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical:6),
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                )))
            :
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont("Lora",
                fontSize: 18, fontWeight: FontWeight.w600,
                color: Colors.black87
              ),
            ),
            Expanded(
              child: Container(
                child: Text(title,
                  style: GoogleFonts.getFont("Merriweather", 
                  fontSize: 12,
                  color: Colors.black87),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                ),
              ),
            ),
            SizedBox(height: 3),
          ],
        ),
      ),
    );
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

                        return SingleChildScrollView(
                          child: Column(
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
                                child: Column(
                                  children: [
                                    SizedBox(height:10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
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
                                                      child: Center(
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
                                                          onPressed: ()  async{
                                                            print("Navigate to change password screen...");
                                                            await showPasswordResetDialog();
                                                            print("Email sent!!");
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                                          child: GridView.count(
                                            primary: false,
                                            childAspectRatio: (7 / 8),
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 1, vertical: 15),
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            crossAxisCount: 4,
                                            children: <Widget>[
                                              statCard(
                                                '📒',
                                                noOfEntries,
                                                'Entries',
                                              ),
                                              statCard(
                                                '✈',
                                                noOfJourneys,
                                                'Journeys',
                                              ),
                                              statCard(
                                                '💯',
                                                noOfHabits,
                                                'Habits',
                                              ),
                                              statCard(
                                                '☑',
                                                noOfTasks,
                                                'Tasks',
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:10),
                                  ],
                                ),
                              )
                            ],
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
