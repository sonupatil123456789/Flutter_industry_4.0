import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location_tracker/Components/Inventarylist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/Backbtnnavbar.dart';

final String splash1 = 'assets/splash1.svg';

class Addinventary extends StatefulWidget {
  const Addinventary({super.key});

  @override
  State<Addinventary> createState() => _AddinventaryState();
}

class _AddinventaryState extends State<Addinventary> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController partnerbrandnamecontroller = TextEditingController();
  TextEditingController partnerbrandemailcontroller = TextEditingController();
  TextEditingController partnercompanynumbercontroller =
      TextEditingController();
  TextEditingController perpieceweightcontroller = TextEditingController();
  TextEditingController totalweightcontroller = TextEditingController();

  var companyid;
  final database = FirebaseDatabase.instance.ref("companys");
  // var name;
  // var partnerbrandname;
  // var partnerbrandemail;
  late int partnercompanynumber;
  // var perpieceweight;
  // var totalweight;
  late int weight;

  Future Addinventaryinfirebase(_id, name, partnerbrandname, partnerbrandemail,
      partnercompanynumber, perpieceweight, totalweight) async {
    final prefs = await SharedPreferences.getInstance();
    companyid = prefs.getString('companyid');
    try {
      await database
          .child("$companyid")
          .child("/inventary")
          .child("/${_id}")
          .set({
        "id": _id,
        "name": name,
        "partnerbrandemail": partnerbrandemail,
        "partnerbrandname": partnerbrandname,
        "partnercompanynumber": partnercompanynumber,
        "perpieceweight": perpieceweight,
        "totalweight": totalweight,
        "weight": 0,
      });

      await prefs.setBool('backgroundmailcheck', false);
      Navigator.pop(context, MaterialPageRoute(builder: (context) {
        return Inventarylist();
      }));
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Back_btn_navbar(navname: "Add Inventary"),
        Container(
          // color: Colors.amber,
          height: screenheight * 0.30,
          width: screenwidth * 0.80,
          child: SvgPicture.asset(splash1, semanticsLabel: 'splashscreen'),
        ),
        SizedBox(
          height: screenheight * 0.02,
        ),
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
                      buildTextField(
                          "Name",
                          'Enter unique name for your inventary',
                          false,
                          screenwidth * 0.80,
                          namecontroller,
                          1,
                          TextInputType.text),
                      buildTextField(
                          "Brand Name",
                          'Enter partner company name',
                          false,
                          screenwidth * 0.80,
                          partnerbrandnamecontroller,
                          1,
                          TextInputType.text),
                      buildTextField(
                          "Email",
                          'Enter partner company email',
                          false,
                          screenwidth * 0.80,
                          partnerbrandemailcontroller,
                          1,
                          TextInputType.text),
                      buildTextField(
                          "Mobile no",
                          'Enter partner company number',
                          false,
                          screenwidth * 0.80,
                          partnercompanynumbercontroller,
                          1,
                          TextInputType.number),
                      buildTextField(
                          "Product weight",
                          'Enter th weight of product in kg',
                          false,
                          screenwidth * 0.80,
                          perpieceweightcontroller,
                          1,
                          TextInputType.number),
                      buildTextField(
                          "Inventary capiciety",
                          'Enter the total Inventary capiciety kg',
                          false,
                          screenwidth * 0.80,
                          totalweightcontroller,
                          1,
                          TextInputType.number),
                      // totalweightcontroller
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
                onPressed: (() {
                  namecontroller.text = "";
                  partnerbrandnamecontroller.text = "";
                  partnerbrandemailcontroller.text = "";
                  partnercompanynumbercontroller.text;
                  perpieceweightcontroller.text;
                  totalweightcontroller.text;
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
                    var id = new DateTime.now().millisecondsSinceEpoch;
                    // partnercompanynumber =
                    //     partnercompanynumbercontroller.text as int;
                    // weight = perpieceweightcontroller.text as int;
                    await Addinventaryinfirebase(
                      id,
                      namecontroller.text.toString(),
                      partnerbrandnamecontroller.text.toString(),
                      partnerbrandemailcontroller.text.toString(),
                      int.parse(partnercompanynumbercontroller.text),
                      int.parse(perpieceweightcontroller.text),
                      int.parse(totalweightcontroller.text),
                    );
                    await Fluttertoast.showToast(
                        msg: "Inventary added to database successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 5,
                        backgroundColor: HexColor('#A5FF8F'),
                        textColor: HexColor('#000000'),
                        fontSize: 16.0);

                    // Navigator.pop(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return Homepage();
                    // }));
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
  maxline,
  TextInputType inputtypes,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
    child: Container(
      width: width,
      child: TextField(
          keyboardType: inputtypes,
          autocorrect: true,
          maxLines: maxline,
          controller: controller,
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
