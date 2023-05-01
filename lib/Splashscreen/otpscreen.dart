import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Splashscreen/Resetpasswprd.dart';

final String splash4 = 'assets/splash4.svg';

class Otpscreen extends StatefulWidget {
  const Otpscreen({super.key});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  String baseurl = dotenv.env['BASEURL']!;

  late int userotp;

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenheight * 0.06,
                    ),
                    Container(
                      height: screenheight * 0.20,
                      width: screenwidth * 0.80,
                      child: SvgPicture.asset(splash4,
                          semanticsLabel: 'splashscreen'),
                    ),
                    SizedBox(
                      height: screenheight * 0.04,
                    ),
                    Text(
                      "Enter yours Otp send to your emailid",
                      style: GoogleFonts.poppins(
                          fontSize: screenwidth * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
////////////////////////
                    Container(
                      width: screenwidth * 0.80,
                      child: OtpTextField(
                        numberOfFields: 6,
                        borderColor: Color(0xFF512DA8),
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {
                          //handle validation or checks here
                        },
                        onSubmit: (verificationCode) {
                          userotp = int.parse(verificationCode);
                          print(userotp);
                        }, // end onSubmit
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: screenwidth * 0.80,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            primary: HexColor('#000000'),
                            onPrimary: HexColor('#FFFFFF'),
                          ),
                          onPressed: () async {
                            // /auth/verifyotp/:otp

                            var stringresponse;
                            dynamic mapresponse;

                            Future Verifyotp() async {
                              try {
                                print("function runnned verifyotp");
                                final response = await http.post(
                                  Uri.parse(
                                      'https://$baseurl/api/v1/auth/verifyotp/$userotp'),
                                );
                                if (response.statusCode == 200) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Resetpassword(
                                        companyuuid: mapresponse["otp"]
                                            ["userId"]);
                                  }));
                                  setState(() {
                                    stringresponse = response.body;
                                    mapresponse = jsonDecode(stringresponse);
                                    print(mapresponse["otp"]["userId"]);
                                  });
                                }
                                if (response.statusCode == 402) {
                                  stringresponse = response.body;
                                  mapresponse = jsonDecode(stringresponse);
                                  print(mapresponse["message"]);
                                  Fluttertoast.showToast(
                                      msg: "${mapresponse["message"]}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: HexColor('#A5FF8F'),
                                      textColor: HexColor('#000000'),
                                      fontSize: 16.0);
                                } else {
                                  return null;
                                }
                              } catch (e) {
                                print("$e");
                                await Fluttertoast.showToast(
                                    msg: '$e',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: HexColor('#A5FF8F'),
                                    textColor: HexColor('#000000'),
                                    fontSize: 16.0);
                              }
                            }

                            Verifyotp();
                          },
                          child: Text(
                            "Submit",
                            style: GoogleFonts.notoSans(
                                fontSize: screenwidth * 0.046,
                                fontWeight: FontWeight.w700),
                          ),
                        )),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      width: screenwidth * 0.80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Dont have acount ?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Text(
                              "Creat new account",
                              style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
        ),
      ),
    );
  }
}


// Widget build(BuildContext context) {
//     double screenheight = MediaQuery.of(context).size.height;
//     double screenwidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//               alignment: Alignment.center,
//               // color: Colors.green,
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: screenheight * 0.04,
//                     ),
//                     Text(
//                       "OTP",
//                       style: GoogleFonts.poppins(
//                           fontSize: screenwidth * 0.12,
//                           fontWeight: FontWeight.w800),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       height: screenheight * 0.20,
//                       width: screenwidth * 0.80,
                      // child: OtpTextField(
                      //   numberOfFields: 6,
                      //   borderColor: Color(0xFF512DA8),
                      //   showFieldAsBox: true,
                      //   onCodeChanged: (String code) {
                      //     //handle validation or checks here
                      //   },
                      //   onSubmit: (String verificationCode) {
                      //     showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             title: Text("Verification Code"),
                      //             content:
                      //                 Text('Code entered is $verificationCode'),
                      //           );
                      //         });
                      //   }, // end onSubmit
                      // ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                         width: screenwidth * 0.80,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(10.0),
//                             ),
//                             primary: HexColor('#000000'),
//                             onPrimary: HexColor('#FFFFFF'),
//                           ),
//                           onPressed: () {},
//                           child: Text(
//                             "Verify Otp",
//                             style: GoogleFonts.notoSans(
//                                 fontSize: screenwidth * 0.046,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         )),
//                     SizedBox(
//                       height: 28,
//                     ),
//                     Container(
//                       width: screenwidth * 0.80,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Dont have acount ?",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               // Navigator.push(context,
//                               //     MaterialPageRoute(builder: (context) {
//                               //   return const Signup();
//                               // }));
//                             },
//                             child: Text(
//                               "Creat new account",
//                               style: TextStyle(
//                                   color: Colors.deepPurpleAccent,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ])),
//         ),
//       ),
//     );
//   }