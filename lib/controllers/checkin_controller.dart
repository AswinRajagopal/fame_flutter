import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/locationpath.dart';
import '../connection/remote_services.dart';
import '../views/dashboard_page.dart';

class CheckinController extends GetxController {
  ProgressDialog pr;
  var checkinResponse;
  var todayString = (DateFormat.yMd().add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;

  @override
  void onInit() {
    updateTime();
    print('locationFetchTimeout: ${jsonDecode(RemoteServices().box.get('appFeature'))}');
    if (jsonDecode(RemoteServices().box.get('appFeature'))['locFetchTimeout']) latlngTimeout();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      todayString.value = DateFormat.yMd().add_jm().format(DateTime.now()).toString();
    });
  }

  Future latlngTimeout() {
    Timer(const Duration(seconds: 10), () => (currentAddress.value == 'Fetching your location...') ? currentAddress.value = 'Please checkin' : '');
    return null;
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).then((Position position) {
      currentPosition = position;
      // print(position.floor);
      // print(position.heading);
      // print(position.accuracy);
      // print(position.latitude);
      // print(position.longitude);
      getAddressFromLatLng();

      // ignore: unnecessary_lambdas
    }).catchError((e) {
      print(e);
    });
  }

  void getAddressFromLatLng() async {
    try {
      var placemark = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      var first;
      if (placemark != null) {
        first = placemark.first;
      }
      print(first);

      var maxDistance = RemoteServices().box.get('maxDist');
      var distance;
      if(maxDistance!='0') {
        distance = await Locationpath().getDistance(
            LatLng(currentPosition.latitude, currentPosition.longitude),
            LatLng(double.parse(RemoteServices().box.get('clientLat')),
                double.parse(RemoteServices().box.get('clientLng'))));
      }
      if (maxDistance == '0' || int.parse(maxDistance) > (distance * 1000).round()) {
        if (first != null) {
          currentAddress.value = '${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
        } else {
          currentAddress.value = 'Please checkin';
        }
      } else {
        await showDialog(
          context: Get.context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Cannot Checkin'),
              content: Text(
                'Too long from Site Location ',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Get.offAll(DashboardPage());
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      }
      // print(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<bool> uploadImage(File imageFile) async {
    try {
      await pr.show();
      checkinResponse = await RemoteServices().checkinProcess(imageFile);
      if (checkinResponse != null) {
        await pr.hide();
        print('checkinResponse valid: ${checkinResponse.success}');
        if (checkinResponse.success) {
          var resDecode = jsonDecode(checkinResponse.response);
          print('checkinResponse: $resDecode');
          if (resDecode['msg'] == 'Please register before using.') {
            Get.snackbar(
              null,
              resDecode['msg'],
              colorText: Colors.white,
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 18.0,
              ),
              borderRadius: 5.0,
            );
            return false;
          } else if (!resDecode['face_found']) {
            Get.snackbar(
              null,
              'Face not detected. Please take a picture again',
              colorText: Colors.white,
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 18.0,
              ),
              borderRadius: 5.0,
            );
            return false;
          } else if (resDecode['n_faces'] > 1) {
            Get.snackbar(
              null,
              'More then one face detected.',
              colorText: Colors.white,
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 18.0,
              ),
              borderRadius: 5.0,
            );
            return false;
          } else if (resDecode['0']['clientID'].toString().toLowerCase() != RemoteServices().box.get('empid').toString().toLowerCase()) {
            Get.snackbar(
              null,
              "Face doesn't match.",
              colorText: Colors.white,
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 18.0,
              ),
              borderRadius: 5.0,
            );
            return false;
          } else {
            // call checkin api
            // print(currentAddress.value);
            // print(currentPosition.latitude);
            // print(currentPosition.longitude);
            var checkin = await RemoteServices().checkin(
              (currentPosition != null) ? currentPosition.latitude : '0.0',
              (currentPosition != null) ? currentPosition.longitude : '0.0',
              currentAddress.value,
            );
            // print(checkin);
            if (checkin != null && checkin['success']) {
              // RemoteServices().saveLocationLog();
              /* await Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.bestForNavigation,
              ).listen((Position position) async {});*/
              if (RemoteServices().box.get('gpsTracking') != null && RemoteServices().box.get('gpsTracking')) {
                if (Platform.isAndroid) {
                  var methodChannel = MethodChannel('in.androidfame.attendance');
                  var result = await methodChannel.invokeMethod('startService', {'empId': RemoteServices().box.get('empid'), 'companyId': RemoteServices().box.get('companyid')});
                  print('result: $result');
                } else if (Platform.isIOS) {
                  // await LocationUpdates.initiateLocationUpdates(Get.context);
                }
              }
              return true;
            } else {
              var msg = 'Something went wrong! Please try again later';
              if (checkin['message'] != null) {
                msg = checkin['message'];
              }
              Get.snackbar(
                null,
                msg,
                colorText: Colors.white,
                backgroundColor: Colors.black87,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 18.0,
                ),
                borderRadius: 5.0,
              );
              return false;
            }
          }
        } else {
          Get.snackbar(
            null,
            'Something went wrong! Please try again later',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
          return false;
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
      return false;
    }
  }

  Future<bool> justCheckin() async {
    await pr.show();

    var checkin = await RemoteServices().checkin(
      (currentPosition != null) ? currentPosition.latitude : '0.0',
      (currentPosition != null) ? currentPosition.longitude : '0.0',
      currentAddress.value,
    );
    // print(checkin);
    if (checkin != null && checkin['success']) {
      await pr.hide();
      return true;
    } else {
      await pr.hide();
      var msg = 'Something went wrong! Please try again later';
      if (checkin['message'] != null) {
        msg = checkin['message'];
      }
      Get.snackbar(
        null,
        msg,
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
      return false;
    }
  }
}
