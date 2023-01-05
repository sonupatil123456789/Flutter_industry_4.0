
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static double latitude = 18.789499;
  static double longitude = 73.344803;

  static final CameraPosition Mycameraposition = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: Mycameraposition,
        zoomControlsEnabled: false,
        markers: {
          Marker(
              markerId: MarkerId("source"),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: "this is workers location"))
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() async {
            GoogleMapController getmylocation = await _controller.future;
            getmylocation
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 16.00,
            )));
          });
        },
        label: const Text('To my location !'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }


}










Padding(
              padding: const EdgeInsets.only(left: 0, top: 20, right: 0),
              child: Container(
                // width: 364,
                width: screenwidth * 0.88,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor("#FFFFFF"),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: HexColor("#000000"),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          size: 20,
                          color: HexColor("#FFFFFF"),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "240.0 m/sec",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: HexColor('#212121')),
                            ),
                            Text(
                              "Gas leakage dectection emergancy mode",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                  color: HexColor('#212121')),
                            )
                          ]),
                    ]),
              ),
            ),












return Stack(alignment: Alignment.center, children: [
      Positioned(
          top: 10,
          right: 230,
          child: Container(
            width: 150,
            height: 120,
            // color: Color.fromARGB(255, 64, 67, 255),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: HexColor("#000000"),
            ),
          )),
      Positioned(
          top: 10,
          left: 230,
          child: Container(
            width: 150,
            height: 200,
            color: Color.fromARGB(255, 215, 10, 184),
          )),
      Positioned(
          top: 160,
          right: 230,
          child: Container(
            width: 150,
            height: 184,
            // color: Color.fromARGB(255, 64, 67, 255),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: HexColor("#000000"),
            ),
          )),
      Positioned(
          top: 240,
          left: 230,
          child: Container(
            width: 150,
            height: 104,
            // color: Color.fromARGB(255, 144, 255, 64),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: HexColor("#000000"),
            ),
          )),
    ]);










     Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: doNothing,
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: doNothing,
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.share,
                    label: 'Share',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: doNothing,
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  SlidableAction(
                    onPressed: doNothing,
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),
              child: Column(children: [
                Worker_list(),
                Worker_list(),
                Worker_list(),
              ]),
            ),










        
        
return GestureDetector(
          onTap: () {
            print("hello user");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Worker_health_page();
            }));
          },
          child: Container(
            width: screenwidth * 0.90,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // color: HexColor("#FFFFFF"),
              color: HexColor('#EDF7FF'),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          Image.asset('assets/profile.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Omkar pralhad deshmukh",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: HexColor('#212121')),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "23486467383788399337",
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: HexColor('#212121')),
                        )
                      ]),
                ]),
          ),
        );














         if (snapshot.hasData) {
          final workerhealth = Map<String, dynamic>.from(
              (snapshot.data! as Event).snapshot.value);
          workerhealth.forEach((key, value) {
            final workerhealthdetails = Map<String, dynamic>.from(value);

          });
        }





        return StreamBuilder(
      stream: database.onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Text("Loading..."),
          );
        } else {
          Map<String, dynamic> workerhealth =
              snapshot.data!.snapshot.value as dynamic;
          List<dynamic> list = [];
          list.clear();
          list = workerhealth.values.toList();
          return ListView.builder(
              itemCount: snapshot.data!.snapshot.childrean.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(list[index]['name']),
                );
              }));
        }
      },
    );










    var stepcoun;
  var heartrate;

  Worker_health_page({Key? key, required this.stepcoun, required this.heartrate}) : super(key: key);





import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Components/Backbtnnavbar.dart';

class Worker_location_page extends StatefulWidget {
  var workerlat;
  var workerlong;
  var name;

  Worker_location_page(
      {Key? key,
      required this.workerlat,
      required this.workerlong,
      required this.name})
      : super(key: key);

  @override
  State<Worker_location_page> createState() => _Worker_location_pageState();
}

class _Worker_location_pageState extends State<Worker_location_page> {
  final Completer<GoogleMapController> _controller = Completer();

  static double latitude = 18.789499;
  static double longitude = 73.344803;

  static final CameraPosition Mycameraposition = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Back_btn_navbar(navname: '${widget.name}'),
                Expanded(
                  child: SizedBox(
                    height: screenheight,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: Mycameraposition,
                      zoomControlsEnabled: false,
                      markers: {
                        Marker(
                            markerId: MarkerId("source"),
                            position: LatLng(latitude, longitude),
                            infoWindow:
                                InfoWindow(title: "this is workers location"))
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
              ],
            ),

            //////////////////////////////////////////////////////////
            ///
            SlidingUpPanel(
              maxHeight: 300,
              minHeight: 80,
              panel: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Veena nagar khopoli",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "( ${widget.workerlat} , ${widget.workerlong} )",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() async {
              GoogleMapController getmylocation = await _controller.future;
              getmylocation
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 16.00,
              )));
            });
          },
          label: const Text('!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }
}














