import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              // color: Colors.green,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenheight * 0.04,
                    ),
                    Text(
                      "OTP",
                      style: GoogleFonts.poppins(
                          fontSize: screenwidth * 0.12,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: screenheight * 0.20,
                      width: screenwidth * 0.80,
                      child: OtpTextField(
                        numberOfFields: 5,
                        borderColor: Color(0xFF512DA8),
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {
                          //handle validation or checks here
                        },
                        onSubmit: (String verificationCode) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Verification Code"),
                                  content:
                                      Text('Code entered is $verificationCode'),
                                );
                              });
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
                          onPressed: () {},
                          child: Text(
                            "Verify Otp",
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
                            onTap: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return const Signup();
                              // }));
                            },
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
