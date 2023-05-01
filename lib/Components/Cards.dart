import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:location_tracker/Components/Inventarylist.dart';
import 'package:location_tracker/Pages/Graphpage.dart';
import 'package:location_tracker/Pages/Inventary.dart';
import 'package:location_tracker/Pages/incidentpage.dart';
import 'package:location_tracker/Pages/weather.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

DateTime now = new DateTime.now();
DateTime date = DateTime(now.year, now.month, now.day);

int percentage = 14;

const cctv = 'assets/cctv.svg';
const noofdeath = 'assets/hospital.svg';
const inventary = 'assets/inventory.svg';
const graph = 'assets/bargraph.svg';

class Cards extends StatefulWidget {
  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  bool sendemailautomatic = true;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          // color: Color.fromRGBO(255, 193, 7, 1),
          width: 150,
          height: 400,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Graph_information();
                }));
              },
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: HexColor("#DCF9ED"),
                  color: HexColor("#CDEAF6"),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(graph,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Graph'),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Graph",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: HexColor('#212121')),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const Weather()));
              },
              child: Container(
                width: 150,
                height: 185,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: HexColor("#F6CDDD"),
                  color: HexColor("#F6F5CD"),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(cctv,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          semanticsLabel: 'servilance'),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Weather",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: HexColor('#212121')),
                      )
                    ]),
              ),
            ),
          ]),
        ),
/////////////////////////////////////////////////////////////////////////////////////
        Container(
          // color: Color.fromARGB(255, 147, 7, 255),
          width: 150,
          height: 400,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) => _Card1(
                //       context, screenwidth, screenheight, date, percentage),
                // );
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const Inventarylist()));
              },
              child: Container(
                width: 150,
                height: 185,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: HexColor("#CDEAF6"),
                  color: HexColor("#DCF9ED"),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 140,
                          height: 50,
                          alignment: Alignment.bottomRight,
                          child: Switch(
                            // This bool value toggles the switch.
                            value: sendemailautomatic,
                            activeColor: HexColor("#6C63FF"),
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                print(value);
                                sendemailautomatic = value;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset(inventary,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Inventary'),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Inventary",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: HexColor('#212121')),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Incidentpage();
                }));
              },
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: HexColor("#F6F5CD"),
                  color: HexColor("#F6CDDD"),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(noofdeath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          semanticsLabel: 'Deth'),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Incidents",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: HexColor('#212121')),
                      )
                    ]),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
