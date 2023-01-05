import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_tracker/Pages/Homepage.dart';
import 'package:location_tracker/Splashscreen/Forgotpassword.dart';
import 'package:location_tracker/Splashscreen/Signeuppage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String splash1 = 'assets/splash1.svg';
final String splash2 = 'assets/splash2.svg';
final String splash3 = 'assets/splash3.svg';
final String splash4 = 'assets/splash4.svg';
final String splash5 = 'assets/splash5.svg';

bool _isObscure = true;

TextEditingController loginemailcontroller = TextEditingController();
TextEditingController loginpassowrdcontroller = TextEditingController();
var emailfield;
var passwordfield;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var stringresponse;
  var mapresponse;

  String baseurl = dotenv.env['BASEURL']!;

  Future Logincontracter(email, password) async {
    print("func is clicked , $password  , $email");
    try {
      final response = await http.post(
          Uri.parse('http://$baseurl/api/v1/auth/login'),
          headers: <String, String>{
            'Content-Type': 'application/json ',
          },
          body: jsonEncode(
              <dynamic, dynamic>{"email": email, "password": password}));

      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
        final prefs = await SharedPreferences.getInstance();

        var introscreen = await prefs.setString('Onboardingscreen', "onboard");
        var setloginlogout =
            await prefs.setBool('Login', mapresponse["success"]);
        var companyid = await prefs.setString(
            'companyid', mapresponse["contracter"]["uuid"]);
        var Contractername = await prefs.setString('Contractername',
            mapresponse["contracter"]["contractername"].toString());
        var Contracterprofile = await prefs.setString('Contracterprofile',
            mapresponse["contracter"]["pofilePicture"].toString());
        var Contracteremail = await prefs.setString(
            'Contracteremail', mapresponse["contracter"]["email"]);
        var Contractermobileno = await prefs.setString('Contractermobileno',
            mapresponse["contracter"]["contactNumber"].toString());

        await Fluttertoast.showToast(
            msg: "contracter login successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Homepage();
        }));
      }
      if (response.statusCode == 402) {
        stringresponse = response.body;
        mapresponse = jsonDecode(stringresponse);
        return Fluttertoast.showToast(
            msg: "${mapresponse["message"]}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#F37373'),
            textColor: HexColor('#FFFFFF'),
            fontSize: 16.0);
        // print(mapresponse);
      }
      if (response.statusCode == 201) {
        stringresponse = response.body;
        mapresponse = jsonDecode(stringresponse);
        return Fluttertoast.showToast(
            msg: "${mapresponse["message"]}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#F37373'),
            textColor: HexColor('#FFFFFF'),
            fontSize: 16.0);
        //  print(mapresponse);
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  final formkey = GlobalKey<FormState>();

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
                        "Login",
                        style: GoogleFonts.poppins(
                            fontSize: screenwidth * 0.12,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTextField("Email", 'Enter your email', false,
                          screenwidth * 0.80, loginemailcontroller, 1),
                      Container(
                        width: screenwidth * 0.80,
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'password field should not be empty ';
                              }
                              if (value != null && value.length < 8) {
                                return 'enter minimum 10 char ';
                              } else {
                                return null;
                              }
                            },
                            obscureText: _isObscure,
                            controller: loginpassowrdcontroller,
                            decoration: InputDecoration(
                              hintText: 'Enter your password here',
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
                              labelText: 'Password',
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
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(screenwidth * 0.44, 0, 0, 0),
                        child: GestureDetector(
                          onTap: () async {
                            // Obtain shared prefere
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Forgotpassword();
                            }));
                          },
                          child: Text(
                            "Forgot password",
                            style: GoogleFonts.notoSans(
                                fontSize: screenwidth * 0.040,
                                color: HexColor("#000000"),
                                fontWeight: FontWeight.w700),
                          ),
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
                              emailfield = loginemailcontroller.text;
                              passwordfield = loginpassowrdcontroller.text;

                              await Logincontracter(emailfield, passwordfield);

                              var status = await Permission.camera.status;
                              if (status.isDenied) {
                                // We didn't ask for permission yet or the permission has been denied before but not permanently.
                                print("Permission is denined.");
                              } else if (status.isGranted) {
                                //permission is already granted.
                                print("Permission is already granted.");
                              } else if (status.isPermanentlyDenied) {
                                //permission is permanently denied.
                                openAppSettings();
                                print("Permission is permanently denied");
                              } else if (status.isRestricted) {
                                //permission is OS restricted.
                                print("Permission is OS restricted.");
                              }
                            },
                            child: Text(
                              "Log in",
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Signeuppage();
                                }));
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
              return 'password field should not be empty ';
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





        // print("$introscreen===$setloginlogout===$companyid");
        // print(
        //     "===${mapresponse["success"]}===${mapresponse["contracter"]["uuid"]}");


        
                              // Map<Permission, PermissionStatus> statuses =
                              //     await [
                              //   Permission.location,
                              //   Permission.sms,
                              //   Permission.phone,
                              //   Permission.storage,
                              //   Permission.camera
                              //   //add more permission to request here.
                              // ].request();

                              // if (statuses[Permission.location]!.isDenied) {
                              //   //check each permission status after.
                              //   print("Location permission is denied.");
                              // }

                              // if (statuses[Permission.camera]!.isDenied) {
                              //   //check each permission status after.
                              //   print("Camera permission is denied.");
                              // }