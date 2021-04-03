import 'package:daybook/Services/habitStatsService.dart';
import 'package:flutter/material.dart';
import 'package:daybook/Models/habitSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HabitChart extends StatefulWidget {
  final List<dynamic> daysCompleted;
  final String year;

  HabitChart({@required this.daysCompleted, @required this.year});

  @override
  _HabitChartState createState() => _HabitChartState();
}

class _HabitChartState extends State<HabitChart> {
  List<HabitSeries> data = [];
  @override
  void initState() {
    super.initState();

    data = getHabitMonthlyCount(widget.daysCompleted, widget.year);
  }

  @override
  Widget build(BuildContext context) {
    data = getHabitMonthlyCount(widget.daysCompleted, widget.year);
    List<charts.Series<HabitSeries, String>> series = [
      charts.Series(
          id: "Habit Chart",
          data: data,
          domainFn: (HabitSeries series, _) => series.xval,
          measureFn: (HabitSeries series, _) => series.habitCount,
          colorFn: (HabitSeries series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue),
              labelAccessorFn: (HabitSeries series, _) =>
              '${series.habitCount.toString()}'),
              
    ];

    return Container(
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(series, 
                animate: true, 
                barRendererDecorator: new charts.BarLabelDecorator<String>(insideLabelStyleSpec: new charts.TextStyleSpec(fontFamily:"Times New Roman", fontSize:10, lineHeight:5 ),labelPosition: charts.BarLabelPosition.outside),
                domainAxis: new charts.OrdinalAxisSpec(),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
