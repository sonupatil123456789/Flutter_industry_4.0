import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Allworkerlist.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Banner_cards extends StatefulWidget {
  const Banner_cards({Key? key}) : super(key: key);

  @override
  State<Banner_cards> createState() => _Banner_cardsState();
}

class _Banner_cardsState extends State<Banner_cards> {
  var stringresponse;
  dynamic mapresponse;
  dynamic mapresponsedata;

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
          mapresponsedata = mapresponse["workercount"];
          print("=============$mapresponsedata");
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

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      width: screenwidth * 0.86,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: HexColor("#EAF6F8"), //CFEAEE EAF6F8
      ),
      child: Row(children: [
        Container(
          width: 150,
          // color: Color.fromARGB(255, 7, 255, 48),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 180,
                // color: Colors.cyan,
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 2000,
                  radius: 60.0,
                  lineWidth: 12.0,
                  percent: 0.60,
                  center: new Text(
                    mapresponsedata == null
                        ? "0"
                        : mapresponse["workercount"].toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: HexColor('#212121')),
                  ),
                  progressColor: HexColor("#6C63FF"),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: 190,
            // color: Colors.amber,
            height: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Container(
                      width: screenwidth * 0.45,
                      height: 68,
                      // color: Colors.redAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("`Track worker",
                              style: GoogleFonts.poppins(
                                  color: HexColor('#212121'),
                                  fontSize: screenwidth * 0.054,
                                  fontWeight: FontWeight.bold)),
                          Text(" location",
                              style: GoogleFonts.poppins(
                                  color: HexColor('#212121'),
                                  fontSize: screenwidth * 0.054,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Container(
                      width: 140,
                      height: 38,
                      // color: Colors.deepPurpleAccent,
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
                            return Allworkerlist();
                          }));
                        },
                        child: Text(
                          'View More',
                          style: GoogleFonts.notoSans(
                              color: HexColor('#FFFFFF'),
                              fontSize: screenwidth * 0.032,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ]),
    );
  }
}
