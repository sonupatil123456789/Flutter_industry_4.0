import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Backbtnnavbar.dart';
import 'package:location_tracker/Components/Cards.dart';
import 'package:location_tracker/Pages/Locationpage.dart';
import 'package:location_tracker/Pages/Workerinfo.dart';
import 'package:location_tracker/formspages/Updateworkerform.dart';
import 'package:shared_preferences/shared_preferences.dart';

const blood = 'assets/blood.svg';
const heart = 'assets/heart.svg';
const calories = 'assets/calories.svg';
const steps = 'assets/steps.svg';

class Worker_health_page extends StatefulWidget {
  var uuid;
  var name;
  var profilepic;
  var companyid;

  Worker_health_page(
      {Key? key,
      required this.uuid,
      required this.companyid,
      required this.name,
      required this.profilepic})
      : super(key: key);

  @override
  State<Worker_health_page> createState() => _Worker_health_pageState();
}

class _Worker_health_pageState extends State<Worker_health_page> {
  final database = FirebaseDatabase.instance.ref("companys");
  late StreamSubscription healthdispose;
  dynamic gethealth;
  late double distancetravelled;
  late int Caloriesburned = 0;
  late int weight;

  gethealthinfo(companyid, workerid) {
    print("function running ");
    healthdispose = database
        .child(companyid)
        .child("siteworkerhealth")
        .child('/${workerid}')
        .onValue
        .listen((DatabaseEvent event) {
      setState(() {
        gethealth = event.snapshot.value as Map;
        distancetravelled = gethealth["stepcount"] * 0.6072 / 1000.toDouble();
        weight = int.parse(gethealth["weight"]);
        Caloriesburned =
            6 * weight * int.parse(gethealth["timeworked"].split(":")[0]);

        print(Caloriesburned);
      });
    });
  }

