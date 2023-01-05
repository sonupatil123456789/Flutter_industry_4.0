import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Allworkerlist.dart';
import 'package:location_tracker/Components/Allworkerlist2.dart';
import 'package:location_tracker/formspages/Addworkerform.dart';
import 'package:location_tracker/formspages/Emargancyinfoform.dart';

class Bottom_bar extends StatefulWidget {
  const Bottom_bar({Key? key}) : super(key: key);

  @override
  State<Bottom_bar> createState() => _Bottom_barState();
}

class _Bottom_barState extends State<Bottom_bar> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      width: screenwidth,
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: HexColor("#FFFFFF"),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: (() {}),
              icon: Icon(Icons.home, size: 28, color: HexColor('#212121')),
            ),
            IconButton(
              onPressed: (() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Addworkerform();
                }));
              }),
              icon:
                  Icon(Icons.person_add, size: 28, color: HexColor('#212121')),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: (() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Allworkerlist2();
                }));
              }),
              icon: Icon(Icons.medical_information,
                  size: 28, color: HexColor('#212121')),
            ),
            IconButton(
              onPressed: (() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Emargancydetailform();
                }));
              }),
              icon: Icon(Icons.edit_calendar,
                  size: 28, color: HexColor('#212121')),
            ),
          ]),
    );
  }
}
