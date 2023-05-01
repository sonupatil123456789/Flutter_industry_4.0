import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Pages/Homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Back_btn_navbar extends StatelessWidget {
  final String navname;

  Back_btn_navbar({
    Key? key,
    required this.navname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      height: 66.0,
      width: screenwidth,
      // color: HexColor('EDF7FF'),
      color: HexColor('FFFFFF'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return Homepage();
              }));
            },
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 24,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            navname,
            style: GoogleFonts.notoSans(
                color: HexColor('#212121'),
                fontSize: screenwidth * 0.052,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
