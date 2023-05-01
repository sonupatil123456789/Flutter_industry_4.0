import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Pages/Inventary.dart';
import 'package:location_tracker/formspages/Addinventary.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Backbtnnavbar.dart';

dynamic inventrypercentage = 0.0;

class Inventarylist extends StatefulWidget {
  const Inventarylist({super.key});

  @override
  State<Inventarylist> createState() => _InventarylistState();
}

class _InventarylistState extends State<Inventarylist> {
  String baseurl = dotenv.env['BASEURL']!;
  var companyid;

  Future Getcompanyid() async {
    final prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('companyid');
    setState(() {});
  }

  @override
  initState() {
    Getcompanyid();
    super.initState;
  }

  final String profilepicworker = 'assets/profile.jpg';
  final database = FirebaseDatabase.instance.ref("companys");

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: (companyid == null
          ? Center(
              child: CircularProgressIndicator(
              color: HexColor("#6C63FF"),
              strokeWidth: 6,
            ))
          : Container(
              width: screenwidth,
              height: screenheight,
              color: HexColor("#FFFFFF"),
              child: Column(children: [
                Back_btn_navbar(navname: "Inventary management"),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FirebaseAnimatedList(
                      query: database.child(companyid).child("inventary"),
                      duration: Duration(seconds: 3),
                      defaultChild: Center(
                          child: CircularProgressIndicator(
                        color: HexColor("#6C63FF"),
                        strokeWidth: 6,
                      )),
                      itemBuilder: ((context, snapshot, animation, index) {
                        dynamic? weight = snapshot.child('weight').value;
                        dynamic? totalweight =
                            snapshot.child('totalweight').value;
                        inventrypercentage = weight / totalweight * 100;

                        return Slidable(
                            // startActionPane: ActionPane(
                            //   motion: const ScrollMotion(),
                            //   extentRatio: 0.25,
                            //   children: [
                            //     SlidableAction(
                            //       onPressed: (buildctx) {},
                            //       backgroundColor: HexColor('#A5FF8F'),
                            //       foregroundColor: HexColor('#000000'),
                            //       icon: (snapshot
                            //                   .child('duty')
                            //                   .value
                            //                   .toString() ==
                            //               "false"
                            //           ? Icons.hourglass_full
                            //           : Icons.hourglass_bottom),
                            //       label: (snapshot
                            //                   .child('duty')
                            //                   .value
                            //                   .toString() ==
                            //               "false"
                            //           ? "Full Day"
                            //           : "Half Day"),
                            //     ),
                            //   ],
                            // ),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (buildctx) {
                                    var datadeleted = database
                                        .child(companyid)
                                        .child("inventary")
                                        .child(
                                            '/${snapshot.child('id').value.toString()}')
                                        .remove()
                                        .then((value) => Fluttertoast.showToast(
                                            msg:
                                                '${snapshot.child('name').value.toString()} deleted successfully',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 5,
                                            backgroundColor:
                                                HexColor('#A5FF8F'),
                                            textColor: HexColor('#000000'),
                                            fontSize: 16.0))
                                        .catchError((error) => {
                                              Fluttertoast.showToast(
                                                  msg: '$error',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor:
                                                      HexColor('#A5FF8F'),
                                                  textColor:
                                                      HexColor('#000000'),
                                                  fontSize: 16.0)
                                            });
                                  },
                                  backgroundColor: HexColor("#FFD0D7"),
                                  foregroundColor: HexColor('#000000'),
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Inventary(
                                    uuid: snapshot.child('id').value.toString(),
                                    name:
                                        snapshot.child('name').value.toString(),
                                    companyid: companyid,
                                  );
                                }));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: Container(
                                      width: screenwidth,
                                      height: 150,
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
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        width:
                                                            screenwidth * 0.30,
                                                        // color: Colors.amber,
                                                        height: 140,
                                                        child:
                                                            CircularPercentIndicator(
                                                          animation: true,
                                                          animationDuration:
                                                              2000,
                                                          radius: 44.0,
                                                          lineWidth: 12.0,
                                                          percent: inventrypercentage
                                                                      .isNaN ||
                                                                  inventrypercentage
                                                                      .isInfinite ||
                                                                  inventrypercentage ==
                                                                      null
                                                              ? 0.0
                                                              : inventrypercentage /
                                                                  100,
                                                          center: Text(
                                                            "${inventrypercentage.isNaN || inventrypercentage.isInfinite || inventrypercentage == null ? 0.0 : inventrypercentage.toInt()} %",
                                                            style: GoogleFonts.notoSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    screenwidth *
                                                                        0.030,
                                                                color: HexColor(
                                                                    '#212121')),
                                                          ),
                                                          progressColor:
                                                              HexColor(
                                                                  "#6C63FF"),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenwidth * 0.03,
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: screenwidth * 0.66,
                                                      height:
                                                          screenheight * 0.12,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .child('name')
                                                                  .value
                                                                  .toString(),
                                                              style: GoogleFonts.notoSans(
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
                                                              snapshot
                                                                  .child('id')
                                                                  .value
                                                                  .toString(),
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
                                                            SizedBox(
                                                              height: 14,
                                                            ),
                                                            Container(
                                                              // color: Colors
                                                              //     .orangeAccent,
                                                              width:
                                                                  screenwidth *
                                                                      0.55,
                                                              height:
                                                                  screenheight *
                                                                      0.045,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      width: screenwidth *
                                                                          0.10,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: HexColor(
                                                                            "#EAF6F8"), //CFEAEE EAF6F8
                                                                      ),
                                                                      // color: HexColor('#B064B0'), //F5F3F5
                                                                      child:
                                                                          IconButton(
                                                                        tooltip: snapshot
                                                                            .child('partnerbrandemail')
                                                                            .value
                                                                            .toString(),
                                                                        iconSize:
                                                                            20,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .mark_email_unread,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            final Uri
                                                                                emailLaunchUri =
                                                                                await Uri(
                                                                              scheme: 'mailto',
                                                                              path: snapshot.child('partnerbrandemail').value.toString(),
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
                                                                      width: screenwidth *
                                                                          0.10,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: HexColor(
                                                                            "#EAF6F8"), //CFEAEE EAF6F8
                                                                      ),
                                                                      child:
                                                                          IconButton(
                                                                        tooltip: snapshot
                                                                            .child('partnercompanynumber')
                                                                            .value
                                                                            .toString(),
                                                                        iconSize:
                                                                            20,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .phone_in_talk,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            final Uri
                                                                                numberlauncher =
                                                                                await Uri(
                                                                              scheme: 'tel',
                                                                              path: snapshot.child('partnercompanynumber').value.toString(),
                                                                            );

                                                                            await launchUrl(numberlauncher);
                                                                          } catch (e) {
                                                                            print("error  : $e");
                                                                          }
                                                                        },
                                                                      )),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Container(
                                                                      width: screenwidth *
                                                                          0.10,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: HexColor(
                                                                            "#EAF6F8"), //CFEAEE   EAF6F8
                                                                      ),
                                                                      child:
                                                                          IconButton(
                                                                        tooltip: snapshot
                                                                            .child('partnercompanynumber')
                                                                            .value
                                                                            .toString(),
                                                                        iconSize:
                                                                            20,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .sms,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            final Uri
                                                                                smslauncher =
                                                                                await Uri(
                                                                              scheme: 'sms',
                                                                              path: snapshot.child('partnercompanynumber').value.toString(),
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
                                                                      width: screenwidth *
                                                                          0.10,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: HexColor(
                                                                            "#EAF6F8"), //CFEAEE EAF6F8
                                                                      ),
                                                                      child:
                                                                          IconButton(
                                                                        tooltip: snapshot
                                                                            .child('partnerbrandname')
                                                                            .value
                                                                            .toString(),
                                                                        iconSize:
                                                                            20,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .factory,
                                                                        ),
                                                                        onPressed:
                                                                            () {},
                                                                      ))
                                                                ],
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      })),
                ),
                Container(
                    width: screenwidth * 0.80,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: HexColor('#000000'),
                        onPrimary: HexColor('#FFFFFF'),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Addinventary();
                        }));
                      },
                      child: Text(
                        "Add New Inventary",
                        style: TextStyle(
                            // fontSize: 17,
                            letterSpacing: 1,
                            fontSize: screenwidth * 0.044,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                SizedBox(
                  height: screenheight * 0.02,
                ),
              ]))),
    ));
  }
}



