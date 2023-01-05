import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_tracker/Pages/Homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Backbtnnavbar.dart';
import 'package:http/http.dart' as http;

var women = 'assets/gender-female.svg';
var men = 'assets/gender-male.svg';

class Updateworkerform extends StatefulWidget {
  var uuid;
  var companyid;
  var workernameparams;
  var workeremailparams;
  var workernumberparams;
  var imagesparams;
  var birthdateparams;
  var addressparams;
  var adharnumberparams;
  var ageparams;
  var genderparams;
  var heightparams;
  var weightparams;
  var bloodgroupparams;
  Updateworkerform(
      {super.key,
      required this.uuid,
      required this.companyid,
      required this.workernameparams,
      required this.workeremailparams,
      required this.workernumberparams,
      required this.imagesparams,
      required this.birthdateparams,
      required this.addressparams,
      required this.adharnumberparams,
      required this.ageparams,
      required this.genderparams,
      required this.heightparams,
      required this.weightparams,
      required this.bloodgroupparams});

  @override
  State<Updateworkerform> createState() => _UpdateworkerformState();
}

class _UpdateworkerformState extends State<Updateworkerform> {
  var stringresponseupdate;

  DateTime selectedDate = DateTime.now();
  dynamic radiovalue;
  dynamic box1color;
  dynamic box2color;

  var workername;
  var workeremail;
  var workerno;
  var workerimage;
  var workerbirthdate;
  var workeradress;
  var workerage;
  var workergender;
  var workerweight;
  var workerheight;
  var workerbloodgroup;
  var workeradhar;

  final database = FirebaseDatabase.instance.ref("companys");

  late StreamSubscription<DatabaseEvent> namedispose;

  TextEditingController Namecontroller = TextEditingController();
  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Mobilenocontroller = TextEditingController();
  TextEditingController Adharcardcontroller = TextEditingController();
  TextEditingController Addresscontroller = TextEditingController();
  TextEditingController Agecontroller = TextEditingController();
  TextEditingController Heightcontroller = TextEditingController();
  TextEditingController Weightcontroller = TextEditingController();
  TextEditingController Bloodgroupcontroller = TextEditingController();

  var selectedbdDate;

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  var Imagepath;
  var defaultimage = "assets/profile.jpg";
  late File imagefile;
  late String Imagename;
  late TaskSnapshot uploadpic;
  var imagedownloadedurl;
  var workerprofileimage;

