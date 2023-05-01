import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/formspages/Editincidentform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:cr_file_saver/file_saver.dart';
// import 'package:cr_file_saver/generated/assets.dart';
// import 'package:file_saver/file_saver.dart';

import '../Components/Backbtnnavbar.dart';

class Incidentpage extends StatefulWidget {
  const Incidentpage({super.key});

  @override
  State<Incidentpage> createState() => _IncidentpageState();
}

class _IncidentpageState extends State<Incidentpage> {
  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  var getimage;

  String baseurl = dotenv.env['BASEURL']!;

  Future Getallincident() async {
    final prefs = await SharedPreferences.getInstance();
    var companyid = prefs.getString('companyid');
    try {
      final response = await http.get(Uri.parse(
          'https://$baseurl/api/v1/contracteraccountincident/$companyid'));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          mapresponsedata = mapresponse["incident"];
          print(mapresponsedata);
        });
      }
    } catch (e) {
      print('-----------$e---allworker--------');
    }
  }

  late String fileurl;
  var savePath;
  var downloadpercent = 0.0;
  Future downloadimagefile(fileurllink, date) async {
    final dir = await DownloadsPathProvider.downloadsDirectory;
    var savePath = '${dir!.path}/${date}.pdf';
    var fileurl = '$fileurllink';
    try {
      await Dio().download(
        fileurl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadpercent = received / total * 100;
            });
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
        deleteOnError: true,
      );
      print("File is saved to download folder ----$savePath.");
    } on DioError catch (e) {
      print(e.message);
    }
  }

  @override
  initState() {
    Getallincident();
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: screenwidth,
          height: screenheight,
          color: HexColor('#FFFFFF'),
          child: Column(children: [
            Back_btn_navbar(navname: "Incident"),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: mapresponse == null
                  ? Center(
                      child: CircularProgressIndicator(
                      color: HexColor("#6C63FF"),
                      strokeWidth: 6,
                    ))
                  : Container(
                      child: ListView.builder(
                          itemCount: mapresponsedata.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                // builtdialogbox();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(
                                          context,
                                          screenwidth,
                                          screenheight,
                                          mapresponsedata[index]
                                              ["contractername"],
                                          mapresponsedata[index]
                                              ["contracteremail"],
                                          mapresponsedata[index]
                                              ["contracternumber"],
                                          mapresponsedata[index]
                                              ["incidenttype"],
                                          mapresponsedata[index]
                                              ["totalinvestment"],
                                          mapresponsedata[index]
                                              ["totalfinancialloss"],
                                          mapresponsedata[index]
                                              ["noofpeopleenjured"],
                                          mapresponsedata[index]
                                              ["noofpeopledead"],
                                          mapresponsedata[index]
                                              ["incidentlocation"]["latitude"],
                                          mapresponsedata[index]
                                              ["incidentlocation"]["longitude"],
                                          mapresponsedata[index]["createdAt"]
                                              .substring(0, 10)),
                                );
                              },
                              onDoubleTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Editincidentform(
                                    objectid: mapresponsedata[index]["_id"],
                                    deadpeopleinin: mapresponsedata[index]
                                        ["noofpeopledead"],
                                    enjuredpeopleinin: mapresponsedata[index]
                                        ["noofpeopleenjured"],
                                    finenciallossesinin: mapresponsedata[index]
                                        ["totalfinancialloss"],
                                    incidenttypeinit: mapresponsedata[index]
                                        ["incidenttype"],
                                    totalinvestment: mapresponsedata[index]
                                        ["totalinvestment"],
                                    pdfeinit: mapresponsedata[index]
                                        ["pdffilelink"],
                                  );
                                }));
                              },
                              child: Container(
                                height: 240,
                                width: screenwidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenwidth * 0.90,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: HexColor('#FFFFFF'),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x337c99b3),
                                            blurRadius: 30,
                                            offset: Offset(6, 6),
                                          ),
                                          BoxShadow(
                                            color: Color(0x1c5690c5),
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 12,
                                            right: -16,
                                            child: Transform(
                                              alignment:
                                                  FractionalOffset.center,
                                              transform: new Matrix4.identity()
                                                ..rotateZ(45 * 3.1415927 / 180),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 2, 0, 0),
                                                  alignment: Alignment.center,
                                                  width: screenwidth * 0.18,
                                                  height: 18,
                                                  child: Text(
                                                    mapresponsedata[index]
                                                            ["createdAt"]
                                                        .substring(0, 10),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenwidth * 0.026,
                                                        color: HexColor(
                                                            '#FFFFFF')),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#948EFF'),
                                                  )),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        downloadimagefile(
                                                            mapresponsedata[
                                                                    index]
                                                                ["pdffilelink"],
                                                            mapresponsedata[
                                                                        index][
                                                                    "createdAt"]
                                                                .substring(
                                                                    0, 10));
                                                      },
                                                      child: Container(
                                                        width: 48.0,
                                                        height: 58.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Colors.cyanAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Image.asset(
                                                                'assets/pdf-file.png',
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenwidth * 0.037,
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: screenwidth * 0.62,
                                                      height: 60,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              mapresponsedata[
                                                                      index][
                                                                  "contractername"],
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenwidth *
                                                                          0.042,
                                                                  color: HexColor(
                                                                      '#212121')),
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              mapresponsedata[
                                                                      index][
                                                                  "contracteremail"],
                                                              style: GoogleFonts.notoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenwidth *
                                                                          0.030,
                                                                  color: HexColor(
                                                                      '#212121')),
                                                            ),
                                                          ]),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                height: 12,
                                                // child: Text("hided"),
                                              ),
                                              Container(
                                                height: 70,
                                                color:
                                                    // Color.fromARGB(255, 101, 157, 254),
                                                    // HexColor('#6C63FF'),
                                                    HexColor('#746CFF'),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: screenwidth * 0.16,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Enjured",
                                                            style: GoogleFonts.notoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.032,
                                                                color: HexColor(
                                                                    '#FFFFFF')),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            mapresponsedata[
                                                                        index][
                                                                    "noofpeopleenjured"]
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.048,
                                                                color: HexColor(
                                                                    '#FFFFFF')),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 28,
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: screenwidth * 0.16,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Death",
                                                            style: GoogleFonts.notoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.032,
                                                                color: HexColor(
                                                                    '#FFFFFF')),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            mapresponsedata[
                                                                        index][
                                                                    "noofpeopledead"]
                                                                .toString(),
                                                            style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.048,
                                                                color: HexColor(
                                                                    '#FFFFFF')),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 28,
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: screenwidth * 0.36,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Finencial loss",
                                                            style: GoogleFonts.notoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.032,
                                                                color: HexColor(
                                                                    '#FFFFFF')),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                mapresponsedata[
                                                                            index]
                                                                        [
                                                                        "totalfinancialloss"]
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        screenwidth *
                                                                            0.048,
                                                                    color: HexColor(
                                                                        '#FFFFFF')),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "₹",
                                                                style: GoogleFonts.notoSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        screenwidth *
                                                                            0.052,
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
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                    ),
            ),
          ])),
    ));
  }
}

