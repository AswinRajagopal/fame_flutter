import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fame/connection/locationpath.dart';
import 'package:fame/views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';

class CheckoutController extends GetxController {
  ProgressDialog pr;
  var checkoutResponse;
  var todayString = (DateFormat.yMd().add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;

  @override
  void onInit() {
    updateTime();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat.yMd().add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      currentPosition = position;
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
      var distance = await Locationpath().getDistance(LatLng(currentPosition.latitude, currentPosition.longitude), LatLng(double.parse(RemoteServices().box.get('clientLat')), double.parse(RemoteServices().box.get('clientLng'))));
      var maxDistance = RemoteServices().box.get('maxDist');
      if (maxDistance == '0' || int.parse(maxDistance) > (distance * 1000).round()) {
        if (first != null) {
          currentAddress.value = 'lat: ${currentPosition.latitude}\nlng: ${currentPosition.longitude}\n${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
        } else {
          currentAddress.value = 'Please checkout';
        }
      } else {
        await showDialog(
          context: Get.context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Cannot Checkout'),
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
      checkoutResponse = await RemoteServices().checkinProcess(imageFile);
      if (checkoutResponse != null) {
        await pr.hide();
        print('checkoutResponse valid: ${checkoutResponse.success}');
        if (checkoutResponse.success) {
          var resDecode = jsonDecode(checkoutResponse.response);
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
            var checkout = await RemoteServices().checkout(
              (currentPosition != null) ? currentPosition.latitude : '0.0',
              (currentPosition != null) ? currentPosition.longitude : '0.0',
              currentAddress.value,
            );
            // print(checkin);
            if (checkout != null && checkout['success']) {
              // await RemoteServices().saveLocationLog(cancel: true);
              if (Platform.isAndroid) {
                var methodChannel = MethodChannel('in.androidfame.attendance');
                var result = await methodChannel.invokeMethod('stopService');
                print('result: $result');
              } else if (Platform.isIOS) {
                // await LocationUpdates.stopLocationUpdates(Get.context);
              }
              return true;
            } else {
              var msg = 'Something went wrong! Please try again later';
              if (checkout['message'] != null) {
                msg = checkout['message'];
                showDialog(
                  context: Get.context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      msg,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Ok'),
                      )
                    ],
                  ),
                );
              } else {
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
              }
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

  Future<bool> justCheckout() async {
    await pr.show();
    var checkout = await RemoteServices().checkout(
      (currentPosition != null) ? currentPosition.latitude : '0.0',
      (currentPosition != null) ? currentPosition.longitude : '0.0',
      currentAddress.value,
    );
    // print(checkin);
    if (checkout != null && checkout['success']) {
      await pr.hide();
      var methodChannel = MethodChannel('in.androidfame.attendance');
      var result = await methodChannel.invokeMethod('stopService');
      print(result);
      return true;
    } else {
      await pr.hide();
      var msg = 'Something went wrong! Please try again later';
      if (checkout['message'] != null) {
        msg = checkout['message'];
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
