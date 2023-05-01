import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Weathercard extends StatefulWidget {
  var info;
  dynamic apiinfo;
  var unit;
  IconData icon;
  Weathercard({
    super.key,
    required this.info,
    required this.apiinfo,
    required this.icon,
    required this.unit,
  });

  @override
  State<Weathercard> createState() => _WeathercardState();
}

class _WeathercardState extends State<Weathercard> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      width: screenwidth * 0.40,
      height: screenheight * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#EDF7FF"),
        // color: HexColor("#FCFEFF"),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: Colors.cyan,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: HexColor("#000000"),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 18,
                      color: HexColor("#FFFFFF"),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenheight * 0.08,
              // color: Color.fromARGB(255, 34, 207, 81),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.apiinfo.toInt().toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenwidth * 0.056,
                                  color: HexColor('#212121')),
                            ),
                            SizedBox(
                              width: screenwidth * 0.01,
                            ),
                            Text(
                              widget.unit.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenwidth * 0.040,
                                  color: HexColor('#212121')),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: screenheight * 0.008,
                    ),
                    Text(widget.info.toString(),
                        style: GoogleFonts.poppins(
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            fontSize: screenwidth * 0.040,
                            color: HexColor('#212121'))),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