Widget _buildPopupDialog(
    BuildContext context,
    double screenwidth,
    double screenheight,
    contractername,
    contracteremail,
    contracternumber,
    incidenttype,
    totalinvestment,
    totalfinancialloss,
    noofpeopleenjured,
    noofpeopledead,
    lat,
    long,
    incidentdate) {
  var email = contracteremail;
  var calctext = totalfinancialloss / totalinvestment * 100;
  print("======$calctext");
  print(totalfinancialloss / totalinvestment * 100 / 100);
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)), //this right here
    child: Container(
      color: HexColor('#FFFFFF'),
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      contractername,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: screenwidth * 0.046,
                          color: HexColor('#212121')),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(
                        incidentdate,
                        style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: screenwidth * 0.034,
                            color: HexColor('#212121')),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenheight * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Container(
                      // color: Colors.amber,
                      width: screenwidth * 0.80,
                      height: screenwidth * 0.10,
                      child: Row(
                        children: [
                          Container(
                              width: screenwidth * 0.10,
                              height: screenwidth * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
                              ),
                              // color: HexColor('#B064B0'), //F5F3F5
                              child: IconButton(
                                tooltip: contracteremail.toString(),
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.mark_email_unread,
                                ),
                                onPressed: () async {
                                  try {
                                    final Uri emailLaunchUri = await Uri(
                                      scheme: 'mailto',
                                      path: contracteremail,
                                    );

                                    await launchUrl(emailLaunchUri);
                                  } catch (e) {
                                    print("error : $e");
                                  }
                                },
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              width: screenwidth * 0.10,
                              height: screenwidth * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
                              ),
                              child: IconButton(
                                tooltip: contracternumber.toString(),
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.phone_in_talk,
                                ),
                                onPressed: () async {
                                  try {
                                    final Uri numberlauncher = await Uri(
                                      scheme: 'tel',
                                      path: contracternumber.toString(),
                                    );

                                    await launchUrl(numberlauncher);
                                  } catch (e) {
                                    print("error : $e");
                                  }
                                },
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              width: screenwidth * 0.10,
                              height: screenwidth * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
                              ),
                              child: IconButton(
                                tooltip: contracternumber.toString(),
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.sms,
                                ),
                                onPressed: () async {
                                  try {
                                    final Uri smslauncher = await Uri(
                                      scheme: 'sms',
                                      path: contracternumber.toString(),
                                    );

                                    await launchUrl(smslauncher);
                                  } catch (e) {
                                    print("error : $e");
                                  }
                                },
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              width: screenwidth * 0.10,
                              height: screenwidth * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
                              ),
                              child: IconButton(
                                iconSize: 20,
                                icon: const Icon(
                                  Icons.near_me,
                                ),
                                onPressed: () {},
                              ))
                        ],
                      ),
                    ),
                  ),
                ]),
            Container(
              width: screenheight * 0.60,
              height: screenheight * 0.10,
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 0, right: 0),
                    child: Text(
                      "Incident discription",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: screenwidth * 0.045,
                          color: HexColor('#746CFF')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2, right: 0),
                    child: Text(
                      incidenttype,
                      style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.w400,
                          fontSize: screenwidth * 0.032,
                          color: HexColor('#212121')),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenheight * 0.01,
            ),
            Container(
              height: 60,
              color: HexColor('#EAF6F8'),
              // HexColor('#746CFF'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.amber,
                    width: screenwidth * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enjured",
                          style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.w300,
                              fontSize: screenwidth * 0.034,
                              color: HexColor('#212121')),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          noofpeopleenjured.toString(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: screenwidth * 0.052,
                              color: HexColor('#F7CD4D')),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  Container(
                    // color: Colors.amber,
                    width: screenwidth * 0.16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Death",
                          style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.w300,
                              fontSize: screenwidth * 0.034,
                              color: HexColor('#212121')),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          noofpeopledead.toString(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: screenwidth * 0.052,
                              color: HexColor('#F84C4C')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenheight * 0.01,
            ),
            Row(
              children: [
                Container(
                  width: screenwidth * 0.36,
                  // color: Colors.amber,
                  height: 140,
                  child: CircularPercentIndicator(
                    animation: true,
                    animationDuration: 2000,
                    radius: 50.0,
                    lineWidth: 12.0,
                    percent: calctext.isNaN
                        ? 0.0
                        : calctext /
                            100, // totalfinancialloss / totalinvestment * 100 / 100,
                    center: Text(
                      "${calctext.isNaN ? "0" : calctext.toInt()}%",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: screenwidth * 0.03,
                          color: HexColor('#212121')),
                    ),
                    progressColor: HexColor("#6C63FF"),
                  ),
                ),
                Container(
                  width: screenwidth * 0.36,
                  // color: Color.fromARGB(255, 156, 58, 243),
                  height: 140,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.amber,
                          width: screenwidth * 0.36,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Finencial loss",
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w300,
                                    fontSize: screenwidth * 0.034,
                                    color: HexColor('#212121')),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    totalfinancialloss.toString(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenwidth * 0.048,
                                        color: HexColor('#212121')),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "₹",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: screenwidth * 0.05,
                                        color: HexColor('#212121')),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          width: screenwidth * 0.36,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Investment cost",
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w300,
                                    fontSize: screenwidth * 0.034,
                                    color: HexColor('#212121')),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    totalinvestment.toString(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenwidth * 0.048,
                                        color: HexColor('#212121')),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "₹",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: screenwidth * 0.05,
                                        color: HexColor('#212121')),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // SizedBox(
                //     width: 100.0,
                //     child: OutlinedButton(
                //       style: OutlinedButton.styleFrom(
                //           backgroundColor: HexColor('#FFFFFF'),
                //           foregroundColor: HexColor('#746CFF')),
                //       onPressed: () {},
                //       child: Text('view'),
                //     )),
                // SizedBox(
                //   width: screenwidth * 0.01,
                // ),
                SizedBox(
                    width: 100.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: HexColor('#FFFFFF'),
                          foregroundColor: HexColor('#746CFF')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    )),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
