import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:location_tracker/Components/Backbtnnavbar.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime now = new DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);
dynamic calc;
dynamic noofpieces;
dynamic inventrypercentage = 0.0;
bool backgroundmailcheck = true;

class Inventary extends StatefulWidget {
  String name;
  String uuid;
  dynamic companyid;

  Inventary(
      {super.key,
      required this.name,
      required this.uuid,
      required this.companyid});

  @override
  State<Inventary> createState() => _InventaryState();
}

class _InventaryState extends State<Inventary> {
  final database = FirebaseDatabase.instance.ref("companys");
  late StreamSubscription<DatabaseEvent> inventarydispose;
  late Map getinventary = {};

  void getinventaryf() async {
    final prefs = await SharedPreferences.getInstance();
    inventarydispose = database
        .child(widget.companyid)
        .child("inventary")
        .child('/${widget.uuid}')
        .onValue
        .listen((DatabaseEvent event) async {
      getinventary = event.snapshot.value as Map;
      to_email = getinventary['partnerbrandemail'];
      // var tonconversion = getinventary['perpieceweight'] / 1000;  ////// ton conversion value
      var kgconversion = getinventary['perpieceweight'];
      setState(() {
        inventrypercentage =
            getinventary['weight'] / getinventary['totalweight'] * 100;
        getinventary['totalweight'];
        getinventary['weight'];
        noofpieces = getinventary['weight'] / kgconversion; // in kg
        // noofpieces = getinventary['weight'] / tonconversion; // in tons
      });
      message =
          "Respected manager of  ${getinventary['partnerbrandname']} industry our inventary is going out of stock so we request an order to refill our inventary stock to produce smooth running of supply chin without any distubance. our inventary is reached to as low as ${inventrypercentage.isNaN || inventrypercentage.isInfinite == true ? 0 : inventrypercentage.toInt()} % please refill our stocks ";

      if (inventrypercentage < 25) {
        prefs.setBool('backgroundmailcheck', false);
      }

      if (inventrypercentage == 25 &&
          prefs.getBool('backgroundmailcheck') == true) {
        print(" email send ");
        sendinventarymail(
            to_email, to_name, from_email, from_name, user_subject, message);
        prefs.setBool('backgroundmailcheck', false);
      }

      if (inventrypercentage > 25) {
        prefs.setBool('backgroundmailcheck', true);
        print(" enventary is good ");
      }
    });

    print(
        "emailstatement ${prefs.getBool('backgroundmailcheck')}================}");
  }

  var stringresponseemail;
  dynamic mapresponse;

  var serviceid = "service_zf2ezeq";
  var tampletid = 'template_ugh9iy9';
  var userid = "uq7nZnZud5UA5IsVf";

  dynamic message;
  dynamic to_email;
  dynamic to_name;
  dynamic from_number;
  dynamic from_email;
  dynamic from_name;
  dynamic user_subject = "Requesting of new stocks ";

