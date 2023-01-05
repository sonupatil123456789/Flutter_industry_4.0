import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/Workerhealthpage.dart';
import '../formspages/Updateworkerform.dart';

class Listcaerd extends StatefulWidget {
  const Listcaerd({
    super.key,
  });

  @override
  State<Listcaerd> createState() => _ListcaerdState();
}

class _ListcaerdState extends State<Listcaerd> {
  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  String baseurl = dotenv.env['BASEURL']!;
  var companyid;

  Future Getallworkersdetails() async {
    final prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('companyid');
  }

  Object? getstepcountvar;
  Object? isgetaccident;
  var accident;

  @override
  initState() {
    super.initState;
  }

  final String profilepicworker = 'assets/profile.jpg';
  final database = FirebaseDatabase.instance.ref("companys");

  @override
  Widget build(BuildContext context) {
    Getallworkersdetails();
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return FirebaseAnimatedList(
        query: database.child(companyid.toString()).child("siteworkerhealth"),
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
                          .child('/${snapshot.child('id').value.toString()}')
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Updateworkerform(
                          uuid: mapresponsedata[index]["_id"],
                          workernameparams: mapresponsedata[index]
                              ["workername"],
                          workeremailparams: mapresponsedata[index]
                              ["workeremail"],
                          workernumberparams: mapresponsedata[index]
                              ["workernumber"],
                          imagesparams: mapresponsedata[index]["images"],
                          birthdateparams: mapresponsedata[index]["birthdate"],
                          addressparams: mapresponsedata[index]["address"],
                          adharnumberparams: mapresponsedata[index]
                              ["adharnumber"],
                          ageparams: mapresponsedata[index]
                              ["medicalinformation"]["age"],
                          genderparams: mapresponsedata[index]
                              ["medicalinformation"]["gender"],
                          heightparams: mapresponsedata[index]
                              ["medicalinformation"]["height"],
                          weightparams: mapresponsedata[index]
                              ["medicalinformation"]["weight"],
                          bloodgroupparams: mapresponsedata[index]
                              ["medicalinformation"]["bloodgroup"],
                          companyid: companyid,
                        );
                      }));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Worker_health_page(
                      uuid: snapshot.child('id').value.toString(),
                      name: snapshot.child('name').value.toString(),
                      profilepic: snapshot.child('imagepic').value.toString(),
                      companyid: companyid,
                    );
                  }));
                },
                child: Container(
                  width: screenwidth,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        (snapshot.child('accident').value.toString() == "true"
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
                                    snapshot.child('imagepic').value.toString(),
                                    fit: BoxFit.cover)),
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
                                snapshot.child('name').value.toString(),
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
        }));
  }
}


  //  snapshot
  //                               .child("name")
  //                               .value
  //                               .toString()
