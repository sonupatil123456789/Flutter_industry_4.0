import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_tracker/Pages/incidentpage.dart';
import 'package:file_picker/file_picker.dart';

import '../Components/Backbtnnavbar.dart';

class Editincidentform extends StatefulWidget {
  var objectid;
  var incidenttypeinit;
  var finenciallossesinin;
  var deadpeopleinin;
  var pdfeinit;
  var totalinvestment;
  var enjuredpeopleinin;

  Editincidentform({
    super.key,
    required this.objectid,
    required this.pdfeinit,
    required this.enjuredpeopleinin,
    required this.deadpeopleinin,
    required this.finenciallossesinin,
    required this.incidenttypeinit,
    required this.totalinvestment,
  });

  @override
  State<Editincidentform> createState() => _EditincidentformState();
}

class _EditincidentformState extends State<Editincidentform> {
  var stringresponseupdate;
  dynamic mapresponse;
  var noofpeopleenjured;
  var noofpeopledead;
  var totalfinancialloss;
  var totalinvestment;
  var pdffilelink;
  var incidenttype;

  TextEditingController noofpeopleenjuredcontroll = TextEditingController();
  TextEditingController noofpeopledeadcontroll = TextEditingController();
  TextEditingController totalfinanciallosscontroll = TextEditingController();
  TextEditingController investmentcontroll = TextEditingController();
  TextEditingController pdffilelinkcontroll = TextEditingController();
  TextEditingController incidenttypecontroll = TextEditingController();

  var storage = FirebaseStorage.instance.ref('Incidents/pdfs');
  var defaultimage = "assets/profile.jpg";
  var pdfimage = "assets/pdf-file.png";
  late String Filename;
  String? Filepath;
  late File Pdffile;
  late TaskSnapshot uploadpdf;
  var pdfdownloadedurl;
  var incidentpdflink;

  Future openpdf() async {
    try {
      var pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );
      if (pickedFile != null) {
        setState(() {
          Filepath = pickedFile.files.single.path;
          print("file path is = $Filepath");
          // OpenFile.open(Filepath);
          Filename =
              DateTime.now().toString() + "_" + pickedFile.files.single.name;
          print("file Filename is = $Filename");
          Pdffile = File(Filepath!);
        });
        uploadpdf = await storage.child("$Filename").putFile(Pdffile);
        TaskSnapshot uploadingpicprocess = await uploadpdf;
        pdfdownloadedurl = await uploadingpicprocess.ref.getDownloadURL();
        setState(() {
          incidentpdflink = pdfdownloadedurl;
        });
        print('$pdfdownloadedurl');
        print('${widget.objectid}');
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("error while picking file $e");
    }
  }

  String baseurl = dotenv.env['BASEURL']!;

