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
  Allworkerlist({super.key});

  @override
  State<Allworkerlist> createState() => _AllworkerlistState();
}

class _AllworkerlistState extends State<Allworkerlist> {
  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  // var box = Hive.box('companydata');

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
              strokeWidth: 8,
            ))
          : Container(
              width: screenwidth,
              height: screenheight,
              color: HexColor("#FFFFFF"),
              child: Column(children: [
                const Back_btn_navbar(navname: "worker details"),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FirebaseAnimatedList(
                      query:
                          database.child(companyid).child("siteworkerhealth"),
                      duration: Duration(seconds: 3),
                      defaultChild: Center(
                          child: CircularProgressIndicator(
                        color: HexColor("#6C63FF"),
                        strokeWidth: 6,
                      )),
                      itemBuilder: ((context, snapshot, animation, index) {
                        var helmetvalue =
                            snapshot.child('hilmetdistance').value;
                        var accident = snapshot.child('accident').value;
                        return Slidable(
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  onPressed: (buildctx) {},
                                  backgroundColor: HexColor('#A5FF8F'),
                                  foregroundColor: HexColor('#000000'),
                                  icon: (snapshot
                                              .child('duty')
                                              .value
                                              .toString() ==
                                          "false"
                                      ? Icons.hourglass_full
                                      : Icons.hourglass_bottom),
                                  label: (snapshot
                                              .child('duty')
                                              .value
                                              .toString() ==
                                          "false"
                                      ? "Full Day"
                                      : "Half Day"),
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
                                    var datadeleted = database
                                        .child(companyid)
                                        .child("siteworkerhealth")
                                        .child(
                                            '/${snapshot.child('id').value.toString()}')
                                        .remove()
                                        .then((value) => print(
                                            '${snapshot.child('id').value.toString()}deleted successfully'));
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
                                print("hello user");
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Worker_health_page(
                                    uuid: snapshot.child('id').value.toString(),
                                    name:
                                        snapshot.child('name').value.toString(),
                                    profilepic: snapshot
                                        .child('imagepic')
                                        .value
                                        .toString(),
                                    companyid: companyid,
                                  );
                                }));
                              },
                              child: Container(
                                width: screenwidth,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //  <num>(t) => t == 50 ? 0 : null,
                                    color: (accident == true
                                        ? HexColor("#FFD0D7")
                                        : (helmetvalue == true
                                            ? HexColor('#FFFAD1')
                                            : HexColor("#FFFFFF")))),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: screenwidth * 0.10,
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: (snapshot
                                                      .child('imagepic')
                                                      .value
                                                      .toString() ==
                                                  "null"
                                              ? Image.asset(
                                                  'assets/profile.jpg',
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
                                        width: screenwidth * 0.05,
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
                                              height: 5,
                                            ),
                                            Text(
                                              snapshot
                                                  .child('id')
                                                  .value
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14,
                                                  color: HexColor('#212121')),
                                            )
                                          ]),
                                      SizedBox(
                                        width: screenwidth * 0.05,
                                      ),
                                      // Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.center,
                                      //   children: [
                                      //  IconButton(
                                      //     onPressed: (() {}),
                                      //     tooltip: (accident == true
                                      //         ? "There is a incident happened"
                                      //         : (helmetvalue == true
                                      //             ? "Worker is not wearing helmet"
                                      //             : "Worker is working fine")),
                                      //     icon: Icon(
                                      //       Icons.error,
                                      //       size: 30,
                                      //     ),
                                      //   ),
                                      //     SizedBox(
                                      //       height: 18,
                                      //     )
                                      //   ],
                                      // )
                                    ]),
                              ),
                            ));
                      })),
                ),
              ]))),
    ));
  }
}
