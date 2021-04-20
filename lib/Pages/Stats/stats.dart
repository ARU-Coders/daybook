import 'package:daybook/Pages/Stats/StatsTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> statsTabs = [];

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 38.0,
            margin: EdgeInsets.fromLTRB(0, 16.0, 0, 5),
            child: Center(
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
          ),
          Expanded(
            child: Builder(builder: (newContext) {
              statsTabs = [StatsTab(tab: "Year"), StatsTab(tab: "Month")];
              return TabBarView(
                children: statsTabs,
                controller: _tabController,
              );
            }),
          ),
        ],
      ),
    );
  }
}
