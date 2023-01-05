import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Backbtnnavbar.dart';
import 'package:location_tracker/Components/Pdfcomponent.dart';
import 'dart:convert';
import 'package:recase/recase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location_tracker/Pages/Workerhealthpage.dart';
import 'package:path_provider/path_provider.dart';

final String profilepicworker = 'assets/profile.jpg';

class Worker_info extends StatefulWidget {
  var uuid;
  Worker_info({Key? key, required this.uuid}) : super(key: key);

  @override
  State<Worker_info> createState() => _Worker_infoState();
}

class _Worker_infoState extends State<Worker_info> {
  var stringresponse;
  dynamic mapresponse;

  String baseurl = dotenv.env['BASEURL']!;

  late String fileurl;
  var savePath;
  var downloadpercent = 0.0;

  Future getworkerdetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://$baseurl/api/v1/worker/${widget.uuid}'));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
      }
    } catch (e) {
      print('-----------$e-----workerinfo------');
    }
  }

  // Future downloadimagefile() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   savePath = '${dir.path}/${mapresponse["worker"]["workername"]}';
  //   fileurl = '${mapresponse["worker"]["images"]}';
  //   try {
  //     await Dio().download(
  //       fileurl,
  //       savePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           setState(() {
  //             downloadpercent = received / total * 100;
  //           });
  //           print((received / total * 100).toStringAsFixed(0) + "%");
  //         }
  //       },
  //       deleteOnError: true,
  //     );
  //     print("File is saved to download folder ----$savePath.");
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  // }

  var fullname;
  late List namesplite = [];
  Name() async {
    if (mapresponse != null) {
      fullname = await mapresponse["worker"]["workername"].toString();
      namesplite = fullname.split(" ");
      print(namesplite);
      print("my name is ${namesplite[0]}==${namesplite[1]}==${namesplite[2]}");
      return namesplite;
    }
  }

  callfunctionbyline() async {
    await getworkerdetails();
    await Name();
  }

  @override
  initState() {
    callfunctionbyline();
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                mapresponse == null
                    ? "no res"
                    : mapresponse["worker"]["_id"].toString(),
              ),
              // leadingWidth: Text("xiujohxniw"),
              backgroundColor: HexColor("#000000"),
              expandedHeight: screenheight * 0.50,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20, top: 0, right: 0),
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) {
                        return Worker_health_page(
                          uuid: null,
                          name: null,
                          profilepic: null,
                          companyid: null,
                        );
                      }));
                    }),
              ),
              flexibleSpace: FlexibleSpaceBar(
                // title: Text(namesplite.length > 0 ? namesplite[0] : "no data",
                //     style: TextStyle(
                //         fontWeight: FontWeight.w400,
                //         fontSize: screenwidth * 0.040,
                //         color: HexColor('#FFFFFF'))),
                background: Container(
                  width: screenwidth,
                  child: Image.asset(
                    alignment: Alignment.topCenter,
                    profilepicworker,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 1500,
              delegate: SliverChildListDelegate([
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenwidth * 0.20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["workername"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: screenwidth * 0.060,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.01,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["_id"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.034,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                              color: HexColor("#000000"),
                              fontSize: screenwidth * 0.058,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("First Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            namesplite.length > 0 ? namesplite[0] : "no data",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Middle Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            namesplite.length > 0 ? namesplite[1] : "no data",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Last Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            namesplite.length > 0 ? namesplite[2] : "no data",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Birth Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["birthdate"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
////////////////////////////////////////////////////////////////////////////////
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                        // thickness: 1,
                        // indent: screenwidth * 0.10,
                        // endIndent: screenwidth * 0.10,
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                          "Personal Details",
                          style: TextStyle(
                              color: HexColor("#000000"),
                              fontSize: screenwidth * 0.058,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Email Id",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["workeremail"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Worker Phone Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["workernumber"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Adharcard Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["adharnumber"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
/////////////////////////////////////////////////////////////
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                        // thickness: 1,
                        // indent: screenwidth * 0.10,
                        // endIndent: screenwidth * 0.10,
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              color: HexColor("#000000"),
                              fontSize: screenwidth * 0.058,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Current Address",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["address"].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
////////////////////////////////////////
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                          "Medical Information",
                          style: TextStyle(
                              color: HexColor("#000000"),
                              fontSize: screenwidth * 0.058,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: screenwidth * 0.06,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Gender",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["medicalinformation"]
                                        ["gender"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Age",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["medicalinformation"]
                                        ["age"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Height",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["medicalinformation"]
                                        ["height"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Weight",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["medicalinformation"]
                                        ["weight"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text("Blood-Group",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.045,
                                color: HexColor('#6C63FF'))),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, top: 0, right: 0),
                        child: Text(
                            mapresponse == null
                                ? "no res"
                                : mapresponse["worker"]["medicalinformation"]
                                        ["bloodgroup"]
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenwidth * 0.040,
                                color: HexColor('#000000'))),
                      ),
                      SizedBox(
                        height: screenwidth * 0.05,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
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
    );
  }
}
// ["worker"][0]["medicalinformation"]
//  mapresponse["worker"]["_id"].toString()
