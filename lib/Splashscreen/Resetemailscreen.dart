import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracker/Splashscreen/otpscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String splash4 = 'assets/splash4.svg';
TextEditingController emailcontroller = TextEditingController();

class Resetemailscreen extends StatefulWidget {
  const Resetemailscreen({super.key});

  @override
  State<Resetemailscreen> createState() => _ResetemailscreenState();
}

class _ResetemailscreenState extends State<Resetemailscreen> {
  var rng;
  var code;

  var serviceid = "service_zf2ezeq";
  var tampletid = 'template_ugh9iy9';
  var userid = "uq7nZnZud5UA5IsVf";
  dynamic message;
  dynamic to_email;
  dynamic to_name;
  dynamic from_number;
  dynamic from_email = "deshmukhomkar60@gmail.com";
  dynamic from_name = "Industry 4.0 team";
  dynamic user_subject = "Reciving reset password otp";
  late String stringresponseemail;

  Future sendresetpasswordotp(
      to_email, to_name, from_email, from_name, subject, message) async {
    try {
      final response = await http.post(
          Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "service_id": serviceid,
            "template_id": tampletid,
            "user_id": userid,
            "template_params": {
              "to_email": to_email,
              "from_email": from_email,
              "to_name": to_name,
              "from_name": from_name,
              "user_subject": subject,
              "message": message,
            }
          }));
      print("${response.body}");
      if (response.statusCode == 200) {
        await Fluttertoast.showToast(
            msg: 'Otp send to your email',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);
        setState(() {
          stringresponseemail = response.body;
          print("$stringresponseemail");
        });
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: HexColor('#A5FF8F'),
          textColor: HexColor('#000000'),
          fontSize: 16.0);
      print(e);
    }
  }

  var stringresponse;
  dynamic mapresponse;

  String baseurl = dotenv.env['BASEURL']!;
  Future getallcontracters(email) async {
    try {
      final response = await http.get(Uri.parse(
          'https://$baseurl/api/v1/auth/getallcontracters/${email.toString()}'));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
        to_name = mapresponse["contracter"]["contractername"];
        to_email = mapresponse["contracter"]["email"];
        rng = new Random();
        code = rng.nextInt(900000) + 100000;
        message =
            "Dear $to_name your OTP code for your id ${mapresponse["contracter"]["uuid"]} is <b>$code </b> ";
        await sendresetpasswordotp(
            to_email, to_name, from_email, from_name, user_subject, message);
        await Addotp(mapresponse["contracter"]["uuid"], code, "Token data");
      }

      if (response.statusCode == 400) {
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
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: HexColor('#A5FF8F'),
          textColor: HexColor('#000000'),
          fontSize: 16.0);
      print('$e');
    }
  }

  Future Addotp(companyuuid, otp, token) async {
    print(companyuuid);
    try {
      final response = await http.post(
          Uri.parse('https://$baseurl/api/v1/auth/sendotp/$companyuuid'),
          headers: <String, String>{
            'Content-Type': 'application/json ',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "userId": companyuuid,
            "otp": otp,
            "token": token,
          }));
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otpscreen();
        }));
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
      } else {
        return null;
      }
    } catch (e) {
      print("$e");
    }
  }

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
                      "Enter yours reset password email",
                      style: GoogleFonts.poppins(
                          fontSize: screenwidth * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildTextField("Email", 'Enter your email', false,
                        screenwidth * 0.80, emailcontroller, 1),
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
                            await getallcontracters(emailcontroller.text);
                            emailcontroller.text = "";
                          },
                          child: Text(
                            "Send",
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
      child: TextFormField(
          autocorrect: true,
          maxLines: maxline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email field should not be empty ';
            } else {
              return null;
            }
          },
          controller: controller,
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: HexColor("#000000"),
            ),
            hintText: placeholder,
            labelText: labelText,
            labelStyle: TextStyle(
              color: HexColor('#000000'),
            ),
            hintStyle: TextStyle(color: HexColor("#000000")),
            filled: true,
            fillColor: HexColor('#FFFFFF'),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: HexColor("#AEAEAE"), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: HexColor('#000000'), width: 2),
            ),
          )),
    ),
  );
}
