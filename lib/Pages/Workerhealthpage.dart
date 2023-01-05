import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  // var companyid;

  // final database = FirebaseDatabase.instance.ref("workerhealth");

  // Future getcompanyid() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   companyid = prefs.getString('companyid');
  // }

  final database = FirebaseDatabase.instance.ref("companys");

  late StreamSubscription heartratedispose;
  late StreamSubscription timeworkeddispose;
  late StreamSubscription stepcountdispose;
  late StreamSubscription dayworkeddispose;

  var getheartratevar;
  var heartrate;
  var getstepcountvar;
  var stepcount;
  var timeworkeddata;
  var timeworked;
  var dayworkeddata;
  var dayworked;

  void getheartrate() {
    heartratedispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/heartrate')
        .onValue
        .listen((DatabaseEvent event) {
      getheartratevar = event.snapshot.value;
      setState(() {
        heartrate = "$getheartratevar";
      });
      print(heartrate);
    });
  }

  void getstepcount() {
    stepcountdispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/stepcount')
        .onValue
        .listen((DatabaseEvent event) {
      getstepcountvar = event.snapshot.value;
      setState(() {
        stepcount = "$getstepcountvar";
      });
      print(stepcount);
    });
  }

  void gettimeworked() {
    timeworkeddispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/timeworked')
        .onValue
        .listen((DatabaseEvent event) {
      timeworkeddata = event.snapshot.value;
      setState(() {
        timeworked = "$timeworkeddata";
      });
      print(timeworked);
    });
  }

  void getdayworked() {
    dayworkeddispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/duty')
        .onValue
        .listen((DatabaseEvent event) {
      dayworkeddata = event.snapshot.value;
      setState(() {
        dayworked = "$dayworkeddata";
      });
      print(dayworked);
    });
  }

  @override
  initState() {
    getheartrate();
    getstepcount();
    gettimeworked();
    getdayworked();
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
                    const Back_btn_navbar(navname: "Health information"),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: screenwidth,
                      height: 140,
                      decoration: BoxDecoration(
                          // color: Colors.blue,
                          // border: Border.all(),
                          // borderRadius: BorderRadius.circular(0.0),
                          ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenwidth * 0.08,
                          ),
                          Container(
                            width: screenwidth * 0.18,
                            height: screenwidth * 0.27,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: widget.profilepic == null
                                  ? Image.asset('assets/profile.jpg',
                                      fit: BoxFit.cover)
                                  : Image.network(widget.profilepic,
                                      fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: screenwidth * 0.03,
                          ),
                          Container(
                            // color: Color.fromARGB(255, 243, 163, 33),
                            width: screenwidth * 0.71,
                            height: screenwidth * 0.26,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 5, right: 0),
                                  child: Text(widget.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenwidth * 0.054,
                                          color: HexColor('#000000'))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 4, right: 0),
                                  child: Text(widget.uuid,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: screenwidth * 0.032,
                                          color: HexColor('#000000'))),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 15, right: 0),
                                    child: Container(
                                      width: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          //   IconButton(
                                          //   onPressed: (() {}),
                                          //   tooltip: (accident == true
                                          //       ? "There is a incident happened"
                                          //       : (helmetvalue == true
                                          //           ? "Worker is not wearing helmet"
                                          //           : "Worker is working fine")),
                                          //   icon: Icon(
                                          //     Icons.error,
                                          //     size: 30,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                    (dayworked.toString() == "false"
                                        ? Icons.hourglass_full
                                        : Icons.hourglass_bottom),
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
                                        (timeworked.toString() == ""
                                            ? "00:00:00"
                                            : timeworked.toString()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            color: HexColor('#000000'))),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "Working ${(dayworked.toString() == "false" ? "full day" : "half day")} with ${(timeworked.toString() == "" ? "00:00:00" : timeworked.toString())} time ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: HexColor('#000000'))),
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
                                    Text(
                                      (stepcount == null) ? "0" : stepcount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: HexColor('#212121')),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Steps count",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(heart,
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.contain,
                                              semanticsLabel: 'Heart rate'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      (heartrate == null) ? "0" : heartrate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: HexColor('#212121')),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Heart rate ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
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
                                    Text(
                                      "290",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: HexColor('#212121')),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Calories burn",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14,
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
    heartratedispose.cancel();
    stepcountdispose.cancel();
    stepcountdispose.cancel();
    dayworkeddispose.cancel();
    super.deactivate;
  }
}
