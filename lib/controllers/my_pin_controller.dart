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

class MyPinController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List pitsStops = [].obs;
  var todayString = (DateFormat().add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;
  var pinRes;
  var dis = 'Finding distance from site...'.obs;

  @override
  void onInit() {
    // getEmprPlan();
    updateTime();
    super.onInit();
  }

  void init() {
    print('init custom');
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat().add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation() {
    currentAddress.value = 'Fetching your location...';
    dis.value = 'Finding distance from site...';
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      currentPosition = position;
      // dis.value = Geolocator.distanceBetween(double.parse(pits['lat']), double.parse(pits['lng']), position.latitude, position.longitude).toStringAsFixed(2) + ' meter';
      // print('dis: ${dis.value}');
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
      // print(first);
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
      pinRes = await RemoteServices().checkinProcess(imageFile);
      if (pinRes != null) {
        await pr.hide();
        print('pinRes valid: ${pinRes.success}');
        if (pinRes.success) {
          var resDecode = jsonDecode(pinRes.response);
          if (!resDecode['face_found']) {
            Get.snackbar(
              'Error',
              'Face not detected. Please take a picture again',
              colorText: Colors.white,
              backgroundColor: Colors.black87,
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
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else if (resDecode['0']['clientID'].toString().toLowerCase() != RemoteServices().box.get('empid').toString().toLowerCase()) {
            Get.snackbar(
              'Error',
              "Face doesn't match.",
              colorText: Colors.white,
              backgroundColor: Colors.black87,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else {
            return true;
          }
        } else {
          Get.snackbar(
            'Error',
            'Something went wrong! Please try again later',
            colorText: Colors.white,
backgroundColor: Colors.black87,
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
backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
      );
      return false;
    }
  }
}