  Future GetInitialdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from_name = prefs.getString('Contractername');
    from_email = prefs.getString('Contracteremail');
    from_number = prefs.getString('Contractermobileno');
    print('$from_email-$from_name--is all the details');
  }

  Future sendinventarymail(
      to_email, to_name, from_email, from_name, subject, message) async {
    print(
        " $to_email, $to_name, $from_email, $from_name, $subject, $message calling mail function");
    try {
      final response = await http.post(
          Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "service_id": serviceid,
            "template_id": tampletid,
            "user_id": userid,
            "template_params": {
              "to_email": to_email,
              "from_email": from_email,
              "to_name": to_name,
              "from_name": from_name,
              "user_subject": subject,
              "message": message,
            }
          }));
      print("${response.body}");
      if (response.statusCode == 200) {
        await Fluttertoast.showToast(
            msg:
                'Order has been place to ${getinventary['partnerbrandname']} cpmpany',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);
        setState(() {
          stringresponseemail = response.body;
          print("$stringresponseemail");
        });
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: HexColor('#A5FF8F'),
          textColor: HexColor('#000000'),
          fontSize: 16.0);
      print(e);
    }
  }

  @override
  initState() {
    GetInitialdetails();
    getinventaryf();
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
            Back_btn_navbar(navname: "Inventary Tracking"),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                width: screenwidth,
                // color: HexColor('#FFFFFF'),
                // color: Colors.blueAccent,
                height: screenheight,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.amberAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenwidth * 0.50,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        widget.name.toString(),
                                        style: GoogleFonts.notoSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenwidth * 0.048,
                                            color: HexColor('#212121')),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        date.toString().substring(0, 10),
                                        style: GoogleFonts.notoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenwidth * 0.036,
                                            color: HexColor('#212121')),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              width: screenwidth * 0.12,
                            ),
                            Container(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                    minimumSize: Size(screenwidth * 0.30,
                                        screenheight * 0.05),
                                    // primary: HexColor('#8F3BFB'),
                                    primary: HexColor('#746CFF'),
                                    onPrimary: HexColor('#FFFFFF'),
                                  ),
                                  onPressed: () async {
                                    await sendinventarymail(
                                        to_email,
                                        to_name,
                                        from_email,
                                        from_name,
                                        user_subject,
                                        message);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Order',
                                        style: GoogleFonts.notoSans(
                                            fontSize: screenwidth * 0.032,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.01,
                      ),
                      Container(
                        // color: Colors.amber,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          // color: Colors.amber,
                          // color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
                        ),
                        child: Row(
                          children: [
                            // Container(
                            //   height: screenheight * 0.20,
                            //   width: screenwidth * 0.45,
                            //   // color: Colors.amber,
                            //   child: CircularPercentIndicator(
                            //     animation: true,
                            //     animationDuration: 2000,
                            //     radius: 54.0,
                            //     lineWidth: 12.0,
                            //     percent: (inventrypercentage == null
                            //         ? ""
                            //         : inventrypercentage / 100.toInt()),
                            //     // center: Text(getinventary == null
                            //     //     ? "Calibrating"
                            //     //     : "${getinventary['weight'] / getinventary['totalweight'] * 100.truncate()}%"),
                            //     progressColor: HexColor("#6C63FF"),
                            //   ),
                            // ),
                            Container(
                              width: screenwidth * 0.36,
                              // color: Color.fromARGB(255, 40, 255, 7),
                              height: screenheight * 0.17,
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: LiquidLinearProgressIndicator(
                                  value: inventrypercentage.isNaN ||
                                          inventrypercentage.isInfinite ||
                                          inventrypercentage == null
                                      ? 0.0
                                      : inventrypercentage /
                                          100, // Defaults to 0.5.
                                  borderRadius: 20.0,
                                  valueColor: AlwaysStoppedAnimation(
                                      inventrypercentage >= 90
                                          ? HexColor(
                                              "#69E6B2") // DCF9ED  69E6B2
                                          : inventrypercentage >= 60
                                              ? HexColor(
                                                  "#5FBAE2") // CDEAF6 5FBAE2
                                              : inventrypercentage >= 40
                                                  ? HexColor('#F7CD4D')
                                                  : inventrypercentage >= 10
                                                      ? HexColor('#F84C4C')
                                                      : HexColor(
                                                          '#E31111')), // Defaults to the current Theme's accentColor.
                                  backgroundColor: Colors
                                      .white, // Defaults to the current Theme's backgroundColor.
                                  direction: Axis
                                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenheight * 0.05,
                            ),
                            Container(
                              width: screenwidth * 0.36,
                              // color: Color.fromARGB(255, 40, 255, 7),
                              height: screenheight * 0.17,
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    inventrypercentage.isNaN ||
                                            inventrypercentage.isInfinite ||
                                            inventrypercentage == null
                                        ? "0"
                                        : inventrypercentage.toInt().toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenwidth * 0.15,
                                      color: inventrypercentage >= 90
                                          ? HexColor(
                                              "#69E6B2") // DCF9ED  69E6B2
                                          : inventrypercentage >= 60
                                              ? HexColor(
                                                  "#5FBAE2") // CDEAF6 5FBAE2
                                              : inventrypercentage >= 40
                                                  ? HexColor('#F7CD4D')
                                                  : inventrypercentage >= 10
                                                      ? HexColor('#F84C4C')
                                                      : HexColor('#E31111'),
                                    ),
                                  ),
                                  Text(
                                    "%",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenwidth * 0.06,
                                        color: HexColor('#212121')),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.01,
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.blueGrey,
                          // height: 300.0,
                          width: screenwidth,
                          child: Wrap(
                            runSpacing: 25,
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 20, right: 0),
                                child: Container(
                                  // width: 364,
                                  width: screenwidth * 0.88,
                                  height: screenheight * 0.08,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: HexColor("#EDF7FF"),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: HexColor("#000000"),
                                          ),
                                          child: Icon(
                                            Icons.inventory,
                                            size: 18,
                                            color: HexColor("#FFFFFF"),
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
                                                "${noofpieces == null ? "" : noofpieces.toInt()} / Pcs",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenwidth * 0.04,
                                                    color: HexColor('#212121')),
                                              ),
                                              Text(
                                                "Total pieces remaining in stock",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize:
                                                        screenwidth * 0.030,
                                                    color: HexColor('#212121')),
                                              )
                                            ]),
                                      ]),
                                ),
                              ),
