import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_tracker/Splashscreen/Loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String splash6 = 'assets/splash6.svg';

bool _isObscure = true;

TextEditingController signupemailcontroller = TextEditingController();
TextEditingController signuppassowrdcontroller = TextEditingController();
TextEditingController signupphonecontroller = TextEditingController();
TextEditingController signupname = TextEditingController();

class Signeuppage extends StatefulWidget {
  const Signeuppage({super.key});

  @override
  State<Signeuppage> createState() => _SigneuppageState();
}

class _SigneuppageState extends State<Signeuppage> {
  var contractername;
  var contracteremail;
  var contracterphoneno;
  var contracterpassword;
  var contracterimage;

  var defaultimage = "assets/profile.jpg";
  late File imagefile;
  var Imagepath;
  late String Imagename;
  var uploadpic;
  var imagedownloadedurl;
  var uploadingpicprocess;
  var contracterprofileimage;

  var storage = FirebaseStorage.instance.ref('Images/contracter');
  final ImagePicker _picker = ImagePicker();
  Future openImagegallery() async {
    try {
      var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          Imagepath = pickedFile.path;
          Imagename = DateTime.now().toString() + "_" + pickedFile.name;
          imagefile = File(Imagepath);
        });
        uploadpic = await storage.child("$Imagename").putFile(imagefile);
        TaskSnapshot uploadingpicprocess = await uploadpic;
        imagedownloadedurl = await uploadingpicprocess.ref.getDownloadURL();

        setState(() {
          contracterprofileimage = imagedownloadedurl;
          Imagepath = null;
        });

        print('$imagedownloadedurl');
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file $e");
    }
  }

  var stringresponse;
  var mapresponse;

  String baseurl = dotenv.env['BASEURL']!;

  Future Signeupcontracter(name, email, phoneno, password, profileimg) async {
    print("func is clicked , $password , $name , $phoneno , $email");
    try {
      final response =
          await http.post(Uri.parse('http://$baseurl/api/v1/auth/signup'),
              headers: <String, String>{
                'Content-Type': 'application/json ',
              },
              body: jsonEncode(<dynamic, dynamic>{
                "contractername": name,
                "email": email,
                "password": password,
                "contactNumber": phoneno,
                "pofilePicture": profileimg
              }));

      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
        await Fluttertoast.showToast(
            msg: "Signein successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: HexColor('#A5FF8F'),
            textColor: HexColor('#000000'),
            fontSize: 16.0);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Loginpage();
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
              // color: Colors.green,
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
                        child: SvgPicture.asset(splash6,
                            semanticsLabel: 'splashscreen'),
                      ),
                      SizedBox(
                        height: screenheight * 0.04,
                      ),
                      Container(
                        // color: Colors.amber,
                        width: screenwidth * 0.80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Signe up",
                              style: GoogleFonts.poppins(
                                  fontSize: screenwidth * 0.12,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              width: screenheight * 0.06,
                            ),
                            GestureDetector(
                              // onDoubleTap: () {},
                              onTap: () {
                                openImagegallery();
                              },
                              child: Container(
                                width: screenwidth * 0.10,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amberAccent,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (contracterprofileimage != null
                                        ? Image.network(contracterprofileimage,
                                            fit: BoxFit.cover)
                                        : Image.asset('assets/profile.jpg',
                                            fit: BoxFit.cover))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTextField("Name", 'Enter your name', false,
                          screenwidth * 0.80, signupname, 1),
                      buildTextField2("Email", 'Enter your email', false,
                          screenwidth * 0.80, signupemailcontroller, 1),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        width: screenwidth * 0.80,
                        child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'number field should not be empty ';
                              }
                              if (value != null && value.length < 10) {
                                return 'enter minimum 10 char ';
                              } else {
                                return null;
                              }
                            },
                            controller: signupphonecontroller,
                            decoration: InputDecoration(
                              hintText: 'Enter your password here',
                              prefixIcon: Icon(
                                Icons.call,
                                color: HexColor("#000000"),
                              ),
                              labelText: 'Phoneno',
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
                            controller: signuppassowrdcontroller,
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
                        height: 40,
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
                              contractername = signupname.text;
                              contracteremail = signupemailcontroller.text;
                              contracterphoneno = signupphonecontroller.text;
                              contracterpassword =
                                  signuppassowrdcontroller.text;
                              contracterimage = contracterprofileimage;

                              Signeupcontracter(
                                  contractername,
                                  contracteremail,
                                  contracterphoneno,
                                  contracterpassword,
                                  contracterimage);
                            },
                            child: Text(
                              "Sign up",
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
                              "Already have acount ?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Log in",
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

Widget buildTextField2(
    String labelText,
    String placeholder,
    bool isPasswordTextField,
    double width,
    TextEditingController controller,
    maxline) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
    child: Container(
      width: width,
      child: TextField(
          autocorrect: true,
          maxLines: maxline,
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
              return ' field should not be empty';
            } else {
              return null;
            }
          },
          controller: controller,
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.home_work,
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
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.black26, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: HexColor('#000000'), width: 2),
            ),
          )),
    ),
  );
}
