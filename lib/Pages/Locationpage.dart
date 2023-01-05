import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  late StreamSubscription latdispose;
  late StreamSubscription longdispose;

  var getlatitudevar;
  var latitude;
  var getlongitudevar;
  var longitude;

  void getposition() {
    latdispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/position/lat')
        .onValue
        .listen((DatabaseEvent event) {
      getlatitudevar = event.snapshot.value;
      setState(() {
        latitude = "$getlatitudevar";
      });
      print("====latitude=====$latitude");
    });
    longdispose = database
        .child(widget.companyid)
        .child("siteworkerhealth")
        .child('/${widget.uuid}/position/long')
        .onValue
        .listen((DatabaseEvent event) {
      getlongitudevar = event.snapshot.value;
      setState(() {
        longitude = "$getlongitudevar";
      });
      print("====longitude=====$longitude");
    });
  }

  @override
  initState() {
    getposition();
    super.initState;
  }

  // static double latitude = 18.789499;
  // static double longitude = 73.344803;

  static final CameraPosition Mycameraposition = CameraPosition(
    target: LatLng(18.789499, 73.344803),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Back_btn_navbar(navname: '${widget.name}'),
                Expanded(
                  child: SizedBox(
                    height: screenheight,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: Mycameraposition,
                      zoomControlsEnabled: false,
                      markers: {
                        Marker(
                            markerId: MarkerId("source"),
                            position: LatLng(18.789499,
                                73.344803), //position: LatLng(latitude , longitude),
                            infoWindow:
                                InfoWindow(title: "this is workers location"))
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
              maxHeight: 300,
              minHeight: 80,
              panel: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Veena nagar khopoli",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "( ${latitude} , ${longitude} )",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() async {
              GoogleMapController getmylocation = await _controller.future;
              getmylocation
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 16.00,
              )));
            });
          },
          label: const Text('!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  @override
  deactivate() {
    latdispose.cancel();
    longdispose.cancel();
    super.deactivate;
  }
}
