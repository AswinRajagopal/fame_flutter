import 'dart:async';

import '../utils/utils.dart';

import '../connection/locationpath.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../controllers/employee_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitPlanRoute extends StatefulWidget {
  final String empId;
  final String date;
  VisitPlanRoute(this.empId, this.date);

  @override
  _VisitPlanRouteState createState() => _VisitPlanRouteState();
}

class _VisitPlanRouteState extends State<VisitPlanRoute> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  GoogleMapController controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> latlngSegment1 = [];
  List<LatLng> latlngSegment2 = [];
  LatLng _updatedMapPosition;
  // ignore: prefer_final_fields
  Locationpath _locationPath = Locationpath();

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
      epC.getVisitPlanRoute(widget.empId, widget.date, type: 'visit');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<LatLng> _convertToLatLng(List points) {
    var result = <LatLng>[];
    for (var i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    var index = 0;
    var len = poly.length;
    var c = 0;

    do {
      var shift = 0;
      var result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    return lList;
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

      epC.pitsStops.asMap().forEach((index, emp) async {
        print('emp$index: $emp');
        if (emp['checkinLat'] != null || emp['checkinLat'] != '' || emp['checkinLng'] != null || emp['checkinLng'] != '') {
          _markers.add(
            Marker(
              markerId: MarkerId(
                emp['pitstopId'].toString(),
              ),
              // icon: pinTaskIcon,
              position: LatLng(
                double.parse(emp['checkinLat']),
                double.parse(emp['checkinLng']),
              ),
              infoWindow: InfoWindow(
                title: 'Pit Stop ID: ${emp['pitstopId'].toString()}',
                snippet: emp['address'],
              ),
            ),
          );

          if (index > 0) {
            _updatedMapPosition = LatLng(
              double.parse(epC.pitsStops[index - 1]['checkinLat']),
              double.parse(epC.pitsStops[index - 1]['checkinLng']),
            );

            String route = await _locationPath.getRouteCoordinates(
              _updatedMapPosition,
              LatLng(
                double.parse(emp['checkinLat']),
                double.parse(emp['checkinLng']),
              ),
            );

            _polyline.add(
              Polyline(
                polylineId: PolylineId(emp['pitstopId'].toString()),
                visible: true,
                //latlng is List<LatLng>
                points: _convertToLatLng(
                  _decodePoly(
                    route,
                  ),
                ),
                width: 5,
                color: Theme.of(context).primaryColor,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
              ),
            );
          }
        }
      });
    });
    Timer(Duration(seconds: 1), () {
      // controller.showMarkerInfoWindow(MarkerId(epC.locations.first['empId']));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().innerScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Visit Plan Tracking',
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (epC.isLoadingTimeline.value) {
            return Column();
          } else if (epC.pitsStops.isNullOrBlank) {
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
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15.0,
                  15.0,
                  15.0,
                  55.0,
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: GoogleMap(
                        buildingsEnabled: true,
                        myLocationEnabled: true,
                        mapToolbarEnabled: true,
                        polylines: _polyline,
                        markers: _markers,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(epC.pitsStops.first['checkinLat']),
                            double.parse(epC.pitsStops.first['checkinLng']),
                          ),
                          zoom: 13,
                        ),
                        mapType: MapType.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 25.0,
                  bottom: 15.0,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Total Distance: ${epC.totalDistance.toStringAsFixed(2)} KM',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
