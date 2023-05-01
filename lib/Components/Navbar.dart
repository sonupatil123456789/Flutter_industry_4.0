import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Splashscreen/Loginscreen.dart';
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
  var Contractername;
  var Contracterprofile;
  var Contractermobileno;
  var Contracteremail;
  late bool Login;
  var companyid;
  Future Getcontracterdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Contractername = prefs.getString('Contractername');
      Contracterprofile = prefs.getString('Contracterprofile');
      Contractermobileno = prefs.getString('Contractermobileno');
      Contracteremail = prefs.getString('Contracteremail');
      companyid = prefs.getString('companyid');
      prefs.setBool('Login', false);
    });
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Contractername');
    prefs.remove('Contracterprofile');
    prefs.remove('Contractermobileno');
    prefs.remove('Contracteremail');
    prefs.remove('companyid');
    prefs.getBool('Login')!;
    setState(() {});
    print(Contractername);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Loginpage();
    }));
    setState(() {});
    await Fluttertoast.showToast(
        msg: "Log out",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: HexColor('#A5FF8F'),
        textColor: HexColor('#000000'),
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    Getcontracterdetails();
  }

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
                  "${"Hello !"} 👋",
                  style: GoogleFonts.poppins(
                      color: HexColor('#212121'),
                      fontSize: screenwidth * 0.052,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                    Contractername == "null"
                        ? "No data"
                        : Contractername.toString(),
                    style: GoogleFonts.notoSans(
                        color: HexColor('#212121'),
                        fontSize: screenwidth * 0.035,
                        fontWeight: FontWeight.w400))
              ]),
          Container(
            width: screenwidth * 0.20,
            height: 40.0,
            // color: Colors.black,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(
                      context,
                      screenwidth,
                      screenheight,
                      Contracterprofile,
                      Contractermobileno,
                      Contracteremail,
                      companyid,
                      Contractername,
                      logout));
            },
            child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Contracterprofile == null
                      ? Image.asset('assets/profile.jpeg', fit: BoxFit.cover)
                      : Image.network(
                          Contracterprofile,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                        ),
                )),
          ),
          // SizedBox(
          //   width: 2,
          // ),
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context, double screenwidth,
    double screenheight, profileimg, number, email, id, name, logout) {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)), //this right here
    child: Container(
      color: HexColor('#FFFFFF'),
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: screenwidth * 0.25,
              height: screenwidth * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  profileimg == null
                      ? "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80"
                      : profileimg,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              color: Color.fromARGB(255, 78, 78, 78),
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.amber,
                    width: screenwidth * 0.62,
                    height: 100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name ?? " ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: screenwidth * 0.044,
                                color: HexColor('#212121')),
                          ),
                          Text(
                            email ?? " ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: screenwidth * 0.032,
                                color: HexColor('#212121')),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "#$id" ?? " ",
                            style: GoogleFonts.poppins(
                                color: HexColor('#212121'),
                                fontSize: screenwidth * 0.070,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ]),
                  ),
                ]),
            SizedBox(
              height: 14,
            ),
            Container(
                width: screenwidth * 0.40,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    primary: HexColor('#000000'),
                    onPrimary: HexColor('#FFFFFF'),
                  ),
                  onPressed: () async {
                    logout();
                  },
                  child: Text(
                    "Log out",
                    style: GoogleFonts.notoSans(
                        // fontSize: 17,
                        letterSpacing: 1,
                        fontSize: screenwidth * 0.040,
                        fontWeight: FontWeight.w400),
                  ),
                )),
          ],
        ),
      ),
    ),
  );
}
