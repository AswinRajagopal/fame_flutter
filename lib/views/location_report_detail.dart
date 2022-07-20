import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';

class LocationReportDetail extends StatefulWidget {
  @override
  _LocationReportDetailState createState() => _LocationReportDetailState();
}

class _LocationReportDetailState extends State<LocationReportDetail> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  final TextEditingController search = TextEditingController();
  GoogleMapController controller;
  Set<Marker> _markers = {};
  int live = 0, total = 0;
  bool online = true;
  bool offline = true;
  var searchId;
  List<String> empName = [];

  get mapController => controller;

  @override
  void initState() {
    epC.pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
      customBody: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Processing please wait...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
    epC.pr.style(
      backgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      epC.getLocationReport(RemoteServices().box.get('empid'));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    // ignore: missing_return
    SystemChannels.lifecycle.setMessageHandler((msg) {
      debugPrint('SystemChannels> $msg');
      if (msg == AppLifecycleState.resumed.toString()) {
        if (!mounted) return;
        setState(() {
          controller.setMapStyle('[]');
        });
      }
    });
    setState(() {
      controller = controllerParam;
      // controller.setMapStyle(_mapStyle);
      epC.locations.asMap().forEach((index, emp) async {
        print(emp);
        var markIcon;
        empName.add(emp['name']);
        var time = DateTime.parse(emp['timeStamp']);
        var now = DateTime.now();
        total++;
        markIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(24, 24)),
            'assets/images/siteposted_nolive.png');
        if (time.millisecondsSinceEpoch >
            (now.millisecondsSinceEpoch - (3600 * 1000))) {
          live++;
          markIcon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(24, 24)),
              'assets/images/siteposted.png');
        }

        var snippetString = '${emp['datetime']}, ${emp['battery']}%';
        _markers.add(
          Marker(
            markerId: MarkerId(
              emp['empId'],
            ),
            icon: markIcon,
            position: LatLng(
              double.parse(emp['lat']),
              double.parse(emp['lng']),
            ),
            infoWindow: InfoWindow(
              title: emp['name'],
              // snippet: emp['datetime'],
              snippet: snippetString,
            ),
          ),
        );
      });
    });
    Timer(Duration(seconds: 1), () {
      controller.showMarkerInfoWindow(MarkerId(epC.locations.first['empId']));
      setState(() {});
    });
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Current Location',
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (epC.isLoadingLocation.value) {
            return Column();
          } else if (epC.locations.isNullOrBlank) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'No data found for employee',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            child: Center(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 50.0),
                  child: SimpleAutoCompleteTextField(
                    suggestions: empName,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Employee Name',
                    ),
                    key: key,
                    textSubmitted: (name) {
                      setMarkers(name);
                    },
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: GoogleMap(
                          buildingsEnabled: true,
                          myLocationEnabled: true,
                          mapToolbarEnabled: true,
                          markers: _markers,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(epC.locations.first['lat']),
                              double.parse(epC.locations.first['lng']),
                            ),
                            zoom: 8,
                          ),
                          mapType: MapType.normal,
                        ),
                      ),
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Switch(
                              value: online,
                              onChanged: (bool value) {
                                setState(() {
                                  online = value;
                                  setMarkers(null);
                                });
                              },
                            ),
                            Text(
                              'Online',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 200.0),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: <Widget>[
                            Switch(
                              value: offline,
                              onChanged: (bool value) {
                                setState(() {
                                  offline = value;
                                  setMarkers(null);
                                });
                              },
                            ),
                            Text(
                              'Offline',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ]),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      color: Colors.grey[400],
                      child: Text(
                        'Live ' + live.toString() + '/' + total.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ))
              ]),
            ),
          );
        }),
      ),
    );
  }

  setMarkers(name) {
    setState(() {
      total = 0;
      live = 0;
      _markers = {};
      epC.locations.asMap().forEach((index, emp) async {
        print(emp);
        var markIcon;
        var time = DateTime.parse(emp['timeStamp']);
        var now = DateTime.now();
        total++;

        if (online &&
            time.millisecondsSinceEpoch >
                (now.millisecondsSinceEpoch - (3600 * 1000)) &&
            (name == null || name == emp['name'])) {
          live++;
          markIcon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(24, 24)),
              'assets/images/siteposted.png');
          print("online:$online");
          var snippetString = '${emp['datetime']}, ${emp['battery']}%';
          _markers.add(
            Marker(
              markerId: MarkerId(
                emp['empId'],
              ),
              icon: markIcon,
              position: LatLng(
                double.parse(emp['lat']),
                double.parse(emp['lng']),
              ),
              infoWindow: InfoWindow(
                title: emp['name'],
                snippet: snippetString,
              ),
            ),
          );
          LatLng newlatlang = LatLng(
            double.parse(emp['lat']),
            double.parse(emp['lng']),
          );
          controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: newlatlang, zoom: 17)
              //17 is new zoom level
              ));
        }
        if (offline &&
            time.millisecondsSinceEpoch <=
                (now.millisecondsSinceEpoch - (3600 * 1000)) &&
            (name == null || name == emp['name'])) {
          markIcon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(24, 24)),
              'assets/images/siteposted_nolive.png');
          print("offline:$offline");
          var snippetString = '${emp['datetime']}, ${emp['battery']}%';
          _markers.add(
            Marker(
              markerId: MarkerId(
                emp['empId'],
              ),
              icon: markIcon,
              position: LatLng(
                double.parse(emp['lat']),
                double.parse(emp['lng']),
              ),
              infoWindow: InfoWindow(
                title: emp['name'],
                snippet: snippetString,
              ),
            ),
          );
          LatLng newlatlang = LatLng(
            double.parse(emp['lat']),
            double.parse(emp['lng']),
          );
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: newlatlang, zoom: 17)
              //17 is new zoom level
              ));
        }
      });
    });
    Timer(Duration(seconds: 1), () {
      controller.showMarkerInfoWindow(MarkerId(epC.locations.first['empId']));
      setState(() {});
    });
  }
}