Container(
                          color: Colors.blueAccent,
                          child: Column(
                            children: [
                              Container(
                                  color: Colors.amberAccent,
                                  child: Text(
                                      mapresponsedata[index]["workeremail"])),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  color: Color.fromARGB(255, 244, 243, 240),
                                  child: Text(
                                      mapresponsedata[index]["workername"])),
                            ],
                          ));













                           Fluttertoast.showToast(
                                    msg: "data updated successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);





                                      Future setvalueonscreen() async {
    try {
      final response = await http.post(
          Uri.parse('http://192.168.0.103:4000/api/v1/worker/new'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "workername": "akshay zalte ",
            "workeremail": "akshayzalte@gmail.com",
            "workernumber": 9297129289,
            "images": "swagat mhatrejnwxwxjwexwecxnjwejcww",
            "birthdate": "2/03/2002",
            "medicalinformation": {
              "age": 0,
              "gender": "male",
              "weight": 7,
              "height": 80,
              "bloodgroup": "o+ve"
            },
            "adharnumber": 123456789012,
          }));
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
        });
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }







  workername = Namecontroller.text == ""
                                    ? mapresponse["worker"]["workername"]
                                    : Namecontroller.text;
                                print(workername);
                                workeremail = Emailcontroller.text == ""
                                    ? mapresponse["worker"]["workeremail"]
                                    : Emailcontroller.text;
                                print(workeremail);
                                workerno = Mobilenocontroller.text == null
                                    ? mapresponse["worker"]["workernumber"]
                                    : Mobilenocontroller.text;
                                print(workerno);
                                workerimage =
                                    workerprofileimage.toString() == ""
                                        ? mapresponse["worker"]["images"]
                                        : workerprofileimage.toString();
                                print(workerimage);
                                workerbirthdate = selectedDate.toString() == ""
                                    ? mapresponse["worker"]["birthdate"]
                                    : selectedDate.toString();
                                print(workerbirthdate);
                                workeradress = Addresscontroller.text == ""
                                    ? mapresponse["worker"]["address"]
                                    : Addresscontroller.text;
                                print(workeradress);
                                workerage = Agecontroller.text == null
                                    ? mapresponse["worker"]
                                        ["medicalinformation"]["age"]
                                    : Agecontroller.text;
                                print(workerage);
                                workergender = radiovalue == ""
                                    ? mapresponse["worker"]
                                        ["medicalinformation"]["gender"]
                                    : Agecontroller.text;
                                print(workergender);
                                workerweight = Heightcontroller.text == null
                                    ? mapresponse["worker"]
                                        ["medicalinformation"]["height"]
                                    : Heightcontroller.text;
                                print(workerweight);
                                workerheight = Weightcontroller.text == null
                                    ? mapresponse["worker"]
                                        ["medicalinformation"]["weight"]
                                    : Weightcontroller.text;
                                print(workerheight);
                                workerbloodgroup =
                                    Bloodgroupcontroller.text == ""
                                        ? mapresponse["worker"]
                                            ["medicalinformation"]["bloodgroup"]
                                        : Bloodgroupcontroller.text;
                                print(workerbloodgroup);
                                workeradhar = Adharcardcontroller.text == null
                                    ? mapresponse["worker"]["adharnumber"]
                                    : Adharcardcontroller.text;
                                print(workeradhar);















                                if (await mapresponse["success"] == true) {
        Namecontroller.text = mapresponse["worker"]["workername"] == null
            ? "loading"
            : mapresponse["worker"]["workername"];
        Emailcontroller.text = mapresponse["worker"]["workeremail"] == null
            ? "loading"
            : mapresponse["worker"]["workeremail"];
        Mobilenocontroller.text = mapresponse["worker"]["workernumber"] == null
            ? "loading"
            : mapresponse["worker"]["workernumber"];
        workerprofileimage = mapresponse["worker"]["images"] == null
            ? "loading"
            : mapresponse["worker"]["images"];
        selectedDate = mapresponse["worker"]["birthdate"] == null
            ? "loading"
            : mapresponse["worker"]["birthdate"];
        Addresscontroller.text = mapresponse["worker"]["address"] == null
            ? "loading"
            : mapresponse["worker"]["address"];
        Agecontroller.text =
            mapresponse["worker"]["medicalinformation"]["age"] == null
                ? "loading"
                : mapresponse["worker"]["medicalinformation"]["age"];
        radiovalue =
            mapresponse["worker"]["medicalinformation"]["gender"] == null
                ? "loading"
                : mapresponse["worker"]["medicalinformation"]["gender"];
        Heightcontroller.text =
            mapresponse["worker"]["medicalinformation"]["height"] == null
                ? "loading"
                : mapresponse["worker"]["medicalinformation"]["height"];
        Weightcontroller.text =
            mapresponse["worker"]["medicalinformation"]["weight"] == null
                ? "loading"
                : mapresponse["worker"]["medicalinformation"]["weight"];
        ;
        Bloodgroupcontroller.text =
            mapresponse["worker"]["medicalinformation"]["bloodgroup"] == null
                ? "loading"
                : mapresponse["worker"]["medicalinformation"]["bloodgroup"];
        Adharcardcontroller.text = mapresponse["worker"]["adharnumber"] == null
            ? "loading"
            : Adharcardcontroller.text = mapresponse["worker"]["adharnumber"];
      } else {}







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

