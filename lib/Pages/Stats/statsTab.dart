import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/Stats/ShowMedia.dart';
import 'package:daybook/Services/statService.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsTab extends StatefulWidget {
  String tab;
  StatsTab({this.tab});

  @override
  _StatsTabState createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  Stream<QuerySnapshot> query;
  DateTime date;
  String tab;
  List<int> yearsToShow;
  List<DateTime> monthsToShow;
  int _yearIndex = 24;
  int _monthIndex = 299;
  int yearToAdd = DateTime.now().year - 24;
  Map<String, double> dataMap = {
    "Terrible": 5,
    "Bad": 3,
    "Neutral": 2,
    "Good": 2,
    "Wonderful": 4
  };

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
    date = DateTime.now();
    tab = widget.tab;
    query = tab == "Year" ? getPhotosOfYear(date) : getPhotosOfMonth(date);
    monthsToShow = getMonths();
    yearsToShow =
        new List<int>.from(new List<int>.generate(25, (i) => i + yearToAdd));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      tab == 'Year' ? showYearpicker() : showMonthpicker(),
      SizedBox(height: 30),
      showphotosCard(date.year.toString(), query),
      SizedBox(
        height: 20,
      ),
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
      ),
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
            return Center(child: Text(date.year.toString()));
          },
          index: yearsToShow.indexOf(date.year),
          control: new SwiperControl(),
          onIndexChanged: (index) {
            setState(() {
              _yearIndex = index;
              date = DateTime(yearsToShow[_yearIndex]);
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
            return Center(child: Text(DateFormat.yMMM().format(date)));
          },
          index: monthsToShow.indexOf(DateTime(date.year, date.month)),
          control: new SwiperControl(),
          onIndexChanged: (index) {
            setState(() {
              _monthIndex = index;
              date = monthsToShow[_monthIndex];
            });
          },
        ));
  }

  Card showphotosCard(String year, Stream<QuerySnapshot> query) {
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
                  ? Text(date.year.toString())
                  : Text(DateFormat.yMMM().format(date)),
              GestureDetector(
                child: Text('Show All Images'),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ShowAllImages(date: date, query: query);
                  }));
                },
              )
            ],
          ),
          height: 100,
          width: MediaQuery.of(context).size.width - 8.0,
        ));
  }
}
