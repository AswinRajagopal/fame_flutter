import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';

class MyPinController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List pitsStops = [].obs;
  final List activityList = [].obs;
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

  void getActivityList() async {
    try {
      // await pr.show();
      var getActivityRes = await RemoteServices().getActivityList();

      if (getActivityRes != null) {
        // print('getClientRes valid: $getClientRes');
        if (getActivityRes['success'] && getActivityRes['activityList'] != null) {
          activityList.addAll(getActivityRes['activityList']);
          // print('clientsList: $clientList');
        }
      }
      // await pr.hide();
    } catch (e) {
      print(e);
      // await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
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
            return true;
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
}
