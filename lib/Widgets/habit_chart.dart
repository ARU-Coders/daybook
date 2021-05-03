import 'package:daybook/Services/habitStatsService.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Models/habitSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HabitChart extends StatefulWidget {
  final List<dynamic> daysCompleted;
  final String value;

  HabitChart({@required this.daysCompleted, @required this.value});

  @override
  _HabitChartState createState() => _HabitChartState();
}

class _HabitChartState extends State<HabitChart> {
  List<dynamic> data = [];
  @override
  void initState() {
    super.initState();
    data = getHabitStats(widget.daysCompleted);
  }

  @override
  Widget build(BuildContext context) {
    data = getHabitStats(widget.daysCompleted);
    List<charts.Series<HabitYearSeries, String>> yearlySeries = [
      charts.Series(
          id: "Habit Chart",
          data: data[0],
          domainFn: (HabitYearSeries series, _) => series.year,
          measureFn: (HabitYearSeries series, _) => series.yearCount,
          colorFn: (HabitYearSeries series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue),
          labelAccessorFn: (HabitYearSeries series, _) =>
              "${series.yearCount.toString()}"),
    ];
    List<charts.Series<HabitMonthSeries, String>> monthlySeries = [
      charts.Series(
          id: "Habit Chart",
          data: data[1],
          domainFn: (HabitMonthSeries series, _) => series.month,
          measureFn: (HabitMonthSeries series, _) => series.monthCount,
          colorFn: (HabitMonthSeries series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue),
          labelAccessorFn: (HabitMonthSeries series, _) =>
              "${series.monthCount.toString()}"),
    ];
    double width = MediaQuery.of(context).size.width;
    double yearlyWidth = width * yearlySeries.length + (width * 0.05);
    yearlyWidth = yearlyWidth > width ? yearlyWidth : width;
    double monthlyWidth =
        5 * width * yearlySeries.length * monthlySeries.length;
    return Container(
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: widget.value == 'Year' ? yearlyWidth : monthlyWidth,
                  height: 284,
                  child: charts.BarChart(
                    widget.value == 'Year' ? yearlySeries : monthlySeries,
                    animate: true,
                    // defaultRenderer: charts.BarRendererConfig(
                    //   strokeWidthPx: 5.0,
                    //   fillPattern: charts.FillPatternType.solid,
                    //   maxBarWidthPx: 30,
                    // ),
                    barRendererDecorator: new charts.BarLabelDecorator<String>(
                        insideLabelStyleSpec: new charts.TextStyleSpec(
                          fontFamily: "Times New Roman",
                          fontSize: 10,
                          lineHeight: 5,
                          // color: Colors.black,
                        ),
                        labelPosition: charts.BarLabelPosition.outside),
                    domainAxis: new charts.OrdinalAxisSpec(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
