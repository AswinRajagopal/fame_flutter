import 'dart:async';

import 'package:flutter/services.dart';

import '../connection/remote_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/employee_report_controller.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LocationReportDetail extends StatefulWidget {
  @override
  _LocationReportDetailState createState() => _LocationReportDetailState();
}

class _LocationReportDetailState extends State<LocationReportDetail> {
  final EmployeeReportController epC = Get.put(EmployeeReportController());
  GoogleMapController controller;
  final Set<Marker> _markers = {};
  int live = 0,total =0;

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
        var time = DateTime.parse(emp['timeStamp']);
        DateTime now = new DateTime.now();;
        total++;
        markIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(24, 24)), 'assets/images/siteposted_nolive.png');
        if(time.millisecondsSinceEpoch > (now.millisecondsSinceEpoch - (3600*1000))){
          live++;
          markIcon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(24, 24)), 'assets/images/siteposted.png');
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
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Stack (children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child :Align(
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
                )),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child : Container(
                      padding: EdgeInsets.all(6),
                      color: Colors.grey[400],
                      child: Text('Live '+live.toString()+'/'+total.toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                    )
                  )
              ]),
            ),
          );
        }),
      ),
    );
  }
}