import '../Components/Backbtnnavbar.dart';

const _barsGradient = LinearGradient(
  colors: [
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);


List<BarChartGroupData> barChartGroupData = [
  BarChartGroupData(
      x: 1, barRods: [BarChartRodData(toY: 10, gradient: _barsGradient)]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(toY: 8.5, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(toY: 12.6, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(toY: 11.4, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(toY: 7.5, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(toY: 14, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(toY: 12.2, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(toY: 8.5, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(toY: 12.6, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(toY: 11.4, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(toY: 7.5, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(toY: 14, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(toY: 12.2, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(toY: 8.5, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(toY: 14, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(toY: 12.2, gradient: _barsGradient),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(toY: 8.5, gradient: _barsGradient),
  ]),
];

class Graph_information extends StatefulWidget {
  const Graph_information({Key? key}) : super(key: key);

  @override
  State<Graph_information> createState() => _Graph_informationState();
}

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff7589a2),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4.0,
    child: Text(value.toString(), style: style),
  );
}

FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(
      show: false,
    );

class _Graph_informationState extends State<Graph_information> {
  final database = FirebaseDatabase.instance.ref("workerhealth");
// snapshot.child('name').value.toString()

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: FirebaseAnimatedList(
            query: database,
            defaultChild: Center(
                child: CircularProgressIndicator(
              color: HexColor("#6C63FF"),
              strokeWidth: 6,
            )),
            itemBuilder: ((context, snapshot, animation, index) {
              return Container(
                  width: screenwidth,
                  height: screenheight,
                  color: HexColor('#EDF7FF'),
                  child: Column(
                    children: [
                      const Back_btn_navbar(navname: "Graph info"),
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: screenheight * 0.96,
                              height: 310,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Colors.blue,
                                // ),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: screenwidth * 0.92,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.blue,
                                    // ),
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  height: 280,
                                  child: BarChart(BarChartData(
                                    maxY: 20,
                                    titlesData: titlesData,
                                    borderData: borderData,
                                    gridData: FlGridData(show: false),
                                    barGroups:barChartGroupData,
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(snapshot.child('stepcount').value.toString())
                          ],
                        ),
                      ),
                    ],
                  ));
            })),
      ),
    );
  }
}





ListView.builder(
                                  itemCount: ,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      width: screenwidth * 0.90,
                                      height: screenwidth * 0.50,
                                      child: SfCartesianChart(
                                          primaryXAxis: NumericAxis(
                                            majorGridLines:
                                                MajorGridLines(width: 0),
                                            axisLine: AxisLine(width: 0),
                                          ),
                                          primaryYAxis: NumericAxis(
                                              majorGridLines:
                                                  MajorGridLines(width: 0),
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
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y)
                                          ]),
                                    );
                                  }));




                                  Timer(
        const Duration(seconds: 2),
        // () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => (Showintroscreen == true
        //         ? Fill_details()
        //         : const Home_page(
        //             Myname: null, Mynumber: null, Mypic: null)))));

        // () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => Fill_details())));

        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home_page(
                  Myname: null,
                  Mynumber: null,
                  Mypic: null,
                  Message: null,
                ))));






                      Future Deletworkerdata() async {
                                      try {
                                        final response = await http.delete(
                                          Uri.parse(
                                              'http://$baseurl/api/v1/worker/${mapresponsedata[index]["_id"]}'),
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                        );
                                        print(response.body);

                                        if (response.statusCode == 200) {
                                          setState(() {
                                            stringresponse = response;
                                          });
                                        } else {
                                          return null;
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    }

                                    setState(() {
                                      Deletworkerdata();
                                    });













                                    IntrinsicHeight(
                                                child: Container(
                                                  height: 80,
                                                  width: 240,
                                                  // color: Colors.blueAccent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Enjured     ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.04,
                                                                color: HexColor(
                                                                    '#212121')),
                                                          ),
                                                          SizedBox(
                                                            height: 18,
                                                          ),
                                                          Text(
                                                            "51",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.07,
                                                                color: HexColor(
                                                                    '#212121')),
                                                          ),
                                                        ],
                                                      ),
                                                      VerticalDivider(
                                                        color: Color.fromARGB(
                                                            255, 78, 78, 78),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Economic loss",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.04,
                                                                color: HexColor(
                                                                    '#212121')),
                                                          ),
                                                          SizedBox(
                                                            height: 18,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "80,00,00,00",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        screenwidth *
                                                                            0.07,
                                                                    color: HexColor(
                                                                        '#212121')),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "₹",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        screenwidth *
                                                                            0.05,
                                                                    color: HexColor(
                                                                        '#212121')),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )





 Future downloadimagefile() async {
    try {
      var pathtostore = await DownloadsPathProvider.downloadsDirectory;

      var downloaderUtils = await DownloaderUtils(
        progressCallback: (current, total) {
          final progress = (current / total) * 100;
          print('Downloading: $progress');
        },
        file:
            File('${pathtostore?.path}/${mapresponse["worker"]["workername"]}'),
        progress: ProgressImplementation(),
        deleteOnCancel: true,
        onDone: () => print("dounload compleated ${pathtostore?.path}"),
      );

      var core = await Flowder.download(
          '${mapresponse["worker"]["images"]}', downloaderUtils);
    } catch (e) {
      print(e);
    }
  }







     import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/Components/Listcard.dart';
