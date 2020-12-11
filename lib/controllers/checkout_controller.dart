import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CheckoutController extends GetxController {
  ProgressDialog pr;
  var checkoutResponse;
  var todayString =
      (DateFormat().add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;

  @override
  void onInit() {
    updateTime();
    super.onInit();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value =
          DateFormat().add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
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
      var first = placemark.first;
      currentAddress.value =
          '${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
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
          if (!resDecode['face_found']) {
            Get.snackbar(
              'Error',
              'Face not detected. Please take a picture again',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else if (resDecode['n_faces'] > 1) {
            Get.snackbar(
              'Error',
              'More then one face detected.',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else if (resDecode['0']['clientID'].toString().toLowerCase() !=
              RemoteServices().box.get('empid').toString().toLowerCase()) {
            Get.snackbar(
              'Error',
              "Face doesn't match.",
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else {
            // call checkin api
            // print(currentAddress.value);
            // print(currentPosition.latitude);
            // print(currentPosition.longitude);
            var checkin = await RemoteServices().checkout(
              currentPosition.latitude,
              currentPosition.longitude,
              currentAddress.value,
            );
            // print(checkin);
            if (checkin != null && checkin['success']) {
              return true;
            } else {
              Get.snackbar(
                'Error',
                'Something went wrong! Please try again later',
                colorText: Colors.white,
                backgroundColor: Colors.red,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
              );
              return false;
            }
          }
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong! Please try again later',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
          );
          return false;
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      Get.snackbar(
        'Error',
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
      return false;
    } finally {
      await pr.hide();
      // return checkoutResponse.success;
    }
  }
}
