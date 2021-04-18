// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daybook/Pages/EnlargedImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/Stats/ShowMedia.dart';
import 'package:daybook/Services/statService.dart';
// import 'package:daybook/Services/statService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  int _yearIndex = 24;
  int _monthIndex = 299;
  DateTime date = DateTime.now();
  int yearToAdd = DateTime.now().year - 24;
  String _activetab = 'Year';
  List<int> yearsToShow;
  List<DateTime> monthsToShow;
  TabController _tabController;
  List<Widget> statsTabs = [];

  TextEditingController yearController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    yearController = new TextEditingController(text: 'Not Set');
    yearsToShow =
        new List<int>.from(new List<int>.generate(25, (i) => i + yearToAdd));
    monthsToShow = getMonths();
  }

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

  Widget getTextWid(String txt) {
    return Text(
      txt,
      style: TextStyle(
        fontFamily: 'Segoe-UI',
        fontSize: 18.5,
        color: (_activetab == txt) ? Colors.black : Colors.grey,
        fontWeight: FontWeight.bold,
        decorationColor: Colors.blue,
        decorationThickness: 3,
        letterSpacing: 2.0,
      ),
    );
  }

  showYearStats() {
    Stream<QuerySnapshot> query = getPhotosOfYear(date);
    return Column(children: [
      showYearpicker(),
      SizedBox(height: 30),
      showphotosCard(query)
    ]);
  }

  showMonthStats() {
    Stream<QuerySnapshot> query = getPhotosOfMonth(date);
    return Column(children: [
      showMonthpicker(),
      SizedBox(height: 30),
      showphotosCard(query)
    ]);
  }

  showYearpicker() {
    return Container(
        height: 50,
        child: new Swiper(
          itemCount: yearsToShow.length,
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: Text(date.year.toString()));
          },
          index: _yearIndex,
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
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: Text(DateFormat.yMMM().format(date)));
          },
          index: _monthIndex,
          control: new SwiperControl(),
          onIndexChanged: (index) {
            setState(() {
              _monthIndex = index;
              date = monthsToShow[_monthIndex];
            });
          },
        ));
  }

  showphotosCard(Stream<QuerySnapshot> query) {
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
              _activetab == 'Year'
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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 38.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              tabs: [
                Tab(
                  text: 'Year',
                ),
                Tab(
                  text: 'Month',
                ),
              ],
              controller: _tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.symmetric(horizontal: 25.0),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelColor: Theme.of(context).iconTheme.color,
              labelColor: Colors.white,
              labelStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (newContext) {
              statsTabs = [showYearStats(), showMonthStats()];
              return TabBarView(
                children: statsTabs,
                controller: _tabController,
              );
            }),
          ),
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
          )
        ],
      ),
    ));
  }
}
