import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Components/Backbtnnavbar.dart';

class Worker_location_page extends StatefulWidget {
  var uuid;
  var companyid;
  var name;

  Worker_location_page(
      {Key? key,
      required this.uuid,
      required this.companyid,
      required this.name})
      : super(key: key);

  @override
  State<Worker_location_page> createState() => _Worker_location_pageState();
}

class _Worker_location_pageState extends State<Worker_location_page> {
  final Completer<GoogleMapController> _controller = Completer();
  final database = FirebaseDatabase.instance.ref("companys");

  // late StreamSubscription latdispose;
  late StreamSubscription getlocationdispose;

  dynamic getlocation;
  late double latitude = 37.43296265331129;
  late double longitude = -122.08832357078792;

  // late List<Placemark> placemarks = [];
  // Future setposition(lat, long) async {
  //   placemarks = await placemarkFromCoordinates(lat, long);
  //   setState(() {
  //     placemarks.toString();
  //   });
  //   print(placemarks.toString());
  //   // print(placemarks[0].country);
  //   // print(placemarks[0].locality);
  //   // print(placemarks[0].administrativeArea);
  //   // print(placemarks[0].postalCode);
  //   // print(placemarks[0].name);
  //   // print(placemarks[0].isoCountryCode);
  //   // print(placemarks[0].subLocality);
  //   // print(placemarks[0].subThoroughfare);
  //   // print(placemarks[0].thoroughfare);
  //   // print(placemarks[0].street);
  //   // print(placemarks[0].subAdministrativeArea);
  // }

  void getposition() {
    getlocationdispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/position/')
        .onValue
        .listen((DatabaseEvent event) {
      setState(() {
        getlocation = event.snapshot.value as Map;
        latitude = getlocation["lat"] ?? 37.43296265331129;
        longitude = getlocation["long"] ?? -122.08832357078792;
      });
      print("============$getlocation");
      print("============$longitude");
      print("============$latitude");
    });
  }

  @override
  initState() {
    getposition();
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      // body: Container(),
      body: latitude == null
          ? Center(
              child: CircularProgressIndicator(
              color: HexColor("#6C63FF"),
              strokeWidth: 8,
            ))
          : SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Back_btn_navbar(navname: '${widget.name}'),
                      Expanded(
                        child: SizedBox(
                          height: screenheight,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              //innital position in map
                              target: LatLng(
                                  latitude, longitude), //initial position
                              zoom: 14.0, //initial zoom level
                            ),
                            zoomControlsEnabled: false,
                            markers: {
                              Marker(
                                  markerId: MarkerId("source"),
                                  position: LatLng(latitude,
                                      longitude), //position: LatLng(latitude , longitude),
                                  infoWindow: InfoWindow(
                                      title: "this is workers location"))
                            },
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  //////////////////////////////////////////////////////////
                  ///
                  SlidingUpPanel(
                    maxHeight: 90,
                    minHeight: 80,
                    panel: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   placemarks.toString(),
                          //   style: TextStyle(
                          //       fontSize: screenwidth * 0.04,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "( ${latitude} , ${longitude} )",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          GoogleMapController getmylocation = await _controller.future;
          getmylocation
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 16.00,
          )));
          setState(() {});
        },
        label: const Text(''),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  @override
  deactivate() {
    getlocationdispose.cancel();
    // longdispose.cancel();
    super.deactivate;
  }
}
