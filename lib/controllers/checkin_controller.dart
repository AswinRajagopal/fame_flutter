import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CheckinController extends GetxController {
  ProgressDialog pr;
  var checkinResponse;
  var todayString = (DateFormat().add_jm().format(DateTime.now()).toString()).obs;
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
      todayString.value = DateFormat().add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
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
      var first = placemark.first;
      print(first);
      currentAddress.value = '${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
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
              currentPosition.latitude,
              currentPosition.longitude,
              currentAddress.value,
            );
            // print(checkin);
            if (checkin != null && checkin['success']) {
              // RemoteServices().saveLocationLog();
              await Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.bestForNavigation,
              ).listen((Position position) async {});
              if (Platform.isAndroid) {
                var methodChannel = MethodChannel('in.androidfame.attendance');
                var result = await methodChannel.invokeMethod('startService');
                print('result: $result');
              } else if (Platform.isIOS) {
                // await LocationUpdates.initiateLocationUpdates(Get.context);
              }
              return true;
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
      currentPosition.latitude,
      currentPosition.longitude,
      currentAddress.value,
    );
    // print(checkin);
    if (checkin != null && checkin['success']) {
      await pr.hide();
      return true;
    } else {
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
}
