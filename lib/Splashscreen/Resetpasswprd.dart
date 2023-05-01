import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Splashscreen/Loginscreen.dart';

final String splash4 = 'assets/splash4.svg';
bool _isObscure = true;
TextEditingController Passwordcontroller = TextEditingController();
TextEditingController Cpasswordcontroller = TextEditingController();

class Resetpassword extends StatefulWidget {
  var companyuuid;
  Resetpassword({super.key, this.companyuuid});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final formkey = GlobalKey<FormState>();

  late String confirmpasswordfield;
  late String Passwordfield;

  var stringresponseupdate;
  dynamic mapresponse;
  String baseurl = dotenv.env['BASEURL']!;

  Future Resetpassword() async {
    try {
      final response = await http.put(
          Uri.parse(
              'https://$baseurl/api/v1/auth/updatepassword/${widget.companyuuid.toString()}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "password": confirmpasswordfield,
          }));
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          stringresponseupdate = response.body;
          mapresponse = jsonDecode(stringresponseupdate);
          print(mapresponse);
        });
        await Fluttertoast.showToast(
            msg: "${mapresponse["message"].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Loginpage();
        }));
      } else {
        return null;
      }
    } catch (e) {
      // Fluttertoast.showToast(
      //     msg: "$e",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 5,
      //     backgroundColor: HexColor('#A5FF8F'),
      //     textColor: HexColor('#000000'),
      //     fontSize: 16.0);
      print(e);
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
              child: Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        "Enter yours new password",
                        style: GoogleFonts.poppins(
                            fontSize: screenwidth * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTextField("Password", 'Enter your new password',
                          false, screenwidth * 0.80, Passwordcontroller, 1),
                      Container(
                        width: screenwidth * 0.80,
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'password field should not be empty';
                              }
                              if (value != null && value.length < 8) {
                                return 'enter minimum 10 char ';
                              } else {
                                return null;
                              }
                            },
                            obscureText: _isObscure,
                            controller: Cpasswordcontroller,
                            decoration: InputDecoration(
                              hintText: 'Confirm your password again',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: HexColor("#000000"),
                              ),
                              suffixIcon: IconButton(
                                color: HexColor("#000000"),
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              labelText: 'Confirm password',
                              labelStyle: TextStyle(
                                color: HexColor("#000000"),
                              ),
                              hintStyle: TextStyle(color: HexColor("#000000")),
                              filled: true,
                              fillColor: HexColor('#FFFFFF'),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: HexColor("#AEAEAE"), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: HexColor("#000000"), width: 2),
                              ),
                            )),
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
                              Passwordfield =
                                  Passwordcontroller.text.toString();
                              confirmpasswordfield =
                                  Cpasswordcontroller.text.toString();

                              if (Passwordfield == confirmpasswordfield) {
                                await Resetpassword();
                                await Fluttertoast.showToast(
                                    msg: "Password updated successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: HexColor('#A5FF8F'),
                                    textColor: HexColor('#000000'),
                                    fontSize: 16.0);
                              }
                              if (Passwordfield != confirmpasswordfield) {
                                Fluttertoast.showToast(
                                    msg: "Password not matching",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: HexColor('#A5FF8F'),
                                    textColor: HexColor('#000000'),
                                    fontSize: 16.0);
                              }
                            },
                            child: Text(
                              "Change password",
                              style: GoogleFonts.notoSans(
                                  fontSize: screenwidth * 0.046,
                                  fontWeight: FontWeight.w700),
                            ),
                          )),
                      SizedBox(
                        height: 28,
                      ),
                    ]),
              )),
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
              return 'password field should not be empty';
            }
            if (value != null && value.length < 8) {
              return 'enter minimum 10 char ';
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
