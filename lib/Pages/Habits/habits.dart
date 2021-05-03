import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Services/habitService.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'habit_stats.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  // DateTime now = DateTime.now();
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final Map<String, Color> colorCodes = {
    "Terrible": Color(0xffa3a8b8), //darkgrey
    "Bad": Color(0xffcbcbcb), //grey
    "Neutral": Color(0xfffdefcc), //yellow
    "Good": Color(0xffffa194), //red
    "Wonderful": Color(0xffadd2ff) //blue
  };

  String formatTime(time, frequency, context, [day]) {
    int h = int.parse(time.split(":")[0]);
    int m = int.parse(time.split(":")[1]);
    String formattedTime = TimeOfDay(hour: h, minute: m).format(context);
    String timeString = frequency == "Daily"
        ? "Everyday at $formattedTime"
        : "Every $day at $formattedTime";
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            StreamBuilder(
                stream: getHabits(),
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
                            'assets/images/No-Habits.png',
                            height: 250.0,
                            // width: 200.0,
                          ),
                          Text(
                            "No habits created !! \n Click on + to get started",
                            style: GoogleFonts.getFont(
                              'Lato',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              // color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return new ListView.builder(
                      padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];

                        String timeString = formatTime(
                            ds['reminder'].toString(),
                            ds['frequency'].toString(),
                            context,
                            ds['frequency'].toString() == "Weekly"
                                ? ds['day'].toString()
                                : null);
                        return GestureDetector(
                          child: CheckboxListTile(
                              title: Text(
                                ds['title'],
                                style: GoogleFonts.getFont(
                                  'Merriweather',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text("$timeString"),
                              ),
                              value: List<String>.from(ds['daysCompleted'])
                                  .contains(today.toString()),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (newValue) async{
                                await HapticFeedback.vibrate();
                                print("Habit: $newValue");
                                markAsDone(
                                    ds['habitId'],
                                    List<String>.from(ds['daysCompleted']),
                                    DateTime.now());
                              },
                              secondary: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HabitStatisticsPage(
                                              ds: ds,
                                            )),
                                  );
                                },
                              )),
                        );
                      });
                }),
            Positioned(
              bottom: 15,
              right: 15,
              child: FloatingActionButton(
                backgroundColor: Color(0xffd68598),
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
                onPressed: () => {Navigator.pushNamed(context, '/createHabit')},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