  @override
  initState() {
    gethealthinfo(widget.companyid, widget.uuid);
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
                color: HexColor("#FFFFFF"),
                child: Column(
                  children: [
                    Back_btn_navbar(navname: widget.name.toString()),
                    Container(
                        height: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenwidth * 0.24,
                              height: 126,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: HexColor("#000000"), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#DAFFD1'),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: widget.profilepic == "null"
                                    ? Image.asset('assets/profile.jpeg',
                                        fit: BoxFit.cover)
                                    : Image.network(widget.profilepic,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              width: screenwidth * 0.56,
                              height: 126,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: HexColor("#000000"), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#D1E0FF'),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: HexColor('#8FB4FF'),
                                      ),
                                      child: Icon(
                                        (gethealth == null
                                            ? Icons.question_mark
                                            : gethealth["duty"] == false
                                                ? Icons.hourglass_full
                                                : Icons.hourglass_bottom),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (gethealth == null
                                              ? "00:00:00"
                                              : gethealth["timeworked"]
                                                  .toString()),
                                          // "",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: screenwidth * 0.04,
                                              color: HexColor('#212121')),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Working ${(gethealth == null ? "Loading" : gethealth["duty"] == false ? "full day" : "half day")}",
                                          // "",
                                          style: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w300,
                                              fontSize: screenwidth * 0.032,
                                              color: HexColor('#212121')),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          ],
                        )),
                    Container(
                      height: screenwidth * 0.04,
                      width: screenwidth,
                    ),
                    Container(
                      height: 50.0,
                      width: screenwidth,
                      // width: 450,
                      // color: HexColor('#87EAC0'),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Health info",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: HexColor('#212121')),
                              ),
                              Container(
                                width: screenwidth * 0.18,
                                height: 30.0,
                                // color: Colors.black,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "See more",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                        color: HexColor('#000000')),
                                  ),
                                  IconButton(
                                    onPressed: (() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Worker_info(
                                          uuid: widget.uuid,
                                        );
                                      }));
                                    }),
                                    icon: Icon(FeatherIcons.arrowRight,
                                        size: 18, color: HexColor('#212121')),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                    Container(
                      height: screenwidth * 0.04,
                      width: screenwidth,
                    ),
                    Container(
                      height: 80,
                      width: screenwidth * 0.86,
                      decoration: BoxDecoration(
                        // border: Border.all(color: HexColor("#000000"), width: 1),
                        borderRadius: BorderRadius.circular(20),
                        color: HexColor('#FFFAD1'),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: HexColor("#FFF28F")),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_walk,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      gethealth == null
                                          ? "0 "
                                          : gethealth["stepcount"].toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenwidth * 0.04,
                                          color: HexColor('#212121')),
                                    ),
                                    Text(
                                      // (stepcount == null) ? "0" : stepcount,
                                      "  Steps",
                                      style: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenwidth * 0.03,
                                          color: HexColor('#212121')),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Measure over all steps",
                                  style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.w300,
                                      fontSize: screenwidth * 0.032,
                                      color: HexColor('#212121')),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Container(
                      height: screenwidth * 0.06,
                      width: screenwidth,
                    ),
                    Container(
                        height: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenwidth * 0.24,
                              height: 126,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: HexColor("#000000"), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#DAFFD1'),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: HexColor('#A5FF8F'),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(steps,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.contain,
                                              semanticsLabel: 'Steps count'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gethealth == null
                                              ? "0 "
                                              : distancetravelled
                                                  .toString()
                                                  .substring(0, 3),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: screenwidth * 0.04,
                                              color: HexColor('#212121')),
                                        ),
                                        Text(
                                          // (stepcount == null) ? "0" : stepcount,
                                          "km",
                                          style: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenwidth * 0.03,
                                              color: HexColor('#212121')),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Distance",
                                      style: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w300,
                                          fontSize: screenwidth * 0.032,
                                          color: HexColor('#212121')),
                                    )
                                  ]),
                            ),
                            Container(
                              width: screenwidth * 0.24,
                              height: 126,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: HexColor("#000000"), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#FFD0D7'),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: HexColor('#FF8FA0'),
                                      ),
                                      child: SvgPicture.asset(heart,
                                          width: 28,
                                          height: 28,
                                          fit: BoxFit.contain,
                                          semanticsLabel: 'Heart rate'),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gethealth == null
                                              ? "0 "
                                              : gethealth["heartrate"]
                                                  .toString(),
                                          // "200 ",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: screenwidth * 0.04,
                                              color: HexColor('#212121')),
                                        ),
                                        Text(
                                          // (stepcount == null) ? "0" : stepcount,
                                          "Bpm",
                                          style: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenwidth * 0.03,
                                              color: HexColor('#212121')),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Heart rate ",
                                      style: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w300,
                                          fontSize: screenwidth * 0.032,
                                          color: HexColor('#212121')),
                                    )
                                  ]),
                            ),
                            Container(
                              width: screenwidth * 0.24,
                              height: 126,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: HexColor("#000000"), width: 1),
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor('#D1E0FF'),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: HexColor('#8FB4FF'),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(calories,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.contain,
                                              semanticsLabel: 'Calories burn'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          gethealth == null
                                              ? 0.toString()
                                              : Caloriesburned.toInt()
                                                  .toString(),
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: screenwidth * 0.04,
                                              color: HexColor('#212121')),
                                        ),
                                        Text(
                                          "Cal/hr",
                                          style: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenwidth * 0.03,
                                              color: HexColor('#212121')),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Calories burn",
                                      style: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w300,
                                          fontSize: screenwidth * 0.032,
                                          color: HexColor('#212121')),
                                    )
                                  ]),
                            ),
                          ],
                        )),
                    Container(
                      height: screenwidth * 0.06,
                      width: screenwidth,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Worker_location_page(
                            name: widget.name,
                            companyid: widget.companyid,
                            uuid: widget.uuid,
                          );
                        }));
                      },
                      child: Container(
                        height: 150,
                        width: screenwidth * 0.86,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:
                              Image.asset('assets/map.jpg', fit: BoxFit.cover),
                        ),
                      ),
                    )
                  ],
                ))));
  }

  @override
  deactivate() {
    healthdispose.cancel();
    super.deactivate;
  }
}
