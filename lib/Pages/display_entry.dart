import 'package:flutter/material.dart';
import 'package:daybook/Services/entryService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:cached_network_image/cached_network_image.dart';

// class DisplayEntryScreen extends StatefulWidget {
//   @override
//   _DisplayEntryScreenState createState() => _DisplayEntryScreenState();
// }

// class _DisplayEntryScreenState extends State<DisplayEntryScreen> {
//   // Future<void> handleEdit() async {}

//   // Future<void> handleDelete() async {
//   //   deleteEntry(documentSnapshot);}

//   @override
//   Widget build(BuildContext context) {
//     final arguments =
//         ModalRoute.of(context).settings.arguments as List<dynamic>;
//     DocumentSnapshot documentSnapshot = arguments[0];
//     List<dynamic> imageUrls = documentSnapshot["images"];
//     print("checking :" + documentSnapshot['title']);
//     print("checking :" + documentSnapshot.toString());
//     Widget _imagesGrid() {
//       return Container(
//         height: 140,
//         child: GridView.count(
//           scrollDirection: Axis.horizontal,
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 4,
//           crossAxisCount: 1,
//           children: List.generate(imageUrls.length, (index) {
//             return Column(
//               children: <Widget>[
//                 GestureDetector(
//                   onLongPress: () {
//                     print("Long Press Registered !!!");
//                     setState(() {
//                       imageUrls.removeAt(index);
//                     });
//                   },
//                   onTap: () {
//                     print("Tap registered !!");
//                     Navigator.push(context, MaterialPageRoute(builder: (_) {
//                       return EnlargedImage(imageUrls[index], true);
//                     }));
//                   },
//                   child: Container(
//                       height: 130,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ClipRRect(
//                         child: CachedNetworkImage(
//                           imageUrl: imageUrls[index] == ""
//                               ? 'https://picsum.photos/250?image=9'
//                               : imageUrls[index],
//                           progressIndicatorBuilder:
//                               (context, url, downloadProgress) => Container(
//                             width: 5,
//                             height: 5,
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 value: downloadProgress.progress,
//                                 strokeWidth: 2.0,
//                               ),
//                             ),
//                           ),
//                           errorWidget: (context, url, error) =>
//                               Icon(Icons.error),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       )),
//                 ),
//               ],
//             );
//           }),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Entry",
//         ),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) => AlertDialog(
//                   title: Text("Detele Entry ?"),
//                   content: Text("This will delete the Entry permanently."),
//                   actions: <Widget>[
//                     Row(
//                       children: [
//                         FlatButton(
//                           onPressed: () {
//                             deleteEntry(documentSnapshot);
//                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
//                             // Navigator.popAndPushNamed(context, '/home',
//                             //     arguments: [2]);
//                             Navigator.pop(context);
//                             Navigator.pop(context);
//                           },
//                           child: Text("Delete"),
//                         ),
//                         FlatButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text("Cancel"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//             child: Icon(
//               Icons.delete,
//               size: 20,
//             ),
//           ),
//           SizedBox(
//             width: 30,
//           ),
//           GestureDetector(
//             child: Icon(
//               Icons.edit,
//               size: 20,
//             ),
//             onTap: () {
//               Navigator.popAndPushNamed(context, '/createEntry', arguments: [
//                 // documentSnapshot["title"],
//                 // documentSnapshot["content"],
//                 // documentSnapshot["images"],
//                 // documentSnapshot.id,
//                 // documentSnapshot["mood"],
//                 documentSnapshot
//               ]);
//             },
//           ),
//           SizedBox(
//             width: 25,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
//                     child: Column(children: [
//                       SizedBox(
//                         height: 25.0,
//                       ),
//                       Text(
//                         "Mood for the day : " + documentSnapshot['mood'],
//                         style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: "Times New Roman"),
//                       ),
//                       SizedBox(height: 20),
//                       Container(child: Row(children: [])),
//                       Text(
//                         documentSnapshot['title'],
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "Times New Roman"),
//                       ),
//                       Text(
//                         documentSnapshot['content'],
//                         style: TextStyle(
//                             color: Colors.black87,
//                             fontSize: 18,
//                             fontFamily: "Times New Roman"),
//                       ),
//                       SizedBox(
//                         height: 25.0,
//                       ),
//                       imageUrls.length != 0
//                           ? _imagesGrid()
//                           : SizedBox(
//                               height: 1,
//                             ),
//                     ]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class DisplayEntryScreen extends StatefulWidget {
  @override
  _DisplayEntryScreenState createState() => _DisplayEntryScreenState();
}

class _DisplayEntryScreenState extends State<DisplayEntryScreen> {
  final Map<String, Color> colorMoodMap = {
    "Terrible": Color(0xffffa194), //red
    "Bad": Color(0xffa3a8b8), //grey
    "Neutral": Color(0xdaffffff), //white
    "Good": Color(0xfffdefcc), //yellow
    "Wonderful": Color(0xffadd2ff) //blue
  };
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    var appbarHeight = AppBar().preferredSize.height;
    double newheight = height - padding.top - padding.bottom - appbarHeight;

    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    DocumentSnapshot documentSnapshot = arguments[0];
    List<dynamic> imageUrls = documentSnapshot["images"];
    print("checking :" + documentSnapshot['title']);
    print("checking :" + documentSnapshot.toString());

    Widget _imagesGrid() {
      return Container(
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisSpacing: 2,
            mainAxisSpacing: 4,
            crossAxisCount: 1,
            children: List.generate(imageUrls.length, (index) {
              return Column(
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      print("Long Press Registered !!!");
                      setState(() {
                        imageUrls.removeAt(index);
                      });
                    },
                    onTap: () {
                      print("Tap registered !!");
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return EnlargedImage(imageUrls[index], true);
                      }));
                    },
                    child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index] == ""
                                ? 'https://picsum.photos/250?image=9'
                                : imageUrls[index],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              width: 5,
                              height: 5,
                              child: Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ],
              );
            }),
          ),
        ),
      );
    }

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SingleChildScrollView(
                child: Stack(children: [
              Column(children: [
                Container(
                    height: 200,
                    width: width,
                    decoration: new BoxDecoration(
                      color: colorMoodMap[documentSnapshot['mood']],
                      // boxShadow: [new BoxShadow(blurRadius: 10.0)],
                      borderRadius: new BorderRadius.vertical(
                          bottom: new Radius.elliptical(width, 40.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            Container(
                              height: appbarHeight,
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        title: Text("Detele Entry ?"),
                                        content: Text(
                                            "This will delete the Entry permanently."),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              FlatButton(
                                                onPressed: () {
                                                  deleteEntry(documentSnapshot);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Delete"),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    Navigator.popAndPushNamed(
                                        context, '/createEntry',
                                        arguments: [documentSnapshot]);
                                  },
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          children: [
                            Text(
                              documentSnapshot['title'],
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Times New Roman"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Mood for the day : " + documentSnapshot['mood'],
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Times New Roman"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Text(
                    documentSnapshot['content'],
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        letterSpacing: 0.2,
                        fontFamily: "Times New Roman"),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                imageUrls.length != 0
                    ? _imagesGrid()
                    : SizedBox(
                        height: 1,
                      ),
              ])
            ]))));
  }
}