import 'package:location_tracker/Pages/Workerhealthpage.dart';
import 'package:location_tracker/formspages/Addworkerform.dart';
import 'package:location_tracker/formspages/Updateworkerform.dart';
import 'package:location_tracker/models/workerdetailmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Backbtnnavbar.dart';

class Allworkerlist extends StatefulWidget {
  var companyid;
  Allworkerlist({super.key, required companyid});

  @override
  State<Allworkerlist> createState() => _AllworkerlistState();
}

class _AllworkerlistState extends State<Allworkerlist> {
  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  String baseurl = dotenv.env['BASEURL']!;
  var companyid;

  Future Getallworkersdetails() async {
    final prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('companyid');
  }

  @override
  initState() {
    // Timer(Duration(seconds: 43200), () => print('done'));
    super.initState;
  }

  final String profilepicworker = 'assets/profile.jpg';
  final database = FirebaseDatabase.instance.ref("companys");

  @override
  Widget build(BuildContext context) {
    Getallworkersdetails();
    print(companyid.toString());
    print("widget rendering started");
    print(companyid.toString());
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: screenwidth,
          height: screenheight,
          color: HexColor("#FFFFFF"),
          child: Column(children: [
            const Back_btn_navbar(navname: "worker details"),
            SizedBox(
              height: 20,
            ),
            Expanded(
              // child: Listcaerd(),
              child: FirebaseAnimatedList(
                  query: database
                      // .child(companyid == null ? "3815" : companyid)
                      .child(companyid.toString())
                      .child("siteworkerhealth"),
                  defaultChild: Center(
                      child: CircularProgressIndicator(
                    color: HexColor("#6C63FF"),
                    strokeWidth: 6,
                  )),
                  itemBuilder: ((context, snapshot, animation, index) {
                    print(snapshot.key.toString());
                    return Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (buildctx) {
                                // Future Deletworkerdata() async {
                                //   try {
                                //     final response = await http.delete(
                                //       Uri.parse(
                                //           'http://$baseurl/api/v1/worker/${mapresponsedata[index]["_id"]}'),
                                //       headers: <String, String>{
                                //         'Content-Type': 'application/json; charset=UTF-8',
                                //       },
                                //     );
                                //     print(response.body);
                                //     if (response.statusCode == 200) {
                                //       await Fluttertoast.showToast(
                                //           msg:
                                //               "Worker deleted from database successfully",
                                //           toastLength: Toast.LENGTH_SHORT,
                                //           gravity: ToastGravity.CENTER,
                                //           timeInSecForIosWeb: 5,
                                //           backgroundColor: HexColor('#A5FF8F'),
                                //           textColor: HexColor('#000000'),
                                //           fontSize: 16.0);
                                //       setState(() {
                                //         stringresponse = response;
                                //       });
                                //     } else {
                                //       return null;
                                //     }
                                //   } catch (e) {
                                //     print(e);
                                //   }
                                // }
                                // Deletworkerdata();
                                var datadeleted = database
                                    .child(companyid)
                                    .child("siteworkerhealth")
                                    .child(
                                        '/${snapshot.child('id').value.toString()}')
                                    .remove()
                                    .then((value) => print(
                                        '${snapshot.child('id').value.toString()}deleted successfully'));
                              },
                              backgroundColor: HexColor('#A5FF8F'),
                              foregroundColor: HexColor('#000000'),
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              flex: 2,
                              onPressed: (buildctx) {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return Updateworkerform(
                                //     uuid: mapresponsedata[index]["_id"],
                                //     workernameparams: mapresponsedata[index]
                                //         ["workername"],
                                //     workeremailparams: mapresponsedata[index]
                                //         ["workeremail"],
                                //     workernumberparams: mapresponsedata[index]
                                //         ["workernumber"],
                                //     imagesparams: mapresponsedata[index]["images"],
                                //     birthdateparams: mapresponsedata[index]["birthdate"],
                                //     addressparams: mapresponsedata[index]["address"],
                                //     adharnumberparams: mapresponsedata[index]
                                //         ["adharnumber"],
                                //     ageparams: mapresponsedata[index]
                                //         ["medicalinformation"]["age"],
                                //     genderparams: mapresponsedata[index]
                                //         ["medicalinformation"]["gender"],
                                //     heightparams: mapresponsedata[index]
                                //         ["medicalinformation"]["height"],
                                //     weightparams: mapresponsedata[index]
                                //         ["medicalinformation"]["weight"],
                                //     bloodgroupparams: mapresponsedata[index]
                                //         ["medicalinformation"]["bloodgroup"],
                                //     companyid: companyid,
                                //   );
                                // }));
                              },
                              backgroundColor: HexColor('#A5FF8F'),
                              foregroundColor: HexColor('#000000'),
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print("hello user");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Worker_health_page(
                                uuid: snapshot.child('id').value.toString(),
                                name: snapshot.child('name').value.toString(),
                                profilepic:
                                    snapshot.child('imagepic').value.toString(),
                                companyid: companyid,
                              );
                            }));
                          },
                          child: Container(
                            width: screenwidth,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (snapshot
                                          .child('accident')
                                          .value
                                          .toString() ==
                                      "true"
                                  ? HexColor("#FFD0D7")
                                  : HexColor("#FFFFFF")),
                              // color: HexColor('#EDF7FF'),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: (snapshot
                                                  .child('imagepic')
                                                  .value
                                                  .toString() ==
                                              "null"
                                          ? Image.asset('assets/profile.jpg',
                                              fit: BoxFit.cover)
                                          : Image.network(
                                              snapshot
                                                  .child('imagepic')
                                                  .value
                                                  .toString(),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot
                                              .child('name')
                                              .value
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: HexColor('#212121')),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          snapshot.child('id').value.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14,
                                              color: HexColor('#212121')),
                                        )
                                      ]),
                                ]),
                          ),
                        ));
                  })),
            ),
          ])),
    ));
  }
}





                                      // foo == 1 ? doSomething1 : (foo == 2 ? doSomething1 : doSomething2)  exColor("#FFFFFF")