  var storage = FirebaseStorage.instance.ref('Images/Workerimages');
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
          workerprofileimage = imagedownloadedurl;
          // Imagepath = null;
        });

        print('$imagedownloadedurl');
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file $e");
    }
  }

  String baseurl = dotenv.env['BASEURL']!;

  Future Updateworkerdata(
      workername,
      workeremail,
      workernumber,
      images,
      birthdate,
      address,
      age,
      gender,
      weight,
      height,
      bloodgroup,
      adharnumber) async {
    try {
      final response = await http.put(
          Uri.parse('http://$baseurl/api/v1/worker/${widget.uuid}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "workername": workername,
            "workeremail": workeremail,
            "workernumber": workernumber,
            "images": images,
            "birthdate": birthdate,
            "address": address,
            "medicalinformation": {
              "age": age,
              "gender": gender,
              "weight": weight,
              "height": height,
              "bloodgroup": bloodgroup
            },
            "adharnumber": adharnumber,
          }));

      await updatename(
        workername,
      );
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          stringresponseupdate = response.body;
        });
      } else {
        return null;
      }
    } catch (e) {
      print('$e-------');
    }
  }

  updatename(workernames) {
    database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}')
        .update({
      "name": workernames == null ? widget.workernameparams : workernames,
    });
  }

  @override
  initState() {
    setState(() {
      Namecontroller.text = widget.workernameparams;
      Emailcontroller.text = widget.workeremailparams;
      Mobilenocontroller.text = widget.workernumberparams.toString();
      workerprofileimage = widget.imagesparams;
      selectedbdDate = widget.birthdateparams;
      Addresscontroller.text = widget.addressparams;
      Agecontroller.text = widget.ageparams.toString();
      radiovalue = widget.genderparams;
      Heightcontroller.text = widget.heightparams.toString();
      Weightcontroller.text = widget.weightparams.toString();
      Bloodgroupcontroller.text = widget.bloodgroupparams;
      Adharcardcontroller.text = widget.adharnumberparams.toString();
    });
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Back_btn_navbar(navname: "Edit information"),
          Expanded(
            child: Container(
                width: screenwidth,
                height: screenheight,
                color: HexColor("#FFFFFF"),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.greenAccent,
                          width: screenwidth * 0.80,
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                // onDoubleTap: () {},
                                onTap: () {
                                  openImagegallery();
                                },
                                child: Container(
                                  width: screenwidth * 0.26,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amberAccent,
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: (imagedownloadedurl != null
                                          ? Image.network(workerprofileimage,
                                              fit: BoxFit.cover)
                                          : Image.network(workerprofileimage,
                                              fit: BoxFit.cover))),
                                ),
                              ),
                              Container(
                                height: 150,
                                // color: Color.fromARGB(255, 145, 148, 236),
                                width: screenwidth * 0.38,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              box1color = HexColor("#000000");
                                              box2color = HexColor("#FFFFFF");
                                              radiovalue = "Male";
                                              print(radiovalue);
                                            });
                                          },
                                          child: Container(
                                            width: screenwidth * 0.16,
                                            height: screenwidth * 0.20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: box1color,
                                            ),
                                            // color: Colors.amberAccent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.male,
                                                  size: screenwidth * 0.09,
                                                  color: box2color,
                                                ),
                                                Text(
                                                  "Male",
                                                  style: TextStyle(
                                                      color: box2color,
                                                      fontSize:
                                                          screenwidth * 0.04,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenwidth * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              box1color = HexColor("#FFFFFF");
                                              box2color = HexColor("#000000");
                                              radiovalue = "Female";
                                              print(radiovalue);
                                            });
                                          },
                                          child: Container(
                                            width: screenwidth * 0.16,
                                            height: screenwidth * 0.20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // color: Colors.amberAccent,
                                              color: box2color,
                                            ),
                                            // color: Colors.amberAccent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.female,
                                                  size: screenwidth * 0.09,
                                                  color: box1color,
                                                ),
                                                Text(
                                                  "Female",
                                                  style: TextStyle(
                                                      color: box1color,
                                                      fontSize:
                                                          screenwidth * 0.04,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 26,
                                      // ignore: unnecessary_null_comparison
                                      // child: Text(selectedDate.toString()),
                                    ),
                                    Container(
                                      width: screenwidth * 0.32,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          primary: HexColor('#6C63FF'),
                                          onPrimary: HexColor('#FFFFFF'),
                                        ),
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Text("Birthdate"),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Color.fromARGB(255, 78, 78, 78),
                          height: 20,
                          // thickness: 1,
                          indent: screenwidth * 0.10,
                          endIndent: screenwidth * 0.10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: screenwidth * 0.80,
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "Personal Information",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: screenwidth * 0.055,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        buildTextField(
                            "Name",
                            'Shreyas patil',
                            false,
                            screenwidth * 0.80,
                            Namecontroller,
                            1,
                            TextInputType.text),
                        buildTextField(
                            "Email",
                            'shreyaspatil2903@gmail.com',
                            false,
                            screenwidth * 0.80,
                            Emailcontroller,
                            1,
                            TextInputType.text),
                        buildTextField(
                            "Mobile no",
                            '7767952646',
                            false,
                            screenwidth * 0.80,
                            Mobilenocontroller,
                            1,
                            TextInputType.number),
                        buildTextField(
                            "Adharcard no",
                            '586795264623',
                            false,
                            screenwidth * 0.80,
                            Adharcardcontroller,
                            1,
                            TextInputType.number),
                        buildTextField(
                            "Address",
                            'Enter your full address',
                            false,
                            screenwidth * 0.80,
                            Addresscontroller,
                            4,
                            TextInputType.text),
                        Divider(
                          color: Color.fromARGB(255, 78, 78, 78),
                          height: 20,
                          // thickness: 1,
                          indent: screenwidth * 0.10,
                          endIndent: screenwidth * 0.10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: screenwidth * 0.80,
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "Medical information",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: screenwidth * 0.055,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        buildTextField("Age", '45', false, screenwidth * 0.80,
                            Agecontroller, 1, TextInputType.number),
                        buildTextField(
                            "Height",
                            'in feet',
                            false,
                            screenwidth * 0.80,
                            Heightcontroller,
                            1,
                            TextInputType.number),
                        buildTextField(
                            "Weight",
                            'in kg',
                            false,
                            screenwidth * 0.80,
                            Weightcontroller,
                            1,
                            TextInputType.number),
                        buildTextField(
                            "Bloodgroup",
                            'Enter your bloodgroup',
                            false,
                            screenwidth * 0.80,
                            Bloodgroupcontroller,
                            1,
                            TextInputType.text),
                        // Container(
                        //   width: screenwidth * 0.80,
                        //   color: Colors.greenAccent,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                )),
          ),
          Container(
            color: HexColor('#FFFFFF'),
            width: screenwidth * 0.80,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor('#000000'),
                  ),
                  width: 60,
                  height: 58,
                  child: IconButton(
                    color: HexColor('#FFFFFF'),
                    alignment: Alignment.center,
                    onPressed: (() {
                      Namecontroller.text = widget.workernameparams;
                      Emailcontroller.text = widget.workeremailparams;
                      Mobilenocontroller.text =
                          widget.workernumberparams.toString();
                      workerprofileimage = widget.imagesparams;
                      selectedbdDate = widget.birthdateparams;
                      Addresscontroller.text = widget.addressparams;
                      Agecontroller.text = widget.ageparams.toString();
                      radiovalue = widget.genderparams;
                      Heightcontroller.text = widget.heightparams.toString();
                      Weightcontroller.text = widget.weightparams.toString();
                      Bloodgroupcontroller.text = widget.bloodgroupparams;
                      Adharcardcontroller.text =
                          widget.adharnumberparams.toString();
                    }),
                    icon: Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenwidth * 0.14,
                ),
                Container(
                    width: 190,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        primary: HexColor('#000000'),
                        onPrimary: HexColor('#FFFFFF'),
                      ),
                      onPressed: () async {
                        workername = Namecontroller.text;
                        workeremail = Emailcontroller.text;
                        workerno = Mobilenocontroller.text;
                        workerimage = workerprofileimage.toString();
                        workerbirthdate =
                            selectedDate.toString().substring(0, 11);
                        workeradress = Addresscontroller.text;
                        workerage = Agecontroller.text;
                        workergender = radiovalue;
                        workerweight = Heightcontroller.text;
                        workerheight = Weightcontroller.text;
                        workerbloodgroup = Bloodgroupcontroller.text;
                        workeradhar = Adharcardcontroller.text;
                        print(
                            '--${widget.uuid}--$workername--$workeremail--$workerno--${workerbirthdate.substring(0, 11)}--$workergender--');
                        await Updateworkerdata(
                            workername,
                            workeremail,
                            workerno,
                            workerimage,
                            workerbirthdate,
                            workeradress,
                            workerage,
                            workergender,
                            workerweight,
                            workerheight,
                            workerbloodgroup,
                            workeradhar);

                        await Fluttertoast.showToast(
                            msg: "Worker updated to database successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 5,
                            backgroundColor: HexColor('#A5FF8F'),
                            textColor: HexColor('#000000'),
                            fontSize: 16.0);

                        Navigator.pop(context,
                            MaterialPageRoute(builder: (context) {
                          return Homepage();
                        }));
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            // fontSize: 17,
                            letterSpacing: 1,
                            fontSize: screenwidth * 0.044,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

Widget buildTextField(
  String labelText,
  String placeholder,
  bool isPasswordTextField,
  double width,
  TextEditingController controller,
  maxline,
  TextInputType inputtypes,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
    child: Container(
      width: width,
      child: TextField(
          autocorrect: true,
          keyboardType: inputtypes,
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
