import 'package:daybook/Services/habitService.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Models/habitSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HabitChart extends StatefulWidget {
  final List<dynamic> daysCompleted;

  HabitChart({@required this.daysCompleted});

  @override
  _HabitChartState createState() => _HabitChartState();
}

class _HabitChartState extends State<HabitChart> {
  List<HabitSeries> data = [];
  @override
  void initState() {
    print("Init, Is It ??");
    super.initState();

    data = getHabitMonthlyCount(widget.daysCompleted);
  }

  @override
  Widget build(BuildContext context) {
    data = getHabitMonthlyCount(widget.daysCompleted);
    List<charts.Series<HabitSeries, String>> series = [
      charts.Series(
          id: "Habit Chart",
          data: data,
          domainFn: (HabitSeries series, _) => series.xval,
          measureFn: (HabitSeries series, _) => series.habitCount,
          colorFn: (HabitSeries series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue))
    ];
    // setState(() {
    // });
    return Container(
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              // Text(
              //   "Habit Chart",
              // ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