// (snapshot
//                                                   .child('accident')
//                                                   .value
//                                                   .toString() ==
//                                               "true"
//                                           ? HexColor("#FFD0D7")
//                                           : ( (snapshot
//                                                   .child('accident')
//                                                   .value! >= 2) ?  HexColor("#FFD0D7") :  HexColor("#FFFFFF")    )),











Container(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                primary: HexColor('#000000'),
                                onPrimary: HexColor('#FFFFFF'),
                              ),
                   
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    // fontSize: 17,
                                    letterSpacing: 2,
                                    fontSize: screenwidth * 0.050,
                                    fontWeight: FontWeight.w400),
                              ),
                            )),





                                 // child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(20),
                                //     child: (workerprofileimage != null
                                //         ? Image.network(workerprofileimage,
                                //             fit: BoxFit.cover)
                                //         : Image.asset('assets/profile.jpg',
                                //             fit: BoxFit.cover))),








                                
                                                  _onSaveFilePressed() async {
                                                    final folder =
                                                        await getTemporaryDirectory();
                                                    var savePath =
                                                        '${folder.path}/${mapresponsedata[index]["createdAt"].substring(0, 10)}';
                                                    var fileurl =
                                                        '${mapresponsedata[index]["pdffilelink"]}';
                                                  }

                                                  _onSaveFilePressed();