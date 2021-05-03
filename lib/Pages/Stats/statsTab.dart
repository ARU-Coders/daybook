import 'package:cached_network_image/cached_network_image.dart';
import 'package:daybook/Pages/Stats/ShowFiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/Pages/Stats/ShowMedia.dart';
import 'package:daybook/Services/statService.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

import '../EnlargedImage.dart';

class StatsTab extends StatefulWidget {
  final String tab;
  StatsTab({this.tab});

  @override
  _StatsTabState createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab>
    with AutomaticKeepAliveClientMixin {
  var files;

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
    getFiles();
    super.initState();
    tab = widget.tab;
    query =
        tab == "Year" ? getPhotosOfYear(yearDate) : getPhotosOfMonth(monthDate);
    monthsToShow = getMonths();
    yearsToShow =
        new List<int>.from(new List<int>.generate(25, (i) => i + yearToAdd));
    date = tab == 'Year' ? yearDate : monthDate;

    _yearIndex = yearsToShow.length - 1;
    _monthIndex = monthsToShow.length - 1;
  }

  void getFiles() async {
    files = await FileManager.listFiles(
        "/storage/emulated/0/Android/data/com.mip.daybook/files",
        extensions: ["pdf"],
        sortedBy: FileManagerSorting.Date);
    setState(() {}); //update the UI
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            tab == 'Year' ? showYearpicker() : showMonthpicker(),
            SizedBox(height: 20),
            showphotosCard(query),
            SizedBox(height: 15),
            showPdfCard(),
            SizedBox(height: 15),
            showTimelineCard(),
            SizedBox(height: 15),
            showDonutChart(),
          ],
        ),
      ),
    );
  }

  Text getCardTitle(String txt  ) {
    return Text(
      txt,
      style: GoogleFonts.getFont(
        'Lato',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        // color: Colors.black54,
        decorationColor: Colors.blue,
        decorationThickness: 3,
        letterSpacing: 2.0,
      ),
    );
  }

  Text getCardValueText(String txt) {
    return Text(
      txt,
      style: GoogleFonts.getFont(
        'Nunito',
        fontSize: 18, 
        fontWeight: FontWeight.w600,
        decorationColor: Colors.blue,
        decorationThickness: 3,
        letterSpacing: 2.0,
      ),
    );
  }

  Card cardWrapper({Widget child}) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        // color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: child);
  }

  Container showYearpicker() {
    return Container(
      height: 50,
      child: new Swiper(
        itemCount: yearsToShow.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(child: getCardTitle(yearDate.year.toString()));
        },
        index: yearsToShow.indexOf(yearDate.year),
        control: new SwiperControl(),
        onIndexChanged: (index) {
          setState(() {
            _yearIndex = index;
            yearDate = DateTime(yearsToShow[_yearIndex]);
            query = tab == "Year"
                ? getPhotosOfYear(yearDate)
                : getPhotosOfMonth(monthDate);
          });
        },
      ),
    );
  }

  Container showMonthpicker() {
    return Container(
      height: 50,
      child: Swiper(
        itemCount: monthsToShow.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
              child: getCardTitle(DateFormat.yMMM().format(monthDate)));
        },
        index: monthsToShow.indexOf(DateTime(monthDate.year, monthDate.month)),
        control: new SwiperControl(),
        onIndexChanged: (index) {
          setState(() {
            _monthIndex = index;
            monthDate = monthsToShow[_monthIndex];
            query = tab == "Year"
                ? getPhotosOfYear(yearDate)
                : getPhotosOfMonth(monthDate);
          });
        },
      ),
    );
  }

  FutureBuilder showDonutChart() {
    return FutureBuilder(
        future: getMoodCount(tab, tab == "Year" ? yearDate : monthDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dataMap = snapshot.data;
            return cardWrapper(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  getCardTitle('Mood'),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
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
                      legendTextStyle: GoogleFonts.getFont(
                        'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.blue,
                        decorationThickness: 3,
                        letterSpacing: 2.0,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 0,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          }
          return showLoadingCard();
        });
  }

  Container imageGrid(imageURLs) {
    return Container(
      height: 80,
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
                  height: 70,
                  width: 70,
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

  Card showphotosCard(Stream<QuerySnapshot> query) {
    return cardWrapper(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            getCardTitle('Photos'),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            //display recent photos here !
            imageGrid([
              'https://picsum.photos/200',
              'https://picsum.photos/200/300',
              'https://picsum.photos/300/200'
            ]),
            SizedBox(
              height: 10,
            ),
            // tab == 'Year'
            //     ? getCardValueText(yearDate.year.toString())
            //     : getCardValueText(DateFormat.yMMM().format(monthDate)),
            GestureDetector(
              child: Text('Show All Images'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ShowAllImages(
                        date: tab == 'Year' ? yearDate : monthDate,
                        query: query);
                  }),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width - 8.0,
      ),
    );
  }

  Card showPdfCard() {
    return cardWrapper(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            getCardTitle('PDF Files'),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text('Show All Files'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ShowFiles(
                      files: files,
                    );
                  }),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width - 8.0,
      ),
    );
  }

  FutureBuilder showTimelineCard() {
    return FutureBuilder(
        future: getTimelineCounts(tab, tab == "Year" ? yearDate : monthDate),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            timelineCounts = snapshot.data;
            return cardWrapper(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      getCardTitle('Timeline'),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCardValueText('Entries'),
                            getCardValueText(
                                timelineCounts['entries'].toString())
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCardValueText('Journeys'),
                            getCardValueText(
                                timelineCounts['journeys'].toString())
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCardValueText('Habits'),
                            getCardValueText(
                                timelineCounts['habits'].toString())
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width - 8.0,
              ),
            );
          }
          return showLoadingCard();
        });
  }

  showLoadingCard() {
    return cardWrapper(
      child: Container(
        height: 170,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
