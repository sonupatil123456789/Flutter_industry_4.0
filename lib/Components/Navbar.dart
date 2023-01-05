import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const String Brandlogo = 'assets/Logo.svg';
String? usesetimage;

class Navbar extends StatefulWidget {
  // final String? Mypic;
  const Navbar({
    Key? key,
    // required this.Mypic,
  }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? setimg;

  @override
  void initState() {
    super.initState();
    // setmyprofilepic();
  }

  // setmyprofilepic() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   final prefs = await SharedPreferences.getInstance();
  //   String? IMG = prefs.getString('Image');
  //   setState(() {
  //     setimg = IMG;
  //   });
  //   print("this is navbar variable $setimg");
  // }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    var picture;
    return Container(
      height: 68.0,
      width: screenwidth,
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //     width: 40.0,
          //     height: 40.0,
          //     child: SvgPicture.asset(Brandlogo, semanticsLabel: 'Brand Logo')),
          // SizedBox(
          //   width: 2,
          // ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${"Hello User !"} 👋",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenwidth * 0.055,
                      // fontSize: 22,
                      color: HexColor('#212121')),
                ),
                Text("Shreyas patil",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        // fontSize: 16,
                        fontSize: screenwidth * 0.038,
                        color: HexColor('#000000')))
              ]),
          Container(
            width: screenwidth * 0.20,
            height: 40.0,
            // color: Colors.black,
          ),
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/profile.jpg', fit: BoxFit.cover),
            ),
            // child: (setimg != null
            //     ? Image.memory(
            //         base64Decode(setimg!),
            //         // fit: BoxFit.cover,
            //         // width: 40,
            //         // height: 40,
            //       )
            //     : const Text("data loading")),
          ),
          // SizedBox(
          //   width: 2,
          // ),
        ],
      ),
    );
  }
}
