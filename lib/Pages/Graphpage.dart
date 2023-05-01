import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Components/Backbtnnavbar.dart';

class Graph_information extends StatefulWidget {
  const Graph_information({Key? key}) : super(key: key);

  @override
  State<Graph_information> createState() => _Graph_informationState();
}

final database = FirebaseDatabase.instance.ref("companys");

class _Graph_informationState extends State<Graph_information> {
// snapshot.child('name').value.toString()
  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData(DateTime.utc(2011), 35),
      SalesData(DateTime.utc(2012), 40),
      SalesData(DateTime.utc(2013), 75),
      SalesData(DateTime.utc(2014), 50),
      SalesData(DateTime.utc(2015), 10),
      SalesData(DateTime.utc(2016), 100),
      SalesData(DateTime.utc(2017), 10),
      SalesData(DateTime.utc(2018), 50),
      SalesData(DateTime.utc(2019), 30),
      SalesData(DateTime.utc(2020), 80),
      SalesData(DateTime.utc(2021), 90),
      SalesData(DateTime.utc(2022), 44),
    ];
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: screenwidth,
          height: screenheight,
          color: HexColor('#FFFFFF'),
          child: Column(children: [
            Back_btn_navbar(navname: "Graph"),
            const SizedBox(
              height: 20,
            ),
            Container(
                // color: Colors.amberAccent,
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<SalesData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ]))
          ])),
    ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
