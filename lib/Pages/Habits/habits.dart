import 'package:daybook/Utils/constants.dart';
import 'package:daybook/Widgets/no_data_found_widget.dart';
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
                    return noDataFound(
                      screen: Screens.HABITS,
                    );
                  }
                  return new ListView.builder(
                      padding: EdgeInsets.fromLTRB(17, 10, 17, 25),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        Color color = habitsStringToColorMap[ds['color']];
                        String timeString = formatTime(
                            ds['reminder'].toString(),
                            ds['frequency'].toString(),
                            context,
                            ds['frequency'].toString() == "Weekly"
                                ? ds['day'].toString()
                                : null);
                        return GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical:8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: color,
                              ),
                              child: CheckboxListTile(
                                activeColor: Colors.black45,
                                // checkColor: Colors.black87,
                                  title: Text(
                                    ds['title'],
                                    style: GoogleFonts.getFont(
                                      'Merriweather',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text("$timeString",
                                    style: TextStyle(color: Colors.black45),),
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
                                    icon: Icon(Icons.arrow_forward,color: Colors.black87),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                            HabitStatisticsPage(
                                              ds: ds,
                                            ),
                                          ),
                                      );
                                    },
                                  ),
                                ),
                            ),
                          ),
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
