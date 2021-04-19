import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/Stats/ShowMedia.dart';
import 'package:daybook/Services/statService.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsTab extends StatefulWidget {
  final String tab;
  StatsTab({this.tab});

  @override
  _StatsTabState createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>
    with AutomaticKeepAliveClientMixin {
  Stream<QuerySnapshot> query;
  DateTime yearDate = DateTime.now();
  DateTime monthDate = DateTime.now();
  DateTime date;
  String tab;
  List<int> yearsToShow;
  List<DateTime> monthsToShow;
  int _yearIndex;
  int _monthIndex;
  int yearToAdd = DateTime.now().year - 24;
  Map<String, int> timelineCounts;
  Map<String, double> dataMap;

  List<Color> colorList = [
    Color(0xffa3a8b8),
    Color(0xffcbcbcb),
    Color(0xfffdefcc),
    Color(0xffffa194),
    Color(0xffadd2ff)
  ];

  @override
  void initState() {
    super.initState();
    tab = widget.tab;
    query =
        tab == "Year" ? getPhotosOfYear(yearDate) : getPhotosOfMonth(monthDate);
    monthsToShow = getMonths();
    yearsToShow =
        new List<int>.from(new List<int>.generate(25, (i) => i + yearToAdd));
    date = tab == 'Year' ? yearDate : monthDate;
    timelineCounts = getTimelineCounts(tab, date);
    dataMap = getMoodCount(tab, date);
    // if (dataMap == null) {
    //   print("dataMap is null");
    //   getMoodCount(tab, date).then((Map s) {
    //     print("datamap wala s");
    //     print(s);
    //     dataMap = s;
    //   });
    //   print(dataMap);
    // }
    // if (timelineCounts == null) {
    //   print("timelineCounts is null");
    //   getTimelineCounts(tab, date).then((Map s) {
    //     print("timelineCounts wala s");
    //     print(s);
    //     timelineCounts = s;
    //   });
    //   print(timelineCounts);
    // }

    // dataMap = await getMoodCount(tab, date);
    _yearIndex = yearsToShow.length - 1;
    _monthIndex = monthsToShow.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      tab == 'Year' ? showYearpicker() : showMonthpicker(),
      SizedBox(height: 30),
      showphotosCard(query),
      SizedBox(
        height: 20,
      ),
      showTimelineCard(),
      SizedBox(height: 20),
      // FutureBuilder(
      //     future: getMoodCount(tab, date),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         if (snapshot.data.length == 0) {
      //           return Text("No data !");
      //         }
      //         return
      PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.5,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "Moods",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      )
      //     ;
      //   }
      //   return CircularProgressIndicator();
      // }),
    ]);
  }

  Text getTextWid(String txt) {
    return Text(
      txt,
      style: TextStyle(
        fontFamily: 'Segoe-UI',
        fontSize: 18.5,
        color: (tab == txt) ? Colors.black : Colors.grey,
        fontWeight: FontWeight.bold,
        decorationColor: Colors.blue,
        decorationThickness: 3,
        letterSpacing: 2.0,
      ),
    );
  }

  showYearpicker() {
    return Container(
        height: 50,
        child: new Swiper(
          itemCount: yearsToShow.length,
          // loop: false,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: Text(yearDate.year.toString()));
          },
          index: yearsToShow.indexOf(yearDate.year),
          control: new SwiperControl(),
          onIndexChanged: (index) {
            // Map<String, int> temp = await getTimelineCounts(tab, date);
            setState(() {
              _yearIndex = index;
              yearDate = DateTime(yearsToShow[_yearIndex]);
              // timelineCounts = temp;
            });
          },
        ));
  }

  showMonthpicker() {
    return Container(
        height: 50,
        child: new Swiper(
          itemCount: monthsToShow.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: Text(DateFormat.yMMM().format(monthDate)));
          },
          index:
              monthsToShow.indexOf(DateTime(monthDate.year, monthDate.month)),
          control: new SwiperControl(),
          onIndexChanged: (index) {
            // Map<String, int> temp = await getTimelineCounts(tab, date);
            setState(() {
              _monthIndex = index;
              monthDate = monthsToShow[_monthIndex];
              // timelineCounts = temp;
            });
          },
        ));
  }

  Card showphotosCard(Stream<QuerySnapshot> query) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Container(
          child: Column(
            children: [
              Text('Photos'),
              tab == 'Year'
                  ? Text(yearDate.year.toString())
                  : Text(DateFormat.yMMM().format(monthDate)),
              GestureDetector(
                child: Text('Show All Images'),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ShowAllImages(
                        date: tab == 'Year' ? yearDate : monthDate,
                        query: query);
                  }));
                },
              )
            ],
          ),
          height: 100,
          width: MediaQuery.of(context).size.width - 8.0,
        ));
  }

  Card showTimelineCard() {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  print("hfuh");
                },
                child: Icon(Icons.add),
              ),
              Text('Timeline'),
              tab == 'Year'
                  ? Text(yearDate.year.toString())
                  : Text(DateFormat.yMMM().format(monthDate)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Entries'),
                Text(timelineCounts['entries'].toString())
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Journeys'),
                Text(timelineCounts['journeys'].toString())
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Habits'),
                Text(timelineCounts['habits'].toString())
              ]),
            ],
          ),
          height: 100,
          width: MediaQuery.of(context).size.width - 8.0,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
