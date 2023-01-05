import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Bannercard.dart';
import 'package:location_tracker/Components/Bottombar.dart';
import 'package:location_tracker/Components/Cards.dart';
import 'package:location_tracker/Components/Navbar.dart';
// import 'package:telephony/telephony.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

final String doctor = 'assets/doctor.svg';
// https://iconscout.com/icons/pdf-file

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // final Telephony telephony = Telephony.instance;

  var contractername;
  var contracteremail;
  var contracterphonenumber;
  var latitude;
  var longitude;
  var altitude;

  dynamic stringresponseemail;
  dynamic stringresponse;
  dynamic mapresponse;

// 7066549165
  dynamic phonenumberfirebriget;
  dynamic phonenumberambulance;
  dynamic headphonenumber;
  dynamic message =
      "sudden incident is occured on our site we kindly request you to send a ambulance / fire trucks immeadieatly";
  dynamic to_email;
  dynamic to_name;
  dynamic from_number;
  dynamic from_email;
  dynamic from_name;
  dynamic user_subject = "Sending an ambulance on our site";

  Future GetInitialdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    from_name = prefs.getString('Contractername');
    from_email = prefs.getString('Contracteremail');
    from_number = prefs.getString('Contractermobileno');
    to_name = prefs.getString('Headname');
    headphonenumber = prefs.getString('Headnumber');
    to_email = prefs.getString('Heademail');
    phonenumberfirebriget = prefs.getString('Firebrigetno');
    phonenumberambulance = prefs.getString('Ambulanceno');
    print(
        '$from_name-$to_name-$phonenumberfirebriget-$phonenumberambulance-is all the details');
  }

  sendbackgroundmessage() async {
    // bool? permissionsGranted = await telephony.requestSmsPermissions;
    // await telephony.sendSms(
    //     to: phonenumberfirebriget.toString(),
    //     message:
    //         "hi there is incident happened in in our construction site please send  firebriget !");
    // await telephony.sendSms(
    //     to: phonenumberambulance.toString(),
    //     message:
    //         "hi there is incident happened in in our construction site please send ambulance !");
    // await telephony.sendSms(
    //     to: headphonenumber.toString(),
    //     message:
    //         "hi there is incident happened in in our construction site please send ambulance !");
    bool? res = await FlutterPhoneDirectCaller.callNumber(
        phonenumberambulance.toString());
  }

  var serviceid = "service_zf2ezeq";
  var tampletid = 'template_ugh9iy9';
  var userid = "uq7nZnZud5UA5IsVf";

  Future sendbackgroundemail() async {
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
              "user_subject": user_subject,
              "message": message,
            }
          }));
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          stringresponseemail = response.body;
        });
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  String baseurl = dotenv.env['BASEURL']!;
  String defaultpdfimage = "assets/pdf.png";

  Future Addincident(contractername, contracteremail, contracterphonenumber,
      latitude, longitude, altitude) async {
    final prefs = await SharedPreferences.getInstance();
    var companyid = prefs.getString('companyid');
    try {
      final response =
          await http.post(Uri.parse('http://$baseurl/api/v1/incident/new'),
              headers: <String, String>{
                'Content-Type': 'application/json ',
              },
              body: jsonEncode(<dynamic, dynamic>{
                "companyid": companyid,
                "incidentlocation": {
                  "latitude": latitude,
                  "longitude": longitude,
                  "altitude": altitude
                },
                "contractername": contractername,
                "contracteremail": contracteremail,
                "contracternumber": contracterphonenumber,
                "noofpeopleenjured": 0,
                "noofpeopledead": 0,
                "totalfinancialloss": 0,
                "totalinvestment": 0,
                "pdffilelink": defaultpdfimage,
              }));
      if (response.statusCode == 200) {
        setState(() {
          stringresponse = response.body;
          mapresponse = jsonDecode(stringresponse);
          print(mapresponse);
        });
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  var getlatitudeval;
  var getlongitudeval;
  var getaltitudeval;

  Future getlocation() async {
    var status = await Permission.location.status;
    print("status : $status");
    if (await status.isGranted) {
      print("Location permission is already granted");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      getlatitudeval = position.latitude;
      getlongitudeval = position.longitude;
      getaltitudeval = position.altitude;
      print("Latitude is = ${position.latitude}");
      print("Longitude is = ${position.longitude}");
      print("Altitude is = ${position.altitude}");
    }
    if (await status.isDenied) {
      print("Location permission is already granted");
      openAppSettings();
    }
  }

  // String? Showintroscreen;

  @override
  initState() {
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenwidth,
          height: screenheight,
          color: HexColor("#FFFFFF"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Navbar(),
              const SizedBox(
                height: 12,
              ),
              Container(
                // width: screenwidth * 0.85,
                width: screenwidth <= 400
                    ? screenwidth * 0.90
                    : screenwidth * 0.85,
                // color: Colors.green,
                // height: screenheight*,
                child: DatePicker(
                  height: 85,
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: HexColor("#000000"),
                  // selectedTextColor: HexColor("#EAF3F2"),
                  onDateChange: (date) {
                    setState(() {
                      var selectedValue = date;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Banner_cards(),
              const SizedBox(
                height: 6,
              ),
              Container(
                height: 50.0,
                width: screenwidth,
                // width: 450,
                // color: HexColor('#87EAC0'),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Device info",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: HexColor('#212121')),
                        ),
                        Container(
                          width: screenwidth * 0.18,
                          height: 30.0,
                          // color: Colors.black,
                        ),
                        Row(
                          children: [
                            Text(
                              "See more",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                  color: HexColor('#000000')),
                            ),
                            IconButton(
                              onPressed: (() {}),
                              icon: Icon(FeatherIcons.arrowRight,
                                  size: 18, color: HexColor('#212121')),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  width: screenwidth,
                  height: 400,
                  // color: Colors.deepOrange,
                  child: SingleChildScrollView(
                    child: Cards(),
                  ),
                ),
              ),
              Bottom_bar()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: HexColor('#6C63FF'),
        // backgroundColor: HexColor('#1FAEFF'),
        child: Icon(
          Icons.emergency,
          size: 25,
          color: HexColor("#FFFFFF"),
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              builder: (context) => Column(
                    children: [
                      // Back_btn_navbar(navname: "SOS"),
                      Container(
                        width: 300,
                        height: 300,
                        // color: Colors.amber,
                        child: SvgPicture.asset(doctor,
                            fit: BoxFit.contain, semanticsLabel: 'Fire'),
                      ),
                      Container(
                        width: screenwidth,
                        height: 80,
                        decoration: BoxDecoration(
                          // border:
                          //     Border.all(width: 1, color: HexColor("#404040")),
                          borderRadius: BorderRadius.circular(10),
                          // color: HexColor("#EB304A"),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.error),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "on pressing this button it will send information \n hospital ambulance and firebriged for safty",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    color: HexColor('#000000')),
                              )
                            ]),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await getlocation();
                          setState(() {
                            contractername = from_name;
                            contracteremail = from_email;
                            contracterphonenumber = from_number;
                            latitude = getaltitudeval;
                            longitude = getlatitudeval;
                            altitude = getaltitudeval;
                          });
                          await GetInitialdetails();
                          // await sendbackgroundmessage();
                          // await sendbackgroundemail();

                          await Addincident(
                              contractername,
                              contracteremail,
                              contracterphonenumber,
                              latitude,
                              longitude,
                              altitude);
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: HexColor("#EB304A"),
                          ),
                          child: Icon(
                            Icons.sos,
                            color: HexColor("#FFFFFF"),
                          ),
                        ),
                      )
                    ],
                  ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}




    // if (statuses[Permission.camera]!.isDenied) {
    //   openAppSettings();
    //   print("Camera permission is denied.");
    // }
    // if (statuses[Permission.storage]!.isDenied) {
    //   openAppSettings();
    //   print("Location permission is denied.");
    // }
    // if (statuses[Permission.sms]!.isDenied) {
    //   openAppSettings();
    //   print("Location permission is denied.");
    // }
    // if (statuses[Permission.phone]!.isDenied) {
    //   openAppSettings();
    //   print("Location permission is denied.");
    // }