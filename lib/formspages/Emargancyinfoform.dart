import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Pages/Homepage.dart';
import '../Components/Backbtnnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Emargancydetailform extends StatefulWidget {
  const Emargancydetailform({super.key});

  @override
  State<Emargancydetailform> createState() => _EmargancydetailformState();
}

class _EmargancydetailformState extends State<Emargancydetailform> {
  TextEditingController Headnamecontroller = TextEditingController();
  TextEditingController Heademailcontroller = TextEditingController();
  TextEditingController Headnumbercontroller = TextEditingController();
  TextEditingController Ambulancenumbercontroller = TextEditingController();
  TextEditingController Firebrigetnumbercontroller = TextEditingController();

  Future SetInitialdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Headname', Headnamecontroller.text);
    await prefs.setString('Heademail', Heademailcontroller.text);
    await prefs.setString('Headnumber', Headnumbercontroller.text);
    await prefs.setString('Ambulanceno', Ambulancenumbercontroller.text);
    await prefs.setString('Firebrigetno', Firebrigetnumbercontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        const Back_btn_navbar(navname: "Fill Details"),
        Expanded(
          child: Container(
              width: screenwidth,
              height: screenheight,
              // color: HexColor('#EDF7FF'),
              color: HexColor("#FFFFFF"),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          // color: Colors.greenAccent,
                          width: screenwidth * 0.80,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SvgPicture.asset("assets/fillform.svg",
                                fit: BoxFit.contain,
                                semanticsLabel: 'Fillform'),
                          )),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                        // thickness: 1,
                        // indent: screenwidth * 0.10,
                        // endIndent: screenwidth * 0.10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: screenwidth * 0.80,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text(
                            "Headquarters details",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: screenwidth * 0.055,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      buildTextField("Head name", 'Name of Head', false,
                          screenwidth * 0.80, Headnamecontroller, 1),
                      buildTextField("Head number", 'Number of Head', false,
                          screenwidth * 0.80, Headnumbercontroller, 1),
                      buildTextField("Head email", 'Email of Head', false,
                          screenwidth * 0.80, Heademailcontroller, 1),
                      Divider(
                        color: Color.fromARGB(255, 78, 78, 78),
                        height: 20,
                        // thickness: 1,
                        // indent: screenwidth * 0.10,
                        // endIndent: screenwidth * 0.10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: screenwidth * 0.80,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text(
                            "Ambulance details",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: screenwidth * 0.055,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      buildTextField(
                          "Ambulancenumber",
                          'Enter ambulance number',
                          false,
                          screenwidth * 0.80,
                          Ambulancenumbercontroller,
                          1),
                      buildTextField(
                          "Firebrigetnumber",
                          'Enter firebriget number',
                          false,
                          screenwidth * 0.80,
                          Firebrigetnumbercontroller,
                          1),
                      // ),
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    await SetInitialdetails();

                    await Fluttertoast.showToast(
                        msg: "Information saved successfully",
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
          ]),
        )
      ],
    )));
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






// TabBarView(
//               children: <Widget>[
//                 Container(
//                   child: Center(
//                     child: Text("Tab 1"),
//                   ),
//                 ),
//                 Container(
//                   child: Center(
//                     child: Text("Tab 2"),
//                   ),
//                 ),
//                 Container(
//                   child: Center(
//                     child: Text("Tab 3"),
//                   ),
//                 ),
//               ],
//             )








  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 6,
  //     child: Scaffold(
  //         appBar: AppBar(
  //           centerTitle: true,
  //           leading: Icon(Icons.person_outline),
  //           title: Text(
  //             "HOME SCREEN",
  //             style: TextStyle(fontSize: 16.0),
  //           ),
  //           bottom: PreferredSize(
  //               child: TabBar(
  //                   isScrollable: true,
  //                   unselectedLabelColor: Colors.white.withOpacity(0.3),
  //                   indicatorColor: Colors.white,
  //                   tabs: [
  //                     Tab(
  //                       child: Text("Kumar"),
  //                     ),
  //                     Tab(
  //                       child: Text("Lokesh"),
  //                     ),
  //                     Tab(
  //                       child: Text("Rathod"),
  //                     ),
  //                   ]),
  //               preferredSize: Size.fromHeight(30.0)),
  //           actions: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.only(right: 16.0),
  //               child: Icon(Icons.add_alert),
  //             ),
  //           ],
  //         ),
          // body: TabBarView(
          //   children: <Widget>[
          //     Container(
          //       child: Center(
          //         child: Text("Tab 1"),
          //       ),
          //     ),
          //     Container(
          //       child: Center(
          //         child: Text("Tab 2"),
          //       ),
          //     ),
          //     Container(
          //       child: Center(
          //         child: Text("Tab 3"),
          //       ),
          //     ),

          //   ],
          // )),
  //   );
  // }










  //  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
  //               const Back_btn_navbar(navname: "Details form"),

  //               buildTextField("Head name", 'Name of Head', false,
  //                   screenwidth * 0.80, Headnamecontroller, 1),
  //               buildTextField("Head number", 'Number of Head', false,
  //                   screenwidth * 0.80, Headnumbercontroller, 1),
  //               buildTextField("Head email", 'Email of Head', false,
  //                   screenwidth * 0.80, Heademailcontroller, 1),
                // buildTextField("Ambulancenumber", 'Enter ambulance number',
                //     false, screenwidth * 0.80, Ambulancenumbercontroller, 1),
                // buildTextField("Firebrigetnumber", 'Enter firebriget number',
                //     false, screenwidth * 0.80, Firebrigetnumbercontroller, 1),
  //               Container(
  //                   width: 240,
  //                   height: 50,
  //                   child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       shape: new RoundedRectangleBorder(
  //                         borderRadius: new BorderRadius.circular(10.0),
  //                       ),
  //                       primary: HexColor('#000000'),
  //                       onPrimary: HexColor('#FFFFFF'),
  //                     ),
  //                     onPressed: () async {


                        // await SetInitialdetails();

                        // await Fluttertoast.showToast(
                        //     msg: "Information saved successfully",
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.CENTER,
                        //     timeInSecForIosWeb: 5,
                        //     backgroundColor: HexColor('#A5FF8F'),
                        //     textColor: HexColor('#000000'),
                        //     fontSize: 16.0);

                        // Navigator.pop(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return Homepage();
                        // }));
  //                     },
  //                     child: Text(
  //                       "Save",
  //                       style: TextStyle(
  //                           // fontSize: 17,
  //                           letterSpacing: 2,
  //                           fontSize: screenwidth * 0.050,
  //                           fontWeight: FontWeight.w400),
  //                     ),
  //                   )),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //             ]),