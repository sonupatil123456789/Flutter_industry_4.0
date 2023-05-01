import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker/Components/Weathercard.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String profilepicworker = 'assets/weather.png';
const String noweather = 'assets/weathericon/weatherbg.jpg';
const String sunmoon = 'assets/weathericon/sunmoon.webp';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
// vernaribility

  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  String baseurl = dotenv.env['BASEURL']!;
  String Weather_api_key = dotenv.env['APIKEYWEATHER']!;

  var temprature;

  Future Getweatherdetails(lat, long) async {
    print("Api function ran");
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$Weather_api_key'));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          temprature = mapresponse["main"]["temp"] - 273.15;
          print(mapresponse);
        });
      }
      if (response.statusCode == 400) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          mapresponsedata = mapresponse["message"];
          Fluttertoast.showToast(
              msg: "${mapresponse["message"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: HexColor('#A5FF8F'),
              textColor: HexColor('#000000'),
              fontSize: 16.0);
        });
      }
      setState(() {});
    } catch (e) {
      print('$e');
      Fluttertoast.showToast(
          msg: "${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: HexColor('#A5FF8F'),
          textColor: HexColor('#000000'),
          fontSize: 16.0);
    }
  }

  @override
  initState() {
    getlocation();
    super.initState;
  }

  var getlatitudeval;
  var getlongitudeval;
  var getaltitudeval;

  Future getlocation() async {
    var status = await Permission.location.status;
    print("status : $status");
    if (await status.isGranted) {
      print("Location permission is already granted");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      getlatitudeval = await position.latitude;
      getlongitudeval = await position.longitude;
      await Getweatherdetails(getlatitudeval, getlongitudeval);
      print("Latitude is = ${position.latitude}");
      print("Longitude is = ${position.longitude}");
    }
    if (await status.isDenied) {
      print("Location permission is already granted");
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: RefreshIndicator(
        onRefresh: () async {
          await getlocation();
          setState(() {});
        },
        child: Scaffold(
            body: mapresponse == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: HexColor("#6C63FF"),
                    strokeWidth: 8,
                  ))
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        title: Text(
                          mapresponse == null ? "" : mapresponse["name"],
                        ),
                        // leadingWidth: Text("xiujohxniw"),
                        backgroundColor: HexColor("#000000"),
                        expandedHeight: screenheight * 0.30,
                        pinned: true,
                        leading: Padding(
                          padding:
                              const EdgeInsets.only(left: 20, top: 0, right: 0),
                          child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Colors.white,
                            width: screenwidth,
                            child: Image.asset(
                              alignment: Alignment.topCenter,
                              noweather,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 1200,
                        delegate: SliverChildListDelegate([
                          Container(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenwidth * 0.14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 0, right: 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        // color: Colors.amber,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                mapresponse == null
                                                    ? "0  \u2103"
                                                    : temprature
                                                            .toInt()
                                                            .toString() +
                                                        "" +
                                                        " \u2103",
                                                   style: GoogleFonts.poppins(
                                        height: 1.2,
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenwidth * 0.15,
                                        color: HexColor('#212121'))
                                                        ),
                                            Text(
                                              mapresponse == null
                                                  ? ""
                                                  : "-- " +
                                                      mapresponse["weather"][0]
                                                              ["description"]
                                                          .toString() +
                                                      " --",
                                                     style: GoogleFonts.notoSans(
                                        height: 1.2,
                                        fontWeight: FontWeight.w300,
                                        fontSize: screenwidth * 0.034,
                                        color: HexColor('#212121'))
                                            ),
                                            SizedBox(
                                              height: screenwidth * 0.01,
                                            ),
                                            // Text(
                                            //     mapresponse == null
                                            //         ? ""
                                            //         : mapresponse["name"],
                                            //     style: TextStyle(
                                            //         fontWeight: FontWeight.w400,
                                            //         fontSize:
                                            //             screenwidth * 0.05,
                                            //         color:
                                            //             HexColor('#000000'))),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenwidth * 0.25,
                                      ),
                                      Container(
                                        width: screenwidth * 0.30,
                                        height: screenheight * 0.10,
                                        // color: Colors.amber,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: HexColor("#000000"),
                                        ),
                                        child: mapresponse == null
                                            ? Icon(
                                                WeatherIcons.na,
                                                size: 60,
                                                color: HexColor("#18BAFF"),
                                              )
                                            : Icon(
                                                mapresponse["weather"][0]
                                                                ["main"]
                                                            .toString()
                                                            .contains(
                                                                "Clear") ==
                                                        true
                                                    ? WeatherIcons.day_sunny
                                                    : mapresponse["weather"][0]
                                                                    ["main"]
                                                                .toString()
                                                                .contains(
                                                                    "Thunderstorm") ==
                                                            true
                                                        ? WeatherIcons
                                                            .thunderstorm
                                                        : mapresponse["weather"]
                                                                            [0]
                                                                        ["main"]
                                                                    .toString()
                                                                    .contains(
                                                                        "Drizzle") ==
                                                                true
                                                            ? WeatherIcons
                                                                .raindrops
                                                            : mapresponse["weather"][0]
                                                                            ["main"]
                                                                        .toString()
                                                                        .contains("Snow") ==
                                                                    true
                                                                ? WeatherIcons.day_snow
                                                                : mapresponse["weather"][0]["main"].toString().contains("Rain") == true
                                                                    ? WeatherIcons.day_storm_showers
                                                                    : mapresponse["weather"][0]["icon"].toString().contains("50") == true
                                                                        ? WeatherIcons.day_haze
                                                                        : mapresponse["weather"][0]["main"].toString().contains("Clouds") == true
                                                                            ? WeatherIcons.day_cloudy
                                                                            : WeatherIcons.cloud_refresh,
                                                size: 40,
                                                color: HexColor("#FFFFFF"),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: screenwidth * 0.10,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 0, right: 0),
                                  child: Text("Weather Information",
                                      style: GoogleFonts.notoSans(
                                          height: 1.2,
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenwidth * 0.050,
                                          color: HexColor('#212121'))),
                                ),
                                SizedBox(
                                  height: screenwidth * 0.06,
                                ),

                                ////////////////
                                Expanded(
                                  child: Container(
                                    // color: Colors.blueGrey,
                                    // height: 300.0,
                                    width: screenwidth,
                                    child: Wrap(
                                      runSpacing: 25,
                                      alignment: WrapAlignment.spaceAround,
                                      children: [
                                        ////////////////////////////////////////////////////////////////////////////////////////////////
                                        Weathercard(
                                          apiinfo: mapresponse["main"]
                                              ["humidity"],
                                          icon: WeatherIcons.humidity,
                                          info: "Humidity",
                                          unit: " %",
                                        ),
                                        Weathercard(
                                          apiinfo: mapresponse["main"]
                                                  ["feels_like"] -
                                              273.16,
                                          icon: WeatherIcons.thermometer,
                                          info: "Feels like",
                                          unit: " \u2103",
                                        ),
                                        Weathercard(
                                          apiinfo: mapresponse["main"]
                                              ["pressure"],
                                          icon: WeatherIcons.wind_deg_90,
                                          info: "Air pressure",
                                          unit: " hpa",
                                        ),
                                        Weathercard(
                                          apiinfo:
                                              mapresponse["visibility"] * 0.001,
                                          icon: Icons.select_all,
                                          info: "Visibility",
                                          unit: " km",
                                        ),
                                        Weathercard(
                                          apiinfo: mapresponse["wind"]
                                                  ["speed"] *
                                              3600 /
                                              1000,
                                          icon: WeatherIcons.day_windy,
                                          info: "Wind speed",
                                          unit: " km/hr",
                                        ),
                                        Weathercard(
                                          apiinfo: mapresponse["main"]
                                                  ["temp_max"] -
                                              273.16,
                                          icon: WeatherIcons.hot,
                                          info: "Wind speed",
                                          unit: "  \u2103",
                                        ),
                                        ////////////////////////////////////////////////////////////////////////////////////////////////
                                        Container(
                                          width: screenwidth * 0.88,
                                          height: screenheight * 0.24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: HexColor("#EDF7FF"),
                                          ),
                                          // color: Colors.amber,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.asset(
                                                  width: screenwidth,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  sunmoon,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 45,
                                                          height: 45,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: HexColor(
                                                                "#000000"),
                                                          ),
                                                          child: Icon(
                                                            WeatherIcons
                                                                .moon_alt_new,
                                                            size: 20,
                                                            color: HexColor(
                                                                "#FFFFFF"),
                                                          ),
                                                        ),
                                                        Text(
                                                          new DateFormat.jm()
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      mapresponse["sys"]
                                                                              [
                                                                              "sunset"] *
                                                                          1000))
                                                              .toString()
                                                              .toLowerCase(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  screenwidth *
                                                                      0.040,
                                                              color: HexColor(
                                                                  '#FFFFFF')),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: 45,
                                                          height: 45,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: HexColor(
                                                                "#000000"),
                                                          ),
                                                          child: Icon(
                                                            Icons.sunny,
                                                            size: 20,
                                                            color: HexColor(
                                                                "#FFFFFF"),
                                                          ),
                                                        ),
                                                        Text(
                                                          new DateFormat.jm()
                                                              .format(DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                                      mapresponse["sys"]
                                                                              [
                                                                              "sunrise"] *
                                                                          1000))
                                                              .toString()
                                                              .toLowerCase(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  screenwidth *
                                                                      0.040,
                                                              color: HexColor(
                                                                  '#FFFFFF')),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ////////////////
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  )
            // floatingActionButton: FloatingActionButton(
            //   elevation: 10,
            //   backgroundColor: HexColor('#6C63FF'),
            //   onPressed: () {
            //     // downloadimagefile();
            //   },
            //   child: Icon(
            //     Icons.download,
            //     size: 25,
            //     color: HexColor("#FFFFFF"),
            //   ),
            // )
            ),
      ),
    );
  }
}

  // DateTime.fromMillisecondsSinceEpoch(
  //                                                             mapresponse["sys"]
  //                                                                     [
  //                                                                     "sunrise"] *
  //                                                                 1000)
  //                                                         .toString()
  //                                                         .split(" ")[1]
  //                                                         .replaceAll(":", ".").substring(0,5)
  //                                                         .toString()