  Future Editincident(noofpeopleenjured, noofpeopledead, totalfinancialloss,
      pdffilelink, incidenttype, totalinvestment) async {
    try {
      final response = await http.put(
          Uri.parse('https://$baseurl/api/v1/incident/${widget.objectid}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<dynamic, dynamic>{
            "incidenttype": incidenttype,
            "noofpeopleenjured": noofpeopleenjured,
            "noofpeopledead": noofpeopledead,
            "totalfinancialloss": totalfinancialloss,
            "pdffilelink": pdffilelink,
            "totalinvestment": totalinvestment
          }));

      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          stringresponseupdate = response.body;
          mapresponse = jsonDecode(stringresponseupdate);
          print(mapresponse);
          Fluttertoast.showToast(
              msg: "${mapresponse["message"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: HexColor('#A5FF8F'),
              textColor: HexColor('#000000'),
              fontSize: 16.0);
        });
      } else {
        return null;
      }
    } catch (e) {
      print('$e-------');
    }
  }

  var strlength;

  @override
  initState() {
    strlength = 0;
    setState(() {
      noofpeopledeadcontroll.text = widget.deadpeopleinin.toString();
      noofpeopleenjuredcontroll.text = widget.enjuredpeopleinin.toString();
      totalfinanciallosscontroll.text = widget.finenciallossesinin.toString();
      investmentcontroll.text = widget.totalinvestment.toString();
      incidentpdflink = widget.pdfeinit;
      incidenttypecontroll.text = widget.incidenttypeinit;
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
          Back_btn_navbar(navname: "Edit information"),
          Expanded(
            child: Container(
                width: screenwidth,
                height: screenheight,
                color: HexColor('#FFFFFF'),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onDoubleTap: () {},
                          onTap: () {
                            openpdf();
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
                                child: (incidentpdflink != null
                                    ? Image.asset(pdfimage, fit: BoxFit.cover)
                                    : Image.asset(defaultimage,
                                        fit: BoxFit.cover))),
                          ),
                        ),
                        buildTextField(
                            "Enjuredpeople",
                            'no of enjured people',
                            false,
                            screenwidth * 0.80,
                            noofpeopleenjuredcontroll,
                            1),
                        buildTextField(
                            "Dead people",
                            'no of dead people',
                            false,
                            screenwidth * 0.80,
                            noofpeopledeadcontroll,
                            1),
                        buildTextField(
                            "Financial loss",
                            'Financial loss of company ',
                            false,
                            screenwidth * 0.80,
                            totalfinanciallosscontroll,
                            1),
                        buildTextField(
                            "Total investment",
                            'Total investment of company',
                            false,
                            screenwidth * 0.80,
                            investmentcontroll,
                            1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
                              child: Container(
                                width: screenwidth * 0.80,
                                child: TextField(
                                    maxLength: 120,
                                    autocorrect: true,
                                    maxLines: 3,
                                    controller: incidenttypecontroll,
                                    // enabled: (strlength > 148 ? false : true),
                                    onChanged: (valueinctype) {
                                      setState(() {
                                        // strlength = valueinctype.length;
                                        // print("length is = $strlength");
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'type of insident',
                                      labelText: "Incident type",
                                      labelStyle: TextStyle(
                                        color: HexColor('#6C63FF'),
                                      ),
                                      hintStyle:
                                          TextStyle(color: HexColor("#636363")),
                                      filled: true,
                                      fillColor: HexColor('#FFFFFF'),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.black26, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: HexColor('#6C63FF'),
                                            width: 2),
                                      ),
                                    )),
                              ),
                            ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   width: 60,
                            //   height: 30,
                            //   color: HexColor('#FFFFFF'),
                            //   child: Text(
                            //     "${strlength == "" ? widget.incidenttypeinit.toString().length : strlength}/150",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.w300,
                            //         fontSize: screenwidth * 0.035,
                            //         color: HexColor('#212121')),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                )),
          ),
          Container(
            // color: Colors.amber,
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
                      onPressed: (() {}),
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
                          noofpeopleenjured = noofpeopleenjuredcontroll.text;
                          noofpeopledead = noofpeopledeadcontroll.text;
                          totalfinancialloss = totalfinanciallosscontroll.text;
                          pdffilelink = incidentpdflink.toString();
                          incidenttype = incidenttypecontroll.text.toString();
                          totalinvestment = investmentcontroll.text;

                          await Editincident(
                              noofpeopleenjured,
                              noofpeopledead,
                              totalfinancialloss,
                              pdffilelink,
                              incidenttype,
                              totalinvestment);

                          await Fluttertoast.showToast(
                              msg: "incident updated to database successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 5,
                              backgroundColor: HexColor('#A5FF8F'),
                              textColor: HexColor('#000000'),
                              fontSize: 16.0);

                          Navigator.pop(context,
                              MaterialPageRoute(builder: (context) {
                            return Incidentpage();
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
                ]),
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
    maxline) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
    child: Container(
      width: width,
      child: TextField(
          keyboardType: TextInputType.number,
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
