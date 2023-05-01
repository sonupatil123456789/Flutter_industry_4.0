import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:location_tracker/Pages/Workerinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../formspages/Updateworkerform.dart';
import 'Backbtnnavbar.dart';

class Allworkerlist2 extends StatefulWidget {
  const Allworkerlist2({super.key});

  @override
  State<Allworkerlist2> createState() => _Allworkerlist2State();
}

class _Allworkerlist2State extends State<Allworkerlist2> {
  var stringresponse;
  dynamic mapresponse;
  List mapresponsedata = [];

  String baseurl = dotenv.env['BASEURL']!;

  @override
  initState() {
    Getallworkersdetails();
    super.initState;
  }

  Future Getallworkersdetails() async {
    var companyid;
    final prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('companyid');
    try {
      final response = await http.get(Uri.parse(
          'https://$baseurl/api/v1/contracteraccountworkers/$companyid'));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          mapresponsedata = mapresponse["worker"];
          print(mapresponsedata);
        });
      }
      if (response.statusCode == 400) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          mapresponsedata = mapresponse["message"];
        });
        Fluttertoast.showToast(
            msg: "${mapresponse["message"]}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);
      }
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

  final database = FirebaseDatabase.instance.ref("companys");

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
          child: Column(children: [
            Back_btn_navbar(navname: "All worker details"),
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Getallworkersdetails();
                          // setState(() {});
                        },
                        child: ListView.builder(
                            itemCount: mapresponsedata.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                child: Column(children: [
                                  Slidable(
                                    // key: ValueKey(index),
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      extentRatio: 0.25,
                                      children: [
                                        SlidableAction(
                                          onPressed: (buildctx) async {
                                            Future Deletworkerdata() async {
                                              try {
                                                final response =
                                                    await http.delete(
                                                  Uri.parse(
                                                      'https://$baseurl/api/v1/worker/${mapresponsedata[index]["_id"]}'),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json; charset=UTF-8',
                                                  },
                                                );
                                                print(response.body);

                                                if (response.statusCode ==
                                                    200) {
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

                                            Deletworkerdata();
                                            var datadeleted = database
                                                .child(mapresponsedata[index]
                                                    ["companyid"])
                                                .child("siteworkerhealth")
                                                .child(
                                                    '/${mapresponsedata[index]["_id"]}')
                                                .remove()
                                                .then((value) => print(
                                                    '${mapresponsedata[index]["_id"]}deleted successfully'));

                                            await Fluttertoast.showToast(
                                                msg:
                                                    "Worker deleted from database successfully",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor:
                                                    HexColor('#A5FF8F'),
                                                textColor: HexColor('#000000'),
                                                fontSize: 16.0);
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
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Updateworkerform(
                                                uuid: mapresponsedata[index]
                                                    ["_id"],
                                                workernameparams:
                                                    mapresponsedata[index]
                                                        ["workername"],
                                                workeremailparams:
                                                    mapresponsedata[index]
                                                        ["workeremail"],
                                                workernumberparams:
                                                    mapresponsedata[index]
                                                        ["workernumber"],
                                                imagesparams:
                                                    mapresponsedata[index]
                                                        ["images"],
                                                birthdateparams:
                                                    mapresponsedata[index]
                                                        ["birthdate"],
                                                addressparams:
                                                    mapresponsedata[index]
                                                        ["address"],
                                                adharnumberparams:
                                                    mapresponsedata[index]
                                                        ["adharnumber"],
                                                ageparams: mapresponsedata[
                                                            index]
                                                        ["medicalinformation"]
                                                    ["age"],
                                                genderparams: mapresponsedata[
                                                            index]
                                                        ["medicalinformation"]
                                                    ["gender"],
                                                heightparams: mapresponsedata[
                                                            index]
                                                        ["medicalinformation"]
                                                    ["height"],
                                                weightparams: mapresponsedata[
                                                            index]
                                                        ["medicalinformation"]
                                                    ["weight"],
                                                bloodgroupparams:
                                                    mapresponsedata[index][
                                                            "medicalinformation"]
                                                        ["bloodgroup"],
                                                companyid:
                                                    mapresponsedata[index]
                                                        ["companyid"],
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
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Worker_info(
                                              uuid: mapresponsedata[index]
                                                  ["_id"]);
                                        }));
                                      },
                                      child: Container(
                                        width: screenwidth,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          // color: Colors.amberAccent,
                                          // color: HexColor('#EDF7FF'),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenwidth * 0.10,
                                              ),
                                              Container(
                                                width: 42.0,
                                                height: 42.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: (mapresponsedata[index]
                                                              ["images"] ==
                                                          "null"
                                                      ? Image.asset(
                                                          'assets/profile.jpeg',
                                                          fit: BoxFit.cover)
                                                      : Image.network(
                                                          mapresponsedata[index]
                                                              ["images"],
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
                                                      mapresponsedata[index]
                                                          ["workername"],
                                                      style:
                                                          GoogleFonts.notoSans(
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
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      mapresponsedata[index]
                                                          ["_id"],
                                                      style:
                                                          GoogleFonts.notoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize:
                                                                  screenwidth *
                                                                      0.030,
                                                              color: HexColor(
                                                                  '#212121')),
                                                    )
                                                  ]),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            })),
                      ),
                    ),
            ),
          ])),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}











    // var Contractername = await prefs.getString('Contractername');
    // var Contracteremail = await prefs.getString('Contracteremail');
    // var Contractermobileno = await prefs.getString('Contractermobileno');
    // print("$Contractername===$Contracteremail==$Contractermobileno");