////////////////////////////////////////////////////////////////////////////////////////////////////
                              Container(
                                width: screenwidth * 0.40,
                                height: screenheight * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: HexColor("#EDF7FF"),
                                  // color: HexColor("#FCFEFF"),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // color: Colors.cyan,
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: HexColor("#000000"),
                                            ),
                                            child: Icon(
                                              Icons.scale,
                                              size: 18,
                                              color: HexColor("#FFFFFF"),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getinventary[
                                                                'totalweight'] ==
                                                            null
                                                        ? ""
                                                        : getinventary[
                                                                'totalweight']
                                                            .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenwidth * 0.056,
                                                        color: HexColor(
                                                            '#212121')),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "Kg",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenwidth * 0.030,
                                                        color: HexColor(
                                                            '#212121')),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 68.0,
                                      // width: screenwidth,
                                      // color: Color.fromARGB(255, 34, 207, 81),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total capacity",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenwidth * 0.040,
                                                    color: HexColor('#212121')),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                  "Total stock holding capicity of inventary",
                                                  style: GoogleFonts.poppins(
                                                      height: 1.2,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize:
                                                          screenwidth * 0.030,
                                                      color:
                                                          HexColor('#212121')))
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ////////////////////////////////////////////////////////////////////////////////////////////////
                              Container(
                                width: screenwidth * 0.40,
                                height: screenheight * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: HexColor("#EDF7FF"),
                                  // color: HexColor("#FCFEFF"),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // color: Colors.cyan,
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: HexColor("#000000"),
                                            ),
                                            child: Icon(
                                              Icons.scale,
                                              size: 18,
                                              color: HexColor("#FFFFFF"),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getinventary['weight'] ==
                                                            null
                                                        ? ""
                                                        : getinventary['weight']
                                                            .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenwidth * 0.056,
                                                        color: HexColor(
                                                            '#212121')),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    "Kg",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenwidth * 0.030,
                                                        color: HexColor(
                                                            '#212121')),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 60.0,
                                      // width: screenwidth,
                                      // color: Color.fromARGB(255, 34, 207, 81),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Current capacity",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenwidth * 0.040,
                                                    color: HexColor('#212121')),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                  "Total stock remaning in inventary",
                                                  style: GoogleFonts.poppins(
                                                      height: 1.2,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize:
                                                          screenwidth * 0.030,
                                                      color:
                                                          HexColor('#212121'))
                                                          )
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
////////////////////////////////////////////////////////////////////////////////////////////////
                              Container(
                                width: screenwidth * 0.88,
                                height: screenheight * 0.135,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: HexColor("#EDF7FF"),
                                ),
                                // color: Colors.amber,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 0, right: 0),
                                      child: Text(
                                        "Sugessions",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenwidth * 0.045,
                                            color: HexColor('#746CFF')),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8, right: 0),
                                      child: Text(
                                          inventrypercentage >= 90
                                              ? "Inventary stock is full for satisfying high coustomer demand   "
                                              : inventrypercentage >= 60
                                                  ? "Inventary is Running smoothly and efficently without effecting sc "
                                                  : inventrypercentage >= 40
                                                      ? "Order should be made for smooth operation of Inventary "
                                                      : inventrypercentage >= 10
                                                          ? "Inventary is running out of stock it should be filled quickly as possible"
                                                          : "Inventary is out of stock there is no more stock avalable ",
                                          style: GoogleFonts.poppins(
                                              height: 1.2,
                                              fontWeight: FontWeight.w200,
                                              fontSize: screenwidth * 0.030,
                                              color: HexColor('#212121'))),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
/////xxxxxxxxxxxxxxxxxxxxxx
                    ],
                  ),
                ),
              ),
            ),
          ])),
    ));
  }

  @override
  deactivate() {
    inventarydispose.cancel();
    super.deactivate;
  }
}
