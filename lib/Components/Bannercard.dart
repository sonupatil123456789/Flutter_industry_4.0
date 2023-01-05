import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
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
                  center: new Text("60%"),
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
                          Text(
                            "`Track worker",
                            style: TextStyle(
                              // color: HexColor(""),
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                              // fontSize: screenwidth <= 400
                              //     ? screenwidth * 0.00
                              //     : screenwidth * 0.064,
                            ),
                          ),
                          Text(
                            " location",
                            style: TextStyle(
                              // color: HexColor(""),
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                              // fontSize: screenwidth <= 400
                              //     ? screenwidth * 0.00
                              //     : screenwidth * 0.064,
                            ),
                          ),
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
                          style: TextStyle(
                              // fontSize: 17,
                              fontSize: screenwidth * 0.040,
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
