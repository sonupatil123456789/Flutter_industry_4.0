import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Splashscreen/Loginscreen.dart';
import 'package:permission_handler/permission_handler.dart';

final String splash1 = 'assets/splash1.svg';
final String splash2 = 'assets/splash2.svg';
final String splash3 = 'assets/splash3.svg';
final String splash4 = 'assets/splash4.svg';
final String splash5 = 'assets/splash5.svg';

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  final controller = PageController(initialPage: 0);

  int pagedotno = 0;
  bool _isObscure = true;

  TextEditingController loginemailcontroller = TextEditingController();
  TextEditingController loginpassowrdcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Container(
              width: screenwidth,
              // color: Color.fromRGBO(118, 125, 216, 1),
              height: screenheight * 0.80,
              child: PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                    pagedotno = value;
                  });
                  print("page no is ${value + 1}");
                },
                children: [
                  Container(
                    child: Column(children: [
                      Container(
                        height: screenheight * 0.50,
                        width: screenwidth * 0.80,
                        child: SvgPicture.asset(splash3,
                            semanticsLabel: 'splashscreen'),
                      ),
                      SizedBox(
                        height: screenheight * 0.05,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Text(
                          "Worker Tracking",
                          style: GoogleFonts.poppins(
                              fontSize: screenwidth * 0.05,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 18, 30, 0),
                        child: Text(
                          "Track the location of thw worker near construction site to improve perfomance of the construction",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                              fontSize: screenwidth * 0.034,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        height: screenheight * 0.50,
                        width: screenwidth * 0.80,
                        child: SvgPicture.asset(splash5,
                            semanticsLabel: 'splashscreen'),
                      ),
                      SizedBox(
                        height: screenheight * 0.05,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Text(
                          "File Management",
                          style: GoogleFonts.poppins(
                              fontSize: screenwidth * 0.05,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 18, 30, 0),
                        child: Text(
                          "Manage all your fies and worker information in database records at one pace to reduce loss of papers  ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                              fontSize: screenwidth * 0.034,
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ]),
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        height: screenheight * 0.50,
                        width: screenwidth * 0.80,
                        child: SvgPicture.asset(splash1,
                            semanticsLabel: 'splashscreen'),
                      ),
                      SizedBox(
                        height: screenheight * 0.05,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Text(
                          "Inventary Management",
                          style: GoogleFonts.poppins(
                              fontSize: screenwidth * 0.05,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 18, 30, 0),
                        child: Text(
                          "Manage all your inventary by using only one hand 🖐️ and improve the efficieny of your construction site & productiviety at low cost ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                              fontSize: screenwidth * 0.034,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.08,
                      ),
                      Container(
                          width: 60,
                          height: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                                ),
                                primary: HexColor('#000000'),
                                onPrimary: HexColor('#FFFFFF'),
                              ),
                              onPressed: () async {
                                late Map<Permission, PermissionStatus> statuses;
                                Future getnativesensorpermission() async {
                                  statuses = await [
                                    Permission.location,
                                    Permission.sms,
                                    Permission.phone,
                                    Permission.storage,
                                    Permission.camera
                                  ].request();
                                  print("status is  $statuses");
                                }

                                await getnativesensorpermission();

                                if (await statuses[Permission.location]! ==
                                        PermissionStatus.denied ||
                                    statuses[Permission.sms]! ==
                                        PermissionStatus.denied ||
                                    statuses[Permission.phone]! ==
                                        PermissionStatus.denied ||
                                    statuses[Permission.storage]! ==
                                        PermissionStatus.denied ||
                                    statuses[Permission.camera]! ==
                                        PermissionStatus.denied) {
                                  openAppSettings();
                                  print("all permission is denied.");
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Loginpage()),
                                  );
                                }
                              },
                              child: Icon(Icons.chevron_right))),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   height: screenheight * 0.06,
          //   child: DotsIndicator(
          //     dotsCount: 4,
          //     // dotsCount: pageLength,
          //     position: pagedotno.toDouble(),
          //   ),
          // ),
        ],
      )),
    );
  }
}

Widget buildTextField(
    String labelText,
    String placeholder,
    bool isPasswordTextField,
    double width,
    TextEditingController controller,
    maxline) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
    child: Container(
      width: width,
      child: TextField(
          autocorrect: true,
          maxLines: maxline,
          controller: controller,
          onChanged: (value) {},
          decoration: InputDecoration(
            hintText: placeholder,
            labelText: labelText,
            labelStyle: TextStyle(
              color: HexColor('#6C63FF'),
            ),
            hintStyle: TextStyle(color: HexColor("#636363")),
            filled: true,
            fillColor: HexColor('#FFFFFF'),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.black26, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: HexColor('#6C63FF'), width: 2),
            ),
          )),
    ),
  );
}
