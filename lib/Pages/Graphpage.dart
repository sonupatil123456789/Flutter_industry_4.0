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

class _Graph_informationState extends State<Graph_information> {
  final database = FirebaseDatabase.instance.ref("workerhealth");
// snapshot.child('name').value.toString()

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    final List<ChartData> chartData = [
      ChartData(1, 35),
      ChartData(2, 23),
      ChartData(3, 34),
      ChartData(4, 25),
      ChartData(5, 40),
      ChartData(6, 23),
      ChartData(7, 50),
    ];

    return SafeArea(
        child: Scaffold(
            body: Container(
                width: screenwidth,
                height: screenheight,
                color: HexColor('#EDF7FF'),
                child: Column(
                  children: [
                    const Back_btn_navbar(navname: "Graph info"),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FirebaseAnimatedList(
                          scrollDirection: Axis.vertical,
                          query: database,
                          defaultChild: Center(
                              child: CircularProgressIndicator(
                            color: HexColor("#6C63FF"),
                            strokeWidth: 6,
                          )),
                          itemBuilder: ((context, snapshot, animation, index) {
                            return Container(
                              width: screenwidth * 0.90,
                              height: screenwidth * 0.50,
                              child: SfCartesianChart(
                                  primaryXAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(width: 0),
                                    axisLine: AxisLine(width: 0),
                                  ),
                                  primaryYAxis: NumericAxis(
                                      majorGridLines: MajorGridLines(width: 0),
                                      axisLine: AxisLine(width: 0)),
                                  enableSideBySideSeriesPlacement: true,
                                  enableAxisAnimation: false,
                                  isTransposed: false,
                                  series: <ChartSeries<ChartData, int>>[
                                    ColumnSeries<ChartData, int>(
                                        animationDelay: 3.0,
                                        isVisibleInLegend: false,
                                        enableTooltip: true,
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y)
                                  ]),
                            );
                          })),
                    )
                  ],
                ))));
  }
}

class ChartData {
  final int x;
  final double y;
  ChartData(
    this.x,
    this.y,
  );
}
