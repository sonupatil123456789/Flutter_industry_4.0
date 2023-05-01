import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Pages/Homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location_tracker/Splashscreen/Splashscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

var companyid;
void main() async {
  await dotenv.load(fileName: "secrets.env");
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  companyid = prefs.getString('companyid');
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Scaffold(body: SafeArea(child: Logoscreen_splash())),
    );
  }
}

const logo = 'assets/logosp.svg';

class Logoscreen_splash extends StatefulWidget {
  const Logoscreen_splash({super.key});

  @override
  State<Logoscreen_splash> createState() => _Logoscreen_splashState();
}

// ignore: camel_case_types
class _Logoscreen_splashState extends State<Logoscreen_splash> {
  var Showintroscreen;
  var setintro;

  getonboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Showintroscreen = prefs.getString('Onboardingscreen');
      setState(() {
        setintro = Showintroscreen;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getonboarding();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                (setintro == null ? Splash_screen() : const Homepage()))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          // color: Colors.amber,
          width: screenwidth,
          height: screenheight,
          child: Center(
            child: SvgPicture.asset(logo,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                semanticsLabel: 'Steps count'),
          ),
        ),
      ),
    );
  }
}